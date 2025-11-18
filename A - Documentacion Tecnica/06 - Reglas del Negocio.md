# REGLAS DEL NEGOCIO - SISTEMA CHINCHULINK

## **INFORMACIÓN DEL DOCUMENTO**

| **Campo** | **Descripción** |
|-----------|-----------|
| **Documento** | Reglas del Negocio - Sistema ChinchuLink |
| **Proyecto** | Sistema de Gestión de Pedidos |
| **Cliente** | Parrilla El Encuentro |
| **Desarrollado por** | SQLeaders S.A. |
| **Versión** | 1.0 |
| **Estado** | Implementado y Funcional |

## **RESUMEN EJECUTIVO**

### **Objetivo del Documento**
Este documento establece las reglas de negocio implementadas en el sistema ChinchuLink, definiendo las políticas operativas, restricciones funcionales y validaciones automáticas que gobiernan el funcionamiento del restaurante. Estas reglas aseguran la integridad de los datos y la consistencia operacional del sistema.

### **Alcance de las Reglas**
- **Gestión de pedidos** y flujos operativos
- **Validaciones de integridad** de datos y procesos
- **Políticas de precios** y promociones
- **Reglas organizacionales** de personal y sucursales
- **Controles de seguridad** y auditoría

---

## **REGLAS ORGANIZACIONALES**

### **RN-001: Gestión de Personal**
**Descripción:** Control de empleados y asignaciones organizacionales.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-001.1** | Un empleado debe pertenecer a una única sucursal | FK obligatoria EMPLEADO.sucursal_id |
| **RN-001.2** | Un empleado debe tener un rol asignado | FK obligatoria EMPLEADO.rol_id |
| **RN-001.3** | El usuario debe ser único en todo el sistema | UNIQUE constraint en EMPLEADO.usuario |
| **RN-001.4** | Solo empleados activos pueden tomar pedidos | Validación en sp_CrearPedido |
| **RN-001.5** | La contraseña debe estar hasheada | Campo hash_password, nunca texto plano |

### **RN-002: Gestión de Sucursales**
**Descripción:** Reglas para múltiples ubicaciones y mesas.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-002.1** | Cada sucursal debe tener un nombre único | UNIQUE constraint en SUCURSAL.nombre |
| **RN-002.2** | Las mesas pertenecen a una única sucursal | FK obligatoria MESA.sucursal_id |
| **RN-002.3** | Número de mesa único por sucursal | UNIQUE constraint (numero, sucursal_id) |
| **RN-002.4** | Cada mesa debe tener código QR único | UNIQUE constraint en MESA.qr_token |
| **RN-002.5** | La capacidad de mesa debe ser positiva | CHECK constraint capacidad > 0 |

---

## **REGLAS DE PRODUCTOS Y PRECIOS**

### **RN-003: Catálogo de Productos**
**Descripción:** Gestión del menú y productos del restaurante.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-003.1** | Cada plato debe tener nombre único | UNIQUE constraint en PLATO.nombre |
| **RN-003.2** | Solo platos activos pueden venderse | Validación en lógica de pedidos |
| **RN-003.3** | Todo plato debe tener una categoría | Campo PLATO.categoria NOT NULL |
| **RN-003.4** | Los combos deben tener nombre único | UNIQUE constraint en COMBO.nombre |
| **RN-003.5** | Un combo debe incluir al menos un plato | Validación en COMBO_DETALLE |

### **RN-004: Gestión de Precios**
**Descripción:** Políticas de precios y vigencias temporales.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-004.1** | Los precios no pueden ser negativos | CHECK constraint precio >= 0 |
| **RN-004.2** | Todo precio debe tener fecha de inicio | PRECIO.vigencia_desde NOT NULL |
| **RN-004.3** | Fecha de fin debe ser posterior al inicio | CHECK constraint vigencia_hasta >= vigencia_desde |
| **RN-004.4** | Se debe mantener histórico de precios | No eliminar registros de PRECIO |
| **RN-004.5** | Un plato puede tener múltiples precios vigentes | Permitir solapamiento temporal controlado |

### **RN-005: Promociones y Descuentos**
**Descripción:** Gestión de ofertas y promociones especiales.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-005.1** | Las promociones deben tener nombre único | UNIQUE constraint en PROMOCION.nombre |
| **RN-005.2** | Las promociones deben tener tipo definido | PROMOCION.tipo NOT NULL |
| **RN-005.3** | Solo promociones activas pueden aplicarse | Validación en lógica de pedidos |
| **RN-005.4** | Una promoción puede aplicar a múltiples platos | Relación N:M en PROMOCION_PLATO |
| **RN-005.5** | Las reglas de promoción se almacenan como JSON | Campo PROMOCION.regla_json |

---

## **REGLAS DE PEDIDOS Y VENTAS**

### **RN-006: Creación de Pedidos**
**Descripción:** Validaciones y controles en el proceso de pedidos.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-006.1** | Todo pedido debe tener un canal de venta | FK obligatoria PEDIDO.canal_id |
| **RN-006.2** | Todo pedido debe tener un empleado responsable | FK obligatoria PEDIDO.tomado_por_empleado_id |
| **RN-006.3** | Todo pedido inicia en estado "Pendiente" | Asignación automática en sp_CrearPedido |
| **RN-006.4** | Pedidos de mesa requieren mesa asignada | Validación condicional por canal |
| **RN-006.5** | Pedidos delivery requieren cliente y domicilio | Validación condicional por canal |

