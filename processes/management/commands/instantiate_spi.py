# processes/management/commands/instantiate_spi.py
from django.core.management.base import BaseCommand, CommandError
from processes.services import instantiate_subprocess
from processes.models import SubProcessTemplate, Career, AcademicPeriod, User

class Command(BaseCommand):
    help = "Instancia un subproceso desde la línea de comandos"

    def add_arguments(self, parser):
        parser.add_argument("template_id", type=int)
        parser.add_argument("career_id", type=int)
        parser.add_argument("period_id", type=int)
        parser.add_argument("user_id", type=int)

    def handle(self, *args, **options):
        try:
            tpl = SubProcessTemplate.objects.get(pk=options["template_id"])
            career = Career.objects.get(pk=options["career_id"])
            period = AcademicPeriod.objects.get(pk=options["period_id"])
            user = User.objects.get(pk=options["user_id"])
        except (SubProcessTemplate.DoesNotExist, Career.DoesNotExist,
                AcademicPeriod.DoesNotExist, User.DoesNotExist) as e:
            raise CommandError(str(e))

        spi = instantiate_subprocess(tpl, career, period, user)
        self.stdout.write(self.style.SUCCESS(f"SPI creado: {spi.pk}"))
