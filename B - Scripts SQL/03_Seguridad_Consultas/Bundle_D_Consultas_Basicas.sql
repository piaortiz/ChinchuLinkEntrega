-- =============================================
-- BUNDLE D - CONSULTAS BASICAS
-- ChinchuLink - Sistema de Gestion de Restaurante
-- Descripcion: Stored procedures y vistas para consultas operativas
-- Fecha: 9 de noviembre de 2025
-- Desarrollado por: SQLeaders S.A.
-- Proyecto Educativo ISTEA - Uso academico exclusivo
-- PROHIBIDA LA COMERCIALIZACION
-- =============================================

USE ChinchuLink
GO

-- Configuraciones necesarias para indices filtrados
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

PRINT 'INICIANDO BUNDLE D - CONSULTAS BASICAS'
PRINT '========================================='
PRINT 'Instalando consultas operativas esenciales...'
PRINT ''

-- =============================================
-- SP 1: CONSULTAR MENU ACTUAL
-- =============================================

PRINT 'Creando SP: sp_ConsultarMenuActual...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarMenuActual]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ConsultarMenuActual]
GO

CREATE PROCEDURE [dbo].[sp_ConsultarMenuActual]
    @sucursal_id INT = NULL,
    @categoria NVARCHAR(50) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.plato_id,
        p.nombre as plato_nombre,
        p.categoria,
        pr.precio as precio_actual,
        pr.vigencia_desde,
        pr.vigencia_hasta,
        CASE 
            WHEN pr.vigencia_hasta IS NULL THEN 'Vigente'
            WHEN pr.vigencia_hasta >= GETDATE() THEN 'Vigente'
            ELSE 'Vencido'
        END as estado_precio,
        p.activo
    FROM PLATO p
    INNER JOIN PRECIO pr ON p.plato_id = pr.plato_id
    WHERE p.activo = 1
      AND pr.vigencia_desde <= GETDATE()
      AND (pr.vigencia_hasta IS NULL OR pr.vigencia_hasta >= GETDATE())
      AND (@categoria IS NULL OR p.categoria = @categoria)
    ORDER BY p.categoria, p.nombre
END
GO

-- =============================================
-- SP 2: MESAS DISPONIBLES
-- =============================================

PRINT 'Creando SP: sp_MesasDisponibles...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MesasDisponibles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_MesasDisponibles]
GO

CREATE PROCEDURE [dbo].[sp_MesasDisponibles]
    @sucursal_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        m.mesa_id,
        m.numero as mesa_numero,
        m.capacidad,
        s.nombre as sucursal_nombre,
        m.qr_token,
        CASE 
            WHEN EXISTS (
                SELECT 1 FROM PEDIDO p 
                INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
                WHERE p.mesa_id = m.mesa_id 
                  AND ep.nombre NOT IN ('Cerrado', 'Cancelado')
            ) THEN 'Ocupada'
            ELSE 'Disponible'
        END as estado_mesa,
        (
            SELECT TOP 1 p.pedido_id 
            FROM PEDIDO p 
            INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
            WHERE p.mesa_id = m.mesa_id 
              AND ep.nombre NOT IN ('Cerrado', 'Cancelado')
            ORDER BY p.fecha_pedido DESC
        ) as pedido_activo_id
    FROM MESA m
    INNER JOIN SUCURSAL s ON m.sucursal_id = s.sucursal_id
    WHERE m.activa = 1
      AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id)
    ORDER BY s.nombre, m.numero
END
GO

-- =============================================
-- VISTA 1: PEDIDOS COMPLETOS
-- =============================================

PRINT 'Creando Vista: vw_PedidosCompletos...'

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_PedidosCompletos]'))
DROP VIEW [dbo].[vw_PedidosCompletos]
GO

