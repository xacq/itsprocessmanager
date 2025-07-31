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


# ---------- Operaciones ----------
class OperationDetailView(LoginRequiredMixin, FormView, DetailView):
    model = OperationInstance
    template_name = "operations/detail.html"
    form_class = OperationCompleteForm

    def get_success_url(self):
        return reverse("instance-detail", args=[self.object.subprocess_instance_id])

    def form_valid(self, form):
        # Completar asignaciones del usuario
        self.object = self.get_object()
        self.object.assignments.filter(user=self.request.user, status="PENDING").update(
            status="COMPLETED", completed_at=timezone.now()
        )
        return super().form_valid(form)

    def get_context_data(self, **kwargs):
        ctx = super().get_context_data(**kwargs)
        ctx["upload_form"] = DocumentUploadForm()
        return ctx

    def post(self, request, *args, **kwargs):
        self.object = self.get_object()
        if "file" in request.FILES:
            # carga de documento
            form = DocumentUploadForm(request.POST, request.FILES)
            if form.is_valid():
                doc = form.save(commit=False)
                doc.operation_instance = self.object
                doc.uploaded_by = request.user
                doc.save()
            return redirect(request.path)
        # confirmación de operación completada
        return super().post(request, *args, **kwargs)


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
