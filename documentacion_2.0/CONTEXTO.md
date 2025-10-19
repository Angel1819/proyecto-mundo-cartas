

# 📄 CONTEXTO.MD - PROMPT PARA IA



`# CONTEXTO COMPLETO - MVP MUNDO CARTAS **Propósito de este documento:** Pégame completo al iniciar una nueva sesión con IA. Te dará contexto total del proyecto en segundos. **Última actualización:** 19 de octubre de 2025, 2:55 AM   **Versión:** 3.0 --- ## 🎯 QUIÉN SOY Y QUÉ NECESITO Soy **Angel Medina**, estudiante de programación desarrollando un sistema para mi proyecto de título. Trabajo con un compañero (Alejandro Barraza) que hace frontend mientras yo hago backend. **Mi estilo de trabajo:** - Planificador meticuloso: necesito TODO documentado antes de codear - Prefiero razonar decisiones arquitectónicas en profundidad - Trabajo mejor con ejemplos de código concretos - Me gusta documentar el "por qué", no solo el "qué" - Suelo distraerme muy facil, por eso instrucciones claras me ayudan **Lo que necesito de la IA:** - Respuestas técnicas precisas (no genéricas) - Código funcional completo (no pseudocódigo) - Explicación de trade-offs y alternativas - Validación de mis decisiones arquitectónicas - Advertencias proactivas de problemas potenciales --- ## 🏢 EL PROYECTO EN UNA LÍNEA **Sistema web de inventario y ventas para Mundo Cartas (tienda física de trading cards en Chile) que reemplaza hojas Excel con gestión en tiempo real, auditoría completa y roles diferenciados.** --- ## 📊 ESTADO ACTUAL DEL PROYECTO ### Lo que YA está planificado (listo para codear): **Sprint 1 (20-26 oct):** Autenticación con JWT - 7 tareas detalladas en TAREAS_DETALLADAS.md - Django + React + PostgreSQL configurados - Modelo Usuario con roles (administrador/vendedor) - Login/logout completo - **Estado:** ✅ 100% planificado, 0% implementado **Sprint 2 (27 oct - 2 nov):** Inventario con categorías dinámicas - 10 tareas (incluyendo 3 nuevas para categorías dinámicas) - CRUD completo de productos - Modelo Categoria independiente (decisión arquitectónica del 19-oct) - Ajustes de stock con auditoría (MovimientoInventario) - **Estado:** ✅ 100% planificado, 0% implementado **Sprint 3 (3-9 nov):** POS (Punto de Venta) - 8 tareas - Registro de ventas con múltiples métodos de pago - Actualización automática de stock con transacciones atómicas - Dashboard con métricas en tiempo real - **Estado:** ✅ 100% planificado, 0% implementado ### Lo que FALTA planificar: **Sprints 4-7:** Reservas, Reportes, Notificaciones, Despliegue - **Estado:** ⏳ Se planificarán después de completar Sprints 1-3 - **Razón:** Filosofía Agile - aprender de velocidad real antes de sobre-planificar --- ## 🛠️ STACK TÉCNICO (NO NEGOCIABLE) **Backend:** - Django 4.2 + Django REST Framework 3.14 - PostgreSQL 15 (no SQLite, no MySQL) - JWT para autenticación (djangorestframework-simplejwt) - Python 3.11+ **Frontend:** - React 18 (JavaScript, no TypeScript por ahora) - React Router DOM 6 - Axios para HTTP - Context API (no Redux) - CSS vanilla (sin frameworks CSS) **Despliegue futuro:** - Railway/Render (backend) - Vercel/Netlify (frontend) - Neon/Supabase (PostgreSQL managed) --- ## 🏗️ ARQUITECTURA ESENCIAL ### Modelo de Datos Core`

Usuario (AbstractUser extendido)  
├── rol: 'administrador' | 'vendedor'  
├── nombre_completo, activo, fecha_creacion  
└── Métodos: es_administrador, es_vendedor

Categoria (NUEVA - decisión 19-oct-2025)  
├── nombre (unique), descripcion, activo  
└── 8 categorías base: TCG Pokémon, Yu-Gi-Oh!, Magic, One Piece, Digimon, Juegos de Mesa, Accesorios, Otros

Producto  
├── sku (unique), nombre, descripcion  
├── categoria_id (FK a Categoria - CAMBIO: antes era CharField con choices)  
├── precio_compra, precio_venta (CHECK: venta > compra)  
├── stock_disponible, stock_reservado, stock_minimo  
├── estado: 'disponible' | 'agotado' | 'descontinuado'  
└── activo, fecha_creacion, ultima_modificacion

