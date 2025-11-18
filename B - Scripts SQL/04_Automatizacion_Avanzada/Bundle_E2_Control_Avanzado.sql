-- =============================================
-- BUNDLE E2 - CONTROL AVANZADO
-- ChinchuLink - Sistema de Gestión de Restaurante
-- Descripción: Triggers de stock, notificaciones y control avanzado
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

PRINT 'INICIANDO BUNDLE E2 - CONTROL AVANZADO'
PRINT '========================================='
PRINT 'Instalando triggers de stock y sistema de notificaciones...'
PRINT ''

-- =============================================
-- TRIGGER 1: VALIDAR STOCK (SIMULACIÓN)
-- =============================================

PRINT 'Creando Trigger: tr_ValidarStock...'

-- Crear tabla de stock simulada si no existe
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'STOCK_SIMULADO')
BEGIN
    CREATE TABLE STOCK_SIMULADO (
        plato_id INT PRIMARY KEY,
        stock_disponible INT NOT NULL DEFAULT 100,
        stock_minimo INT NOT NULL DEFAULT 10,
        ultima_actualizacion DATETIME NOT NULL DEFAULT GETDATE(),
        CONSTRAINT FK_STOCK_plato FOREIGN KEY (plato_id) REFERENCES PLATO(plato_id)
    )
    
    -- Insertar stock inicial para todos los platos
    INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo)
    SELECT plato_id, 100, 10 FROM PLATO
    
    PRINT 'Tabla STOCK_SIMULADO creada con datos iniciales'
END

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_ValidarStock]'))
DROP TRIGGER [dbo].[tr_ValidarStock]
GO

CREATE TRIGGER [dbo].[tr_ValidarStock]
ON [dbo].[DETALLE_PEDIDO]
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Validar stock solo para platos (no combos)
    DECLARE @platos_sin_stock TABLE (plato_id INT, nombre NVARCHAR(100), stock_actual INT)
    
    INSERT INTO @platos_sin_stock
    SELECT 
        i.plato_id,
        p.nombre,
        s.stock_disponible
    FROM inserted i
    INNER JOIN PLATO p ON i.plato_id = p.plato_id
    INNER JOIN STOCK_SIMULADO s ON i.plato_id = s.plato_id
    WHERE i.plato_id IS NOT NULL
      AND s.stock_disponible < i.cantidad
    
    -- Si hay platos sin stock, mostrar advertencia
    IF EXISTS (SELECT 1 FROM @platos_sin_stock)
    BEGIN
        DECLARE @mensaje NVARCHAR(MAX) = 'ADVERTENCIA: Los siguientes platos tienen stock insuficiente: '
        
        SELECT @mensaje = @mensaje + nombre + ' (stock: ' + CAST(stock_actual AS VARCHAR) + '), '
        FROM @platos_sin_stock
        
        PRINT @mensaje
    END
    
    -- Actualizar stock (restar cantidades)
    UPDATE s
    SET 
        stock_disponible = s.stock_disponible - i.cantidad,
        ultima_actualizacion = GETDATE()
    FROM STOCK_SIMULADO s
    INNER JOIN inserted i ON s.plato_id = i.plato_id
    WHERE i.plato_id IS NOT NULL
END
GO

-- =============================================
-- TRIGGER 2: SISTEMA DE NOTIFICACIONES
-- =============================================

PRINT 'Creando Trigger: tr_SistemaNotificaciones...'

-- Crear tabla de notificaciones si no existe
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NOTIFICACIONES')
BEGIN
    CREATE TABLE NOTIFICACIONES (
        notificacion_id INT IDENTITY(1,1) PRIMARY KEY,
        tipo VARCHAR(50) NOT NULL,
        titulo NVARCHAR(200) NOT NULL,
        mensaje NVARCHAR(500) NOT NULL,
        pedido_id INT NULL,
        mesa_id INT NULL,
        prioridad VARCHAR(20) NOT NULL DEFAULT 'NORMAL', -- BAJA, NORMAL, ALTA, CRITICA
        fecha_creacion DATETIME NOT NULL DEFAULT GETDATE(),
        leida BIT NOT NULL DEFAULT 0,
        fecha_lectura DATETIME NULL,
        usuario_destino VARCHAR(100) NULL
    )
    PRINT 'Tabla NOTIFICACIONES creada'
END

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_SistemaNotificaciones]'))
DROP TRIGGER [dbo].[tr_SistemaNotificaciones]
GO

