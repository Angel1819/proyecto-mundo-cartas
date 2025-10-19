-- 1. Tabla Usuario
CREATE TABLE Usuario (
  id SERIAL PRIMARY KEY,
  nombre_usuario VARCHAR(50) NOT NULL UNIQUE,
  nombre_completo VARCHAR(100) NOT NULL,
  email VARCHAR(100) NOT NULL UNIQUE,
  contraseña VARCHAR(255) NOT NULL,
  rol ENUM('Administrador','Vendedor') NOT NULL,
  estado ENUM('Activo','Inactivo') NOT NULL DEFAULT 'Activo',
  permiso_aplicar_descuentos BOOLEAN NOT NULL DEFAULT FALSE,
  permiso_crear_reservas BOOLEAN NOT NULL DEFAULT FALSE,
  permiso_editar_inventario BOOLEAN NOT NULL DEFAULT FALSE,
  permiso_cancelar_reservas BOOLEAN NOT NULL DEFAULT FALSE,
  permiso_cierre_caja BOOLEAN NOT NULL DEFAULT FALSE,
  fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
  fecha_actualizacion TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 2. Tabla Producto
CREATE TABLE Producto (
  id SERIAL PRIMARY KEY,
  sku VARCHAR(50) NOT NULL UNIQUE,
  nombre VARCHAR(100) NOT NULL,
  descripcion TEXT,
  categoria ENUM('Pokemon','Yu-Gi-Oh','Magic','One Piece','Digimon','Accesorios','Juegos de Mesa') NOT NULL,
  precio_unitario DECIMAL(12,2) NOT NULL CHECK (precio_unitario>=0),
  stock_disponible INT NOT NULL CHECK (stock_disponible>=0),
  stock_reservado INT NOT NULL DEFAULT 0 CHECK (stock_reservado>=0),
  umbral_minimo_stock INT NOT NULL DEFAULT 5,
  codigo_barras VARCHAR(100) UNIQUE,
  imagen_url VARCHAR(255),
  fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
  fecha_actualizacion TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 3. Tabla Venta
CREATE TABLE Venta (
  id SERIAL PRIMARY KEY,
  usuario_id INT NOT NULL REFERENCES Usuario(id),
  fecha DATE NOT NULL DEFAULT CURRENT_DATE,
  hora TIME NOT NULL DEFAULT CURRENT_TIME,
  subtotal DECIMAL(12,2) NOT NULL,
  descuento_tipo ENUM('Porcentaje','Monto Fijo'),
  descuento_valor DECIMAL(12,2),
  descuento_motivo TEXT,
  total DECIMAL(12,2) NOT NULL,
  metodo_pago ENUM('Efectivo','Transferencia','Redcompra') NOT NULL,
  es_preventa BOOLEAN NOT NULL DEFAULT FALSE,
  reserva_id INT REFERENCES Reserva(id),
  estado ENUM('Completada','Anulada') NOT NULL DEFAULT 'Completada',
  fecha_anulacion TIMESTAMP,
  motivo_anulacion TEXT,
  cliente_rut VARCHAR(20),
  cliente_nombre VARCHAR(100),
  cliente_apellido VARCHAR(100)
);

-- 4. Tabla intermedia VentaProducto
CREATE TABLE VentaProducto (
  id SERIAL PRIMARY KEY,
  venta_id INT NOT NULL REFERENCES Venta(id),
  producto_id INT NOT NULL REFERENCES Producto(id),
  cantidad INT NOT NULL CHECK (cantidad>0),
  precio_unitario DECIMAL(12,2) NOT NULL,
  subtotal DECIMAL(12,2) GENERATED ALWAYS AS (cantidad*precio_unitario) STORED
);

-- 5. Tabla Reserva
CREATE TABLE Reserva (
  id SERIAL PRIMARY KEY,
  usuario_id INT NOT NULL REFERENCES Usuario(id),
  cliente_rut VARCHAR(20) NOT NULL,
  cliente_nombre VARCHAR(100) NOT NULL,
  cliente_apellido VARCHAR(100) NOT NULL,
  cliente_telefono VARCHAR(20),
  fecha_creacion TIMESTAMP NOT NULL DEFAULT NOW(),
  fecha_vencimiento DATE NOT NULL,
  estado ENUM('Pendiente','Confirmada','Cancelada') NOT NULL DEFAULT 'Pendiente',
  fecha_confirmacion TIMESTAMP,
  fecha_cancelacion TIMESTAMP,
  motivo_cancelacion TEXT,
  observaciones TEXT,
  descuento_tipo ENUM('Porcentaje','Monto Fijo'),
  descuento_valor DECIMAL(12,2),
  metodo_pago ENUM('Efectivo','Transferencia','Redcompra')
);

-- 6. Tabla intermedia ReservaProducto
CREATE TABLE ReservaProducto (
  id SERIAL PRIMARY KEY,
  reserva_id INT NOT NULL REFERENCES Reserva(id),
  producto_id INT NOT NULL REFERENCES Producto(id),
  cantidad INT NOT NULL CHECK (cantidad>0),
  precio_unitario DECIMAL(12,2) NOT NULL,
  subtotal DECIMAL(12,2) GENERATED ALWAYS AS (cantidad*precio_unitario) STORED
);

-- 7. Tabla MovimientoInventario
CREATE TABLE MovimientoInventario (
  id SERIAL PRIMARY KEY,
  producto_id INT NOT NULL REFERENCES Producto(id),
  usuario_id INT NOT NULL REFERENCES Usuario(id),
  tipo ENUM('Entrada','Salida') NOT NULL,
  motivo ENUM('Nueva Compra','Devolución','Corrección','Producto Dañado','Venta','Anulación','Reserva Confirmada','Reserva Cancelada','Ajuste Manual','Otro') NOT NULL,
  cantidad INT NOT NULL CHECK (cantidad>0),
  stock_anterior INT NOT NULL,
  stock_resultante INT NOT NULL,
  observaciones TEXT,
  fecha TIMESTAMP NOT NULL DEFAULT NOW()
);

-- 8. Tabla CierreCaja
CREATE TABLE CierreCaja (
  id SERIAL PRIMARY KEY,
  usuario_id INT NOT NULL REFERENCES Usuario(id),
  fecha DATE NOT NULL,
  hora TIME NOT NULL,
  monto_efectivo_registrado DECIMAL(12,2) NOT NULL,
  monto_efectivo_contado DECIMAL(12,2) NOT NULL,
  monto_transferencia_registrado DECIMAL(12,2) NOT NULL,
  monto_transferencia_contado DECIMAL(12,2) NOT NULL,
  monto_redcompra_registrado DECIMAL(12,2) NOT NULL,
  monto_redcompra_contado DECIMAL(12,2) NOT NULL,
  diferencias JSON NOT NULL,
  observaciones TEXT
);

-- 9. Tabla AuditLog
CREATE TABLE AuditLog (
  id SERIAL PRIMARY KEY,
  usuario_id INT NOT NULL REFERENCES Usuario(id),
  accion VARCHAR(100) NOT NULL,
  entidad_afectada VARCHAR(50) NOT NULL,
  id_entidad INT NOT NULL,
  datos_anteriores JSON,
  datos_nuevos JSON NOT NULL,
  ip_usuario VARCHAR(45),
  fecha TIMESTAMP NOT NULL DEFAULT NOW()
);
