# REPORTES Y DASHBOARD - ChinchuLink

**Orden de ejecución:** PASO 5 (FINAL)  
**Dependencias:** Pasos 1, 2, 3 y 4 COMPLETADOS  

## CONTENIDO DE LA CARPETA

### **Bundle_R1_Reportes_Estructuras_SPs.sql**
- **Propósito:** Infraestructura y stored procedures de reportes
- **Tiempo estimado:** 4-5 minutos
- **Contenido:**
  - Tabla REPORTES_GENERADOS
  - 5 Stored procedures de reportes
  - Sistema de almacenamiento histórico
  - Validaciones de prerequisitos

### **Bundle_R2_Reportes_Vistas_Dashboard.sql**
- **Propósito:** Vistas de dashboard y finalización
- **Tiempo estimado:** 2-3 minutos
- **Contenido:**
  - Vista de dashboard ejecutivo
  - Vista de monitoreo en tiempo real
  - Validación completa del sistema
  - Ejemplos de uso

## ORDEN DE EJECUCIÓN CRÍTICO

⚠️ **MUY IMPORTANTE:** R1 debe completarse antes de ejecutar R2

1. **PRIMERO:** Bundle_R1_Reportes_Estructuras_SPs.sql
2. **SEGUNDO:** Bundle_R2_Reportes_Vistas_Dashboard.sql

## STORED PROCEDURES DE REPORTES

### **Reportes Diarios**
- `sp_ReporteVentasDiario` - Análisis completo de ventas diarias
- `sp_PlatosMasVendidosDiario` - Top platos del día
- `sp_RendimientoCanalDiario` - Performance por canal de venta

### **Reportes Mensuales**
- `sp_AnalisisVentasMensual` - Análisis completo mensual
- `sp_RankingProductosMensual` - Top productos del mes

## VISTAS DE DASHBOARD

### **vw_DashboardEjecutivo**
- **Propósito:** Métricas ejecutivas en tiempo real
- **Contenido:**
  - Ventas del día y del mes
  - Ticket promedio
  - Plato más vendido
  - Estado operativo general

### **vw_MonitoreoTiempoReal**
- **Propósito:** Monitoreo operativo continuo
- **Contenido:**
  - Pedidos por estado
  - Mesas ocupadas
  - Personal activo
  - Ventas acumuladas

## EJEMPLOS DE USO

### **Reportes Básicos**
```sql
-- Reporte de ventas de hoy
EXEC sp_ReporteVentasDiario

-- Top 5 platos más vendidos hoy
EXEC sp_PlatosMasVendidosDiario @top_cantidad = 5

-- Rendimiento por canal hoy
EXEC sp_RendimientoCanalDiario
```

### **Reportes con Parámetros**
```sql
-- Ventas de una fecha específica para una sucursal
EXEC sp_ReporteVentasDiario 
    @fecha = '2025-11-13', 
    @sucursal_id = 1,
    @guardar_reporte = 1

-- Análisis mensual con guardado
EXEC sp_AnalisisVentasMensual 
    @año = 2025, 
    @mes = 11,
    @guardar_reporte = 1
```

### **Dashboard en Tiempo Real**
```sql
-- Dashboard ejecutivo
SELECT * FROM vw_DashboardEjecutivo

-- Monitoreo operativo
SELECT * FROM vw_MonitoreoTiempoReal

-- Reportes guardados históricos
SELECT * FROM REPORTES_GENERADOS 
ORDER BY fecha_generacion DESC
```

## VALIDACIÓN COMPLETA

```sql
-- Verificar stored procedures de reportes
SELECT COUNT(*) as ReportSPs
FROM sys.objects 
WHERE type = 'P' 
AND name IN (
    'sp_ReporteVentasDiario',
    'sp_PlatosMasVendidosDiario', 
    'sp_RendimientoCanalDiario',
    'sp_AnalisisVentasMensual',
    'sp_RankingProductosMensual'
)
-- Esperado: 5

-- Verificar vistas de dashboard
SELECT COUNT(*) as DashboardViews
FROM sys.views
WHERE name IN ('vw_DashboardEjecutivo', 'vw_MonitoreoTiempoReal')
-- Esperado: 2

-- Verificar tabla de reportes
SELECT COUNT(*) as ReportStorage
FROM INFORMATION_SCHEMA.TABLES 
WHERE TABLE_NAME = 'REPORTES_GENERADOS'
-- Esperado: 1
```

## FUNCIONALIDADES COMPLETAS

- **Sistema completo de reportes** diarios y mensuales
- **Dashboard ejecutivo** en tiempo real
- **Monitoreo operativo** continuo
- **Almacenamiento histórico** de reportes
- **Análisis comparativo** vs períodos anteriores
- **Métricas de performance** por canal y producto

## PRÓXIMOS PASOS RECOMENDADOS

1. **SQL Server Agent:** Configurar jobs automáticos para reportes diarios
2. **Alertas:** Implementar notificaciones por email
3. **Integración:** Conectar con aplicaciones de visualización (Power BI, etc.)
4. **Archivado:** Configurar limpieza automática de reportes antiguos

## TROUBLESHOOTING

**Error común:** "sp_ReporteVentasDiario not found" en Bundle_R2
- **Solución:** Verificar que Bundle_R1 se ejecutó completamente sin errores