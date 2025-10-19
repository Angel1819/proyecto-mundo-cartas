Entendido, Angel. Pasemos directamente al **Documento 2: DB_MODEL_MUNDO_CARTAS.md**

---

# 📄 DOCUMENTO 2: DB_MODEL_MUNDO_CARTAS.md

Este es un documento técnico completamente nuevo que describe el modelo de datos definitivo del proyecto, basado en toda la planificación de Sprints 1-3.

text

`# MODELO DE BASE DE DATOS - MVP MUNDO CARTAS **Proyecto:** Sistema de Gestión de Inventario y Ventas   **Base de Datos:** PostgreSQL 15   **Última actualización:** 19 de octubre de 2025, 2:30 AM   **Versión:** 3.0 (con categorías dinámicas) --- ## 📋 ÍNDICE 1. [Resumen General](#resumen-general) 2. [Diagrama de Relaciones](#diagrama-de-relaciones) 3. [Tablas del Sistema](#tablas-del-sistema) 4. [Decisiones de Diseño](#decisiones-de-diseño) 5. [Índices y Optimizaciones](#índices-y-optimizaciones) --- ## RESUMEN GENERAL ### Estadísticas del Modelo - **Total de tablas:** 8 tablas principales - **Relaciones:** 9 relaciones (ForeignKey) - **Constraints:** 15 constraints (UNIQUE, CHECK, NOT NULL) - **Índices:** 12 índices personalizados - **Triggers:** 1 trigger (actualización de fecha de modificación) ### Apps Django | App | Tablas | Propósito | |-----|--------|-----------| | **authentication** | Usuario | Gestión de usuarios y autenticación | | **inventory** | Categoria, Producto, MovimientoInventario | Gestión de inventario y stock | | **sales** | Venta, DetalleVenta, MetodoPago | Registro de ventas y métodos de pago | --- ## DIAGRAMA DE RELACIONES ### Relaciones Principales`

┌─────────────┐  
│ Usuario │  
└──────┬──────┘  
│ 1:N (vendedor)  
│  
├─────────────────┐  
│ │  
▼ 1:N ▼ 1:N  
┌────────────┐ ┌─────────────────┐  
│ Venta │ │ MovimientoInv │  
└─────┬──────┘ └─────────────────┘  
│ 1:N ▲ N:1  
│ │  
▼ │  
┌─────────────┐ │  
│ DetalleVenta├──────────┤  
└──────┬──────┘ │  
│ N:1 │  
│ │  
▼ │  
┌─────────────┐ │  
│ Producto ├──────────┘  
└──────┬──────┘  
│ N:1  
▼  
┌─────────────┐  
│ Categoria │  
└─────────────┘

┌─────────────┐  
│ Venta │  
└──────┬──────┘  
│ 1:N  
▼  
┌─────────────┐  
│ MetodoPago │  
└─────────────┘

text