MovimientoInventario (auditoría inmutable)  
├── producto_id (FK)  
├── tipo_movimiento: 'ajuste_manual' | 'venta' | 'reserva' | etc.  
├── cantidad (+ entrada, - salida)  
├── stock_anterior, stock_posterior  
├── motivo (obligatorio)  
├── usuario_id (FK, SET NULL)  
├── venta_relacionada_id (FK a Venta, SET NULL - agregado Sprint 3)  
└── fecha (auto_now_add)

Venta  
├── numero_venta (unique, formato: V-YYYYMMDD-NNNN)  
├── vendedor_id (FK a Usuario, PROTECT)  
├── subtotal, descuento_total, total  
├── anulada, fecha_anulacion, motivo_anulacion  
└── fecha_venta

DetalleVenta (snapshot de producto)  
├── venta_id (FK, CASCADE)  
├── producto_id (FK, PROTECT)  
├── producto_sku, producto_nombre (duplicados intencionalmente)  
├── cantidad, precio_unitario (snapshot al momento de venta)  
├── descuento_unitario, subtotal_linea, total_linea

MetodoPago (soporta pago mixto)  
├── venta_id (FK, CASCADE)  
├── tipo_pago: 'efectivo' | 'debito' | 'credito' | 'transferencia' | 'otro'  
├── monto  
└── referencia (opcional: nº transacción)



``### Relaciones Críticas - Usuario 1:N Venta (vendedor) - Usuario 1:N MovimientoInventario - Categoria 1:N Producto - Producto 1:N DetalleVenta - Producto 1:N MovimientoInventario - Venta 1:N DetalleVenta - Venta 1:N MetodoPago - Venta 1:N MovimientoInventario (venta_relacionada) --- ## 🔥 DECISIONES ARQUITECTÓNICAS CRÍTICAS ### 1. Categorías Dinámicas (19-oct-2025 - Sprint 2) **ANTES:** `Producto.categoria = CharField(choices=[('pokemon', 'TCG Pokémon'), ...])` **AHORA:** `Producto.categoria = ForeignKey(Categoria, on_delete=PROTECT)` **Por qué cambiamos:** - Mundo Cartas necesita crear categorías según tendencias del mercado (nuevos TCGs lanzan constantemente) - Choices hardcodeadas requieren modificar código cada vez - Escalabilidad > simplicidad inicial **Costo:** +6 horas en Sprint 2 (35h → 41h)   **Beneficio:** Flexibilidad total sin tocar código --- ### 2. MovimientoInventario Anticipado (Sprint 2, no 3) **Decisión:** Implementar auditoría de stock en Sprint 2 (ajustes manuales) en lugar de Sprint 3 (ventas) **Por qué:** - Trazabilidad completa desde el primer ajuste - Reutilización en Sprint 3 para ventas (-3 horas) - Base sólida para reportes futuros (Sprint 5) **Campo agregado en Sprint 3:** `venta_relacionada_id` para vincular movimientos con ventas --- ### 3. Snapshot en DetalleVenta **Decisión:** Duplicar SKU, nombre y precio_unitario en DetalleVenta (no calcular dinámicamente) **Por qué:** - Si cambio el precio de un producto, ventas históricas NO pueden cambiar retroactivamente - Requisito legal/contable: facturas son inmutables - Snapshots preservan estado exacto al momento de venta **Alternativa descartada:** Relación simple a Producto → Facturas cambiarían con cada update de producto (ilegal) --- ### 4. Transacciones Atómicas en Ventas **Problema:** Venta coordina 5 operaciones: 1. Crear Venta 2. Crear N DetalleVenta 3. Crear M MetodoPago 4. Reducir stock de N productos 5. Crear N MovimientoInventario **Solución:** `transaction.atomic()` en Django **Por qué:** - Garantiza consistencia: TODAS las operaciones se ejecutan o NINGUNA - Previene ventas parciales si falla una operación - Si falla pago, stock no se reduce --- ### 5. Race Conditions en Ventas **Problema:**``

Vendedor A lee stock = 5  
Vendedor B lee stock = 5  
Vendedor A vende 5 → stock = 0  
Vendedor B vende 5 → stock = -5 ❌

text

``**Solución:** `select_for_update()` en Django``

producto = Producto.objects.select_for_update().get(pk=id)

# Fila bloqueada hasta fin de transacción



