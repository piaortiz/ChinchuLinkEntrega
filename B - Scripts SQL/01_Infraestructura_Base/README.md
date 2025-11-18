# INFRAESTRUCTURA BASE - ChinchuLink

**Orden de ejecución:** PASO 1  
**Dependencias:** Ninguna  

## CONTENIDO DE LA CARPETA

### **Bundle_A1_BaseDatos_Estructura.sql**
- **Propósito:** Crear estructura completa de base de datos
- **Tiempo estimado:** 2-3 minutos
- **Contenido:**
  - 17 Tablas principales
  - Relaciones y claves foráneas
  - Restricciones de integridad
  - Datos de referencia básicos

### **Bundle_A2_Indices_Datos.sql** 
- **Propósito:** Optimización de performance inicial
- **Tiempo estimado:** 1-2 minutos
- **Contenido:**
  - Índices de performance críticos
  - Datos de configuración inicial
  - Estados, canales y roles básicos

## ORDEN DE EJECUCIÓN

1. **PRIMERO:** Bundle_A1_BaseDatos_Estructura.sql
2. **SEGUNDO:** Bundle_A2_Indices_Datos.sql

## VALIDACIÓN

```sql
-- Verificar tablas creadas
SELECT COUNT(*) as TablesCreated 
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_TYPE = 'BASE TABLE'
-- Esperado: 17

-- Verificar índices
SELECT COUNT(*) as IndexesCreated
FROM sys.indexes 
WHERE name IS NOT NULL
-- Esperado: 25+
```

## PRERREQUISITOS

- Base de datos ChinchuLink creada
- Usuario con permisos db_owner o sysadmin
- SQL Server 2019 o superior