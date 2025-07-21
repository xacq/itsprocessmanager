# 1 A) Crea la carpeta de trabajo
mkdir C:\Proyectos\ist_process_manager
cd C:\Proyectos\ist_process_manager

# 1 B) Crea y activa un entorno virtual
python -m venv venv
.\venv\Scripts\activate 

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