``**Por qué:** - Previene ventas simultáneas del último stock - Vendedor B espera a que A termine - Vendedor B ve stock actualizado (0) y venta es rechazada correctamente --- ## 📚 DOCUMENTACIÓN DISPONIBLE **Para consultar detalles:** | Documento | Propósito | Cuándo usar | |-----------|-----------|-------------| | **TAREAS_DETALLADAS.md** | Pasos técnicos paso a paso | Durante implementación de tareas | | **SPRINT_PLANNING.md** | Cronograma y distribución de trabajo | Planificación y seguimiento | | **DB_MODEL_MUNDO_CARTAS.md** | Modelo de datos completo | Diseño de modelos y migraciones | | **mundo_cartas.sql** | Script SQL de base de datos | Setup inicial de PostgreSQL | | **BACKLOG.md** | Historias de usuario con criterios | Validación de funcionalidades | | **BITACORA_DESARROLLO.md** | Decisiones técnicas y cambios | Registro de por qué se hizo algo | **Jerarquía de fuentes de verdad:** 1. **TAREAS_DETALLADAS.md** - Instrucciones de implementación 2. **DB_MODEL_MUNDO_CARTAS.md** - Estructura de datos 3. **CONTEXTO.md** (este archivo) - Visión general y decisiones --- ## 💡 CONVENCIONES Y PREFERENCIAS ### Código **Django:** - Nombres en español para modelos y campos (Usuario, no User) - Comentarios en español explicando el "por qué" - Validaciones en modelo Y en serializer (doble capa) - Permisos custom sobre funciones de Django admin - Preferir `on_delete=PROTECT` sobre CASCADE (prevenir eliminaciones accidentales) **React:** - Componentes funcionales (no clases) - Hooks: useState, useEffect, useContext - Nombres de archivos: PascalCase para componentes, camelCase para servicios - Carpetas: components/ (reutilizables), pages/ (rutas principales) ### Estilo de Respuesta Esperado de la IA **✅ BIEN:**``

La decisión entre choices y ForeignKey depende de:

- Choices: Más simple, pero hardcodeadas (no escalable)

- ForeignKey: Más flexible, permite CRUD dinámico

Para Mundo Cartas recomiendo ForeignKey porque:

1. Nuevos TCGs lanzan constantemente (Lorcana, One Piece)

2. Claudio necesita crear categorías sin modificar código

3. Costo: +6h de desarrollo, pero ganas flexibilidad

Implementación:  
[código completo aquí]

text

`**❌ MAL:**`

Puedes usar choices o una tabla separada, ambos funcionan.  
[sin explicar trade-offs ni dar recomendación]

text

`--- ## 🚨 ADVERTENCIAS IMPORTANTES ### Lo que NO debes asumir: 1. **NO asumir que algo está implementado**    - Estado actual: 0% de código escrito   - Todo está planificado, nada está implementado 2. **NO sugerir cambios de stack**    - Django + React + PostgreSQL es decisión final   - Cliente usa Windows (considerar rutas de archivos) 3. **NO simplificar explicaciones técnicas**    - Angel prefiere entender el "por qué" a fondo   - Explicar trade-offs y alternativas siempre 4. **NO usar TypeScript en ejemplos de React**    - MVP usa JavaScript vanilla   - TypeScript considerado para versiones futuras --- ## 🎬 PRÓXIMOS PASOS INMEDIATOS **Antes de empezar Sprint 1 (20 octubre):** 1. Configurar repositorio Git 2. Instalar dependencias locales (Python 3.11, Node 18, PostgreSQL 15) 3. Ejecutar mundo_cartas.sql para crear base de datos 4. Seguir TAREAS_DETALLADAS.md paso a paso **Durante desarrollo:** - Consultar TAREAS_DETALLADAS.md para implementación específica - Documentar decisiones técnicas en BITACORA_DESARROLLO.md - Commits descriptivos en español --- ## 🔄 CÓMO USAR ESTE CONTEXTO ### Ejemplo de uso correcto:`

[Pegar CONTEXTO.md completo]

Estoy implementando la Tarea 8.2 (Modal ProductoModal).  
Necesito que el modal sirva para crear Y editar productos.  
¿Cómo estructuro el componente para reutilizarlo en ambos modos?

text

`### La IA debería entender automáticamente: - ✅ Estás usando React (no preguntar "¿qué framework?") - ✅ Modal debe integrar CategoriaSelect (ya sabes que existe) - ✅ Modo edición: SKU no editable, stock no modificable aquí - ✅ Validaciones: precio_venta > precio_compra - ✅ Integración con endpoint PATCH /api/inventario/:id/ --- ## 📞 INFORMACIÓN DE CONTACTO Y ENTORNO **Desarrollador:** Angel Alejandro   **Ubicación:** Chile (UTC-3)   **Horario de trabajo:** Nocturno (11 PM - 4 AM)   **Sistema operativo:** Windows 11   **IDE:** VS Code   **Control de versiones:** Git + GitHub --- **Última actualización:** 19 de octubre de 2025, 2:55 AM   **Versión3 planificados)   **Próxima revisión:** Al completar Sprint 3 (9 nov 2025)`


