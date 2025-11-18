# GLOSARIO DE TÉRMINOS - SISTEMA CHINCHULINK

## **INFORMACIÓN DEL DOCUMENTO**

| **Campo** | **Descripción** |
|-----------|-----------|
| **Documento** | Glosario de Términos - Sistema ChinchuLink |
| **Proyecto** | Sistema de Gestión de Pedidos |
| **Cliente** | Parrilla El Encuentro |
| **Desarrollado por** | SQLeaders S.A. |
| **Versión** | 1.0 |
| **Estado** | Implementado y Funcional |

## **RESUMEN EJECUTIVO**

### **Objetivo del Documento**
Este glosario define todos los términos técnicos, conceptos de negocio y abreviaciones utilizadas en el sistema ChinchuLink y su documentación. Proporciona una referencia unificada para asegurar la comprensión consistente de la terminología empleada en el proyecto, facilitando la comunicación entre desarrolladores, usuarios finales y stakeholders.

### **Alcance del Glosario**
- **Términos técnicos** de base de datos y desarrollo
- **Conceptos de negocio** del dominio gastronómico
- **Abreviaciones** y acrónimos del proyecto
- **Roles y permisos** del sistema
- **Flujos operativos** y estados

---

## **TÉRMINOS GENERALES DEL SISTEMA**

| **Término** | **Definición** | **Contexto** |
|-------------|----------------|--------------|
| **ChinchuLink** | Nombre del sistema de gestión integral para restaurantes desarrollado por SQLeaders S.A. | Sistema |
| **Bundle** | Conjunto de scripts SQL agrupados por funcionalidad específica (ej: Bundle_A1_BaseDatos_Estructura.sql) | Desarrollo |
| **DER** | Diagrama Entidad-Relación. Representación gráfica de la estructura de la base de datos | Documentación |
| **FK** | Foreign Key (Clave Foránea). Campo que establece relación entre dos tablas | Base de datos |
| **PK** | Primary Key (Clave Primaria). Campo único identificador de cada registro en una tabla | Base de datos |
| **SP** | Stored Procedure. Procedimiento almacenado en la base de datos | Base de datos |
| **UK** | Unique Key (Clave Única). Restricción que garantiza valores únicos en un campo | Base de datos |
| **MVP** | Minimum Viable Product. Versión mínima funcional del sistema | Desarrollo |

---

## **TÉRMINOS DE NEGOCIO**

### **Gestión de Pedidos**

| **Término** | **Definición** | **Ejemplo** |
|-------------|----------------|-------------|
| **Pedido** | Solicitud de productos realizada por un cliente en el restaurante | Pedido #1001 con 2 platos principales |
| **Detalle de Pedido** | Línea individual dentro de un pedido que especifica producto, cantidad y precio | 2x Bife de Chorizo - $15.000 |
| **Canal de Venta** | Modalidad por la cual se realiza el pedido | Mesa, Mostrador, Delivery |
| **Estado de Pedido** | Situación actual en el flujo operativo del pedido | Pendiente, En Preparación, Listo, Entregado |
| **Comensales** | Número de personas que consumirán en un pedido de mesa | Mesa para 4 comensales |
| **QR Token** | Código QR único asignado a cada mesa para identificación | QR: MESA001-SUCURSAL1 |

### **Productos y Precios**

| **Término** | **Definición** | **Ejemplo** |
|-------------|----------------|-------------|
| **Plato** | Producto individual del menú del restaurante | Bife de Chorizo, Ensalada Caesar |
| **Combo** | Oferta que agrupa múltiples platos a un precio especial | Combo Parrilla: Bife + Papas + Bebida |
| **Categoría** | Clasificación de productos del menú | Carnes, Ensaladas, Bebidas, Postres |
| **Promoción** | Descuento o oferta especial aplicable a productos específicos | 20% off en bebidas |
| **Vigencia** | Período de tiempo en que un precio o promoción está activo | Del 01/11/2025 al 30/11/2025 |
| **Precio Unitario** | Costo individual de un producto al momento de la venta | $8.500 por Bife de Chorizo |

### **Organización y Personal**

| **Término** | **Definición** | **Ejemplo** |
|-------------|----------------|-------------|
| **Sucursal** | Ubicación física del restaurante | Parrilla El Encuentro - Sucursal Centro |
| **Empleado** | Personal del restaurante con acceso al sistema | Juan Pérez - Mesero |
| **Rol** | Función o cargo que define los permisos de un empleado | Administrador, Mesero, Cocinero, Cajero |
| **Mesa** | Ubicación física donde se atienden clientes en el restaurante | Mesa 5 - Capacidad 6 personas |
| **Usuario** | Identificador único para acceso al sistema | jperez2025 |

### **Clientes y Delivery**

| **Término** | **Definición** | **Ejemplo** |
|-------------|----------------|-------------|
| **Cliente** | Persona que realiza pedidos en el restaurante | María González |
| **Domicilio** | Dirección de entrega para pedidos de delivery | Av. Corrientes 1234, CABA |
| **Delivery** | Modalidad de entrega de pedidos en el domicilio del cliente | Pedido entregado en 45 minutos |
| **Domicilio Principal** | Dirección preferencial de un cliente para entregas | Marcado como dirección por defecto |

---

## **TÉRMINOS TÉCNICOS**

### **Base de Datos**

