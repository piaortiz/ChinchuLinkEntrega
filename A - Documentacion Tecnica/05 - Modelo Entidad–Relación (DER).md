# MODELO ENTIDAD-RELACIÓN - SISTEMA CHINCHULINK

## **INFORMACIÓN DEL DOCUMENTO**

| **Campo** | **Descripción** |
|-----------|-----------|
| **Documento** | Modelo Entidad-Relación (DER) - Sistema ChinchuLink |
| **Proyecto** | Sistema de Gestión de Pedidos |
| **Cliente** | Parrilla El Encuentro |
| **Desarrollado por** | SQLeaders S.A. |
| **Versión** | 1.0 |
| **Estado** | Implementado y Funcional |

## **RESUMEN EJECUTIVO**

### **Objetivo del Documento**
Este documento presenta el Modelo Entidad-Relación (DER) del sistema ChinchuLink, enfocándose en las relaciones entre entidades y la arquitectura visual del modelo de datos. Para detalles específicos de campos y tipos de datos, consultar el documento **"02 - Diccionario de Datos"**.

### **Componentes del Modelo**
- **17 entidades** organizadas en 7 módulos funcionales
- **23 relaciones** con integridad referencial completa
- **Arquitectura modular** por dominios de negocio
- **3 flujos de datos críticos** para operaciones principales

---

## **DIAGRAMAS INTERACTIVOS**

### **Visualización Completa del Modelo**
Para explorar los diagramas interactivos del Modelo Entidad-Relación de ChinchuLink:

**Diagrama Completo:** [**Ver en Mermaid Chart**](https://www.mermaidchart.com/d/372ab075-70ce-49cb-a815-a4a277218381)

**Descripción:** Diagrama técnico detallado con todas las 17 entidades del sistema, incluyendo nombres de campos específicos, tipos de datos (nvarchar, decimal, datetime), restricciones de integridad (CHECK, UNIQUE, FK), y relaciones exactas tal como están implementadas en la base de datos. Ideal para desarrolladores, administradores de base de datos y documentación técnica.

### **Visualización Simplificada**

**Diagrama Estilo ER Clásico:** [**Ver en Mermaid Chart**](https://www.mermaidchart.com/d/2afa2861-011c-47c6-8ccb-54fa3f40bcab)

**Descripción:** Diagrama conceptual siguiendo la notación académica tradicional con entidades representadas como rectángulos verdes y relaciones como diamantes azules. Muestra las 8 entidades principales y sus relaciones con cardinalidades (1:N, N:1). Perfecto para presentaciones ejecutivas, documentación de alto nivel y audiencias no técnicas que necesitan comprender la arquitectura general del sistema.

> **IMPORTANTE:** Para detalles técnicos completos, consultar el diagrama detallado y el diccionario de datos.

---

**Documento generado por SQLeaders S.A.**  
**Versión: 12.0 - 2025**  
