# Guía de Instalación y Continuación del Proyecto

## Estado Actual del Proyecto (19/10/2025)

### Estructura Implementada

```
proyecto-mundo-cartas/
├── backend/
│   ├── mundo_cartas_backend/    # Configuración principal
│   │   ├── settings.py         # Configuración Django
│   │   ├── urls.py            # URLs principales
│   │   ├── wsgi.py            # Config despliegue
│   │   └── asgi.py            # Config async
│   ├── authentication/         # App de usuarios
│   │   ├── models.py          # Modelo Usuario
│   │   ├── admin.py           # Panel admin
│   │   └── urls.py            # URLs (vacío)
│   ├── inventory/             # App de productos
│   │   └── urls.py            # URLs (vacío)
│   └── sales/                 # App de ventas
│       └── urls.py            # URLs (vacío)
└── docs/
    └── POR_QUE_POSTGRESQL.md  # Explicación técnica DB
```

## Requisitos Previos

### Python

- Versión 3.11 o superior
- Verificar con: `python --version`

### Git

- Última versión estable
- Configurado con tus credenciales

### PostgreSQL 15

1. **¿Por qué PostgreSQL 15?**

   - Versión LTS (soporte largo plazo)
   - Compatibilidad probada con Django 4.2
   - Mejoras significativas en rendimiento

2. **¿Por qué el instalador EnterpriseDB?**
   - Es el instalador oficial mantenido por PostgreSQL
   - Incluye todas las herramientas necesarias
   - Configura automáticamente el sistema
   - Instala pgAdmin 4 (interfaz gráfica)

## Instalación Paso a Paso

### 1. PostgreSQL

1. Descargar instalador:

   - Ir a: https://www.postgresql.org/download/windows/
   - Seleccionar "Download the installer"
   - Elegir "Windows x86-64" para versión 15.x

2. Ejecutar instalador:

   - Ejecutar como administrador
   - Componentes a instalar:
     - PostgreSQL Server
     - pgAdmin 4
     - Command Line Tools
     - Stack Builder
   - Puerto: 5432 (default)
   - Contraseña: crear una segura y guardarla

3. Verificar instalación:
   ```cmd
   psql --version
   ```

### 2. Configuración del Proyecto

1. Clonar repositorio (si no lo has hecho):

   ```cmd
   git clone https://github.com/Angel1819/proyecto-mundo-cartas.git
   cd proyecto-mundo-cartas
   git checkout develop
   ```

2. Crear entorno virtual:

   ```cmd
   cd backend
   python -m venv venv
   venv\Scripts\activate
   ```

3. Instalar dependencias:

   ```cmd
   pip install -r requirements.txt
   ```

4. Crear base de datos:

   - Abrir pgAdmin 4
   - Servers → PostgreSQL → Databases
   - Click derecho → Create → Database
   - Name: mundo_cartas_db

5. Configurar .env:
   ```env
   # Copiar .env.example a .env y editar:
   DB_NAME=mundo_cartas_db
   DB_USER=postgres
   DB_PASSWORD=tu_password
   DB_HOST=localhost
   DB_PORT=5432
   ```

### 3. Inicializar Base de Datos

1. Crear migraciones:

   ```cmd
   python manage.py makemigrations
   ```

2. Aplicar migraciones:

   ```cmd
   python manage.py migrate
   ```

3. Crear superusuario:

   ```cmd
   python manage.py createsuperuser
   ```

4. Iniciar servidor:
   ```cmd
   python manage.py runserver
   ```

## Verificación

1. Panel Admin:

   - Ir a: http://localhost:8000/admin
   - Login con superusuario
   - Verificar modelo Usuario

2. Documentación API:
   - Swagger UI: http://localhost:8000/swagger/
   - ReDoc: http://localhost:8000/redoc/

## Siguientes Pasos

1. **Sprint 1 - Autenticación:**

   - Implementar endpoints JWT en `authentication/views.py`
   - Configurar serializers para Usuario
   - Agregar tests de autenticación

2. **Sprint 2 - Inventario:**
   - Crear modelos de Producto y Categoría
   - Implementar endpoints CRUD
   - Configurar permisos por rol

Las tareas están pensadas para ser desarrolladas secuencialmente porque:

- La autenticación es base para todo
- Los permisos dependen de los roles
- El inventario necesita usuarios autenticados
- Las ventas dependen del inventario

## Recursos Adicionales

- `DESARROLLO.md`: Guía técnica completa
- `POR_QUE_POSTGRESQL.md`: Explicación de decisiones DB
- `.github/copilot-instructions.md`: Guía para agentes IA

## Notas para el Agente IA

1. El proyecto usa:

   - Django 4.2 con DRF
   - PostgreSQL 15
   - JWT para autenticación

2. Convenciones:

   - Código comentado en español
   - Modelos con nombres en español
   - Commits semánticos (feat:, fix:, docs:)

3. Archivos clave:

   - `settings.py`: Configuración principal
   - `models.py`: Modelo Usuario personalizado
   - `urls.py`: Endpoints de la API

4. Branch actual: `develop`