``### Explicación de Relaciones 1. **Usuario → Venta:** Un vendedor puede registrar múltiples ventas 2. **Usuario → MovimientoInventario:** Un usuario puede hacer múltiples ajustes de stock 3. **Categoria → Producto:** Una categoría puede tener múltiples productos 4. **Producto → DetalleVenta:** Un producto puede estar en múltiples ventas 5. **Producto → MovimientoInventario:** Un producto puede tener múltiples movimientos 6. **Venta → DetalleVenta:** Una venta tiene múltiples líneas de detalle 7. **Venta → MetodoPago:** Una venta puede tener múltiples métodos de pago (pago mixto) 8. **Venta → MovimientoInventario:** Una venta genera movimientos de inventario 9. **DetalleVenta ↔ Producto:** Snapshot de producto al momento de venta --- ## TABLAS DEL SISTEMA ### 1. TABLA: usuario **App:** authentication   **Modelo Django:** Usuario   **Hereda de:** AbstractUser **Propósito:**   Gestionar usuarios del sistema con roles diferenciados (administrador/vendedor) y auditoría de accesos. **Campos:** | Campo | Tipo | Restricciones | Descripción | |-------|------|---------------|-------------| | `id` | SERIAL | PK | Identificador único del usuario | | `username` | VARCHAR(150) | UNIQUE, NOT NULL | Nombre de usuario para login | | `email` | VARCHAR(254) | UNIQUE, NOT NULL | Correo electrónico | | `password` | VARCHAR(128) | NOT NULL | Contraseña hasheada (bcrypt) | | `nombre_completo` | VARCHAR(200) | NULL | Nombre completo del usuario | | `rol` | VARCHAR(20) | NOT NULL, CHECK | 'administrador' o 'vendedor' | | `activo` | BOOLEAN | DEFAULT TRUE | Usuario habilitado en el sistema | | `is_staff` | BOOLEAN | DEFAULT FALSE | Acceso al admin de Django | | `is_superuser` | BOOLEAN | DEFAULT FALSE | Permisos totales | | `fecha_creacion` | TIMESTAMP | DEFAULT NOW() | Fecha de creación del usuario | | `ultima_conexion` | TIMESTAMP | NULL | Último login registrado | | `last_login` | TIMESTAMP | NULL | Último login (campo de Django) | **Constraints:**``

CHECK (rol IN ('administrador', 'vendedor'))  
UNIQUE (username)  
UNIQUE (email)

text

`**Índices:**`

CREATE INDEX idx_usuario_rol ON usuario(rol);  
CREATE INDEX idx_usuario_activo ON usuario(activo);

text

``**Decisiones de Diseño:** - **¿Por qué heredar AbstractUser?** Reutiliza toda la infraestructura de autenticación de Django (hasheado de contraseñas, permisos, grupos) - **¿Por qué rol simple en lugar de roles múltiples?** MVP requiere solo 2 roles claros. Múltiples roles complicarían permisos innecesariamente - **¿Por qué campo activo separado de is_active?** Permite desactivar usuarios sin afectar lógica interna de Django --- ### 2. TABLA: categoria **App:** inventory   **Modelo Django:** Categoria   **Agregada en:** Sprint 2 (19 octubre 2025) **Propósito:**   Gestionar categorías de productos de forma dinámica, permitiendo al administrador crear nuevas categorías sin modificar código. **Campos:** | Campo | Tipo | Restricciones | Descripción | |-------|------|---------------|-------------| | `id` | SERIAL | PK | Identificador único de categoría | | `nombre` | VARCHAR(100) | UNIQUE, NOT NULL | Nombre de la categoría | | `descripcion` | TEXT | NULL | Descripción opcional | | `activo` | BOOLEAN | DEFAULT TRUE | Categoría habilitada | | `fecha_creacion` | TIMESTAMP | DEFAULT NOW() | Fecha de creación | **Constraints:**``

UNIQUE (nombre) -- Case-insensitive en Django con validación

text

`**Índices:**`

CREATE INDEX idx_categoria_activo ON categoria(activo);  
CREATE INDEX idx_categoria_nombre ON categoria(nombre);

text

`**Categorías Base Pre-cargadas:**`

INSERT INTO categoria (nombre, descripcion) VALUES  
('TCG Pokémon', 'Trading Card Game de Pokémon: sobres, cartas sueltas, productos sellados'),  
('TCG Yu-Gi-Oh!', 'Trading Card Game de Yu-Gi-Oh!: sobres, structure decks, cartas sueltas'),  
('TCG Magic', 'Magic: The Gathering - sobres, mazos preconstruidos, singles'),  
('TCG One Piece', 'Trading Card Game de One Piece - últimas expansiones'),  
('TCG Digimon', 'Digimon Card Game - sobres y starter decks'),  
('Juegos de Mesa', 'Board games, juegos de estrategia, party games'),  
('Accesorios', 'Sleeves, deck boxes, binders, playmats, dados'),  
('Otros', 'Productos diversos');

text

