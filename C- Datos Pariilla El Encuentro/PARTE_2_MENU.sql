-- ============================================================================
-- PARTE 2: MENU COMPLETO
-- Script de inicializacion Parrilla El Encuentro - Productos
-- ============================================================================

USE ChinchuLink;
GO

PRINT 'PARTE 2: CARGANDO MENU COMPLETO';
PRINT '==================================';

BEGIN TRANSACTION TRX_MENU;

SET IDENTITY_INSERT PLATO ON;

PRINT 'Insertando productos del menu...';

-- CARNES Y PARRILLA (11 productos)
INSERT INTO PLATO (plato_id, nombre, categoria, activo) VALUES
(1, 'Bife de Chorizo', 'Carnes', 1),
(2, 'Asado de Tira', 'Carnes', 1),
(3, 'Pollo Grillado', 'Carnes', 1),
(9, 'Parrillada Completa (2 pers)', 'Parrilla', 1),
(10, 'Bife Angosto 300g', 'Parrilla', 1),
(11, 'Vacio a la Parrilla', 'Parrilla', 1),
(12, 'Entrana Jugosa', 'Parrilla', 1),
(13, 'Chorizo Colorado', 'Parrilla', 1),
(14, 'Morcilla Criolla', 'Parrilla', 1),
(15, 'Milanesa Napolitana', 'Principales', 1),
(16, 'Milanesa de Pollo', 'Principales', 1);

-- PIZZAS Y PASTAS (8 productos)
INSERT INTO PLATO (plato_id, nombre, categoria, activo) VALUES
(17, 'Pizza Mozzarella', 'Pizzas', 1),
(18, 'Pizza Napolitana', 'Pizzas', 1),
(19, 'Pizza Calabresa', 'Pizzas', 1),
(20, 'Pizza Fugazzeta', 'Pizzas', 1),
(21, 'Noquis de Papa', 'Pastas', 1),
(22, 'Ravioles de Ricota', 'Pastas', 1),
(23, 'Tallarines con Tuco', 'Pastas', 1),
(24, 'Canelones de Verdura', 'Pastas', 1);

-- ENTRADAS Y GUARNICIONES (10 productos)  
INSERT INTO PLATO (plato_id, nombre, categoria, activo) VALUES
(25, 'Empanadas Criollas (6u)', 'Entradas', 1),
(26, 'Tabla de Fiambres', 'Entradas', 1),
(27, 'Provoleta a la Parrilla', 'Entradas', 1),
(28, 'Matambre a la Pizza', 'Entradas', 1),
(29, 'Papas Fritas Caseras', 'Guarniciones', 1),
(30, 'Papas Espanolas', 'Guarniciones', 1),
(31, 'Pure de Calabaza', 'Guarniciones', 1),
(32, 'Ensalada Rusa', 'Guarniciones', 1),
(4, 'Ensalada Mixta', 'Ensaladas', 1),
(33, 'Ensalada Cesar', 'Ensaladas', 1);

-- POSTRES (6 productos)
INSERT INTO PLATO (plato_id, nombre, categoria, activo) VALUES
(34, 'Flan con Dulce de Leche', 'Postres', 1),
(35, 'Panqueque con DDL', 'Postres', 1),
(36, 'Helado Artesanal', 'Postres', 1),
(37, 'Tiramisu', 'Postres', 1),
(38, 'Volcan de Chocolate', 'Postres', 1),
(39, 'Mousse de Maracuya', 'Postres', 1);

-- BEBIDAS (10 productos)
INSERT INTO PLATO (plato_id, nombre, categoria, activo) VALUES
(40, 'Agua Mineral 500ml', 'Bebidas', 1),
(41, 'Coca Cola 600ml', 'Bebidas', 1),
(42, 'Jugo de Naranja Natural', 'Bebidas', 1),
(43, 'Cafe Cortado', 'Bebidas', 1),
(44, 'Cafe con Leche', 'Bebidas', 1),
(45, 'Cerveza Stella Artois', 'Bebidas', 1),
(46, 'Vino Tinto Catena Zapata', 'Bebidas', 1),
(47, 'Vino Blanco Rutini', 'Bebidas', 1),
(48, 'Fernet Branca', 'Bebidas', 1),
(49, 'Aperol Spritz', 'Bebidas', 1);

SET IDENTITY_INSERT PLATO OFF;

-- Verificar insercion
SELECT 
    categoria,
    COUNT(*) as PRODUCTOS_INSERTADOS
FROM PLATO
WHERE activo = 1
GROUP BY categoria
ORDER BY categoria;

SELECT 'TOTAL PRODUCTOS' as RESUMEN, COUNT(*) as TOTAL FROM PLATO WHERE activo = 1;

COMMIT TRANSACTION TRX_MENU;

PRINT 'MENU COMPLETO INSERTADO - 45 productos cargados';
PRINT '';

GO