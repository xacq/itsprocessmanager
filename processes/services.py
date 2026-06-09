# processes/services.py
from pathlib import Path

from django.conf import settings
from django.core.exceptions import ValidationError
from django.db import transaction
from django.utils import timezone

from .models import (
    AcademicPeriod,
    Career,
    Document,
    Notification,
    OperationAssignment,
    OperationInstance,
    SubProcessInstance,
    SubProcessTemplate,
    User,
)


def _users_for_role(role, template, participants=None, creator=None):
    """Resuelve a qué usuarios asignar según el rol definido en la plantilla."""
    if role == User.Role.MANAGER:
        return [template.process.manager]
    if role == User.Role.ADMIN:
        return list(User.objects.filter(role=User.Role.ADMIN))
    if role == User.Role.PARTICIPANT and participants:
        return participants
    # fallback: si el creador tiene ese rol
    return [creator] if creator and creator.role == role else []


def _assignment_role(actor_template):
    """Traduce flags de plantilla al rol operativo válido en OperationAssignment."""
    if actor_template.is_emitter:
        return "EMITTER"
    if actor_template.is_receiver:
        return "RECEIVER"
    return "RESPONSIBLE"


def _notify_manager(operation_instance, assignment=None):
    """Crea una notificación para el gestor del proceso asociado."""
    subprocess_instance = operation_instance.subprocess_instance
    message = (
        f"Subproceso «{subprocess_instance}» completado."
        if subprocess_instance.state == "COMPLETED"
        else f"Operación «{operation_instance}» completada."
    )
    Notification.objects.create(
        user=subprocess_instance.template.process.manager,
        message=message,
        related_assignment=assignment,
    )


def _notify_users(users, message):
    """Crea notificaciones simples para usuarios únicos."""
    seen = set()
    for user in users:
        if user and user.pk not in seen:
            Notification.objects.create(user=user, message=message)
            seen.add(user.pk)


def _validate_document_file(uploaded_file):
    """Valida tamaño y extensión permitida para evidencias/documentos."""
    max_size = getattr(settings, "MAX_DOCUMENT_UPLOAD_SIZE", 5 * 1024 * 1024)
    if uploaded_file.size > max_size:
        raise ValueError("El archivo supera el tamaño máximo permitido.")

    allowed_extensions = getattr(settings, "ALLOWED_DOCUMENT_EXTENSIONS", set())
    extension = Path(uploaded_file.name).suffix.lower()
    if allowed_extensions and extension not in allowed_extensions:
        allowed = ", ".join(sorted(allowed_extensions))
        raise ValueError(f"Tipo de archivo no permitido. Extensiones válidas: {allowed}.")


def refresh_operation_progress(operation_instance, assignment=None):
    """
    Sincroniza operación y subproceso a partir de sus asignaciones.

    Esta función es deliberadamente explícita porque QuerySet.update() no dispara
    señales de Django. Las vistas/API deben llamarla después de completar
    asignaciones o aprobar una operación.
    """
    operation_instance.refresh_from_db()
    if operation_instance.assignments.filter(status="PENDING").exists():
        return operation_instance

    state_changed = operation_instance.state != "COMPLETED"
    if state_changed:
        operation_instance.state = "COMPLETED"
        operation_instance.save(update_fields=["state"])

    subprocess_instance = operation_instance.subprocess_instance
    subprocess_completed = False
    if not subprocess_instance.operation_instances.exclude(state="COMPLETED").exists():
        if subprocess_instance.state != "COMPLETED":
            subprocess_instance.state = "COMPLETED"
            subprocess_instance.completed_at = timezone.now()
            subprocess_instance.save(update_fields=["state", "completed_at"])
            subprocess_completed = True

    if state_changed or subprocess_completed:
        _notify_manager(operation_instance, assignment=assignment)

    return operation_instance


@transaction.atomic
def instantiate_subprocess(
    template: SubProcessTemplate,
    career: Career,
    period: AcademicPeriod,
    creator: User,
    participants=None,
) -> SubProcessInstance:
    """Crea SPI + OI + OA según actor_templates."""
    spi = SubProcessInstance.objects.create(
        template=template,
        career=career,
        period=period,
        state="ACTIVE",
    )

    for operation_template in template.operation_templates.all():
        deadline = (
            timezone.now().date() + timezone.timedelta(days=operation_template.deadline_days)
            if operation_template.deadline_days
            else None
        )

        operation_instance = OperationInstance.objects.create(
            operation_template=operation_template,
            subprocess_instance=spi,
            order=operation_template.order,
            deadline=deadline,
        )

        for actor_template in operation_template.actor_templates.select_related("participant"):
            target_users = (
                [actor_template.participant]
                if actor_template.participant
                else _users_for_role(actor_template.role, template, participants, creator)
            )
            if actor_template.role == User.Role.PARTICIPANT and not target_users:
                raise ValidationError(
                    "Seleccione al menos un participante para iniciar este subproceso."
                )
            for user in target_users:
                OperationAssignment.objects.create(
                    operation_instance=operation_instance,
                    user=user,
                    role_in_operation=_assignment_role(actor_template),
                )

    return spi


