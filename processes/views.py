from rest_framework import viewsets, mixins, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.core.exceptions import ValidationError
from django.shortcuts import get_object_or_404

from .models import *
from .serializers import *
from .permissions import IsManager
from .services import (
    approve_operation,
    attach_document,
    complete_user_assignments,
    instantiate_subprocess,
    reject_operation_documents,
)

# ------ Catálogos (solo lectura pública) ------
class InstitutionView(viewsets.ReadOnlyModelViewSet):
    queryset = ProcessInstitution.objects.all()
    serializer_class = ProcessInstitutionSerializer


class MacroProcessView(viewsets.ReadOnlyModelViewSet):
    queryset = MacroProcess.objects.all()
    serializer_class = MacroProcessSerializer

    def get_queryset(self):
        user = self.request.user
        if user.is_authenticated and user.role == "MANAGER":
            return MacroProcess.objects.filter(process__manager=user).distinct()
        return MacroProcess.objects.all()


class ProcessView(viewsets.ReadOnlyModelViewSet):
    queryset = Process.objects.all()
    serializer_class = ProcessSerializer

    def get_queryset(self):
        user = self.request.user
        if user.is_authenticated and user.role == "MANAGER":
            return Process.objects.filter(manager=user)
        return Process.objects.all()


# ------ Plantillas (solo Gestor) ------
class SubProcessTemplateView(viewsets.ModelViewSet):
    queryset = SubProcessTemplate.objects.all()
    serializer_class = SubProcessTemplateSerializer
    permission_classes = [IsManager]

    def get_queryset(self):
        user = self.request.user
        if user.is_authenticated and user.role == "MANAGER":
            return SubProcessTemplate.objects.filter(process__manager=user)
        return SubProcessTemplate.objects.all()


# ------ Instancias ------
class SubProcessInstanceView(viewsets.ReadOnlyModelViewSet):
    queryset = SubProcessInstance.objects.select_related("template", "career", "period")
    serializer_class = SubProcessInstanceSerializer

    @action(detail=False, methods=["post"], permission_classes=[IsManager])
    def instantiate(self, request):
        """
        Body: {template_id, career_id, period_id}
        """
        tpl = get_object_or_404(SubProcessTemplate, pk=request.data.get("template_id"))
        if tpl.process.manager_id != request.user.id:
            return Response(status=status.HTTP_403_FORBIDDEN)
        career = get_object_or_404(Career, pk=request.data.get("career_id"))
        period = get_object_or_404(AcademicPeriod, pk=request.data.get("period_id"))
        participant_ids = request.data.get("participant_ids", []) or []
        if isinstance(participant_ids, str):
            participant_ids = [pk for pk in participant_ids.split(",") if pk]
        elif isinstance(participant_ids, int):
            participant_ids = [participant_ids]
        participant_ids = list(participant_ids)
        participants = list(User.objects.filter(id__in=participant_ids, role=User.Role.PARTICIPANT))
        if len(participants) != len(set(participant_ids)):
            return Response(
                {"participant_ids": ["Todos los participantes deben existir y tener rol PARTICIPANT."]},
                status=status.HTTP_400_BAD_REQUEST,
            )
        try:
            spi = instantiate_subprocess(tpl, career, period, request.user, participants=participants)
        except ValidationError as exc:
            return Response({"detail": exc.messages}, status=status.HTTP_400_BAD_REQUEST)
        return Response(SubProcessInstanceSerializer(spi).data, status=status.HTTP_201_CREATED)


class OperationInstanceView(viewsets.GenericViewSet,
                            mixins.RetrieveModelMixin,
                            mixins.UpdateModelMixin):
    queryset = OperationInstance.objects.all()
    serializer_class = OperationInstanceSerializer

    def get_queryset(self):
        qs = super().get_queryset().select_related(
            "subprocess_instance__template__process__manager",
            "operation_template",
        )
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return qs
        if user.role == User.Role.MANAGER:
            return qs.filter(subprocess_instance__template__process__manager=user)
        return qs.filter(assignments__user=user).distinct()

    @action(detail=True, methods=["post"])
    def complete(self, request, pk=None):
        operation_instance = self.get_object()
        completed = complete_user_assignments(operation_instance, request.user)
        return Response({"completed": completed})

    @action(detail=True, methods=["post"])
    def approve(self, request, pk=None):
        operation_instance = self.get_object()
        if request.user.role not in (User.Role.ADMIN, User.Role.MANAGER):
            return Response(status=status.HTTP_403_FORBIDDEN)
        approve_operation(operation_instance, request.user)
        return Response({"approved": True})

    @action(detail=True, methods=["post"])
    def reject(self, request, pk=None):
        operation_instance = self.get_object()
        if request.user.role not in (User.Role.ADMIN, User.Role.MANAGER):
            return Response(status=status.HTTP_403_FORBIDDEN)
        try:
            rejected = reject_operation_documents(
                operation_instance,
                request.user,
                request.data.get("comment", ""),
            )
        except ValueError as exc:
            return Response({"detail": str(exc)}, status=status.HTTP_400_BAD_REQUEST)
        return Response({"rejected": len(rejected)})


# ------ Documentos ------
class DocumentView(viewsets.ModelViewSet):
    queryset = Document.objects.select_related(
        "operation_instance__subprocess_instance__template__process__manager",
        "operation_instance__operation_template",
        "uploaded_by",
    )
    serializer_class = DocumentSerializer
    http_method_names = ["get", "post", "delete"]

    def get_queryset(self):
        qs = super().get_queryset()
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return qs
        if user.role == User.Role.MANAGER:
            return qs.filter(
                operation_instance__subprocess_instance__template__process__manager=user
            )
        return qs.filter(operation_instance__assignments__user=user).distinct()

    def create(self, request, *args, **kwargs):
        operation_instance = get_object_or_404(
            OperationInstance,
            pk=request.data.get("operation_instance"),
        )
        if not self._can_access_operation(operation_instance, request.user):
            return Response(status=status.HTTP_403_FORBIDDEN)
        if "file" not in request.FILES:
            return Response({"file": ["Este campo es requerido."]}, status=status.HTTP_400_BAD_REQUEST)
        try:
            document = attach_document(operation_instance, request.user, request.FILES["file"])
        except ValueError as exc:
            return Response({"detail": str(exc)}, status=status.HTTP_400_BAD_REQUEST)
        return Response(DocumentSerializer(document).data, status=status.HTTP_201_CREATED)

    def _can_access_operation(self, operation_instance, user):
        if user.role == User.Role.ADMIN:
            return True
        if user.role == User.Role.MANAGER:
            return operation_instance.subprocess_instance.template.process.manager_id == user.id
        return operation_instance.assignments.filter(user=user).exists()


# ------ Notificaciones ------
class NotificationView(viewsets.ReadOnlyModelViewSet):
    serializer_class = NotificationSerializer

    def get_queryset(self):
        return Notification.objects.filter(user=self.request.user)
