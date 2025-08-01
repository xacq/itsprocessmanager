from rest_framework import routers, viewsets, permissions
from .models import SubProcessInstance, OperationInstance
from .serializers import SubProcessInstanceSerializer, OperationInstanceSerializer

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
    """GET /api/instances/  — lista / detalle de SPI"""
    queryset = SubProcessInstance.objects.select_related("template", "career", "period")
    serializer_class = SubProcessInstanceSerializer

    def get_queryset(self):
        user = self.request.user
        if user.role == "MANAGER":
            return self.queryset.filter(template__process__manager=user)
        if user.role == "PARTICIPANT":
            return self.queryset.filter(operation_instances__assignments__user=user).distinct()
        return self.queryset  # ADMIN

class OperationInstanceViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = OperationInstance.objects.select_related("subprocess_instance", "operation_template")
    serializer_class = OperationInstanceSerializer
    permission_classes = [permissions.IsAuthenticated]
