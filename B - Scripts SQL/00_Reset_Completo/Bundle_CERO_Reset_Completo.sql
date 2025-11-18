-- =============================================
-- BUNDLE CERO - RESET COMPLETO CHINCHULINK
-- Sistema de Reset Total de Base de Datos
-- Fecha: 15 de noviembre de 2025
-- Propósito: Dejar el sistema en estado CERO completamente limpio
-- PRECAUCIÓN: Este script ELIMINA TODO sin posibilidad de recuperación
-- =============================================

-- IMPORTANTE: Ejecutar este script conectado a la base 'master'
-- NO ejecutar desde la base ChinchuLink ya que será eliminada

USE master;
GO

PRINT 'INICIANDO BUNDLE CERO - RESET COMPLETO CHINCHULINK'
PRINT '===================================================='
PRINT 'ADVERTENCIA: Este script eliminara COMPLETAMENTE la base de datos'
PRINT 'Se perderan TODOS los datos sin posibilidad de recuperacion'
PRINT 'Asegurese de tener backups si es necesario'
PRINT ''

-- =============================================
-- VERIFICACIÓN INICIAL
-- =============================================
PRINT 'Verificando estado actual del sistema...'

-- Verificar si existe ChinchuLink (cualquier variante)
DECLARE @bases_encontradas TABLE (nombre NVARCHAR(128))
INSERT INTO @bases_encontradas
SELECT name FROM sys.databases 
WHERE name IN ('ChinchuLink', 'Chinchulink', 'chinchulink', 'CHINCHULINK')

IF EXISTS (SELECT 1 FROM @bases_encontradas)
BEGIN
    PRINT 'Bases de datos encontradas para eliminacion:'
    SELECT '   ' + nombre as 'Base de Datos Detectada' FROM @bases_encontradas
    PRINT ''
END
ELSE
BEGIN
    PRINT 'No se encontraron bases de datos ChinchuLink existentes'
    PRINT 'El sistema ya esta en estado CERO'
    PRINT ''
    PRINT 'BUNDLE CERO COMPLETADO - Sistema ya limpio'
    PRINT '=============================================='
    GOTO FIN_SCRIPT
END

-- =============================================
-- ELIMINACIÓN FORZADA DE TODAS LAS VARIANTES
-- =============================================
PRINT 'FASE 1: Eliminacion forzada de bases de datos'
PRINT '=============================================='

-- ChinchuLink (nombre correcto)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ChinchuLink')
BEGIN
    PRINT 'Eliminando base de datos: ChinchuLink'
    
    -- Forzar desconexión de todos los usuarios
    ALTER DATABASE [ChinchuLink] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Eliminar base de datos
    DROP DATABASE [ChinchuLink];
    
    PRINT 'ChinchuLink eliminada exitosamente'
END

-- Chinchulink (variante con minúscula)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Chinchulink')
BEGIN
    PRINT 'Eliminando base de datos: Chinchulink'
    
    -- Forzar desconexión de todos los usuarios
    ALTER DATABASE [Chinchulink] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Eliminar base de datos
    DROP DATABASE [Chinchulink];
    
    PRINT 'Chinchulink eliminada exitosamente'
END

-- chinchulink (todo en minúsculas)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'chinchulink')
BEGIN
    PRINT 'Eliminando base de datos: chinchulink'
    
    -- Forzar desconexión de todos los usuarios
    ALTER DATABASE [chinchulink] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Eliminar base de datos
    DROP DATABASE [chinchulink];
    
    PRINT 'chinchulink eliminada exitosamente'
END

-- CHINCHULINK (todo en mayúsculas)
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'CHINCHULINK')
BEGIN
    PRINT 'Eliminando base de datos: CHINCHULINK'
    
    -- Forzar desconexión de todos los usuarios
    ALTER DATABASE [CHINCHULINK] SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    
    -- Eliminar base de datos
    DROP DATABASE [CHINCHULINK];
    
    PRINT 'CHINCHULINK eliminada exitosamente'
END

PRINT ''

-- =============================================
-- VERIFICACIÓN FINAL DE LIMPIEZA
-- =============================================
PRINT 'FASE 2: Verificacion de limpieza completa'
PRINT '=========================================='

-- Verificar que no quedan bases ChinchuLink
IF NOT EXISTS (SELECT name FROM sys.databases 
               WHERE name IN ('ChinchuLink', 'Chinchulink', 'chinchulink', 'CHINCHULINK'))
