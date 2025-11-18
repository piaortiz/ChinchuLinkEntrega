-- ============================================================================
-- CARGA DE PEDIDOS HISTÓRICOS - SEPTIEMBRE Y OCTUBRE 2025
-- Script de carga de 4 pedidos usando sp_CrearPedido y sp_AgregarItemPedido
-- ============================================================================

USE ChinchuLink;
GO

SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;

PRINT '📋 CARGA DE PEDIDOS HISTÓRICOS - SEPTIEMBRE Y OCTUBRE 2025';
PRINT '===========================================================';
PRINT 'Usando stored procedures: sp_CrearPedido y sp_AgregarItemPedido';
PRINT '';

-- ============================================================================
-- PEDIDO 1 - SEPTIEMBRE 2025 (Pareja cenando - Mesa 2)
-- ============================================================================

PRINT '🍽️ PEDIDO 1 - 15 de Septiembre 2025 - Mesa 2';

DECLARE @pedido1_id INT, @mensaje1 NVARCHAR(500);

-- Crear pedido principal
EXEC sp_CrearPedido 
    @canal_id = 1,                      -- Mesa QR
    @mesa_id = 2,                       -- Mesa 2 (4 personas)
    @cant_comensales = 2,               -- Pareja
    @tomado_por_empleado_id = 4,        -- María López (mozo)
    @pedido_id = @pedido1_id OUTPUT,
    @mensaje = @mensaje1 OUTPUT;

PRINT @mensaje1;

-- Actualizar fecha del pedido a septiembre
UPDATE PEDIDO 
SET fecha_pedido = '2025-09-15 20:30:00',
    observaciones = 'Pareja aniversario - servicio excelente'
WHERE pedido_id = @pedido1_id;

-- Agregar items al pedido 1
DECLARE @detalle1_1 INT, @detalle1_2 INT, @detalle1_3 INT, @detalle1_4 INT, @detalle1_5 INT;
DECLARE @msg1_1 NVARCHAR(500), @msg1_2 NVARCHAR(500), @msg1_3 NVARCHAR(500), @msg1_4 NVARCHAR(500), @msg1_5 NVARCHAR(500);

-- Item 1: 2 Bife de Chorizo
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido1_id,
    @plato_id = 1,                      -- Bife de Chorizo
    @cantidad = 2,                      -- 2 bifes
    @detalle_id = @detalle1_1 OUTPUT,
    @mensaje = @msg1_1 OUTPUT;

-- Item 2: 1 Papas Fritas Caseras
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido1_id,
    @plato_id = 29,                     -- Papas Fritas Caseras
    @cantidad = 1,                      -- 1 porción
    @detalle_id = @detalle1_2 OUTPUT,
    @mensaje = @msg1_2 OUTPUT;

-- Item 3: 1 Vino Tinto Catena Zapata
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido1_id,
    @plato_id = 46,                     -- Vino Tinto Catena Zapata
    @cantidad = 1,                      -- 1 botella
    @detalle_id = @detalle1_3 OUTPUT,
    @mensaje = @msg1_3 OUTPUT;

-- Item 4: 2 Flan con Dulce de Leche
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido1_id,
    @plato_id = 34,                     -- Flan con Dulce de Leche
    @cantidad = 2,                      -- 2 postres
    @detalle_id = @detalle1_4 OUTPUT,
    @mensaje = @msg1_4 OUTPUT;

-- Item 5: 2 Café con Leche
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido1_id,
    @plato_id = 44,                     -- Café con Leche
    @cantidad = 2,                      -- 2 cafés
    @detalle_id = @detalle1_5 OUTPUT,
    @mensaje = @msg1_5 OUTPUT;

PRINT 'Pedido 1 completado - Mesa 2 - 15/Sep/2025';

-- ============================================================================
-- PEDIDO 2 - SEPTIEMBRE 2025 (Familia almorzando - Mesa 5)
-- ============================================================================

PRINT '';
PRINT '🍕 PEDIDO 2 - 22 de Septiembre 2025 - Mesa 5';

DECLARE @pedido2_id INT, @mensaje2 NVARCHAR(500);

-- Crear pedido principal
EXEC sp_CrearPedido 
    @canal_id = 1,                      -- Mesa QR
    @mesa_id = 5,                       -- Mesa 5 (4 personas)
    @cant_comensales = 4,               -- Familia de 4
    @tomado_por_empleado_id = 5,        -- Juan Martínez (mozo)
    @pedido_id = @pedido2_id OUTPUT,
    @mensaje = @mensaje2 OUTPUT;

