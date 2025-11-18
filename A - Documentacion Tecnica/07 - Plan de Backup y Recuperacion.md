# PLAN DE BACKUP Y RECUPERACIÓN - SISTEMA CHINCHULINK

## **INFORMACIÓN DEL DOCUMENTO**

| **Campo** | **Descripción** |
|-----------|-----------|
| **Documento** | Plan de Backup y Recuperación - Sistema ChinchuLink |
| **Proyecto** | Sistema de Gestión de Pedidos |
| **Cliente** | Parrilla El Encuentro |
| **Desarrollado por** | SQLeaders S.A. |
| **Versión** | 1.0 |
| **Estado** | Implementado y Funcional |

## **RESUMEN EJECUTIVO**

### **Objetivo del Documento**
Este plan define la estrategia integral de backup y recuperación para la base de datos ChinchuLink, garantizando la continuidad del negocio mediante procedimientos automatizados de respaldo y restauración. Incluye configuraciones detalladas, procedimientos de emergencia y métricas de rendimiento.

### **Herramientas y Tecnologías**
- **Software Principal:** SQLBackupAndFTP Professional (v12.7.35)
- **Base de Datos:** Microsoft SQL Server - ChinchuLink
- **Estrategia:** Backup 3-2-1 (Local + Google Drive)
- **Frecuencias:** Full (Semanal), Differential (Diario), Transaction Log (12h)

---

## CONFIGURACIÓN DEL SISTEMA DE BACKUP

### **Herramienta Implementada**
- **Software:** SQLBackupAndFTP Professional Trial (v12.7.35)
- **Estado de Licencia:** Trial (14 días) - Requiere adquisición para producción
- **Conectividad:** Microsoft SQL Server (Standard backup)
- **Base de Datos Objetivo:** ChinchuLink

### **Opciones de Licencia SQLBackupAndFTP**

| **Edición** | **Precio** | **Límite BD** | **Recomendación** |
|-------------|------------|---------------|-------------------|
| **Free** | $0/año | Máximo 2 BD |  **Recomendada para ChinchuLink** |
| **Lite** | $39/año | Máximo 5 BD |  Para expansiones futuras |
| **Standard/Professional** | $89-129/año | Sin límite | Para entornos empresariales |

### **¿Por qué SQLBackupAndFTP?**
- **Funcionalidad completa gratuita:** Todas las funciones disponibles en versión Free
- **Fácil configuración:** Interfaz gráfica intuitiva
- **Múltiples destinos:** Google Drive, Amazon S3, FTP, carpetas locales
- **Automatización:** Programación de backups sin intervención manual
- **Confiabilidad probada:** Ampliamente usado en entornos de producción

### **Configuración Actual Implementada**
- **Versión:** SQLBackupAndFTP Professional Trial (se migrará a Free)
- **Destinos configurados:** Carpeta local (E:\Chinchubckp) + Google Drive
- **Programación:** Full semanal, Diferencial diario, Transaction Log cada 12h

### **Programación de Respaldos Automáticos**

| **Tipo de Backup** | **Frecuencia** | **Próxima Ejecución** | **Horario** |
|-------------------|----------------|----------------------|-------------|
| **Full Backup** | Cada 168 horas (Semanal) | Nov 20 3:44a | Domingos 03:44 AM |
| **Differential** | Cada 24 horas (Diario) | Nov 15 3:44a | Diario 03:44 AM |
| **Transaction Log** | Cada 12 horas | Nov 14 3:44p | Cada 12 horas |

### **Destinos de Almacenamiento y Responsabilidades**

| **Destino** | **Ubicación** | **Responsable** | **Propósito** | **Estado** |
|------------|---------------|-----------------|---------------|------------|
| **Local/Network** | Servidor Parrilla El Encuentro (E:\Chinchubckp) | Parrilla El Encuentro | Recuperación rápida local |  Activo |
| **Google Drive** | Nube (Adrián Barletta: chinchubckp) | DBA SQLeaders | Seguridad offsite y DR |  Activo |

### **Ventajas de esta Estrategia de Almacenamiento**
- **Recuperación rápida:** Backup local en servidor permite restauración inmediata sin dependencia de internet
- **Seguridad adicional:** Backup en nube gestionado por DBA especializado garantiza conservación a largo plazo
- **Separación de responsabilidades:** Parrilla maneja operación diaria, SQLeaders la continuidad del negocio
- **Cumple mejores prácticas:** Implementa estrategia 3-2-1 (3 copias, 2 medios, 1 offsite)
- **Doble resguardo:** Si falla el servidor local, el DBA puede restaurar desde Google Drive

