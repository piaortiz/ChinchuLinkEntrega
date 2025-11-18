# B - Scripts SQL - ChinchuLink

**Cliente:** Parrilla El Encuentro  
**Desarrollado por:** SQLeaders S.A.  
**Versión:** 1.0  
**Fecha:** 13 de noviembre de 2025  

---

## CONTENIDO DE LA CARPETA

Esta carpeta contiene **todos los scripts SQL** necesarios para el despliegue completo del sistema ChinchuLink, organizados por funcionalidad en subcarpetas específicas.

### **Estructura Organizada**

```
B - Scripts SQL/
├── 01_Infraestructura_Base/            ← Paso 1: Estructura y datos básicos
├── 02_Logica_Negocio/                  ← Paso 2: SPs y lógica de pedidos
├── 03_Seguridad_Consultas/             ← Paso 3: Seguridad y consultas
├── 04_Automatizacion_Avanzada/         ← Paso 4: Triggers y automatización
├── 05_Reportes_Dashboard/              ← Paso 5: Sistema de reportes
└── 06_VALIDACION_POST_BUNDLES.sql      ← Validación final del sistema
```

---

## INICIO RÁPIDO

### **Para desplegar desde cero:**

1. **LEER PRIMERO:** `../A - Documentacion Tecnica/OK 03 - Guia de Despliegue Inicial.md`
2. **EJECUTAR en orden:** Scripts de cada subcarpeta (01 → 02 → 03 → 04 → 05)
3. **VALIDAR:** Ejecutar `06_VALIDACION_POST_BUNDLES.sql`

### **Orden de ejecución crítico:**

| **Paso** | **Carpeta** | **Descripción** | **Tiempo estimado** |
|----------|-------------|-----------------|---------------------|
| **1** | `01_Infraestructura_Base/` | Tablas, índices, datos básicos | 5 minutos |
| **2** | `02_Logica_Negocio/` | SPs de pedidos y cálculos | 8 minutos |
| **3** | `03_Seguridad_Consultas/` | Roles, permisos, vistas | 6 minutos |
| **4** | `04_Automatizacion_Avanzada/` | Triggers y controles | 7 minutos |
| **5** | `05_Reportes_Dashboard/` | Sistema completo de reportes | 8 minutos |
| **Final** | Validación completa | Verificar instalación | 2 minutos |

---

## ARCHIVOS PRINCIPALES

### **Guía de Despliegue Principal**
- **Ubicación:** `../A - Documentacion Tecnica/OK 03 - Guia de Despliegue Inicial.md`
- **Propósito:** Guía completa paso a paso
- **Contenido:** Instrucciones detalladas, prerrequisitos, troubleshooting
- **Importancia:** **CRÍTICA** - Leer antes de cualquier instalación

### **06_VALIDACION_POST_BUNDLES.sql**
- **Propósito:** Verificar que todos los componentes estén correctos
- **Ejecutar:** Al final del despliegue
- **Resultado:** Reporte detallado del estado del sistema

---

## SUBCARPETAS DETALLADAS

### **01_Infraestructura_Base/**
- **Contenido:** Bundle_A1, Bundle_A2 + README
- **Función:** Crear estructura completa de BD
- **Dependencias:** Ninguna

### **02_Logica_Negocio/**
- **Contenido:** Bundle_B1, Bundle_B2, Bundle_B3 + README  
- **Función:** Implementar lógica de pedidos
- **Dependencias:** Infraestructura Base

### **03_Seguridad_Consultas/**
- **Contenido:** Bundle_C, Bundle_D + README
- **Función:** Configurar seguridad y vistas básicas
- **Dependencias:** Infraestructura + Lógica

### **04_Automatizacion_Avanzada/**
- **Contenido:** Bundle_E1, Bundle_E2 + README
- **Función:** Triggers y automatización
- **Dependencias:** Pasos 1-3 completados

### **05_Reportes_Dashboard/**
- **Contenido:** Bundle_R1, Bundle_R2 + README
- **Función:** Sistema completo de reportes y dashboard
- **Dependencias:** Todos los pasos anteriores

---

## VALIDACIÓN RÁPIDA

### **Verificar antes de empezar:**
```sql
-- Verificar que SQL Server está listo
SELECT @@VERSION as SQLServerVersion
SELECT SERVERPROPERTY('ProductLevel') as ServicePack
```

### **Verificar después del despliegue:**
```sql
-- Ejecutar script de validación completa
-- Ubicación: B - Scripts SQL/06_VALIDACION_POST_BUNDLES.sql
```

---

## SOPORTE Y TROUBLESHOOTING

### **Si algo falla:**

1. **Revisar prerrequisitos** en la guía principal
2. **Verificar orden de ejecución** (muy importante)
3. **Consultar README** de la carpeta específica donde falló
4. **Ejecutar validación** para identificar qué falta
5. **Contactar soporte** con logs específicos del error

### **Contacto:**
- **Desarrollado por:** SQLeaders S.A.
- **Proyecto:** ChinchuLink v2.0
- **Cliente:** Parrilla El Encuentro

---

## CONSIDERACIONES IMPORTANTES

⚠️ **SIEMPRE hacer backup** antes de ejecutar en producción  
⚠️ **Probar en ambiente de desarrollo** primero  
⚠️ **Ejecutar en orden estricto** - las dependencias son críticas  
⚠️ **Leer documentación** antes de ejecutar cada paso  

---

**¡El sistema está diseñado para ser robusto y fácil de instalar siguiendo esta estructura organizada!**