CREATE TRIGGER [dbo].[tr_SistemaNotificaciones]
ON [dbo].[PEDIDO]
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    -- Notificación cuando un pedido cambia a "Listo"
    INSERT INTO NOTIFICACIONES (tipo, titulo, mensaje, pedido_id, mesa_id, prioridad, usuario_destino)
    SELECT 
        'PEDIDO_LISTO',
        'Pedido Listo para Entregar',
        CONCAT('El pedido #', i.pedido_id, 
               CASE WHEN m.numero IS NOT NULL THEN ' de la mesa ' + CAST(m.numero AS VARCHAR) ELSE '' END,
               ' está listo para entregar. Total: $', i.total),
        i.pedido_id,
        i.mesa_id,
        'ALTA',
        'MOZOS'
    FROM inserted i
    INNER JOIN deleted d ON i.pedido_id = d.pedido_id
    INNER JOIN ESTADO_PEDIDO ep_new ON i.estado_id = ep_new.estado_id
    INNER JOIN ESTADO_PEDIDO ep_old ON d.estado_id = ep_old.estado_id
    LEFT JOIN MESA m ON i.mesa_id = m.mesa_id
    WHERE ep_new.nombre = 'Listo' AND ep_old.nombre != 'Listo'
    
    -- Notificación cuando un pedido se cierra
    INSERT INTO NOTIFICACIONES (tipo, titulo, mensaje, pedido_id, mesa_id, prioridad, usuario_destino)
    SELECT 
        'PEDIDO_CERRADO',
        'Pedido Completado',
        CONCAT('Pedido #', i.pedido_id, ' cerrado exitosamente. Total: $', i.total),
        i.pedido_id,
        i.mesa_id,
        'NORMAL',
        'CAJA'
    FROM inserted i
    INNER JOIN deleted d ON i.pedido_id = d.pedido_id
    INNER JOIN ESTADO_PEDIDO ep_new ON i.estado_id = ep_new.estado_id
    INNER JOIN ESTADO_PEDIDO ep_old ON d.estado_id = ep_old.estado_id
    WHERE ep_new.nombre = 'Cerrado' AND ep_old.nombre != 'Cerrado'
END
GO

-- =============================================
-- SP 1: CONSULTAR NOTIFICACIONES
-- =============================================

PRINT 'Creando SP: sp_ConsultarNotificaciones...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarNotificaciones]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ConsultarNotificaciones]
GO

CREATE PROCEDURE [dbo].[sp_ConsultarNotificaciones]
    @usuario_destino VARCHAR(100) = NULL,
    @solo_no_leidas BIT = 1,
    @prioridad VARCHAR(20) = NULL
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        n.notificacion_id,
        n.tipo,
        n.titulo,
        n.mensaje,
        n.pedido_id,
        n.mesa_id,
        n.prioridad,
        n.fecha_creacion,
        n.leida,
        n.fecha_lectura,
        n.usuario_destino,
        
        -- Información adicional del pedido si existe
        CASE WHEN n.pedido_id IS NOT NULL THEN ep.nombre ELSE NULL END as estado_pedido_actual,
        CASE WHEN n.mesa_id IS NOT NULL THEN m.numero ELSE NULL END as numero_mesa,
        
        -- Antigüedad de la notificación
        DATEDIFF(MINUTE, n.fecha_creacion, GETDATE()) as minutos_antiguedad,
        
        -- Prioridad numérica para ordenamiento
        CASE n.prioridad
            WHEN 'CRITICA' THEN 4
            WHEN 'ALTA' THEN 3
            WHEN 'NORMAL' THEN 2
            WHEN 'BAJA' THEN 1
            ELSE 0
        END as prioridad_orden
        
    FROM NOTIFICACIONES n
    LEFT JOIN PEDIDO p ON n.pedido_id = p.pedido_id
    LEFT JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
    LEFT JOIN MESA m ON n.mesa_id = m.mesa_id
    WHERE (@usuario_destino IS NULL OR n.usuario_destino = @usuario_destino)
      AND (@solo_no_leidas = 0 OR n.leida = 0)
      AND (@prioridad IS NULL OR n.prioridad = @prioridad)
    ORDER BY prioridad_orden DESC, n.fecha_creacion DESC
END
GO

-- =============================================
-- SP 2: MARCAR NOTIFICACIÓN COMO LEÍDA
-- =============================================

PRINT 'Creando SP: sp_MarcarNotificacionLeida...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MarcarNotificacionLeida]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_MarcarNotificacionLeida]
GO

CREATE PROCEDURE [dbo].[sp_MarcarNotificacionLeida]
    @notificacion_id INT
AS
BEGIN
    SET NOCOUNT ON;
    
    UPDATE NOTIFICACIONES
    SET 
        leida = 1,
        fecha_lectura = GETDATE()
    WHERE notificacion_id = @notificacion_id
      AND leida = 0
    
    IF @@ROWCOUNT > 0
    BEGIN
        PRINT 'Notificación marcada como leída exitosamente'
        RETURN 0
    END
    ELSE
    BEGIN
        PRINT 'Notificación no encontrada o ya estaba leída'
        RETURN -1
    END
END
GO

-- =============================================
-- SP 3: CONSULTAR STOCK ACTUAL
-- =============================================

PRINT 'Creando SP: sp_ConsultarStock...'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarStock]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[sp_ConsultarStock]
GO

