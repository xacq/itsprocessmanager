from django.core.management import BaseCommand, CommandError, call_command
from django.db import transaction

from processes.models import Process, User


DEMO_USERS = [
    {
        "pk": 1,
        "username": "admin",
        "password": "123Qwerty$%^",
        "email": "admin@istausto.edu.ec",
        "id_number": "0000000001",
        "role": User.Role.ADMIN,
        "is_staff": True,
        "is_superuser": True,
    },
    {
        "pk": 2,
        "username": "gestor",
        "password": "Gestor123!",
        "email": "gestor@istausto.edu.ec",
        "id_number": "0000000002",
        "role": User.Role.MANAGER,
        "is_staff": True,
        "is_superuser": False,
    },
]

DEMO_PARTICIPANTS = [
    {
        "username": "alumno1",
        "password": "Alumno123!",
        "email": "alumno1@istausto.edu.ec",
        "id_number": "1111111111",
    },
    {
        "username": "alumno2",
        "password": "Alumno123!",
        "email": "alumno2@istausto.edu.ec",
        "id_number": "2222222222",
    },
    {
        "username": "alumno3",
        "password": "Alumno123!",
        "email": "alumno3@istausto.edu.ec",
        "id_number": "3333333333",
    },
]


class Command(BaseCommand):
    help = "Crea usuarios demo y carga los datos iniciales del sistema."

    def add_arguments(self, parser):
        parser.add_argument(
            "--no-reset-passwords",
            action="store_true",
            help="No restablece contraseñas de usuarios demo existentes.",
        )
        parser.add_argument(
            "--skip-fixture",
            action="store_true",
            help="Crea usuarios demo sin cargar processes/fixtures/initial.json.",
        )

    @transaction.atomic
    def handle(self, *args, **options):
        reset_passwords = not options["no_reset_passwords"]

        for user_data in DEMO_USERS:
            self._ensure_fixed_user(user_data, reset_passwords)

        for participant_data in DEMO_PARTICIPANTS:
            self._ensure_participant(participant_data, reset_passwords)

        if not options["skip_fixture"]:
            call_command("loaddata", "processes/fixtures/initial.json", verbosity=0)
            gestor = User.objects.get(pk=2)
            Process.objects.filter(pk=1).update(manager=gestor)
            self.stdout.write(self.style.SUCCESS("Datos iniciales cargados desde initial.json."))

        self.stdout.write(self.style.SUCCESS("Bootstrap demo completado."))
        self.stdout.write("Usuarios demo:")
        self.stdout.write("  admin / 123Qwerty$%^")
        self.stdout.write("  gestor / Gestor123!")
        self.stdout.write("  alumno1, alumno2, alumno3 / Alumno123!")

    def _ensure_fixed_user(self, user_data, reset_passwords):
        pk = user_data["pk"]
        username = user_data["username"]
        existing_pk = User.objects.filter(pk=pk).first()
        if existing_pk and existing_pk.username != username:
            raise CommandError(
                f"El ID {pk} ya pertenece a '{existing_pk.username}'. "
                f"No se puede crear el usuario demo '{username}'."
            )

        existing_username = User.objects.filter(username=username).first()
        if existing_username and existing_username.pk != pk:
            raise CommandError(
                f"El usuario '{username}' ya existe con ID {existing_username.pk}; "
                f"se esperaba ID {pk}."
            )

        defaults = {
            "username": username,
            "email": user_data["email"],
            "id_number": user_data["id_number"],
            "role": user_data["role"],
            "is_staff": user_data["is_staff"],
            "is_superuser": user_data["is_superuser"],
            "is_active": True,
        }
        user, _ = User.objects.update_or_create(pk=pk, defaults=defaults)
        if reset_passwords:
            user.set_password(user_data["password"])
            user.save(update_fields=["password"])

    def _ensure_participant(self, user_data, reset_passwords):
        existing_id_number = User.objects.filter(id_number=user_data["id_number"]).first()
        if existing_id_number and existing_id_number.username != user_data["username"]:
            raise CommandError(
                f"La cédula/DNI {user_data['id_number']} ya pertenece a "
                f"'{existing_id_number.username}'."
            )

        user, _ = User.objects.update_or_create(
            username=user_data["username"],
            defaults={
                "email": user_data["email"],
                "id_number": user_data["id_number"],
                "role": User.Role.PARTICIPANT,
                "is_staff": False,
                "is_superuser": False,
                "is_active": True,
            },
        )
        if reset_passwords:
            user.set_password(user_data["password"])
            user.save(update_fields=["password"])
