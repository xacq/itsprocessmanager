from rest_framework import viewsets, mixins, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django.utils import timezone

from .models import *
from .serializers import *
from .permissions import IsManager
from .services import instantiate_subprocess

# ------ Catálogos (solo lectura pública) ------
class InstitutionView(viewsets.ReadOnlyModelViewSet):
    queryset = ProcessInstitution.objects.all()
    serializer_class = ProcessInstitutionSerializer


class MacroProcessView(viewsets.ReadOnlyModelViewSet):
    queryset = MacroProcess.objects.all()
    serializer_class = MacroProcessSerializer


class ProcessView(viewsets.ReadOnlyModelViewSet):
    queryset = Process.objects.all()
    serializer_class = ProcessSerializer


# ------ Plantillas (solo Gestor) ------
class SubProcessTemplateView(viewsets.ModelViewSet):
    queryset = SubProcessTemplate.objects.all()
    serializer_class = SubProcessTemplateSerializer
    permission_classes = [IsManager]


# ------ Instancias ------
class SubProcessInstanceView(viewsets.ReadOnlyModelViewSet):
    queryset = SubProcessInstance.objects.select_related("template", "career", "period")
    serializer_class = SubProcessInstanceSerializer

    @action(detail=False, methods=["post"], permission_classes=[IsManager])
    def instantiate(self, request):
        """
        Body: {template_id, career_id, period_id}
        """
        tpl = SubProcessTemplate.objects.get(pk=request.data["template_id"])
        career = Career.objects.get(pk=request.data["career_id"])
        period = AcademicPeriod.objects.get(pk=request.data["period_id"])
        spi = instantiate_subprocess(tpl, career, period, request.user)
        return Response(SubProcessInstanceSerializer(spi).data, status=status.HTTP_201_CREATED)


class OperationInstanceView(viewsets.GenericViewSet,
                            mixins.RetrieveModelMixin,
                            mixins.UpdateModelMixin):
    queryset = OperationInstance.objects.all()
    serializer_class = OperationInstanceSerializer

    @action(detail=True, methods=["post"])
    def complete(self, request, pk=None):
        oi = self.get_object()
        # marca todas las asignaciones del usuario como completadas
        qs = oi.assignments.filter(user=request.user, status="PENDING")
        qs.update(status="COMPLETED", completed_at=timezone.now())
        return Response({"completed": qs.count()})


# ------ Documentos ------
class DocumentView(viewsets.ModelViewSet):
    queryset = Document.objects.select_related("operation_instance")
    serializer_class = DocumentSerializer
    http_method_names = ["get", "post", "delete"]


# ------ Notificaciones ------
class NotificationView(viewsets.ReadOnlyModelViewSet):
    serializer_class = NotificationSerializer

    def get_queryset(self):
        return Notification.objects.filter(user=self.request.user)