``**Decisiones de Diseño:** - **¿Por qué tabla separada?** Permite escalabilidad sin modificar código. Mundo Cartas necesita crear categorías según tendencias del mercado - **¿Por qué no choices en Producto?** Choices están hardcodeados, no escalables - **¿Por qué campo activo?** Permite ocultar categorías sin eliminarlas (preserva historial) --- ### 3. TABLA: producto **App:** inventory   **Modelo Django:** Producto **Propósito:**   Almacenar información de productos del inventario con control de stock disponible y reservado. **Campos:** | Campo | Tipo | Restricciones | Descripción | |-------|------|---------------|-------------| | `id` | SERIAL | PK | Identificador único del producto | | `sku` | VARCHAR(50) | UNIQUE, NOT NULL | Código único de producto | | `nombre` | VARCHAR(200) | NOT NULL | Nombre del producto | | `descripcion` | TEXT | NULL | Descripción detallada | | `categoria_id` | INTEGER | FK(categoria), NOT NULL | Categoría del producto | | `precio_compra` | DECIMAL(10,2) | NOT NULL, CHECK > 0 | Precio de compra | | `precio_venta` | DECIMAL(10,2) | NOT NULL, CHECK > 0 | Precio de venta | | `stock_disponible` | INTEGER | DEFAULT 0, CHECK >= 0 | Stock disponible para venta | | `stock_reservado` | INTEGER | DEFAULT 0, CHECK >= 0 | Stock apartado (reservas) | | `stock_minimo` | INTEGER | DEFAULT 5, CHECK >= 0 | Stock mínimo para alertas | | `estado` | VARCHAR(20) | DEFAULT 'disponible' | disponible/agotado/descontinuado | | `activo` | BOOLEAN | DEFAULT TRUE | Producto habilitado | | `fecha_creacion` | TIMESTAMP | DEFAULT NOW() | Fecha de creación | | `ultima_modificacion` | TIMESTAMP | DEFAULT NOW() | Última modificación | **Constraints:**``

UNIQUE (sku)  
CHECK (precio_venta > precio_compra)  
CHECK (stock_disponible >= 0)  
CHECK (stock_reservado >= 0)  
CHECK (stock_minimo >= 0)  
CHECK (estado IN ('disponible', 'agotado', 'descontinuado'))  
FOREIGN KEY (categoria_id) REFERENCES categoria(id) ON DELETE PROTECT

text

`**Índices:**`

CREATE INDEX idx_producto_categoria ON producto(categoria_id);  
CREATE INDEX idx_producto_sku ON producto(sku);  
CREATE INDEX idx_producto_estado ON producto(estado);  
CREATE INDEX idx_producto_stock ON producto(stock_disponible);  
CREATE INDEX idx_producto_activo ON producto(activo);

text

`**Trigger:**`

CREATE TRIGGER trigger_actualizar_producto  
BEFORE UPDATE ON producto  
FOR EACH ROW  
EXECUTE FUNCTION actualizar_fecha_modificacion();

text

`**Propiedades Calculadas (en Django):**`

@property  
def stock_total(self):  
return self.stock_disponible + self.stock_reservado

@property  
def necesita_reabastecimiento(self):  
return self.stock_disponible <= self.stock_minimo

@property  
def margen_ganancia(self):  
return self.precio_venta - self.precio_compra

@property  
def porcentaje_margen(self):  
return (self.margen_ganancia / self.precio_compra) * 100

text

