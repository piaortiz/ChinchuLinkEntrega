# GUÍA DE DESPLIEGUE INICIAL - SISTEMA CHINCHULINK

## **INFORMACIÓN DEL DOCUMENTO**

| **Campo** | **Descripción** |
|-----------|-----------|
| **Documento** | Guía de Despliegue Inicial - Sistema ChinchuLink |
| **Proyecto** | Sistema de Gestión de Pedidos |
| **Cliente** | Parrilla El Encuentro |
| **Desarrollado por** | SQLeaders S.A. |
| **Versión** | 1.0 |
| **Estado** | Implementado y Funcional |

## **RESUMEN EJECUTIVO**

### **Objetivo del Documento**
Esta guía proporciona las instrucciones completas para el despliegue inicial del sistema ChinchuLink, incluyendo la secuencia obligatoria de ejecución de bundles SQL, verificaciones y comandos específicos para una instalación exitosa.

---

## ESTRUCTURA DE BUNDLES DISPONIBLES

### **01_Infraestructura_Base**
- `Bundle_A1_BaseDatos_Estructura.sql` - Creación de BD y tablas
- `Bundle_A2_Indices_Datos.sql` - Índices y datos iniciales

### **02_Logica_Negocio**
- `Bundle_B1_Pedidos_Core.sql` - SP creación de pedidos
- `Bundle_B2_Items_Calculos.sql` - SP gestión items y cálculos  
- `Bundle_B3_Estados_Finalizacion.sql` - SP estados y finalización

### **03_Seguridad_Consultas**
- `Bundle_C_Seguridad.sql` - Roles y permisos de seguridad
- `Bundle_D_Consultas_Basicas.sql` - Consultas base del sistema

### **04_Automatizacion_Avanzada**
- `Bundle_E1_Triggers_Principales.sql` - Triggers de totales y auditoría
- `Bundle_E2_Control_Avanzado.sql` - Automatizaciones avanzadas

### **05_Reportes_Dashboard**
- `Bundle_R1_Reportes_Estructuras_SPs.sql` - Infraestructura de reportes
- `Bundle_R2_Reportes_Vistas_Dashboard.sql` - Vistas y dashboard

### **Script de Validación**
- `06 - VALIDACION_COMPLETA_SISTEMA.sql` - Verificación final

---

## SECUENCIA DE DESPLIEGUE OBLIGATORIA

### **FASE 1: INFRAESTRUCTURA BÁSICA** *(OBLIGATORIO)*

#### **Paso 1.1 - Estructura de Base de Datos**
```sql
-- Archivo: 01_Infraestructura_Base/Bundle_A1_BaseDatos_Estructura.sql
--  Tiempo estimado: 2-3 minutos
--  Crea: Base de datos + 17 tablas principales
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d master -E -i "Bundle_A1_BaseDatos_Estructura.sql"
```

**Verificación:**
```sql
USE Chinchulink;
SELECT COUNT(*) AS 'Tablas_Creadas' FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';
-- Resultado esperado: 17
```

#### **Paso 1.2 - Índices y Datos Iniciales**
```sql
-- Archivo: 01_Infraestructura_Base/Bundle_A2_Indices_Datos.sql  
--  Tiempo estimado: 1-2 minutos
--  Crea: Índices de performance + datos de referencia
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "Bundle_A2_Indices_Datos.sql"
```

**Verificación:**
```sql
SELECT COUNT(*) AS 'Estados_Pedido' FROM ESTADO_PEDIDO; -- Esperado: 8
SELECT COUNT(*) AS 'Roles_Sistema' FROM ROL;           -- Esperado: 7
SELECT COUNT(*) AS 'Canales_Venta' FROM CANAL_VENTA;   -- Esperado: 3
```

---

### **FASE 2: LÓGICA DE NEGOCIO** *(OBLIGATORIO)*

#### **Paso 2.1 - Core de Pedidos**
```sql
-- Archivo: 02_Logica_Negocio/Bundle_B1_Pedidos_Core.sql
--  Tiempo estimado: 1 minuto
--  Crea: sp_CrearPedido (funcionalidad principal)
```

**Dependencias:** Requiere Fase 1 completa

#### **Paso 2.2 - Gestión de Items**
```sql
-- Archivo: 02_Logica_Negocio/Bundle_B2_Items_Calculos.sql
--  Tiempo estimado: 1 minuto  
--  Crea: sp_AgregarItemPedido, sp_CalcularTotalPedido
```

