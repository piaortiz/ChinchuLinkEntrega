# DICCIONARIO DE DATOS - ChinchuLink 

## **INFORMACIÓN DEL DOCUMENTO**

| **Campo** | **Descripción** |
|-----------|-----------|
| **Documento** | Diccionario de Datos - Sistema ChinchuLink |
| **Proyecto** | Sistema de Gestión de Pedidos |
| **Cliente** | Parrilla El Encuentro |
| **Desarrollado por** | SQLeaders S.A. |
| **Versión** | 1.0 |
| **Estado** | Implementado y Funcional |



## **RESUMEN EJECUTIVO**

### **Estadísticas Generales**

| **Métrica** | **Valor** | **Descripción** |
|-------------|-----------|-----------------|
| **Tablas** | 21 | Entidades principales del sistema |
| **Campos** | 120+ | Total de atributos en todas las tablas |
| **Claves Primarias** | 21 | Una por tabla |
| **Claves Foráneas** | 18 | Referencias entre tablas |
| **Índices** | 12+ | Índices de performance |
| **Triggers** | 8 | Automatizaciones y validaciones |
| **Stored Procedures** | 13+ | Procedimientos principales implementados |

### **Distribución por Módulos**

| **Módulo** | **Tablas** | **Descripción** |
|------------|------------|-----------------|
| **Core Catálogos** | 5 | SUCURSAL, CANAL_VENTA, ESTADO_PEDIDO, ROL, PLATO |
| **Gestión Personal** | 2 | MESA, EMPLEADO |
| **Clientes** | 2 | CLIENTE, DOMICILIO |
| **Productos y Precios** | 4 | PRECIO, COMBO, COMBO_DETALLE, PROMOCION |
| **Operaciones** | 3 | PEDIDO, DETALLE_PEDIDO, PROMOCION_PLATO |
| **Auditoría y Control** | 3 | AUDITORIA, AUDITORIA_SIMPLE, STOCK_SIMULADO |
| **Reportes y Notificaciones** | 2 | REPORTES_GENERADOS, NOTIFICACIONES |

---

## **TABLA DE REFERENCIA - TIPOS DE DATOS**

### **Tipos de Datos SQL Server Utilizados**

| **Tipo** | **Descripción** | **Rango/Tamaño** | **Uso en ChinchuLink** | **Ejemplo** |
|----------|-----------------|------------------|------------------------|-------------|
| **INT** | Entero de 32 bits | -2,147,483,648 a 2,147,483,647 | IDs, números, cantidades | `empleado_id INT` |
| **IDENTITY** | Autonumérico | Incremento automático | Claves primarias | `IDENTITY(1,1)` |
| **NVARCHAR(n)** | Cadena Unicode variable | 1 a 4,000 caracteres | Textos, nombres | `nombre NVARCHAR(100)` |
| **NVARCHAR(MAX)** | Cadena Unicode extendida | Hasta 2GB | Textos largos, JSON | `regla_json NVARCHAR(MAX)` |
| **BIT** | Booleano | 0 o 1 | Estados activo/inactivo | `activo BIT DEFAULT 1` |
| **DECIMAL(p,s)** | Número decimal preciso | Precisión y escala fijas | Precios, totales | `precio DECIMAL(10,2)` |
| **DATETIME** | Fecha y hora | 1753-01-01 a 9999-12-31 | Fechas de operación | `fecha_pedido DATETIME` |
| **DATE** | Solo fecha | 0001-01-01 a 9999-12-31 | Vigencias, períodos | `vigencia_desde DATE` |

### **Convenciones de Nomenclatura**

| **Elemento** | **Convención** | **Ejemplo** | **Descripción** |
|--------------|----------------|-------------|-----------------|
| **Tablas** | MAYÚSCULAS | `PEDIDO`, `DETALLE_PEDIDO` | Nombres descriptivos en singular |
| **Campos ID** | tabla_id | `pedido_id`, `cliente_id` | Identificadores únicos |
| **Claves Foráneas** | tabla_referencia_id | `sucursal_id`, `empleado_id` | Referencias a otras tablas |
| **Campos Booleanos** | adjetivo | `activo`, `es_principal` | Estados o características |
| **Fechas** | fecha_accion | `fecha_pedido`, `vigencia_desde` | Momentos o períodos |
| **Amounts/Money** | sustantivo | `precio`, `total`, `subtotal` | Valores monetarios |
| **Restricciones PK** | PK_TABLA | `PK_PEDIDO` | Claves primarias |
| **Restricciones FK** | FK_TABLA_campo | `FK_PEDIDO_cliente` | Claves foráneas |
| **Restricciones UK** | UK_TABLA_campo | `UK_MESA_qr_token` | Claves únicas |
| **Restricciones CHK** | CHK_TABLA_campo | `CHK_PRECIO_precio` | Validaciones |

