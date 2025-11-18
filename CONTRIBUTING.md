# Guía de Contribución - ChinchuLink v1.0

¡Gracias por tu interés en ChinchuLink! Este proyecto es académico y fue desarrollado como parte de la materia Administración de Bases de Datos en ISTEA.

## 📋 Tabla de Contenidos

- [Contexto Académico](#contexto-académico)
- [Cómo Usar Este Proyecto](#cómo-usar-este-proyecto)
- [Sugerencias de Mejora](#sugerencias-de-mejora)
- [Reportar Problemas](#reportar-problemas)
- [Estándares de Código](#estándares-de-código)
- [Estructura de Commits](#estructura-de-commits)

---

## 🎓 Contexto Académico

Este proyecto fue desarrollado por **SQLeaders S.A.** como entrega final para la materia de Administración de Bases de Datos:

- **Instituto:** ISTEA
- **Profesor:** Victor Cordero
- **Fecha:** Noviembre 2025
- **Propósito:** Proyecto académico de evaluación

### Equipo de Desarrollo

| Nombre | Rol |
|--------|-----|
| Mariapía Ortiz | Project Manager |
| Adrián Barletta | Database Administrator |
| Franco Emmert | QA / Editor |
| Agustín Acosta | Developer SQL |
| Lucas Miedwiediew | Developer SQL |

---

## 📚 Cómo Usar Este Proyecto

### Para Estudiantes

Si eres estudiante y quieres aprender de este proyecto:

1. **NO copies directamente** - Esto es plagio académico
2. **SÍ estudia y aprende** - Analiza el diseño, la lógica y las técnicas utilizadas
3. **SÍ practica** - Intenta implementar conceptos similares en tu propio proyecto
4. **SÍ cita** - Si refieres este proyecto en tu trabajo, cita apropiadamente

#### Ejemplo de Cita

```
Ortiz, M., Barletta, A., Emmert, F., Acosta, A., & Miedwiediew, L. (2025). 
ChinchuLink v1.0: Sistema de Gestión de Pedidos para Restaurantes. 
ISTEA - Administración de Bases de Datos. 
https://github.com/piaortiz/ChinchuLinkEntrega
```

### Para Docentes

Este proyecto puede servir como:
- Material de referencia para enseñar diseño de bases de datos
- Ejemplo de proyecto completo con documentación profesional
- Caso de estudio de implementación de SQL Server
- Plantilla de estructura de proyecto académico

---

## 💡 Sugerencias de Mejora

Aunque este es un proyecto académico completado, valoramos sugerencias educativas:

### Áreas de Extensión Sugeridas

1. **Interfaz Gráfica**
   - Desarrollo de una aplicación web (React, Angular, Vue)
   - Aplicación de escritorio (C#, Java)
   - Aplicación móvil (React Native, Flutter)

2. **API Backend**
   - API REST con Node.js + Express
   - API con ASP.NET Core
   - GraphQL implementation

3. **Reportería Avanzada**
   - Integración con Power BI
   - Dashboard en tiempo real
   - Reportes exportables (PDF, Excel)

4. **Funcionalidades Adicionales**
   - Sistema de reservas online
   - Integración con sistemas de pago
   - Gestión de delivery
   - Sistema de feedback de clientes
   - Programa de fidelización

5. **Optimización**
   - Indexación avanzada
   - Particionamiento de tablas
   - Caché de consultas frecuentes
   - Optimización de stored procedures

### Cómo Sugerir Mejoras

Si tienes sugerencias:

1. Abre un **Issue** en GitHub
2. Usa el título: `[SUGERENCIA] Breve descripción`
3. Explica:
   - Qué se podría mejorar
   - Por qué sería beneficioso
   - Cómo se podría implementar (opcional)

---

## 🐛 Reportar Problemas

Si encuentras un problema en el código o la documentación:

### Antes de Reportar

1. Verifica que usas SQL Server 2019 o superior
2. Revisa que ejecutaste los scripts en el orden correcto
3. Consulta la [Guía de Despliegue](A%20-%20Documentacion%20Tecnica/03%20-%20Guia%20de%20Despliegue%20Inicial.md)
4. Busca si el problema ya fue reportado

### Cómo Reportar

1. Abre un **Issue** en GitHub
2. Usa el título: `[BUG] Breve descripción del problema`
3. Incluye:
   - **Descripción:** Qué salió mal
   - **Pasos para reproducir:** Cómo reproducir el error
   - **Comportamiento esperado:** Qué debería pasar
   - **Comportamiento actual:** Qué está pasando
   - **Entorno:** Versión de SQL Server, sistema operativo
   - **Capturas de pantalla:** Si aplica

#### Plantilla de Reporte

```markdown
## Descripción
[Descripción clara del problema]

## Pasos para Reproducir
1. Ejecutar script X
2. Ejecutar consulta Y
3. Observar error Z

## Comportamiento Esperado
[Qué debería suceder]

## Comportamiento Actual
[Qué está sucediendo]

## Entorno
- SQL Server: [versión]
- SO: [Windows/Linux/Mac]
- SSMS: [versión]

## Información Adicional
[Logs, capturas, etc.]
```

---

## 📝 Estándares de Código

Si contribuyes con mejoras, sigue estos estándares:

### SQL

```sql
-- ✅ CORRECTO: Nombres descriptivos en español, PascalCase para objetos
CREATE TABLE Pedidos (
    PedidoID INT PRIMARY KEY,
    FechaPedido DATETIME NOT NULL,
    EstadoPedido VARCHAR(20) NOT NULL
);

-- ✅ CORRECTO: Stored procedures con prefijo sp_
CREATE PROCEDURE sp_CrearPedido
    @MesaID INT,
    @UsuarioID INT
AS
BEGIN
    -- Lógica del procedimiento
END;

-- ✅ CORRECTO: Comentarios claros
-- Este trigger actualiza el stock automáticamente
-- cuando se confirma un pedido
CREATE TRIGGER trg_ActualizarStock
    ON DetallesPedido
    AFTER INSERT
AS
BEGIN
    -- Lógica del trigger
END;
```

### Markdown

- Usa títulos jerárquicos (H1 > H2 > H3)
- Incluye tabla de contenidos para documentos largos
- Usa código de bloques con sintaxis resaltada
- Incluye ejemplos prácticos
- Mantén líneas de máximo 100 caracteres cuando sea posible

### Estructura de Archivos

```
Proyecto/
├── A - Documentacion Tecnica/     # Documentación completa
├── B - Scripts SQL/               # Scripts organizados por bundles
├── C - Datos Prueba/              # Datos de ejemplo
├── README.md                      # Documentación principal
├── LICENSE.md                     # Licencia
├── CHANGELOG.md                   # Historial de cambios
└── CONTRIBUTING.md                # Esta guía
```

---

## 🔄 Estructura de Commits

Si realizas contribuciones, usa mensajes de commit descriptivos:

### Formato

```
tipo(ámbito): Descripción breve

Descripción detallada opcional
```

### Tipos de Commit

- `feat`: Nueva funcionalidad
- `fix`: Corrección de bug
- `docs`: Cambios en documentación
- `style`: Formato, espacios (no afecta código)
- `refactor`: Refactorización de código
- `test`: Agregar o modificar tests
- `chore`: Tareas de mantenimiento

### Ejemplos

```bash
# ✅ CORRECTO
git commit -m "feat(pedidos): Agregar validación de stock antes de crear pedido"
git commit -m "fix(triggers): Corregir actualización de totales en trg_CalcularTotales"
git commit -m "docs(readme): Actualizar sección de instalación"

# ❌ INCORRECTO
git commit -m "cambios"
git commit -m "fix"
git commit -m "actualización de archivos"
```

---

## 🔍 Proceso de Revisión

Para contribuciones significativas:

1. **Fork** del repositorio
2. Crear una **rama** descriptiva
   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```
3. Realizar cambios siguiendo los estándares
4. **Commit** con mensajes claros
5. **Push** a tu fork
6. Crear **Pull Request** con:
   - Título descriptivo
   - Descripción de cambios
   - Referencias a issues relacionados
   - Capturas de pantalla si aplica

---

## 📖 Recursos Adicionales

### Para Aprender SQL Server

- [Documentación oficial de Microsoft SQL Server](https://docs.microsoft.com/sql)
- [SQL Server Central](https://www.sqlservercentral.com/)
- [Brent Ozar's Blog](https://www.brentozar.com/blog/)

### Para Diseño de Bases de Datos

- Database Design for Mere Mortals (Michael J. Hernandez)
- SQL Antipatterns (Bill Karwin)
- The Data Warehouse Toolkit (Ralph Kimball)

### Para Documentación

- [Markdown Guide](https://www.markdownguide.org/)
- [GitHub Docs](https://docs.github.com/)

---

## ⚖️ Código de Conducta

### Comportamiento Esperado

- Ser respetuoso y profesional
- Aceptar críticas constructivas
- Enfocarse en lo que es mejor para el aprendizaje
- Ser colaborativo y empático

### Comportamiento Inaceptable

- Comentarios ofensivos o discriminatorios
- Acoso de cualquier tipo
- Publicación de información privada sin permiso
- Plagio académico

---

## 📧 Contacto

Para preguntas sobre el proyecto académico:

- **Repositorio:** [ChinchuLinkEntrega](https://github.com/piaortiz/ChinchuLinkEntrega)
- **Institución:** ISTEA
- **Supervisor:** Profesor Victor Cordero

---

## 🎯 Objetivos de Este Proyecto

Recuerda que los objetivos académicos de este proyecto son:

1. ✅ Diseñar bases de datos relacionales complejas
2. ✅ Implementar stored procedures y triggers
3. ✅ Gestionar seguridad y roles de usuario
4. ✅ Optimizar consultas y rendimiento
5. ✅ Crear documentación técnica profesional
6. ✅ Desarrollar arquitectura modular y escalable

---

<div align="center">

**ChinchuLink v1.0**

Gracias por tu interés en nuestro proyecto académico

SQLeaders S.A. | ISTEA 2025

</div>