#### **Paso 2.3 - Estados y Finalización**
```sql
-- Archivo: 02_Logica_Negocio/Bundle_B3_Estados_Finalizacion.sql
--  Tiempo estimado: 1 minuto
--  Crea: sp_CerrarPedido, sp_CancelarPedido, sp_ActualizarEstadoPedido
```

**Verificación Fase 2:**
```sql
SELECT COUNT(*) AS 'SPs_Creados' 
FROM INFORMATION_SCHEMA.ROUTINES 
WHERE ROUTINE_TYPE = 'PROCEDURE' AND ROUTINE_NAME LIKE 'sp_%';
-- Resultado esperado: ≥ 5 SPs
```

---

### **FASE 3: SEGURIDAD Y CONSULTAS** *(OBLIGATORIO)*

#### **Paso 3.1 - Sistema de Seguridad**
```sql
-- Archivo: 03_Seguridad_Consultas/Bundle_C_Seguridad.sql
--  Tiempo estimado: 1-2 minutos
--  Crea: 7 roles + permisos granulares + usuarios aplicación
```

** IMPORTANTE:** Requiere permisos de `sysadmin`

**Dependencias:** Requiere Fases 1 y 2 completas

#### **Paso 3.2 - Consultas Básicas**
```sql
-- Archivo: 03_Seguridad_Consultas/Bundle_D_Consultas_Basicas.sql
--  Tiempo estimado: 1 minuto
--  Crea: Consultas frecuentes del sistema
```

**Verificación Fase 3:**
```sql
SELECT COUNT(*) AS 'Roles_Seguridad' 
FROM sys.database_principals 
WHERE type = 'R' AND name LIKE 'rol_%';
-- Resultado esperado: 7 roles
```

---

### **FASE 4: AUTOMATIZACIÓN** *(OPCIONAL - RECOMENDADO)*

#### **Paso 4.1 - Triggers Principales**
```sql
-- Archivo: 04_Automatizacion_Avanzada/Bundle_E1_Triggers_Principales.sql
--  Tiempo estimado: 1 minuto
--  Crea: Triggers de cálculo automático de totales
```

#### **Paso 4.2 - Control Avanzado**
```sql
-- Archivo: 04_Automatizacion_Avanzada/Bundle_E2_Control_Avanzado.sql
--  Tiempo estimado: 1 minuto
--  Crea: Automatizaciones adicionales y validaciones
```

---

### **FASE 5: REPORTES Y DASHBOARD** *(OPCIONAL)*

#### **Paso 5.1 - Infraestructura de Reportes**
```sql
-- Archivo: 05_Reportes_Dashboard/Bundle_R1_Reportes_Estructuras_SPs.sql
--  Tiempo estimado: 2 minutos
--  Crea: SPs de reportes automáticos
```

#### **Paso 5.2 - Vistas y Dashboard**
```sql
-- Archivo: 05_Reportes_Dashboard/Bundle_R2_Reportes_Vistas_Dashboard.sql
--  Tiempo estimado: 2 minutos
--  Crea: Vistas optimizadas para dashboard
```

---

## VALIDACIÓN FINAL DEL SISTEMA

### **Script de Validación Completa**
```sql
-- Archivo: 06 - VALIDACION_COMPLETA_SISTEMA.sql
--  Tiempo estimado: 1 minuto
--  Verifica: Todas las componentes instalados correctamente
```

### **Resultados Esperados:**
-  **Tablas principales:** 17/17
-  **Índices performance:** ≥ 8 creados
-  **Datos de referencia:** Estados, Canales, Roles completos
-  **Stored procedures:** ≥ 5 funcionales
-  **Roles de seguridad:** 7 roles configurados
-  **Triggers:** Funcionando correctamente
-  **Reportes:** Infraestructura operativa

---

## COMANDOS DE EJECUCIÓN COMPLETOS

### **Ejecución por SQL Server Management Studio (SSMS)**
```sql
-- 1. Conectar con permisos de sysadmin
-- 2. Abrir cada archivo en orden
-- 3. Verificar USE Chinchulink; al inicio (excepto Bundle_A1)
-- 4. Ejecutar (F5)
```

