# processes/services.py
from django.utils import timezone
from django.db import transaction

from .models import (
    SubProcessTemplate, SubProcessInstance,
    OperationInstance, OperationAssignment,
    User, Career, AcademicPeriod,
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