### **Consideraciones Especiales**

| **Tipo** | **Consideración** | **Aplicación en ChinchuLink** |
|----------|-------------------|-------------------------------|
| **NVARCHAR vs VARCHAR** | NVARCHAR soporta Unicode | Usado para nombres, direcciones (caracteres especiales) |
| **DECIMAL(10,2)** | Precisión monetaria | Precios con 2 decimales, hasta 99,999,999.99 |
| **BIT DEFAULT 1** | Estados por defecto | Registros activos por defecto |
| **DATETIME DEFAULT GETDATE()** | Timestamp automático | Fechas de creación automáticas |
| **Campos Nullable** | SÍ/NO en diccionario | Campos opcionales vs obligatorios |
| **IDENTITY(1,1)** | Incremento automático | Comienza en 1, incrementa de 1 en 1 |


---

## **DICCIONARIO DETALLADO POR TABLA**

---

### **1. TABLA: SUCURSAL**
**Propósito:** Almacena información de las sucursales del restaurante  
**Tipo:** Entidad maestra  
**Relaciones:** Centro del sistema (Hub)

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **sucursal_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de sucursal |
| **nombre** | NVARCHAR | 100 | NO | UQ | - | Nombre comercial de la sucursal |
| **direccion** | NVARCHAR | 255 | NO | - | - | Dirección física completa |

**Restricciones:**
- `PK_SUCURSAL`: Clave primaria en sucursal_id
- `UK_SUCURSAL_nombre`: Nombre único por sucursal

---

### **2. TABLA: CANAL_VENTA**
**Propósito:** Define los canales de venta disponibles (Mostrador, Delivery, Mesa QR, etc.)  
**Tipo:** Catálogo de valores  
**Relaciones:** Utilizado en PEDIDOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **canal_id** | INT | 4 | NO | PK | IDENTITY | Identificador único del canal |
| **nombre** | NVARCHAR | 50 | NO | UQ | - | Nombre del canal (Mostrador, Delivery, Mesa QR, etc.) |

**Restricciones:**
- `PK_CANAL_VENTA`: Clave primaria en canal_id
- `UK_CANAL_VENTA_nombre`: Nombre único de canal

**Valores estándar:**
- Mostrador, Delivery, Mesa QR, Teléfono, App Móvil

---

### **3. TABLA: ESTADO_PEDIDO**
**Propósito:** Estados del flujo de pedidos  
**Tipo:** Catálogo de estados  
**Relaciones:** Controla el flujo de PEDIDOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **estado_id** | INT | 4 | NO | PK | IDENTITY | Identificador único del estado |
| **nombre** | NVARCHAR | 50 | NO | UQ | - | Nombre descriptivo del estado |
| **orden** | INT | 4 | NO | UQ | - | Orden de secuencia del estado |

**Restricciones:**
- `PK_ESTADO_PEDIDO`: Clave primaria en estado_id
- `UK_ESTADO_PEDIDO_nombre`: Nombre único del estado
- `UK_ESTADO_PEDIDO_orden`: Orden único de secuencia

**Estados estándar:**
- Pendiente (1), Confirmado (2), En Preparación (3), Listo (4), En Reparto (5), Entregado (6), Cerrado (7), Cancelado (99)

---

### **4. TABLA: ROL**
**Propósito:** Roles de usuarios del sistema  
**Tipo:** Catálogo de roles  
**Relaciones:** Asignado a EMPLEADOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **rol_id** | INT | 4 | NO | PK | IDENTITY | Identificador único del rol |
| **nombre** | NVARCHAR | 50 | NO | UQ | - | Nombre del rol |
| **descripcion** | NVARCHAR | 255 | SÍ | - | - | Descripción detallada del rol |

**Restricciones:**
- `PK_ROL`: Clave primaria en rol_id
- `UK_ROL_nombre`: Nombre único del rol

**Roles estándar:**
- Administrador, Gerente, Mozo, Cajero, Cocinero, Repartidor, Hostess

---

### **5. TABLA: MESA**
**Propósito:** Define las mesas disponibles en cada sucursal  
**Tipo:** Entidad operacional  
**Relaciones:** Pertenece a SUCURSAL, utilizada en PEDIDOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **mesa_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de mesa |
| **numero** | INT | 4 | NO | - | - | Número de mesa dentro de sucursal |
| **capacidad** | INT | 4 | NO | CHK | - | Número máximo de comensales |
| **sucursal_id** | INT | 4 | NO | FK | - | Referencia a sucursal |
| **qr_token** | NVARCHAR | 255 | NO | UQ | - | Token único para QR de la mesa |
| **activa** | BIT | 1 | NO | - | 1 | Mesa disponible para uso |