### **Políticas de Retención Recomendadas**

| **Tipo de Backup** | **Retención Local (Parrilla)** | **Retención Nube (SQLeaders)** | **Justificación** |
|-------------------|--------------------------------|--------------------------------|-------------------|
| **Full Backup** | 4 semanas (1 mes) | 6 meses | Recuperación punto en el tiempo, auditorías |
| **Differential** | 2 semanas | 1 mes | Balance espacio vs. flexibilidad recuperación |
| **Transaction Log** | 1 semana | 2 semanas | Recuperación granular reciente |

### **Gestión de Espacio y Limpieza Automática**
- **Local (Parrilla):** Limpieza automática cada domingo después del Full backup
- **Nube (SQLeaders):** Revisión trimestral y archivo de backups antiguos
- **Espacio estimado local:** ~500 MB por semana (considerando compresión)
- **Espacio estimado nube:** ~2 GB para 6 meses de retención
- **Alerta de espacio:** Configurar aviso cuando uso local supere 80% del espacio disponible

### **Casos Especiales de Retención**
- **Cierre mensual:** Conservar Full backup del último día del mes por 1 año adicional
- **Auditoría anual:** Backup del 31 de diciembre conservado por 7 años (requerimientos fiscales)
- **Actualizaciones de sistema:** Backup inmediatamente antes y después conservado por 3 meses


---

## SISTEMA DE MONITOREO Y ALERTAS

### **Configuración de Notificaciones por Email**
- **Email éxito**: adrian.barletta@istea.com.ar
- **Email falla**: (Se puede configurar múltiples emails separados por coma)
- **Servicio down alerts**: Habilitado

### **Monitoreo Remoto y Logs Web**
- **Historial web**: Disponible para consulta
- **Monitoreo remoto**: Posible via web interface

---

## PROCEDIMIENTOS DE BACKUP

### **Respaldo Automático Configurado**
```
Job: Backup Job - 1 (Next run: Nov 14 3:44a)
├── Connect to Microsoft SQL Server
├── Select Database: Chinchlink 
├── Store backups in:
│   ├── Local/Network: E:\Chinchubckp
│   └── Google Drive: chinchubckp
├── Schedule:
│   ├── Full: every 168h
│   ├── Differential: every 24h  
│   └── Transaction Log: every 12h
└── Send confirmation email
```

### **Procedimiento de Respaldo Manual**
1. Abrir SQLBackupAndFTP
2. Seleccionar "Backup Job - 1"
3. Hacer clic en "Run Now"
4. Verificar ejecución en History & restore

---

## PROCEDIMIENTOS DE RESTAURACIÓN

### **Restauración desde Almacenamiento Local**
```sql
-- Restaurar backup completo
RESTORE DATABASE ChinchuLink_Restore 
FROM DISK = 'E:\Chinchubckp\ChinchuLink_Full_YYYYMMDD.bak'
WITH REPLACE, STATS = 10;

-- Aplicar backup diferencial (si existe)
RESTORE DATABASE ChinchuLink_Restore 
FROM DISK = 'E:\Chinchubckp\ChinchuLink_Diff_YYYYMMDD.bak'
WITH NORECOVERY;

-- Aplicar logs de transacciones
RESTORE LOG ChinchuLink_Restore 
FROM DISK = 'E:\Chinchubckp\ChinchuLink_Log_YYYYMMDDHH.trn'
WITH RECOVERY;
```

### **Restauración desde Google Drive**
1. Descargar archivo .bak desde Google Drive
2. Copiar a servidor SQL Server
3. Ejecutar comandos de restauración SQL
4. Verificar integridad: `DBCC CHECKDB('ChinchuLink_Restore')`

---

## MEJORES PRÁCTICAS IMPLEMENTADAS

### **Estrategia de Respaldo 3-2-1 con Segregación de Responsabilidades**
-  **3 copias**: Original (servidor) + Local (Parrilla) + Google Drive (SQLeaders)
-  **2 medios diferentes**: Disco local + Nube
-  **1 offsite**: Google Drive remoto gestionado por DBA especializado