CREATE PROCEDURE [dbo].[sp_ConsultarStock]
    @plato_id INT = NULL,
    @solo_stock_bajo BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT 
        p.plato_id,
        p.nombre,
        p.categoria,
        s.stock_disponible,
        s.stock_minimo,
        s.ultima_actualizacion,
        CASE 
            WHEN s.stock_disponible <= s.stock_minimo THEN 'CRÍTICO'
            WHEN s.stock_disponible <= s.stock_minimo * 2 THEN 'BAJO'
            ELSE 'NORMAL'
        END as estado_stock,
        pr.precio as precio_actual
    FROM PLATO p
    INNER JOIN STOCK_SIMULADO s ON p.plato_id = s.plato_id
    LEFT JOIN (
        SELECT 
            plato_id, 
            precio,
            ROW_NUMBER() OVER (PARTITION BY plato_id ORDER BY vigencia_desde DESC) as rn
        FROM PRECIO 
        WHERE vigencia_desde <= GETDATE()
          AND (vigencia_hasta IS NULL OR vigencia_hasta >= GETDATE())
    ) pr ON p.plato_id = pr.plato_id AND pr.rn = 1
    WHERE (@plato_id IS NULL OR p.plato_id = @plato_id)
      AND (@solo_stock_bajo = 0 OR s.stock_disponible <= s.stock_minimo)
      AND p.activo = 1
    ORDER BY 
        CASE 
            WHEN s.stock_disponible <= s.stock_minimo THEN 1
            WHEN s.stock_disponible <= s.stock_minimo * 2 THEN 2
            ELSE 3
        END,
        p.nombre
END
GO

-- =============================================
-- VALIDACIÓN
-- =============================================

PRINT ''
PRINT 'Validando control avanzado creado...'

-- Verificar triggers
IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_ValidarStock]'))
    PRINT 'tr_ValidarStock: Creado exitosamente'
ELSE
    PRINT 'tr_ValidarStock: ERROR en la creación'

IF EXISTS (SELECT * FROM sys.triggers WHERE object_id = OBJECT_ID(N'[dbo].[tr_SistemaNotificaciones]'))
    PRINT 'tr_SistemaNotificaciones: Creado exitosamente'
ELSE
    PRINT 'tr_SistemaNotificaciones: ERROR en la creación'

-- Verificar SPs
IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarNotificaciones]') AND type in (N'P', N'PC'))
    PRINT 'sp_ConsultarNotificaciones: Creado exitosamente'
ELSE
    PRINT 'sp_ConsultarNotificaciones: ERROR en la creación'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_MarcarNotificacionLeida]') AND type in (N'P', N'PC'))
    PRINT 'sp_MarcarNotificacionLeida: Creado exitosamente'
ELSE
    PRINT 'sp_MarcarNotificacionLeida: ERROR en la creación'

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[sp_ConsultarStock]') AND type in (N'P', N'PC'))
    PRINT 'sp_ConsultarStock: Creado exitosamente'
ELSE
    PRINT 'sp_ConsultarStock: ERROR en la creación'

-- Verificar tablas auxiliares
IF EXISTS (SELECT * FROM sys.tables WHERE name = 'STOCK_SIMULADO')
    PRINT 'STOCK_SIMULADO: Tabla creada correctamente'
ELSE
    PRINT 'STOCK_SIMULADO: ERROR en la creación'

IF EXISTS (SELECT * FROM sys.tables WHERE name = 'NOTIFICACIONES')
    PRINT 'NOTIFICACIONES: Tabla creada correctamente'
ELSE
    PRINT 'NOTIFICACIONES: ERROR en la creación'

PRINT ''
PRINT 'BUNDLE E2 - CONTROL AVANZADO COMPLETADO!'
PRINT '============================================'
PRINT 'Estado: Sistema de control avanzado instalado'
PRINT 'Funcionalidad: tr_ValidarStock'
PRINT 'Funcionalidad: tr_SistemaNotificaciones'
PRINT 'Funcionalidad: sp_ConsultarNotificaciones'
PRINT 'Funcionalidad: sp_MarcarNotificacionLeida'
PRINT 'Funcionalidad: sp_ConsultarStock'
PRINT ''
PRINT 'RESUMEN BUNDLE E COMPLETO (E1+E2):'
PRINT '   tr_ActualizarTotales: Totales automáticos'
PRINT '   tr_AuditoriaPedidos: Auditoría principal'
PRINT '   tr_AuditoriaDetalle: Auditoría de items'
PRINT '   tr_ValidarStock: Control de inventario'
PRINT '   tr_SistemaNotificaciones: Alertas automáticas'
PRINT '   SPs de notificaciones y stock'
PRINT ''
PRINT 'AUTOMATIZACION COMPLETA Y FUNCIONAL'
PRINT 'SIGUIENTE PASO: Ejecutar Bundle_C_Seguridad.sql'
PRINT '================================================='
GO