**Restricciones:**
- `PK_MESA`: Clave primaria en mesa_id
- `FK_MESA_sucursal`: Clave foránea a SUCURSAL(sucursal_id)
- `UK_MESA_numero_sucursal`: Número único por sucursal
- `UK_MESA_qr_token`: Token QR único
- `CHK_Mesa_Capacidad`: Capacidad > 0

---

### **6. TABLA: EMPLEADO**
**Propósito:** Información del personal del restaurante  
**Tipo:** Entidad maestra  
**Relaciones:** Pertenece a SUCURSAL y ROL, opera PEDIDOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **empleado_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de empleado |
| **nombre** | NVARCHAR | 100 | NO | - | - | Nombre completo del empleado |
| **usuario** | NVARCHAR | 50 | NO | UQ | - | Usuario para login |
| **hash_password** | NVARCHAR | 255 | NO | - | - | Contraseña encriptada |
| **rol_id** | INT | 4 | NO | FK | - | Rol asignado al empleado |
| **sucursal_id** | INT | 4 | NO | FK | - | Sucursal donde trabaja |
| **activo** | BIT | 1 | NO | - | 1 | Empleado activo |

**Restricciones:**
- `PK_EMPLEADO`: Clave primaria en empleado_id
- `FK_EMPLEADO_rol`: Clave foránea a ROL(rol_id)
- `FK_EMPLEADO_sucursal`: Clave foránea a SUCURSAL(sucursal_id)
- `UK_EMPLEADO_usuario`: Usuario único

---

### **7. TABLA: CLIENTE**
**Propósito:** Información de clientes del restaurante  
**Tipo:** Entidad maestra  
**Relaciones:** Realiza PEDIDOS, tiene DOMICILIOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **cliente_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de cliente |
| **nombre** | NVARCHAR | 100 | NO | - | - | Nombre del cliente |
| **telefono** | NVARCHAR | 20 | SÍ | - | - | Teléfono de contacto |
| **email** | NVARCHAR | 100 | SÍ | UQ | - | Email de contacto |
| **doc_tipo** | NVARCHAR | 10 | SÍ | - | - | Tipo de documento |
| **doc_nro** | NVARCHAR | 20 | SÍ | - | - | Número de documento |

**Restricciones:**
- `PK_CLIENTE`: Clave primaria en cliente_id
- `UK_CLIENTE_email`: Email único cuando no es nulo
- `UK_CLIENTE_documento`: Única combinación tipo-número documento

---

### **8. TABLA: DOMICILIO**
**Propósito:** Direcciones de entrega de clientes  
**Tipo:** Entidad de detalle  
**Relaciones:** Pertenece a CLIENTE, usado en PEDIDOS delivery

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **domicilio_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de domicilio |
| **cliente_id** | INT | 4 | NO | FK | - | Cliente propietario del domicilio |
| **calle** | NVARCHAR | 100 | NO | - | - | Nombre de la calle |
| **numero** | NVARCHAR | 10 | NO | - | - | Número de puerta |
| **piso** | NVARCHAR | 10 | SÍ | - | - | Piso |
| **depto** | NVARCHAR | 10 | SÍ | - | - | Departamento |
| **localidad** | NVARCHAR | 50 | NO | - | - | Localidad |
| **provincia** | NVARCHAR | 50 | NO | - | - | Provincia/Estado |
| **observaciones** | NVARCHAR | 255 | SÍ | - | - | Observaciones adicionales |
| **es_principal** | BIT | 1 | NO | - | 0 | Domicilio principal del cliente |

**Restricciones:**
- `PK_DOMICILIO`: Clave primaria en domicilio_id
- `FK_DOMICILIO_cliente`: Clave foránea a CLIENTE(cliente_id)

---

### **9. TABLA: PLATO**
**Propósito:** Catálogo de platos del restaurante  
**Tipo:** Entidad maestra  
**Relaciones:** Tiene PRECIOS, incluido en PEDIDOS y COMBOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **plato_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de plato |
| **nombre** | NVARCHAR | 100 | NO | UQ | - | Nombre del plato |
| **categoria** | NVARCHAR | 50 | NO | - | - | Categoría del plato |
| **activo** | BIT | 1 | NO | - | 1 | Plato disponible para venta |

**Restricciones:**
- `PK_PLATO`: Clave primaria en plato_id
- `UK_PLATO_nombre`: Nombre único de plato

**Categorías estándar:**
- Carnes, Ensaladas, Guarniciones, Bebidas

---

