# Índice de Documentación - ChinchuLink v1.0

Este documento sirve como guía de navegación para toda la documentación del proyecto ChinchuLink.

## 🎯 Inicio Rápido

Si es tu primera vez con el proyecto, recomendamos seguir este orden:

1. **[README.md](../README.md)** - Comienza aquí para una visión general del proyecto
2. **[00 - Propuesta Inicial ChinchuLink.pdf](00%20-%20Propuesta%20Inicial%20ChinchuLink.pdf)** - Propuesta inicial y contexto
3. **[03 - Guia de Despliegue Inicial.md](03%20-%20Guia%20de%20Despliegue%20Inicial.md)** - Instalación paso a paso
4. **[04 - Carga de Datos Parrilla.md](04%20-%20Carga%20de%20Datos%20Parrilla.md)** - Carga de datos de prueba

---

## 📚 Documentación Técnica Completa

### Documentos de Análisis y Diseño

#### [01 - Requerimientos Tecnicos.md](01%20-%20Requerimientos%20Tecnicos.md)
**Propósito:** Define los requerimientos técnicos del sistema  
**Contenido:**
- Requerimientos funcionales y no funcionales
- Especificaciones de hardware y software
- Dependencias del sistema
- Restricciones técnicas

**Cuándo consultarlo:** Al inicio del proyecto o para entender las especificaciones técnicas

---

#### [02 - Diccionario de Datos.md](02%20-%20Diccionario%20de%20Datos.md)
**Propósito:** Documentación completa de todas las estructuras de datos  
**Contenido:**
- Descripción de las 17 tablas del sistema
- Definición de campos y tipos de datos
- Relaciones entre tablas
- Constraints y validaciones

**Cuándo consultarlo:** Para entender la estructura de la base de datos o al desarrollar consultas

---

#### [05 - Modelo Entidad–Relación (DER).md](05%20-%20Modelo%20Entidad–Relación%20(DER).md)
**Propósito:** Representación visual del modelo de datos  
**Contenido:**
- Diagrama Entidad-Relación
- Cardinalidades
- Relaciones entre entidades
- Claves primarias y foráneas

**Cuándo consultarlo:** Para visualizar la arquitectura de datos del sistema

---

#### [06 - Reglas del Negocio.md](06%20-%20Reglas%20del%20Negocio.md)
**Propósito:** Definición de las reglas de negocio implementadas  
**Contenido:**
- Reglas de validación
- Flujos de procesos
- Políticas del negocio
- Restricciones operativas

**Cuándo consultarlo:** Para entender la lógica de negocio y validaciones

---

### Documentos de Implementación

#### [03 - Guia de Despliegue Inicial.md](03%20-%20Guia%20de%20Despliegue%20Inicial.md)
**Propósito:** Guía paso a paso para la instalación del sistema  
**Contenido:**
- Prerrequisitos
- Pasos de instalación ordenados
- Configuración inicial
- Verificación de instalación

**Cuándo consultarlo:** Al instalar el sistema por primera vez

---

#### [04 - Carga de Datos Parrilla.md](04%20-%20Carga%20de%20Datos%20Parrilla.md)
**Propósito:** Guía para cargar los datos de prueba del cliente ficticio  
**Contenido:**
- Proceso de carga de datos
- Datos del restaurante "Parrilla El Encuentro"
- Scripts de inserción
- Validación de datos

**Cuándo consultarlo:** Después de la instalación, para poblar la base de datos

---

### Documentos de Operación y Mantenimiento

#### [07 - Plan de Backup y Recuperacion.md](07%20-%20Plan%20de%20Backup%20y%20Recuperacion.md)
**Propósito:** Estrategia de respaldo y recuperación de datos  
**Contenido:**
- Política de backups
- Procedimientos de respaldo
- Proceso de recuperación
- Programación de backups

**Cuándo consultarlo:** Para implementar estrategias de backup o recuperación ante desastres

---

### Documentos de Referencia

#### [08 - Glosario.md](08%20-%20Glosario.md)
**Propósito:** Definición de términos técnicos utilizados en el proyecto  
**Contenido:**
- Terminología técnica
- Acrónimos
- Conceptos del dominio
- Definiciones específicas del proyecto

**Cuándo consultarlo:** Para aclarar términos técnicos o conceptos del dominio

---

## 📂 Scripts SQL

Los scripts SQL están organizados en la carpeta **[B - Scripts SQL](../B%20-%20Scripts%20SQL/)** con la siguiente estructura:

### Bundle 0: Reset Completo
**Ubicación:** `B - Scripts SQL/00_Reset_Completo/`  
**Propósito:** Limpiar y resetear la base de datos  
**Archivos:**
- `Bundle_CERO_Reset_Completo.sql`

### Bundle 1: Infraestructura Base
**Ubicación:** `B - Scripts SQL/01_Infraestructura_Base/`  
**Propósito:** Crear la estructura base de la base de datos  
**Archivos:**
- `Bundle_A1_BaseDatos_Estructura.sql` - Creación de tablas
- `Bundle_A2_Indices_Datos.sql` - Índices y optimización

### Bundle 2: Lógica de Negocio
**Ubicación:** `B - Scripts SQL/02_Logica_Negocio/`  
**Propósito:** Implementar stored procedures principales  
**Archivos:**
- `Bundle_B1_Pedidos_Core.sql` - Gestión de pedidos
- `Bundle_B2_Items_Calculos.sql` - Cálculos de items
- `Bundle_B3_Estados_Finalizacion.sql` - Estados y finalización

