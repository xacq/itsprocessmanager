# 1 A) Crea la carpeta de trabajo
mkdir C:\Proyectos\ist_process_manager
cd C:\Proyectos\ist_process_manager

# 1 B) Crea y activa un entorno virtual
python -m venv venv
.\venv\Scripts\activate 

PAQUETES A INSTALAR
pip install --upgrade pip
pip install django==4.2 mysqlclient python-dotenv
pip install djangorestframework django-cron

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