### **10. TABLA: PRECIO**
**Propósito:** Histórico de precios de platos con vigencias  
**Tipo:** Entidad de configuración temporal  
**Relaciones:** Pertenece a PLATO, controla precios en el tiempo

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **precio_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de precio |
| **plato_id** | INT | 4 | NO | FK | - | Plato al que corresponde el precio |
| **vigencia_desde** | DATE | 3 | NO | - | - | Fecha de inicio de vigencia |
| **vigencia_hasta** | DATE | 3 | SÍ | - | - | Fecha de fin de vigencia |
| **precio** | DECIMAL | 10,2 | NO | CHK | - | Precio del plato en este período |

**Restricciones:**
- `PK_PRECIO`: Clave primaria en precio_id
- `FK_PRECIO_plato`: Clave foránea a PLATO(plato_id)
- `CHK_PRECIO_precio`: precio >= 0
- `CK_PRECIO_vigencia`: vigencia_hasta IS NULL OR vigencia_hasta >= vigencia_desde

---

### **11. TABLA: COMBO**
**Propósito:** Combos de platos con precio especial  
**Tipo:** Entidad de producto compuesto  
**Relaciones:** Agrupa PLATOS, incluido en PEDIDOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **combo_id** | INT | 4 | NO | PK | IDENTITY | Identificador único del combo |
| **nombre** | NVARCHAR | 100 | NO | UQ | - | Nombre del combo |
| **vigencia_desde** | DATE | 3 | NO | - | - | Fecha de inicio de vigencia |
| **vigencia_hasta** | DATE | 3 | SÍ | - | - | Fecha de fin de vigencia |
| **precio_combo** | DECIMAL | 10,2 | NO | CHK | - | Precio especial del combo |
| **activo** | BIT | 1 | NO | - | 1 | Combo disponible |

**Restricciones:**
- `PK_COMBO`: Clave primaria en combo_id
- `UK_COMBO_nombre`: Nombre único de combo
- `CHK_COMBO_precio_combo`: precio_combo >= 0
- `CK_COMBO_vigencia`: vigencia_hasta IS NULL OR vigencia_hasta >= vigencia_desde

---

### **12. TABLA: COMBO_DETALLE**
**Propósito:** Platos incluidos en cada combo  
**Tipo:** Tabla intermedia  
**Relaciones:** Relaciona COMBO con PLATOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **combo_id** | INT | 4 | NO | PK | - | Combo al que pertenece |
| **plato_id** | INT | 4 | NO | PK | - | Plato incluido en el combo |
| **cantidad** | INT | 4 | NO | CHK | - | Cantidad del plato en el combo |

**Restricciones:**
- `PK_COMBO_DETALLE`: Clave primaria compuesta (combo_id, plato_id)
- `FK_COMBO_DETALLE_combo`: Clave foránea a COMBO(combo_id)
- `FK_COMBO_DETALLE_plato`: Clave foránea a PLATO(plato_id)
- `CHK_COMBO_DETALLE_cantidad`: cantidad > 0

---

### **13. TABLA: PROMOCION**
**Propósito:** Promociones y descuentos del restaurante  
**Tipo:** Entidad de configuración comercial  
**Relaciones:** Se aplica a PLATOS, incluida en PEDIDOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **promocion_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de promoción |
| **nombre** | NVARCHAR | 100 | NO | UQ | - | Nombre de la promoción |
| **tipo** | NVARCHAR | 50 | NO | - | - | Tipo de promoción |
| **vigencia_desde** | DATE | 3 | NO | - | - | Inicio de vigencia |
| **vigencia_hasta** | DATE | 3 | SÍ | - | - | Fin de vigencia |
| **activa** | BIT | 1 | NO | - | 1 | Promoción activa |
| **regla_json** | NVARCHAR | MAX | SÍ | - | - | Reglas en formato JSON |

**Restricciones:**
- `PK_PROMOCION`: Clave primaria en promocion_id
- `UK_PROMOCION_nombre`: Nombre único de promoción
- `CK_PROMOCION_vigencia`: vigencia_hasta IS NULL OR vigencia_hasta >= vigencia_desde

---

### **14. TABLA: PROMOCION_PLATO**
**Propósito:** Platos incluidos en promociones  
**Tipo:** Tabla intermedia  
**Relaciones:** Relaciona PROMOCION con PLATOS

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **promocion_id** | INT | 4 | NO | PK | - | Promoción aplicada |
| **plato_id** | INT | 4 | NO | PK | - | Plato incluido en promoción |

**Restricciones:**
- `PK_PROMOCION_PLATO`: Clave primaria compuesta (promocion_id, plato_id)
- `FK_PROMOCION_PLATO_promocion`: Clave foránea a PROMOCION(promocion_id)
- `FK_PROMOCION_PLATO_plato`: Clave foránea a PLATO(plato_id)

---

