# processes/signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver
from django.utils import timezone
from .models import (
    OperationAssignment, OperationInstance,
    SubProcessInstance, Notification,
)

@receiver(post_save, sender=OperationAssignment)
def update_states_and_notify(sender, instance, **kwargs):
    op = instance.operation_instance

    # 1) ¿Toda la operación completada?
    if op.assignments.filter(status="PENDING").exists():
        return
    if op.state != "COMPLETED":
        op.state = "COMPLETED"
        op.save(update_fields=["state"])

    # 2) ¿Todo el subproceso completado?
    spi = op.subprocess_instance
    if not spi.operation_instances.exclude(state="COMPLETED").exists():
        spi.state = "COMPLETED"
        spi.completed_at = timezone.now()
        spi.save(update_fields=["state", "completed_at"])

    # 3) Notificación al Gestor
    message = (
        f"Subproceso «{spi}» completado."
        if spi.state == "COMPLETED"
        else f"Operación «{op}» completada."
    )
    Notification.objects.create(
        user=spi.template.process.manager,
        message=message,
        related_assignment=instance,
    )
