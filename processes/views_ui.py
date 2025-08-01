# processes/views_ui.py
from django.contrib.auth.mixins import LoginRequiredMixin
from django.views.generic import TemplateView, ListView, DetailView, FormView
from django.shortcuts import redirect, get_object_or_404
from django.urls import reverse
from django.utils import timezone
from django.contrib import messages

from processes.services import instantiate_subprocess

from .models import SubProcessInstance, OperationInstance, Notification, SubProcessTemplate, User
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


class OperationDetailView(LoginRequiredMixin, FormView, DetailView):
    model = OperationInstance
    template_name = "operations/detail.html"
    form_class = OperationCompleteForm

    # ----------  Helpers de visibilidad ----------
    def get_form_kwargs(self):
        """Solo muestra el formulario si el usuario tiene asignación pendiente."""
        kwargs = super().get_form_kwargs()
        self.object = self.get_object()
        kwargs["initial"] = {"confirm": True}
        return kwargs

    @property
    def form_visible(self):
        return self.object.assignments.filter(user=self.request.user, status="PENDING").exists()

    @property
    def upload_visible(self):
        t = self.object.operation_template
        return t.type in ("DOC_REQUEST", "REVIEW")

    @property
    def approve_visible(self):
        t = self.object.operation_template
        return t.requires_approval and self.request.user.role == User.Role.MANAGER and self.object.state != "COMPLETED"

    # ----------  Context ----------
    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx["upload_form"] = DocumentUploadForm() if self.upload_visible else None
        ctx["form_visible"] = self.form_visible
        ctx["upload_visible"] = self.upload_visible
        ctx["approve_visible"] = self.approve_visible
        return ctx

    # ----------  POST ----------
    def post(self, request, *args, **kwargs):
        self.object = self.get_object()

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


class StartView(LoginRequiredMixin, FormView):
    template_name = "templates/start.html"
    form_class = SubProcessStartForm

    def form_valid(self, form):
        tpl = get_object_or_404(SubProcessTemplate, pk=self.kwargs["pk"])
        spi = instantiate_subprocess(
            tpl,
            form.cleaned_data["career"],
            form.cleaned_data["period"],
            self.request.user,
        )
        messages.success(self.request, f"Subproceso #{spi.pk} creado.")
        return redirect("instance-detail", spi.pk)
    

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
