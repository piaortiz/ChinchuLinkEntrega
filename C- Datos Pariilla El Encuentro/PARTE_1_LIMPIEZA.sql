-- ============================================================================
-- PARTE 1: LIMPIEZA Y PREPARACIÓN
-- Script de inicialización Parrilla El Encuentro
-- ============================================================================

USE ChinchuLink;
GO

SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;

PRINT '🧹 PARTE 1: LIMPIEZA Y PREPARACIÓN DE DATOS';
PRINT '============================================';

BEGIN TRANSACTION TRX_LIMPIEZA;

PRINT 'Limpiando datos existentes...';

-- Deshabilitar constraints temporalmente para evitar conflictos
PRINT 'Deshabilitando constraints...';
ALTER TABLE DETALLE_PEDIDO NOCHECK CONSTRAINT ALL;
ALTER TABLE PEDIDO NOCHECK CONSTRAINT ALL;
ALTER TABLE STOCK_SIMULADO NOCHECK CONSTRAINT ALL;
ALTER TABLE PROMOCION_PLATO NOCHECK CONSTRAINT ALL;
ALTER TABLE COMBO_DETALLE NOCHECK CONSTRAINT ALL;
ALTER TABLE PRECIO NOCHECK CONSTRAINT ALL;

-- Limpiar en orden por dependencias de Foreign Keys (más profundo)
PRINT 'Limpiando tablas de transacciones...';
DELETE FROM DETALLE_PEDIDO;
DELETE FROM PEDIDO;  -- Limpiar pedidos que referencian mesas y empleados

PRINT 'Limpiando tablas dependientes...';
DELETE FROM STOCK_SIMULADO; 
DELETE FROM PROMOCION_PLATO;
DELETE FROM COMBO_DETALLE;
DELETE FROM PRECIO;

PRINT 'Limpiando tablas principales...';
DELETE FROM PLATO;
DELETE FROM EMPLEADO WHERE empleado_id > 1;  -- Mantener admin principal
DELETE FROM MESA;

-- Habilitar constraints nuevamente
PRINT 'Habilitando constraints...';
ALTER TABLE PRECIO CHECK CONSTRAINT ALL;
ALTER TABLE COMBO_DETALLE CHECK CONSTRAINT ALL;
ALTER TABLE PROMOCION_PLATO CHECK CONSTRAINT ALL;
ALTER TABLE STOCK_SIMULADO CHECK CONSTRAINT ALL;
ALTER TABLE PEDIDO CHECK CONSTRAINT ALL;
ALTER TABLE DETALLE_PEDIDO CHECK CONSTRAINT ALL;

-- Reiniciar contadores IDENTITY
PRINT 'Reiniciando contadores IDENTITY...';
DBCC CHECKIDENT ('PEDIDO', RESEED, 0);
DBCC CHECKIDENT ('DETALLE_PEDIDO', RESEED, 0);
DBCC CHECKIDENT ('PLATO', RESEED, 0);
DBCC CHECKIDENT ('PRECIO', RESEED, 0);
DBCC CHECKIDENT ('EMPLEADO', RESEED, 1);
DBCC CHECKIDENT ('MESA', RESEED, 0);

PRINT 'Limpieza completada - Base preparada para nueva configuración';

-- Verificar estado
PRINT 'Verificando estado después de limpieza...';
SELECT 'PLATOS' as TABLA, COUNT(*) as TOTAL FROM PLATO
UNION ALL
SELECT 'PRECIOS', COUNT(*) FROM PRECIO
UNION ALL
SELECT 'EMPLEADOS', COUNT(*) FROM EMPLEADO
UNION ALL
SELECT 'MESAS', COUNT(*) FROM MESA;

COMMIT TRANSACTION TRX_LIMPIEZA;

PRINT 'PARTE 1 COMPLETADA - Listo para cargar menú';
PRINT '';

GO