-- =============================================
-- BUNDLE B3 - ESTADOS Y FINALIZACIÓN
-- ChinchuLink - Sistema de Gestión de Restaurante
-- Descripción: Stored Procedures para cierre y cancelación de pedidos
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

PRINT 'INICIANDO BUNDLE B3 - ESTADOS Y FINALIZACION'
PRINT '==============================================='
PRINT 'Instalando funcionalidad de cierre y cancelacion de pedidos...'
PRINT ''

-- =============================================
-- SP 1: CERRAR PEDIDO
-- =============================================

PRINT 'Creando SP: sp_CerrarPedido...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CerrarPedido]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_CerrarPedido]
GO

CREATE PROCEDURE [dbo].[sp_CerrarPedido]
    @pedido_id INT,
    @mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Variables locales
        DECLARE @estado_cerrado_id INT
        DECLARE @pedido_existe INT = 0
        DECLARE @estado_actual NVARCHAR(50)
        DECLARE @tiene_items INT = 0
        
        -- Inicializar variables de salida
        SET @mensaje = ''
        
        -- 1. VALIDAR PEDIDO
        SELECT @pedido_existe = COUNT(*), @estado_actual = MAX(ep.nombre)
        FROM PEDIDO p
        INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
        WHERE p.pedido_id = @pedido_id
        
        IF @pedido_existe = 0
        BEGIN
            SET @mensaje = 'Error: El pedido no existe'
            ROLLBACK TRANSACTION
            RETURN -1
        END
        
        -- 2. VALIDAR QUE EL PEDIDO NO ESTÉ YA CERRADO
        IF @estado_actual IN ('Cerrado', 'Cancelado')
        BEGIN
            SET @mensaje = 'Error: El pedido ya está ' + @estado_actual
            ROLLBACK TRANSACTION
            RETURN -2
        END
        
        -- 3. VALIDAR QUE EL PEDIDO TENGA ITEMS
        SELECT @tiene_items = COUNT(*)
        FROM DETALLE_PEDIDO
        WHERE pedido_id = @pedido_id
        
        IF @tiene_items = 0
        BEGIN
            SET @mensaje = 'Error: No se puede cerrar un pedido sin items'
            ROLLBACK TRANSACTION
            RETURN -3
        END
        
        -- 4. RECALCULAR TOTALES ANTES DE CERRAR
        DECLARE @total_calculado DECIMAL(10,2)
        DECLARE @msg_calculo NVARCHAR(500)
        
        EXEC sp_CalcularTotalPedido @pedido_id, @total_calculado OUTPUT, @msg_calculo OUTPUT
        
        -- 5. OBTENER ID DEL ESTADO "CERRADO"
        SELECT @estado_cerrado_id = estado_id
        FROM ESTADO_PEDIDO
        WHERE nombre = 'Cerrado'
        
        IF @estado_cerrado_id IS NULL
        BEGIN
            SET @mensaje = 'Error: No se encontró el estado "Cerrado"'
            ROLLBACK TRANSACTION
            RETURN -4
        END
        
        -- 6. CERRAR EL PEDIDO
        UPDATE PEDIDO
        SET 
            estado_id = @estado_cerrado_id,
            fecha_entrega = GETDATE()
        WHERE pedido_id = @pedido_id
        
        SET @mensaje = 'Pedido cerrado exitosamente. Total: $' + CAST(@total_calculado AS VARCHAR)
        
        COMMIT TRANSACTION
        RETURN 0
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SET @mensaje = 'Error inesperado: ' + ERROR_MESSAGE()
        RETURN -99
    END CATCH
END
GO

-- =============================================
-- SP 2: CANCELAR PEDIDO
-- =============================================

PRINT 'Creando SP: sp_CancelarPedido...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CancelarPedido]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_CancelarPedido]
GO

