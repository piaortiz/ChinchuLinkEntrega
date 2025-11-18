-- =============================================
-- BUNDLE E1 - TRIGGERS PRINCIPALES
-- ChinchuLink - Sistema de Gestión de Restaurante
-- Descripción: Triggers de totales automáticos y auditoría principal
-- Fecha: 11 de noviembre de 2025
-- Desarrollado por: SQLeaders S.A.
-- Proyecto Educativo ISTEA - Uso académico exclusivo
-- PROHIBIDA LA COMERCIALIZACION
-- =============================================

USE ChinchuLink
GO

-- Configuraciones necesarias
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

PRINT 'INICIANDO BUNDLE E1 - TRIGGERS PRINCIPALES'
PRINT '============================================'
PRINT 'Instalando triggers de totales automáticos y auditoría...'
PRINT ''

-- =============================================
-- TRIGGER 1: ACTUALIZAR TOTALES AUTOMÁTICAMENTE
-- =============================================

PRINT 'Creando Trigger: tr_ActualizarTotales...'

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_ActualizarTotales]'))
DROP TRIGGER [dbo].[tr_ActualizarTotales]
GO

CREATE TRIGGER [dbo].[tr_ActualizarTotales]
ON [dbo].[DETALLE_PEDIDO]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Obtener los pedidos afectados
    DECLARE @pedidos_afectados TABLE (pedido_id INT)
    
    -- Desde registros insertados
    INSERT INTO @pedidos_afectados (pedido_id)
    SELECT DISTINCT pedido_id FROM inserted
    
    -- Desde registros eliminados
    INSERT INTO @pedidos_afectados (pedido_id)
    SELECT DISTINCT pedido_id FROM deleted
    WHERE pedido_id NOT IN (SELECT pedido_id FROM @pedidos_afectados)
    
    -- Actualizar totales para cada pedido afectado
    UPDATE p
    SET total = ISNULL(totales.total_calculado, 0)
    FROM PEDIDO p
    INNER JOIN @pedidos_afectados pa ON p.pedido_id = pa.pedido_id
    LEFT JOIN (
        SELECT 
            dp.pedido_id,
            SUM(dp.subtotal) as total_calculado
        FROM DETALLE_PEDIDO dp
        GROUP BY dp.pedido_id
    ) totales ON p.pedido_id = totales.pedido_id
END
GO

-- =============================================
-- TRIGGER 2: AUDITORÍA DE PEDIDOS
-- =============================================

PRINT 'Creando Trigger: tr_AuditoriaPedidos...'

-- Crear tabla de auditoría si no existe (simplificada)
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'AUDITORIA_SIMPLE')
BEGIN
    CREATE TABLE AUDITORIA_SIMPLE (
        auditoria_id INT IDENTITY(1,1) PRIMARY KEY,
        tabla_afectada NVARCHAR(50) NOT NULL,
        registro_id INT NOT NULL,
        accion VARCHAR(20) NOT NULL, -- INSERT, UPDATE, DELETE
        fecha_auditoria DATETIME NOT NULL DEFAULT GETDATE(),
        usuario_sistema VARCHAR(128) NOT NULL DEFAULT SYSTEM_USER,
        datos_resumen NVARCHAR(500) NULL
    )
    PRINT 'Tabla AUDITORIA_SIMPLE creada'
END

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_AuditoriaPedidos]'))
DROP TRIGGER [dbo].[tr_AuditoriaPedidos]
GO

CREATE TRIGGER [dbo].[tr_AuditoriaPedidos]
ON [dbo].[PEDIDO]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Auditoría para INSERT
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AUDITORIA_SIMPLE (tabla_afectada, registro_id, accion, datos_resumen)
        SELECT 
            'PEDIDO',
            i.pedido_id,
            'INSERT',
            'Nuevo pedido - Canal: ' + ISNULL(cv.nombre, 'N/A') + ', Estado: ' + ISNULL(ep.nombre, 'N/A')
        FROM inserted i
        LEFT JOIN ESTADO_PEDIDO ep ON i.estado_id = ep.estado_id
        LEFT JOIN CANAL_VENTA cv ON i.canal_id = cv.canal_id
    END
    
    -- Auditoría para UPDATE
    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AUDITORIA_SIMPLE (tabla_afectada, registro_id, accion, datos_resumen)
        SELECT 
            'PEDIDO',
            i.pedido_id,
            'UPDATE',
            'Estado: ' + ISNULL(ep_old.nombre, 'N/A') + ' → ' + ISNULL(ep_new.nombre, 'N/A') + 
            ', Total: $' + CAST(ISNULL(i.total, 0) AS VARCHAR)
        FROM inserted i
        INNER JOIN deleted d ON i.pedido_id = d.pedido_id
        LEFT JOIN ESTADO_PEDIDO ep_old ON d.estado_id = ep_old.estado_id
        LEFT JOIN ESTADO_PEDIDO ep_new ON i.estado_id = ep_new.estado_id
        WHERE d.estado_id != i.estado_id OR d.total != i.total
    END
    
    -- Auditoría para DELETE
    IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AUDITORIA_SIMPLE (tabla_afectada, registro_id, accion, datos_resumen)
        SELECT 
            'PEDIDO',
            d.pedido_id,
            'DELETE',
            'Pedido eliminado - Total: $' + CAST(ISNULL(d.total, 0) AS VARCHAR)
        FROM deleted d
    END
