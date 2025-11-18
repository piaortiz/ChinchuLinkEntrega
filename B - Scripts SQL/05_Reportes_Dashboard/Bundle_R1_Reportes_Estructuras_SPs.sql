-- =============================================
-- BUNDLE R1 - REPORTES AUTOMÁTICOS CHINCHULINK - PARTE 1
-- Estructuras y Stored Procedures de reportes
-- Fecha: 12 de noviembre de 2025
-- Propósito: Implementar infraestructura y SPs de reportes automáticos
-- NOTA: Este es la PRIMERA parte del Bundle_R. Ejecutar Bundle_R2 después.
-- =============================================

USE ChinchuLink;
GO

PRINT 'INICIANDO BUNDLE R1 - REPORTES AUTOMÁTICOS (PARTE 1/2)'
PRINT '=========================================================='
PRINT 'Implementando infraestructura y stored procedures de reportes...'
PRINT 'NOTA: Ejecutar Bundle_R2 después de completar esta parte'
PRINT ''

-- =============================================
-- VERIFICACIÓN DE PREREQUISITOS
-- =============================================
PRINT 'Verificando prerequisitos...'

-- Verificar que existen las tablas necesarias
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'PEDIDO')
BEGIN
    PRINT 'ERROR: Tabla PEDIDO no encontrada. Ejecutar Bundle_A1 primero.'
    RETURN
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'DETALLE_PEDIDO')
BEGIN
    PRINT 'ERROR: Tabla DETALLE_PEDIDO no encontrada. Ejecutar Bundle_A1 primero.'
    RETURN
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'ESTADO_PEDIDO')
BEGIN
    PRINT 'ERROR: Tabla ESTADO_PEDIDO no encontrada. Ejecutar Bundle_A1 primero.'
    RETURN
END

IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'CANAL_VENTA')
BEGIN
    PRINT 'ERROR: Tabla CANAL_VENTA no encontrada. Ejecutar Bundle_A1 primero.'
    RETURN
END

PRINT 'Prerequisitos verificados'
PRINT ''

-- =============================================
-- PASO 1: CREAR TABLA DE REPORTES GENERADOS
-- =============================================
PRINT 'Paso 1/3: Creando tabla de almacenamiento de reportes...'

-- Crear tabla si no existe
IF NOT EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'REPORTES_GENERADOS')
BEGIN
    CREATE TABLE REPORTES_GENERADOS (
        reporte_id INT IDENTITY(1,1) PRIMARY KEY,
        tipo_reporte NVARCHAR(50) NOT NULL,
        fecha_generacion DATETIME NOT NULL DEFAULT GETDATE(),
        fecha_reporte DATE NOT NULL,
        sucursal_id INT NULL,
        datos_json NVARCHAR(MAX) NULL,
        ejecutado_por NVARCHAR(100) DEFAULT SYSTEM_USER,
        estado NVARCHAR(20) DEFAULT 'COMPLETADO',
        observaciones NVARCHAR(500) NULL,
        CONSTRAINT FK_REPORTES_sucursal FOREIGN KEY (sucursal_id) REFERENCES SUCURSAL(sucursal_id)
    );
    
    -- Crear índices para optimizar consultas
    CREATE INDEX IX_REPORTES_tipo_fecha ON REPORTES_GENERADOS(tipo_reporte, fecha_reporte);
    CREATE INDEX IX_REPORTES_sucursal ON REPORTES_GENERADOS(sucursal_id, fecha_reporte);
    CREATE INDEX IX_REPORTES_generacion ON REPORTES_GENERADOS(fecha_generacion DESC);
    
    PRINT 'Tabla REPORTES_GENERADOS creada con índices'
END
ELSE
BEGIN
    PRINT 'Tabla REPORTES_GENERADOS ya existe'
END

PRINT ''

-- =============================================
-- PASO 2: STORED PROCEDURES REPORTES DIARIOS
-- =============================================
PRINT 'Paso 2/3: Creando stored procedures de reportes diarios...'

-- =============================================
-- SP 1: REPORTE DE VENTAS DIARIO
-- =============================================
PRINT 'Creando SP: sp_ReporteVentasDiario...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ReporteVentasDiario]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_ReporteVentasDiario]
GO

CREATE PROCEDURE [dbo].[sp_ReporteVentasDiario]
    @fecha DATE = NULL,
    @sucursal_id INT = NULL,
    @guardar_reporte BIT = 0