### **15. TABLA: PEDIDO**
**Propósito:** Registro principal de pedidos del restaurante  
**Tipo:** Entidad transaccional central  
**Relaciones:** Centro del flujo operativo

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **pedido_id** | INT | 4 | NO | PK | IDENTITY | Identificador único de pedido |
| **fecha_pedido** | DATETIME | 8 | NO | - | GETDATE() | Fecha y hora del pedido |
| **fecha_entrega** | DATETIME | 8 | SÍ | - | - | Fecha y hora de entrega real |
| **canal_id** | INT | 4 | NO | FK | - | Canal por el cual se realizó el pedido |
| **mesa_id** | INT | 4 | SÍ | FK | - | Mesa asignada (null para delivery) |
| **cliente_id** | INT | 4 | SÍ | FK | - | Cliente del pedido |
| **domicilio_id** | INT | 4 | SÍ | FK | - | Domicilio de entrega (delivery) |
| **cant_comensales** | INT | 4 | SÍ | - | - | Cantidad de comensales |
| **estado_id** | INT | 4 | NO | FK | - | Estado actual del pedido |
| **tomado_por_empleado_id** | INT | 4 | NO | FK | - | Empleado que tomó el pedido |
| **entregado_por_empleado_id** | INT | 4 | SÍ | FK | - | Empleado que entregó el pedido |
| **total** | DECIMAL | 10,2 | NO | - | 0 | Total final del pedido |
| **observaciones** | NVARCHAR | 500 | SÍ | - | - | Observaciones del pedido |

**Restricciones:**
- `PK_PEDIDO`: Clave primaria en pedido_id
- `FK_PEDIDO_canal`: Clave foránea a CANAL_VENTA(canal_id)
- `FK_PEDIDO_mesa`: Clave foránea a MESA(mesa_id)
- `FK_PEDIDO_cliente`: Clave foránea a CLIENTE(cliente_id)
- `FK_PEDIDO_domicilio`: Clave foránea a DOMICILIO(domicilio_id)
- `FK_PEDIDO_estado`: Clave foránea a ESTADO_PEDIDO(estado_id)
- `FK_PEDIDO_tomado_por`: Clave foránea a EMPLEADO(empleado_id)
- `FK_PEDIDO_entregado_por`: Clave foránea a EMPLEADO(empleado_id)

---

### **16. TABLA: DETALLE_PEDIDO**
**Propósito:** Items individuales de cada pedido  
**Tipo:** Entidad de detalle transaccional  
**Relaciones:** Pertenece a PEDIDO, referencia PLATO o COMBO

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **detalle_id** | INT | 4 | NO | PK | IDENTITY | Identificador único del detalle |
| **pedido_id** | INT | 4 | NO | FK | - | Pedido al que pertenece |
| **plato_id** | INT | 4 | SÍ | FK | - | Plato solicitado (excluyente con combo_id) |
| **combo_id** | INT | 4 | SÍ | FK | - | Combo solicitado (excluyente con plato_id) |
| **cantidad** | INT | 4 | NO | CHK | - | Cantidad del item |
| **precio_unitario** | DECIMAL | 10,2 | NO | CHK | - | Precio al momento del pedido |
| **promocion_id** | INT | 4 | SÍ | FK | - | Promoción aplicada |
| **subtotal** | DECIMAL | 10,2 | NO | CHK | - | Cantidad * precio_unitario |

**Restricciones:**
- `PK_DETALLE_PEDIDO`: Clave primaria en detalle_id
- `FK_DETALLE_PEDIDO_pedido`: Clave foránea a PEDIDO(pedido_id)
- `FK_DETALLE_PEDIDO_plato`: Clave foránea a PLATO(plato_id)
- `FK_DETALLE_PEDIDO_combo`: Clave foránea a COMBO(combo_id)
- `FK_DETALLE_PEDIDO_promocion`: Clave foránea a PROMOCION(promocion_id)
- `CK_DETALLE_PEDIDO_plato_o_combo`: (plato_id IS NOT NULL AND combo_id IS NULL) OR (plato_id IS NULL AND combo_id IS NOT NULL)
- `CHK_DETALLE_PEDIDO_cantidad`: cantidad > 0
- `CHK_DETALLE_PEDIDO_precio`: precio_unitario >= 0
- `CHK_DETALLE_PEDIDO_subtotal`: subtotal >= 0

---

### **17. TABLA: AUDITORIA**
**Propósito:** Registro de auditoría de cambios en pedidos  
**Tipo:** Entidad de auditoría  
**Relaciones:** Registra cambios en PEDIDOS y DETALLES

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **auditoria_id** | INT | 4 | NO | PK | IDENTITY | Identificador único del registro |
| **tabla_afectada** | NVARCHAR | 50 | NO | - | - | Nombre de la tabla modificada |
| **operacion** | NVARCHAR | 10 | NO | - | - | Tipo de operación: INSERT, UPDATE, DELETE |
| **pedido_id** | INT | 4 | SÍ | FK | - | ID del pedido afectado |
| **detalle_id** | INT | 4 | SÍ | - | - | ID del detalle afectado |
| **usuario** | NVARCHAR | 50 | NO | - | - | Usuario que realizó la operación |
| **fecha** | DATETIME | 8 | NO | - | GETDATE() | Fecha y hora de la operación |
| **datos_anteriores** | NVARCHAR | MAX | SÍ | - | - | Valores antes del cambio |
| **datos_nuevos** | NVARCHAR | MAX | SÍ | - | - | Valores después del cambio |

