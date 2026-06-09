# processes/admin.py
from django import forms
from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from django.core.exceptions import PermissionDenied
from django.utils.html import format_html
from django.utils.translation import gettext_lazy as _

from .models import (
    AcademicPeriod,
    Career,
    MacroProcess,
    OperationActorTemplate,
    OperationTemplate,
    Process,
    ProcessInstitution,
    StorageType,
    SubProcessTemplate,
    User,
)


def is_manager(user):
    return not user.is_superuser and getattr(user, "role", None) == User.Role.MANAGER


class ManagerOwnProcessMixin:
    """Limita al gestor a los procesos que tiene asignados."""

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if is_manager(request.user):
            return qs.filter(process__manager=request.user)
        return qs

    def has_add_permission(self, request):
        if is_manager(request.user):
            return True
        return super().has_add_permission(request)


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    fieldsets = (
        (None, {"fields": ("username", "password")}),
        (_("Información personal"), {"fields": ("first_name", "last_name", "email", "id_number")}),
        (_("Permisos"), {"fields": ("is_active", "is_staff", "is_superuser", "groups", "user_permissions")}),
        (_("Fechas importantes"), {"fields": ("last_login", "date_joined")}),
        (_("Rol del sistema"), {"fields": ("role",)}),
    )
    add_fieldsets = (
        (None, {
            "classes": ("wide",),
            "fields": ("username", "password1", "password2", "role", "id_number", "is_staff", "is_superuser"),
        }),
    )
    list_display = ("username", "email", "role", "is_staff", "is_active")
    list_filter = ("role", "is_staff", "is_superuser", "is_active", "groups")
    search_fields = ("username", "email", "id_number")
    ordering = ("username",)

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if is_manager(request.user):
            return qs.filter(role=User.Role.PARTICIPANT)
        return qs

    def get_fieldsets(self, request, obj=None):
        if is_manager(request.user):
            if obj is None:
                return (
                    (None, {"classes": ("wide",), "fields": ("username", "password1", "password2", "id_number", "email")}),
                )
            return (
                (None, {"fields": ("username", "password")}),
                (_("Información personal"), {"fields": ("first_name", "last_name", "email", "id_number")}),
                (_("Permisos"), {"fields": ("is_active",)}),
            )
        return super().get_fieldsets(request, obj)

    def formfield_for_choice_field(self, db_field, request, **kwargs):
        if db_field.name == "role" and is_manager(request.user):
            kwargs["choices"] = [(User.Role.PARTICIPANT, "Participante de la operación")]
        return super().formfield_for_choice_field(db_field, request, **kwargs)

    def has_change_permission(self, request, obj=None):
        if is_manager(request.user) and obj is not None:
            return obj.role == User.Role.PARTICIPANT
        return super().has_change_permission(request, obj)

    def has_delete_permission(self, request, obj=None):
        if is_manager(request.user):
            return obj is not None and obj.role == User.Role.PARTICIPANT
        return super().has_delete_permission(request, obj)

    def save_model(self, request, obj, form, change):
        if is_manager(request.user):
            if change and obj.role != User.Role.PARTICIPANT:
                raise PermissionDenied("Los gestores solo pueden administrar participantes.")
            obj.role = User.Role.PARTICIPANT
            obj.is_staff = False
            obj.is_superuser = False
        super().save_model(request, obj, form, change)


class TimeStampedMixin(admin.ModelAdmin):
    readonly_fields = ("created_at", "updated_at")
    ordering = ("id",)


class SubProcessTemplateInline(admin.TabularInline):
    model = SubProcessTemplate
    extra = 0
    show_change_link = True

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if is_manager(request.user):
            return qs.filter(process__manager=request.user)
        return qs


class OperationTemplateInline(admin.TabularInline):
    model = OperationTemplate
    extra = 0
    show_change_link = True
    ordering = ("order",)
    fields = ("order", "name", "type", "deadline_days", "storage_type", "requires_approval")


class OperationActorTemplateInline(admin.TabularInline):
    model = OperationActorTemplate
    extra = 1
    fields = ("role", "participant", "is_emitter", "is_receiver")

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "participant":
            kwargs["queryset"] = User.objects.filter(role=User.Role.PARTICIPANT)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)


class ManagerRestrictionMixin:
    def has_add_permission(self, request):
        if is_manager(request.user):
            return False
        return super().has_add_permission(request)

    def has_change_permission(self, request, obj=None):
        if is_manager(request.user):
            return False
        return super().has_change_permission(request, obj)

    def has_delete_permission(self, request, obj=None):
        if is_manager(request.user):
            return False
        return super().has_delete_permission(request, obj)


@admin.register(ProcessInstitution)
class ProcessInstitutionAdmin(ManagerRestrictionMixin, TimeStampedMixin):
    list_display = ("code", "name", "created_at")
    search_fields = ("code", "name")


