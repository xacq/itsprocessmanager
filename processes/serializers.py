from rest_framework import serializers
from .models import *

# --------- Catálogos básicos ----------
class ProcessInstitutionSerializer(serializers.ModelSerializer):
    class Meta:
        model = ProcessInstitution
        fields = ("id", "code", "name", "description")


class MacroProcessSerializer(serializers.ModelSerializer):
    class Meta:
        model = MacroProcess
        fields = ("id", "code", "name", "process_institution")


class ProcessSerializer(serializers.ModelSerializer):
    class Meta:
        model = Process
        fields = ("id", "code", "name", "macro_process", "manager")


# --------- Plantillas ----------
class OperationTemplateSerializer(serializers.ModelSerializer):
    class Meta:
        model = OperationTemplate
        fields = "__all__"


class SubProcessTemplateSerializer(serializers.ModelSerializer):
    operation_templates = OperationTemplateSerializer(many=True, read_only=True)

    class Meta:
        model = SubProcessTemplate
        fields = ("id", "name", "description", "process", "operation_templates")


# --------- Ejecución ----------
class OperationInstanceSerializer(serializers.ModelSerializer):
    class Meta:
        model = OperationInstance
        fields = "__all__"


class SubProcessInstanceSerializer(serializers.ModelSerializer):
    operation_instances = OperationInstanceSerializer(many=True, read_only=True)

    class Meta:
        model = SubProcessInstance
        fields = "__all__"


# --------- Documentos ----------
class DocumentSerializer(serializers.ModelSerializer):
    class Meta:
        model = Document
        fields = "__all__"


# --------- Notificaciones ----------
class NotificationSerializer(serializers.ModelSerializer):
    class Meta:
        model = Notification
        fields = "__all__"
