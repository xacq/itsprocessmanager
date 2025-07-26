A) Crea la carpeta de trabajo
mkdir C:\Proyectos\ist_process_manager
cd C:\Proyectos\ist_process_manager

B) Crea y activa un entorno virtual
python -m venv venv
.\venv\Scripts\activate 

PAQUETES A INSTALAR
pip install --upgrade pip
pip install django==4.2 mysqlclient python-dotenv
pip install djangorestframework django-cron
pip install djangorestframework drf-spectacular drf-spectacular-sidecar //API REST

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

Comando CLI instantiate_spi
    processes/management/commands/instantiate_spi.py

Migraciones y prueba rápida

python manage.py makemigrations
python manage.py migrate

# crea algún Career, AcademicPeriod y SubProcessTemplate con OperationTemplates
python manage.py instantiate_spi <tpl_id> <career_id> <period_id> <gestor_id>

# comprueba operaciones creadas
python manage.py shell -c "from processes.models import SubProcessInstance as S; print(S.objects.last().operation_instances.all())"

# simula cron (opcional)
python manage.py runcrons