**Restricciones:**
- `PK_AUDITORIA`: Clave primaria en auditoria_id
- `FK_AUDITORIA_pedido`: Clave foránea a PEDIDO(pedido_id)

---

### **18. TABLA: AUDITORIA_SIMPLE**
**Propósito:** Registro simplificado de auditoría para operaciones críticas  
**Tipo:** Entidad de auditoría automática  
**Relaciones:** Poblada automáticamente por triggers

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **auditoria_id** | INT | 4 | NO | PK | IDENTITY | ID único de auditoría |
| **tabla_afectada** | NVARCHAR | 50 | NO | - | - | Nombre de la tabla modificada |
| **registro_id** | INT | 4 | NO | - | - | ID del registro afectado |
| **accion** | VARCHAR | 20 | NO | - | - | INSERT, UPDATE, DELETE |
| **fecha_auditoria** | DATETIME | 8 | NO | - | GETDATE() | Fecha y hora de la operación |
| **usuario_sistema** | VARCHAR | 128 | NO | - | SYSTEM_USER | Usuario que ejecutó la operación |
| **datos_resumen** | NVARCHAR | 500 | SÍ | - | - | Resumen de los cambios |

**Restricciones:**
- `PK_AUDITORIA_SIMPLE`: Clave primaria en auditoria_id

**Índices:**
- Por fecha_auditoria, tabla_afectada

**Poblada por:** Triggers automáticos

---

### **19. TABLA: STOCK_SIMULADO**
**Propósito:** Control simulado de inventario de platos  
**Tipo:** Entidad de control operativo  
**Relaciones:** Referencia PLATO, validada por triggers

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **plato_id** | INT | 4 | NO | PK/FK | - | ID del plato (referencia a PLATO) |
| **stock_disponible** | INT | 4 | NO | - | 100 | Cantidad disponible en stock |
| **stock_minimo** | INT | 4 | NO | - | 10 | Stock mínimo antes de alerta |
| **ultima_actualizacion** | DATETIME | 8 | NO | - | GETDATE() | Última modificación del stock |

**Restricciones:**
- `PK_STOCK_SIMULADO`: Clave primaria en plato_id
- `FK_STOCK_SIMULADO_plato`: Clave foránea a PLATO(plato_id)

**Validaciones:** Triggers validan stock en pedidos

---

### **20. TABLA: REPORTES_GENERADOS**
**Propósito:** Almacenar reportes generados automáticamente  
**Tipo:** Entidad de almacenamiento de reportes  
**Relaciones:** Opcional referencia a SUCURSAL

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **reporte_id** | INT | 4 | NO | PK | IDENTITY | ID único del reporte |
| **tipo_reporte** | NVARCHAR | 50 | NO | - | - | Tipo de reporte generado |
| **fecha_generacion** | DATETIME | 8 | NO | - | GETDATE() | Cuándo se generó el reporte |
| **fecha_reporte** | DATE | 3 | NO | - | - | Fecha de los datos del reporte |
| **sucursal_id** | INT | 4 | SÍ | FK | - | Sucursal del reporte (si aplica) |
| **datos_json** | NVARCHAR | MAX | SÍ | - | - | Datos del reporte en formato JSON |
| **ejecutado_por** | NVARCHAR | 100 | NO | - | SYSTEM_USER | Usuario que generó el reporte |
| **estado** | NVARCHAR | 20 | NO | - | 'COMPLETADO' | COMPLETADO, ERROR, PROCESANDO |
| **observaciones** | NVARCHAR | 500 | SÍ | - | - | Notas adicionales |

**Restricciones:**
- `PK_REPORTES_GENERADOS`: Clave primaria en reporte_id
- `FK_REPORTES_GENERADOS_sucursal`: Clave foránea a SUCURSAL(sucursal_id)

**Índices implementados:**
- IX_REPORTES_tipo_fecha (tipo_reporte, fecha_reporte)
- IX_REPORTES_sucursal (sucursal_id, fecha_reporte) 
- IX_REPORTES_generacion (fecha_generacion DESC)

---

### **21. TABLA: NOTIFICACIONES**
**Propósito:** Sistema de notificaciones automáticas  
**Tipo:** Entidad de comunicación interna  
**Relaciones:** Referencias opcionales sin FK a PEDIDO y MESA

