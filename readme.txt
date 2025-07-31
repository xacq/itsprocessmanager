*************************PRIMERA ENTREGA*************************
A) Crea la carpeta de trabajo
mkdir C:\Proyectos\ist_process_manager
cd C:\Proyectos\ist_process_manager

B) Crea y activa un entorno virtual
python -m venv venv
.\venv\Scripts\activate 

PAQUETES A INSTALAR
pip install --upgrade pip
pip install django==4.2 mysqlclient python-dotenv

django-admin startproject config .
python manage.py startapp processes

CREATE DATABASE ist_austro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

Luego de generar los modelos

python manage.py makemigrations          # genera migraciones para processes
python manage.py migrate                 # crea tablas en MySQL
python manage.py createsuperuser         # sigue el asistente
SUPERUSER
procesos
procesos@gmail.com
123Qwerty$%^

python manage.py runserver

Si se necesita el admin:
http://127.0.0.1:8000/admin/
colocar los datos del superuser

Crear carpeta fixtures y con el archivo process_seed.json 

    python manage.py loaddata process_seed

# mantener 001 en los tres niveles produce el código jerárquico:
ProcessInstitution   → 001
MacroProcess         → 001   → 001.001
Process              → 001   → 001.001.001
Dentro de cada ámbito padre el sufijo debe ser único, pero empezar todo en 001 es totalmente válido para la primera rama.

*************************SEGUNDA ENTREGA*************************

PAQUETES A INSTALAR
pip install djangorestframework drf-spectacular drf-spectacular-sidecar //API REST
pip install django-crispy-forms crispy-bootstrap5  //UI Boostrap

Comando CLI instantiate_spi
    processes/management/commands/instantiate_spi.py

Asignar rol al super‑usuario ejecuta la primera instruccion que esta a continuacion, y luego ejecuta cada instruccion una por una,
luego despues de ejecutar con enter la u.save(), aplastar Ctrl + Z para salir del Shell de python

python manage.py shell

>>> from django.contrib.auth import get_user_model
>>> u = get_user_model().objects.get(username="procesos")
>>> u.role = "ADMIN"; u.is_staff = True
>>> u.save()

Migraciones y prueba rápida

python manage.py makemigrations
python manage.py migrate

Ejecutar para ver el IST Process Manager API

http://127.0.0.1:8000/api/

http://127.0.0.1:8000/api/docs/

http://127.0.0.1:8000/api/?format=json

http://127.0.0.1:8000/dashboard

*************************TERCERA ENTREGA*************************
PAQUETES A INSTALAR
pip install django-cron

Ejecuta el shell de python 

python manage.py shell

y codifica lo siguiente

from processes.models import Career, AcademicPeriod
Career.objects.get_or_create(name="Tecnología en Redes")
AcademicPeriod.objects.get_or_create(code="2025-1", start_date="2025-05-01", end_date="2025-09-30")

sales con Ctrl + Z

Si necesitas confirmar los IDs en la consola:
python manage.py shell -c "from processes.models import SubProcessTemplate, Career, AcademicPeriod, User; print(SubProcessTemplate.objects.values('id','name')); print(Career.objects.values('id','name')); print(AcademicPeriod.objects.values('id','code')); print(User.objects.filter(role='MANAGER').values('id','username'))"
<QuerySet [{'id': 1, 'name': 'Planificación PPP'}]>
<QuerySet [{'id': 1, 'name': 'Tecnología en Redes'}]>
<QuerySet [{'id': 1, 'code': '2025-1'}]>
<QuerySet [{'id': 2, 'username': 'gestor'}]>

Ejecuta la instanciación
(venv) PS C:\ist_process_manager> python manage.py instantiate_spi 1 1 1 2

Orden de argumentos →
<template_id> <career_id> <period_id> <gestor_id>
Si todo está en su sitio verás algo como:

SPI creado: 1

y en el admin aparecerá la nueva SubProcess instance con sus tres operaciones y deadlines. (esto ya esta realizado)

VER IMAGEN Imagen de la primer instanciación.png en carpeta evidencias

Ruta para Iniciar "Planificacion PPP"
http://127.0.0.1:8000/templates/1/start/