``**Decisiones de Diseño:** - **¿Por qué stock_disponible y stock_reservado separados?** Permite gestionar reservas sin afectar stock real - **¿Por qué precio_venta > precio_compra obligatorio?** Previene errores que generarían pérdidas - **¿Por qué ON DELETE PROTECT en categoria?** No permite eliminar categoría si tiene productos (preserva integridad) - **¿Por qué campo estado?** Permite marcar productos descontinuados sin eliminarlos (historial) --- ### 4. TABLA: movimiento_inventario **App:** inventory   **Modelo Django:** MovimientoInventario   **Implementada en:** Sprint 2 **Propósito:**   Auditoría inmutable de todos los cambios de stock (ajustes manuales, ventas, reservas). Sistema de trazabilidad completo. **Campos:** | Campo | Tipo | Restricciones | Descripción | |-------|------|---------------|-------------| | `id` | SERIAL | PK | Identificador único del movimiento | | `producto_id` | INTEGER | FK(producto), NOT NULL | Producto afectado | | `tipo_movimiento` | VARCHAR(30) | NOT NULL, CHECK | Tipo de movimiento (ver tipos) | | `cantidad` | INTEGER | NOT NULL | Cantidad (positiva o negativa) | | `stock_anterior` | INTEGER | NOT NULL | Stock antes del movimiento | | `stock_posterior` | INTEGER | NOT NULL | Stock después del movimiento | | `motivo` | TEXT | NOT NULL | Descripción del motivo | | `usuario_id` | INTEGER | FK(usuario), SET NULL | Usuario que realizó el movimiento | | `venta_relacionada_id` | INTEGER | FK(venta), SET NULL | Venta asociada (si aplica) | | `fecha` | TIMESTAMP | DEFAULT NOW() | Fecha del movimiento | **Tipos de Movimiento:**``

CHECK (tipo_movimiento IN (  
'ajuste_manual', -- Ajuste administrativo  
'venta', -- Venta procesada  
'reserva', -- Producto reservado  
'confirmacion_reserva', -- Reserva confirmada (venta)  
'cancelacion_reserva', -- Reserva cancelada  
'devolucion', -- Devolución de venta  
'merma', -- Pérdida por daño/robo  
'ingreso_compra', -- Ingreso de mercadería  
'correccion' -- Corrección de inventario  
))

text

`**Constraints:**`

FOREIGN KEY (producto_id) REFERENCES producto(id) ON DELETE CASCADE  
FOREIGN KEY (usuario_id) REFERENCES usuario(id) ON DELETE SET NULL  
FOREIGN KEY (venta_relacionada_id) REFERENCES venta(id) ON DELETE SET NULL

text

`**Índices:**`

CREATE INDEX idx_movimiento_producto_fecha ON movimiento_inventario(producto_id, fecha DESC);  
CREATE INDEX idx_movimiento_tipo ON movimiento_inventario(tipo_movimiento);  
CREATE INDEX idx_movimiento_venta ON movimiento_inventario(venta_relacionada_id);  
CREATE INDEX idx_movimiento_usuario ON movimiento_inventario(usuario_id);

text

``**Decisiones de Diseño:** - **¿Por qué tabla inmutable?** Auditoría requiere que registros no se puedan editar ni eliminar - **¿Por qué stock_anterior y stock_posterior?** Permite reconstruir historial completo de stock - **¿Por qué campo venta_relacionada?** Vincula movimientos con ventas para trazabilidad - **¿Por qué ON DELETE SET NULL en usuario?** Preserva movimientos aunque se elimine usuario - **¿Por qué cantidad puede ser negativa?** Negativo = salida (venta), Positivo = entrada (compra) --- ### 5. TABLA: venta **App:** sales   **Modelo Django:** Venta   **Implementada en:** Sprint 3 **Propósito:**   Registrar ventas realizadas con totales calculados y referencia única. **Campos:** | Campo | Tipo | Restricciones | Descripción | |-------|------|---------------|-------------| | `id` | SERIAL | PK | Identificador único de venta | | `numero_venta` | VARCHAR(20) | UNIQUE, NOT NULL | Número único (V-YYYYMMDD-NNNN) | | `vendedor_id` | INTEGER | FK(usuario), NOT NULL | Vendedor que realizó la venta | | `subtotal` | DECIMAL(12,2) | NOT NULL, CHECK >= 0 | Suma de productos sin descuento | | `descuento_total` | DECIMAL(12,2) | DEFAULT 0, CHECK >= 0 | Descuento aplicado | | `total` | DECIMAL(12,2) | NOT NULL, CHECK > 0 | Total final cobrado | | `observaciones` | TEXT | NULL | Notas de la venta | | `anulada` | BOOLEAN | DEFAULT FALSE | Venta anulada | | `fecha_anulacion` | TIMESTAMP | NULL | Fecha de anulación | | `motivo_anulacion` | TEXT | NULL | Motivo de anulación | | `fecha_venta` | TIMESTAMP | DEFAULT NOW() | Fecha de la venta | **Formato de numero_venta:**``

