# processes/services.py
from django.utils import timezone
from django.db import transaction

from .models import (
    SubProcessTemplate, SubProcessInstance,
    OperationInstance, OperationAssignment,
    User, Career, AcademicPeriod,OperationActorTemplate
)


@transaction.atomic
def instantiate_subprocess(template: SubProcessTemplate,
                            career: Career,
                            period: AcademicPeriod,
                            created_by: User) -> SubProcessInstance:
    """
    Crea una SubProcessInstance (SPI) con todas sus OperationInstance (OI)
    y OperationAssignment (OA) derivadas de las plantillas.
    """
    spi = SubProcessInstance.objects.create(
        template=template,
        career=career,
        period=period,
        state="ACTIVE",
    )

    for ot in template.operation_templates.all():
        # calcula deadline
        deadline = (timezone.now().date() + timezone.timedelta(days=ot.deadline_days)
                    if ot.deadline_days else None)

        oi = OperationInstance.objects.create(
            operation_template=ot,
            subprocess_instance=spi,
            order=ot.order,
            deadline=deadline,
        )

        # crea asignaciones por cada rol/actor predefinido
        for actor in ot.actor_templates.all():
            OperationAssignment.objects.create(
                operation_instance=oi,
                user=created_by,              # TODO: mapa real de roles
                role_in_operation=actor.role,
            )
    return spi


def _users_for_role(role, template, participants=None, creator=None):
    """Resuelve a qué usuarios asignar según el rol."""
    if role == User.Role.MANAGER:
        return [template.process.manager]
    if role == User.Role.ADMIN:
        return list(User.objects.filter(role=User.Role.ADMIN))
    if role == User.Role.PARTICIPANT and participants:
        return participants
    # fallback: si el creador tiene ese rol
    return [creator] if creator and creator.role == role else []


@transaction.atomic
def instantiate_subprocess(template: SubProcessTemplate,
                            career,
                            period,
                            creator: User,
                            participants=None):
    """Crea SPI + OI + OA según actor_templates."""
    spi = SubProcessInstance.objects.create(
        template=template, career=career, period=period, state="ACTIVE"
    )

    for ot in template.operation_templates.all():
        deadline = (timezone.now().date() + timezone.timedelta(days=ot.deadline_days)
                    if ot.deadline_days else None)

        oi = OperationInstance.objects.create(
            operation_template=ot,
            subprocess_instance=spi,
            order=ot.order,
            deadline=deadline,
        )

        for at in ot.actor_templates.all():
            for user in _users_for_role(at.role, template, participants, creator):
                OperationAssignment.objects.create(
                    operation_instance=oi,
                    user=user,
                    role_in_operation="EMITTER" if at.is_emitter else
                                      "RECEIVER" if at.is_receiver else
                                      "RESPONSIBLE"
                )

    return spi