CREATE PROCEDURE [dbo].[sp_CancelarPedido]
    @pedido_id INT,
    @motivo NVARCHAR(255) = NULL,
    @mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Variables locales
        DECLARE @estado_cancelado_id INT
        DECLARE @pedido_existe INT = 0
        DECLARE @estado_actual NVARCHAR(50)
        
        -- Inicializar variables de salida
        SET @mensaje = ''
        
        -- 1. VALIDAR PEDIDO
        SELECT @pedido_existe = COUNT(*), @estado_actual = MAX(ep.nombre)
        FROM PEDIDO p
        INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
        WHERE p.pedido_id = @pedido_id
        
        IF @pedido_existe = 0
        BEGIN
            SET @mensaje = 'Error: El pedido no existe'
            ROLLBACK TRANSACTION
            RETURN -1
        END
        
        -- 2. VALIDAR QUE EL PEDIDO NO ESTÉ YA CERRADO O CANCELADO
        IF @estado_actual IN ('Cerrado', 'Cancelado')
        BEGIN
            SET @mensaje = 'Error: No se puede cancelar un pedido ' + @estado_actual
            ROLLBACK TRANSACTION
            RETURN -2
        END
        
        -- 3. OBTENER ID DEL ESTADO "CANCELADO"
        SELECT @estado_cancelado_id = estado_id
        FROM ESTADO_PEDIDO
        WHERE nombre = 'Cancelado'
        
        IF @estado_cancelado_id IS NULL
        BEGIN
            SET @mensaje = 'Error: No se encontró el estado "Cancelado"'
            ROLLBACK TRANSACTION
            RETURN -3
        END
        
        -- 4. CANCELAR EL PEDIDO
        UPDATE PEDIDO
        SET 
            estado_id = @estado_cancelado_id,
            fecha_entrega = GETDATE(),
            observaciones = ISNULL(observaciones, '') + 
                CASE 
                    WHEN observaciones IS NOT NULL THEN ' | CANCELADO: ' + ISNULL(@motivo, 'Sin motivo especificado')
                    ELSE 'CANCELADO: ' + ISNULL(@motivo, 'Sin motivo especificado')
                END
        WHERE pedido_id = @pedido_id
        
        SET @mensaje = 'Pedido cancelado exitosamente'
        IF @motivo IS NOT NULL
            SET @mensaje = @mensaje + '. Motivo: ' + @motivo
        
        COMMIT TRANSACTION
        RETURN 0
        
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        SET @mensaje = 'Error inesperado: ' + ERROR_MESSAGE()
        RETURN -99
    END CATCH
END
GO

-- =============================================
-- VALIDACIÓN
-- =============================================

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CerrarPedido]') AND type in (N'P', N'PC'))
    PRINT 'sp_CerrarPedido: Creado exitosamente'
ELSE
    PRINT 'sp_CerrarPedido: ERROR en la creacion'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CancelarPedido]') AND type in (N'P', N'PC'))
    PRINT 'sp_CancelarPedido: Creado exitosamente'
ELSE
    PRINT 'sp_CancelarPedido: ERROR en la creacion'

PRINT ''
PRINT 'BUNDLE B3 - ESTADOS Y FINALIZACION COMPLETADO!'
PRINT '================================================='
PRINT 'Estado: SPs de finalizacion de pedidos instalados'
PRINT 'Funcionalidad: sp_CerrarPedido OK'
PRINT 'Funcionalidad: sp_CancelarPedido OK'
PRINT ''
PRINT 'FUNCIONES DISPONIBLES:'
PRINT '   - Cerrar pedidos con validaciones completas'
PRINT '   - Cancelar pedidos con motivo registrado'
PRINT '   - Recalculo automatico de totales al cierre'
PRINT '   - Control de estados y transiciones validas'
PRINT ''
PRINT 'RESUMEN BUNDLE B COMPLETO (B1+B2+B3):'
PRINT '   OK sp_CrearPedido: Crear pedidos'
PRINT '   OK sp_AgregarItemPedido: Agregar items'
PRINT '   OK sp_CalcularTotalPedido: Calcular totales'
PRINT '   OK sp_CerrarPedido: Cerrar pedidos'
PRINT '   OK sp_CancelarPedido: Cancelar pedidos'
PRINT ''
PRINT 'SIGUIENTE PASO: Ejecutar Bundle_C_Seguridad.sql'
PRINT '================================================='
GO