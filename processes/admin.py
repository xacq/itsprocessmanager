# processes/admin.py
from django.contrib import admin
from django.utils.html import format_html
from django.utils.translation import gettext_lazy as _

from .models import (
    User,
    ProcessInstitution, MacroProcess, Process,
    SubProcessTemplate, StorageType,
    OperationTemplate, OperationActorTemplate,
    Career, AcademicPeriod,
)

# ───────────────────────────────────────────────────────────────────────────
# 1.  USER ADMIN
# ───────────────────────────────────────────────────────────────────────────
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        (_("Información personal"),
         {"fields": ("first_name", "last_name", "email", "id_number")}),
        (_("Permisos"),
         {"fields": ("is_active", "is_staff", "is_superuser",
                     "groups", "user_permissions")}),
        (_("Fechas importantes"), {"fields": ("last_login", "date_joined")}),
        (_("Rol del sistema"), {"fields": ("role",)}),
    )
    add_fieldsets = (
        (None, {
            "classes": ("wide",),
            "fields": ("username", "password1", "password2",
                       "role", "id_number", "is_staff", "is_superuser"),
        }),
    )
    list_display = ("username", "email", "role", "is_staff", "is_active")
    list_filter = ("role", "is_staff", "is_superuser", "is_active", "groups")
    search_fields = ("username", "email", "id_number")
    ordering = ("username",)


# ───────────────────────────────────────────────────────────────────────────
# 2.  MIXIN FECHAS
# ───────────────────────────────────────────────────────────────────────────
class TimeStampedMixin(admin.ModelAdmin):
    readonly_fields = ("created_at", "updated_at")
    ordering = ("id",)


# ───────────────────────────────────────────────────────────────────────────
# 3.  INLINES
# ───────────────────────────────────────────────────────────────────────────
class SubProcessTemplateInline(admin.TabularInline):
    model = SubProcessTemplate
    extra = 0
    show_change_link = True


class OperationTemplateInline(admin.TabularInline):
    model = OperationTemplate
    extra = 0
    show_change_link = True
    ordering = ("order",)
    fields = ("order", "name", "type", "deadline_days", "requires_approval")


class OperationActorTemplateInline(admin.TabularInline):
    model = OperationActorTemplate
    extra = 1


# ───────────────────────────────────────────────────────────────────────────
# 4.  ADMIN DE CATÁLOGO JERÁRQUICO
# ───────────────────────────────────────────────────────────────────────────
@admin.register(ProcessInstitution)
class ProcessInstitutionAdmin(TimeStampedMixin):
    list_display = ("code", "name", "created_at")
    search_fields = ("code", "name")


@admin.register(MacroProcess)
class MacroProcessAdmin(TimeStampedMixin):
    list_display = ("code", "name", "process_institution", "created_at")
    list_filter = ("process_institution",)
    search_fields = ("code", "name")


@admin.register(Process)
class ProcessAdmin(TimeStampedMixin):
    list_display = ("code", "name", "macro_process", "manager_badge")
    list_filter = ("macro_process__process_institution",)
    search_fields = ("code", "name", "manager__username")
    inlines = (SubProcessTemplateInline,)

    def manager_badge(self, obj):
        color = "green" if obj.manager.role == obj.manager.Role.MANAGER else "red"
        return format_html("<b style='color:{}'>{}</b>", color, obj.manager.get_full_name())

    manager_badge.short_description = "Gestor"


# ───────────────────────────────────────────────────────────────────────────
# 5.  PLANTILLAS Y OPERACIONES
# ───────────────────────────────────────────────────────────────────────────
@admin.register(SubProcessTemplate)
class SubProcessTemplateAdmin(TimeStampedMixin):
    list_display = ("name", "process", "created_by", "created_at")
    list_filter = ("process__macro_process__process_institution",)
    search_fields = ("name", "process__name")
    inlines = (OperationTemplateInline,)


@admin.register(OperationTemplate)
class OperationTemplateAdmin(admin.ModelAdmin):
    list_display = ("subprocess_template", "order", "name", "type", "deadline_days")
    list_filter = ("type",)
    search_fields = ("name", "subprocess_template__name")
    ordering = ("subprocess_template", "order")
    inlines = (OperationActorTemplateInline,)          # ← ahora sí aparece el inline


@admin.register(OperationActorTemplate)
class OperationActorTemplateAdmin(admin.ModelAdmin):
    list_display = ("operation_template", "role", "is_emitter", "is_receiver")
    list_filter = ("role",)


# ───────────────────────────────────────────────────────────────────────────
# 6.  APOYO
# ───────────────────────────────────────────────────────────────────────────
@admin.register(StorageType)
class StorageTypeAdmin(TimeStampedMixin):
    list_display = ("name", "permanent", "subprocess_template", "created_at")
    list_filter = ("permanent", "subprocess_template__process__name")
    search_fields = ("name",)


admin.site.register(Career)
admin.site.register(AcademicPeriod)
