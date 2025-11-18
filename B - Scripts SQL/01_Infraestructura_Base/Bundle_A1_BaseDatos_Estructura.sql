-- =============================================
-- BUNDLE A1 - BASE DE DATOS Y ESTRUCTURA
-- ChinchuLink - Sistema de Gestión de Restaurante
-- Descripción: Creación de base de datos y estructura de tablas
-- Desarrollado por: SQLeaders S.A.
-- Proyecto Educativo ISTEA - Uso académico exclusivo
--  PROHIBIDA LA COMERCIALIZACIÓN 
-- =============================================

PRINT ' INICIANDO BUNDLE A1 - BASE DE DATOS Y ESTRUCTURA'
PRINT '=================================================='
PRINT 'Creando base de datos y estructura de tablas del sistema ChinchuLink...'
PRINT ''

-- =============================================
-- PASO 1: CREAR BASE DE DATOS
-- =============================================

PRINT ' Paso 1/2: Creando base de datos...'

-- Verificar si la base de datos existe
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Chinchulink')
BEGIN
    CREATE DATABASE Chinchulink
    PRINT 'Base de datos Chinchulink creada exitosamente'
END
ELSE
BEGIN
    PRINT 'Base de datos Chinchulink ya existe'
END
GO

-- Usar la base de datos
USE Chinchulink
GO

-- Configuraciones iniciales
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- PASO 2: CREAR TABLAS
-- =============================================

PRINT 'Paso 2/2: Creando estructura de tablas...'

-- TABLAS BASE Y CATÁLOGOS
CREATE TABLE SUCURSAL (
    sucursal_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    direccion NVARCHAR(255) NOT NULL,
    CONSTRAINT UK_SUCURSAL_nombre UNIQUE (nombre)
)
GO

CREATE TABLE CANAL_VENTA (
    canal_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    CONSTRAINT UK_CANAL_VENTA_nombre UNIQUE (nombre)
)
GO

CREATE TABLE ESTADO_PEDIDO (
    estado_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    orden INT NOT NULL,
    CONSTRAINT UK_ESTADO_PEDIDO_nombre UNIQUE (nombre),
    CONSTRAINT UK_ESTADO_PEDIDO_orden UNIQUE (orden)
)
GO

CREATE TABLE ROL (
    rol_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(50) NOT NULL,
    descripcion NVARCHAR(255) NULL,
    CONSTRAINT UK_ROL_nombre UNIQUE (nombre)
)
GO

-- TABLAS DE UBICACIÓN Y PERSONAL
CREATE TABLE MESA (
    mesa_id INT IDENTITY(1,1) PRIMARY KEY,
    numero INT NOT NULL,
    capacidad INT NOT NULL CHECK (capacidad > 0),
    sucursal_id INT NOT NULL,
    qr_token NVARCHAR(255) NOT NULL,
    activa BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_MESA_sucursal FOREIGN KEY (sucursal_id) REFERENCES SUCURSAL(sucursal_id),
    CONSTRAINT UK_MESA_numero_sucursal UNIQUE (numero, sucursal_id),
    CONSTRAINT UK_MESA_qr_token UNIQUE (qr_token)
)
GO

CREATE TABLE EMPLEADO (
    empleado_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    usuario NVARCHAR(50) NOT NULL,
    hash_password NVARCHAR(255) NOT NULL,
    rol_id INT NOT NULL,
    sucursal_id INT NOT NULL,
    activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_EMPLEADO_rol FOREIGN KEY (rol_id) REFERENCES ROL(rol_id),
    CONSTRAINT FK_EMPLEADO_sucursal FOREIGN KEY (sucursal_id) REFERENCES SUCURSAL(sucursal_id),
    CONSTRAINT UK_EMPLEADO_usuario UNIQUE (usuario)
)
GO

-- TABLAS DE CLIENTES
CREATE TABLE CLIENTE (
    cliente_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    telefono NVARCHAR(20) NULL,
    email NVARCHAR(100) NULL,
    doc_tipo NVARCHAR(10) NULL,
    doc_nro NVARCHAR(20) NULL,
    CONSTRAINT UK_CLIENTE_email UNIQUE (email),
    CONSTRAINT UK_CLIENTE_documento UNIQUE (doc_tipo, doc_nro)
)
GO