### **Modelo de Responsabilidades Compartidas**
-  **Parrilla El Encuentro**: Gestión del backup local para recuperación inmediata
-  **DBA SQLeaders**: Custodia del backup en nube para disaster recovery
-  **Beneficio**: Combina rapidez operativa con expertise técnico especializado
-  **1 offsite**: Google Drive remoto

### **Verificación de Integridad de Datos**
-  **Checksum**: Automático en cada backup
-  **Verification**: SQLBackupAndFTP verifica automáticamente
-  **Compression**: Activada para optimizar espacio

### **Sistema de Monitoreo y Seguimiento**
-  **Email notifications**: Configuradas para éxito/falla
-  **Historial detallado**: Disponible en interfaz
-  **Logs de actividad**: Registrados automáticamente

### **Ventajas del Modelo de Responsabilidades Implementado**
-  **Rapidez operativa**: Backup local permite restauración en minutos sin dependencia externa
-  **Expertise especializado**: DBA SQLeaders asegura gestión profesional del backup crítico
-  **Continuidad garantizada**: Si falla infraestructura local, SQLeaders puede restaurar remotamente
-  **Separación de riesgos**: Diversifica la responsabilidad entre operación diaria y continuidad estratégica
-  **Cumplimiento de mejores prácticas**: Implementa estándares empresariales con recursos optimizados

---

## PLAN DE MEJORAS Y OPTIMIZACIONES

### **Acciones Inmediatas Requeridas**
1. **Migrar a versión Free** cuando expire el trial (14 días)
   - Mantiene toda la funcionalidad actual
   - Permite hasta 2 bases de datos programadas (suficiente para ChinchuLink)
   - Costo: $0
2. **Implementar políticas de retención automática**
   - Configurar limpieza automática de backups antiguos en servidor local
   - Coordinar con DBA SQLeaders la gestión de retención en nube
3. **Configurar emails de fallas** con múltiples destinatarios del equipo técnico
4. **Optimizar frecuencia de transaction log** a cada 15-30 minutos para mejor RPO
5. **Monitorear espacio en disco** y configurar alertas de capacidad

---

## ANÁLISIS DE RETENCIÓN Y ESPACIO

### **Estimación de Crecimiento de Backups**

| **Período** | **Espacio Local (Parrilla)** | **Espacio Nube (SQLeaders)** | **Gestión** |
|-------------|------------------------------|------------------------------|-------------|
| **1 mes** | ~2 GB | ~2 GB | Operación normal |
| **3 meses** | ~2 GB (rotación) | ~4 GB | Revisión trimestral |
| **6 meses** | ~2 GB (rotación) | ~8 GB | Limpieza selectiva |
| **1 año** | ~2 GB (rotación) | ~12 GB + archivos especiales | Archivado anual |

### **Beneficios de la Política de Retención Implementada**
- **Control de costos:** Limita crecimiento de almacenamiento sin comprometer seguridad
- **Cumplimiento legal:** Conserva backups de cierres fiscales por 7 años
- **Flexibilidad operativa:** Permite recuperación granular hasta 2 semanas atrás
- **Optimización de recursos:** Balance entre disponibilidad y uso eficiente del espacio

---

## OBJETIVOS Y TIEMPOS DE RECUPERACIÓN
### **Escenarios de Recuperación y Tiempos Estimados**

| **Escenario** | **Tiempo Estimado** | **Procedimiento** |
|---------------|-------------------|------------------|
| **Corrupción menor** | 15-30 min | Restaurar desde diferencial |
| **Pérdida de base completa** | 1-2 horas | Full + Differential + Logs |
| **Disaster recovery** | 2-4 horas | Restaurar desde Google Drive |
| **Point-in-time** | 30-60 min | Full + Logs hasta punto específico |

---

## RESPONSABILIDADES Y CONTACTOS

### **Equipo de Administración de Base de Datos**
- **DBA Principal**: Adrián Barletta (adrian.barletta@istea.com.ar)
- **Backup Tool**: SQLBackupAndFTP Professional
- **Soporte**: Documentación + Community forums

### **Procedimiento de Escalamiento**
1. **Nivel 1**: Verificar logs automáticos y email alerts
2. **Nivel 2**: Contactar DBA para investigación
3. **Nivel 3**: Ejecutar procedimiento de disaster recovery


---

**Documento generado por SQLeaders S.A. - Noviembre 2025**  
**Para soporte técnico: Contactar equipo de desarrollo**  
