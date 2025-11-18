-- =============================================
-- BUNDLE B2 - ITEMS Y CÁLCULOS
-- ChinchuLink - Sistema de Gestión de Restaurante
-- Descripción: Stored Procedures para manejo de items y cálculos de totales
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

PRINT 'INICIANDO BUNDLE B2 - ITEMS Y CALCULOS'
PRINT '========================================='
PRINT 'Instalando funcionalidad de items y calculos de totales...'
PRINT ''

-- =============================================
-- SP 1: AGREGAR ITEM AL PEDIDO
-- =============================================

PRINT 'Creando SP: sp_AgregarItemPedido...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_AgregarItemPedido]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_AgregarItemPedido]
GO

CREATE PROCEDURE [dbo].[sp_AgregarItemPedido]
    @pedido_id INT,
    @plato_id INT = NULL,
    @combo_id INT = NULL,
    @cantidad INT,
    @promocion_id INT = NULL,
    @detalle_id INT OUTPUT,
    @mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Variables locales
        DECLARE @precio_unitario DECIMAL(10,2) = 0
        DECLARE @subtotal DECIMAL(10,2) = 0
        DECLARE @pedido_existe INT = 0
        DECLARE @estado_pedido NVARCHAR(50)
        
        -- Inicializar variables de salida
        SET @detalle_id = 0
        SET @mensaje = ''
        
        -- 1. VALIDAR PEDIDO
        SELECT @pedido_existe = COUNT(*), @estado_pedido = MAX(ep.nombre)
        FROM PEDIDO p
        INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
        WHERE p.pedido_id = @pedido_id
        
        IF @pedido_existe = 0
        BEGIN
            SET @mensaje = 'Error: El pedido no existe'
            ROLLBACK TRANSACTION
            RETURN -1
        END
        
        IF @estado_pedido NOT IN ('Pendiente', 'Confirmado')
        BEGIN
            SET @mensaje = 'Error: No se pueden agregar items a un pedido en estado: ' + @estado_pedido
            ROLLBACK TRANSACTION
            RETURN -2
        END
        
        -- 2. VALIDAR QUE SE ESPECIFICA PLATO O COMBO (PERO NO AMBOS)
        IF (@plato_id IS NULL AND @combo_id IS NULL) OR (@plato_id IS NOT NULL AND @combo_id IS NOT NULL)
        BEGIN
            SET @mensaje = 'Error: Debe especificar un plato o un combo, pero no ambos'
            ROLLBACK TRANSACTION
            RETURN -3
        END
        
        -- 3. VALIDAR CANTIDAD
        IF @cantidad <= 0
        BEGIN
            SET @mensaje = 'Error: La cantidad debe ser mayor a cero'
            ROLLBACK TRANSACTION
            RETURN -4
        END
        
        -- 4. OBTENER PRECIO UNITARIO
        IF @plato_id IS NOT NULL
        BEGIN
            -- Buscar precio vigente del plato
            SELECT TOP 1 @precio_unitario = precio
            FROM PRECIO
            WHERE plato_id = @plato_id
              AND vigencia_desde <= GETDATE()
              AND (vigencia_hasta IS NULL OR vigencia_hasta >= GETDATE())
            ORDER BY vigencia_desde DESC
            
            IF @precio_unitario = 0
            BEGIN
                SET @mensaje = 'Error: No se encontró precio vigente para el plato'
                ROLLBACK TRANSACTION
                RETURN -5
            END
        END
        ELSE IF @combo_id IS NOT NULL
        BEGIN
            -- Buscar precio del combo
            SELECT @precio_unitario = precio_combo
            FROM COMBO
            WHERE combo_id = @combo_id
              AND activo = 1
              AND vigencia_desde <= GETDATE()
              AND (vigencia_hasta IS NULL OR vigencia_hasta >= GETDATE())
            
            IF @precio_unitario = 0
            BEGIN
                SET @mensaje = 'Error: No se encontró combo vigente o está inactivo'
                ROLLBACK TRANSACTION
                RETURN -6
            END
        END
        
        -- 5. CALCULAR SUBTOTAL
        SET @subtotal = @precio_unitario * @cantidad
        
        -- 6. INSERTAR DETALLE DEL PEDIDO
        INSERT INTO DETALLE_PEDIDO (
            pedido_id,
            plato_id,
            combo_id,
            cantidad,
            precio_unitario,
            subtotal,
            promocion_id
        )
        VALUES (
            @pedido_id,
            @plato_id,
            @combo_id,
            @cantidad,
            @precio_unitario,
            @subtotal,
            @promocion_id
        )
        
        SET @detalle_id = SCOPE_IDENTITY()
        
        SET @mensaje = 'Item agregado exitosamente. Detalle ID: ' + CAST(@detalle_id AS VARCHAR)
        
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
-- SP 2: CALCULAR TOTAL DEL PEDIDO
-- =============================================

