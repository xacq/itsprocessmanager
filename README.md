# IST Process Manager

> Aplicación web para la gestión completa de los procesos académicos del Instituto Superior Tecnológico Austro (Prácticas Pre-Profesionales y Servicio Comunitario).

---

## 📋 Requisitos

| Herramienta | Versión Requerida |
|-------------|-------------------|
| Python      | 3.10+             |
| Django      | 4.2               |
| MySQL       | 8+ (funciona con XAMPP) |

---

## 🚀 Instalación Rápida

### 1. Clonar el Repositorio

```bash
git clone https://github.com/xacq/itsprocessmanager.git
cd itsprocessmanager
```

### 2. Crear y Activar Entorno Virtual

**Windows (PowerShell):**

```powershell
python -m venv venv
.\venv\Scripts\Activate.ps1
```

**Linux/Mac:**

```bash
python -m venv venv
source venv/bin/activate
```

### 3. Instalar Dependencias

```bash
pip install -r requirements.txt
```

### 4. Configurar Base de Datos

Crea el archivo `.env` en la raíz del proyecto:

```env
DB_NAME=ist_austro
DB_USER=root
DB_PASS=
```

Crea la base de datos en MySQL:

```sql
CREATE DATABASE ist_austro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

### 5. Ejecutar Migraciones

```bash
python manage.py migrate
```

### 6. Crear Usuarios Iniciales

**IMPORTANTE:** El modelo User requiere el campo `id_number` (cédula/DNI) único.

#### Crear Superusuario (ADMIN - ID=1)

```bash
python manage.py createsuperuser --username admin --email admin@istausto.edu.ec --noinput
```

Luego configurar contraseña y rol:

```bash
python manage.py shell
```

```python
from processes.models import User

# Configurar admin
u = User.objects.get(username='admin')
u.set_password('123Qwerty$%^')
u.id_number = '0000000001'
u.role = 'ADMIN'
u.is_staff = True
u.is_superuser = True
u.save()
print(f'Admin configurado: ID={u.pk}, role={u.role}')
exit()
```

#### Crear Usuario Gestor (MANAGER - ID=2)

```bash
python manage.py shell
```

```python
from processes.models import User
from django.db import connection

# Crear gestor con ID=2 (requerido por el fixture)
cursor = connection.cursor()
cursor.execute("""
    INSERT INTO processes_user 
    (id, password, last_login, is_superuser, username, first_name, last_name, email, is_staff, is_active, date_joined, id_number, role) 
    VALUES 
    (2, 'pbkdf2_sha256$870000$temp', NULL, 0, 'gestor', '', '', 'gestor@istausto.edu.ec', 1, 1, NOW(), '0000000002', 'MANAGER')
""")

