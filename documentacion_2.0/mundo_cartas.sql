-- ============================================
-- SCRIPT DE CREACIÓN DE BASE DE DATOS
-- Proyecto: MVP Mundo Cartas
-- Versión: 3.0 (con categorías dinámicas y ventas)
-- Última actualización: 19 de octubre de 2025
-- ============================================

-- Crear base de datos
CREATE DATABASE mundo_cartas_db
    WITH 
    ENCODING = 'UTF8'
    LC_COLLATE = 'es_CL.UTF-8'
    LC_CTYPE = 'es_CL.UTF-8'
    TEMPLATE = template0;

\c mundo_cartas_db

-- ============================================
-- EXTENSIONES
-- ============================================
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- TABLA: CATEGORIA (NUEVA - Sprint 2)
-- ============================================
CREATE TABLE categoria (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) UNIQUE NOT NULL,
    descripcion TEXT,
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insertar categorías base
INSERT INTO categoria (nombre, descripcion) VALUES
('TCG Pokémon', 'Trading Card Game de Pokémon: sobres, cartas sueltas, productos sellados'),
('TCG Yu-Gi-Oh!', 'Trading Card Game de Yu-Gi-Oh!: sobres, structure decks, cartas sueltas'),
('TCG Magic', 'Magic: The Gathering - sobres, mazos preconstruidos, singles'),
('TCG One Piece', 'Trading Card Game de One Piece - últimas expansiones y cartas populares'),
('TCG Digimon', 'Digimon Card Game - sobres y starter decks'),
('Juegos de Mesa', 'Board games, juegos de estrategia, party games'),
('Accesorios', 'Sleeves, deck boxes, binders, playmats, dados'),
('Otros', 'Productos diversos que no encajan en otras categorías');

-- Índices para categoria
CREATE INDEX idx_categoria_activo ON categoria(activo);
CREATE INDEX idx_categoria_nombre ON categoria(nombre);

-- ============================================
-- TABLA: PRODUCTO (ACTUALIZADA con ForeignKey a categoria)
-- ============================================
CREATE TABLE producto (
    id SERIAL PRIMARY KEY,
    sku VARCHAR(50) UNIQUE NOT NULL,
    nombre VARCHAR(200) NOT NULL,
    descripcion TEXT,
    categoria_id INTEGER NOT NULL REFERENCES categoria(id) ON DELETE PROTECT,
    precio_compra DECIMAL(10, 2) CHECK (precio_compra > 0) NOT NULL,
    precio_venta DECIMAL(10, 2) CHECK (precio_venta > 0) NOT NULL,
    stock_disponible INTEGER DEFAULT 0 CHECK (stock_disponible >= 0),
    stock_reservado INTEGER DEFAULT 0 CHECK (stock_reservado >= 0),
    stock_minimo INTEGER DEFAULT 5 CHECK (stock_minimo >= 0),
    estado VARCHAR(20) CHECK (estado IN ('disponible', 'agotado', 'descontinuado')) DEFAULT 'disponible',
    activo BOOLEAN DEFAULT TRUE,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ultima_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT check_precio_venta_mayor CHECK (precio_venta > precio_compra)
);

-- Índices para producto
CREATE INDEX idx_producto_categoria ON producto(categoria_id);
CREATE INDEX idx_producto_sku ON producto(sku);
CREATE INDEX idx_producto_estado ON producto(estado);
CREATE INDEX idx_producto_stock ON producto(stock_disponible);
CREATE INDEX idx_producto_activo ON producto(activo);
CREATE INDEX idx_producto_categoria_activo ON producto(categoria_id, activo);

-- Trigger para actualizar ultima_modificacion
CREATE OR REPLACE FUNCTION actualizar_fecha_modificacion()
RETURNS TRIGGER AS $$
BEGIN
    NEW.ultima_modificacion = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_actualizar_producto
BEFORE UPDATE ON producto
FOR EACH ROW
EXECUTE FUNCTION actualizar_fecha_modificacion();

