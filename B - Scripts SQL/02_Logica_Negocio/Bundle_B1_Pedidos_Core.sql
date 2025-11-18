-- =============================================
-- BUNDLE B1 - PEDIDOS CORE
-- ChinchuLink - Sistema de Gestión de Restaurante
-- Descripción: Stored Procedure para creación de pedidos
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

PRINT 'INICIANDO BUNDLE B1 - PEDIDOS CORE'
PRINT '===================================='
PRINT 'Instalando funcionalidad de creacion de pedidos...'
PRINT ''

-- =============================================
-- SP: CREAR PEDIDO
-- =============================================

PRINT 'Creando SP: sp_CrearPedido...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CrearPedido]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_CrearPedido]
GO

CREATE PROCEDURE [dbo].[sp_CrearPedido]
    @canal_id INT,
    @mesa_id INT = NULL,
    @cliente_id INT = NULL,
    @domicilio_id INT = NULL,
    @cant_comensales INT = NULL,
    @tomado_por_empleado_id INT,
    @pedido_id INT OUTPUT,
    @mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Variables locales
        DECLARE @estado_pendiente_id INT
        DECLARE @empleado_activo INT = 0
        DECLARE @sucursal_empleado INT
        DECLARE @sucursal_mesa INT
        
        -- Inicializar variables de salida
        SET @pedido_id = 0
        SET @mensaje = ''
        
        -- 1. VALIDAR CANAL DE VENTA
        IF NOT EXISTS (SELECT 1 FROM CANAL_VENTA WHERE canal_id = @canal_id)
        BEGIN
            SET @mensaje = 'Error: Canal de venta no válido'
            ROLLBACK TRANSACTION
            RETURN -1
        END
        
        -- 2. OBTENER ESTADO "PENDIENTE"
        SELECT @estado_pendiente_id = estado_id 
        FROM ESTADO_PEDIDO 
        WHERE nombre = 'Pendiente'
        
        IF @estado_pendiente_id IS NULL
        BEGIN
            SET @mensaje = 'Error: No se encontró el estado "Pendiente"'
            ROLLBACK TRANSACTION
            RETURN -2
        END
        
        -- 3. VALIDAR EMPLEADO
        SELECT @empleado_activo = COUNT(*), @sucursal_empleado = MAX(sucursal_id)
        FROM EMPLEADO 
        WHERE empleado_id = @tomado_por_empleado_id AND activo = 1
        
        IF @empleado_activo = 0
        BEGIN
            SET @mensaje = 'Error: Empleado no existe o está inactivo'
            ROLLBACK TRANSACTION
            RETURN -3
        END
        
        -- 4. VALIDACIONES ESPECÍFICAS POR CANAL
        IF @mesa_id IS NOT NULL
        BEGIN
            -- Validar que la mesa existe y está activa
            IF NOT EXISTS (SELECT 1 FROM MESA WHERE mesa_id = @mesa_id AND activa = 1)
            BEGIN
                SET @mensaje = 'Error: Mesa no existe o está inactiva'
                ROLLBACK TRANSACTION
                RETURN -4
            END
            
            -- Obtener sucursal de la mesa
            SELECT @sucursal_mesa = sucursal_id FROM MESA WHERE mesa_id = @mesa_id
            
            -- Validar que empleado y mesa pertenecen a la misma sucursal
            IF @sucursal_empleado != @sucursal_mesa
            BEGIN
                SET @mensaje = 'Error: El empleado no pertenece a la sucursal de la mesa'
                ROLLBACK TRANSACTION
                RETURN -5
            END
        END
        
        -- 5. CREAR EL PEDIDO
        INSERT INTO PEDIDO (
            fecha_pedido,
            canal_id,
            estado_id,
            mesa_id,
            cliente_id,
            domicilio_id,
            cant_comensales,
            tomado_por_empleado_id
        )
        VALUES (
            GETDATE(),
            @canal_id,
            @estado_pendiente_id,
            @mesa_id,
            @cliente_id,
            @domicilio_id,
            @cant_comensales,
            @tomado_por_empleado_id
        )
        
        -- Obtener el ID del pedido creado
        SET @pedido_id = SCOPE_IDENTITY()
        
        SET @mensaje = 'Pedido creado exitosamente con ID: ' + CAST(@pedido_id AS VARCHAR)
        
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

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_CrearPedido]') AND type in (N'P', N'PC'))
    PRINT 'sp_CrearPedido: Creado exitosamente'
ELSE
    PRINT 'sp_CrearPedido: ERROR en la creacion'

PRINT ''
PRINT 'BUNDLE B1 - PEDIDOS CORE COMPLETADO!'
PRINT '======================================='
PRINT 'Estado: SP de creacion de pedidos instalado'
PRINT 'Funcionalidad: sp_CrearPedido OK'
PRINT ''
PRINT 'FUNCIONES DISPONIBLES:'
PRINT '   - Crear pedidos con validaciones completas'
PRINT '   - Validacion de canales, mesas y empleados'
PRINT '   - Control de sucursales y permisos'
PRINT ''
PRINT 'SIGUIENTE PASO: Ejecutar Bundle_B2_Items_Calculos.sql'
PRINT '================================================='
GO