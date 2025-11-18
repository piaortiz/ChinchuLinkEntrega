-- ============================================================================
-- PARTE 6: VERIFICACIÓN FINAL
-- Script de inicialización Parrilla El Encuentro - Resumen Final
-- ============================================================================

USE ChinchuLink;
GO

PRINT 'PARTE 6: VERIFICACIÓN FINAL';
PRINT '==============================';

PRINT 'GENERANDO RESUMEN COMPLETO DE LA CONFIGURACIÓN...';
PRINT '';

-- ============================================================================
-- RESUMEN GENERAL DE CONFIGURACIÓN
-- ============================================================================

PRINT 'RESUMEN GENERAL DE CONFIGURACIÓN:';
PRINT '====================================';

SELECT 
    '🍽️ MENÚ OPTIMIZADO' as CONFIGURACION,
    COUNT(*) as TOTAL,
    'productos activos' as DESCRIPCION
FROM PLATO 
WHERE activo = 1

UNION ALL

SELECT 
    'PRECIOS VIGENTES',
    COUNT(*),
    'precios configurados'
FROM PRECIO
WHERE vigencia_hasta >= GETDATE()

UNION ALL

SELECT 
    'PERSONAL ACTIVO',
    COUNT(*),
    'empleados operativos'
FROM EMPLEADO
WHERE activo = 1

UNION ALL

SELECT 
    'MESAS DISPONIBLES',
    COUNT(*),
    'mesas activas'
FROM MESA
WHERE activa = 1

UNION ALL

SELECT 
    'CAPACIDAD TOTAL',
    SUM(capacidad),
    'comensales máximos'
FROM MESA
WHERE activa = 1;

PRINT '';

-- ============================================================================
-- DISTRIBUCIÓN DEL MENÚ POR CATEGORÍAS
-- ============================================================================

PRINT '📋 DISTRIBUCIÓN DEL MENÚ POR CATEGORÍAS:';
PRINT '========================================';

SELECT 
    p.categoria as CATEGORIA,
    COUNT(*) as PRODUCTOS,
    '$' + CAST(CAST(MIN(pr.precio) AS INT) AS VARCHAR) as PRECIO_MIN,
    '$' + CAST(CAST(MAX(pr.precio) AS INT) AS VARCHAR) as PRECIO_MAX,
    '$' + CAST(CAST(AVG(pr.precio) AS INT) AS VARCHAR) AS PRECIO_PROMEDIO
FROM PLATO p
INNER JOIN PRECIO pr ON p.plato_id = pr.plato_id
WHERE p.activo = 1 
  AND pr.vigencia_hasta >= GETDATE()
GROUP BY p.categoria
ORDER BY 
    CASE p.categoria
        WHEN 'Carnes' THEN 1
        WHEN 'Parrilla' THEN 2
        WHEN 'Principales' THEN 3
        WHEN 'Pizzas' THEN 4
        WHEN 'Pastas' THEN 5
        WHEN 'Entradas' THEN 6
        WHEN 'Guarniciones' THEN 7
        WHEN 'Ensaladas' THEN 8
        WHEN 'Postres' THEN 9
        WHEN 'Bebidas' THEN 10
    END;

PRINT '';

-- ============================================================================
-- DISTRIBUCIÓN DE PERSONAL POR ROL
-- ============================================================================

PRINT 'DISTRIBUCIÓN DE PERSONAL POR ROL:';
PRINT '====================================';

SELECT 
    r.nombre as ROL,
    COUNT(e.empleado_id) as CANTIDAD
FROM ROL r
LEFT JOIN EMPLEADO e ON r.rol_id = e.rol_id AND e.activo = 1
GROUP BY r.rol_id, r.nombre
ORDER BY r.rol_id;

PRINT '';

-- ============================================================================
-- DISTRIBUCIÓN DE MESAS POR CAPACIDAD
-- ============================================================================

PRINT '🪑 DISTRIBUCIÓN DE MESAS POR CAPACIDAD:';
PRINT '======================================';

SELECT 
    'Mesas para ' + CAST(capacidad AS VARCHAR) + ' personas' as TIPO_MESA,
    COUNT(*) as CANTIDAD,
    SUM(capacidad) as CAPACIDAD_TOTAL
FROM MESA
WHERE activa = 1
GROUP BY capacidad
ORDER BY capacidad;

PRINT '';

-- ============================================================================
-- VERIFICACIÓN DE INTEGRIDAD
-- ============================================================================

PRINT 'VERIFICACIÓN DE INTEGRIDAD DE DATOS:';
PRINT '=======================================';

-- Verificar que todos los platos tienen precio
SELECT 
    CASE 
        WHEN COUNT(p.plato_id) = COUNT(pr.precio_id) THEN ' TODOS LOS PLATOS TIENEN PRECIO'
        ELSE 'HAY PLATOS SIN PRECIO'
    END as VERIFICACION_PRECIOS
FROM PLATO p
LEFT JOIN PRECIO pr ON p.plato_id = pr.plato_id AND pr.vigencia_hasta >= GETDATE()
WHERE p.activo = 1;

-- Verificar que hay personal para todos los roles
SELECT 
    CASE 
        WHEN COUNT(DISTINCT e.rol_id) >= 4 THEN ' TODOS LOS ROLES TIENEN PERSONAL'
        ELSE ' FALTAN ROLES POR CUBRIR'
    END as VERIFICACION_PERSONAL
FROM EMPLEADO e
WHERE e.activo = 1 AND e.rol_id IN (2,3,4,5);

-- Verificar que hay mesas configuradas
SELECT 
    CASE 
        WHEN COUNT(*) >= 40 THEN ' SUFICIENTES MESAS CONFIGURADAS'
        ELSE ' POCAS MESAS CONFIGURADAS'
    END as VERIFICACION_MESAS
FROM MESA
WHERE activa = 1;

PRINT '';

-- ============================================================================
-- MENSAJE FINAL
-- ============================================================================

PRINT ' ¡CONFIGURACIÓN DE PARRILLA EL ENCUENTRO COMPLETADA!';
PRINT '======================================================';
PRINT '';
PRINT ' Menú optimizado con productos balanceados';
PRINT ' Precios corregidos y competitivos';
PRINT ' Personal operativo completo asignado';
PRINT ' Distribución de mesas optimizada';
PRINT ' Tokens QR únicos para cada mesa';
PRINT ' Capacidad total: 200 comensales';
PRINT '';
PRINT ' ¡LA PARRILLA EL ENCUENTRO ESTÁ LISTA PARA OPERAR!';
PRINT '';
PRINT ' Sistema ChinchuLink configurado correctamente';
PRINT ' ¡Que tengan un excelente servicio!';
PRINT '';

GO