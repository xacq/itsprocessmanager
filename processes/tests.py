import tempfile

from django.contrib import admin
from django.core.files.uploadedfile import SimpleUploadedFile
from django.test import RequestFactory, TestCase, override_settings

from .admin import ProcessAdmin, UserAdmin
from .models import (
    AcademicPeriod,
    Career,
    MacroProcess,
    OperationActorTemplate,
    OperationAssignment,
    OperationTemplate,
    OperationType,
    Process,
    ProcessInstitution,
    StorageType,
    SubProcessTemplate,
    User,
)
from .services import attach_document, complete_user_assignments, instantiate_subprocess
from .views_ui import OperationListView


@override_settings(MEDIA_ROOT=tempfile.mkdtemp())
class ProcessWorkflowTests(TestCase):
    def setUp(self):
        self.admin_user = User.objects.create_superuser(
            username="admin",
            password="pass",
            email="admin@example.com",
            id_number="0000000001",
            role=User.Role.ADMIN,
        )
        self.manager = User.objects.create_user(
            username="gestor",
            password="pass",
            id_number="0000000002",
            role=User.Role.MANAGER,
            is_staff=True,
        )
        self.other_manager = User.objects.create_user(
            username="otro_gestor",
            password="pass",
            id_number="0000000003",
            role=User.Role.MANAGER,
            is_staff=True,
        )
        self.participant = User.objects.create_user(
            username="alumno",
            password="pass",
            id_number="1111111111",
            role=User.Role.PARTICIPANT,
        )
        self.other_participant = User.objects.create_user(
            username="otro_alumno",
            password="pass",
            id_number="2222222222",
            role=User.Role.PARTICIPANT,
        )
        self.institution = ProcessInstitution.objects.create(code="001", name="IST Austro")
        self.macro = MacroProcess.objects.create(
            process_institution=self.institution,
            name="Docencia",
        )
        self.process = Process.objects.create(
            macro_process=self.macro,
            name="Prácticas preprofesionales",
            manager=self.manager,
        )
        self.other_process = Process.objects.create(
            macro_process=self.macro,
            name="Vinculación",
            manager=self.other_manager,
        )
        self.template = SubProcessTemplate.objects.create(
            process=self.process,
            name="Solicitud de prácticas",
            created_by=self.manager,
        )
        self.storage_type = StorageType.objects.create(
            subprocess_template=self.template,
            name="Solicitud firmada",
        )
        self.operation = OperationTemplate.objects.create(
            subprocess_template=self.template,
            name="Enviar solicitud",
            type=OperationType.DOC_REQUEST,
            order=1,
            storage_type=self.storage_type,
            requires_approval=True,
        )
        OperationActorTemplate.objects.create(
            operation_template=self.operation,
            role=User.Role.PARTICIPANT,
            is_emitter=True,
        )
        OperationActorTemplate.objects.create(
            operation_template=self.operation,
            role=User.Role.MANAGER,
            is_receiver=True,
        )
        self.career = Career.objects.create(name="Redes")
        self.period = AcademicPeriod.objects.create(
            code="2026-1",
            start_date="2026-01-01",
            end_date="2026-06-30",
        )

    def test_subprocess_instantiation_assigns_only_selected_participant(self):
        spi = instantiate_subprocess(
            self.template,
            self.career,
            self.period,
            self.manager,
            participants=[self.participant],
        )

        assignments = OperationAssignment.objects.filter(operation_instance__subprocess_instance=spi)
        self.assertEqual(assignments.count(), 2)
        self.assertTrue(assignments.filter(user=self.participant).exists())
        self.assertTrue(assignments.filter(user=self.manager).exists())
        self.assertFalse(assignments.filter(user=self.other_participant).exists())

    def test_completion_keeps_operation_pending_until_all_assignees_complete(self):
        spi = instantiate_subprocess(
            self.template,
            self.career,
            self.period,
            self.manager,
            participants=[self.participant],
        )
        operation_instance = spi.operation_instances.get()

        complete_user_assignments(operation_instance, self.participant)
        operation_instance.refresh_from_db()
        self.assertEqual(operation_instance.state, "PENDING")

        complete_user_assignments(operation_instance, self.manager)
        operation_instance.refresh_from_db()
        spi.refresh_from_db()
        self.assertEqual(operation_instance.state, "COMPLETED")
        self.assertEqual(spi.state, "COMPLETED")
        self.assertEqual(self.manager.notifications.count(), 1)

    def test_attach_document_uses_operation_storage_type(self):
        spi = instantiate_subprocess(
            self.template,
            self.career,
            self.period,
            self.manager,
            participants=[self.participant],
        )
        operation_instance = spi.operation_instances.get()
        uploaded = SimpleUploadedFile("solicitud.pdf", b"contenido", content_type="application/pdf")

        document = attach_document(operation_instance, self.participant, uploaded)

        self.assertEqual(document.storage_type, self.storage_type)
        self.assertEqual(document.uploaded_by, self.participant)

    def test_participant_operation_list_shows_only_assigned_operations(self):
        own_spi = instantiate_subprocess(
            self.template,
            self.career,
            self.period,
            self.manager,
            participants=[self.participant],
        )
        other_spi = instantiate_subprocess(
            self.template,
            self.career,
            self.period,
            self.manager,
            participants=[self.other_participant],
        )

        request = RequestFactory().get("/operations/")
        request.user = self.participant
        view = OperationListView()
        view.request = request
        visible_ids = set(view.get_queryset().values_list("id", flat=True))

        self.assertIn(own_spi.operation_instances.get().id, visible_ids)
        self.assertNotIn(other_spi.operation_instances.get().id, visible_ids)

    def test_manager_admin_sees_only_assigned_processes(self):
        request = type("Request", (), {"user": self.manager})()
        model_admin = ProcessAdmin(Process, admin.site)

        qs = model_admin.get_queryset(request)

        self.assertIn(self.process, qs)
        self.assertNotIn(self.other_process, qs)
        self.assertFalse(model_admin.has_add_permission(request))

    def test_manager_user_admin_limited_to_participants(self):
        request = type("Request", (), {"user": self.manager})()
        model_admin = UserAdmin(User, admin.site)

        qs = model_admin.get_queryset(request)

        self.assertIn(self.participant, qs)
        self.assertNotIn(self.admin_user, qs)
        self.assertNotIn(self.other_manager, qs)


class BootstrapDemoTests(TestCase):
    def test_bootstrap_demo_creates_users_and_loads_clean_fixture(self):
        from io import StringIO

        from django.core.management import call_command

        call_command("bootstrap_demo", verbosity=0, stdout=StringIO())

        self.assertTrue(User.objects.filter(pk=1, username="admin", role=User.Role.ADMIN).exists())
        self.assertTrue(User.objects.filter(pk=2, username="gestor", role=User.Role.MANAGER).exists())
        self.assertEqual(User.objects.filter(role=User.Role.PARTICIPANT).count(), 3)
        self.assertEqual(SubProcessTemplate.objects.count(), 5)
        self.assertEqual(OperationActorTemplate.objects.count(), 34)
        self.assertFalse(SubProcessTemplate.objects.filter(pk=2).exists())
        self.assertEqual(Process.objects.get(pk=1).manager_id, 2)