AS
BEGIN
    SET NOCOUNT ON;

    IF @fecha IS NULL SET @fecha = CAST(GETDATE() AS DATE);
    DECLARE @fecha_anterior DATE = DATEADD(DAY, -1, @fecha);

    -- Variables para facturación
    DECLARE @facturacion_actual DECIMAL(18,2) = (
        SELECT SUM(p.total)
        FROM PEDIDO p
        INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
        LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
        WHERE CAST(p.fecha_pedido AS DATE) = @fecha
          AND ep.nombre IN ('Entregado', 'Cerrado')
          AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
    );

    DECLARE @facturacion_ayer DECIMAL(18,2) = (
        SELECT SUM(p.total)
        FROM PEDIDO p
        INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
        LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
        WHERE CAST(p.fecha_pedido AS DATE) = @fecha_anterior
          AND ep.nombre IN ('Entregado', 'Cerrado')
          AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
    );

    CREATE TABLE #ResultadoVentas (
        tipo_reporte NVARCHAR(50),
        fecha_reporte DATE,
        sucursal NVARCHAR(100),
        facturacion_total DECIMAL(18,2),
        pedidos_completados INT,
        ticket_promedio DECIMAL(18,2),
        facturacion_anterior DECIMAL(18,2),
        porcentaje_crecimiento DECIMAL(9,2),
        total_items_vendidos INT,
        mesas_utilizadas INT
    );

    INSERT INTO #ResultadoVentas
    SELECT 
        'VENTAS_DIARIO',
        @fecha,
        s.nombre,
        ISNULL(@facturacion_actual, 0),
        (
            SELECT COUNT(DISTINCT p.pedido_id)
            FROM PEDIDO p
            INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
            LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
            WHERE CAST(p.fecha_pedido AS DATE) = @fecha
              AND ep.nombre IN ('Entregado', 'Cerrado')
              AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
        ),
        (
            SELECT AVG(sub.total)
            FROM (
                SELECT DISTINCT p.pedido_id, p.total
                FROM PEDIDO p
                INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
                LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
                WHERE CAST(p.fecha_pedido AS DATE) = @fecha
                  AND ep.nombre IN ('Entregado', 'Cerrado')
                  AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
            ) sub
        ),
        ISNULL(@facturacion_ayer, 0),
        CASE 
            WHEN ISNULL(@facturacion_ayer, 0) > 0 
            THEN ROUND((@facturacion_actual - @facturacion_ayer) * 100.0 / NULLIF(@facturacion_ayer, 0), 2)
            ELSE 0
        END,
        (
            SELECT SUM(dp.cantidad)
            FROM DETALLE_PEDIDO dp
            INNER JOIN PEDIDO p3 ON dp.pedido_id = p3.pedido_id
            INNER JOIN ESTADO_PEDIDO ep3 ON p3.estado_id = ep3.estado_id
            LEFT JOIN MESA m3 ON p3.mesa_id = m3.mesa_id
            WHERE CAST(p3.fecha_pedido AS DATE) = @fecha
              AND ep3.nombre IN ('Entregado', 'Cerrado')
              AND (@sucursal_id IS NULL OR m3.sucursal_id = @sucursal_id OR p3.mesa_id IS NULL)
        ),
        (
            SELECT COUNT(DISTINCT p.mesa_id)
            FROM PEDIDO p
            LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
            WHERE CAST(p.fecha_pedido AS DATE) = @fecha
              AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
        )
    FROM SUCURSAL s
    WHERE (@sucursal_id IS NULL OR s.sucursal_id = @sucursal_id);

    SELECT * FROM #ResultadoVentas ORDER BY sucursal;

    IF @guardar_reporte = 1
    BEGIN
        DECLARE @json NVARCHAR(MAX);
        SELECT @json = (SELECT * FROM #ResultadoVentas FOR JSON PATH);

        INSERT INTO REPORTES_GENERADOS (tipo_reporte, fecha_reporte, sucursal_id, datos_json, observaciones)
        VALUES ('VENTAS_DIARIO', @fecha, @sucursal_id, @json, 'Reporte automático de ventas diarias');
    END;

    DROP TABLE #ResultadoVentas;
END
GO

-- =============================================
-- SP 2: TOP PLATOS MÁS VENDIDOS DIARIO
-- =============================================
PRINT 'Creando SP: sp_PlatosMasVendidosDiario...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PlatosMasVendidosDiario]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_PlatosMasVendidosDiario]
GO

CREATE PROCEDURE [dbo].[sp_PlatosMasVendidosDiario]
    @fecha DATE = NULL,
    @top_cantidad INT = 10,
    @sucursal_id INT = NULL,
    @guardar_reporte BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @fecha IS NULL SET @fecha = CAST(GETDATE() AS DATE)
    
    CREATE TABLE #ResultadoPlatos (
        tipo_reporte NVARCHAR(50),
        fecha_reporte DATE,
        posicion INT,
        plato_nombre NVARCHAR(100),
        categoria NVARCHAR(50),
        cantidad_vendida INT,
        ingresos_generados DECIMAL(10,2),
        pedidos_incluidos INT,
        promedio_por_pedido DECIMAL(5,2)
    )
    
    INSERT INTO #ResultadoPlatos
    SELECT TOP (@top_cantidad)
        'TOP_PLATOS_DIARIO' as tipo_reporte,
        @fecha as fecha_reporte,
        ROW_NUMBER() OVER (ORDER BY SUM(dp.cantidad) DESC) as posicion,
        pl.nombre as plato_nombre,
        pl.categoria,
        SUM(dp.cantidad) as cantidad_vendida,
        SUM(dp.subtotal) as ingresos_generados,
        COUNT(DISTINCT p.pedido_id) as pedidos_incluidos,
        ROUND(SUM(dp.cantidad) * 1.0 / COUNT(DISTINCT p.pedido_id), 2) as promedio_por_pedido
    FROM DETALLE_PEDIDO dp
    INNER JOIN PEDIDO p ON dp.pedido_id = p.pedido_id
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    INNER JOIN PLATO pl ON dp.plato_id = pl.plato_id
    LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
    WHERE CAST(p.fecha_pedido AS DATE) = @fecha
      AND ep.nombre IN ('Entregado','Cerrado')
      AND dp.plato_id IS NOT NULL
      AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
    GROUP BY pl.plato_id, pl.nombre, pl.categoria
    ORDER BY cantidad_vendida DESC
    
    -- Mostrar resultados
    SELECT * FROM #ResultadoPlatos ORDER BY posicion
    
    -- Guardar reporte
    IF @guardar_reporte = 1
    BEGIN
        INSERT INTO REPORTES_GENERADOS (tipo_reporte, fecha_reporte, sucursal_id, datos_json, observaciones)
        VALUES (
            'TOP_PLATOS_DIARIO',
            @fecha,
            @sucursal_id,
            (SELECT * FROM #ResultadoPlatos FOR JSON PATH),
            'Top ' + CAST(@top_cantidad AS VARCHAR) + ' platos más vendidos del día'
        )
    END
    
    DROP TABLE #ResultadoPlatos
END
GO

-- =============================================
-- SP 3: RENDIMIENTO POR CANAL DIARIO
-- =============================================
PRINT 'Creando SP: sp_RendimientoCanalDiario...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RendimientoCanalDiario]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_RendimientoCanalDiario]
GO

CREATE PROCEDURE [dbo].[sp_RendimientoCanalDiario]
    @fecha DATE = NULL,
    @sucursal_id INT = NULL,
    @guardar_reporte BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @fecha IS NULL SET @fecha = CAST(GETDATE() AS DATE)
    
    -- Informacion del reporte
    PRINT 'EJECUTANDO REPORTE: RENDIMIENTO POR CANAL DE VENTA';
    PRINT 'Estados considerados como completados: ENTREGADO + CERRADO';
    PRINT 'Fecha de analisis: ' + CAST(@fecha AS VARCHAR);
    PRINT '';
    
    CREATE TABLE #ResultadoCanal (
        tipo_reporte NVARCHAR(50),
        fecha_reporte DATE,
        canal_venta NVARCHAR(50),
        total_pedidos INT,
        pedidos_completados INT,
        pedidos_pendientes INT,
        pedidos_cancelados INT,
        facturacion_canal DECIMAL(18,2),
        ticket_promedio DECIMAL(18,2),
        tasa_completacion DECIMAL(9,2),
        porcentaje_facturacion DECIMAL(9,2),
        sucursal_analizada NVARCHAR(100)
    )
    
    INSERT INTO #ResultadoCanal
    SELECT 
        'RENDIMIENTO_CANAL_DIARIO' as tipo_reporte,
        @fecha as fecha_reporte,
        cv.nombre as canal_venta,
        COUNT(p.pedido_id) as total_pedidos,
        
        -- Pedidos completados (Entregado + Cerrado)
        COUNT(CASE WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN p.pedido_id END) as pedidos_completados,
        
        -- Desglose por estado
        COUNT(CASE WHEN ep.nombre = 'Pendiente' THEN p.pedido_id END) as pedidos_pendientes,
        COUNT(CASE WHEN ep.nombre = 'Cancelado' THEN p.pedido_id END) as pedidos_cancelados,
        
        -- Facturacion de pedidos completados
        COALESCE(SUM(CASE WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN p.total END), 0) as facturacion_canal,
        
        -- Ticket promedio de pedidos completados
        COALESCE(AVG(CASE WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN p.total END), 0) as ticket_promedio,
        
        -- Tasa de completacion
        ROUND(
            (COUNT(CASE WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN p.pedido_id END) * 100.0) / 
            NULLIF(COUNT(p.pedido_id), 0), 2
        ) as tasa_completacion,
        
        -- Porcentaje de facturacion del dia
        ROUND(
            (COALESCE(SUM(CASE WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN p.total END), 0) * 100.0) / 
            NULLIF((SELECT SUM(CASE WHEN ep2.nombre IN ('Entregado', 'Cerrado') THEN p2.total END)
                    FROM PEDIDO p2 
                    INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
                    LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
                    WHERE CAST(p2.fecha_pedido AS DATE) = @fecha
                      AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL)), 1), 2
        ) as porcentaje_facturacion,
        
        -- Sucursal analizada
        CASE 
            WHEN @sucursal_id IS NULL THEN 'Todas las sucursales'
            ELSE (SELECT nombre FROM SUCURSAL WHERE sucursal_id = @sucursal_id)
        END as sucursal_analizada
        
    FROM CANAL_VENTA cv
    LEFT JOIN PEDIDO p ON cv.canal_id = p.canal_id AND CAST(p.fecha_pedido AS DATE) = @fecha
    LEFT JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
    WHERE (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
    GROUP BY cv.canal_id, cv.nombre
    ORDER BY facturacion_canal DESC
    
    -- Mostrar resultados principales
    SELECT * FROM #ResultadoCanal ORDER BY facturacion_canal DESC
    
    -- INFORMACION ADICIONAL DE ANALISIS
    PRINT '';
    PRINT 'ANALISIS DETALLADO DEL DIA:';
    PRINT '===========================';
    
    -- Resumen de estados por canal
    PRINT '1. DISTRIBUCION DE ESTADOS POR CANAL:';
    SELECT 
        cv.nombre as canal_venta,
        ep.nombre as estado,
        COUNT(p.pedido_id) as cantidad_pedidos,
        SUM(p.total) as facturacion_estado,
        CASE 
            WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN 'COMPLETADO'
            WHEN ep.nombre = 'Pendiente' THEN 'EN PROCESO'
            WHEN ep.nombre = 'Cancelado' THEN 'CANCELADO'
            ELSE 'OTRO ESTADO'
        END as categoria
    FROM CANAL_VENTA cv
    LEFT JOIN PEDIDO p ON cv.canal_id = p.canal_id AND CAST(p.fecha_pedido AS DATE) = @fecha
    LEFT JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    WHERE p.pedido_id IS NOT NULL
    GROUP BY cv.canal_id, cv.nombre, ep.estado_id, ep.nombre
    ORDER BY cv.canal_id, ep.estado_id;
    
    -- Totales del dia
    PRINT '';
    PRINT '2. RESUMEN GENERAL DEL DIA:';
    SELECT 
        'Total pedidos del dia' as indicador,
        COUNT(p.pedido_id) as cantidad,
        SUM(p.total) as monto,
        ROUND(AVG(p.total), 2) as promedio
    FROM PEDIDO p 
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
    WHERE CAST(p.fecha_pedido AS DATE) = @fecha
      AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
    
    UNION ALL
    
    SELECT 
        'Pedidos completados',
        COUNT(CASE WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN p.pedido_id END),
        SUM(CASE WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN p.total END),
        ROUND(AVG(CASE WHEN ep.nombre IN ('Entregado', 'Cerrado') THEN p.total END), 2)
    FROM PEDIDO p 
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
    WHERE CAST(p.fecha_pedido AS DATE) = @fecha
      AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL);
    
    -- Guardar reporte
    IF @guardar_reporte = 1
    BEGIN
        INSERT INTO REPORTES_GENERADOS (tipo_reporte, fecha_reporte, sucursal_id, datos_json, observaciones)
        VALUES (
            'RENDIMIENTO_CANAL_DIARIO',
            @fecha,
            @sucursal_id,
            (SELECT * FROM #ResultadoCanal FOR JSON PATH),
            'Rendimiento por canal de venta del dia ' + CAST(@fecha AS VARCHAR)
        )
    END
    
    DROP TABLE #ResultadoCanal
END
GO

-- =============================================
-- PASO 3: STORED PROCEDURES REPORTES MENSUALES
-- =============================================
PRINT 'Paso 3/3: Creando stored procedures de reportes mensuales...'

-- =============================================
-- SP 4: ANÁLISIS DE VENTAS MENSUAL
-- =============================================
PRINT 'Creando SP: sp_AnalisisVentasMensual...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_AnalisisVentasMensual]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_AnalisisVentasMensual]
GO

CREATE PROCEDURE [dbo].[sp_AnalisisVentasMensual]
    @ano INT = NULL,
    @mes INT = NULL,
    @sucursal_id INT = NULL,
    @guardar_reporte BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @ano IS NULL SET @ano = YEAR(GETDATE())
    IF @mes IS NULL SET @mes = MONTH(GETDATE())
    
    DECLARE @fecha_inicio DATE = DATEFROMPARTS(@ano, @mes, 1)
    DECLARE @fecha_fin DATE = EOMONTH(@fecha_inicio)
    DECLARE @mes_anterior_inicio DATE = DATEADD(MONTH, -1, @fecha_inicio)
    DECLARE @mes_anterior_fin DATE = EOMONTH(@mes_anterior_inicio)
    
    -- Informacion de la correccion
    PRINT 'USANDO SP_ANALISISVENTASMENSUAL (CORREGIDO)';
    PRINT 'Incluye pedidos: ENTREGADO + CERRADO';
    PRINT 'Analizando: ' + DATENAME(MONTH, @fecha_inicio) + ' ' + CAST(@ano AS VARCHAR);
    PRINT '';
    
    CREATE TABLE #ResultadoMensual (
        tipo_reporte NVARCHAR(50),
        ano INT,
        mes INT,
        periodo NVARCHAR(50),
        sucursal NVARCHAR(100),
        facturacion_mensual DECIMAL(18,2),
        pedidos_mensuales INT,
        facturacion_mes_anterior DECIMAL(18,2),
        dia_mayor_venta DATE,
        promedio_diario DECIMAL(18,2),
        crecimiento_vs_anterior DECIMAL(9,2)
    )
    
    INSERT INTO #ResultadoMensual
    SELECT 
        'ANALISIS_VENTAS_MENSUAL_CORREGIDO' as tipo_reporte,
        @ano as ano,
        @mes as mes,
        DATENAME(MONTH, @fecha_inicio) + ' ' + CAST(@ano AS VARCHAR) as periodo,
        s.nombre as sucursal,
        
        -- CORRECCION PRINCIPAL: Incluir "Entregado" Y "Cerrado"
        -- Metricas del mes actual
        (SELECT COALESCE(SUM(p.total), 0)
         FROM PEDIDO p
         INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
         LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
         WHERE ep.nombre IN ('Entregado', 'Cerrado')
           AND p.fecha_pedido >= @fecha_inicio 
           AND p.fecha_pedido <= @fecha_fin
           AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
        ) as facturacion_mensual,
        
        (SELECT COUNT(*)
         FROM PEDIDO p
         INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
         LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
         WHERE ep.nombre IN ('Entregado', 'Cerrado')
           AND p.fecha_pedido >= @fecha_inicio 
           AND p.fecha_pedido <= @fecha_fin
           AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
        ) as pedidos_mensuales,
        
        -- Facturacion mes anterior (CORREGIDA)
        (SELECT COALESCE(SUM(CASE WHEN ep2.nombre IN ('Entregado', 'Cerrado') THEN p2.total END), 0)
         FROM PEDIDO p2
         INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
         LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
         WHERE p2.fecha_pedido >= @mes_anterior_inicio 
           AND p2.fecha_pedido <= @mes_anterior_fin
           AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL)
        ) as facturacion_mes_anterior,
        
        -- Dia de mayor venta (CORREGIDO)
        (SELECT TOP 1 CAST(p3.fecha_pedido AS DATE)
         FROM PEDIDO p3
         INNER JOIN ESTADO_PEDIDO ep3 ON p3.estado_id = ep3.estado_id
         LEFT JOIN MESA m3 ON p3.mesa_id = m3.mesa_id
         WHERE ep3.nombre IN ('Entregado', 'Cerrado')
           AND p3.fecha_pedido >= @fecha_inicio 
           AND p3.fecha_pedido <= @fecha_fin
           AND (@sucursal_id IS NULL OR m3.sucursal_id = @sucursal_id OR p3.mesa_id IS NULL)
         GROUP BY CAST(p3.fecha_pedido AS DATE)
         ORDER BY SUM(p3.total) DESC
        ) as dia_mayor_venta,
        
        -- Promedio diario (CORREGIDO)
        ROUND((SELECT COALESCE(SUM(p.total), 0)
               FROM PEDIDO p
               INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
               LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
               WHERE ep.nombre IN ('Entregado', 'Cerrado')
                 AND p.fecha_pedido >= @fecha_inicio 
                 AND p.fecha_pedido <= @fecha_fin
                 AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
              ) / NULLIF(DAY(@fecha_fin), 0), 2) as promedio_diario,
        
        -- Crecimiento vs mes anterior (CORREGIDO)  
        CASE 
            WHEN (SELECT COALESCE(SUM(CASE WHEN ep2.nombre IN ('Entregado', 'Cerrado') THEN p2.total END), 0)
                  FROM PEDIDO p2
                  INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
                  LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
                  WHERE p2.fecha_pedido >= @mes_anterior_inicio 
                    AND p2.fecha_pedido <= @mes_anterior_fin
                    AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL)) > 0
            THEN 
                ROUND(
                    ((SELECT COALESCE(SUM(p.total), 0)
                      FROM PEDIDO p
                      INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
                      LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
                      WHERE ep.nombre IN ('Entregado', 'Cerrado')
                        AND p.fecha_pedido >= @fecha_inicio 
                        AND p.fecha_pedido <= @fecha_fin
                        AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)) - 
                     (SELECT COALESCE(SUM(CASE WHEN ep2.nombre IN ('Entregado', 'Cerrado') THEN p2.total END), 0)
                      FROM PEDIDO p2
                      INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
                      LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
                      WHERE p2.fecha_pedido >= @mes_anterior_inicio 
                        AND p2.fecha_pedido <= @mes_anterior_fin
                        AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL))
                    ) * 100.0 / 
                    NULLIF((SELECT COALESCE(SUM(CASE WHEN ep2.nombre IN ('Entregado', 'Cerrado') THEN p2.total END), 0)
                            FROM PEDIDO p2
                            INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
                            LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
                            WHERE p2.fecha_pedido >= @mes_anterior_inicio 
                              AND p2.fecha_pedido <= @mes_anterior_fin
                              AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL)), 0), 
                    2)
            ELSE 0
        END as crecimiento_vs_anterior
        
    FROM SUCURSAL s
    WHERE (@sucursal_id IS NULL OR s.sucursal_id = @sucursal_id);
    
    -- Mostrar resultados
    SELECT * FROM #ResultadoMensual ORDER BY sucursal
    
    -- Informacion adicional del mes analizado
    PRINT '';
    PRINT 'RESUMEN DEL PERIODO ANALIZADO:';
    PRINT '==============================';
    
    -- Contar pedidos por estado en el periodo
    SELECT 
        ep.nombre as ESTADO,
        COUNT(*) as CANTIDAD_PEDIDOS,
        SUM(p.total) as FACTURACION_TOTAL
    FROM PEDIDO p
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    WHERE p.fecha_pedido >= @fecha_inicio 
      AND p.fecha_pedido <= @fecha_fin
    GROUP BY ep.estado_id, ep.nombre
    ORDER BY ep.estado_id;
    
    -- Guardar reporte (OPCIONAL)
    IF @guardar_reporte = 1
    BEGIN
        INSERT INTO REPORTES_GENERADOS (tipo_reporte, fecha_reporte, sucursal_id, datos_json, observaciones)
        VALUES (
            'ANALISIS_VENTAS_MENSUAL_CORREGIDO',
            @fecha_fin,
            @sucursal_id,
            (SELECT * FROM #ResultadoMensual FOR JSON PATH),
            'Analisis completo de ventas del mes ' + CAST(@mes AS VARCHAR) + '/' + CAST(@ano AS VARCHAR)
        )
    END
    
    DROP TABLE #ResultadoMensual
END
GO

-- =============================================
-- SP 5: RANKING DE PRODUCTOS MENSUAL
-- =============================================
PRINT 'Creando SP: sp_RankingProductosMensual...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RankingProductosMensual]') AND type in (N'P', N'PC'))
    DROP PROCEDURE [dbo].[sp_RankingProductosMensual]
