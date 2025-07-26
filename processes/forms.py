from django import forms
from crispy_forms.helper import FormHelper
from crispy_forms.layout import Submit
from .models import Document

class OperationCompleteForm(forms.Form):
    confirm = forms.BooleanField(label="Marcar como completada")

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_method = "post"
        self.helper.add_input(Submit("submit", "Confirmar"))

class DocumentUploadForm(forms.ModelForm):
    class Meta:
        model = Document
        fields = ("file",)

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.helper = FormHelper()
        self.helper.form_method = "post"
        self.helper.add_input(Submit("submit", "Subir archivo"))