V-YYYYMMDD-NNNN

Ejemplo: V-20251104-0001

- V: Prefijo de venta

- YYYYMMDD: Fecha (20251104 = 4 nov 2025)

- NNNN: Correlativo del día (reinicia cada día)

text

`**Constraints:**`

UNIQUE (numero_venta)  
CHECK (subtotal >= 0)  
CHECK (descuento_total >= 0)  
CHECK (total > 0)  
CHECK (descuento_total <= subtotal)  
FOREIGN KEY (vendedor_id) REFERENCES usuario(id) ON DELETE PROTECT

text

`**Índices:**`

CREATE INDEX idx_venta_vendedor_fecha ON venta(vendedor_id, fecha_venta DESC);  
CREATE INDEX idx_venta_numero ON venta(numero_venta);  
CREATE INDEX idx_venta_fecha ON venta(fecha_venta DESC);  
CREATE INDEX idx_venta_anulada ON venta(anulada, fecha_venta DESC);

text

`**Propiedades Calculadas:**`

@property  
def cantidad_productos(self):  
return self.detalles.aggregate(Sum('cantidad'))['cantidad__sum'] or 0

text

``**Decisiones de Diseño:** - **¿Por qué numero_venta generado?** Referencia única legible para buscar ventas - **¿Por qué correlativo por día?** Facilita búsquedas y reduce longitud del número - **¿Por qué campo anulada en lugar de DELETE?** Preserva historial contable - **¿Por qué ON DELETE PROTECT en vendedor?** No permite eliminar vendedor con ventas registradas --- ### 6. TABLA: detalle_venta **App:** sales   **Modelo Django:** DetalleVenta   **Implementada en:** Sprint 3 **Propósito:**   Detallar cada línea de una venta con snapshot de producto (precio al momento de venta). **Campos:** | Campo | Tipo | Restricciones | Descripción | |-------|------|---------------|-------------| | `id` | SERIAL | PK | Identificador único del detalle | | `venta_id` | INTEGER | FK(venta), NOT NULL | Venta asociada | | `producto_id` | INTEGER | FK(producto), NOT NULL | Producto vendido | | `producto_sku` | VARCHAR(50) | NOT NULL | SKU snapshot | | `producto_nombre` | VARCHAR(200) | NOT NULL | Nombre snapshot | | `cantidad` | INTEGER | NOT NULL, CHECK > 0 | Cantidad vendida | | `precio_unitario` | DECIMAL(10,2) | NOT NULL, CHECK > 0 | Precio al momento de venta | | `descuento_unitario` | DECIMAL(10,2) | DEFAULT 0, CHECK >= 0 | Descuento por unidad | | `subtotal_linea` | DECIMAL(12,2) | NOT NULL, CHECK >= 0 | cantidad * precio_unitario | | `total_linea` | DECIMAL(12,2) | NOT NULL, CHECK >= 0 | subtotal - descuento | **Constraints:**``

CHECK (cantidad > 0)  
CHECK (precio_unitario > 0)  
CHECK (descuento_unitario >= 0)  
CHECK (descuento_unitario < precio_unitario)  
FOREIGN KEY (venta_id) REFERENCES venta(id) ON DELETE CASCADE  
FOREIGN KEY (producto_id) REFERENCES producto(id) ON DELETE PROTECT

text

`**Índices:**`

CREATE INDEX idx_detalle_venta ON detalle_venta(venta_id);  
CREATE INDEX idx_detalle_producto ON detalle_venta(producto_id);

text