GO

CREATE PROCEDURE [dbo].[sp_RankingProductosMensual]
    @ano INT = NULL,
    @mes INT = NULL,
    @top_cantidad INT = 20,
    @sucursal_id INT = NULL,
    @guardar_reporte BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    IF @ano IS NULL SET @ano = YEAR(GETDATE())
    IF @mes IS NULL SET @mes = MONTH(GETDATE())
    
    DECLARE @fecha_inicio DATE = DATEFROMPARTS(@ano, @mes, 1)
    DECLARE @fecha_fin DATE = EOMONTH(@fecha_inicio)
    
    -- Informacion del reporte
    PRINT 'EJECUTANDO REPORTE: RANKING DE PRODUCTOS MENSUAL'
    PRINT 'Estados considerados como completados: ENTREGADO + CERRADO'
    PRINT 'Analizando: ' + DATENAME(MONTH, @fecha_inicio) + ' ' + CAST(@ano AS VARCHAR)
    PRINT ''
    
    CREATE TABLE #ResultadoRanking (
        tipo_reporte NVARCHAR(50),
        ano INT,
        mes INT,
        posicion_ranking INT,
        producto_nombre NVARCHAR(100),
        categoria NVARCHAR(50),
        total_vendido INT,
        ingresos_totales DECIMAL(18,2),
        precio_promedio DECIMAL(18,2),
        pedidos_diferentes INT,
        promedio_diario DECIMAL(9,2),
        vendido_mes_anterior INT,
        crecimiento_vs_anterior DECIMAL(9,2),
        sucursal_analizada NVARCHAR(100)
    )
    
    INSERT INTO #ResultadoRanking
    SELECT TOP (@top_cantidad)
        'RANKING_PRODUCTOS_MENSUAL' as tipo_reporte,
        @ano as ano,
        @mes as mes,
        ROW_NUMBER() OVER (ORDER BY SUM(dp.cantidad) DESC) as posicion_ranking,
        pl.nombre as producto_nombre,
        pl.categoria,
        SUM(dp.cantidad) as total_vendido,
        SUM(dp.subtotal) as ingresos_totales,
        AVG(dp.precio_unitario) as precio_promedio,
        COUNT(DISTINCT p.pedido_id) as pedidos_diferentes,
        ROUND((SUM(dp.cantidad) * 1.0) / DAY(@fecha_fin), 2) as promedio_diario,
        
        -- Vendido mes anterior (incluye ambos estados)
        (SELECT COALESCE(SUM(dp2.cantidad), 0)
         FROM DETALLE_PEDIDO dp2
         INNER JOIN PEDIDO p2 ON dp2.pedido_id = p2.pedido_id
         INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
         LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
         WHERE dp2.plato_id = pl.plato_id
           AND ep2.nombre IN ('Entregado', 'Cerrado')  -- Estados completados
           AND p2.fecha_pedido >= DATEADD(MONTH, -1, @fecha_inicio)
           AND p2.fecha_pedido <= DATEADD(DAY, -1, @fecha_inicio)
           AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL)
        ) as vendido_mes_anterior,
        
        -- Crecimiento vs mes anterior
        CASE 
            WHEN (SELECT COALESCE(SUM(dp2.cantidad), 0)
                  FROM DETALLE_PEDIDO dp2
                  INNER JOIN PEDIDO p2 ON dp2.pedido_id = p2.pedido_id
                  INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
                  LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
                  WHERE dp2.plato_id = pl.plato_id
                    AND ep2.nombre IN ('Entregado', 'Cerrado')
                    AND p2.fecha_pedido >= DATEADD(MONTH, -1, @fecha_inicio)
                    AND p2.fecha_pedido <= DATEADD(DAY, -1, @fecha_inicio)
                    AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL)) > 0
            THEN 
                ROUND(
                    ((SUM(dp.cantidad) - 
                      (SELECT COALESCE(SUM(dp2.cantidad), 0)
                       FROM DETALLE_PEDIDO dp2
                       INNER JOIN PEDIDO p2 ON dp2.pedido_id = p2.pedido_id
                       INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
                       LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
                       WHERE dp2.plato_id = pl.plato_id
                         AND ep2.nombre IN ('Entregado', 'Cerrado')
                         AND p2.fecha_pedido >= DATEADD(MONTH, -1, @fecha_inicio)
                         AND p2.fecha_pedido <= DATEADD(DAY, -1, @fecha_inicio)
                         AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL))) * 100.0 /
                     (SELECT CASE 
                             WHEN COALESCE(SUM(dp2.cantidad), 0) = 0 THEN 1
                             ELSE COALESCE(SUM(dp2.cantidad), 0)
                          END
                      FROM DETALLE_PEDIDO dp2
                      INNER JOIN PEDIDO p2 ON dp2.pedido_id = p2.pedido_id
                      INNER JOIN ESTADO_PEDIDO ep2 ON p2.estado_id = ep2.estado_id
                      LEFT JOIN MESA m2 ON p2.mesa_id = m2.mesa_id
                      WHERE dp2.plato_id = pl.plato_id
                        AND ep2.nombre IN ('Entregado', 'Cerrado')
                        AND p2.fecha_pedido >= DATEADD(MONTH, -1, @fecha_inicio)
                        AND p2.fecha_pedido <= DATEADD(DAY, -1, @fecha_inicio)
                        AND (@sucursal_id IS NULL OR m2.sucursal_id = @sucursal_id OR p2.mesa_id IS NULL))
                    ), 2)
            ELSE 0
        END as crecimiento_vs_anterior,
        
        -- Sucursal analizada
        CASE 
            WHEN @sucursal_id IS NULL THEN 'Todas las sucursales'
            ELSE (SELECT nombre FROM SUCURSAL WHERE sucursal_id = @sucursal_id)
        END as sucursal_analizada
        
    FROM DETALLE_PEDIDO dp
    INNER JOIN PEDIDO p ON dp.pedido_id = p.pedido_id
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    INNER JOIN PLATO pl ON dp.plato_id = pl.plato_id
    LEFT JOIN MESA m ON p.mesa_id = m.mesa_id
    WHERE ep.nombre IN ('Entregado', 'Cerrado')  -- Estados completados
      AND p.fecha_pedido >= @fecha_inicio
      AND p.fecha_pedido <= @fecha_fin
      AND dp.plato_id IS NOT NULL
      AND (@sucursal_id IS NULL OR m.sucursal_id = @sucursal_id OR p.mesa_id IS NULL)
    GROUP BY pl.plato_id, pl.nombre, pl.categoria
    ORDER BY total_vendido DESC
    
    -- Mostrar resultados principales
    SELECT * FROM #ResultadoRanking ORDER BY posicion_ranking
    
    -- Estadisticas adicionales del periodo
    PRINT '';
    PRINT 'ESTADISTICAS DEL PERIODO ANALIZADO:';
    PRINT '===================================';
    
    -- Estadisticas del periodo
    PRINT '1. RESUMEN DE VENTAS:';
    SELECT 
        'Productos analizados' as metrica,
        COUNT(DISTINCT dp.plato_id) as valor
    FROM DETALLE_PEDIDO dp
    INNER JOIN PEDIDO p ON dp.pedido_id = p.pedido_id
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    WHERE ep.nombre IN ('Entregado', 'Cerrado')
      AND p.fecha_pedido >= @fecha_inicio
      AND p.fecha_pedido <= @fecha_fin
      AND dp.plato_id IS NOT NULL
      AND (@sucursal_id IS NULL OR EXISTS (SELECT 1 FROM MESA m WHERE m.mesa_id = p.mesa_id AND m.sucursal_id = @sucursal_id) OR p.mesa_id IS NULL)
    
    UNION ALL
    
    SELECT 
        'Total unidades vendidas',
        SUM(dp.cantidad)
    FROM DETALLE_PEDIDO dp
    INNER JOIN PEDIDO p ON dp.pedido_id = p.pedido_id
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    WHERE ep.nombre IN ('Entregado', 'Cerrado')
      AND p.fecha_pedido >= @fecha_inicio
      AND p.fecha_pedido <= @fecha_fin
      AND dp.plato_id IS NOT NULL
      AND (@sucursal_id IS NULL OR EXISTS (SELECT 1 FROM MESA m WHERE m.mesa_id = p.mesa_id AND m.sucursal_id = @sucursal_id) OR p.mesa_id IS NULL)
    
    UNION ALL
    
    SELECT 
        'Ingresos totales',
        CAST(SUM(dp.subtotal) AS INT)
    FROM DETALLE_PEDIDO dp
    INNER JOIN PEDIDO p ON dp.pedido_id = p.pedido_id
    INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    WHERE ep.nombre IN ('Entregado', 'Cerrado')
      AND p.fecha_pedido >= @fecha_inicio
      AND p.fecha_pedido <= @fecha_fin
      AND dp.plato_id IS NOT NULL
      AND (@sucursal_id IS NULL OR EXISTS (SELECT 1 FROM MESA m WHERE m.mesa_id = p.mesa_id AND m.sucursal_id = @sucursal_id) OR p.mesa_id IS NULL);
    
    -- Guardar reporte
    IF @guardar_reporte = 1
    BEGIN
        INSERT INTO REPORTES_GENERADOS (tipo_reporte, fecha_reporte, sucursal_id, datos_json, observaciones)
        VALUES (
            'RANKING_PRODUCTOS_MENSUAL',
            @fecha_fin,
            @sucursal_id,
            (SELECT * FROM #ResultadoRanking FOR JSON PATH),
            'Top ' + CAST(@top_cantidad AS VARCHAR) + ' productos del mes ' + CAST(@mes AS VARCHAR) + '/' + CAST(@ano AS VARCHAR)
        )
    END
    
    DROP TABLE #ResultadoRanking
END
GO

PRINT 'Stored procedures de reportes mensuales creados'
PRINT ''

-- =============================================
-- VALIDACIÓN PARCIAL - STORED PROCEDURES
-- =============================================
PRINT 'Validando stored procedures creados...'

-- Verificar SPs de reportes diarios
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ReporteVentasDiario]') AND type in (N'P', N'PC'))
    PRINT 'sp_ReporteVentasDiario: OK'
