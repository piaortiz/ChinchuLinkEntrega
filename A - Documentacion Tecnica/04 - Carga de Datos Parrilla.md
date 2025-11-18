# CARGA DE DATOS OPERATIVOS - PARRILLA EL ENCUENTRO

## **INFORMACIÓN DEL DOCUMENTO**

| **Campo** | **Descripción** |
|-----------|-----------|
| **Documento** | Carga de Datos operativos - Parrilla El Encuentro |
| **Proyecto** | Sistema de Gestión de Pedidos ChinchuLink |
| **Cliente** | Parrilla El Encuentro |
| **Desarrollado por** | SQLeaders S.A. |
| **Versión** | 1.0 |
| **Estado** | Implementado y Funcional |

## **RESUMEN EJECUTIVO**

### **Objetivo del Documento**
Esta guía proporciona las instrucciones completas para el despliegue de datos específicos de Parrilla El Encuentro, incluyendo menú, precios, personal, mesas y pedidos de demostración. Los scripts deben ejecutarse DESPUÉS de haber completado el despliegue inicial del sistema ChinchuLink.

### **Prerrequisitos**
- Sistema ChinchuLink debe estar completamente instalado (Bundles A1-R2)
- Base de datos ChinchuLink operativa
- Permisos de escritura en la base de datos
- Tiempo estimado total: 5-8 minutos

---

## ESTRUCTURA DE SCRIPTS DISPONIBLES

### **Datos Parrilla El Encuentro**
- `PARTE_1_LIMPIEZA.sql` - Limpieza y preparación de datos existentes
- `PARTE_2_MENU.sql` - Productos y menú completo de la parrilla
- `PARTE_3_PRECIOS.sql` - Precios actualizados vigentes 
- `PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql` - Personal según estructura organizacional
- `PARTE_5_MESAS.sql` - Configuración de mesas y códigos QR
- `PARTE_6_VERIFICACION.sql` - Verificación y resumen final
- `SEIS_PEDIDOS_DEMO_CORREGIDO.sql` - Pedidos de demostración

---

## SECUENCIA DE DESPLIEGUE OBLIGATORIA

### **FASE 1: PREPARACIÓN DE DATOS** *(OBLIGATORIO)*

#### **Paso 1.1 - Limpieza de Datos Existentes**
```sql
-- Archivo: PARTE_1_LIMPIEZA.sql
-- Tiempo estimado: 30 segundos
-- Función: Elimina datos existentes y prepara sistema para nueva carga
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_1_LIMPIEZA.sql"
```

**Verificación:**
```sql
-- Verificar que las tablas están limpias
SELECT COUNT(*) AS 'Pedidos_Existentes' FROM PEDIDO;
SELECT COUNT(*) AS 'Personal_Existente' FROM EMPLEADO;
-- Resultado esperado: 0 en ambos casos
```

#### **Paso 1.2 - Carga de Menú Completo**
```sql
-- Archivo: PARTE_2_MENU.sql  
-- Tiempo estimado: 45 segundos
-- Función: Carga todos los productos del menú de la parrilla
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_2_MENU.sql"
```

**Verificación:**
```sql
SELECT COUNT(*) AS 'Productos_Menu' FROM PLATO WHERE activo = 1;
-- Resultado esperado: 29 productos activos
SELECT categoria, COUNT(*) as 'Cantidad' FROM PLATO 
WHERE activo = 1 GROUP BY categoria ORDER BY categoria;
```

---

### **FASE 2: CONFIGURACIÓN COMERCIAL** *(OBLIGATORIO)*

#### **Paso 2.1 - Configuración de Precios**
```sql
-- Archivo: PARTE_3_PRECIOS.sql
-- Tiempo estimado: 30 segundos
-- Función: Establece precios vigentes para todos los productos
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_3_PRECIOS.sql"
```

