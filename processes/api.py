from rest_framework import permissions, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response

from .models import OperationInstance, SubProcessInstance, User
from .serializers import OperationInstanceSerializer, SubProcessInstanceSerializer
from .services import complete_user_assignments


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
        return request.user.role == "MANAGER"


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