| **Término** | **Definición** | **Implementación en ChinchuLink** |
|-------------|----------------|------------------------------------|
| **IDENTITY** | Campo autoincremental que genera valores únicos automáticamente | Todos los IDs principales (pedido_id, cliente_id, etc.) |
| **NOT NULL** | Restricción que impide valores nulos en un campo | Campos obligatorios como nombres y fechas |
| **DEFAULT** | Valor asignado automáticamente cuando no se especifica | fecha_pedido DEFAULT GETDATE() |
| **CHECK Constraint** | Restricción que valida condiciones específicas | precio >= 0, cantidad > 0 |
| **UNIQUE Constraint** | Restricción que garantiza valores únicos | email único, usuario único |
| **Trigger** | Código que se ejecuta automáticamente ante eventos en la BD | Auditoría automática en cambios |
| **Cascade** | Acción automática en tablas relacionadas ante cambios | Políticas de eliminación y actualización |

### **Desarrollo y Arquitectura**

| **Término** | **Definición** | **Uso en ChinchuLink** |
|-------------|----------------|------------------------|
| **Normalización** | Proceso de organización de datos para eliminar redundancias | Implementado hasta 3FN |
| **3FN** | Tercera Forma Normal. Nivel de normalización de base de datos | Estándar aplicado en todas las tablas |
| **Integridad Referencial** | Mantenimiento de consistencia entre tablas relacionadas | 23 Foreign Keys implementadas |
| **Audit Trail** | Registro histórico de cambios realizados en el sistema | Tabla AUDITORIA con todos los cambios |
| **JSON** | Formato de intercambio de datos estructurados | Almacenamiento de reglas de promociones |
| **Hash** | Algoritmo de encriptación unidireccional | Almacenamiento seguro de contraseñas |

---

## **ROLES Y PERMISOS**

### **Roles del Sistema**

| **Rol** | **Descripción** | **Permisos Principales** |
|---------|-----------------|--------------------------|
| **Administrador** | Control total del sistema | Crear usuarios, modificar configuraciones, acceso completo |
| **Gerente** | Gestión operativa del restaurante | Reportes, configuración de precios, gestión de personal |
| **Cajero** | Manejo de pagos y cierre de caja | Procesar pagos, consultar pedidos, reportes de ventas |
| **Mesero** | Atención de mesas y toma de pedidos | Crear pedidos, consultar estados, gestión de mesas |
| **Cocinero** | Gestión de preparación de pedidos | Actualizar estados de pedidos, consultar productos |
| **Delivery** | Gestión de entregas a domicilio | Consultar pedidos, actualizar estado de entrega |
| **Auditor** | Revisión y control de procesos | Solo lectura, acceso a reportes y auditoría |

---

## **ESTADOS Y FLUJOS**

### **Estados de Pedidos**

| **Estado** | **Orden** | **Descripción** | **Acción Requerida** |
|------------|-----------|-----------------|---------------------|
| **Pendiente** | 1 | Pedido creado, esperando preparación | Iniciar preparación |
| **En Preparación** | 2 | Pedido siendo preparado por cocina | Finalizar preparación |
| **Listo** | 3 | Pedido terminado, listo para entrega | Entregar al cliente |
| **Entregado** | 4 | Pedido entregado al cliente | Proceso completado |
| **Cancelado** | - | Pedido cancelado por algún motivo | No requiere acción |

### **Canales de Venta**

| **Canal** | **Descripción** | **Validaciones Específicas** |
|-----------|-----------------|-------------------------------|
| **Mesa** | Pedido realizado en mesa del restaurante | Requiere mesa_id válida |
| **Mostrador** | Pedido para llevar en mostrador | No requiere mesa ni cliente |
| **Delivery** | Pedido con entrega a domicilio | Requiere cliente_id y domicilio_id |

---

## **ABREVIACIONES Y ACRÓNIMOS**

### **Técnicas**

| **Abreviación** | **Significado** | **Contexto** |
|-----------------|-----------------|--------------|
| **BD** | Base de Datos | Documentación técnica |
| **CRUD** | Create, Read, Update, Delete | Operaciones básicas |
| **SQL** | Structured Query Language | Lenguaje de consulta |
| **ER** | Entity-Relationship | Modelado de datos |
| **API** | Application Programming Interface | Integración de sistemas |
| **UI** | User Interface | Interfaz de usuario |
| **UX** | User Experience | Experiencia de usuario |

### **De Negocio**

| **Abreviación** | **Significado** | **Contexto** |
|-----------------|-----------------|--------------|
| **POS** | Point of Sale | Sistema de punto de venta |
| **CRM** | Customer Relationship Management | Gestión de relaciones con clientes |
| **SKU** | Stock Keeping Unit | Identificador de producto |
| **ERP** | Enterprise Resource Planning | Planificación de recursos empresariales |

---

## **MÉTRICAS Y UNIDADES**

### **Tiempos**

| **Unidad** | **Descripción** | **Uso en ChinchuLink** |
|------------|-----------------|------------------------|
| **Tiempo de Preparación** | Minutos desde pedido hasta listo | Medición de eficiencia de cocina |
| **Tiempo de Entrega** | Minutos desde listo hasta entregado | Control de calidad de servicio |
| **Tiempo Total** | Duración completa del proceso | KPI principal de satisfacción |

### **Financieras**

| **Término** | **Descripción** | **Formato** |
|-------------|-----------------|-------------|
| **Subtotal** | Cantidad × Precio unitario por ítem | DECIMAL(10,2) |
| **Total** | Suma de todos los subtotales del pedido | DECIMAL(10,2) |
| **Precio Vigente** | Precio actual aplicable según fecha | Consultado en tiempo real |

---

**Documento generado por SQLeaders S.A.**  
**Versión: 1.0 - 2025**  