### **Ejecución por Línea de Comandos**
```bash
# Fase 1 - Infraestructura
sqlcmd -S [SERVIDOR] -E -i "01_Infraestructura_Base/Bundle_A1_BaseDatos_Estructura.sql"
sqlcmd -S [SERVIDOR] -E -i "01_Infraestructura_Base/Bundle_A2_Indices_Datos.sql"

# Fase 2 - Lógica de Negocio  
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "02_Logica_Negocio/Bundle_B1_Pedidos_Core.sql"
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "02_Logica_Negocio/Bundle_B2_Items_Calculos.sql"
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "02_Logica_Negocio/Bundle_B3_Estados_Finalizacion.sql"

# Fase 3 - Seguridad
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "03_Seguridad_Consultas/Bundle_C_Seguridad.sql"
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "03_Seguridad_Consultas/Bundle_D_Consultas_Basicas.sql"

# Fase 4 - Automatización (Opcional)
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "04_Automatizacion_Avanzada/Bundle_E1_Triggers_Principales.sql"
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "04_Automatizacion_Avanzada/Bundle_E2_Control_Avanzado.sql"

# Fase 5 - Reportes (Opcional)
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "05_Reportes_Dashboard/Bundle_R1_Reportes_Estructuras_SPs.sql"
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "05_Reportes_Dashboard/Bundle_R2_Reportes_Vistas_Dashboard.sql"

# Validación Final
sqlcmd -S [SERVIDOR] -d Chinchulink -E -i "06 - VALIDACION_COMPLETA_SISTEMA.sql"
```

### **Script PowerShell Automatizado**
```powershell
# Variables de configuración
$Server = "localhost"
$BundlesPath = "C:\ChinchuLink\B - Scripts SQL"

# Función de ejecución
function Execute-Bundle($BundlePath, $Database = "Chinchulink") {
    Write-Host "Ejecutando: $BundlePath" -ForegroundColor Yellow
    sqlcmd -S $Server -d $Database -E -i "$BundlesPath\$BundlePath"
    if ($LASTEXITCODE -eq 0) {
        Write-Host " Completado: $BundlePath" -ForegroundColor Green
    } else {
        Write-Host "Error en: $BundlePath" -ForegroundColor Red
        exit 1
    }
}

# Ejecución secuencial
Write-Host " INICIANDO DESPLIEGUE CHINCHULINK" -ForegroundColor Cyan

Execute-Bundle "01_Infraestructura_Base\Bundle_A1_BaseDatos_Estructura.sql" "master"
Execute-Bundle "01_Infraestructura_Base\Bundle_A2_Indices_Datos.sql"
Execute-Bundle "02_Logica_Negocio\Bundle_B1_Pedidos_Core.sql"
Execute-Bundle "02_Logica_Negocio\Bundle_B2_Items_Calculos.sql"
Execute-Bundle "02_Logica_Negocio\Bundle_B3_Estados_Finalizacion.sql"
Execute-Bundle "03_Seguridad_Consultas\Bundle_C_Seguridad.sql"
Execute-Bundle "03_Seguridad_Consultas\Bundle_D_Consultas_Basicas.sql"
Execute-Bundle "04_Automatizacion_Avanzada\Bundle_E1_Triggers_Principales.sql"
Execute-Bundle "04_Automatizacion_Avanzada\Bundle_E2_Control_Avanzado.sql"
Execute-Bundle "05_Reportes_Dashboard\Bundle_R1_Reportes_Estructuras_SPs.sql"
Execute-Bundle "05_Reportes_Dashboard\Bundle_R2_Reportes_Vistas_Dashboard.sql"
Execute-Bundle "06 - VALIDACION_COMPLETA_SISTEMA.sql"

Write-Host " DESPLIEGUE COMPLETADO EXITOSAMENTE" -ForegroundColor Green
```

---

## SOLUCIÓN DE PROBLEMAS COMUNES

### **Error: "Database already exists"**
```sql
-- Solución: Usar existing database
USE master;
DROP DATABASE Chinchulink; -- CUIDADO: Elimina todos los datos
-- Luego ejecutar Bundle_A1 nuevamente
```

### **Error: "Permission denied"**
```sql
-- Verificar permisos del usuario
SELECT IS_SRVROLEMEMBER('sysadmin') AS 'Es_SysAdmin';
-- Debe retornar 1
```

### **Error: "Object already exists"**
```sql
-- Los scripts incluyen verificaciones IF EXISTS
-- Es seguro re-ejecutar bundles individuales
```

### **Error: "Foreign key constraint"**
```sql
-- Verificar orden de ejecución
-- Bundle_A1 DEBE ejecutarse antes que Bundle_A2
-- Fases 1-3 son OBLIGATORIAS y en orden
```

---

**Desarrollado por:** SQLeaders S.A.  
**Proyecto Educativo ISTEA:** Uso exclusivamente académico - Prohibida la comercialización