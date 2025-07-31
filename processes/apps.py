# processes/apps.py
from django.apps import AppConfig


class ProcessesConfig(AppConfig):
    default_auto_field = 'django.db.models.BigAutoField'
    name = 'processes'

    def ready(self):
        from . import signals  # noqa