@admin.register(MacroProcess)
class MacroProcessAdmin(ManagerRestrictionMixin, TimeStampedMixin):
    list_display = ("code", "name", "process_institution", "created_at")
    list_filter = ("process_institution",)
    search_fields = ("code", "name")


class ProcessAdminForm(forms.ModelForm):
    class Meta:
        model = Process
        fields = "__all__"

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.fields["manager"].queryset = User.objects.filter(role=User.Role.MANAGER)


@admin.register(Process)
class ProcessAdmin(TimeStampedMixin):
    form = ProcessAdminForm
    list_display = ("code", "name", "macro_process", "manager_badge")
    list_filter = ("macro_process__process_institution",)
    search_fields = ("code", "name", "manager__username")
    inlines = (SubProcessTemplateInline,)

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if is_manager(request.user):
            return qs.filter(manager=request.user)
        return qs

    def has_add_permission(self, request):
        if is_manager(request.user):
            return False
        return super().has_add_permission(request)

    def has_change_permission(self, request, obj=None):
        if is_manager(request.user):
            return obj is not None and obj.manager_id == request.user.id
        return super().has_change_permission(request, obj)

    def has_delete_permission(self, request, obj=None):
        if is_manager(request.user):
            return False
        return super().has_delete_permission(request, obj)

    def manager_badge(self, obj):
        name = obj.manager.get_full_name() or obj.manager.username
        color = "#0d6efd" if obj.manager.role == User.Role.MANAGER else "#dc3545"
        return format_html("<b style='color:{}'>{}</b>", color, name)

    manager_badge.short_description = "Gestor responsable"


@admin.register(SubProcessTemplate)
class SubProcessTemplateAdmin(TimeStampedMixin):
    list_display = ("name", "process", "created_by", "created_at")
    list_filter = ("process__macro_process__process_institution",)
    search_fields = ("name", "process__name")
    inlines = (OperationTemplateInline,)

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if is_manager(request.user):
            return qs.filter(process__manager=request.user)
        return qs

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "process" and is_manager(request.user):
            kwargs["queryset"] = Process.objects.filter(manager=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)

    def save_model(self, request, obj, form, change):
        if is_manager(request.user):
            obj.created_by = request.user
            if obj.process.manager_id != request.user.id:
                raise PermissionDenied("Solo puedes modelar procesos asignados a tu usuario.")
        super().save_model(request, obj, form, change)


@admin.register(OperationTemplate)
class OperationTemplateAdmin(admin.ModelAdmin):
    list_display = ("subprocess_template", "order", "name", "type", "deadline_days")
    list_filter = ("type",)
    search_fields = ("name", "subprocess_template__name")
    ordering = ("subprocess_template", "order")
    inlines = (OperationActorTemplateInline,)

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if is_manager(request.user):
            return qs.filter(subprocess_template__process__manager=request.user)
        return qs

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "subprocess_template" and is_manager(request.user):
            kwargs["queryset"] = SubProcessTemplate.objects.filter(process__manager=request.user)
        if db_field.name == "storage_type" and is_manager(request.user):
            kwargs["queryset"] = StorageType.objects.filter(subprocess_template__process__manager=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)


@admin.register(OperationActorTemplate)
class OperationActorTemplateAdmin(admin.ModelAdmin):
    list_display = ("operation_template", "role", "participant", "is_emitter", "is_receiver")
    list_filter = ("role",)

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if is_manager(request.user):
            return qs.filter(operation_template__subprocess_template__process__manager=request.user)
        return qs

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "participant":
            kwargs["queryset"] = User.objects.filter(role=User.Role.PARTICIPANT)
        if db_field.name == "operation_template" and is_manager(request.user):
            kwargs["queryset"] = OperationTemplate.objects.filter(
                subprocess_template__process__manager=request.user
            )
        return super().formfield_for_foreignkey(db_field, request, **kwargs)


@admin.register(StorageType)
class StorageTypeAdmin(TimeStampedMixin):
    list_display = ("name", "permanent", "subprocess_template", "created_at")
    list_filter = ("permanent", "subprocess_template__process__name")
    search_fields = ("name",)

    def get_queryset(self, request):
        qs = super().get_queryset(request)
        if is_manager(request.user):
            return qs.filter(subprocess_template__process__manager=request.user)
        return qs

    def formfield_for_foreignkey(self, db_field, request, **kwargs):
        if db_field.name == "subprocess_template" and is_manager(request.user):
            kwargs["queryset"] = SubProcessTemplate.objects.filter(process__manager=request.user)
        return super().formfield_for_foreignkey(db_field, request, **kwargs)


admin.site.register(Career)
admin.site.register(AcademicPeriod)
