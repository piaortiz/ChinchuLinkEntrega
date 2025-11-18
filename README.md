<div align="center">
  <img src="A - Documentacion Tecnica/09 - chinchulink-logo.png" alt="ChinchuLink Logo" width="300"/>
</div>

# ChinchuLink v1.0
## Sistema de Gestión de Pedidos para Restaurantes

**Proyecto Académico - Administración de Bases de Datos**  
**Profesor:** Victor Cordero  
**Instituto:** ISTEA  
**Desarrollado por:** SQLeaders S.A.  
**Cliente Ficticio:** Parrilla El Encuentro  
**Fecha:** Noviembre 2025

---

## Equipo de Desarrollo - SQLeaders S.A.

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="A - Documentacion Tecnica/team-mariapia-ortiz.png" width="120" style="border-radius: 50%"/><br/>
        <strong>Mariapía Ortiz</strong><br/>
        <em>Project Manager</em>
      </td>
      <td align="center">
        <img src="A - Documentacion Tecnica/team-adrian-barletta.png" width="120" style="border-radius: 50%"/><br/>
        <strong>Adrián Barletta</strong><br/>
        <em>Database Administrator</em>
      </td>
      <td align="center">
        <img src="A - Documentacion Tecnica/team-franco-emmert.png" width="120" style="border-radius: 50%"/><br/>
        <strong>Franco Emmert</strong><br/>
        <em>QA / Editor</em>
      </td>
    </tr>
    <tr>
      <td align="center">
        <img src="A - Documentacion Tecnica/team-agustin-acosta.png" width="120" style="border-radius: 50%"/><br/>
        <strong>Agustín Acosta</strong><br/>
        <em>Developer SQL</em>
      </td>
      <td align="center">
        <img src="A - Documentacion Tecnica/team-lucas-miedwiediew.png" width="120" style="border-radius: 50%"/><br/>
        <strong>Lucas Miedwiediew</strong><br/>
        <em>Developer SQL</em>
      </td>
      <td></td>
    </tr>
  </table>
</div>

---

## Descripción del Proyecto

ChinchuLink es un sistema integral de gestión de pedidos desarrollado específicamente para restaurantes. Este proyecto académico implementa una solución completa de base de datos para la gestión operativa de "Parrilla El Encuentro", un restaurante ficticio especializado en parrillas argentinas.

El sistema maneja todas las operaciones críticas del restaurante: gestión de mesas, toma de pedidos, control de inventario, administración de personal y reportes en tiempo real.

## Objetivos Académicos

Este proyecto fue desarrollado para demostrar competencias en:
- Diseño de bases de datos relacionales complejas
- Implementación de stored procedures y triggers
- Gestión de seguridad y roles de usuario
- Optimización de consultas y rendimiento
- Documentación técnica profesional
- Arquitectura modular y escalable

## Estructura del Proyecto

```
ChinchuLink v1.0/
├── A - Documentacion Tecnica/
│   ├── 01 - Requerimientos Tecnicos.md
│   ├── 02 - Diccionario de Datos.md
│   ├── 03 - Guia de Despliegue Inicial.md
│   ├── 04 - Carga de Datos Parrilla.md
│   ├── 05 - Modelo Entidad–Relación (DER).md
│   ├── 06 - Reglas del Negocio.md
│   ├── 07 - Plan de Backup y Recuperacion.md
│   └── 08 - Glosario.md
├── B - Scripts SQL/
│   ├── 00_Reset_Completo/
│   ├── 01_Infraestructura_Base/
│   ├── 02_Logica_Negocio/
│   ├── 03_Seguridad_Consultas/
│   ├── 04_Automatizacion_Avanzada/
│   ├── 05_Reportes_Dashboard/
│   └── 06_VALIDACION_POST_BUNDLES.sql
└── C- Datos Pariilla El Encuentro/
    ├── PARTE_1_LIMPIEZA.sql
    ├── PARTE_2_MENU.sql
    ├── PARTE_3_PRECIOS.sql
    ├── PARTE_4_PERSONAL_ESTRUCTURA_ACTUALIZADA.sql
    ├── PARTE_5_MESAS.sql
    ├── PARTE_6_VERIFICACION.sql
    ├── PARTE_7_STOCK.sql
    └── PARTE_8_PEDIDOS_HISTORICOS.sql
```

## Características Técnicas

### Base de Datos
- **17 tablas** completamente normalizadas
- **Motor:** Microsoft SQL Server
- **Triggers automáticos** para integridad referencial
- **Stored procedures** para operaciones críticas

### Seguridad
- **7 roles específicos** con permisos granulares
- Sistema de auditoría completo
- Control de acceso por funcionalidad
- Validaciones de integridad implementadas

### Funcionalidades Principales
- Gestión completa de mesas y códigos QR
- Sistema de pedidos con estados automatizados
- Control de inventario en tiempo real
- Administración de personal por roles

## Datos del Cliente Ficticio

**Parrilla El Encuentro** - Restaurante especializado en parrillas argentinas
- **Ubicación:** Ficticia para propósitos académicos
- **Capacidad:** 40+ mesas, 200 comensales
- **Personal:** 17 empleados distribuidos en 7 roles
- **Menú:** 45 productos organizados por categorías
- **Especialidad:** Carnes a la parrilla, acompañamientos tradicionales

## Instalación y Despliegue

### Prerrequisitos
- Microsoft SQL Server 2019 o superior
- SQL Server Management Studio (SSMS)
- Permisos de administrador en la instancia SQL

### Guía de Instalación
Para instrucciones detalladas de instalación y despliegue, consultar el documento:
**[03 - Guía de Despliegue Inicial.md](A%20-%20Documentacion%20Tecnica/03%20-%20Guia%20de%20Despliegue%20Inicial.md)**

Este documento contiene el proceso completo paso a paso para la implementación del sistema.

## Documentación Técnica

La carpeta `A - Documentacion Tecnica` contiene documentación completa:
- Requerimientos técnicos detallados
- Diccionario de datos completo
- Guías de despliegue paso a paso
- Modelo Entidad-Relación documentado
- Reglas de negocio implementadas
- Plan de backup y recuperación
- Glosario técnico

## Tecnologías Utilizadas

- **Base de Datos:** Microsoft SQL Server
- **Herramientas:** SQL Server Management Studio
- **Documentación:** Markdown
- **Versionado:** Git/GitHub

## Métricas del Proyecto

- **Líneas de código SQL:** 2000+ líneas
- **Tablas implementadas:** 17
- **Stored Procedures:** 15+
- **Triggers:** 8+
- **Vistas:** 10+
- **Roles de seguridad:** 7
- **Documentos técnicos:** 8


## Licencia

Este proyecto es desarrollado con fines académicos como parte del cursado de la materia Administración de Bases de Datos en ISTEA. El código y la documentación están disponibles para revisión y evaluación académica.

## Agradecimientos

Agradecimiento especial al profesor Victor Cordero por la guía y supervisión durante el desarrollo del proyecto, y al instituto ISTEA por proporcionar el marco académico para el aprendizaje de administración de bases de datos.