@transaction.atomic
def complete_user_assignments(operation_instance, user):
    """Completa las asignaciones pendientes de un usuario y sincroniza estados."""
    assignments = list(
        operation_instance.assignments.select_for_update().filter(
            user=user,
            status="PENDING",
        )
    )
    completed_at = timezone.now()
    for assignment in assignments:
        assignment.status = "COMPLETED"
        assignment.completed_at = completed_at
        assignment.save(update_fields=["status", "completed_at"])

    last_assignment = assignments[-1] if assignments else None
    refresh_operation_progress(operation_instance, assignment=last_assignment)
    return len(assignments)


@transaction.atomic
def approve_operation(operation_instance, approved_by):
    """Aprueba una operación y registra aprobación en sus documentos pendientes."""
    now = timezone.now()
    Document.objects.filter(
        operation_instance=operation_instance,
        status=Document.Status.PENDING,
    ).update(
        status=Document.Status.APPROVED,
        approved_by=approved_by,
        approved_at=now,
        review_comment="",
    )

    assignments = list(
        operation_instance.assignments.select_for_update().filter(status="PENDING")
    )
    operation_instance.assignments.filter(status="PENDING").update(
        status="COMPLETED",
        completed_at=now,
    )

    state_changed = operation_instance.state != "COMPLETED"
    if state_changed:
        operation_instance.state = "COMPLETED"
        operation_instance.save(update_fields=["state"])

    subprocess_instance = operation_instance.subprocess_instance
    subprocess_completed = False
    if not subprocess_instance.operation_instances.exclude(state="COMPLETED").exists():
        if subprocess_instance.state != "COMPLETED":
            subprocess_instance.state = "COMPLETED"
            subprocess_instance.completed_at = now
            subprocess_instance.save(update_fields=["state", "completed_at"])
            subprocess_completed = True

    if state_changed or subprocess_completed:
        _notify_manager(operation_instance, assignment=assignments[-1] if assignments else None)
    return operation_instance


@transaction.atomic
def reject_operation_documents(operation_instance, rejected_by, comment):
    """Rechaza documentos pendientes y notifica a los usuarios que deben corregirlos."""
    comment = (comment or "").strip()
    if not comment:
        raise ValueError("Ingrese una observación para rechazar el documento.")

    pending_documents = list(
        Document.objects.select_for_update().filter(
            operation_instance=operation_instance,
            status=Document.Status.PENDING,
        )
    )
    if not pending_documents:
        raise ValueError("No hay documentos pendientes para rechazar.")

    now = timezone.now()
    for document in pending_documents:
        document.status = Document.Status.REJECTED
        document.approved_by = rejected_by
        document.approved_at = now
        document.review_comment = comment
        document.save(update_fields=["status", "approved_by", "approved_at", "review_comment"])

    operation_instance.state = "PENDING"
    operation_instance.save(update_fields=["state"])

    uploaders = [document.uploaded_by for document in pending_documents]
    _notify_users(
        uploaders,
        f"Documento rechazado en la operación «{operation_instance}»: {comment}",
    )
    return pending_documents


@transaction.atomic
def attach_document(operation_instance, uploaded_by, uploaded_file):
    """Adjunta un documento usando el storage_type definido en la plantilla."""
    storage_type = operation_instance.operation_template.storage_type
    if not storage_type:
        raise ValueError("La operación no tiene un tipo de almacenamiento configurado.")
    _validate_document_file(uploaded_file)

    replaced_document = (
        operation_instance.documents.filter(
            uploaded_by=uploaded_by,
            status__in=[Document.Status.PENDING, Document.Status.REJECTED],
        )
        .order_by("-uploaded_at", "-id")
        .first()
    )

    return Document.objects.create(
        operation_instance=operation_instance,
        storage_type=storage_type,
        file=uploaded_file,
        uploaded_by=uploaded_by,
        replaced_document=replaced_document,
    )