``**Decisiones de Diseño:** - **¿Por qué duplicar SKU y nombre?** Snapshot inmutable - si el producto cambia después, la venta histórica no debe cambiar - **¿Por qué precio_unitario copiado?** Los precios pueden cambiar, pero facturas históricas no pueden cambiar retroactivamente - **¿Por qué ON DELETE CASCADE en venta?** Si se elimina venta (raro), eliminar detalles también - **¿Por qué ON DELETE PROTECT en producto?** No permite eliminar producto que fue vendido --- ### 7. TABLA: metodo_pago **App:** sales   **Modelo Django:** MetodoPago   **Implementada en:** Sprint 3 **Propósito:**   Registrar métodos de pago utilizados en cada venta (soporta pago mixto). **Campos:** | Campo | Tipo | Restricciones | Descripción | |-------|------|---------------|-------------| | `id` | SERIAL | PK | Identificador único | | `venta_id` | INTEGER | FK(venta), NOT NULL | Venta asociada | | `tipo_pago` | VARCHAR(20) | NOT NULL, CHECK | Tipo de pago | | `monto` | DECIMAL(12,2) | NOT NULL, CHECK > 0 | Monto pagado | | `referencia` | VARCHAR(100) | NULL | Nº transacción/voucher | **Tipos de Pago:**``

CHECK (tipo_pago IN (  
'efectivo',  
'debito',  
'credito',  
'transferencia',  
'otro'  
))

text

`**Constraints:**`

CHECK (monto > 0)  
FOREIGN KEY (venta_id) REFERENCES venta(id) ON DELETE CASCADE

text

`**Índices:**`

CREATE INDEX idx_metodo_pago_venta ON metodo_pago(venta_id);  
CREATE INDEX idx_metodo_pago_tipo ON metodo_pago(tipo_pago);

text

``**Decisiones de Diseño:** - **¿Por qué tabla separada?** Permite múltiples métodos de pago en una venta (pago mixto: efectivo + tarjeta) - **¿Por qué campo referencia opcional?** Efectivo no requiere referencia, pero tarjetas/transferencias sí - **¿Por qué ON DELETE CASCADE?** Si se elimina venta, eliminar métodos de pago también --- ## DECISIONES DE DISEÑO ### 1. Normalización vs Desnormalización **Decisión:** Modelo normalizado con excepción intencional en DetalleVenta **Razones:** - ✅ **Normalización:** Reduce redundancia, facilita mantenimiento - ✅ **Desnormalización en DetalleVenta:** Snapshot necesario para historial inmutable - ✅ **No se normaliza precio en DetalleVenta:** Los precios cambian, las facturas no **Alternativa descartada:** Calcular precios dinámicamente desde Producto - ❌ Problema: Si cambia precio de producto, ventas históricas cambiarían retroactivamente (ilegal contablemente) --- ### 2. Soft Delete vs Hard Delete **Decisión:** Soft delete en usuarios y productos (campo `activo`), hard delete restringido con PROTECT **Razones:** - ✅ Preserva historial y auditoría - ✅ Permite "recuperar" registros marcados como inactivos - ✅ No afecta integridad referencial **Implementación:** - Usuarios: `activo=False` en lugar de DELETE - Productos: `activo=False` en lugar de DELETE - Ventas: `anulada=True` en lugar de DELETE --- ### 3. Generación de Números de Venta **Decisión:** Formato V-YYYYMMDD-NNNN con correlativo por día **Razones:** - ✅ Legible para humanos - ✅ Facilita búsquedas por fecha - ✅ Correlativo corto (máximo 4 dígitos por día) - ✅ Único en todo el sistema **Alternativa descartada:** UUID - ❌ Problema: No legible, difícil de comunicar por teléfono/email --- ### 4. Transacciones Atómicas **Decisión:** Usar `transaction.atomic()` en operaciones críticas **Operaciones con transacciones:** 1. Registro de venta (venta + detalles + stock + movimientos + métodos de pago) 2. Confirmación de reserva 3. Ajustes masivos de stock **Razones:** - ✅ Garantiza consistencia (todo o nada) - ✅ Previene estados intermedios inválidos - ✅ Simplifica manejo de errores --- ### 5. Prevención de Race Conditions **Decisión:** Usar `select_for_update()` en ventas y reservas **Escenario problemático sin select_for_update:**``