| **Campo** | **Tipo** | **Tamaño** | **Nulo** | **Clave** | **Default** | **Descripción** |
|-----------|----------|------------|-----------|-----------|-------------|-----------------|
| **notificacion_id** | INT | 4 | NO | PK | IDENTITY | ID único de notificación |
| **tipo** | VARCHAR | 50 | NO | - | - | Tipo de notificación |
| **titulo** | NVARCHAR | 200 | NO | - | - | Título de la notificación |
| **mensaje** | NVARCHAR | 500 | NO | - | - | Contenido del mensaje |
| **pedido_id** | INT | 4 | SÍ | - | - | Pedido relacionado (sin FK) |
| **mesa_id** | INT | 4 | SÍ | - | - | Mesa relacionada (sin FK) |
| **prioridad** | VARCHAR | 20 | NO | - | 'NORMAL' | BAJA, NORMAL, ALTA, CRITICA |
| **fecha_creacion** | DATETIME | 8 | NO | - | GETDATE() | Cuándo se creó la notificación |
| **leida** | BIT | 1 | NO | - | 0 | Si fue leída o no |
| **fecha_lectura** | DATETIME | 8 | SÍ | - | - | Cuándo se marcó como leída |
| **usuario_destino** | VARCHAR | 100 | SÍ | - | - | Usuario destinatario |

**Restricciones:**
- `PK_NOTIFICACIONES`: Clave primaria en notificacion_id

**Nota:** Los campos pedido_id y mesa_id son referencias lógicas sin constraint FK para evitar problemas con eliminaciones en cascada

**Poblada por:** Triggers de cambios de estado

---

## **MATRIZ DE RELACIONES**

### **Resumen de Claves Foráneas**

| **Tabla Origen** | **Campo** | **Tabla Destino** | **Campo Destino** | **Cardinalidad** |
|------------------|-----------|-------------------|-------------------|------------------|
| MESA | sucursal_id | SUCURSAL | sucursal_id | N:1 |
| EMPLEADO | rol_id | ROL | rol_id | N:1 |
| EMPLEADO | sucursal_id | SUCURSAL | sucursal_id | N:1 |
| DOMICILIO | cliente_id | CLIENTE | cliente_id | N:1 |
| PRECIO | plato_id | PLATO | plato_id | N:1 |
| COMBO_DETALLE | combo_id | COMBO | combo_id | N:1 |
| COMBO_DETALLE | plato_id | PLATO | plato_id | N:1 |
| PROMOCION_PLATO | promocion_id | PROMOCION | promocion_id | N:1 |
| PROMOCION_PLATO | plato_id | PLATO | plato_id | N:1 |
| PEDIDO | canal_id | CANAL_VENTA | canal_id | N:1 |
| PEDIDO | mesa_id | MESA | mesa_id | N:1 (nullable) |
| PEDIDO | cliente_id | CLIENTE | cliente_id | N:1 (nullable) |
| PEDIDO | domicilio_id | DOMICILIO | domicilio_id | N:1 (nullable) |
| PEDIDO | estado_id | ESTADO_PEDIDO | estado_id | N:1 |
| PEDIDO | tomado_por_empleado_id | EMPLEADO | empleado_id | N:1 |
| PEDIDO | entregado_por_empleado_id | EMPLEADO | empleado_id | N:1 (nullable) |
| DETALLE_PEDIDO | pedido_id | PEDIDO | pedido_id | N:1 |
| DETALLE_PEDIDO | plato_id | PLATO | plato_id | N:1 (nullable) |
| DETALLE_PEDIDO | combo_id | COMBO | combo_id | N:1 (nullable) |
| DETALLE_PEDIDO | promocion_id | PROMOCION | promocion_id | N:1 (nullable) |
| AUDITORIA | pedido_id | PEDIDO | pedido_id | N:1 (nullable) |
| STOCK_SIMULADO | plato_id | PLATO | plato_id | 1:1 |
| REPORTES_GENERADOS | sucursal_id | SUCURSAL | sucursal_id | N:1 (nullable) |

**Nota:** La tabla NOTIFICACIONES contiene referencias lógicas a PEDIDO y MESA sin constraints FK.


---

## **ÍNDICES DEL SISTEMA**

### **Índices de Performance Implementados**

