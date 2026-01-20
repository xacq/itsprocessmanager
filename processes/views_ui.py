# processes/views_ui.py
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic import TemplateView, ListView, DetailView, FormView
from django.shortcuts import redirect, get_object_or_404
from django.urls import reverse
from django.utils import timezone
from django.contrib import messages

from processes.services import instantiate_subprocess

from .models import (
    SubProcessInstance,
    OperationInstance,
    Notification,
    SubProcessTemplate,
    User,
    Document,
)
from .forms import OperationCompleteForm, DocumentUploadForm, SubProcessStartForm

class DashboardView(LoginRequiredMixin, TemplateView):
    template_name = "dashboard.html"

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        user = self.request.user

        # notificaciones
        ctx["unread_count"] = user.notifications.filter(is_read=False).count()

        # asignaciones propias
        qs = user.operationassignment_set.select_related("operation_instance")

        ctx["completed_count"] = qs.filter(status="COMPLETED").count()
        ctx["pending_count"]   = qs.filter(status="PENDING").count()
        ctx["late_count"]      = qs.filter(operation_instance__state="LATE").count()

        return ctx

# ---------- Instancias ----------
class InstanceListView(LoginRequiredMixin, ListView):
    model = SubProcessInstance
    template_name = "instances/list.html"
    paginate_by = 10

    def get_queryset(self):
        qs = super().get_queryset().select_related("template", "career", "period")
        if self.request.user.role == User.Role.ADMIN:
            return qs
        if self.request.user.role == "MANAGER":
            qs = qs.filter(template__process__manager=self.request.user)
        else:
            qs = qs.filter(operation_instances__assignments__user=self.request.user).distinct()

        state = self.request.GET.get("state")
        if state:
            qs = qs.filter(operation_instances__state=state).distinct()
        return qs


class SubProcessTemplateListView(LoginRequiredMixin, ListView):
    model = SubProcessTemplate
    template_name = "templates/list.html"

    def dispatch(self, request, *args, **kwargs):
        if request.user.role != User.Role.MANAGER:
            messages.error(request, "Solo los gestores de procesos pueden iniciar subprocesos.")
            return redirect("dashboard")
        return super().dispatch(request, *args, **kwargs)

    def get_queryset(self):
        return SubProcessTemplate.objects.filter(process__manager=self.request.user)


class OperationDetailView(LoginRequiredMixin, FormView, DetailView):
    model = OperationInstance
    template_name = "operations/detail.html"
    form_class = OperationCompleteForm
    queryset = OperationInstance.objects.all()

    def get_queryset(self):
        qs = super().get_queryset().select_related(
            "subprocess_instance__template__process__manager",
            "operation_template",
        ).prefetch_related("assignments__user", "documents")
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return qs
        if user.role == User.Role.MANAGER:
            return qs.filter(subprocess_instance__template__process__manager=user)
        return qs.filter(assignments__user=user).distinct()

    def _previous_incomplete(self):
        return OperationInstance.objects.filter(
            subprocess_instance=self.object.subprocess_instance,
            order__lt=self.object.order,
        ).exclude(state="COMPLETED").exists()

    @property
    def previous_pending(self):
        return getattr(self, "_prev_pending_cache", False)

    def get_object(self, queryset=None):
        obj = super().get_object(queryset)
        # calcula una vez y guarda
        self._prev_pending_cache = OperationInstance.objects.filter(
            subprocess_instance=obj.subprocess_instance,
            order__lt=obj.order,
        ).exclude(state="COMPLETED").exists()
        return obj

    # ----------  Helpers de visibilidad ----------
    def get_form_kwargs(self):
        """Solo muestra el formulario si el usuario tiene asignación pendiente."""
        kwargs = super().get_form_kwargs()
        self.object = self.get_object()
        kwargs["initial"] = {"confirm": True}
        return kwargs

    @property
    def form_visible(self):
        if self.previous_pending:
            return False
        return self.object.assignments.filter(user=self.request.user, status="PENDING").exists()

    @property
    def upload_visible(self):
        t = self.object.operation_template
        return t.type in ("DOC_REQUEST", "REVIEW") and not self.previous_pending

    @property
    def approve_visible(self):
        t = self.object.operation_template
        return (
            t.requires_approval
            and self.request.user.role == User.Role.MANAGER
            and self.object.state != "COMPLETED"
            and not self.previous_pending
        )

    # ----------  Context ----------
    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx["upload_form"] = DocumentUploadForm() if self.upload_visible else None
        ctx["form_visible"] = self.form_visible
        ctx["upload_visible"] = self.upload_visible
        ctx["approve_visible"] = self.approve_visible
        ctx["blocked_by_previous"] = self.previous_pending
        return ctx

    # ----------  POST ----------
    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        self._prev_pending_cache = self._previous_incomplete()

        # ---------- 1) Eliminar documento ----------
        doc_id = request.POST.get("delete_doc")
        if doc_id and request.user.role == User.Role.MANAGER:
            from processes.models import Document
            Document.objects.filter(id=doc_id, operation_instance=self.object).delete()
            messages.success(request, "Documento eliminado.")
            return redirect(request.path)

        # ---------- 2) Aprobar operación ----------
        if request.POST.get("approve") == "1" and self.approve_visible:
            self.object.state = "COMPLETED"
            self.object.save(update_fields=["state"])
            messages.success(request, "Operación aprobada.")
            return redirect(request.path)

        # ---------- 3) Subir documento ----------
        if "file" in request.FILES and self.upload_visible:
            form = DocumentUploadForm(request.POST, request.FILES)
            if form.is_valid():
                doc = form.save(commit=False)
                doc.operation_instance = self.object
                doc.uploaded_by = request.user
                doc.save()
                messages.success(request, "Documento cargado.")
            return redirect(request.path)

        # ---------- 4) Completar asignación ----------
        if self.form_visible:
            return super().post(request, *args, **kwargs)

        messages.error(request, "No puedes realizar esta acción.")
        return redirect(request.path)

    # ----------  Completar ----------
    def form_valid(self, form):
        self.object.assignments.filter(user=self.request.user, status="PENDING").update(
            status="COMPLETED", completed_at=timezone.now()
        )
        messages.success(self.request, "Has completado la operación.")
        return super().form_valid(form)

    def get_success_url(self):
        return reverse("operation-detail", args=[self.object.id])


