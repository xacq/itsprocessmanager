# processes/urls.py
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register("institutions", views.InstitutionView)
router.register("macroprocesses", views.MacroProcessView)
router.register("processes", views.ProcessView)
router.register("subprocess-templates", views.SubProcessTemplateView)
router.register("instances", views.SubProcessInstanceView, basename="instances")
router.register("operations", views.OperationInstanceView, basename="operations")
router.register("documents", views.DocumentView)
router.register("notifications", views.NotificationView, basename="notifications")

urlpatterns = router.urls     # <- exporta la lista de urls
