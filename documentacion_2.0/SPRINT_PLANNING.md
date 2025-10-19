# SPRINT PLANNING - MVP MUNDO CARTAS

**Proyecto:** Sistema de Gestión de Inventario y Ventas  
**Equipo:** Angel Alejandro (Backend) + Alejandro (Frontend)  
**Metodología:** Scrum con sprints semanales  
**Período total:** 19 de octubre - 12 de diciembre de 2025 (55 días)  
**Última actualización:** 19 de octubre de 2025, 2:45 AM  
**Versión:** 3.0 (con categorías dinámicas)

---

## 📋 ÍNDICE

1. [Resumen Ejecutivo](#resumen-ejecutivo)
2. [Cronograma General](#cronograma-general)
3. [Sprint 1: Autenticación y Autorización](#sprint-1-autenticación-y-autorización)
4. [Sprint 2: Inventario con Categorías Dinámicas](#sprint-2-inventario-con-categorías-dinámicas)
5. [Sprint 3: POS Simplificado](#sprint-3-pos-simplificado)
6. [Sprints Pendientes (4-7)](#sprints-pendientes-4-7)
7. [Métricas y Velocidad](#métricas-y-velocidad)
8. [Gráfico de Gantt](#gráfico-de-gantt)
9. [Gestión de Riesgos](#gestión-de-riesgos)

---

## RESUMEN EJECUTIVO

### Objetivo del Proyecto

Desarrollar un MVP funcional que permita a Mundo Cartas:

- Gestionar inventario de trading cards, juegos de mesa y accesorios
- Registrar ventas con actualización automática de stock
- Controlar acceso con roles diferenciados (administrador/vendedor)
- Generar reportes básicos del negocio

### Alcance MVP (Sprints 1-7)

**Sprints Completados (planificación):**

- ✅ Sprint 1: Sistema de autenticación con JWT y roles
- ✅ Sprint 2: CRUD de productos con categorías dinámicas y ajustes de stock
- ✅ Sprint 3: Punto de venta con múltiples métodos de pago

**Sprints Pendientes:**

- ⏳ Sprint 4: Sistema de reservas y apartados
- ⏳ Sprint 5: Reportes y análisis
- ⏳ Sprint 6: Notificaciones y alertas
- ⏳ Sprint 7: Pruebas finales y despliegue

### Equipo y Roles

| Miembro         | Rol                | Responsabilidades Principales                    |
| --------------- | ------------------ | ------------------------------------------------ |
| Angel Alejandro | Backend Developer  | Django, PostgreSQL, APIs REST, lógica de negocio |
| Alejandro       | Frontend Developer | React, UI/UX, integración con APIs               |

**Trabajo Estimado:** 5 horas/día por persona (35 horas/semana equipo completo)

---

## CRONOGRAMA GENERAL

### Calendario de Sprints

| Sprint       | Épica Principal              | Fechas         | Duración | Horas | Estado         |
| ------------ | ---------------------------- | -------------- | -------- | ----- | -------------- |
| **Sprint 1** | Autenticación y Autorización | 19-25 oct      | 7 días   | 35h   | ✅ Planificado |
| **Sprint 2** | Inventario Esencial          | 27 oct - 2 nov | 7 días   | 41h   | ✅ Planificado |
| **Sprint 3** | POS Simplificado             | 3-9 nov        | 7 días   | 29h   | ✅ Planificado |
| **Sprint 4** | Reservas y Apartados         | 10-16 nov      | 7 días   | ~30h  | ⏳ Pendiente   |
| **Sprint 5** | Reportes y Análisis          | 17-23 nov      | 7 días   | ~30h  | ⏳ Pendiente   |
| **Sprint 6** | Notificaciones               | 24-30 nov      | 7 días   | ~25h  | ⏳ Pendiente   |
| **Sprint 7** | Pruebas y Despliegue         | 1-7 dic        | 7 días   | ~20h  | ⏳ Pendiente   |
| **Buffer**   | Ajustes finales              | 8-13 dic       | 6 días   | ~15h  | ⏳ Reserva     |

**Total estimado:** ~225 horas en 55 días

### Hitos Clave

| Fecha  | Hito                      | Descripción                              |
| ------ | ------------------------- | ---------------------------------------- |
| 26 oct | 🎯 Login funcional        | Sistema de autenticación completo        |
| 2 nov  | 🎯 Inventario operativo   | CRUD de productos con categorías         |
| 9 nov  | 🎯 Primera venta          | POS funcional con actualización de stock |
| 16 nov | 🎯 Reservas activas       | Sistema de apartados implementado        |
| 23 nov | 🎯 Reportes disponibles   | Dashboard con métricas del negocio       |
| 30 nov | 🎯 Notificaciones activas | Alertas de stock bajo y reservas         |
| 7 dic  | 🎯 MVP completo           | Sistema probado y listo                  |
| 13 dic | 🚀 Despliegue             | Sistema en producción                    |

---

## SPRINT 1: AUTENTICACIÓN Y AUTORIZACIÓN

**Fechas:** 20-26 de octubre de 2025  
**Objetivo:** Sistema completo de login con JWT y roles diferenciados  
**Duración:** 7 días  
**Horas totales:** 35 horas

### Historias de Usuario Incluidas

- US-001: Iniciar sesión en el sistema
- US-002: Cerrar sesión
- US-003: Diferenciar permisos por rol

### Tareas Detalladas por Día

#### Domingo 19 de octubre (7 horas)

| ID  | Tarea                                  | Responsable        | Horas |
| --- | -------------------------------------- | ------------------ | ----- |
| 1.1 | Estructura Django + React + PostgreSQL | Backend + Frontend | 4h    |
| 1.2 | Configurar autenticación JWT           | Backend            | 3h    |

**Entregables del día:**

- Proyectos Django y React inicializados
- Base de datos PostgreSQL creada y conectada
- JWT configurado y probado

---

#### Lunes 21 de octubre (5 horas)

| ID  | Tarea                    | Responsable | Horas |
| --- | ------------------------ | ----------- | ----- |
| 1.3 | Modelo Usuario con roles | Backend     | 3h    |
| 1.4 | Endpoint de login        | Backend     | 2h    |

**Entregables del día:**

- Modelo Usuario personalizado creado
- Endpoint `/api/auth/login/` funcional
- Usuarios de prueba creados

---

#### Martes 22 de octubre (6 horas)

| ID  | Tarea                 | Responsable | Horas |
| --- | --------------------- | ----------- | ----- |
| 2.1 | Endpoint de logout    | Backend     | 2h    |
| 1.5 | Página de login React | Frontend    | 4h    |

**Entregables del día:**

- Endpoint `/api/auth/logout/` con blacklist
- LoginPage completo con validaciones
- Servicio authService creado

---

#### Miércoles 23 de octubre (3 horas)

| ID  | Tarea                    | Responsable | Horas |
| --- | ------------------------ | ----------- | ----- |
| 1.6 | Context de autenticación | Frontend    | 3h    |

**Entregables del día:**

- AuthContext implementado
- Persistencia de sesión con localStorage
- Estado global de autenticación

---

#### Jueves 24 de octubre (4 horas)

| ID  | Tarea          | Responsable | Horas |
| --- | -------------- | ----------- | ----- |
| 1.7 | Dashboard base | Frontend    | 4h    |

**Entregables del día:**

- DashboardPage creado
- Información de usuario mostrada
- Botón de logout funcional

---

#### Viernes 25 de octubre (3 horas)

| ID  | Tarea            | Responsable | Horas |
| --- | ---------------- | ----------- | ----- |
| 1.8 | Rutas protegidas | Frontend    | 3h    |

**Entregables del día:**

- PrivateRoute implementado
- Interceptor de axios configurado
- Redirección automática sin token

---

#### Sábado 26 de octubre (7 horas)

| ID  | Tarea                       | Responsable | Horas |
| --- | --------------------------- | ----------- | ----- |
| 3.1 | Permisos IsAdmin/IsVendedor | Backend     | 2h    |
| --  | Pruebas de integración      | Ambos       | 5h    |

**Entregables del día:**

- Permisos personalizados creados
- Flujo completo login → dashboard → logout probado
- Sistema de roles validado

---

### Definition of Done - Sprint 1

**Funcionalidad:**

- ✅ Usuario puede iniciar sesión con credenciales válidas
- ✅ Usuario puede cerrar sesión
- ✅ Tokens JWT se generan y validan correctamente
- ✅ Dashboard accesible solo tras autenticación
- ✅ Rutas protegidas redirigen a login sin token

**Seguridad:**

- ✅ Contraseñas hasheadas (bcrypt)
- ✅ Tokens en blacklist no reutilizables
- ✅ Permisos validados en backend
- ✅ CORS configurado correctamente

**Testing:**

- ✅ Endpoints probados con Postman
- ✅ Flujo completo validado
- ✅ Protección de rutas verificada

---

## SPRINT 2: INVENTARIO CON CATEGORÍAS DINÁMICAS

**Fechas:** 27 de octubre - 2 de noviembre de 2025  
**Objetivo:** CRUD completo de productos con categorías dinámicas y ajustes de stock  
**Duración:** 7 días  
**Horas totales:** 41 horas (+6h vs planificación original por categorías dinámicas)

### Cambio Arquitectónico Importante

⚠️ **Agregada gestión de categorías dinámicas** (Tareas 7.0, 7.1, 7.2)

**Motivo:** Las categorías hardcodeadas no son escalables para un negocio que cambia constantemente su inventario según tendencias del mercado.

**Impacto:** +6 horas al sprint, pero permite flexibilidad total sin modificar código.

### Historias de Usuario Incluidas

- US-007A: Gestionar categorías dinámicamente (NUEVA)
- US-007: Ver listado de productos en inventario
- US-008: Agregar nuevo producto al inventario
- US-009: Editar información de producto existente
- US-010: Ajustar stock manualmente con motivo

### Tareas Detalladas por Día

#### Domingo 27 de octubre (4 horas)

| ID  | Tarea                                | Responsable | Horas |
| --- | ------------------------------------ | ----------- | ----- |
| 7.0 | Modelo Categoria + relación Producto | Backend     | 2h    |
| 7.1 | Endpoints GET/POST categorías        | Backend     | 2h    |

**Entregables del día:**

- Tabla categoria creada en PostgreSQL
- 8 categorías base pre-cargadas
- Endpoints `/api/categorias/` funcionando
- Modelo Producto con ForeignKey a Categoria

---

#### Lunes 28 de octubre (6 horas)

| ID  | Tarea                               | Responsable | Horas |
| --- | ----------------------------------- | ----------- | ----- |
| 7.2 | CategoriaSelect con modal crear     | Frontend    | 3h    |
| 7.3 | Endpoint GET inventario con filtros | Backend     | 3h    |

**Entregables del día:**

- Componente CategoriaSelect reutilizable
- Modal para crear categoría inline
- Endpoint `/api/inventario/` con filtros avanzados

---

#### Martes 29 de octubre (8 horas)

| ID  | Tarea                        | Responsable | Horas |
| --- | ---------------------------- | ----------- | ----- |
| 7.4 | Vista InventoryPage          | Frontend    | 5h    |
| 8.1 | Endpoint POST crear producto | Backend     | 3h    |

**Entregables del día:**

- InventoryPage con tabla y filtros
- Búsqueda en tiempo real
- Endpoint `/api/inventario/crear/` funcional
- Validaciones de negocio implementadas

---

#### Miércoles 30 de octubre (8 horas)

| ID  | Tarea                          | Responsable | Horas |
| --- | ------------------------------ | ----------- | ----- |
| 8.2 | Modal ProductoModal            | Frontend    | 5h    |
| 9.1 | Endpoint PATCH editar producto | Backend     | 3h    |

**Entregables del día:**

- ProductoModal para crear productos
- Integración con CategoriaSelect
- Endpoint `/api/inventario/:id/` funcional

---

#### Jueves 31 de octubre (4 horas)

| ID  | Tarea                    | Responsable | Horas |
| --- | ------------------------ | ----------- | ----- |
| 9.2 | Edición en ProductoModal | Frontend    | 4h    |

**Entregables del día:**

- ProductoModal reutilizable (crear/editar)
- Pre-carga de datos en modo edición
- Checkbox para marcar como inactivo

---

#### Viernes 1 de noviembre (4 horas)

| ID   | Tarea                                        | Responsable | Horas |
| ---- | -------------------------------------------- | ----------- | ----- |
| 10.1 | Endpoint ajuste-stock + MovimientoInventario | Backend     | 4h    |

**Entregables del día:**

- Modelo MovimientoInventario creado
- Endpoint `/api/inventario/:id/ajuste-stock/`
- Auditoría de cambios implementada

---

#### Sábado 2 de noviembre (7 horas)

| ID   | Tarea                  | Responsable | Horas |
| ---- | ---------------------- | ----------- | ----- |
| 10.2 | Modal AjusteStockModal | Frontend    | 4h    |
| --   | Pruebas de integración | Ambos       | 3h    |

**Entregables del día:**

- AjusteStockModal con preview en tiempo real
- Validaciones de stock suficiente
- Flujo completo de inventario probado

---

### Definition of Done - Sprint 2

**Funcionalidad:**

- ✅ Administrador puede crear categorías dinámicamente
- ✅ CRUD completo de productos funcional
- ✅ Búsqueda y filtros avanzados operativos
- ✅ Ajustes de stock con auditoría completa
- ✅ Indicadores visuales de stock bajo

**Base de Datos:**

- ✅ Tabla categoria creada con datos base
- ✅ Tabla producto usa ForeignKey a categoria
- ✅ Tabla movimiento_inventario implementada
- ✅ Todos los índices creados

**Testing:**

- ✅ CRUD completo probado
- ✅ Filtros y búsqueda validados
- ✅ Auditoría de movimientos verificada

---

## SPRINT 3: POS SIMPLIFICADO

**Fechas:** 3-9 de noviembre de 2025  
**Objetivo:** Registro de ventas con actualización automática de inventario  
**Duración:** 7 días  
**Horas totales:** 29 horas (-3h por reutilización de MovimientoInventario)

### Optimización Importante

⚠️ **Reutilización de MovimientoInventario de Sprint 2**

**Motivo:** Sistema de auditoría ya implementado, solo se agrega tipo `venta`.

**Impacto:** -3 horas (32h → 29h), agregado campo `venta_relacionada_id`.

### Historias de Usuario Incluidas

- US-011: Eliminar producto del inventario
- US-012: Registrar venta de productos
- US-018: Actualización automática de stock tras venta
- US-006: Ver dashboard con métricas clave

### Tareas Detalladas por Día

#### Domingo 3 de noviembre (7 horas)

| ID   | Tarea                                 | Responsable | Horas |
| ---- | ------------------------------------- | ----------- | ----- |
| 11.1 | Endpoint DELETE producto              | Backend     | 2h    |
| 11.2 | Confirmación eliminación React        | Frontend    | 2h    |
| 12.0 | Modelos Venta/DetalleVenta/MetodoPago | Backend     | 3h    |

**Entregables del día:**

- Endpoint `/api/inventario/:id/eliminar/` con validaciones
- Modal ConfirmDeleteModal
- Tablas de venta creadas en PostgreSQL

---

#### Lunes 4 de noviembre (5 horas)

| ID   | Tarea                        | Responsable | Horas |
| ---- | ---------------------------- | ----------- | ----- |
| 18.1 | Endpoint POST venta completo | Backend     | 5h    |

**Entregables del día:**

- Endpoint `/api/ventas/` con transacciones atómicas
- Generación de número de venta único
- Integración con MovimientoInventario
- select_for_update para prevenir race conditions

---

#### Martes 5 de noviembre (7 horas)

| ID   | Tarea                   | Responsable | Horas |
| ---- | ----------------------- | ----------- | ----- |
| 12.2 | Componente POS completo | Frontend    | 7h    |

**Entregables del día:**

- POSPage con búsqueda de productos
- Carrito de compra funcional
- Cálculo automático de totales
- Modal MetodosPagoModal (pago simple y mixto)

---

#### Miércoles 6 de noviembre (5 horas)

| ID   | Tarea                            | Responsable | Horas |
| ---- | -------------------------------- | ----------- | ----- |
| 18.2 | Verificación actualización stock | Frontend    | 2h    |
| 6.1  | Endpoint GET dashboard métricas  | Backend     | 3h    |

**Entregables del día:**

- Modal ConfirmacionVentaModal con stock actualizado
- Endpoint `/api/dashboard/` con métricas del día

---

#### Jueves-Viernes 7-8 de noviembre (5 horas)

| ID  | Tarea                        | Responsable | Horas |
| --- | ---------------------------- | ----------- | ----- |
| 6.2 | Dashboard con cards métricas | Frontend    | 5h    |

**Entregables del día:**

- DashboardPage con cards de métricas
- Auto-refresh cada 30 segundos
- Gráficos de ventas del día
- Top productos más vendidos

---

### Definition of Done - Sprint 3

**Funcionalidad:**

- ✅ POS completo con búsqueda y selección de productos
- ✅ Carrito con cantidades y descuentos
- ✅ Múltiples métodos de pago (pago mixto)
- ✅ Stock se actualiza automáticamente tras venta
- ✅ Dashboard con métricas en tiempo real

**Base de Datos:**

- ✅ Tablas venta, detalle_venta, metodo_pago creadas
- ✅ Campo venta_relacionada_id agregado a movimiento_inventario
- ✅ Función generar_numero_venta() implementada

**Seguridad:**

- ✅ Transacciones atómicas en ventas
- ✅ select_for_update previene race conditions
- ✅ Validación de stock suficiente

**Testing:**

- ✅ Venta completa procesada correctamente
- ✅ Stock actualizado verificado
- ✅ Pago mixto validado
- ✅ Dashboard muestra datos correctos

---

## SPRINTS PENDIENTES (4-7)

Los siguientes sprints serán planificados con detalle después de completar Sprints 1-3 y aprender de la velocidad real del equipo.

### Sprint 4: Reservas y Apartados (10-16 nov)

**Objetivo:** Permitir apartar productos para clientes con plazo definido

**Funcionalidades estimadas:**

- Crear reserva con datos de cliente
- Bloqueo automático de stock_reservado
- Confirmación de reserva (conversión a venta)
- Cancelación de reserva (liberación de stock)
- Notificaciones de reservas próximas a vencer

**Estimación:** ~30 horas

---

### Sprint 5: Reportes y Análisis (17-23 nov)

**Objetivo:** Generar reportes automáticos para toma de decisiones

**Funcionalidades estimadas:**

- Reporte de ventas por período
- Análisis de productos más/menos vendidos
- Proyección de stock según tendencias
- Reporte de margen de ganancia
- Exportación a CSV/Excel

**Estimación:** ~30 horas

---

### Sprint 6: Notificaciones y Alertas (24-30 nov)

**Objetivo:** Sistema de notificaciones automáticas

**Funcionalidades estimadas:**

- Alertas de stock bajo
- Notificaciones de reservas por vencer
- Resumen de ventas diarias por email
- Alertas configurables por usuario

**Estimación:** ~25 horas

---

### Sprint 7: Pruebas y Despliegue (1-7 dic)

**Objetivo:** Sistema probado y desplegado en producción

**Actividades estimadas:**

- Pruebas de integración end-to-end
- Corrección de bugs encontrados
- Optimización de performance
- Configuración de servidor de producción
- Despliegue en Railway/Render
- Documentación de deployment

**Estimación:** ~20 horas

---

## MÉTRICAS Y VELOCIDAD

### Distribución de Trabajo por Sprint

| Sprint       | Backend   | Frontend  | Integración/Pruebas | Total   |
| ------------ | --------- | --------- | ------------------- | ------- |
| Sprint 1     | 14h (40%) | 16h (46%) | 5h (14%)            | 35h     |
| Sprint 2     | 17h (41%) | 21h (51%) | 3h (8%)             | 41h     |
| Sprint 3     | 13h (45%) | 14h (48%) | 2h (7%)             | 29h     |
| **Promedio** | **42%**   | **48%**   | **10%**             | **35h** |

### Velocidad del Equipo

**Story Points estimados por sprint:**

| Sprint    | Story Points | Horas Reales | SP/Hora  |
| --------- | ------------ | ------------ | -------- |
| Sprint 1  | 10 SP        | 35h          | 0.29     |
| Sprint 2  | 25 SP        | 41h          | 0.61     |
| Sprint 3  | 24 SP        | 29h          | 0.83     |
| **Total** | **59 SP**    | **105h**     | **0.56** |

**Velocidad promedio:** ~20 SP por sprint (7 días)

### Capacidad del Equipo

**Por persona:**

- Horas disponibles: 5h/día × 7 días = 35h/semana
- Horas efectivas (80%): ~28h/semana

**Equipo completo:**

- Capacidad teórica: 70h/sprint
- Capacidad real observada: ~35h/sprint
- Factor de ajuste: 50% (tiempo de coordinación, imprevistos, aprendizaje)

---

## GRÁFICO DE GANTT

### Sprints 1-3 (Planificados)

Semana 1 (20-26 Oct) - SPRINT 1: AUTENTICACIÓN  
═══════════════════════════════════════════════════  
Dom | ████████ Backend: Setup + JWT (7h)  
Lun | ██████ Backend: Usuario + Login (5h)  
Mar | ████ Backend: Logout (2h) | ████████ Frontend: LoginPage (4h)  
Mié | ██████ Frontend: AuthContext (3h)  
Jue | ████████ Frontend: Dashboard (4h)  
Vie | ██████ Frontend: Rutas protegidas (3h)  
Sáb | ████ Backend: Permisos (2h) | ██████████ Pruebas (5h)  
─────────────────────────────────────────────────────  
Total: 35 horas

Semana 2 (27 Oct - 2 Nov) - SPRINT 2: INVENTARIO  
═══════════════════════════════════════════════════  
Dom | ████ Backend: Categoria (2h+2h)  
Lun | ██████ Frontend: CategoriaSelect (3h) | ██████ Backend: GET inv (3h)  
Mar | ██████████ Frontend: InventoryPage (5h) | ██████ Backend: POST (3h)  
Mié | ██████████ Frontend: ProductoModal (5h) | ██████ Backend: PATCH (3h)  
Jue | ████████ Frontend: Edición (4h)  
Vie | ████████ Backend: Ajuste stock + Mov (4h)  
Sáb | ████████ Frontend: AjusteStockModal (4h) | ██████ Pruebas (3h)  
─────────────────────────────────────────────────────  
Total: 41 horas (+6h categorías dinámicas)

Semana 3 (3-9 Nov) - SPRINT 3: POS  
═══════════════════════════════════════════════════  
Dom | ████ BE: DELETE (2h) | ████ FE: Confirm (2h) | ██████ BE: Modelos (3h)  
Lun | ██████████ Backend: POST venta (5h)  
Mar | ██████████████ Frontend: POS completo (7h)  
Mié | ████ FE: Verificación (2h) | ██████ BE: Dashboard API (3h)  
Jue | ████████████ Frontend: Dashboard UI (5h)  
Vie |  
─────────────────────────────────────────────────────  
Total: 29 horas (-3h por reutilización)

Leyenda:  
████ = 2 horas de trabajo  
BE = Backend | FE = Frontend

---

## GESTIÓN DE RIESGOS

### Riesgos Identificados

#### 1. Riesgo: Estimaciones Imprecisas

**Probabilidad:** Media  
**Impacto:** Alto  
**Mitigación:**

- Revisión diaria de progreso
- Ajuste de estimaciones después de cada sprint
- Buffer de 6 días al final del proyecto

---

#### 2. Riesgo: Dependencia entre Tareas

**Probabilidad:** Alta  
**Impacto:** Medio  
**Mitigación:**

- Frontend puede avanzar con datos mock mientras backend termina
- Trabajo en paralelo siempre que sea posible
- Integración continua desde día 1

---

#### 3. Riesgo: Cambios de Alcance

**Probabilidad:** Media  
**Impacto:** Alto  
**Mitigación:**

- Alcance MVP bien definido
- Cambios solo si no afectan fechas críticas
- Registro en BITACORA_DESARROLLO.md

---

#### 4. Riesgo: Problemas Técnicos

**Probabilidad:** Media  
**Impacto:** Medio  
**Mitigación:**

- Stack tecnológico conocido por el equipo
- Documentación detallada en TAREAS_DETALLADAS.md
- Comunidad activa de Django/React para soporte

---

### Supuestos Clave

1. **Disponibilidad del equipo:** 5 horas/día efectivas por persona
2. **Sin bloqueos externos:** Base de datos, servicios cloud disponibles
3. **Conocimiento técnico:** Equipo familiarizado con Django y React
4. **Comunicación fluida:** Coordinación diaria entre backend y frontend

---

## NOTAS IMPORTANTES

### Lecciones Aprendidas Durante Planificación

1. **Categorías Dinámicas (Sprint 2):**

   - Planificación detallada reveló limitación de choices hardcodeadas
   - Inversión de 6 horas adicionales ahorra trabajo futuro
   - Decisión documentada en BITACORA_DESARROLLO.md

2. **MovimientoInventario Anticipado:**

   - Implementar auditoría en Sprint 2 (no Sprint 3) permite reutilización
   - Ahorro de 3 horas en Sprint 3

3. **Transacciones Atómicas Críticas:**

   - Ventas requieren coordinación de múltiples operaciones
   - select_for_update previene race conditions

### Próximas Acciones

**Antes de iniciar Sprint 1 (20 octubre):**

- [ ] Configurar repositorio Git
- [ ] Instalar dependencias locales (Python, Node, PostgreSQL)
- [ ] Crear proyecto base Django y React
- [ ] Configurar herramientas de comunicación (Discord/Slack)

**Durante cada sprint:**

- [ ] Daily standup (15 min diarios)
- [ ] Actualizar BITACORA_DESARROLLO.md con decisiones
- [ ] Commits frecuentes con mensajes descriptivos
- [ ] Code review antes de merge

**Al finalizar cada sprint:**

- [ ] Sprint retrospective (1 hora)
- [ ] Actualizar métricas de velocidad
- [ ] Planificar siguiente sprint con más detalle

---

**Última actualización:** 19 de octubre de 2025, 2:45 AM  
**Mantenido por:** Angel Alejandro  
**Versión:** 3.0 (con categorías dinámicas y optimizaciones Sprint 3)