CREATE VIEW [dbo].[vw_PedidosCompletos]
AS
SELECT 
    -- Informacion del Pedido
    p.pedido_id,
    p.fecha_pedido,
    FORMAT(p.fecha_pedido, 'yyyy-MM-dd') as fecha_pedido_formato,
    FORMAT(p.fecha_pedido, 'HH:mm') as hora_pedido,
    DATENAME(weekday, p.fecha_pedido) as dia_semana,
    
    -- Estado del Pedido
    ep.nombre as estado_pedido,
    ep.orden as estado_orden,
    
    -- Canal de Venta
    cv.nombre as canal_venta,
    
    -- Informacion del Cliente
    c.cliente_id,
    c.nombre as cliente_nombre,
    c.telefono as cliente_telefono,
    c.email as cliente_email,
    
    -- Informacion de la Mesa (si aplica)
    m.mesa_id,
    m.numero as mesa_numero,
    m.capacidad as mesa_capacidad,
    p.cant_comensales,
    
    -- Informacion del Empleado
    e.empleado_id,
    e.nombre as empleado_nombre,
    e.usuario as empleado_usuario,
    
    -- Informacion de Sucursal
    s.sucursal_id,
    s.nombre as sucursal_nombre,
    s.direccion as sucursal_direccion,
    
    -- Totales
    p.total as total_pedido,
    
    -- Tiempos
    p.fecha_entrega as fecha_entrega,
    CASE 
        WHEN p.fecha_entrega IS NOT NULL 
        THEN DATEDIFF(MINUTE, p.fecha_pedido, p.fecha_entrega)
        ELSE DATEDIFF(MINUTE, p.fecha_pedido, GETDATE())
    END as minutos_transcurridos
    
FROM PEDIDO p
INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
INNER JOIN CANAL_VENTA cv ON p.canal_id = cv.canal_id
INNER JOIN EMPLEADO e ON p.tomado_por_empleado_id = e.empleado_id
INNER JOIN SUCURSAL s ON e.sucursal_id = s.sucursal_id
LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
LEFT JOIN CLIENTE c ON p.cliente_id = c.cliente_id
GO

-- =============================================
-- VISTA 2: ESTADO DE MESAS
-- =============================================

PRINT 'Creando Vista: vw_EstadoMesas...'

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_EstadoMesas]'))
DROP VIEW [dbo].[vw_EstadoMesas]
GO

CREATE VIEW [dbo].[vw_EstadoMesas]
AS
SELECT 
    m.mesa_id,
    m.numero as mesa_numero,
    m.capacidad,
    m.qr_token,
    s.sucursal_id,
    s.nombre as sucursal_nombre,
    
    -- Estado actual de la mesa
    CASE 
        WHEN EXISTS (
            SELECT 1 FROM PEDIDO p 
            INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
            WHERE p.mesa_id = m.mesa_id 
              AND ep.nombre NOT IN ('Cerrado', 'Cancelado')
        ) THEN 'Ocupada'
        ELSE 'Disponible'
    END as estado_actual,
    
    -- Informacion del pedido activo (si existe)
    pa.pedido_id as pedido_activo_id,
    pa.fecha_pedido as pedido_inicio,
    pa.cant_comensales,
    pa.total,
    epa.nombre as estado_pedido_activo,
    ea.nombre as empleado_responsable,
    
    -- Tiempo de ocupacion
    CASE 
        WHEN pa.pedido_id IS NOT NULL 
        THEN DATEDIFF(MINUTE, pa.fecha_pedido, GETDATE())
        ELSE 0
    END as minutos_ocupada,
    
    -- Estado operativo
    CASE 
        WHEN m.activa = 0 THEN 'Fuera de servicio'
        WHEN pa.pedido_id IS NULL THEN 'Lista para uso'
        WHEN epa.nombre = 'Pendiente' THEN 'Esperando orden'
        WHEN epa.nombre IN ('Confirmado', 'En Preparacion') THEN 'Comida en preparacion'
        WHEN epa.nombre = 'Listo' THEN 'Comida lista'
        ELSE 'En uso'
    END as estado_operativo
    
