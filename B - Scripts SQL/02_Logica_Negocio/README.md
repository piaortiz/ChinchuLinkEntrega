# LÓGICA DE NEGOCIO - ChinchuLink

**Orden de ejecución:** PASO 2  
**Dependencias:** 01_Infraestructura_Base COMPLETADO  

## CONTENIDO DE LA CARPETA

### **Bundle_B1_Pedidos_Core.sql**
- **Propósito:** Stored procedures principales de pedidos
- **Tiempo estimado:** 3-4 minutos
- **Contenido:**
  - sp_CrearPedido
  - sp_AgregarItemPedido  
  - sp_ModificarPedido
  - Validaciones de negocio core

### **Bundle_B2_Items_Calculos.sql**
- **Propósito:** Lógica de cálculos y precios
- **Tiempo estimado:** 2-3 minutos
- **Contenido:**
  - Cálculo de subtotales
  - Aplicación de promociones
  - Cálculo de totales finales
  - Funciones de pricing

### **Bundle_B3_Estados_Finalizacion.sql**
- **Propósito:** Control de estados y finalización
- **Tiempo estimado:** 2-3 minutos
- **Contenido:**
  - Transiciones de estado
  - Validaciones de finalización
  - Procesos de entrega
  - Cancelación de pedidos

## ORDEN DE EJECUCIÓN CRÍTICO

⚠️ **IMPORTANTE:** El orden es estrictamente necesario

1. **PRIMERO:** Bundle_B1_Pedidos_Core.sql
2. **SEGUNDO:** Bundle_B2_Items_Calculos.sql  
3. **TERCERO:** Bundle_B3_Estados_Finalizacion.sql

## VALIDACIÓN

```sql
-- Verificar stored procedures creados
SELECT COUNT(*) as StoredProcedures
FROM sys.objects 
WHERE type = 'P' AND name LIKE 'sp_%'
-- Esperado: 15+

-- Probar funcionalidad básica
EXEC sp_CrearPedido 
    @canal_id = 1, 
    @mesa_id = 1, 
    @empleado_id = 1, 
    @cant_comensales = 2
```

## FUNCIONALIDADES IMPLEMENTADAS

- **Gestión completa de pedidos**
- **Cálculos automáticos de precios**
- **Control de estados del workflow**
- **Validaciones de integridad de negocio**
- **Manejo de promociones y descuentos**