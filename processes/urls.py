# processes/urls.py
from rest_framework.routers import DefaultRouter
from . import views                       # catálogos + docs + notifs
from .api import (
    SubProcessInstanceViewSet,
    OperationInstanceViewSet,
)

router = DefaultRouter()

# --------- Catálogos y plantillas (solo lectura / gestor) ----------
router.register("institutions", views.InstitutionView)
router.register("macroprocesses", views.MacroProcessView)
router.register("processes", views.ProcessView)
router.register("subprocess-templates", views.SubProcessTemplateView)

# --------- Ejecución (API v1) --------------------------------------
# Usamos nombres explícitos para evitar choque con rutas UI
router.register(
    "subprocess-instances",
    SubProcessInstanceViewSet,
    basename="subprocess-instances",
)
router.register(
    "operation-instances",
    OperationInstanceViewSet,
    basename="operation-instances",
)

# --------- Documentos y notificaciones -----------------------------
router.register("documents", views.DocumentView)
router.register("notifications", views.NotificationView, basename="notifications")

urlpatterns = router.urls
