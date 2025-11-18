# ChinchuLink v1.0
## Sistema de Gestión de Pedidos para Restaurantes

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-red.svg)
![License](https://img.shields.io/badge/license-Academic-green.svg)
![Status](https://img.shields.io/badge/status-Completed-success.svg)

**Proyecto Académico - Administración de Bases de Datos**  
**Profesor:** Victor Cordero  
**Instituto:** ISTEA  
**Desarrollado por:** SQLeaders S.A.  
**Cliente Ficticio:** Parrilla El Encuentro  
**Fecha:** Noviembre 2025

---

## 📑 Tabla de Contenidos

- [Equipo de Desarrollo](#equipo-de-desarrollo---sqleaders-sa)
- [Descripción del Proyecto](#descripción-del-proyecto)
- [Objetivos Académicos](#objetivos-académicos)
- [Estructura del Proyecto](#estructura-del-proyecto)
- [Características Técnicas](#características-técnicas)
- [Datos del Cliente Ficticio](#datos-del-cliente-ficticio)
- [Instalación y Despliegue](#instalación-y-despliegue)
- [Documentación Técnica](#documentación-técnica)
- [Tecnologías Utilizadas](#tecnologías-utilizadas)
- [Métricas del Proyecto](#métricas-del-proyecto)
- [Licencia](#licencia)
- [Agradecimientos](#agradecimientos)

---

## Equipo de Desarrollo - SQLeaders S.A.

<div align="center">
  <table>
    <tr>
      <td align="center">
        <strong>Mariapía Ortiz</strong><br/>
        <em>Project Manager</em>
      </td>
      <td align="center">
        <strong>Adrián Barletta</strong><br/>
        <em>Database Administrator</em>
      </td>
      <td align="center">
        <strong>Franco Emmert</strong><br/>
        <em>QA / Editor</em>
      </td>
    </tr>
    <tr>
      <td align="center">
        <strong>Agustín Acosta</strong><br/>
        <em>Developer SQL</em>
      </td>
      <td align="center">
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
- ✅ Gestión completa de mesas y códigos QR
- ✅ Sistema de pedidos con estados automatizados
- ✅ Control de inventario en tiempo real
- ✅ Administración de personal por roles
- ✅ Reportes y dashboard analíticos
- ✅ Sistema de auditoría completo
- ✅ Validaciones de integridad de datos

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

#### Inicio Rápido
1. **Clonar el repositorio**
   ```bash
   git clone https://github.com/piaortiz/ChinchuLinkEntrega.git
   cd ChinchuLinkEntrega
   ```

2. **Ejecutar scripts en orden**
   - Primero: Scripts en `B - Scripts SQL/00_Reset_Completo/`
   - Segundo: Scripts en `B - Scripts SQL/01_Infraestructura_Base/`
   - Tercero: Scripts en `B - Scripts SQL/02_Logica_Negocio/`
   - Y así sucesivamente...

3. **Cargar datos de prueba**
   - Ejecutar scripts en `C- Datos Pariilla El Encuentro/` en orden numérico

4. **Validar instalación**
   - Ejecutar `B - Scripts SQL/06_VALIDACION_POST_BUNDLES.sql`

#### Documentación Completa
Para instrucciones detalladas de instalación y despliegue, consultar el documento:
**[03 - Guía de Despliegue Inicial.md](A%20-%20Documentacion%20Tecnica/03%20-%20Guia%20de%20Despliegue%20Inicial.md)**

Este documento contiene el proceso completo paso a paso para la implementación del sistema.

## Documentación Técnica

La carpeta **`A - Documentacion Tecnica`** contiene documentación completa:

| Documento | Descripción |
|-----------|-------------|
| [00 - Propuesta Inicial ChinchuLink.pdf](A%20-%20Documentacion%20Tecnica/00%20-%20Propuesta%20Inicial%20ChinchuLink.pdf) | Propuesta inicial del proyecto |
| [01 - Requerimientos Tecnicos.md](A%20-%20Documentacion%20Tecnica/01%20-%20Requerimientos%20Tecnicos.md) | Requerimientos técnicos detallados |
| [02 - Diccionario de Datos.md](A%20-%20Documentacion%20Tecnica/02%20-%20Diccionario%20de%20Datos.md) | Diccionario de datos completo (17 tablas) |
| [03 - Guia de Despliegue Inicial.md](A%20-%20Documentacion%20Tecnica/03%20-%20Guia%20de%20Despliegue%20Inicial.md) | Guía de instalación paso a paso |
| [04 - Carga de Datos Parrilla.md](A%20-%20Documentacion%20Tecnica/04%20-%20Carga%20de%20Datos%20Parrilla.md) | Guía de carga de datos de prueba |
| [05 - Modelo Entidad–Relación (DER).md](A%20-%20Documentacion%20Tecnica/05%20-%20Modelo%20Entidad%E2%80%93Relaci%C3%B3n%20(DER).md) | Modelo ER documentado |
| [06 - Reglas del Negocio.md](A%20-%20Documentacion%20Tecnica/06%20-%20Reglas%20del%20Negocio.md) | Reglas de negocio implementadas |
| [07 - Plan de Backup y Recuperacion.md](A%20-%20Documentacion%20Tecnica/07%20-%20Plan%20de%20Backup%20y%20Recuperacion.md) | Estrategia de backup y recuperación |
| [08 - Glosario.md](A%20-%20Documentacion%20Tecnica/08%20-%20Glosario.md) | Glosario de términos técnicos |

## Tecnologías Utilizadas

- **Base de Datos:** Microsoft SQL Server
- **Herramientas:** SQL Server Management Studio
- **Documentación:** Markdown
- **Versionado:** Git/GitHub

## Métricas del Proyecto

| Categoría | Cantidad |
|-----------|----------|
| Líneas de código SQL | 2000+ |
| Tablas implementadas | 17 |
| Stored Procedures | 15+ |
| Triggers | 8+ |
| Vistas | 10+ |
| Roles de seguridad | 7 |
| Documentos técnicos | 8 |
| Archivos SQL | 21 |


## 📋 Archivos Importantes

- **[README.md](README.md)** - Este archivo, documentación principal del proyecto
- **[LICENSE.md](LICENSE.md)** - Licencia de uso académico
- **[CHANGELOG.md](CHANGELOG.md)** - Historial de cambios y versiones
- **[PresentaciónChinchulink.pptx](PresentaciónChinchulink.pptx)** - Presentación ejecutiva del proyecto


## Licencia

Este proyecto es desarrollado con fines académicos como parte del cursado de la materia Administración de Bases de Datos en ISTEA. 

Para más detalles sobre los términos de uso, consultar **[LICENSE.md](LICENSE.md)**.

## Agradecimientos

Agradecimiento especial al profesor **Victor Cordero** por la guía y supervisión durante el desarrollo del proyecto, y al instituto **ISTEA** por proporcionar el marco académico para el aprendizaje de administración de bases de datos.

---

<div align="center">

**ChinchuLink v1.0** - Sistema de Gestión de Pedidos para Restaurantes

Desarrollado con ❤️ por SQLeaders S.A. | ISTEA 2025

</div>