PRINT 'Creando SP: sp_CalcularTotalPedido...'

-- DOCUMENTACIÓN DE USO:
-- EXEC sp_CalcularTotalPedido @pedido_id = 1, @nuevo_total = @total OUTPUT, @mensaje = @msg OUTPUT
-- Parámetros OUTPUT obligatorios: @nuevo_total y @mensaje

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CalcularTotalPedido]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_CalcularTotalPedido]
GO

CREATE PROCEDURE [dbo].[sp_CalcularTotalPedido]
    @pedido_id INT,
    @nuevo_total DECIMAL(10,2) OUTPUT,
    @mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Variables locales
        DECLARE @total_calculado_local DECIMAL(10,2) = 0
        DECLARE @pedido_existe INT = 0
        
        -- Inicializar variables de salida
        SET @nuevo_total = 0
        SET @mensaje = ''
        
        -- 1. VALIDAR PEDIDO
        SELECT @pedido_existe = COUNT(*)
        FROM PEDIDO
        WHERE pedido_id = @pedido_id
        
        IF @pedido_existe = 0
        BEGIN
            SET @mensaje = 'Error: El pedido no existe'
            ROLLBACK TRANSACTION
            RETURN -1
        END
        
        -- 2. CALCULAR TOTAL (SUM DE SUBTOTALES)
        SELECT @total_calculado_local = ISNULL(SUM(subtotal), 0)
        FROM DETALLE_PEDIDO
        WHERE pedido_id = @pedido_id
        
        -- 3. ACTUALIZAR PEDIDO CON TOTAL CALCULADO
        UPDATE PEDIDO
        SET total = @total_calculado_local
        WHERE pedido_id = @pedido_id
        
        SET @nuevo_total = @total_calculado_local
        SET @mensaje = 'Total calculado exitosamente: $' + CAST(@total_calculado_local AS VARCHAR)
        
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_AgregarItemPedido]') AND type in (N'P', N'PC'))
    PRINT 'sp_AgregarItemPedido: Creado exitosamente'
ELSE
    PRINT 'sp_AgregarItemPedido: ERROR en la creacion'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CalcularTotalPedido]') AND type in (N'P', N'PC'))
    PRINT 'sp_CalcularTotalPedido: Creado exitosamente'
ELSE
    PRINT 'sp_CalcularTotalPedido: ERROR en la creacion'

PRINT ''
PRINT 'BUNDLE B2 - ITEMS Y CALCULOS COMPLETADO!'
PRINT '==========================================='
PRINT 'Estado: SPs de items y calculos instalados'
PRINT 'Funcionalidad: sp_AgregarItemPedido OK'
PRINT 'Funcionalidad: sp_CalcularTotalPedido OK'
PRINT ''
PRINT 'FUNCIONES DISPONIBLES:'
PRINT '   - sp_AgregarItemPedido: Agregar platos/combos a pedidos'
PRINT '   - sp_CalcularTotalPedido: Calcular y actualizar total'
PRINT ''
PRINT 'EJEMPLOS DE USO:'
PRINT '   DECLARE @detalle INT, @total DECIMAL(10,2), @msg NVARCHAR(500)'
PRINT '   EXEC sp_AgregarItemPedido @pedido_id=1, @plato_id=1, @cantidad=2, @detalle_id=@detalle OUTPUT, @mensaje=@msg OUTPUT'
PRINT '   EXEC sp_CalcularTotalPedido @pedido_id=1, @nuevo_total=@total OUTPUT, @mensaje=@msg OUTPUT'
PRINT ''
PRINT '   - Agregar items a pedidos (platos/combos)'
PRINT '   - Validacion de precios vigentes'
PRINT '   - Calculo automatico de subtotales'
PRINT '   - Actualizacion de totales de pedidos'
PRINT ''
PRINT 'SIGUIENTE PASO: Ejecutar Bundle_B3_Estados_Finalizacion.sql'
PRINT '================================================='
GO