FROM MESA m
INNER JOIN SUCURSAL s ON m.sucursal_id = s.sucursal_id
LEFT JOIN (
    SELECT 
        p.mesa_id,
        p.pedido_id,
        p.fecha_pedido,
        p.cant_comensales,
        p.total,
        p.estado_id,
        p.tomado_por_empleado_id,
        ROW_NUMBER() OVER (PARTITION BY p.mesa_id ORDER BY p.fecha_pedido DESC) as rn
    FROM PEDIDO p
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    WHERE ep.nombre NOT IN ('Cerrado', 'Cancelado')
) pa ON m.mesa_id = pa.mesa_id AND pa.rn = 1
LEFT JOIN ESTADO_PEDIDO epa ON pa.estado_id = epa.estado_id
LEFT JOIN EMPLEADO ea ON pa.tomado_por_empleado_id = ea.empleado_id
GO

-- =============================================
-- SP 3: CONSULTAR PEDIDOS POR ESTADO
-- =============================================

PRINT 'Creando SP: sp_ConsultarPedidosPorEstado...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarPedidosPorEstado]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ConsultarPedidosPorEstado]
GO

CREATE PROCEDURE [dbo].[sp_ConsultarPedidosPorEstado]
    @estado_nombre NVARCHAR(50) = NULL,
    @sucursal_id INT = NULL,
    @fecha_desde DATE = NULL,
    @fecha_hasta DATE = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Valores por defecto
    IF @fecha_desde IS NULL SET @fecha_desde = CAST(GETDATE() AS DATE)
    IF @fecha_hasta IS NULL SET @fecha_hasta = CAST(GETDATE() AS DATE)
    
    SELECT 
        pc.pedido_id,
        pc.fecha_pedido,
        pc.hora_pedido,
        pc.estado_pedido,
        pc.canal_venta,
        pc.mesa_numero,
        pc.cliente_nombre,
        pc.empleado_nombre,
        pc.sucursal_nombre,
        pc.total_pedido,
        pc.minutos_transcurridos,
        
        -- Detalles del pedido
        (
            SELECT COUNT(*) 
            FROM DETALLE_PEDIDO dp 
            WHERE dp.pedido_id = pc.pedido_id
        ) as cantidad_items,
        
        (
            SELECT STRING_AGG(
                CASE 
                    WHEN dp.plato_id IS NOT NULL THEN pl.nombre
                    WHEN dp.combo_id IS NOT NULL THEN co.nombre
                END + ' (x' + CAST(dp.cantidad AS VARCHAR) + ')',
                ', '
            )
            FROM DETALLE_PEDIDO dp
            LEFT JOIN PLATO pl ON dp.plato_id = pl.plato_id
            LEFT JOIN COMBO co ON dp.combo_id = co.combo_id
            WHERE dp.pedido_id = pc.pedido_id
        ) as items_pedido
        
    FROM vw_PedidosCompletos pc
    WHERE (@estado_nombre IS NULL OR pc.estado_pedido = @estado_nombre)
      AND (@sucursal_id IS NULL OR pc.sucursal_id = @sucursal_id)
      AND pc.fecha_pedido_formato >= @fecha_desde
      AND pc.fecha_pedido_formato <= @fecha_hasta
    ORDER BY pc.fecha_pedido DESC
END
GO

-- =============================================
-- SP 4: RESUMEN OPERATIVO DIARIO
-- =============================================

PRINT 'Creando SP: sp_ResumenOperativoDiario...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ResumenOperativoDiario]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ResumenOperativoDiario]
GO

