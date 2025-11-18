-- ============================================================================
-- PARTE 7: CARGA DE STOCK REALISTA
-- Script de inicialización Parrilla El Encuentro - Stock Control
-- ============================================================================

USE ChinchuLink;
GO

SET QUOTED_IDENTIFIER ON;
SET NOCOUNT ON;

PRINT '📦 PARTE 7: CARGA DE STOCK REALISTA PARRILLA EL ENCUENTRO';
PRINT '==========================================================';

BEGIN TRANSACTION TRX_STOCK;

PRINT 'Cargando stock inicial realista para parrilla El Encuentro...';

-- ============================================================================
-- STOCK REALISTA POR CATEGORÍAS
-- ============================================================================

-- 🥩 CARNES Y PARRILLA (Stock medio-alto, productos estrella)
PRINT 'Cargando stock de CARNES Y PARRILLA...';

INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo) VALUES
-- Carnes principales
(1,  25, 5),   -- Bife de Chorizo (producto estrella)
(2,  20, 4),   -- Asado de Tira (muy demandado)
(3,  18, 3),   -- Pollo Grillado (alternativa popular)

-- Especialidades de parrilla
(9,  8,  2),   -- Parrillada Completa (2 pers) - limitado por preparación
(10, 22, 4),   -- Bife Angosto 300g (corte premium)
(11, 15, 3),   -- Vacío a la Parrilla (corte tradicional)
(12, 12, 3),   -- Entraña Jugosa (corte especial)
(13, 30, 6),   -- Chorizo Colorado (fácil reposición)
(14, 25, 5);   -- Morcilla Criolla (acompañamiento clásico)

-- 🍕 PIZZAS (Stock alto, masa preparada diaria)
PRINT 'Cargando stock de PIZZAS...';

INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo) VALUES
(17, 35, 8),   -- Pizza Mozzarella (la más pedida)
(18, 30, 6),   -- Pizza Napolitana (clásica)
(19, 25, 5),   -- Pizza Calabresa (popular)
(20, 20, 4);   -- Pizza Fugazzeta (especialidad)

-- 🍝 PASTAS (Stock medio, preparación rápida)
PRINT 'Cargando stock de PASTAS...';

INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo) VALUES
(21, 28, 6),   -- Ñoquis de Papa (popular los 29)
(22, 25, 5),   -- Ravioles de Ricota (clásico)
(23, 30, 7),   -- Tallarines con Tuco (básico)
(24, 15, 3);   -- Canelones de Verdura (elaborado)

-- 🥗 ENSALADAS Y ENTRADAS (Stock medio, ingredientes frescos)
PRINT 'Cargando stock de ENSALADAS Y ENTRADAS...';

INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo) VALUES
-- Ensaladas (dependen de verduras frescas)
(4,  20, 4),   -- Ensalada Mixta (básica)
(33, 15, 3),   -- Ensalada César (elaborada)

-- Entradas (preparaciones especiales)
(25, 50, 10),  -- Empanadas Criollas (6u) - se preparan en lotes
(26, 12, 2),   -- Tabla de Fiambres (depende de compras)
(27, 18, 4),   -- Provoleta a la Parrilla (queso especial)
(28, 8,  2);   -- Matambre a la Pizza (preparación compleja)

-- 🥔 GUARNICIONES (Stock alto, acompañamientos populares)
PRINT 'Cargando stock de GUARNICIONES...';

INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo) VALUES
(29, 40, 8),   -- Papas Fritas Caseras (muy demandadas)
(30, 25, 5),   -- Papas Españolas (elaboradas)
(31, 20, 4),   -- Puré de Calabaza (casero)
(32, 18, 4);   -- Ensalada Rusa (preparación diaria)

-- 🍖 PRINCIPALES (Stock medio)
PRINT 'Cargando stock de PLATOS PRINCIPALES...';

INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo) VALUES
(15, 20, 4),   -- Milanesa Napolitana (popular)
(16, 18, 3);   -- Milanesa de Pollo (alternativa)

-- 🍰 POSTRES (Stock bajo-medio, preparaciones especiales)
PRINT 'Cargando stock de POSTRES...';

INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo) VALUES
(34, 15, 3),   -- Flan con Dulce de Leche (casero)
(35, 12, 2),   -- Panqueque con DDL (elaborado)
(36, 20, 4),   -- Helado Artesanal (proveedor local)
(37, 10, 2),   -- Tiramisú (preparación compleja)
(38, 8,  1),   -- Volcán de Chocolate (elaborado)
(39, 12, 2);   -- Mousse de Maracuyá (preparación especial)

-- 🥤 BEBIDAS (Stock alto, rotación rápida)
PRINT 'Cargando stock de BEBIDAS...';

INSERT INTO STOCK_SIMULADO (plato_id, stock_disponible, stock_minimo) VALUES
-- Bebidas sin alcohol (alta rotación)
(40, 60, 12),  -- Agua Mineral 500ml (básico)
(41, 45, 10),  -- Coca Cola 600ml (popular)
(42, 25, 5),   -- Jugo de Naranja Natural (fresco)
(43, 35, 8),   -- Café Cortado (demanda constante)
(44, 30, 6),   -- Café con Leche (desayunos/meriendas)

-- Bebidas alcohólicas (stock controlado)
(45, 24, 4),   -- Cerveza Stella Artois (premium)
(46, 12, 2),   -- Vino Tinto Catena Zapata (premium)
(47, 8,  1),   -- Vino Blanco Rutini (ocasional)
(48, 15, 3),   -- Fernet Branca (tradicional)
(49, 10, 2);   -- Aperol Spritz (tendencia)

-- ============================================================================
-- VERIFICACIÓN DEL STOCK CARGADO
-- ============================================================================

PRINT '';
PRINT 'VERIFICACIÓN DE STOCK CARGADO:';
PRINT '==============================';

-- Resumen por categoría
SELECT 
    p.categoria,
    COUNT(*) as PRODUCTOS,
    SUM(s.stock_disponible) as STOCK_TOTAL,
    AVG(s.stock_disponible) as STOCK_PROMEDIO,
    MIN(s.stock_disponible) as STOCK_MINIMO_CAT,
    MAX(s.stock_disponible) as STOCK_MAXIMO_CAT
FROM STOCK_SIMULADO s
INNER JOIN PLATO p ON s.plato_id = p.plato_id
GROUP BY p.categoria
ORDER BY STOCK_TOTAL DESC;

-- Total general
SELECT 
    COUNT(*) as TOTAL_PRODUCTOS_CON_STOCK,
    SUM(stock_disponible) as STOCK_TOTAL_GENERAL,
    AVG(CAST(stock_disponible AS FLOAT)) as STOCK_PROMEDIO_GENERAL
FROM STOCK_SIMULADO;

PRINT '';
PRINT '✅ Stock realista cargado exitosamente para Parrilla El Encuentro';
PRINT '📊 Criterios aplicados:';
PRINT '   • Carnes y Parrilla: Stock medio-alto (8-30 unidades)';
PRINT '   • Bebidas: Stock alto por rotación (8-60 unidades)';
PRINT '   • Pastas y Pizzas: Stock medio-alto por demanda (15-35 unidades)';
PRINT '   • Postres: Stock bajo por elaboración (8-20 unidades)';
PRINT '   • Entradas: Stock variable según complejidad (8-50 unidades)';
PRINT '   • Guarniciones: Stock alto por acompañamiento (18-40 unidades)';

COMMIT TRANSACTION TRX_STOCK;

PRINT '';
PRINT '🎯 PARRILLA EL ENCUENTRO - STOCK OPERATIVO LISTO';
PRINT '================================================';

GO