**Verificación:**
```sql
SELECT COUNT(*) AS 'Precios_Configurados' FROM PRECIO 
WHERE vigencia_desde <= GETDATE() AND vigencia_hasta >= GETDATE();
-- Resultado esperado: 29 precios vigentes
```

#### **Paso 2.2 - Personal y Estructura Organizacional**
```sql
-- Archivo: PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql
-- Tiempo estimado: 1 minuto
-- Función: Carga personal según estructura: 1 Admin, 1 Gerente, 6 Mozos, 2 Cajeros, 5 Cocineros, 2 Delivery
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql"
```

**Verificación:**
```sql
SELECT r.nombre as 'Rol', COUNT(*) as 'Cantidad'
FROM EMPLEADO e 
INNER JOIN ROL r ON e.rol_id = r.rol_id
WHERE e.activo = 1
GROUP BY r.nombre, r.rol_id
ORDER BY r.rol_id;
-- Resultado esperado: Administrador(1), Gerente(1), Cajero(2), Mesero(6), Cocinero(5), Delivery(2)
```

---

### **FASE 3: CONFIGURACIÓN OPERATIVA** *(OBLIGATORIO)*

#### **Paso 3.1 - Configuración de Mesas**
```sql
-- Archivo: PARTE_5_MESAS.sql
-- Tiempo estimado: 30 segundos
-- Función: Configura mesas con capacidades y códigos QR únicos
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_5_MESAS.sql"
```

**Verificación:**
```sql
SELECT capacidad, COUNT(*) as 'Cantidad_Mesas'
FROM MESA 
WHERE activa = 1 AND sucursal_id = 1
GROUP BY capacidad 
ORDER BY capacidad;
-- Resultado esperado: 4 personas(20), 6 personas(8), 8 personas(2)
```

#### **Paso 3.2 - Verificación Final del Sistema**
```sql
-- Archivo: PARTE_6_VERIFICACION.sql
-- Tiempo estimado: 45 segundos
-- Función: Ejecuta verificaciones completas y muestra resumen del sistema
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_6_VERIFICACION.sql"
```

**Verificación:**
```sql
-- Este script incluye sus propias verificaciones detalladas
-- Revisar output completo del script para confirmación
```

---

### **FASE 4: DATOS DE DEMOSTRACIÓN** *(OPCIONAL)*

#### **Paso 4.1 - Pedidos de Demostración**
```sql
-- Archivo: SEIS_PEDIDOS_DEMO_CORREGIDO.sql
-- Tiempo estimado: 1 minuto
-- Función: Carga 6 pedidos de ejemplo con diferentes estados y productos
```

**Ejecutar:**
```bash
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "SEIS_PEDIDOS_DEMO_CORREGIDO.sql"
```

**Verificación:**
```sql
SELECT 
    ep.nombre as 'Estado',
    COUNT(*) as 'Cantidad_Pedidos'
FROM PEDIDO p
INNER JOIN ESTADO_PEDIDO ep ON p.estado_id = ep.estado_id
GROUP BY ep.nombre, ep.estado_id
ORDER BY ep.estado_id;
-- Resultado esperado: Varios pedidos en diferentes estados
```

---

## VALIDACIÓN FINAL DEL SISTEMA

### **Script de Verificación Completa**
```sql
-- Archivo: Ejecutado automáticamente en PARTE_6_VERIFICACION.sql
-- Tiempo estimado: Incluido en Paso 3.2
-- Función: Verifica todos los componentes cargados correctamente
```
---

## COMANDOS DE EJECUCIÓN COMPLETOS

### **Ejecución por SQL Server Management Studio (SSMS)**

1. Abrir SSMS y conectar al servidor
2. Verificar conexión a base de datos `ChinchuLink`
3. Ejecutar scripts en orden secuencial:
   - `PARTE_1_LIMPIEZA.sql`
   - `PARTE_2_MENU.sql`
   - `PARTE_3_PRECIOS.sql`
   - `PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql`
   - `PARTE_5_MESAS.sql`
   - `PARTE_6_VERIFICACION.sql`
   - `SEIS_PEDIDOS_DEMO_CORREGIDO.sql` (opcional)

