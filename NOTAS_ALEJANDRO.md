# Notas para Alejandro - Estado del Proyecto

## Estado Actual (19/10/2025)

### Estructura Implementada

- Backend Django configurado con:
  - Autenticación JWT
  - CORS para frontend
  - Swagger/OpenAPI para documentación
  - Debug toolbar para desarrollo
- Apps creadas:
  - `authentication/`: Gestión de usuarios
  - `inventory/`: Control de productos
  - `sales/`: Registro de ventas

### Últimos Cambios

1. Modelo Usuario implementado:
   - Email como identificador principal
   - Roles ADMIN/VENDEDOR
   - Campos de auditoría (fechas, estado activo)
   - Panel de admin personalizado

### Siguiente Paso (Bloqueante)

**Se requiere PostgreSQL para continuar:**

1. Instalar PostgreSQL 15
2. Crear base de datos `mundo_cartas_db`
3. Configurar `.env` con credenciales

### Para Continuar el Desarrollo

1. Instalar PostgreSQL:

   ```bash
   # Windows: Descargar e instalar de postgresql.org
   # Versión requerida: 15.x
   ```

2. Crear base de datos:

   ```sql
   CREATE DATABASE mundo_cartas_db;
   ```

3. Configurar `.env`:

   ```
   DB_NAME=mundo_cartas_db
   DB_USER=tu_usuario
   DB_PASSWORD=tu_password
   DB_HOST=localhost
   DB_PORT=5432
   ```

4. Activar entorno virtual:

   ```cmd
   cd backend
   venv\Scripts\activate
   ```

5. Ejecutar migraciones:
   ```cmd
   python manage.py makemigrations
   python manage.py migrate
   ```

### Puntos a Considerar

- El modelo Usuario es crítico, revisar bien antes de migrar
- Tenemos tests pendientes de implementar
- Las URLs están preparadas pero vacías
- La documentación Swagger se activará al migrar

## Para el Agente IA

- Branch actual: `develop`
- Último commit: Implementación del modelo Usuario
- Siguientes tareas en `DESARROLLO.md`
- Archivos clave comentados en español

## Recursos

- `.env.example` tiene todas las variables necesarias
- `DESARROLLO.md` tiene la guía técnica completa
- Documentación en cada app explica su propósito
