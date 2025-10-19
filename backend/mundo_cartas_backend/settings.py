"""
Configuración principal del proyecto Mundo Cartas.
Este archivo contiene toda la configuración de Django, incluyendo:
- Configuración de base de datos
- Apps instaladas
- Middleware y seguridad
- Internacionalización
- y más...
"""

# os: Proporciona funciones para interactuar con el sistema operativo
# Usado aquí para manejar variables de entorno y rutas
import os

# Path: Clase para manejar rutas de archivos/directorios de forma segura
# Evita problemas con diferentes sistemas operativos (Windows/Linux)
from pathlib import Path

# timedelta: Clase para manejar duraciones de tiempo
# La usamos para configurar la duración de los tokens JWT
from datetime import timedelta

# Directorio base del proyecto
# Útil para construir rutas relativas a este archivo
BASE_DIR = Path(__file__).resolve().parent.parent

# Cargar variables de entorno desde archivo .env
# Esto permite configurar el proyecto sin hardcodear valores sensibles
from dotenv import load_dotenv
load_dotenv()

# Clave secreta para cifrado y sesiones
# IMPORTANTE: Debe ser cambiada en producción y nunca compartida
SECRET_KEY = os.getenv('SECRET_KEY', 'django-insecure-default-key-change-this')

# Modo debug: True en desarrollo, False en producción
# En producción, deshabilitar para evitar exponer información sensible
DEBUG = os.getenv('DEBUG', 'True') == 'True'

# Hosts permitidos para acceder a la aplicación
# En producción, especificar dominios exactos
ALLOWED_HOSTS = os.getenv('ALLOWED_HOSTS', 'localhost,127.0.0.1').split(',')

# Aplicaciones instaladas
INSTALLED_APPS = [
    # Apps Django por defecto
    'django.contrib.admin',        # Panel de administración
    'django.contrib.auth',         # Autenticación de usuarios
    'django.contrib.contenttypes', # Tipos de contenido genéricos
    'django.contrib.sessions',     # Manejo de sesiones
    'django.contrib.messages',     # Sistema de mensajes
    'django.contrib.staticfiles',  # Archivos estáticos
    
    # Apps de terceros
    'rest_framework',             # Framework REST API
    'rest_framework_simplejwt',   # Autenticación JWT
    'corsheaders',               # Manejo de CORS para frontend
    'django_filters',            # Filtrado avanzado de querysets
    'drf_yasg',                 # Documentación automática OpenAPI
    'debug_toolbar',            # Herramienta de depuración
    
    # Apps propias del proyecto
    'authentication',           # Gestión de usuarios y permisos
    'inventory',               # Control de inventario
    'sales',                   # Registro de ventas
]

MIDDLEWARE = [
    'debug_toolbar.middleware.DebugToolbarMiddleware',
    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',
    'django.middleware.csrf.CsrfViewMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
]

ROOT_URLCONF = 'mundo_cartas_backend.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'mundo_cartas_backend.wsgi.application'

# Database
DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql',
        'NAME': os.getenv('DB_NAME', 'mundo_cartas_db'),
        'USER': os.getenv('DB_USER', 'postgres'),
        'PASSWORD': os.getenv('DB_PASSWORD', ''),
        'HOST': os.getenv('DB_HOST', 'localhost'),
        'PORT': os.getenv('DB_PORT', '5432'),
    }
}

# Password validation
AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
LANGUAGE_CODE = 'es-cl'
TIME_ZONE = 'America/Santiago'
USE_I18N = True
USE_TZ = True

# Static files (CSS, JavaScript, Images)
STATIC_URL = 'static/'
STATIC_ROOT = BASE_DIR / 'staticfiles'

# Default primary key field type
DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# Custom user model
AUTH_USER_MODEL = 'authentication.Usuario'

# REST Framework settings
REST_FRAMEWORK = {
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_PERMISSION_CLASSES': (
        'rest_framework.permissions.IsAuthenticated',
    ),
    'DEFAULT_FILTER_BACKENDS': (
        'django_filters.rest_framework.DjangoFilterBackend',
    ),
    'DEFAULT_PAGINATION_CLASS': 'rest_framework.pagination.PageNumberPagination',
    'PAGE_SIZE': 100
}

# JWT settings
SIMPLE_JWT = {
    'ACCESS_TOKEN_LIFETIME': timedelta(minutes=15),
    'REFRESH_TOKEN_LIFETIME': timedelta(days=1),
    'ROTATE_REFRESH_TOKENS': True,
    'BLACKLIST_AFTER_ROTATION': True,
}

# CORS settings
CORS_ALLOWED_ORIGINS = [
    "http://localhost:3000",  # React default port
]
CORS_ALLOW_CREDENTIALS = True

# Debug toolbar settings
INTERNAL_IPS = [
    "127.0.0.1",
]