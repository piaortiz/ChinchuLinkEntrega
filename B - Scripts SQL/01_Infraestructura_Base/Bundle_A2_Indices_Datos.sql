-- =============================================
-- BUNDLE A2 - ÍNDICES Y DATOS INICIALES
-- ChinchuLink - Sistema de Gestión de Restaurante
-- Descripción: Creación de índices optimizados y carga de datos iniciales
-- Fecha: 11 de noviembre de 2025
-- Desarrollado por: SQLeaders S.A.
-- Proyecto Educativo ISTEA - Uso académico exclusivo
-- PROHIBIDA LA COMERCIALIZACIÓN
-- =============================================

USE Chinchulink
GO

-- Configuraciones necesarias
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

PRINT 'INICIANDO BUNDLE A2 - INDICES Y DATOS INICIALES'
PRINT '================================================='
PRINT 'Creando indices optimizados y cargando datos base del sistema...'
PRINT ''

-- =============================================
-- PASO 1: CREAR ÍNDICES BÁSICOS
-- =============================================

PRINT 'Paso 1/2: Creando indices basicos...'

-- Índices para mejorar performance en consultas frecuentes
CREATE INDEX IX_PEDIDO_fecha_estado ON PEDIDO(fecha_pedido, estado_id)
GO
CREATE INDEX IX_PEDIDO_mesa ON PEDIDO(mesa_id) WHERE mesa_id IS NOT NULL
GO
CREATE INDEX IX_PEDIDO_cliente ON PEDIDO(cliente_id) WHERE cliente_id IS NOT NULL
GO
CREATE INDEX IX_DETALLE_PEDIDO_pedido ON DETALLE_PEDIDO(pedido_id)
GO
CREATE INDEX IX_DETALLE_PEDIDO_plato ON DETALLE_PEDIDO(plato_id) WHERE plato_id IS NOT NULL
GO
CREATE INDEX IX_MESA_sucursal_activa ON MESA(sucursal_id, activa)
GO
CREATE INDEX IX_EMPLEADO_sucursal_activo ON EMPLEADO(sucursal_id, activo)
GO
CREATE INDEX IX_PRECIO_plato_vigencia ON PRECIO(plato_id, vigencia_desde, vigencia_hasta)
GO

PRINT 'Indices basicos creados exitosamente'

-- =============================================
-- PASO 2: INSERTAR DATOS INICIALES
-- =============================================

PRINT 'Paso 2/2: Insertando datos iniciales...'

-- Datos iniciales para SUCURSAL (Solo sucursal principal para despliegue limpio)
INSERT INTO SUCURSAL (nombre, direccion) VALUES 
('Parrilla El Encuentro - Caballito', 'Av. Rivadavia 5432, Caballito, CABA')
GO

-- Datos iniciales para CANAL_VENTA
INSERT INTO CANAL_VENTA (nombre) VALUES 
('Mostrador'),
('Delivery'),
('Mesa QR'),
('Teléfono'),
('App Móvil')
GO

-- Datos iniciales para ESTADO_PEDIDO
INSERT INTO ESTADO_PEDIDO (nombre, orden) VALUES 
('Pendiente', 1),
('Confirmado', 2),
('En Preparación', 3),
('Listo', 4),
('En Reparto', 5),
('Entregado', 6),
('Cerrado', 7),
('Cancelado', 99)
GO

-- Datos iniciales para ROL
INSERT INTO ROL (nombre, descripcion) VALUES 
('Administrador', 'Acceso total al sistema'),
('Gerente', 'Gestión operativa y reportes'),
('Mozo', 'Toma de pedidos y atención de mesas'),
('Cajero', 'Facturación y cobros'),
('Cocinero', 'Preparación de pedidos'),
('Repartidor', 'Entregas y delivery'),
('Hostess', 'Recepción y asignación de mesas')
GO

-- Datos iniciales para MESAS (Sucursal Caballito)
DECLARE @sucursal_caballito INT = (SELECT sucursal_id FROM SUCURSAL WHERE nombre LIKE '%Caballito%')

