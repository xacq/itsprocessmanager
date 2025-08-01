import os
from django import template

register = template.Library()

@register.filter(name="basename")
def basename(value):
    """Devuelve solo el nombre de archivo de un FileField."""
    return os.path.basename(getattr(value, "name", str(value)))
