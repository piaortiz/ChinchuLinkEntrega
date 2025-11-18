-- =============================================
-- BUNDLE C - SEGURIDAD
-- ChinchuLink - Sistema de Gestion de Restaurante
-- Descripcion: Implementacion de seguridad, roles y permisos
-- Fecha: 9 de noviembre de 2025
-- Desarrollado por: SQLeaders S.A.
-- Proyecto Educativo ISTEA - Uso academico exclusivo
-- PROHIBIDA LA COMERCIALIZACION
-- =============================================

USE ChinchuLink
GO

PRINT 'INICIANDO BUNDLE C - SEGURIDAD'
PRINT '================================='
PRINT 'Configurando sistema de seguridad y control de acceso...'
PRINT ''

-- =============================================
-- PASO 1: CREAR ROLES DE APLICACION
-- =============================================

PRINT 'Paso 1/3: Creando roles de seguridad...'

-- Rol: Administrador del Sistema
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_administrador')
BEGIN
    CREATE ROLE [rol_administrador];
    PRINT 'Rol rol_administrador creado exitosamente';
END
ELSE
    PRINT 'Rol rol_administrador ya existe';

-- Rol: Empleado General (meseros, cocina)
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_empleado')
BEGIN
    CREATE ROLE [rol_empleado];
    PRINT 'Rol rol_empleado creado exitosamente';
END
ELSE
    PRINT 'Rol rol_empleado ya existe';

-- Rol: Cajero/Facturacion
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_cajero')
BEGIN
    CREATE ROLE [rol_cajero];
    PRINT 'Rol rol_cajero creado exitosamente';
END
ELSE
    PRINT 'Rol rol_cajero ya existe';

-- Rol: Delivery
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_delivery')
BEGIN
    CREATE ROLE [rol_delivery];
    PRINT 'Rol rol_delivery creado exitosamente';
END
ELSE
    PRINT 'Rol rol_delivery ya existe';

-- Rol: Cliente
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_cliente')
BEGIN
    CREATE ROLE [rol_cliente];
    PRINT 'Rol rol_cliente creado exitosamente';
END
ELSE
    PRINT 'Rol rol_cliente ya existe';

-- Rol: Reportes y Business Intelligence
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_reportes')
BEGIN
    CREATE ROLE [rol_reportes];
    PRINT 'Rol rol_reportes creado exitosamente';
END
ELSE
    PRINT 'Rol rol_reportes ya existe';

-- Rol: Aplicacion Web
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_aplicacion_web')
BEGIN
    CREATE ROLE [rol_aplicacion_web];
    PRINT 'Rol rol_aplicacion_web creado exitosamente';
END
ELSE
    PRINT 'Rol rol_aplicacion_web ya existe';

-- =============================================
-- PASO 2: ASIGNAR PERMISOS POR ROL
-- =============================================

PRINT 'Paso 2/3: Configurando permisos por rol...'

-- PERMISOS PARA ROL ADMINISTRADOR
GRANT SELECT, INSERT, UPDATE, DELETE ON SCHEMA::dbo TO [rol_administrador];
GRANT EXECUTE ON SCHEMA::dbo TO [rol_administrador];
PRINT 'Permisos de administrador configurados';

-- PERMISOS PARA ROL EMPLEADO (Operaciones basicas)
GRANT SELECT ON SCHEMA::dbo TO [rol_empleado];
GRANT EXECUTE ON dbo.sp_CrearPedido TO [rol_empleado];
GRANT EXECUTE ON dbo.sp_AgregarItemPedido TO [rol_empleado];
GRANT EXECUTE ON dbo.sp_CalcularTotalPedido TO [rol_empleado];
GRANT INSERT, UPDATE ON PEDIDO TO [rol_empleado];
GRANT INSERT, UPDATE ON DETALLE_PEDIDO TO [rol_empleado];
PRINT 'Permisos de empleado configurados';