# ---------- Notificaciones ----------
class NotificationListView(LoginRequiredMixin, ListView):
    model = Notification
    template_name = "notifications/list.html"
    paginate_by = 15

    def get_queryset(self):
        return Notification.objects.filter(user=self.request.user)
    
    def post(self, request, *args, **kwargs):
        notif_id = request.POST.get("notif_id")
        if notif_id:                       # evita None
            Notification.objects.filter(id=notif_id, user=request.user)\
                                  .update(is_read=True)
        return redirect(request.path)      # recarga la página
    

class SubProcessTemplateStartView(LoginRequiredMixin, FormView):
    template_name = "templates/start.html"
    form_class = SubProcessStartForm  # carrera + periodo
    def form_valid(self, form):
        tpl = get_object_or_404(SubProcessTemplate, pk=self.kwargs["pk"])
        spi = instantiate_subprocess(tpl, form.cleaned_data["career"],
                                          form.cleaned_data["period"],
                                          self.request.user)
        return redirect("instance-detail", spi.pk)
    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx["template_obj"] = get_object_or_404(SubProcessTemplate, pk=self.kwargs["pk"])
        return ctx


class StartView(LoginRequiredMixin, FormView):
    template_name = "templates/start.html"
    form_class = SubProcessStartForm

    def dispatch(self, request, *args, **kwargs):
        if request.user.role != User.Role.MANAGER:
            messages.error(request, "Solo los gestores de procesos pueden iniciar subprocesos.")
            return redirect("dashboard")
        return super().dispatch(request, *args, **kwargs)

    def form_valid(self, form):
        tpl = get_object_or_404(SubProcessTemplate, pk=self.kwargs["pk"])
        if tpl.process.manager != self.request.user:
            messages.error(self.request, "No puedes iniciar subprocesos que no gestionas.")
            return redirect("dashboard")
        spi = instantiate_subprocess(
            tpl,
            form.cleaned_data["career"],
            form.cleaned_data["period"],
            self.request.user,
        )
        messages.success(self.request, f"Subproceso #{spi.pk} creado.")
        return redirect("instance-detail", spi.pk)
    
    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx["template_obj"] = get_object_or_404(SubProcessTemplate, pk=self.kwargs["pk"])
        return ctx
    

class InstanceDetailView(LoginRequiredMixin, DetailView):
    model = SubProcessInstance
    template_name = "instances/detail.html"

    def get_queryset(self):
        qs = super().get_queryset().prefetch_related(
            "operation_instances__assignments",
            "operation_instances__documents",
        )

        user = self.request.user
        # 1) Admin ve todo
        if user.role == User.Role.ADMIN:
            return qs
        # 2) Gestor ve los suyos
        if user.role == User.Role.MANAGER:
            return qs.filter(template__process__manager=user)
        # 3) Participante ve donde está asignado
        return qs.filter(operation_instances__assignments__user=user).distinct()

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        user = self.request.user
        ops = self.object.operation_instances.all()
        if user.role == User.Role.PARTICIPANT:
            ops = ops.filter(assignments__user=user).distinct()
        ctx["visible_operations"] = ops
        return ctx


class ManagerDocumentListView(LoginRequiredMixin, ListView):
    model = Document
    template_name = "documents/list.html"
    paginate_by = 20

    def dispatch(self, request, *args, **kwargs):
        if request.user.role != User.Role.MANAGER:
            messages.error(request, "Solo los gestores pueden ver documentos de sus subprocesos.")
            return redirect("dashboard")
        return super().dispatch(request, *args, **kwargs)

    def get_queryset(self):
        return Document.objects.select_related(
            "operation_instance__subprocess_instance__template__process__manager",
            "operation_instance__operation_template",
            "uploaded_by",
        ).filter(
            operation_instance__subprocess_instance__template__process__manager=self.request.user
        )