BEGIN
    PRINT 'Verificacion exitosa: No hay bases ChinchuLink restantes'
END
ELSE
BEGIN
    PRINT 'ERROR: Aun existen bases ChinchuLink sin eliminar'
    SELECT 'ERROR: ' + name as 'Base Restante' 
    FROM sys.databases 
    WHERE name IN ('ChinchuLink', 'Chinchulink', 'chinchulink', 'CHINCHULINK')
END

-- =============================================
-- LIMPIEZA DE CONEXIONES RESIDUALES
-- =============================================
PRINT ''
PRINT 'FASE 3: Limpieza de conexiones residuales'
PRINT '=========================================='

-- Obtener información de conexiones activas relacionadas con ChinchuLink
DECLARE @conexiones_activas INT = 0
SELECT @conexiones_activas = COUNT(*)
FROM sys.dm_exec_sessions s
INNER JOIN sys.dm_exec_connections c ON s.session_id = c.session_id
WHERE s.database_id IN (
    SELECT database_id FROM sys.databases 
    WHERE name IN ('ChinchuLink', 'Chinchulink', 'chinchulink', 'CHINCHULINK')
)

IF @conexiones_activas = 0
BEGIN
    PRINT 'No hay conexiones residuales detectadas'
END
ELSE
BEGIN
    PRINT 'Se detectaron ' + CAST(@conexiones_activas AS VARCHAR) + ' conexiones residuales'
    PRINT 'Las conexiones fueron cerradas durante la eliminacion de bases'
END

-- =============================================
-- REPORTE FINAL DE ESTADO CERO
-- =============================================
PRINT ''
PRINT 'REPORTE FINAL - ESTADO CERO ALCANZADO'
PRINT '======================================='

-- Mostrar bases de datos actuales (sin ChinchuLink)
PRINT 'Bases de datos actualmente en el servidor:'
SELECT '   ' + name as 'Base de Datos Disponible'
FROM sys.databases 
WHERE name NOT IN ('master', 'tempdb', 'model', 'msdb')
ORDER BY name

-- Verificar memoria libre
DECLARE @memoria_libre_mb BIGINT
SELECT @memoria_libre_mb = (available_physical_memory_kb / 1024)
FROM sys.dm_os_sys_memory

PRINT ''
PRINT 'Estado del sistema tras limpieza:'
PRINT '   Memoria disponible: ' + CAST(@memoria_libre_mb AS VARCHAR) + ' MB'
PRINT '   Estado de conexion: Estable'
PRINT '   Base master: Operativa'
PRINT ''

FIN_SCRIPT:

-- =============================================
-- MENSAJE DE FINALIZACIÓN
-- =============================================
PRINT 'BUNDLE CERO COMPLETADO EXITOSAMENTE'
PRINT '====================================='
PRINT ''
PRINT 'ESTADO FINAL:'
PRINT '   Todas las bases ChinchuLink eliminadas'
PRINT '   Conexiones residuales cerradas'
PRINT '   Sistema en estado CERO completo'
PRINT '   Listo para instalacion limpia'
PRINT ''
PRINT 'PROXIMOS PASOS RECOMENDADOS:'
PRINT '   1. Ejecutar Bundle_A1_BaseDatos_Estructura.sql'
PRINT '   2. Ejecutar Bundle_A2_Indices_Datos.sql'
PRINT '   3. Cargar datos de la parrilla (PARTE_*.sql)'
PRINT '   4. Aplicar reportes (Bundle_R4_CONSOLIDADO.sql)'
PRINT ''
PRINT 'Sistema ChinchuLink listo para despliegue desde cero!'
PRINT ''

GO

-- =============================================
-- INFORMACIÓN ADICIONAL
-- =============================================
PRINT 'INFORMACION TECNICA:'
PRINT '   Fecha de reset: ' + CONVERT(VARCHAR, GETDATE(), 120)
PRINT '   Servidor: ' + @@SERVERNAME
PRINT '   Version SQL: ' + @@VERSION
PRINT '   Usuario: ' + SYSTEM_USER
PRINT ''
PRINT 'Para soporte tecnico consultar documentacion en:'
PRINT '   /Entregables/A - Documentacion Tecnica/'
PRINT ''

GO