Vendedor A lee stock = 5  
Vendedor B lee stock = 5  
Vendedor A vende 5 → stock = 0  
Vendedor B vende 5 → stock = -5 ❌

text

`**Solución:**`

producto = Producto.objects.select_for_update().get(pk=id)

# Fila bloqueada hasta fin de transacción

text

`**Resultado:** - Vendedor A bloquea producto - Vendedor B espera - Vendedor B ve stock actualizado (0) - Venta B es rechazada correctamente --- ## ÍNDICES Y OPTIMIZACIONES ### Índices Críticos para Performance **Consultas más frecuentes:** 1. Buscar productos por SKU o nombre 2. Listar ventas de un vendedor 3. Historial de movimientos de un producto 4. Dashboard: Ventas del día 5. Productos con stock bajo **Índices implementados:**`

-- Productos  
CREATE INDEX idx_producto_sku ON producto(sku); -- Búsqueda por SKU  
CREATE INDEX idx_producto_nombre ON producto USING gin(to_tsvector('spanish', nombre)); -- Full-text search  
CREATE INDEX idx_producto_stock ON producto(stock_disponible) WHERE stock_disponible <= stock_minimo; -- Partial index

-- Ventas  
CREATE INDEX idx_venta_vendedor_fecha ON venta(vendedor_id, fecha_venta DESC); -- Ventas por vendedor  
CREATE INDEX idx_venta_fecha_anulada ON venta(fecha_venta DESC) WHERE anulada = FALSE; -- Partial index

-- Movimientos  
CREATE INDEX idx_movimiento_producto_fecha ON movimiento_inventario(producto_id, fecha DESC); -- Historial

-- Detalles  
CREATE INDEX idx_detalle_venta ON detalle_venta(venta_id); -- JOIN eficiente

text

`### Estimación de Tamaños **Estimación para 1 año de operación:** | Tabla | Registros estimados | Tamaño aprox | |-------|---------------------|--------------| | Usuario | 10 usuarios | <1 KB | | Categoria | 20 categorías | <5 KB | | Producto | 500 productos | ~200 KB | | MovimientoInventario | 10,000 movimientos | ~5 MB | | Venta | 3,650 ventas (10/día) | ~1 MB | | DetalleVenta | 10,950 líneas (3/venta) | ~3 MB | | MetodoPago | 7,300 métodos (2/venta) | ~500 KB | **Total estimado:** ~10 MB después de 1 año --- ## SCRIPTS DE MANTENIMIENTO ### Respaldo de Base de Datos`

# Backup completo

pg_dump mundo_cartas_db > backup_$(date +%Y%m%d).sql

# Backup solo datos

pg_dump -a mundo_cartas_db > datos_backup.sql

# Restore

psql mundo_cartas_db < backup_20251104.sql

text

`### Verificación de Integridad`

-- Verificar consistencia de stock  
SELECT  
p.id,  
p.sku,  
p.nombre,  
p.stock_disponible AS stock_actual,  
COALESCE(SUM(mi.cantidad), 0) AS stock_calculado  
FROM producto p  
LEFT JOIN movimiento_inventario mi ON p.id = mi.producto_id  
GROUP BY p.id  
HAVING p.stock_disponible != COALESCE(SUM(mi.cantidad), 0);

-- Verificar ventas sin detalles  
SELECT * FROM venta v  
WHERE NOT EXISTS (  
SELECT 1 FROM detalle_venta dv WHERE dv.venta_id = v.id  
);

text

`--- **Última actualización:** 19 de octubre de 2025, 2:30 AM   **Mantenido por:** Angel Alejandro   **Versión:** 3.0`