PRINT @mensaje2;

-- Actualizar fecha del pedido a septiembre
UPDATE PEDIDO 
SET fecha_pedido = '2025-09-22 13:15:00',
    observaciones = 'Familia con niños - pedido rápido'
WHERE pedido_id = @pedido2_id;

-- Agregar items al pedido 2
DECLARE @detalle2_1 INT, @detalle2_2 INT, @detalle2_3 INT, @detalle2_4 INT, @detalle2_5 INT, @detalle2_6 INT;
DECLARE @msg2_1 NVARCHAR(500), @msg2_2 NVARCHAR(500), @msg2_3 NVARCHAR(500), @msg2_4 NVARCHAR(500), @msg2_5 NVARCHAR(500), @msg2_6 NVARCHAR(500);

-- Item 1: 2 Pizza Mozzarella
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido2_id,
    @plato_id = 17,                     -- Pizza Mozzarella
    @cantidad = 2,                      -- 2 pizzas
    @detalle_id = @detalle2_1 OUTPUT,
    @mensaje = @msg2_1 OUTPUT;

-- Item 2: 1 Pizza Napolitana
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido2_id,
    @plato_id = 18,                     -- Pizza Napolitana
    @cantidad = 1,                      -- 1 pizza
    @detalle_id = @detalle2_2 OUTPUT,
    @mensaje = @msg2_2 OUTPUT;

-- Item 3: 4 Coca Cola 600ml
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido2_id,
    @plato_id = 41,                     -- Coca Cola 600ml
    @cantidad = 4,                      -- 4 gaseosas
    @detalle_id = @detalle2_3 OUTPUT,
    @mensaje = @msg2_3 OUTPUT;

-- Item 4: 3 Helado Artesanal
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido2_id,
    @plato_id = 36,                     -- Helado Artesanal
    @cantidad = 3,                      -- 3 helados
    @detalle_id = @detalle2_4 OUTPUT,
    @mensaje = @msg2_4 OUTPUT;

-- Item 5: 1 Café Cortado
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido2_id,
    @plato_id = 43,                     -- Café Cortado
    @cantidad = 1,                      -- 1 café
    @detalle_id = @detalle2_5 OUTPUT,
    @mensaje = @msg2_5 OUTPUT;

-- Item 6: 1 Jugo de Naranja Natural
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido2_id,
    @plato_id = 42,                     -- Jugo de Naranja Natural
    @cantidad = 1,                      -- 1 jugo
    @detalle_id = @detalle2_6 OUTPUT,
    @mensaje = @msg2_6 OUTPUT;

PRINT 'Pedido 2 completado - Mesa 5 - 22/Sep/2025';

-- ============================================================================
-- PEDIDO 3 - OCTUBRE 2025 (Cena de negocios - Mesa 1)
-- ============================================================================

PRINT '';
PRINT '🥩 PEDIDO 3 - 8 de Octubre 2025 - Mesa 1';

DECLARE @pedido3_id INT, @mensaje3 NVARCHAR(500);

-- Crear pedido principal
EXEC sp_CrearPedido 
    @canal_id = 1,                      -- Mesa QR
    @mesa_id = 1,                       -- Mesa 1 (4 personas)
    @cant_comensales = 4,               -- Cena de negocios 4 personas
    @tomado_por_empleado_id = 4,        -- María López (mozo)
    @pedido_id = @pedido3_id OUTPUT,
    @mensaje = @mensaje3 OUTPUT;

PRINT @mensaje3;

-- Actualizar fecha del pedido a octubre
UPDATE PEDIDO 
SET fecha_pedido = '2025-10-08 21:45:00',
    observaciones = 'Cena de negocios - cliente importante'
WHERE pedido_id = @pedido3_id;

-- Agregar items al pedido 3
DECLARE @detalle3_1 INT, @detalle3_2 INT, @detalle3_3 INT, @detalle3_4 INT, @detalle3_5 INT, @detalle3_6 INT, @detalle3_7 INT;
DECLARE @msg3_1 NVARCHAR(500), @msg3_2 NVARCHAR(500), @msg3_3 NVARCHAR(500), @msg3_4 NVARCHAR(500), @msg3_5 NVARCHAR(500), @msg3_6 NVARCHAR(500), @msg3_7 NVARCHAR(500);

