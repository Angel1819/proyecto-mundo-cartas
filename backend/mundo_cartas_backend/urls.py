"""
URLs principales del proyecto Mundo Cartas.
Este archivo define todas las rutas principales de la API y la documentación.
"""

# admin: Módulo de Django para el panel de administración
from django.contrib import admin

# path: Función para definir URLs
# include: Función para incluir URLs de otras apps
from django.urls import path, include

# settings: Acceso a la configuración del proyecto
from django.conf import settings

# permissions: Clases para control de acceso a la API
from rest_framework import permissions

# drf_yasg: Generador automático de documentación OpenAPI/Swagger
# get_schema_view: Función para crear la vista de documentación
# openapi: Utilidades para definir la especificación OpenAPI
from drf_yasg.views import get_schema_view
from drf_yasg import openapi

# Configuración de Swagger/OpenAPI para documentación automática
# Esto genera una interfaz web interactiva para probar la API
schema_view = get_schema_view(
   openapi.Info(
      title="Mundo Cartas API",
      default_version='v1',
      description="API REST para sistema de gestión de Mundo Cartas",
      terms_of_service="https://www.google.com/policies/terms/",
      contact=openapi.Contact(email="alejandro.rosemberg@inacapmail.cl"),
      license=openapi.License(name="BSD License"),
   ),
   public=True,  # La documentación será accesible sin autenticación
   permission_classes=[permissions.AllowAny],
)

# Lista de URLs del proyecto
urlpatterns = [
    # Panel de administración de Django (útil para gestión manual de datos)
    path('admin/', admin.site.urls),
    
    # Documentación de la API en dos formatos:
    # 1. Swagger UI: Interfaz interactiva para desarrolladores
    path('swagger/', schema_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    # 2. ReDoc: Documentación más limpia para usuarios finales
    path('redoc/', schema_view.with_ui('redoc', cache_timeout=0), name='schema-redoc'),
    
    # Endpoints de la API agrupados por funcionalidad
    path('api/auth/', include('authentication.urls')),      # Autenticación y usuarios
    path('api/inventory/', include('inventory.urls')),      # Gestión de inventario
    path('api/sales/', include('sales.urls')),             # Registro de ventas
]

# Barra de depuración (solo en modo desarrollo)
# Útil para analizar consultas SQL, caché, y rendimiento
if settings.DEBUG:
    import debug_toolbar
    urlpatterns = [
        path('__debug__/', include(debug_toolbar.urls)),
    ] + urlpatterns