-- ============================================================================
-- PARTE 5: CONFIGURACIÓN DE MESAS
-- Script de inicialización Parrilla El Encuentro - Mesas
-- ============================================================================

USE ChinchuLink;
GO

PRINT 'PARTE 5: CONFIGURANDO MESAS';
PRINT '==============================';

BEGIN TRANSACTION TRX_MESAS;

SET IDENTITY_INSERT MESA ON;

PRINT 'Insertando configuración de mesas...';

-- MESAS PARA 4 PERSONAS (20 mesas) - Sector Principal
INSERT INTO MESA (mesa_id, numero, capacidad, qr_token, sucursal_id, activa) VALUES
(1, 1, 4, 'QR_PE_M001_20251113', 1, 1), (2, 2, 4, 'QR_PE_M002_20251113', 1, 1),
(3, 3, 4, 'QR_PE_M003_20251113', 1, 1), (4, 4, 4, 'QR_PE_M004_20251113', 1, 1),
(5, 5, 4, 'QR_PE_M005_20251113', 1, 1), (6, 6, 4, 'QR_PE_M006_20251113', 1, 1),
(7, 7, 4, 'QR_PE_M007_20251113', 1, 1), (8, 8, 4, 'QR_PE_M008_20251113', 1, 1),
(9, 9, 4, 'QR_PE_M009_20251113', 1, 1), (10, 10, 4, 'QR_PE_M010_20251113', 1, 1),
(11, 11, 4, 'QR_PE_M011_20251113', 1, 1), (12, 12, 4, 'QR_PE_M012_20251113', 1, 1),
(13, 13, 4, 'QR_PE_M013_20251113', 1, 1), (14, 14, 4, 'QR_PE_M014_20251113', 1, 1),
(15, 15, 4, 'QR_PE_M015_20251113', 1, 1), (16, 16, 4, 'QR_PE_M016_20251113', 1, 1),
(17, 17, 4, 'QR_PE_M017_20251113', 1, 1), (18, 18, 4, 'QR_PE_M018_20251113', 1, 1),
(19, 19, 4, 'QR_PE_M019_20251113', 1, 1), (20, 20, 4, 'QR_PE_M020_20251113', 1, 1);

-- MESAS PARA 6 PERSONAS (10 mesas) - Familias
INSERT INTO MESA (mesa_id, numero, capacidad, qr_token, sucursal_id, activa) VALUES
(21, 21, 6, 'QR_PE_M021_20251113', 1, 1), (22, 22, 6, 'QR_PE_M022_20251113', 1, 1),
(23, 23, 6, 'QR_PE_M023_20251113', 1, 1), (24, 24, 6, 'QR_PE_M024_20251113', 1, 1),
(25, 25, 6, 'QR_PE_M025_20251113', 1, 1), (26, 26, 6, 'QR_PE_M026_20251113', 1, 1),
(27, 27, 6, 'QR_PE_M027_20251113', 1, 1), (28, 28, 6, 'QR_PE_M028_20251113', 1, 1),
(29, 29, 6, 'QR_PE_M029_20251113', 1, 1), (30, 30, 6, 'QR_PE_M030_20251113', 1, 1);

-- MESAS PARA 8 PERSONAS (5 mesas) - Grupos grandes  
INSERT INTO MESA (mesa_id, numero, capacidad, qr_token, sucursal_id, activa) VALUES
(31, 31, 8, 'QR_PE_M031_20251113', 1, 1), (32, 32, 8, 'QR_PE_M032_20251113', 1, 1),
(33, 33, 8, 'QR_PE_M033_20251113', 1, 1), (34, 34, 8, 'QR_PE_M034_20251113', 1, 1),
(35, 35, 8, 'QR_PE_M035_20251113', 1, 1);

-- MESAS PARA 2 PERSONAS (10 mesas) - Barra y parejas
INSERT INTO MESA (mesa_id, numero, capacidad, qr_token, sucursal_id, activa) VALUES
(36, 36, 2, 'QR_PE_M036_20251113', 1, 1), (37, 37, 2, 'QR_PE_M037_20251113', 1, 1),
(38, 38, 2, 'QR_PE_M038_20251113', 1, 1), (39, 39, 2, 'QR_PE_M039_20251113', 1, 1),
(40, 40, 2, 'QR_PE_M040_20251113', 1, 1), (41, 41, 2, 'QR_PE_M041_20251113', 1, 1),
(42, 42, 2, 'QR_PE_M042_20251113', 1, 1), (43, 43, 2, 'QR_PE_M043_20251113', 1, 1),
(44, 44, 2, 'QR_PE_M044_20251113', 1, 1), (45, 45, 2, 'QR_PE_M045_20251113', 1, 1);

SET IDENTITY_INSERT MESA OFF;

-- Verificar distribución de mesas
SELECT 
    'Mesas para ' + CAST(capacidad AS VARCHAR) + ' personas' as TIPO_MESA,
    COUNT(*) as CANTIDAD,
    SUM(capacidad) as CAPACIDAD_TOTAL
FROM MESA
WHERE activa = 1
GROUP BY capacidad
ORDER BY capacidad;

SELECT 'CAPACIDAD TOTAL RESTAURANT' as RESUMEN, SUM(capacidad) as TOTAL_COMENSALES FROM MESA WHERE activa = 1;

COMMIT TRANSACTION TRX_MESAS;

PRINT 'MESAS CONFIGURADAS - 45 mesas activas (200 comensales)';
PRINT '';

GO