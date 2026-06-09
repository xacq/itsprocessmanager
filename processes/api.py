from django.core.exceptions import ValidationError
from django.shortcuts import get_object_or_404
from rest_framework import permissions, status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import (
    AcademicPeriod,
    Career,
    OperationInstance,
    SubProcessInstance,
    SubProcessTemplate,
    User,
)
from .permissions import IsManager
from .serializers import OperationInstanceSerializer, SubProcessInstanceSerializer
from .services import complete_user_assignments, instantiate_subprocess


class SPIView(viewsets.ReadOnlyModelViewSet):
    queryset = SubProcessInstance.objects.all()
    serializer_class = SubProcessInstanceSerializer
    permission_classes = [permissions.IsAuthenticated]


class OIView(viewsets.ReadOnlyModelViewSet):
    queryset = OperationInstance.objects.all()
    serializer_class = OperationInstanceSerializer
    permission_classes = [permissions.IsAuthenticated]


class IsManagerOrReadOnly(permissions.BasePermission):
    """Gestor puede POST/PUT, resto solo lectura."""

    def has_permission(self, request, view):
        if request.method in permissions.SAFE_METHODS:
            return True
        return request.user.role == User.Role.MANAGER


class SubProcessInstanceViewSet(viewsets.ReadOnlyModelViewSet):
    """GET /api/subprocess-instances/ — lista / detalle de SPI."""

    queryset = SubProcessInstance.objects.select_related("template", "career", "period")
    serializer_class = SubProcessInstanceSerializer

    def get_queryset(self):
        user = self.request.user
        if user.role == User.Role.MANAGER:
            return self.queryset.filter(template__process__manager=user)
        if user.role == User.Role.PARTICIPANT:
            return self.queryset.filter(operation_instances__assignments__user=user).distinct()
        return self.queryset  # ADMIN

    @action(detail=False, methods=["post"], permission_classes=[IsManager])
    def instantiate(self, request):
        """
        Body: {template_id, career_id, period_id, participant_ids: [id, ...]}
        """
        template = get_object_or_404(SubProcessTemplate, pk=request.data.get("template_id"))
        if template.process.manager_id != request.user.id:
            return Response(status=status.HTTP_403_FORBIDDEN)

        career = get_object_or_404(Career, pk=request.data.get("career_id"))
        period = get_object_or_404(AcademicPeriod, pk=request.data.get("period_id"))
        participant_ids = request.data.get("participant_ids", []) or []
        if isinstance(participant_ids, str):
            participant_ids = [pk for pk in participant_ids.split(",") if pk]
        elif isinstance(participant_ids, int):
            participant_ids = [participant_ids]
        participant_ids = list(participant_ids)
        participants = list(
            User.objects.filter(id__in=participant_ids, role=User.Role.PARTICIPANT)
        )
        if len(participants) != len(set(participant_ids)):
            return Response(
                {"participant_ids": ["Todos los participantes deben existir y tener rol PARTICIPANT."]},
                status=status.HTTP_400_BAD_REQUEST,
            )

        try:
            subprocess_instance = instantiate_subprocess(
                template,
                career,
                period,
                request.user,
                participants=participants,
            )
        except ValidationError as exc:
            return Response({"detail": exc.messages}, status=status.HTTP_400_BAD_REQUEST)

        return Response(
            SubProcessInstanceSerializer(subprocess_instance).data,
            status=status.HTTP_201_CREATED,
        )


class OperationInstanceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = OperationInstance.objects.select_related(
        "subprocess_instance__template__process__manager",
        "operation_template",
    )
    serializer_class = OperationInstanceSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        user = self.request.user
        if user.role == User.Role.ADMIN:
            return self.queryset
        if user.role == User.Role.MANAGER:
            return self.queryset.filter(subprocess_instance__template__process__manager=user)
        return self.queryset.filter(assignments__user=user).distinct()

    @action(detail=True, methods=["post"])
    def complete(self, request, pk=None):
        operation_instance = self.get_object()
        completed = complete_user_assignments(operation_instance, request.user)
        return Response({"completed": completed})
