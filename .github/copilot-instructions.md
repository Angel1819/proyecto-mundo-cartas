<!--
Guidance for AI coding agents working in this repository.
This file was generated automatically when the workspace was empty; update the examples and file references below once the project files exist.
-->

# Copilot instructions — proyecto-mundo-cartas (Sistema MVP para tienda de trading cards)

Purpose: Guiar a agentes AI en el desarrollo de un sistema web de inventario y ventas para Mundo Cartas (tienda física de trading cards en Chile), reemplazando hojas Excel con gestión en tiempo real, auditoría completa y roles diferenciados.

1. Quick repo discovery (what I do first)

- Documentación clave en `/documentacion_2.0/`:
  - `CONTEXTO.md`: Visión general y decisiones arquitectónicas
  - `SPRINT_PLANNING.md`: Cronograma y distribución de trabajo
  - `TAREAS_DETALLADAS.md`: Instrucciones técnicas paso a paso
  - `DB_MODEL_MUNDO_CARTAS.md`: Modelo de datos completo
- Stack técnico NO NEGOCIABLE:
  - Backend: Django 4.2 + DRF 3.14 + PostgreSQL 15
  - Frontend: React 18 + React Router 6 + Axios (JS, no TS)
  - JWT para autenticación (djangorestframework-simplejwt)

2. Big-picture architecture

- Backend Django apps:
  - `authentication/`: Gestión usuarios y roles (admin/vendedor)
  - `inventory/`: CRUD productos, categorías y movimientos
  - `sales/`: Ventas, detalles y métodos de pago
- Frontend React structure:
  - `src/components/`: Componentes reutilizables
  - `src/pages/`: Rutas principales
  - `src/services/`: Llamadas a API y lógica de negocio
- Base de datos: PostgreSQL con triggers para auditoría

3. Project-specific conventions

- Naming:
  - Django: Modelos y campos en español (ej: Usuario, nombre_completo)
  - React: PascalCase componentes, camelCase servicios
- Code style:
  - Python: Comentarios en español explicando el "por qué"
  - React: Componentes funcionales + hooks (no clases)
- Transacciones:
  - Usar `transaction.atomic()` para operaciones múltiples
  - `select_for_update()` para prevenir race conditions

4. Build / run / test commands

Backend (en Windows cmd):

```cmd
python -m venv venv
venv\Scripts\activate
pip install -r requirements.txt
python manage.py migrate
python manage.py runserver
```

Frontend:

```cmd
cd mundo-cartas-frontend
npm install
npm start
```

5. Integration points

- `.env` para URLs y credenciales:
  ```
  REACT_APP_API_URL=http://localhost:8000/api
  DB_NAME=mundo_cartas_db
  DB_USER=postgres
  DB_PASSWORD=tu_password
  ```
- JWT tokens en localStorage:
  - access_token (15min)
  - refresh_token (24h)

6. Safety rules

- NUNCA commitear `.env` ni credenciales reales
- Transacciones atómicas para ventas (todas las operaciones o ninguna)
- Evitar eliminación de registros (usar campo `activo = False`)
- Validaciones en modelo Y serializer (doble capa)
- Permisos basados en roles (admin vs vendedor)

7. Key files and locations

- `mundo_cartas_backend/settings.py`: Configuración Django
- `authentication/models.py`: Modelo Usuario extendido
- `inventory/models.py`: Categoria, Producto, MovimientoInventario
- `sales/models.py`: Venta, DetalleVenta, MetodoPago
- `src/App.js`: Rutas React y protección por roles
- `src/services/api.js`: Cliente axios configurado

8. Current development state

- Sprint 1 (Auth): ✅ Planificado, 0% implementado
- Sprint 2 (Inventory): ✅ Planificado, 0% implementado
- Sprint 3 (POS): ✅ Planificado, 0% implementado
- Sprints 4-7: ⏳ Pendientes de planificar

9. Useful checkpoints for commits

- Resumen de cambios y razón
- Tests ejecutados
- Estado de implementación vs planificación

Para detalles específicos de implementación, consultar primero:

1. `TAREAS_DETALLADAS.md`
2. `DB_MODEL_MUNDO_CARTAS.md`
3. `CONTEXTO.md`

-- End of instructions --
