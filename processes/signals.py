# processes/signals.py
from django.db.models.signals import post_save
from django.dispatch import receiver

from .models import OperationAssignment
from .services import refresh_operation_progress


@receiver(post_save, sender=OperationAssignment)
def update_states_and_notify(sender, instance, **kwargs):
    """Mantiene estados sincronizados cuando una asignación se guarda individualmente."""
    if instance.status != "COMPLETED":
        return
    refresh_operation_progress(instance.operation_instance, assignment=instance)
