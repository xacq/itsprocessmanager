from django.utils import timezone
from django_cron import CronJobBase, Schedule
from .models import OperationInstance

class CheckOverdueOps(CronJobBase):
    RUN_EVERY_MINS = 60 * 24  # 1 vez al día
    schedule = Schedule(run_every_mins=RUN_EVERY_MINS)
    code = "processes.check_overdue_ops"

    def do(self):
        today = timezone.now().date()
        qty = (
            OperationInstance.objects
            .filter(state="PENDING", deadline__lt=today)
            .update(state="LATE")
        )
        if qty:
            print(f"[cron] {qty} operaciones marcadas LATE")
