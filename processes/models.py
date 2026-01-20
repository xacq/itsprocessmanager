from django.db import models
from django.contrib.auth.models import AbstractUser
from django.db.models import Max
from django.core.exceptions import ValidationError

# --------------------------------------------------
# 1. AUTHENTICATION & ROLES
# --------------------------------------------------
class User(AbstractUser):
    """Custom user model with explicit national ID and role."""
    class Role(models.TextChoices):
        ADMIN = "ADMIN", "Administrador del sistema"
        MANAGER = "MANAGER", "Gestor de procesos"
        PARTICIPANT = "PARTICIPANT", "Participante de la operación"

    id_number = models.CharField(max_length=20, unique=True)
    role = models.CharField(max_length=12, choices=Role.choices)

    def __str__(self):
        return f"{self.get_full_name()} ({self.role})"


# --------------------------------------------------
# 2.  MIXIN FECHAS + JERARQUÍA
# --------------------------------------------------
class TimestampedModel(models.Model):
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True


class ProcessInstitution(TimestampedModel):
    code = models.CharField(max_length=3, unique=True)  # 001
    name = models.CharField(max_length=120)
    description = models.TextField(blank=True)

    def __str__(self):
        return f"{self.code} – {self.name}"


class MacroProcess(TimestampedModel):
    process_institution = models.ForeignKey(
        ProcessInstitution,
        on_delete=models.CASCADE,
        related_name="macroprocesses",
    )
    code_suffix = models.CharField(max_length=3, blank=True)  # 002
    name = models.CharField(max_length=120)
    description = models.TextField(blank=True)

    class Meta:
        unique_together = ("process_institution", "code_suffix")

    # --- autogenera código 002 ---
    def save(self, *args, **kwargs):
        if not self.code_suffix:
            last = (
                MacroProcess.objects
                .filter(process_institution=self.process_institution)
                .aggregate(max_code=Max("code_suffix"))
            )
            next_int = int(last["max_code"] or 0) + 1
            self.code_suffix = f"{next_int:03d}"
        super().save(*args, **kwargs)

    @property
    def code(self):
        return f"{self.process_institution.code}.{self.code_suffix}"

    def __str__(self):
        return f"{self.code} – {self.name}"


class Process(TimestampedModel):
    macro_process = models.ForeignKey(
        MacroProcess,
        on_delete=models.CASCADE,
        related_name="processes",
    )
    code_suffix = models.CharField(max_length=3, blank=True)  # 003
    name = models.CharField(max_length=120)
    description = models.TextField(blank=True)
    manager = models.ForeignKey(
        User,
        limit_choices_to={"role": User.Role.MANAGER},
        on_delete=models.PROTECT,
    )

    class Meta:
        unique_together = ("macro_process", "code_suffix")

    # --- autogenera código 003 ---
    def save(self, *args, **kwargs):
        if not self.code_suffix:
            last = (
                Process.objects
                .filter(macro_process=self.macro_process)
                .aggregate(max_code=Max("code_suffix"))
            )
            next_int = int(last["max_code"] or 0) + 1
            self.code_suffix = f"{next_int:03d}"
        super().save(*args, **kwargs)

    @property
    def code(self):
        return f"{self.macro_process.code}.{self.code_suffix}"

    def __str__(self):
        return f"{self.code} – {self.name}"


# --------------------------------------------------
# 3. SUBPROCESOS (PLANTILLA)
# --------------------------------------------------
class SubProcessTemplate(TimestampedModel):
    process = models.ForeignKey(
        Process,
        on_delete=models.CASCADE,
        related_name="subprocess_templates",
    )
    name = models.CharField(max_length=120)
    description = models.TextField(blank=True)
    created_by = models.ForeignKey(User, on_delete=models.PROTECT)

    def __str__(self):
        return self.name


class StorageType(TimestampedModel):   #  ← hereda TimeStampedModel (FIX)
    subprocess_template = models.ForeignKey(
        SubProcessTemplate,
        on_delete=models.CASCADE,
        related_name="storage_types",
    )
    name = models.CharField(max_length=120)
    permanent = models.BooleanField(default=True)

    def __str__(self):
        return self.name


class OperationType(models.TextChoices):
    COMPLETE = "COMPLETE", "Marcar como completada"
    DOC_REQUEST = "DOC_REQUEST", "Solicitud de documento"
    REVIEW = "REVIEW", "Revisión y aprobación"
    CERT_REQUEST = "CERT_REQUEST", "Solicitud de certificado"


class OperationTemplate(models.Model):
    subprocess_template = models.ForeignKey(
        SubProcessTemplate,
        on_delete=models.CASCADE,
        related_name="operation_templates",
    )
    name = models.CharField(max_length=120)
    type = models.CharField(max_length=15, choices=OperationType.choices)
    order = models.PositiveSmallIntegerField()
    deadline_days = models.PositiveSmallIntegerField(default=0)
    storage_type = models.ForeignKey(
        StorageType,
        null=True, blank=True,
        on_delete=models.SET_NULL,
    )
    requires_approval = models.BooleanField(default=False)

    class Meta:
        ordering = ["order"]
        unique_together = ("subprocess_template", "order")

    # --- validaciones ---
    def clean(self):
        # orden único
        if (
            self.order
            and OperationTemplate.objects
            .filter(subprocess_template=self.subprocess_template, order=self.order)
            .exclude(pk=self.pk)
            .exists()
        ):
            raise ValidationError("El orden debe ser único dentro del subproceso.")

        # tipo documento requiere StorageType
        if self.type in {OperationType.DOC_REQUEST, OperationType.REVIEW} and not self.storage_type:
            raise ValidationError("Seleccione un tipo de almacenamiento para esta operación.")

    def save(self, *args, **kwargs):
        self.full_clean()
        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.order}. {self.name} ({self.get_type_display()})"