### Bundle 3: Seguridad y Consultas
**Ubicación:** `B - Scripts SQL/03_Seguridad_Consultas/`  
**Propósito:** Seguridad y consultas básicas  
**Archivos:**
- `Bundle_C_Seguridad.sql` - Roles y permisos
- `Bundle_D_Consultas_Basicas.sql` - Consultas básicas

### Bundle 4: Automatización Avanzada
**Ubicación:** `B - Scripts SQL/04_Automatizacion_Avanzada/`  
**Propósito:** Triggers y control avanzado  
**Archivos:**
- `Bundle_E1_Triggers_Principales.sql` - Triggers principales
- `Bundle_E2_Control_Avanzado.sql` - Control avanzado

### Bundle 5: Reportes y Dashboard
**Ubicación:** `B - Scripts SQL/05_Reportes_Dashboard/`  
**Propósito:** Sistema de reportes  
**Archivos:**
- `Bundle_R1_Reportes_Estructuras_SPs.sql` - Stored procedures de reportes
- `Bundle_R2_Reportes_Vistas_Dashboard.sql` - Vistas para dashboard

### Validación Post-Instalación
**Ubicación:** `B - Scripts SQL/`  
**Archivo:** `06_VALIDACION_POST_BUNDLES.sql`  
**Propósito:** Validar que todos los componentes se instalaron correctamente

---

## 🗂️ Datos de Prueba

Los datos del cliente ficticio "Parrilla El Encuentro" están en la carpeta **[C- Datos Pariilla El Encuentro](../C-%20Datos%20Pariilla%20El%20Encuentro/)**

**Ejecutar en este orden:**
1. `PARTE_1_LIMPIEZA.sql` - Limpieza inicial
2. `PARTE_2_MENU.sql` - Carga del menú
3. `PARTE_3_PRECIOS.sql` - Precios de productos
4. `PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql` - Personal del restaurante
5. `PARTE_5_MESAS.sql` - Configuración de mesas
6. `PARTE_6_VERIFICACION.sql` - Verificación de datos
7. `PARTE_7_STOCK.sql` - Stock inicial
8. `PARTE_8_PEDIDOS_HISTORICOS.sql` - Pedidos históricos de ejemplo

---

## 🎓 Para Evaluadores Académicos

Si estás evaluando este proyecto, te recomendamos el siguiente recorrido:

1. **[README.md](../README.md)** - Visión general y métricas
2. **[00 - Propuesta Inicial ChinchuLink.pdf](00%20-%20Propuesta%20Inicial%20ChinchuLink.pdf)** - Contexto del proyecto
3. **[02 - Diccionario de Datos.md](02%20-%20Diccionario%20de%20Datos.md)** - Estructura completa de datos
4. **[05 - Modelo Entidad–Relación (DER).md](05%20-%20Modelo%20Entidad–Relación%20(DER).md)** - Diseño de la base de datos
5. **[06 - Reglas del Negocio.md](06%20-%20Reglas%20del%20Negocio.md)** - Lógica implementada
6. **Scripts SQL** - Revisar los bundles en orden numérico
7. **[CHANGELOG.md](../CHANGELOG.md)** - Historial del proyecto

---

## 💡 Consejos de Navegación

- **Búsqueda rápida:** Usa Ctrl+F (Cmd+F en Mac) para buscar términos específicos en los documentos Markdown
- **Enlaces relativos:** Todos los enlaces están configurados para funcionar tanto en GitHub como en visualizadores locales de Markdown
- **Orden de lectura:** Los documentos numerados (01, 02, etc.) sugieren un orden lógico de lectura
- **Referencias cruzadas:** Muchos documentos se referencian entre sí para facilitar la navegación

---

## 📞 Información de Contacto

**Equipo SQLeaders S.A.**
- Mariapía Ortiz - Project Manager
- Adrián Barletta - Database Administrator
- Franco Emmert - QA / Editor
- Agustín Acosta - Developer SQL
- Lucas Miedwiediew - Developer SQL

**Supervisor Académico**
- Profesor: Victor Cordero
- Instituto: ISTEA

---

## 📊 Estructura Visual del Proyecto

```
ChinchuLink v1.0/
│
├── 📁 A - Documentacion Tecnica/
│   ├── 📄 00 - Propuesta Inicial ChinchuLink.pdf
│   ├── 📝 01 - Requerimientos Tecnicos.md
│   ├── 📝 02 - Diccionario de Datos.md
│   ├── 📝 03 - Guia de Despliegue Inicial.md
│   ├── 📝 04 - Carga de Datos Parrilla.md
│   ├── 📝 05 - Modelo Entidad–Relación (DER).md
│   ├── 📝 06 - Reglas del Negocio.md
│   ├── 📝 07 - Plan de Backup y Recuperacion.md
│   └── 📝 08 - Glosario.md
│
├── 📁 B - Scripts SQL/
│   ├── 📁 00_Reset_Completo/
│   ├── 📁 01_Infraestructura_Base/
│   ├── 📁 02_Logica_Negocio/
│   ├── 📁 03_Seguridad_Consultas/
│   ├── 📁 04_Automatizacion_Avanzada/
│   ├── 📁 05_Reportes_Dashboard/
│   └── 📄 06_VALIDACION_POST_BUNDLES.sql
│
├── 📁 C- Datos Pariilla El Encuentro/
│   └── 📄 PARTE_1 a PARTE_8 (8 archivos SQL)
│
├── 📊 PresentaciónChinchulink.pptx
├── 📝 README.md
├── 📝 LICENSE.md
├── 📝 CHANGELOG.md
└── 📝 .gitignore
```

---

**Última actualización:** Noviembre 2025  
**Versión del proyecto:** 1.0.0