ELSE
    PRINT 'sp_ReporteVentasDiario: ERROR'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_PlatosMasVendidosDiario]') AND type in (N'P', N'PC'))
    PRINT 'sp_PlatosMasVendidosDiario: OK'
ELSE
    PRINT 'sp_PlatosMasVendidosDiario: ERROR'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RendimientoCanalDiario]') AND type in (N'P', N'PC'))
    PRINT 'sp_RendimientoCanalDiario: OK'
ELSE
    PRINT 'sp_RendimientoCanalDiario: ERROR'

-- Verificar SPs de reportes mensuales
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_AnalisisVentasMensual]') AND type in (N'P', N'PC'))
    PRINT 'sp_AnalisisVentasMensual: OK'
ELSE
    PRINT 'sp_AnalisisVentasMensual: ERROR'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_RankingProductosMensual]') AND type in (N'P', N'PC'))
    PRINT 'sp_RankingProductosMensual: OK'
ELSE
    PRINT 'sp_RankingProductosMensual: ERROR'

-- Verificar tabla de reportes
IF EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'REPORTES_GENERADOS')
    PRINT 'REPORTES_GENERADOS: OK'
ELSE
    PRINT 'REPORTES_GENERADOS: ERROR'

PRINT ''

-- =============================================
-- FINALIZACIÓN BUNDLE R1
-- =============================================

PRINT 'BUNDLE R1 - STORED PROCEDURES COMPLETADO EXITOSAMENTE!'
PRINT '=========================================================='
PRINT 'Estado: Infraestructura y SPs de reportes implementados'
PRINT 'Stored Procedures: 5 SPs de reportes creados'
PRINT 'Infraestructura: Tabla REPORTES_GENERADOS configurada'
PRINT ''
PRINT 'FUNCIONALIDADES DISPONIBLES EN R1:'
PRINT '   Reportes diarios automáticos de ventas'
PRINT '   Top platos más vendidos diario/mensual'
PRINT '   Análisis de rendimiento por canal'
PRINT '   Almacenamiento histórico de reportes'
PRINT ''
PRINT 'PRUEBAS RÁPIDAS DISPONIBLES:'
PRINT '   EXEC sp_ReporteVentasDiario'
PRINT '   EXEC sp_PlatosMasVendidosDiario @top_cantidad = 5'
PRINT '   EXEC sp_RendimientoCanalDiario'
PRINT ''
PRINT 'SIGUIENTE PASO: Ejecutar Bundle_R2_Reportes_Vistas_Dashboard.sql'
PRINT '    para completar el sistema con vistas y dashboard'
PRINT '========================================================='
GO