-- Item 1: 1 Parrillada Completa (2 pers)
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido3_id,
    @plato_id = 9,                      -- Parrillada Completa (2 pers)
    @cantidad = 1,                      -- 1 parrillada
    @detalle_id = @detalle3_1 OUTPUT,
    @mensaje = @msg3_1 OUTPUT;

-- Item 2: 2 Bife Angosto 300g
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido3_id,
    @plato_id = 10,                     -- Bife Angosto 300g
    @cantidad = 2,                      -- 2 bifes premium
    @detalle_id = @detalle3_2 OUTPUT,
    @mensaje = @msg3_2 OUTPUT;

-- Item 3: 1 Provoleta a la Parrilla
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido3_id,
    @plato_id = 27,                     -- Provoleta a la Parrilla
    @cantidad = 1,                      -- 1 entrada
    @detalle_id = @detalle3_3 OUTPUT,
    @mensaje = @msg3_3 OUTPUT;

-- Item 4: 2 Papas Españolas
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido3_id,
    @plato_id = 30,                     -- Papas Españolas
    @cantidad = 2,                      -- 2 acompañamientos
    @detalle_id = @detalle3_4 OUTPUT,
    @mensaje = @msg3_4 OUTPUT;

-- Item 5: 1 Vino Tinto Catena Zapata
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido3_id,
    @plato_id = 46,                     -- Vino Tinto Catena Zapata
    @cantidad = 1,                      -- 1 botella premium
    @detalle_id = @detalle3_5 OUTPUT,
    @mensaje = @msg3_5 OUTPUT;

-- Item 6: 2 Fernet Branca
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido3_id,
    @plato_id = 48,                     -- Fernet Branca
    @cantidad = 2,                      -- 2 digestivos
    @detalle_id = @detalle3_6 OUTPUT,
    @mensaje = @msg3_6 OUTPUT;

-- Item 7: 1 Tiramisú
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido3_id,
    @plato_id = 37,                     -- Tiramisú
    @cantidad = 1,                      -- 1 postre especial
    @detalle_id = @detalle3_7 OUTPUT,
    @mensaje = @msg3_7 OUTPUT;

PRINT 'Pedido 3 completado - Mesa 1 - 8/Oct/2025';

-- ============================================================================
-- PEDIDO 4 - OCTUBRE 2025 (Almuerzo ejecutivo - Mesa 3)
-- ============================================================================

PRINT '';
PRINT '🍝 PEDIDO 4 - 25 de Octubre 2025 - Mesa 3';

DECLARE @pedido4_id INT, @mensaje4 NVARCHAR(500);

-- Crear pedido principal
EXEC sp_CrearPedido 
    @canal_id = 1,                      -- Mesa QR
    @mesa_id = 3,                       -- Mesa 3 (4 personas)
    @cant_comensales = 2,               -- Almuerzo ejecutivo 2 personas
    @tomado_por_empleado_id = 5,        -- Juan Martínez (mozo)
    @pedido_id = @pedido4_id OUTPUT,
    @mensaje = @mensaje4 OUTPUT;

PRINT @mensaje4;

-- Actualizar fecha del pedido a octubre
UPDATE PEDIDO 
SET fecha_pedido = '2025-10-25 14:20:00',
    observaciones = 'Almuerzo ejecutivo - servicio rápido'
WHERE pedido_id = @pedido4_id;

-- Agregar items al pedido 4
DECLARE @detalle4_1 INT, @detalle4_2 INT, @detalle4_3 INT, @detalle4_4 INT, @detalle4_5 INT;
DECLARE @msg4_1 NVARCHAR(500), @msg4_2 NVARCHAR(500), @msg4_3 NVARCHAR(500), @msg4_4 NVARCHAR(500), @msg4_5 NVARCHAR(500);

-- Item 1: 2 Milanesa Napolitana
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido4_id,
    @plato_id = 15,                     -- Milanesa Napolitana
    @cantidad = 2,                      -- 2 milanesas
    @detalle_id = @detalle4_1 OUTPUT,
    @mensaje = @msg4_1 OUTPUT;

-- Item 2: 1 Ensalada Mixta
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido4_id,
    @plato_id = 4,                      -- Ensalada Mixta
    @cantidad = 1,                      -- 1 ensalada
    @detalle_id = @detalle4_2 OUTPUT,
    @mensaje = @msg4_2 OUTPUT;