### **Ejecución por Línea de Comandos**

```bash
cd "C:\dev\ChinchuLink DB\ChinchuLink\Entregables\C- Datos Pariilla El Encuentro"

sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_1_LIMPIEZA.sql"
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_2_MENU.sql"
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_3_PRECIOS.sql"
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql"
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_5_MESAS.sql"
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "PARTE_6_VERIFICACION.sql"
sqlcmd -S [SERVIDOR] -d ChinchuLink -E -i "SEIS_PEDIDOS_DEMO_CORREGIDO.sql"
```

### **Script PowerShell Automatizado**

```powershell
# Configuración
$Server = "[NOMBRE_SERVIDOR]"
$Database = "ChinchuLink"
$ScriptsPath = "C:\dev\ChinchuLink DB\ChinchuLink\Entregables\C- Datos Pariilla El Encuentro"

# Scripts en orden de ejecución
$Scripts = @(
    "PARTE_1_LIMPIEZA.sql",
    "PARTE_2_MENU.sql", 
    "PARTE_3_PRECIOS.sql",
    "PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql",
    "PARTE_5_MESAS.sql",
    "PARTE_6_VERIFICACION.sql",
    "SEIS_PEDIDOS_DEMO_CORREGIDO.sql"
)

# Función de ejecución
function Execute-DataScript {
    param($ScriptPath)
    Write-Host "Ejecutando: $ScriptPath" -ForegroundColor Yellow
    sqlcmd -S $Server -d $Database -E -i "$ScriptsPath\$ScriptPath"
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Completado: $ScriptPath" -ForegroundColor Green
    } else {
        Write-Host "Error en: $ScriptPath" -ForegroundColor Red
        exit 1
    }
}

# Ejecución secuencial
Write-Host "INICIANDO CARGA DE DATOS - PARRILLA EL ENCUENTRO" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan

foreach ($script in $Scripts) {
    Execute-DataScript $script
    Start-Sleep -Seconds 2
}

Write-Host "CARGA DE DATOS COMPLETADA EXITOSAMENTE" -ForegroundColor Green
Write-Host "Sistema listo para operación en Parrilla El Encuentro" -ForegroundColor Green
```

---

## SOLUCIÓN DE PROBLEMAS COMUNES

### **Error: "Violation of PRIMARY KEY constraint"**
**Causa:** Datos duplicados o sistema no limpiado correctamente.
**Solución:** 
1. Ejecutar nuevamente `PARTE_1_LIMPIEZA.sql`
2. Verificar que no hay datos residuales
3. Re-ejecutar scripts desde PARTE_2

### **Error: "The INSERT statement conflicted with the FOREIGN KEY constraint"**
**Causa:** Referencias a datos no existentes (roles, sucursales, etc.).
**Solución:**
1. Verificar que el sistema base ChinchuLink está completamente instalado
2. Confirmar que existen roles y sucursales básicas
3. Ejecutar scripts de infraestructura si es necesario

### **Error: "Cannot insert explicit value for identity column"**
**Causa:** Problema con `IDENTITY_INSERT`.
**Solución:**
1. Los scripts manejan automáticamente `SET IDENTITY_INSERT`
2. Verificar que no hay transacciones abiertas
3. Re-ejecutar el script específico

### **Error: "Object name 'ChinchuLink' is invalid"**
**Causa:** Base de datos no existe o conexión incorrecta.
**Solución:**
1. Verificar que la base de datos ChinchuLink existe
2. Confirmar permisos de acceso
3. Ejecutar primero los bundles de infraestructura


---


**Documento generado por SQLeaders S.A. - Noviembre 2025**  
**Para soporte técnico: Contactar equipo de desarrollo**