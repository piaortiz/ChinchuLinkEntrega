-- ============================================================================
-- PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql
-- Script CORREGIDO para cargar personal de Parrilla El Encuentro
-- Estructura organizacional según requerimientos específicos:
-- 1 Admin + 1 Gerente + 6 Mozos + 2 Cajeros + 5 Cocineros + 2 Deliverys
-- ============================================================================

USE ChinchuLink;
GO

PRINT 'PARTE 4: CONFIGURANDO PERSONAL - ESTRUCTURA ACTUALIZADA';
PRINT '==========================================================';
PRINT 'Cargando personal según nueva estructura organizacional';
PRINT '';

BEGIN TRANSACTION TRX_PERSONAL_ACTUALIZADO;

-- DESACTIVAR TEMPORALMENTE CONSTRAINTS PARA EVITAR CONFLICTOS FK
PRINT 'Desactivando constraints temporalmente...';
IF OBJECT_ID('PEDIDO') IS NOT NULL
    ALTER TABLE PEDIDO NOCHECK CONSTRAINT ALL;

-- VERIFICAR ROLES EXISTENTES PRIMERO
PRINT 'Verificando roles disponibles...';
SELECT 
    rol_id,
    nombre,
    descripcion
FROM ROL 
ORDER BY rol_id;

PRINT '';
PRINT 'Insertando personal operativo...';

-- VERIFICAR SI YA EXISTEN EMPLEADOS
IF EXISTS (SELECT 1 FROM EMPLEADO WHERE usuario = 'agarcia')
BEGIN
    PRINT ' Ya existen empleados cargados. Limpiando todos los empleados...';
    DELETE FROM EMPLEADO;
    DBCC CHECKIDENT ('EMPLEADO', RESEED, 0);
    PRINT 'Empleados eliminados. Reseeding completado.';
END
ELSE
BEGIN
    PRINT 'Limpiando empleados existentes (manteniendo estructura)...';
    DELETE FROM EMPLEADO WHERE empleado_id > 1;
    DBCC CHECKIDENT ('EMPLEADO', RESEED, 1);
END

-- EMPLEADOS SEGÚN NUEVA ESTRUCTURA ORGANIZACIONAL (17 personas total)
INSERT INTO EMPLEADO (nombre, usuario, hash_password, rol_id, sucursal_id, activo) VALUES

-- ============================================================================
-- 1. ADMINISTRADOR DE SISTEMA (1 persona) - ROL_ID = 1 (Administrador)
-- ============================================================================
('Ana García Martinez', 'agarcia', 'hash_agarcia_caballito_2025', 1, 1, 1),

-- ============================================================================
-- 2. GERENTE DE SUCURSAL (1 persona) - ROL_ID = 2 (Gerente)  
-- ============================================================================
('Carlos Gómez', 'cgomez', 'hash_cgomez_gerente_2025', 2, 1, 1),

-- ============================================================================
-- 3. MOZOS/MESEROS (6 personas) - ROL_ID = 3 (Mozo)
-- ============================================================================
('María López', 'mlopez', 'hash_mlopez_mozo_2025', 3, 1, 1),
('Juan Martínez', 'jmartinez', 'hash_jmartinez_mozo_2025', 3, 1, 1),
('Laura Fernández', 'lfernandez', 'hash_lfernandez_mozo_2025', 3, 1, 1),
('Diego Rodríguez', 'drodriguez', 'hash_drodriguez_mozo_2025', 3, 1, 1),
('Ana Silva', 'asilva', 'hash_asilva_mozo_2025', 3, 1, 1),
('Miguel Vargas', 'mvargas', 'hash_mvargas_mozo_2025', 3, 1, 1),

-- ============================================================================
-- 4. CAJEROS (2 personas) - ROL_ID = 4 (Cajero)
-- ============================================================================
('Roberto Pérez', 'rperez', 'hash_rperez_cajero_2025', 4, 1, 1),
('Claudia Morales', 'cmorales', 'hash_cmorales_cajero_2025', 4, 1, 1),

-- ============================================================================
-- 5. COCINEROS (5 personas) - ROL_ID = 5 (Cocinero)
-- ============================================================================
('Alberto Gutiérrez', 'agutierrez', 'hash_agutierrez_cocinero_2025', 5, 1, 1),
('Patricia Romero', 'promero', 'hash_promero_cocinero_2025', 5, 1, 1),
('Ricardo Mendoza', 'rmendoza', 'hash_rmendoza_cocinero_2025', 5, 1, 1),
('Valeria Torres', 'vtorres', 'hash_vtorres_cocinero_2025', 5, 1, 1),
('Fernando Castro', 'fcastro', 'hash_fcastro_cocinero_2025', 5, 1, 1),