class OperationActorTemplate(models.Model):
    operation_template = models.ForeignKey(
        OperationTemplate,
        on_delete=models.CASCADE,
        related_name="actor_templates",
    )
    role = models.CharField(max_length=12, choices=User.Role.choices)
    participant = models.ForeignKey(
        User,
        null=True,
        blank=True,
        on_delete=models.PROTECT,
        related_name="operation_actor_templates",
        limit_choices_to={"role": User.Role.PARTICIPANT},
    )
    is_emitter = models.BooleanField(default=False)
    is_receiver = models.BooleanField(default=False)

    def clean(self):
        if self.role == User.Role.PARTICIPANT and not self.participant:
            raise ValidationError("Debe seleccionar el participante para esta operación.")
        if self.role != User.Role.PARTICIPANT and self.participant:
            raise ValidationError("Sólo los roles PARTICIPANT pueden tener un usuario específico.")
        super().clean()


# --------------------------------------------------
# 4. INSTANCIAS EN EJECUCIÓN
# --------------------------------------------------
class Career(models.Model):
    name = models.CharField(max_length=120)

    def __str__(self):
        return self.name


class AcademicPeriod(models.Model):
    code = models.CharField(max_length=20)  # 2025-1
    start_date = models.DateField()
    end_date = models.DateField()

    def __str__(self):
        return self.code


class SubProcessInstance(TimestampedModel):
    template = models.ForeignKey(
        SubProcessTemplate,
        on_delete=models.PROTECT,
        related_name="instances",
    )
    career = models.ForeignKey(Career, on_delete=models.PROTECT)
    period = models.ForeignKey(AcademicPeriod, on_delete=models.PROTECT)
    state = models.CharField(
        max_length=12,
        choices=[("PENDING", "Pendiente"), ("ACTIVE", "En ejecución"), ("COMPLETED", "Completado")],
        default="ACTIVE",
    )
    started_at = models.DateTimeField(auto_now_add=True)
    completed_at = models.DateTimeField(null=True, blank=True)

    def __str__(self):
        return f"{self.template.name} – {self.period} ({self.career})"


class OperationInstance(models.Model):
    operation_template = models.ForeignKey(OperationTemplate, on_delete=models.CASCADE)
    subprocess_instance = models.ForeignKey(
        SubProcessInstance,
        on_delete=models.CASCADE,
        related_name="operation_instances",
    )
    state = models.CharField(
        max_length=12,
        choices=[("PENDING", "Pendiente"), ("LATE", "Atrasado"), ("COMPLETED", "Completado")],
        default="PENDING",
    )
    deadline = models.DateField(null=True, blank=True)
    order = models.PositiveSmallIntegerField()

    class Meta:
        ordering = ["order"]
        unique_together = ("subprocess_instance", "order")


class OperationAssignment(models.Model):
    operation_instance = models.ForeignKey(
        OperationInstance,
        on_delete=models.CASCADE,
        related_name="assignments",
    )
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    role_in_operation = models.CharField(
        max_length=12,
        choices=[("EMITTER", "Emisor"), ("RECEIVER", "Receptor"), ("RESPONSIBLE", "Responsable")],
        default="RESPONSIBLE",
    )
    status = models.CharField(
        max_length=12,
        choices=[("PENDING", "Pendiente"), ("COMPLETED", "Completado")],
        default="PENDING",
    )
    completed_at = models.DateTimeField(null=True, blank=True)


class Document(models.Model):
    operation_instance = models.ForeignKey(
        OperationInstance,
        on_delete=models.CASCADE,
        related_name="documents",
    )
    storage_type = models.ForeignKey(StorageType, on_delete=models.PROTECT)
    file = models.FileField(upload_to="documents/%Y/%m/%d/")
    uploaded_by = models.ForeignKey(User, on_delete=models.PROTECT)
    uploaded_at = models.DateTimeField(auto_now_add=True)
    approved_by = models.ForeignKey(
        User,
        on_delete=models.PROTECT,
        related_name="approved_documents",
        null=True, blank=True,
    )
    approved_at = models.DateTimeField(null=True, blank=True)
    replaced_document = models.ForeignKey("self", null=True, blank=True, on_delete=models.SET_NULL)


class Notification(TimestampedModel):
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name="notifications")
    message = models.TextField()
    is_read = models.BooleanField(default=False)
    related_assignment = models.ForeignKey(
        OperationAssignment,
        null=True, blank=True,
        on_delete=models.SET_NULL,
    )

    class Meta:
        ordering = ["-created_at"]