CREATE TABLE DOMICILIO (
    domicilio_id INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    calle NVARCHAR(100) NOT NULL,
    numero NVARCHAR(10) NOT NULL,
    piso NVARCHAR(10) NULL,
    depto NVARCHAR(10) NULL,
    localidad NVARCHAR(50) NOT NULL,
    provincia NVARCHAR(50) NOT NULL,
    observaciones NVARCHAR(255) NULL,
    es_principal BIT NOT NULL DEFAULT 0,
    CONSTRAINT FK_DOMICILIO_cliente FOREIGN KEY (cliente_id) REFERENCES CLIENTE(cliente_id)
)
GO

-- TABLAS DE PRODUCTOS Y PRECIOS
CREATE TABLE PLATO (
    plato_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    categoria NVARCHAR(50) NOT NULL,
    activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT UK_PLATO_nombre UNIQUE (nombre)
)
GO

CREATE TABLE PRECIO (
    precio_id INT IDENTITY(1,1) PRIMARY KEY,
    plato_id INT NOT NULL,
    vigencia_desde DATE NOT NULL,
    vigencia_hasta DATE NULL,
    precio DECIMAL(10,2) NOT NULL CHECK (precio >= 0),
    CONSTRAINT FK_PRECIO_plato FOREIGN KEY (plato_id) REFERENCES PLATO(plato_id),
    CONSTRAINT CK_PRECIO_vigencia CHECK (vigencia_hasta IS NULL OR vigencia_hasta >= vigencia_desde)
)
GO

CREATE TABLE COMBO (
    combo_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    vigencia_desde DATE NOT NULL,
    vigencia_hasta DATE NULL,
    precio_combo DECIMAL(10,2) NOT NULL CHECK (precio_combo >= 0),
    activo BIT NOT NULL DEFAULT 1,
    CONSTRAINT UK_COMBO_nombre UNIQUE (nombre),
    CONSTRAINT CK_COMBO_vigencia CHECK (vigencia_hasta IS NULL OR vigencia_hasta >= vigencia_desde)
)
GO

CREATE TABLE COMBO_DETALLE (
    combo_id INT NOT NULL,
    plato_id INT NOT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    CONSTRAINT PK_COMBO_DETALLE PRIMARY KEY (combo_id, plato_id),
    CONSTRAINT FK_COMBO_DETALLE_combo FOREIGN KEY (combo_id) REFERENCES COMBO(combo_id),
    CONSTRAINT FK_COMBO_DETALLE_plato FOREIGN KEY (plato_id) REFERENCES PLATO(plato_id)
)
GO

-- TABLAS DE PROMOCIONES
CREATE TABLE PROMOCION (
    promocion_id INT IDENTITY(1,1) PRIMARY KEY,
    nombre NVARCHAR(100) NOT NULL,
    tipo NVARCHAR(50) NOT NULL,
    vigencia_desde DATE NOT NULL,
    vigencia_hasta DATE NULL,
    activa BIT NOT NULL DEFAULT 1,
    regla_json NVARCHAR(MAX) NULL,
    CONSTRAINT UK_PROMOCION_nombre UNIQUE (nombre),
    CONSTRAINT CK_PROMOCION_vigencia CHECK (vigencia_hasta IS NULL OR vigencia_hasta >= vigencia_desde)
)
GO

CREATE TABLE PROMOCION_PLATO (
    promocion_id INT NOT NULL,
    plato_id INT NOT NULL,
    CONSTRAINT PK_PROMOCION_PLATO PRIMARY KEY (promocion_id, plato_id),
    CONSTRAINT FK_PROMOCION_PLATO_promocion FOREIGN KEY (promocion_id) REFERENCES PROMOCION(promocion_id),
    CONSTRAINT FK_PROMOCION_PLATO_plato FOREIGN KEY (plato_id) REFERENCES PLATO(plato_id)
)
GO