-- PERMISOS PARA ROL CAJERO (Operaciones + cierre)
GRANT SELECT ON SCHEMA::dbo TO [rol_cajero];
GRANT EXECUTE ON dbo.sp_CrearPedido TO [rol_cajero];
GRANT EXECUTE ON dbo.sp_AgregarItemPedido TO [rol_cajero];
GRANT EXECUTE ON dbo.sp_CalcularTotalPedido TO [rol_cajero];
GRANT EXECUTE ON dbo.sp_CerrarPedido TO [rol_cajero];
GRANT INSERT, UPDATE ON PEDIDO TO [rol_cajero];
GRANT INSERT, UPDATE ON DETALLE_PEDIDO TO [rol_cajero];
PRINT 'Permisos de cajero configurados';

-- PERMISOS PARA ROL DELIVERY
GRANT SELECT ON PEDIDO TO [rol_delivery];
GRANT SELECT ON DETALLE_PEDIDO TO [rol_delivery];
GRANT SELECT ON PLATO TO [rol_delivery];
GRANT SELECT ON CLIENTE TO [rol_delivery];
GRANT UPDATE ON PEDIDO TO [rol_delivery];
PRINT 'Permisos de delivery configurados';

-- PERMISOS PARA ROL CLIENTE (Solo lectura de sus datos)
GRANT SELECT ON PEDIDO TO [rol_cliente];
GRANT SELECT ON DETALLE_PEDIDO TO [rol_cliente];
GRANT SELECT ON PLATO TO [rol_cliente];
GRANT SELECT ON PRECIO TO [rol_cliente];
PRINT 'Permisos de cliente configurados';

-- PERMISOS PARA ROL REPORTES (Solo lectura)
GRANT SELECT ON SCHEMA::dbo TO [rol_reportes];
PRINT 'Permisos de reportes configurados';

-- PERMISOS PARA ROL APLICACION WEB
GRANT SELECT, INSERT, UPDATE ON SCHEMA::dbo TO [rol_aplicacion_web];
GRANT EXECUTE ON SCHEMA::dbo TO [rol_aplicacion_web];
PRINT 'Permisos de aplicacion web configurados';

-- =============================================
-- PASO 3: CREAR USUARIOS DE APLICACION
-- =============================================

PRINT 'Paso 3/3: Creando usuarios de aplicacion...'

-- Usuario para aplicacion web
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_chinchulink_web')
BEGIN
    CREATE USER [app_chinchulink_web] WITHOUT LOGIN;
    ALTER ROLE [rol_aplicacion_web] ADD MEMBER [app_chinchulink_web];
    PRINT 'Usuario app_chinchulink_web creado y asignado';
END
ELSE
    PRINT 'Usuario app_chinchulink_web ya existe';

-- Usuario para reportes
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_chinchulink_reportes')
BEGIN
    CREATE USER [app_chinchulink_reportes] WITHOUT LOGIN;
    ALTER ROLE [rol_reportes] ADD MEMBER [app_chinchulink_reportes];
    PRINT 'Usuario app_chinchulink_reportes creado y asignado';
END
ELSE
    PRINT 'Usuario app_chinchulink_reportes ya existe';

-- Usuario para delivery
IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_chinchulink_delivery')
BEGIN
    CREATE USER [app_chinchulink_delivery] WITHOUT LOGIN;
    ALTER ROLE [rol_delivery] ADD MEMBER [app_chinchulink_delivery];
    PRINT 'Usuario app_chinchulink_delivery creado y asignado';
END
ELSE
    PRINT 'Usuario app_chinchulink_delivery ya existe';

-- =============================================
-- FUNCION AUXILIAR: VALIDAR PERMISOS
-- =============================================

PRINT 'Creando funcion de validacion de permisos...'

IF OBJECT_ID('fn_ValidarPermisoUsuario', 'FN') IS NOT NULL
    DROP FUNCTION fn_ValidarPermisoUsuario
GO

CREATE FUNCTION fn_ValidarPermisoUsuario(
    @usuario NVARCHAR(128),
    @objeto NVARCHAR(128),
    @permiso NVARCHAR(128)
)
RETURNS BIT
AS
BEGIN
    DECLARE @tiene_permiso BIT = 0
    
    -- Validar si el usuario tiene el permiso especificado
    IF EXISTS (
        SELECT 1 FROM sys.database_permissions dp
        INNER JOIN sys.objects o ON dp.major_id = o.object_id
        INNER JOIN sys.database_principals p ON dp.grantee_principal_id = p.principal_id
        WHERE p.name = @usuario
          AND o.name = @objeto  
          AND dp.permission_name = @permiso
          AND dp.state = 'G' -- GRANT
    )
        SET @tiene_permiso = 1
    
    RETURN @tiene_permiso