### **RN-007: Estados de Pedidos**
**Descripción:** Control del flujo operativo de pedidos.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-007.1** | Los estados deben seguir un orden secuencial | Campo ESTADO_PEDIDO.orden |
| **RN-007.2** | Solo se puede avanzar al siguiente estado | Validación en sp_ActualizarEstadoPedido |
| **RN-007.3** | Estados únicos con nombres únicos | UNIQUE constraints en nombre y orden |
| **RN-007.4** | Pedidos entregados requieren empleado de entrega | Validación en transición a "Entregado" |
| **RN-007.5** | Cambios de estado se auditan automáticamente | Triggers de auditoría |

### **RN-008: Detalles de Pedidos**
**Descripción:** Validaciones para líneas de productos en pedidos.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-008.1** | Cada detalle debe incluir plato O combo, no ambos | CHECK constraint XOR lógico |
| **RN-008.2** | Las cantidades deben ser positivas | CHECK constraint cantidad > 0 |
| **RN-008.3** | Los precios unitarios no pueden ser negativos | CHECK constraint precio_unitario >= 0 |
| **RN-008.4** | Los subtotales no pueden ser negativos | CHECK constraint subtotal >= 0 |
| **RN-008.5** | El subtotal debe ser cantidad × precio_unitario | Validación en sp_AgregarDetalePedido |

---

## **REGLAS DE CLIENTES Y DELIVERY**

### **RN-009: Gestión de Clientes**
**Descripción:** Políticas para clientes registrados y delivery.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-009.1** | El email debe ser único si se proporciona | UNIQUE constraint en CLIENTE.email |
| **RN-009.2** | La combinación documento debe ser única | UNIQUE constraint (doc_tipo, doc_nro) |
| **RN-009.3** | Todo cliente debe tener un nombre | CLIENTE.nombre NOT NULL |
| **RN-009.4** | Los datos de contacto son opcionales | Campos NULL permitidos |
| **RN-009.5** | Un cliente puede tener múltiples domicilios | Relación 1:N CLIENTE-DOMICILIO |

### **RN-010: Domicilios de Entrega**
**Descripción:** Gestión de direcciones para delivery.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-010.1** | Todo domicilio debe pertenecer a un cliente | FK obligatoria DOMICILIO.cliente_id |
| **RN-010.2** | Calle y número son obligatorios | NOT NULL constraints |
| **RN-010.3** | Localidad y provincia son obligatorias | NOT NULL constraints |
| **RN-010.4** | Piso y departamento son opcionales | Campos NULL permitidos |
| **RN-010.5** | Un cliente puede marcar un domicilio principal | Campo DOMICILIO.es_principal |

---

## **REGLAS DE AUDITORÍA Y SEGURIDAD**

### **RN-011: Trazabilidad**
**Descripción:** Control de cambios y auditoría del sistema.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-011.1** | Todos los pedidos se auditan automáticamente | Trigger en tabla PEDIDO |
| **RN-011.2** | Los cambios de estado se registran | Campo AUDITORIA.operacion |
| **RN-011.3** | Se debe registrar el usuario de cada cambio | AUDITORIA.usuario NOT NULL |
| **RN-011.4** | Fecha automática en cada registro de auditoría | DEFAULT GETDATE() |
| **RN-011.5** | Los datos anteriores se preservan en JSON | Campo AUDITORIA.datos_anteriores |

### **RN-012: Integridad del Sistema**
**Descripción:** Validaciones para mantener consistencia de datos.

| **Código** | **Regla** | **Implementación** |
|------------|-----------|-------------------|
| **RN-012.1** | No se permiten eliminaciones en cascada | RESTRICT en Foreign Keys críticas |
| **RN-012.2** | Los totales deben calcularse automáticamente | Triggers de actualización |
| **RN-012.3** | Las fechas de pedido se asignan automáticamente | DEFAULT GETDATE() |
| **RN-012.4** | Solo empleados de la misma sucursal atienden mesas | Validación cruzada en sp_CrearPedido |
| **RN-012.5** | Los históricos de precios nunca se eliminan | Política de retención |

---

## **VALIDACIONES IMPLEMENTADAS**

### **Validaciones de Integridad Referencial**
- **23 Foreign Keys** implementadas para garantizar consistencia
- **Validaciones cruzadas** entre sucursal de empleado y mesa
- **Controles de existencia** antes de crear relaciones

### **Validaciones de Dominio**
- **CHECK Constraints** para valores positivos y lógicos
- **UNIQUE Constraints** para evitar duplicados
- **Validaciones de formato** en campos críticos

### **Validaciones de Negocio**
- **Stored Procedures** con lógica de validación completa
- **Estados secuenciales** en flujo de pedidos
- **Controles temporales** para precios y promociones

---

**Documento generado por SQLeaders S.A.**  
**Versión: 1.0 - 2025**  