-- TABLAS DE PEDIDOS
CREATE TABLE PEDIDO (
    pedido_id INT IDENTITY(1,1) PRIMARY KEY,
    fecha_pedido DATETIME NOT NULL DEFAULT GETDATE(),
    fecha_entrega DATETIME NULL,
    canal_id INT NOT NULL,
    mesa_id INT NULL,
    cliente_id INT NULL,
    domicilio_id INT NULL,
    cant_comensales INT NULL,
    estado_id INT NOT NULL,
    tomado_por_empleado_id INT NOT NULL,
    entregado_por_empleado_id INT NULL,
    total DECIMAL(10,2) NOT NULL DEFAULT 0,
    observaciones NVARCHAR(500) NULL,
    CONSTRAINT FK_PEDIDO_canal FOREIGN KEY (canal_id) REFERENCES CANAL_VENTA(canal_id),
    CONSTRAINT FK_PEDIDO_mesa FOREIGN KEY (mesa_id) REFERENCES MESA(mesa_id),
    CONSTRAINT FK_PEDIDO_cliente FOREIGN KEY (cliente_id) REFERENCES CLIENTE(cliente_id),
    CONSTRAINT FK_PEDIDO_domicilio FOREIGN KEY (domicilio_id) REFERENCES DOMICILIO(domicilio_id),
    CONSTRAINT FK_PEDIDO_estado FOREIGN KEY (estado_id) REFERENCES ESTADO_PEDIDO(estado_id),
    CONSTRAINT FK_PEDIDO_tomado_por FOREIGN KEY (tomado_por_empleado_id) REFERENCES EMPLEADO(empleado_id),
    CONSTRAINT FK_PEDIDO_entregado_por FOREIGN KEY (entregado_por_empleado_id) REFERENCES EMPLEADO(empleado_id)
)
GO

CREATE TABLE DETALLE_PEDIDO (
    detalle_id INT IDENTITY(1,1) PRIMARY KEY,
    pedido_id INT NOT NULL,
    plato_id INT NULL,
    combo_id INT NULL,
    cantidad INT NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10,2) NOT NULL CHECK (precio_unitario >= 0),
    promocion_id INT NULL,
    subtotal DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    CONSTRAINT FK_DETALLE_PEDIDO_pedido FOREIGN KEY (pedido_id) REFERENCES PEDIDO(pedido_id),
    CONSTRAINT FK_DETALLE_PEDIDO_plato FOREIGN KEY (plato_id) REFERENCES PLATO(plato_id),
    CONSTRAINT FK_DETALLE_PEDIDO_combo FOREIGN KEY (combo_id) REFERENCES COMBO(combo_id),
    CONSTRAINT FK_DETALLE_PEDIDO_promocion FOREIGN KEY (promocion_id) REFERENCES PROMOCION(promocion_id),
    CONSTRAINT CK_DETALLE_PEDIDO_plato_o_combo CHECK (
        (plato_id IS NOT NULL AND combo_id IS NULL) OR
        (plato_id IS NULL AND combo_id IS NOT NULL)
    )
)
GO

-- TABLA DE AUDITORÍA
CREATE TABLE AUDITORIA (
    auditoria_id INT IDENTITY(1,1) PRIMARY KEY,
    tabla_afectada NVARCHAR(50) NOT NULL,
    operacion NVARCHAR(10) NOT NULL,
    pedido_id INT NULL,
    detalle_id INT NULL,
    usuario NVARCHAR(50) NOT NULL,
    fecha DATETIME NOT NULL DEFAULT GETDATE(),
    datos_anteriores NVARCHAR(MAX) NULL,
    datos_nuevos NVARCHAR(MAX) NULL,
    CONSTRAINT FK_AUDITORIA_pedido FOREIGN KEY (pedido_id) REFERENCES PEDIDO(pedido_id)
)
GO

PRINT 'Estructura de tablas creada exitosamente'
PRINT ''
PRINT 'RESUMEN BUNDLE A1:'
PRINT '   - Base de datos: Chinchulink '
PRINT '   - Tablas creadas: 17 '
PRINT '   - Foreign Keys configuradas '
PRINT '   - Check Constraints aplicadas '
PRINT ''
PRINT 'SIGUIENTE PASO: Ejecutar Bundle_A2_Indices_Datos.sql'
PRINT '=================================================='
GO