-- Item 3: 2 Agua Mineral 500ml
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido4_id,
    @plato_id = 40,                     -- Agua Mineral 500ml
    @cantidad = 2,                      -- 2 aguas
    @detalle_id = @detalle4_3 OUTPUT,
    @mensaje = @msg4_3 OUTPUT;

-- Item 4: 2 Café Cortado
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido4_id,
    @plato_id = 43,                     -- Café Cortado
    @cantidad = 2,                      -- 2 cafés
    @detalle_id = @detalle4_4 OUTPUT,
    @mensaje = @msg4_4 OUTPUT;

-- Item 5: 1 Empanadas Criollas (6u)
EXEC sp_AgregarItemPedido
    @pedido_id = @pedido4_id,
    @plato_id = 25,                     -- Empanadas Criollas (6u)
    @cantidad = 1,                      -- 1 docena
    @detalle_id = @detalle4_5 OUTPUT,
    @mensaje = @msg4_5 OUTPUT;

PRINT 'Pedido 4 completado - Mesa 3 - 25/Oct/2025';

-- ============================================================================
-- VERIFICACIÓN DE CARGA EXITOSA
-- ============================================================================

PRINT '';
PRINT 'VERIFICACIÓN DE PEDIDOS CARGADOS:';
PRINT '==================================';

-- Resumen de pedidos por mes
SELECT 
    MONTH(fecha_pedido) as MES,
    CASE 
        WHEN MONTH(fecha_pedido) = 9 THEN 'SEPTIEMBRE'
        WHEN MONTH(fecha_pedido) = 10 THEN 'OCTUBRE'
        ELSE 'OTROS'
    END as MES_NOMBRE,
    COUNT(*) as TOTAL_PEDIDOS,
    SUM(total) as FACTURACION_TOTAL,
    AVG(total) as TICKET_PROMEDIO
FROM PEDIDO 
WHERE MONTH(fecha_pedido) IN (9, 10) 
  AND YEAR(fecha_pedido) = 2025
GROUP BY MONTH(fecha_pedido)
ORDER BY MES;

-- Detalle completo de los pedidos de septiembre y octubre
SELECT 
    p.pedido_id,
    'Mesa ' + CAST(m.numero AS VARCHAR(5)) as MESA,
    e.nombre as MOZO,
    CONVERT(VARCHAR(10), p.fecha_pedido, 103) as FECHA,
    FORMAT(p.fecha_pedido, 'HH:mm') as HORA,
    p.estado,
    '$' + FORMAT(p.total, 'N0') as TOTAL,
    LEFT(p.observaciones, 30) + '...' as OBSERVACIONES
FROM PEDIDO p
INNER JOIN MESA m ON p.mesa_id = m.mesa_id
INNER JOIN EMPLEADO e ON p.empleado_id = e.empleado_id
WHERE MONTH(p.fecha_pedido) IN (9, 10) 
  AND YEAR(p.fecha_pedido) = 2025
ORDER BY p.fecha_pedido;

-- Conteo de items por pedido
SELECT 
    p.pedido_id,
    'Mesa ' + CAST(m.numero AS VARCHAR(5)) as MESA,
    CONVERT(VARCHAR(10), p.fecha_pedido, 103) as FECHA,
    COUNT(dp.detalle_id) as ITEMS_DIFERENTES,
    SUM(dp.cantidad) as CANTIDAD_TOTAL
FROM PEDIDO p
INNER JOIN MESA m ON p.mesa_id = m.mesa_id
INNER JOIN DETALLE_PEDIDO dp ON p.pedido_id = dp.pedido_id
WHERE MONTH(p.fecha_pedido) IN (9, 10) 
  AND YEAR(p.fecha_pedido) = 2025
GROUP BY p.pedido_id, m.numero, p.fecha_pedido
ORDER BY p.fecha_pedido;

PRINT '';
PRINT '✅ 4 PEDIDOS HISTÓRICOS CARGADOS EXITOSAMENTE';
PRINT '==============================================';
PRINT '📅 SEPTIEMBRE 2025: 2 pedidos cargados';
PRINT '📅 OCTUBRE 2025: 2 pedidos cargados'; 
PRINT '';
PRINT '🎯 Datos listos para análisis de ventas históricas';
PRINT '🔧 Creados usando stored procedures sp_CrearPedido y sp_AgregarItemPedido';

GO