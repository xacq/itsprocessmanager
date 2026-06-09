from django.contrib import admin
from django.urls import path, include
from django.conf import settings
from django.conf.urls.static import static
from django.contrib.auth import views as auth_views
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from processes import views_ui as pui    # todas las vistas desde aquí

urlpatterns = [
    path("admin/", admin.site.urls),

    # Gestor: iniciar subproceso
    path("templates/<int:pk>/start/", pui.StartView.as_view(), name="template-start"),

    # Auth
    path("login/", auth_views.LoginView.as_view(template_name="login.html"), name="login"),
    path("logout/", auth_views.LogoutView.as_view(next_page="login"), name="logout"),

    # UI principal
    path("", pui.DashboardView.as_view(), name="dashboard"),
    path("instances/", pui.InstanceListView.as_view(), name="instance-list"),
    path("instances/<int:pk>/", pui.InstanceDetailView.as_view(), name="instance-detail"),
    path("operations/", pui.OperationListView.as_view(), name="operation-list"),
    path("operations/<int:pk>/", pui.OperationDetailView.as_view(), name="operation-detail"),
    path("notifications/", pui.NotificationListView.as_view(), name="notification-list"),
    path("plantillas/", pui.SubProcessTemplateListView.as_view(), name="template-list"),
    path("documentos/", pui.ManagerDocumentListView.as_view(), name="document-list"),

    # API
    path("api/token/", TokenObtainPairView.as_view(), name="token_obtain_pair"),
    path("api/token/refresh/", TokenRefreshView.as_view(), name="token_refresh"),
    path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path("api/docs/", SpectacularSwaggerView.as_view(url_name="schema"), name="swagger-ui"),
    path("api/", include("processes.urls")),
]

if settings.DEBUG:
    urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
