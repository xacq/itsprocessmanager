IST Process Manager – README
================================

> Aplicación web para la gestión completa de los procesos académicos del
> Instituto Superior Tecnológico Austro (PPP y Servicio Comunitario).

-----------------------------------------------------------------------
1 · Requisitos
-----------------------------------------------------------------------

Herramienta | Versión probada
----------- | ---------------
Python      | 3.10+
Django      | 4.2
MySQL       | 8+ (funciona con XAMPP)

-----------------------------------------------------------------------
2 · Instalación rápida
-----------------------------------------------------------------------

git clone https://github.com/xacq/itsprocessmanager.git
cd itsprocessmanager

python -m venv venv
venv\Scripts\activate 
pip install -r requirements.txt

Configura la conexión MySQL en `config/settings.py`

Crea la base vacía:

CREATE DATABASE ist_austro CHARACTER SET utf8mb4;

Luego:

python manage.py makemigrations
python manage.py migrate
python manage.py createsuperuser        # id = 1  (ADMIN)
python manage.py loaddata processes/fixtures/initial.json


Se cargarán:

* 6 SubProcessTemplates (Planificación, Ejecución, Informe, Certificado, SC)
* 10 StorageTypes
* 17 OperationTemplates
* 36 OperationActorTemplates  
* 2 carreras de demo y un período 2025-1

-----------------------------------------------------------------------
3 · Usuarios de ejemplo
-----------------------------------------------------------------------

Rol          | Usuario | Contraseña
------------ | ------- | ----------
Admin        | admin   | la que definas en `createsuperuser`
Gestor       | gestor  | Gestor123!
Participante | alumno  | Alumno123!

*(Si no existen crea el Gestor y Participante desde `/admin/`)*

-----------------------------------------------------------------------
4 · Ejecutar
-----------------------------------------------------------------------

```bash
python manage.py runserver
```

* **http://127.0.0.1:8000/admin/** → carga/edita catálogos.
* **/login/** → ingresa como gestor para iniciar subprocesos.
* **/templates/<id>/start/** → formulario “Iniciar” (selecciona carrera y período).
* Los participantes ven sus operaciones en **/instances/** y cargan evidencias.
* El gestor revisa y aprueba; el cron marca `LATE` si vence el plazo:

```bash
python manage.py runcrons   # se programa cada día por django-cron
```

-----------------------------------------------------------------------
5 · Estructura de carpetas
-----------------------------------------------------------------------

```
processes/
 ├─ admin.py            # configuración admin + inlines
 ├─ models.py           # User, jerarquía, plantillas, motor
 ├─ services.py         # instantiate_subprocess()
 ├─ signals.py          # actualiza estado + notifica
 ├─ tasks.py            # cron que marca operaciones LATE
 ├─ views_ui.py         # Dashboard, Instancias, Operaciones
 ├─ templates/          # base.html, dashboard.html, etc.
 └─ fixtures/initial.json
```

-----------------------------------------------------------------------
6 · API REST (opcional)
-----------------------------------------------------------------------

El proyecto incluye DRF y drf-spectacular.
Cuando se añadan los *ViewSets* aparecerá el schema en:

```
/api/schema/      –  OpenAPI 3 JSON
/api/docs/        –  Swagger UI
```

-----------------------------------------------------------------------
9 · Despliegue
-----------------------------------------------------------------------

1. Instala MySQL y Python en el servidor.
2. Sube el proyecto y el archivo `initial.json`.
3. Ejecuta :

```bash
python -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python manage.py migrate
python manage.py loaddata processes/fixtures/initial.json

-----------------------------------------------------------------------
10 · Licencia
-----------------------------------------------------------------------

MIT © 2025 IST Austro / Autor original.

        

A) Crea la carpeta de trabajo
mkdir C:\Proyectos\ist_process_manager
cd C:\Proyectos\ist_process_manager

B) Crea y activa un entorno virtual
python -m venv venv
\venv\Scripts\activate 

PAQUETES A INSTALAR
pip install --upgrade pip

django-admin startproject config .
python manage.py startapp processes

CREATE DATABASE ist_austro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

Luego de generar los modelos

python manage.py makemigrations          # genera migraciones para processes
python manage.py migrate                 # crea tablas en MySQL
python manage.py createsuperuser         # sigue el asistente

python manage.py runserver

Si se necesita el admin:
http://127.0.0.1:8000/admin/
colocar los datos del superuser

*************************SEGUNDA ENTREGA*************************
Comando CLI instantiate_spi
    processes/management/commands/instantiate_spi.py

Asignar rol al super‑usuario ejecuta la primera instruccion que esta a continuacion, y luego ejecuta cada instruccion una por una,
luego despues de ejecutar con enter la u.save(), aplastar Ctrl + Z para salir del Shell de python

python manage.py shell

>>> from django.contrib.auth import get_user_model
>>> u = get_user_model().objects.get(username="procesos")
>>> u.role = "ADMIN"; u.is_staff = True
>>> u.save()

Ejecutar para ver el IST Process Manager API

http://127.0.0.1:8000/api/

http://127.0.0.1:8000/api/docs/

http://127.0.0.1:8000/api/?format=json

http://127.0.0.1:8000/dashboard

*************************TERCERA ENTREGA*************************
VER IMAGEN Imagen de la primer instanciación.png en carpeta evidencias

USAURIOS ACTUALES
    SUPERUSER      
    username="admin",
    password="123Qwerty$%^",
    role=User.Role.ADMIN

    username="gestor",
    password="Gestor123!",   
    role=User.Role.MANAGER,