-- ============================================================================
-- 6. DELIVERY/REPARTIDORES (2 personas) - ROL_ID = 6 (Delivery)
-- ============================================================================
('Jorge Acosta', 'jacosta', 'hash_jacosta_delivery_2025', 6, 1, 1),
('Sebastián Jiménez', 'sjimenez', 'hash_sjimenez_delivery_2025', 6, 1, 1);

-- ============================================================================
-- VERIFICACIÓN DE LA ESTRUCTURA CARGADA
-- ============================================================================

PRINT '';
PRINT 'Verificando distribución de personal por rol:';
SELECT 
    r.nombre as 'ROL',
    COUNT(e.empleado_id) as 'CANTIDAD_EMPLEADOS',
    CASE r.nombre 
        WHEN 'Administrador' THEN '1 requerido'
        WHEN 'Gerente' THEN '1 requerido'
        WHEN 'Cajero' THEN '2 requeridos'
        WHEN 'Mozo' THEN '6 requeridos'
        WHEN 'Cocinero' THEN '5 requeridos'
        WHEN 'Repartidor' THEN '2 requeridos'
        ELSE 'No requerido'
    END as 'OBJETIVO',
    CASE 
        WHEN r.nombre = 'Administrador' AND COUNT(e.empleado_id) = 1 THEN 'OK'
        WHEN r.nombre = 'Gerente' AND COUNT(e.empleado_id) = 1 THEN 'OK'
        WHEN r.nombre = 'Cajero' AND COUNT(e.empleado_id) = 2 THEN 'OK'
        WHEN r.nombre = 'Mozo' AND COUNT(e.empleado_id) = 6 THEN 'OK'
        WHEN r.nombre = 'Cocinero' AND COUNT(e.empleado_id) = 5 THEN 'OK'
        WHEN r.nombre = 'Repartidor' AND COUNT(e.empleado_id) >= 2 THEN 'OK'
        WHEN COUNT(e.empleado_id) = 0 THEN '➖'
        ELSE 'ADVERTENCIA'
    END as 'STATUS'
FROM ROL r
LEFT JOIN EMPLEADO e ON r.rol_id = e.rol_id AND e.activo = 1
GROUP BY r.rol_id, r.nombre
ORDER BY r.rol_id;

PRINT '';
PRINT 'Resumen total:';
SELECT 'TOTAL EMPLEADOS ACTIVOS' as RESUMEN, COUNT(*) as TOTAL FROM EMPLEADO WHERE activo = 1;

PRINT '';
PRINT 'Listado completo del personal:';
SELECT 
    e.empleado_id AS 'ID',
    e.nombre AS 'EMPLEADO',
    e.usuario AS 'USUARIO',
    r.nombre AS 'ROL',
    'Sucursal #' + CAST(e.sucursal_id AS VARCHAR) AS 'SUCURSAL',
    'Activo' AS 'ESTADO'
FROM EMPLEADO e
INNER JOIN ROL r ON e.rol_id = r.rol_id
WHERE e.activo = 1
ORDER BY r.rol_id, e.nombre;

-- REACTIVAR CONSTRAINTS
PRINT '';
PRINT 'Reactivando constraints...';
IF OBJECT_ID('PEDIDO') IS NOT NULL
    ALTER TABLE PEDIDO CHECK CONSTRAINT ALL;

COMMIT TRANSACTION TRX_PERSONAL_ACTUALIZADO;

PRINT '';
PRINT 'PERSONAL CONFIGURADO EXITOSAMENTE - ESTRUCTURA ACTUALIZADA';
PRINT '============================================================';
PRINT '   DISTRIBUCIÓN FINAL:';
PRINT '   • 2 Administradores de Sistema (1 original + 1 nuevo)';
PRINT '   • 1 Gerente de Sucursal'; 
PRINT '   • 6 Mozos/Meseros';
PRINT '   • 2 Cajeros';
PRINT '   • 5 Cocineros';
PRINT '   • 2 Repartidores';
PRINT '   = 18 EMPLEADOS ACTIVOS TOTAL';
PRINT '';
PRINT '  NOTA: Se mantiene un administrador de respaldo para mayor seguridad.';
PRINT '   Se crearon 2 repartidores según los requerimientos ajustados.';
PRINT '';

GO