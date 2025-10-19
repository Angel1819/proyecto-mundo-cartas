# Guía de Desarrollo - Mundo Cartas

Este documento describe las decisiones técnicas y patrones de desarrollo utilizados en el proyecto.

## Estructura del Proyecto

```
backend/
├── mundo_cartas_backend/    # Configuración principal de Django
├── authentication/          # Gestión de usuarios y permisos
├── inventory/              # Control de inventario y productos
└── sales/                 # Registro y seguimiento de ventas

frontend/
├── src/
│   ├── components/        # Componentes React reutilizables
│   ├── pages/            # Páginas/rutas principales
│   └── services/         # Llamadas a API y lógica de negocio
```

## Decisiones Técnicas

### Backend (Django)

1. **Autenticación**:

   - JWT para tokens de acceso
   - Refresh tokens para mantener sesiones
   - Roles diferenciados (admin/vendedor)

2. **Base de Datos**:

   - PostgreSQL por su robustez y features avanzados
   - Triggers para auditoría automática
   - Índices para optimizar búsquedas frecuentes

3. **API REST**:

   - Django REST Framework
   - Versionado en URL (/api/v1/)
   - Documentación automática con Swagger

4. **Seguridad**:
   - CORS configurado solo para frontend
   - Variables sensibles en .env
   - Validaciones en modelo y serializer

### Frontend (React)

1. **Gestión de Estado**:

   - Context API para estado global
   - Local state para componentes

2. **Llamadas API**:

   - Axios con interceptors
   - Manejo centralizado de errores

3. **UI/UX**:
   - CSS Modules para estilos
   - Diseño responsive mobile-first

## Convenciones de Código

### Python/Django

- Modelos y campos en español
- Comentarios explicando el "por qué"
- Docstrings en clases importantes

### JavaScript/React

- camelCase para variables/funciones
- PascalCase para componentes
- Componentes funcionales + hooks

## Flujo de Trabajo Git

1. **Ramas**:

   - `main`: Producción
   - `develop`: Desarrollo activo
   - `feature/*`: Nuevas características
   - `fix/*`: Correcciones

2. **Commits**:
   - feat: Nueva funcionalidad
   - fix: Corrección de bugs
   - docs: Documentación
   - style: Formato de código
   - refactor: Mejoras de código

## Testing

### Backend

- Tests unitarios por modelo
- Tests de integración para API
- Coverage mínimo: 80%

### Frontend

- Tests de componentes
- Tests de integración
- E2E tests críticos

## Despliegue

1. **Backend**:

   - Gunicorn + Nginx
   - Docker para consistencia
   - Variables de entorno en .env

2. **Frontend**:
   - Build optimizado
   - CDN para assets
   - Cache strategies

## Monitoreo

- Sentry para errores
- Django Debug Toolbar en desarrollo
- Logs estructurados

## Siguiente Sprint

1. Implementar modelo Usuario
2. Configurar autenticación JWT
3. Crear endpoints base
4. Implementar tests unitarios
