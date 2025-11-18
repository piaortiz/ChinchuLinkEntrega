-- ============================================================================
-- PARTE 3: PRECIOS ACTUALIZADOS
-- Script de inicialización Parrilla El Encuentro - Precios
-- ============================================================================

USE ChinchuLink;
GO

PRINT 'PARTE 3: CONFIGURANDO PRECIOS';
PRINT '================================';

BEGIN TRANSACTION TRX_PRECIOS;

SET IDENTITY_INSERT PRECIO ON;

PRINT 'Insertando precios actualizados...';

-- CARNES Y PARRILLA
INSERT INTO PRECIO (precio_id, plato_id, precio, vigencia_desde, vigencia_hasta) VALUES
(1, 1, 12500.00, '2025-11-01', '2025-12-31'),    -- Bife de Chorizo
(2, 2, 11800.00, '2025-11-01', '2025-12-31'),    -- Asado de Tira  
(3, 3, 8900.00, '2025-11-01', '2025-12-31'),     -- Pollo Grillado
(9, 9, 18500.00, '2025-11-01', '2025-12-31'),    -- Parrillada Completa (CORREGIDO)
(10, 10, 13800.00, '2025-11-01', '2025-12-31'),  -- Bife Angosto 300g
(11, 11, 15200.00, '2025-11-01', '2025-12-31'),  -- Vacío a la Parrilla
(12, 12, 14500.00, '2025-11-01', '2025-12-31'),  -- Entraña Jugosa
(13, 13, 7800.00, '2025-11-01', '2025-12-31'),   -- Chorizo Colorado
(14, 14, 6500.00, '2025-11-01', '2025-12-31'),   -- Morcilla Criolla
(15, 15, 9800.00, '2025-11-01', '2025-12-31'),   -- Milanesa Napolitana
(16, 16, 8900.00, '2025-11-01', '2025-12-31');   -- Milanesa de Pollo

-- PIZZAS Y PASTAS  
INSERT INTO PRECIO (precio_id, plato_id, precio, vigencia_desde, vigencia_hasta) VALUES
(17, 17, 7200.00, '2025-11-01', '2025-12-31'),   -- Pizza Mozzarella
(18, 18, 8500.00, '2025-11-01', '2025-12-31'),   -- Pizza Napolitana
(19, 19, 8800.00, '2025-11-01', '2025-12-31'),   -- Pizza Calabresa
(20, 20, 9500.00, '2025-11-01', '2025-12-31'),   -- Pizza Fugazzeta (CORREGIDO)
(21, 21, 6800.00, '2025-11-01', '2025-12-31'),   -- Ñoquis de Papa
(22, 22, 7500.00, '2025-11-01', '2025-12-31'),   -- Ravioles de Ricota
(23, 23, 6200.00, '2025-11-01', '2025-12-31'),   -- Tallarines con Tuco
(24, 24, 8200.00, '2025-11-01', '2025-12-31');   -- Canelones de Verdura

-- ENTRADAS Y GUARNICIONES
INSERT INTO PRECIO (precio_id, plato_id, precio, vigencia_desde, vigencia_hasta) VALUES
(25, 25, 5800.00, '2025-11-01', '2025-12-31'),   -- Empanadas Criollas
(26, 26, 12500.00, '2025-11-01', '2025-12-31'),  -- Tabla de Fiambres
(27, 27, 4500.00, '2025-11-01', '2025-12-31'),   -- Provoleta a la Parrilla
(28, 28, 8900.00, '2025-11-01', '2025-12-31'),   -- Matambre a la Pizza
(29, 29, 3800.00, '2025-11-01', '2025-12-31'),   -- Papas Fritas Caseras
(30, 30, 4200.00, '2025-11-01', '2025-12-31'),   -- Papas Españolas
(31, 31, 3500.00, '2025-11-01', '2025-12-31'),   -- Puré de Calabaza
(32, 32, 3800.00, '2025-11-01', '2025-12-31'),   -- Ensalada Rusa
(4, 4, 4200.00, '2025-11-01', '2025-12-31'),     -- Ensalada Mixta
(33, 33, 4800.00, '2025-11-01', '2025-12-31');   -- Ensalada César

-- POSTRES
INSERT INTO PRECIO (precio_id, plato_id, precio, vigencia_desde, vigencia_hasta) VALUES
(34, 34, 3200.00, '2025-11-01', '2025-12-31'),   -- Flan con DDL
(35, 35, 3800.00, '2025-11-01', '2025-12-31'),   -- Panqueque con DDL
(36, 36, 2800.00, '2025-11-01', '2025-12-31'),   -- Helado Artesanal
(37, 37, 4500.00, '2025-11-01', '2025-12-31'),   -- Tiramisú
(38, 38, 4200.00, '2025-11-01', '2025-12-31'),   -- Volcán de Chocolate
(39, 39, 3900.00, '2025-11-01', '2025-12-31');   -- Mousse de Maracuyá

-- BEBIDAS
INSERT INTO PRECIO (precio_id, plato_id, precio, vigencia_desde, vigencia_hasta) VALUES
(40, 40, 950.00, '2025-11-01', '2025-12-31'),    -- Agua Mineral 500ml
(41, 41, 1450.00, '2025-11-01', '2025-12-31'),   -- Coca Cola 600ml
(42, 42, 2200.00, '2025-11-01', '2025-12-31'),   -- Jugo de Naranja Natural
(43, 43, 1200.00, '2025-11-01', '2025-12-31'),   -- Café Cortado
(44, 44, 1500.00, '2025-11-01', '2025-12-31'),   -- Café con Leche
(45, 45, 2800.00, '2025-11-01', '2025-12-31'),   -- Cerveza Stella Artois
(46, 46, 9500.00, '2025-11-01', '2025-12-31'),   -- Vino Tinto Catena Zapata
(47, 47, 7800.00, '2025-11-01', '2025-12-31'),   -- Vino Blanco Rutini
(48, 48, 4500.00, '2025-11-01', '2025-12-31'),   -- Fernet Branca
(49, 49, 3800.00, '2025-11-01', '2025-12-31');   -- Aperol Spritz

SET IDENTITY_INSERT PRECIO OFF;

-- Verificar precios por categoría
SELECT 
    p.categoria,
    COUNT(pr.precio_id) as PRECIOS_CONFIGURADOS,
    MIN(pr.precio) as PRECIO_MIN,
    MAX(pr.precio) as PRECIO_MAX,
    CAST(AVG(pr.precio) AS INT) AS PRECIO_PROMEDIO
FROM PLATO p
INNER JOIN PRECIO pr ON p.plato_id = pr.plato_id
WHERE p.activo = 1
GROUP BY p.categoria
ORDER BY p.categoria;

SELECT 'TOTAL PRECIOS' as RESUMEN, COUNT(*) as TOTAL FROM PRECIO;

COMMIT TRANSACTION TRX_PRECIOS;

PRINT 'PRECIOS CONFIGURADOS - 45 precios cargados con correcciones';
PRINT '';

GO