# Actualizar con la contraseña correcta
gestor = User.objects.get(pk=2)
gestor.set_password('Gestor123!')
gestor.save()
print(f'Gestor creado: ID={gestor.pk}, username={gestor.username}, role={gestor.role}')
exit()
```

### 7. Cargar Datos Iniciales

```bash
python manage.py loaddata processes/fixtures/initial.json
```

**Se cargarán:**

- ✅ 1 ProcessInstitution
- ✅ 1 MacroProcess
- ✅ 1 Process (Prácticas Pre-Profesionales)
- ✅ 6 SubProcessTemplates
- ✅ 10 StorageTypes
- ✅ 17 OperationTemplates
- ✅ 36 OperationActorTemplates
- ✅ 2 Carreras de prueba (Tecnología en Redes, Contabilidad)
- ✅ 1 Período Académico (2025-1)

### 8. Crear Usuario Participante (Opcional)

```bash
python manage.py shell -c "from processes.models import User; alumno = User.objects.create_user(username='alumno', password='Alumno123!', email='alumno@istausto.edu.ec', role=User.Role.PARTICIPANT, id_number='1111111111'); print(f'Alumno creado: ID={alumno.pk}')"
```

---

## 👥 Usuarios de Ejemplo

| Rol | Username | Password | Email |
|-----|----------|----------|-------|
| Admin | admin | `123Qwerty$%^` | <admin@istausto.edu.ec> |
| Gestor | gestor | `Gestor123!` | <gestor@istausto.edu.ec> |
| Participante | alumno | `Alumno123!` | <alumno@istausto.edu.ec> |

---

## 🏃 Ejecutar el Servidor

```bash
python manage.py runserver
```

### URLs Disponibles

- **Panel Admin:** <http://127.0.0.1:8000/admin/>
- **API REST:** <http://127.0.0.1:8000/api/>
- **API Docs (Swagger):** <http://127.0.0.1:8000/api/docs/>
- **API Schema:** <http://127.0.0.1:8000/api/schema/>
- **Dashboard:** <http://127.0.0.1:8000/dashboard/>
- **Login:** <http://127.0.0.1:8000/login/>

---

## 📁 Estructura del Proyecto

```
itsprocessmanager/
├── config/                 # Configuración Django
│   ├── settings.py
│   ├── urls.py
│   └── wsgi.py
├── processes/              # App principal
│   ├── admin.py           # Configuración admin + inlines
│   ├── models.py          # User, jerarquía, plantillas, motor
│   ├── services.py        # instantiate_subprocess()
│   ├── signals.py         # Actualiza estado + notifica
│   ├── tasks.py           # Cron que marca operaciones LATE
│   ├── views.py           # API ViewSets (DRF)
│   ├── views_ui.py        # Dashboard, Instancias, Operaciones
│   ├── serializers.py     # Serializers DRF
│   ├── permissions.py     # Permisos personalizados
│   ├── api.py             # API adicional
│   ├── urls.py            # URLs de la app
│   ├── templates/         # Templates HTML
│   ├── fixtures/
│   │   └── initial.json   # Datos iniciales
│   └── migrations/
├── templates/             # Templates globales
├── .env                   # Variables de entorno
├── manage.py
└── requirements.txt
```

---

## 🔄 Flujo de Trabajo

1. **Gestor** inicia un subproceso desde `/templates/<id>/start/`
2. Selecciona carrera, período académico y participantes cuando la plantilla los requiere
3. Sistema crea automáticamente:
   - SubProcessInstance
   - OperationInstances
   - Asignaciones al gestor y a los participantes seleccionados
4. **Participantes** ven sus operaciones en `/instances/`
5. Cargan evidencias según el tipo de operación
6. **Gestor** revisa y aprueba documentos
7. Sistema actualiza estados y envía notificaciones

---

## ⏰ Tareas Programadas (Cron)

Para marcar operaciones vencidas como `LATE`:

```bash
python manage.py runcrons
```

En producción, programa esto como tarea diaria usando `django-cron`.

---

## 🌐 API REST

El proyecto incluye Django REST Framework y drf-spectacular.

### Endpoints Principales

- `/api/institutions/` - Instituciones
- `/api/macroprocesses/` - Macroprocesos
- `/api/processes/` - Procesos
- `/api/subprocess-templates/` - Plantillas de subprocesos
- `/api/subprocess-instances/` - Instancias de subprocesos
- `/api/operation-instances/` - Instancias de operaciones
- `/api/documents/` - Documentos
- `/api/notifications/` - Notificaciones

### Documentación Interactiva

- **Swagger UI:** <http://127.0.0.1:8000/api/docs/>
- **OpenAPI Schema:** <http://127.0.0.1:8000/api/schema/>

---

## 🚢 Despliegue en Producción

### 1. Preparar el Servidor

```bash
# Instalar dependencias del sistema
sudo apt update
sudo apt install python3.10 python3-pip python3-venv mysql-server

# Crear base de datos
sudo mysql
CREATE DATABASE ist_austro CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'istuser'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON ist_austro.* TO 'istuser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### 2. Configurar la Aplicación

```bash
# Clonar repositorio
git clone https://github.com/xacq/itsprocessmanager.git
cd itsprocessmanager

# Crear entorno virtual
python3 -m venv venv
source venv/bin/activate

# Instalar dependencias
pip install -r requirements.txt
pip install gunicorn

# Configurar .env
cat > .env << EOF
DB_NAME=ist_austro
DB_USER=istuser
DB_PASS=password
EOF

# Ejecutar migraciones
python manage.py migrate

# Crear usuarios (seguir pasos de instalación)
# Cargar datos iniciales
python manage.py loaddata processes/fixtures/initial.json

# Recolectar archivos estáticos
python manage.py collectstatic --noinput
```

### 3. Configurar Gunicorn

```bash
gunicorn config.wsgi:application --bind 0.0.0.0:8000 --workers 3
```

### 4. Configurar Nginx (Opcional)

```nginx
server {
    listen 80;
    server_name tu-dominio.com;

    location / {
        proxy_pass http://127.0.0.1:8000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }

    location /static/ {
        alias /ruta/a/itsprocessmanager/staticfiles/;
    }
}
```

---

## 🔧 Comandos Útiles

### Verificar Sistema

```bash
python manage.py check
```

### Crear Migraciones

```bash
python manage.py makemigrations
```

### Ver Usuarios

```bash
python manage.py shell -c "from processes.models import User; [print(f'{u.username} - {u.role}') for u in User.objects.all()]"
```

### Backup de Base de Datos

```bash
python manage.py dumpdata > backup.json
```

### Restaurar Backup

```bash
python manage.py loaddata backup.json
```

---

## 📝 Notas Importantes

> **IMPORTANTE:** El campo `id_number` es obligatorio y único para todos los usuarios. Asegúrate de proporcionar un valor único al crear nuevos usuarios.

> **NOTA:** El fixture `initial.json` requiere que existan usuarios con ID=1 (ADMIN) e ID=2 (MANAGER) antes de cargarlo.

---

## 📄 Licencia

MIT © 2025 Instituto Superior Tecnológico Austro

---

## 👨‍💻 Autor

Desarrollado para el Instituto Superior Tecnológico Austro