CREATE PROCEDURE [dbo].[sp_ResumenOperativoDiario]
    @fecha DATE = NULL,
    @sucursal_id INT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Valor por defecto
    IF @fecha IS NULL SET @fecha = CAST(GETDATE() AS DATE)
    
    -- Resumen general
    SELECT 
        'RESUMEN DEL DIA' as tipo_reporte,
        @fecha as fecha_reporte,
        s.nombre as sucursal,
        
        -- Pedidos
        COUNT(DISTINCT p.pedido_id) as total_pedidos,
        COUNT(DISTINCT CASE WHEN ep.nombre = 'Cerrado' THEN p.pedido_id END) as pedidos_cerrados,
        COUNT(DISTINCT CASE WHEN ep.nombre = 'Cancelado' THEN p.pedido_id END) as pedidos_cancelados,
        COUNT(DISTINCT CASE WHEN ep.nombre NOT IN ('Cerrado', 'Cancelado') THEN p.pedido_id END) as pedidos_activos,
        
        -- Facturacion
        SUM(CASE WHEN ep.nombre = 'Cerrado' THEN p.total ELSE 0 END) as facturacion_total,
        AVG(CASE WHEN ep.nombre = 'Cerrado' THEN p.total ELSE NULL END) as ticket_promedio,
        
        -- Operacion
        COUNT(DISTINCT p.mesa_id) as mesas_utilizadas,
        COUNT(DISTINCT CASE WHEN cv.nombre = 'Delivery' THEN p.pedido_id END) as pedidos_delivery,
        COUNT(DISTINCT CASE WHEN cv.nombre = 'Mesa QR' THEN p.pedido_id END) as pedidos_qr,
        
        -- Items
        SUM(dp.cantidad) as total_items_vendidos,
        COUNT(DISTINCT dp.plato_id) as platos_diferentes_vendidos
        
    FROM SUCURSAL s
    LEFT JOIN EMPLEADO e ON s.sucursal_id = e.sucursal_id
    LEFT JOIN PEDIDO p ON e.empleado_id = p.tomado_por_empleado_id 
                       AND CAST(p.fecha_pedido AS DATE) = @fecha
    LEFT JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    LEFT JOIN CANAL_VENTA cv ON p.canal_id = cv.canal_id
    LEFT JOIN DETALLE_PEDIDO dp ON p.pedido_id = dp.pedido_id
    WHERE (@sucursal_id IS NULL OR s.sucursal_id = @sucursal_id)
    GROUP BY s.sucursal_id, s.nombre
    ORDER BY s.nombre
END
GO

-- =============================================
-- VALIDACION FINAL
-- =============================================

PRINT ''
PRINT 'Validando consultas basicas creadas...'

-- Verificar SPs
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarMenuActual]') AND type in (N'P', N'PC'))
    PRINT 'sp_ConsultarMenuActual: OK'
ELSE
    PRINT 'sp_ConsultarMenuActual: ERROR'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MesasDisponibles]') AND type in (N'P', N'PC'))
    PRINT 'sp_MesasDisponibles: OK'
ELSE
    PRINT 'sp_MesasDisponibles: ERROR'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarPedidosPorEstado]') AND type in (N'P', N'PC'))
    PRINT 'sp_ConsultarPedidosPorEstado: OK'
ELSE
    PRINT 'sp_ConsultarPedidosPorEstado: ERROR'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ResumenOperativoDiario]') AND type in (N'P', N'PC'))
    PRINT 'sp_ResumenOperativoDiario: OK'
ELSE
    PRINT 'sp_ResumenOperativoDiario: ERROR'

-- Verificar Vistas
IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_PedidosCompletos]'))
    PRINT 'vw_PedidosCompletos: OK'
ELSE
    PRINT 'vw_PedidosCompletos: ERROR'

IF EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vw_EstadoMesas]'))
    PRINT 'vw_EstadoMesas: OK'
ELSE
    PRINT 'vw_EstadoMesas: ERROR'

-- =============================================
-- FINALIZACION
-- =============================================

PRINT ''
PRINT 'BUNDLE D - CONSULTAS BASICAS COMPLETADO EXITOSAMENTE!'
PRINT '=========================================================='
PRINT 'Estado: Consultas operativas disponibles'
PRINT 'Stored Procedures: 4 SPs de consulta creados'
PRINT 'Vistas: 2 vistas operativas creadas'
PRINT 'Funcionalidades disponibles:'
PRINT '   • Consultar menu actual con precios'
PRINT '   • Ver estado de mesas en tiempo real'
PRINT '   • Consultar pedidos por estado'
PRINT '   • Resumen operativo diario'
PRINT '   • Vista completa de pedidos'
PRINT '   • Vista de estado de mesas'
PRINT ''
PRINT 'Siguiente paso: Ejecutar Bundle E - Automatizacion'
PRINT '===================================================='