from django import forms
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Submit
from .models import AcademicPeriod, Career, Document, User

class OperationCompleteForm(forms.Form):
    confirm = forms.BooleanField(label="Marcar como completada")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_method = "post"
        #  ----- cambia label -> value para distinguir -----
        self.helper.add_input(Submit("complete", "Completar"))

class DocumentUploadForm(forms.ModelForm):
    class Meta:
        model = Document
        fields = ("file",)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_method = "post"
        self.helper.add_input(Submit("submit", "Subir archivo"))


class DocumentRejectForm(forms.Form):
    comment = forms.CharField(
        label="Observación",
        widget=forms.Textarea(attrs={"rows": 3}),
        help_text="Explica qué debe corregir el participante.",
    )

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_method = "post"
        self.helper.add_input(Submit("reject", "Rechazar documento"))


class SubProcessStartForm(forms.Form):
    career = forms.ModelChoiceField(queryset=Career.objects.all(), label="Carrera")
    period = forms.ModelChoiceField(queryset=AcademicPeriod.objects.all(), label="Período académico")
    participants = forms.ModelMultipleChoiceField(
        queryset=User.objects.filter(role=User.Role.PARTICIPANT),
        label="Participantes",
        required=False,
        widget=forms.CheckboxSelectMultiple,
        help_text="Selecciona los participantes que recibirán las operaciones del subproceso.",
    )

    def __init__(self, *args, template=None, **kwargs):
        super().__init__(*args, **kwargs)
        if template:
            has_dynamic_participants = template.operation_templates.filter(
                actor_templates__role=User.Role.PARTICIPANT,
                actor_templates__participant__isnull=True,
            ).exists()
            self.fields["participants"].required = has_dynamic_participants
            if has_dynamic_participants:
                self.fields["participants"].help_text = (
                    "Este subproceso tiene operaciones para participantes; "
                    "selecciona al menos uno."
                )