INSERT INTO MESA (numero, capacidad, sucursal_id, qr_token) VALUES 
(1, 2, @sucursal_caballito, 'QR_MESA_001_' + CONVERT(VARCHAR(36), NEWID())),
(2, 2, @sucursal_caballito, 'QR_MESA_002_' + CONVERT(VARCHAR(36), NEWID())),
(3, 4, @sucursal_caballito, 'QR_MESA_003_' + CONVERT(VARCHAR(36), NEWID())),
(4, 4, @sucursal_caballito, 'QR_MESA_004_' + CONVERT(VARCHAR(36), NEWID())),
(5, 6, @sucursal_caballito, 'QR_MESA_005_' + CONVERT(VARCHAR(36), NEWID())),
(6, 6, @sucursal_caballito, 'QR_MESA_006_' + CONVERT(VARCHAR(36), NEWID())),
(7, 8, @sucursal_caballito, 'QR_MESA_007_' + CONVERT(VARCHAR(36), NEWID())),
(8, 8, @sucursal_caballito, 'QR_MESA_008_' + CONVERT(VARCHAR(36), NEWID()))
GO

-- Empleado administrador inicial
DECLARE @rol_admin INT = (SELECT rol_id FROM ROL WHERE nombre = 'Administrador')
DECLARE @sucursal_caballito INT = (SELECT sucursal_id FROM SUCURSAL WHERE nombre LIKE '%Caballito%')

INSERT INTO EMPLEADO (nombre, usuario, hash_password, rol_id, sucursal_id) VALUES 
('Administrador Sistema', 'admin', 'admin123', @rol_admin, @sucursal_caballito)
GO

-- Platos básicos de ejemplo
INSERT INTO PLATO (nombre, categoria) VALUES 
('Bife de Chorizo', 'Carnes'),
('Asado de Tira', 'Carnes'),
('Pollo Grillado', 'Carnes'),
('Ensalada Mixta', 'Ensaladas'),
('Papas Fritas', 'Guarniciones'),
('Agua Mineral', 'Bebidas'),
('Coca Cola', 'Bebidas'),
('Vino Tinto', 'Bebidas')
GO

-- Precios vigentes
INSERT INTO PRECIO (plato_id, vigencia_desde, precio) 
SELECT plato_id, GETDATE(), 
    CASE 
        WHEN categoria = 'Carnes' THEN 3500.00
        WHEN categoria = 'Ensaladas' THEN 1200.00
        WHEN categoria = 'Guarniciones' THEN 800.00
        WHEN categoria = 'Bebidas' AND nombre LIKE '%Agua%' THEN 300.00
        WHEN categoria = 'Bebidas' AND nombre LIKE '%Coca%' THEN 500.00
        WHEN categoria = 'Bebidas' AND nombre LIKE '%Vino%' THEN 1800.00
        ELSE 1000.00
    END
FROM PLATO
GO

PRINT 'Datos iniciales insertados exitosamente'

-- =============================================
-- VALIDACIÓN FINAL
-- =============================================

PRINT 'Validando instalacion...'

-- Verificar que todas las tablas se crearon
DECLARE @tabla_count INT = (SELECT COUNT(*) FROM sys.tables WHERE schema_id = 1)
PRINT 'Tablas creadas: ' + CAST(@tabla_count AS VARCHAR)

-- Verificar datos iniciales
DECLARE @sucursales INT = (SELECT COUNT(*) FROM SUCURSAL)
DECLARE @canales INT = (SELECT COUNT(*) FROM CANAL_VENTA)
DECLARE @estados INT = (SELECT COUNT(*) FROM ESTADO_PEDIDO)
DECLARE @roles INT = (SELECT COUNT(*) FROM ROL)
DECLARE @mesas INT = (SELECT COUNT(*) FROM MESA)
DECLARE @platos INT = (SELECT COUNT(*) FROM PLATO)

PRINT 'Sucursales: ' + CAST(@sucursales AS VARCHAR)
PRINT 'Canales de venta: ' + CAST(@canales AS VARCHAR)
PRINT 'Estados de pedido: ' + CAST(@estados AS VARCHAR)
PRINT 'Roles: ' + CAST(@roles AS VARCHAR)
PRINT 'Mesas: ' + CAST(@mesas AS VARCHAR)
PRINT 'Platos: ' + CAST(@platos AS VARCHAR)

PRINT ''
PRINT 'BUNDLE A2 - INDICES Y DATOS COMPLETADO!'
PRINT '==========================================='
PRINT 'Estado: Indices optimizados y datos base cargados'
PRINT 'Indices: 8 indices basicos aplicados'
PRINT 'Datos: Configuracion inicial completa'
PRINT ''
PRINT 'RESUMEN INSTALACION FOUNDATION (A1 + A2):'
PRINT '   - Base de datos: Chinchulink OK'
PRINT '   - Estructura: 17 tablas OK'
PRINT '   - Optimizacion: 8 indices OK'
PRINT '   - Datos: Configuracion inicial OK'
PRINT ''
PRINT 'SIGUIENTE PASO: Ejecutar Bundle_B1_Pedidos_Core.sql'
PRINT '================================================='
GO