END
GO

-- =============================================
-- TRIGGER 3: AUDITORÍA DE DETALLE PEDIDOS
-- =============================================

PRINT 'Creando Trigger: tr_AuditoriaDetalle...'

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_AuditoriaDetalle]'))
DROP TRIGGER [dbo].[tr_AuditoriaDetalle]
GO

CREATE TRIGGER [dbo].[tr_AuditoriaDetalle]
ON [dbo].[DETALLE_PEDIDO]
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Auditoría para INSERT
    IF EXISTS (SELECT * FROM inserted) AND NOT EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AUDITORIA_SIMPLE (tabla_afectada, registro_id, accion, datos_resumen)
        SELECT 
            'DETALLE_PEDIDO',
            i.detalle_id,
            'INSERT',
            'Item agregado al pedido ' + CAST(i.pedido_id AS VARCHAR) + 
            ' - Cantidad: ' + CAST(i.cantidad AS VARCHAR) + 
            ', Subtotal: $' + CAST(i.subtotal AS VARCHAR)
        FROM inserted i
    END
    
    -- Auditoría para DELETE
    IF NOT EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO AUDITORIA_SIMPLE (tabla_afectada, registro_id, accion, datos_resumen)
        SELECT 
            'DETALLE_PEDIDO',
            d.detalle_id,
            'DELETE',
            'Item eliminado del pedido ' + CAST(d.pedido_id AS VARCHAR) + 
            ' - Subtotal: $' + CAST(d.subtotal AS VARCHAR)
        FROM deleted d
    END
END
GO

-- =============================================
-- VALIDACIÓN
-- =============================================

-- Verificar triggers creados
DECLARE @triggers_count INT
SELECT @triggers_count = COUNT(*) 
FROM sys.triggers 
WHERE name IN ('tr_ActualizarTotales', 'tr_AuditoriaPedidos', 'tr_AuditoriaDetalle')

PRINT ''
PRINT 'Validando triggers creados...'

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_ActualizarTotales]'))
    PRINT 'tr_ActualizarTotales: Creado exitosamente'
ELSE
    PRINT 'tr_ActualizarTotales: ERROR en la creación'

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_AuditoriaPedidos]'))
    PRINT 'tr_AuditoriaPedidos: Creado exitosamente'
ELSE
    PRINT 'tr_AuditoriaPedidos: ERROR en la creación'

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_AuditoriaDetalle]'))
    PRINT 'tr_AuditoriaDetalle: Creado exitosamente'
ELSE
    PRINT 'tr_AuditoriaDetalle: ERROR en la creación'

PRINT ''
PRINT 'BUNDLE E1 - TRIGGERS PRINCIPALES COMPLETADO!'
PRINT '==============================================='
PRINT 'Estado: Triggers principales instalados'
PRINT 'Funcionalidad: tr_ActualizarTotales'
PRINT 'Funcionalidad: tr_AuditoriaPedidos'
PRINT 'Funcionalidad: tr_AuditoriaDetalle'
PRINT ''
PRINT 'AUTOMATIZACION DISPONIBLE:'
PRINT '   - Cálculo automático de totales de pedidos'
PRINT '   - Auditoría completa de cambios en pedidos'
PRINT '   - Registro automático de items agregados/eliminados'
PRINT '   - Tabla AUDITORIA_SIMPLE para seguimiento'
PRINT ''
PRINT 'SIGUIENTE PASO: Ejecutar Bundle_E2_Control_Avanzado.sql'
PRINT '================================================='
GO