-- ============================================
-- TABLA: VENTA (Sprint 3)
-- ============================================
CREATE TABLE venta (
    id SERIAL PRIMARY KEY,
    numero_venta VARCHAR(20) UNIQUE NOT NULL,
    vendedor_id INTEGER NOT NULL,
    subtotal DECIMAL(12, 2) CHECK (subtotal >= 0) NOT NULL,
    descuento_total DECIMAL(12, 2) DEFAULT 0 CHECK (descuento_total >= 0),
    total DECIMAL(12, 2) CHECK (total > 0) NOT NULL,
    observaciones TEXT,
    anulada BOOLEAN DEFAULT FALSE,
    fecha_anulacion TIMESTAMP,
    motivo_anulacion TEXT,
    fecha_venta TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para venta
CREATE INDEX idx_venta_vendedor_fecha ON venta(vendedor_id, fecha_venta DESC);
CREATE INDEX idx_venta_numero ON venta(numero_venta);
CREATE INDEX idx_venta_fecha ON venta(fecha_venta DESC);
CREATE INDEX idx_venta_anulada ON venta(anulada, fecha_venta DESC);

-- ============================================
-- TABLA: DETALLE_VENTA (Sprint 3)
-- ============================================
CREATE TABLE detalle_venta (
    id SERIAL PRIMARY KEY,
    venta_id INTEGER NOT NULL REFERENCES venta(id) ON DELETE CASCADE,
    producto_id INTEGER NOT NULL REFERENCES producto(id) ON DELETE PROTECT,
    producto_sku VARCHAR(50) NOT NULL,
    producto_nombre VARCHAR(200) NOT NULL,
    cantidad INTEGER CHECK (cantidad > 0) NOT NULL,
    precio_unitario DECIMAL(10, 2) CHECK (precio_unitario > 0) NOT NULL,
    descuento_unitario DECIMAL(10, 2) DEFAULT 0 CHECK (descuento_unitario >= 0),
    subtotal_linea DECIMAL(12, 2) CHECK (subtotal_linea >= 0) NOT NULL,
    total_linea DECIMAL(12, 2) CHECK (total_linea >= 0) NOT NULL
);

-- Índices para detalle_venta
CREATE INDEX idx_detalle_venta ON detalle_venta(venta_id);
CREATE INDEX idx_detalle_producto ON detalle_venta(producto_id);

-- ============================================
-- TABLA: METODO_PAGO (Sprint 3)
-- ============================================
CREATE TABLE metodo_pago (
    id SERIAL PRIMARY KEY,
    venta_id INTEGER NOT NULL REFERENCES venta(id) ON DELETE CASCADE,
    tipo_pago VARCHAR(20) CHECK (tipo_pago IN (
        'efectivo', 'debito', 'credito', 'transferencia', 'otro'
    )) NOT NULL,
    monto DECIMAL(12, 2) CHECK (monto > 0) NOT NULL,
    referencia VARCHAR(100)
);

-- Índices para metodo_pago
CREATE INDEX idx_metodo_pago_venta ON metodo_pago(venta_id);
CREATE INDEX idx_metodo_pago_tipo ON metodo_pago(tipo_pago);

-- ============================================
-- TABLA: MOVIMIENTO_INVENTARIO (Sprint 2 - con venta_relacionada)
-- ============================================
CREATE TABLE movimiento_inventario (
    id SERIAL PRIMARY KEY,
    producto_id INTEGER NOT NULL REFERENCES producto(id) ON DELETE CASCADE,
    tipo_movimiento VARCHAR(30) CHECK (tipo_movimiento IN (
        'ajuste_manual', 'venta', 'reserva', 'confirmacion_reserva',
        'cancelacion_reserva', 'devolucion', 'merma', 'ingreso_compra', 'correccion'
    )) NOT NULL,
    cantidad INTEGER NOT NULL,
    stock_anterior INTEGER NOT NULL,
    stock_posterior INTEGER NOT NULL,
    motivo TEXT NOT NULL,
    usuario_id INTEGER,
    venta_relacionada_id INTEGER REFERENCES venta(id) ON DELETE SET NULL,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Índices para movimiento_inventario
CREATE INDEX idx_movimiento_producto_fecha ON movimiento_inventario(producto_id, fecha DESC);
CREATE INDEX idx_movimiento_tipo ON movimiento_inventario(tipo_movimiento);
CREATE INDEX idx_movimiento_venta ON movimiento_inventario(venta_relacionada_id);
CREATE INDEX idx_movimiento_usuario ON movimiento_inventario(usuario_id);

-- ============================================
-- DATOS DE PRUEBA: PRODUCTOS
-- ============================================
INSERT INTO producto (sku, nombre, descripcion, categoria_id, precio_compra, precio_venta, stock_disponible, stock_minimo) VALUES
('PKM-SV01-001', 'Booster Pack Pokémon Escarlata y Púrpura', 'Sobre con 10 cartas aleatorias de la expansión Escarlata y Púrpura', 1, 2500.00, 3500.00, 50, 10),
('PKM-SV01-002', 'Elite Trainer Box Pokémon Escarlata', 'Caja con 9 sobres, accesorios y carta promo', 1, 28000.00, 38000.00, 8, 5),
('YGO-PHNI-001', 'Booster Pack Yu-Gi-Oh! Phantom Nightmare', 'Sobre con 9 cartas de la expansión Phantom Nightmare', 2, 2800.00, 4000.00, 30, 10),
('YGO-SD-001', 'Structure Deck Cyber Strike', 'Mazo preconstruido de 40 cartas temático Cyber', 2, 8000.00, 12000.00, 3, 5),
('MTG-LCI-001', 'Draft Booster Magic Lost Caverns of Ixalan', 'Sobre draft con 15 cartas de Lost Caverns of Ixalan', 3, 3500.00, 5000.00, 40, 15),
('MTG-LCI-002', 'Set Booster Magic Lost Caverns of Ixalan', 'Sobre set con 12 cartas optimizado para coleccionistas', 3, 4000.00, 5500.00, 25, 10),
('OP01-001', 'Booster Pack One Piece Romance Dawn', 'Sobre con 12 cartas de la primera expansión', 4, 3000.00, 4200.00, 20, 8),
('DGM-BT01-001', 'Booster Pack Digimon Release Special', 'Sobre con cartas de Digimon Card Game', 5, 2800.00, 3800.00, 15, 5),
('JDM-CAT-001', 'Catan - Juego de Mesa', 'Juego de estrategia clásico para 3-4 jugadores', 6, 18000.00, 25000.00, 4, 2),
('JDM-TKT-001', 'Ticket to Ride - Europa', 'Juego de trenes y rutas por Europa', 6, 22000.00, 32000.00, 3, 2),
('ACC-SLV-001', 'Sleeves Ultra Pro 100 unidades', 'Protectores de cartas tamaño estándar', 7, 3000.00, 4500.00, 25, 10),
('ACC-DB-001', 'Deck Box Ultimate Guard 80+', 'Caja rígida para almacenar 80 cartas con divisor', 7, 5000.00, 7500.00, 12, 5),
('ACC-PM-001', 'Playmat Dragon Shield - Negro', 'Tapete de juego 60x35cm antideslizante', 7, 8000.00, 12000.00, 8, 3);

-- ============================================
-- COMENTARIOS Y DOCUMENTACIÓN
-- ============================================

COMMENT ON TABLE categoria IS 'Categorías dinámicas de productos (agregada en Sprint 2)';
COMMENT ON TABLE producto IS 'Inventario principal de productos con stock disponible y reservado';
COMMENT ON TABLE venta IS 'Registro de ventas con número único generado';
COMMENT ON TABLE detalle_venta IS 'Líneas de detalle de cada venta con snapshot de producto';
COMMENT ON TABLE metodo_pago IS 'Métodos de pago utilizados en cada venta (soporta pago mixto)';
COMMENT ON TABLE movimiento_inventario IS 'Auditoría inmutable de todos los movimientos de stock';

COMMENT ON COLUMN producto.categoria_id IS 'Relación con categoría dinámica (FK en lugar de choices)';
COMMENT ON COLUMN producto.stock_disponible IS 'Stock disponible para venta inmediata';
COMMENT ON COLUMN producto.stock_reservado IS 'Stock apartado por reservas de clientes';
COMMENT ON COLUMN detalle_venta.producto_sku IS 'SKU del producto al momento de la venta (snapshot)';
COMMENT ON COLUMN detalle_venta.producto_nombre IS 'Nombre del producto al momento de la venta (snapshot)';
COMMENT ON COLUMN detalle_venta.precio_unitario IS 'Precio unitario al momento de la venta (snapshot)';
COMMENT ON COLUMN movimiento_inventario.venta_relacionada_id IS 'Venta que generó el movimiento (agregado en Sprint 3)';

-- ============================================
-- PERMISOS Y SEGURIDAD
-- ============================================

-- Crear rol de aplicación
CREATE ROLE mundo_cartas_app WITH LOGIN PASSWORD 'cambiar_password_en_produccion';

-- Otorgar permisos
GRANT CONNECT ON DATABASE mundo_cartas_db TO mundo_cartas_app;
GRANT USAGE ON SCHEMA public TO mundo_cartas_app;
GRANT SELECT, INSERT, UPDATE, DELETE ON ALL TABLES IN SCHEMA public TO mundo_cartas_app;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO mundo_cartas_app;

-- ============================================
-- VISTAS ÚTILES
-- ============================================

-- Vista: Productos con stock bajo
CREATE OR REPLACE VIEW productos_stock_bajo AS
SELECT 
    p.id,
    p.sku,
    p.nombre,
    c.nombre AS categoria,
    p.stock_disponible,
    p.stock_minimo,
    p.precio_venta
FROM producto p
INNER JOIN categoria c ON p.categoria_id = c.id
WHERE p.activo = TRUE 
  AND p.stock_disponible <= p.stock_minimo
ORDER BY p.stock_disponible ASC;

-- Vista: Resumen de ventas por vendedor
CREATE OR REPLACE VIEW ventas_por_vendedor AS
SELECT 
    v.vendedor_id,
    COUNT(v.id) AS total_ventas,
    SUM(v.total) AS total_vendido,
    AVG(v.total) AS ticket_promedio,
    DATE(v.fecha_venta) AS fecha
FROM venta v
WHERE v.anulada = FALSE
GROUP BY v.vendedor_id, DATE(v.fecha_venta)
ORDER BY fecha DESC, total_vendido DESC;

-- ============================================
-- FUNCIONES ÚTILES
-- ============================================

-- Función: Generar número de venta único
CREATE OR REPLACE FUNCTION generar_numero_venta()
RETURNS VARCHAR AS $$
DECLARE
    fecha_actual DATE := CURRENT_DATE;
    correlativo INTEGER;
    numero_venta VARCHAR(20);
BEGIN
    -- Obtener el último correlativo del día
    SELECT COALESCE(MAX(
        CAST(SUBSTRING(numero_venta FROM 14) AS INTEGER)
    ), 0) + 1 INTO correlativo
    FROM venta
    WHERE DATE(fecha_venta) = fecha_actual;
    
    -- Formato: V-YYYYMMDD-NNNN
    numero_venta := 'V-' || 
                    TO_CHAR(fecha_actual, 'YYYYMMDD') || '-' ||
                    LPAD(correlativo::TEXT, 4, '0');
    
    RETURN numero_venta;
END;
$$ LANGUAGE plpgsql;

-- ============================================
-- VERIFICACIONES DE INTEGRIDAD
-- ============================================

-- Verificar que precio_venta > precio_compra en todos los productos
DO $$
DECLARE
    productos_invalidos INTEGER;
BEGIN
    SELECT COUNT(*) INTO productos_invalidos
    FROM producto
    WHERE precio_venta <= precio_compra;
    
    IF productos_invalidos > 0 THEN
        RAISE WARNING 'Hay % productos con precio de venta menor o igual al precio de compra', productos_invalidos;
    END IF;
END $$;

-- Verificar que todas las categorías base existan
DO $$
DECLARE
    categorias_faltantes INTEGER;
BEGIN
    SELECT 8 - COUNT(*) INTO categorias_faltantes
    FROM categoria
    WHERE nombre IN (
        'TCG Pokémon', 'TCG Yu-Gi-Oh!', 'TCG Magic', 'TCG One Piece',
        'TCG Digimon', 'Juegos de Mesa', 'Accesorios', 'Otros'
    );
    
    IF categorias_faltantes > 0 THEN
        RAISE WARNING 'Faltan % categorías base', categorias_faltantes;
    END IF;
END $$;

-- ============================================
-- FIN DEL SCRIPT
-- ============================================

-- Mostrar resumen
SELECT 'Base de datos mundo_cartas_db creada exitosamente' AS resultado;
SELECT 'Total de categorías: ' || COUNT(*) FROM categoria;
SELECT 'Total de productos: ' || COUNT(*) FROM producto;

-- Instrucciones de uso:
-- 1. Ejecutar este script en PostgreSQL 15+
-- 2. Cambiar password de mundo_cartas_app en producción
-- 3. Ajustar LC_COLLATE y LC_CTYPE según el sistema
-- 4. Ejecutar migraciones de Django después de crear la base de datos