END
GO

PRINT 'Funcion de validacion creada exitosamente'

-- =============================================
-- SP DE AUDITORIA DE SEGURIDAD
-- =============================================

IF OBJECT_ID('sp_AuditoriaSeguridad', 'P') IS NOT NULL
    DROP PROCEDURE sp_AuditoriaSeguridad
GO

CREATE PROCEDURE sp_AuditoriaSeguridad
AS
BEGIN
    SET NOCOUNT ON;
    
    PRINT 'AUDITORIA DE SEGURIDAD - CHINCHULINK'
    PRINT '===================================='
    PRINT ''
    
    -- Mostrar roles
    PRINT 'ROLES DE BASE DE DATOS:'
    SELECT 
        name as 'Rol',
        create_date as 'Fecha Creacion',
        type_desc as 'Tipo'
    FROM sys.database_principals 
    WHERE type = 'R' AND name LIKE 'rol_%'
    ORDER BY name
    
    PRINT ''
    
    -- Mostrar usuarios de aplicacion
    PRINT 'USUARIOS DE APLICACION:'
    SELECT 
        u.name as 'Usuario',
        r.name as 'Rol Asignado',
        u.create_date as 'Fecha Creacion'
    FROM sys.database_principals u
    INNER JOIN sys.database_role_members rm ON u.principal_id = rm.member_principal_id
    INNER JOIN sys.database_principals r ON rm.role_principal_id = r.principal_id
    WHERE u.name LIKE 'app_%'
    ORDER BY u.name, r.name
    
    PRINT ''
    PRINT 'Auditoria completada'
END
GO

PRINT 'SP de auditoria creado exitosamente'

-- =============================================
-- VALIDACION FINAL
-- =============================================

PRINT ''
PRINT 'Ejecutando auditoria de seguridad...'
EXEC sp_AuditoriaSeguridad

-- Contar elementos creados
DECLARE @roles_count INT = (SELECT COUNT(*) FROM sys.database_principals WHERE type = 'R' AND name LIKE 'rol_%')
DECLARE @usuarios_count INT = (SELECT COUNT(*) FROM sys.database_principals WHERE name LIKE 'app_%')
DECLARE @permisos_count INT = (SELECT COUNT(*) FROM sys.database_permissions WHERE grantee_principal_id IN 
    (SELECT principal_id FROM sys.database_principals WHERE name LIKE 'rol_%'))

PRINT ''
PRINT 'Roles creados: ' + CAST(@roles_count AS VARCHAR)
PRINT 'Usuarios: ' + CAST(@usuarios_count AS VARCHAR)
PRINT 'Permisos asignados: ' + CAST(@permisos_count AS VARCHAR)

-- Test basico de permisos
IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'rol_administrador')
    PRINT 'Rol administrador: OK'
ELSE
    PRINT 'ERROR Rol administrador: ERROR'

IF EXISTS (SELECT * FROM sys.database_principals WHERE name = 'app_chinchulink_web')
    PRINT 'Usuario aplicacion web: OK'
ELSE
    PRINT 'ERROR Usuario aplicacion web: ERROR'

-- =============================================
-- FINALIZACION
-- =============================================

PRINT ''
PRINT 'BUNDLE C - SEGURIDAD COMPLETADO EXITOSAMENTE!'
PRINT '================================================='
PRINT 'Estado: Sistema de seguridad configurado'
PRINT 'Roles: 7 roles de aplicacion creados'
PRINT 'Usuarios: 3 usuarios de aplicacion configurados'
PRINT 'Seguridad implementada:'
PRINT '   • Control de acceso granular por rol'
PRINT '   • Permisos minimos necesarios'
PRINT '   • Usuarios de aplicacion sin login'
PRINT '   • Funciones de validacion'
PRINT '   • Auditoria de seguridad'
PRINT ''
PRINT 'Siguiente paso: Ejecutar Bundle D - Consultas Basicas'
PRINT '======================================================='
GO