| **Nombre del Índice** | **Tabla** | **Campos** | **Tipo** | **Propósito** |
|-----------------------|-----------|------------|----------|---------------|
| **IX_PEDIDO_fecha_estado** | PEDIDO | fecha_pedido, estado_id | NONCLUSTERED | Consultas de pedidos por fecha y estado |
| **IX_PEDIDO_mesa** | PEDIDO | mesa_id | NONCLUSTERED | Pedidos por mesa (WHERE mesa_id IS NOT NULL) |
| **IX_PEDIDO_cliente** | PEDIDO | cliente_id | NONCLUSTERED | Pedidos por cliente (WHERE cliente_id IS NOT NULL) |
| **IX_DETALLE_PEDIDO_pedido** | DETALLE_PEDIDO | pedido_id | NONCLUSTERED | Items por pedido |
| **IX_DETALLE_PEDIDO_plato** | DETALLE_PEDIDO | plato_id | NONCLUSTERED | Reportes de platos (WHERE plato_id IS NOT NULL) |
| **IX_MESA_sucursal_activa** | MESA | sucursal_id, activa | NONCLUSTERED | Mesas disponibles por sucursal |
| **IX_EMPLEADO_sucursal_activo** | EMPLEADO | sucursal_id, activo | NONCLUSTERED | Empleados activos por sucursal |
| **IX_PRECIO_plato_vigencia** | PRECIO | plato_id, vigencia_desde, vigencia_hasta | NONCLUSTERED | Precios vigentes por plato |
| **IX_REPORTES_tipo_fecha** | REPORTES_GENERADOS | tipo_reporte, fecha_reporte | NONCLUSTERED | Reportes por tipo y fecha |
| **IX_REPORTES_sucursal** | REPORTES_GENERADOS | sucursal_id, fecha_reporte | NONCLUSTERED | Reportes por sucursal y fecha |
| **IX_REPORTES_generacion** | REPORTES_GENERADOS | fecha_generacion DESC | NONCLUSTERED | Reportes ordenados por generación |

---

## **COMPONENTES IMPLEMENTADOS DEL SISTEMA**

### **Triggers Activos**

| **Trigger** | **Tabla** | **Evento** | **Propósito** | **Estado** |
|-------------|-----------|------------|---------------|------------|
| **tr_ActualizarTotales** | DETALLE_PEDIDO | INSERT, UPDATE, DELETE | Recalcula totales automáticamente | Activo |
| **tr_AuditoriaPedidos** | PEDIDO | INSERT, UPDATE, DELETE | Registra cambios en AUDITORIA_SIMPLE | Activo |
| **tr_AuditoriaDetalle** | DETALLE_PEDIDO | INSERT, UPDATE, DELETE | Auditoría de cambios en detalle | Activo |
| **tr_ValidarStock** | DETALLE_PEDIDO | INSERT | Valida stock disponible contra STOCK_SIMULADO | Activo |
| **tr_SistemaNotificaciones** | PEDIDO | UPDATE | Crea notificaciones automáticas | Activo |

### **Stored Procedures Implementados**

| **Procedimiento** | **Propósito** | **Estado** |
|-------------------|---------------|------------|
| **sp_CrearPedido** | Crear nuevo pedido con validaciones completas | Funcional |
| **sp_AgregarItemPedido** | Agregar items con cálculo automático | Funcional |
| **sp_CalcularTotalPedido** | Recalcular totales de pedido | Funcional |
| **sp_CerrarPedido** | Finalizar pedido y actualizar estado | Funcional |
| **sp_CancelarPedido** | Cancelar con auditoría completa | Funcional |
| **sp_ConsultarMenuActual** | Menu con precios vigentes | Funcional |
| **sp_MesasDisponibles** | Estado de mesas en tiempo real | Funcional |
| **sp_ConsultarStock** | Consulta de disponibilidad | Funcional |
| **sp_HistorialPedidos** | Historial de cliente | Funcional |
| **sp_ReporteVentasDiario** | Reporte automático de ventas | Funcional |
| **sp_ReporteProductosPopulares** | Ranking de productos | Funcional |
| **sp_ReporteIngresos** | Análisis financiero | Funcional |
| **sp_ReporteRendimientoEmpleados** | Performance del personal | Funcional |

### **Roles de Seguridad Implementados**

| **Rol** | **Permisos** | **Descripción** | **Estado** |
|---------|-------------|-----------------|------------|
| **db_owner** | ALL | Administración completa del sistema | Implementado |
| **db_datareader** | SELECT | Solo lectura de datos | Implementado |
| **db_datawriter** | INSERT, UPDATE, DELETE | Escritura de datos | Implementado |
| **MESERO_ROLE** | SELECT, INSERT, UPDATE (pedidos) | Operaciones de meseros | Implementado |
| **COCINA_ROLE** | SELECT, UPDATE (estado pedidos) | Operaciones de cocina | Implementado |
| **GERENTE_ROLE** | SELECT, reportes avanzados | Gestión y reportes | Implementado |
| **AUDITOR_ROLE** | SELECT (tablas auditoría) | Solo auditoría y consultas | Implementado |


**Desarrollado por:** SQLeaders S.A.  
**Proyecto Educativo ISTEA:** Uso exclusivamente académico - Prohibida la comercialización