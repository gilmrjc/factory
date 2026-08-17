# Ejemplo: Scope Roadmap Completo

Ejemplo de un scope-roadmap para un sistema de notificaciones con múltiples funcionalidades, mostrando diferentes patrones de desglose de fases.

```markdown
---
idea_slug: sistema-notificaciones
domain: plataforma
date: 2025-01-15
skill: evaluar-alcance-idea
profile: full
status: conditional
next: priorizar-roadmap
---

## Evaluación Estratégica

- **Veredicto**: Proceder
- **Alineación**: Alineado con roadmap Q1 2025 de "Mejorar engagement de usuarios"
- **Tamaño**: full
- **Justificación**: Producto externo, impacta múltiples bounded contexts

## Clasificación de Alcance

- **Tipo**: Múltiples funcionalidades
- **Justificación**: Impacta 3 bounded contexts (auth, messaging, analytics), con componentes que pueden entregarse independientemente

## Roadmap de Funcionalidades

### notificaciones-core
- **Alcance**: Email + push básicos para alertas críticas
- **Valor**: Usuarios reciben notificaciones importantes en tiempo real
- **Depende de**: auth-core
- **Estado**: lista

### preferencias-usuario
- **Alcance**: Gestión completa de canales, frecuencias, horarios y reglas de notificación
- **Valor**: Control granular sobre qué notificaciones recibir y cuándo
- **Depende de**: notificaciones-core
- **Estado**: condicionada

### analytics-integration
- **Alcance**: Tracking de engagement, dashboards y reportes de efectividad
- **Valor**: Visibilidad sobre el impacto de las notificaciones en el comportamiento del usuario
- **Depende de**: preferencias-usuario
- **Estado**: lista

## Desglose: notificaciones-core

### Fases
1. **Configuración de proveedor email**: Setup de cuenta SendGrid, configuración de API keys, validación de conexión, template base HTML. Entregable: Sistema capaz de enviar emails de prueba.
2. **Sistema de colas básico**: Setup de RabbitMQ, configuración de colas para procesamiento asíncrono, manejo de errores básico, reintentos simples. Entregable: Infraestructura de colas operativa.
3. **Integración con auth**: Conexión con sistema de usuarios existente, validación de emails, endpoints de API para registrar usuarios. Entregable: API que puede identificar usuarios válidos.
4. **Envío de email simple**: Endpoint para enviar email a un usuario, validación de datos de entrada, encolado de tarea, tracking de estado. Entregable: API que envía emails transactionales básicos.
5. **Integración FCM Android**: Setup de proyecto FCM, configuración de credenciales, registro de dispositivos Android, envío de push notification básico. Entregable: Sistema que envía push a dispositivos Android.
6. **Integración APNS iOS**: Setup de certificados APNS, registro de dispositivos iOS, envío de push notification básico, manejo de tokens expirados. Entregable: Sistema que envía push a dispositivos iOS.
7. **Sistema de fallback**: Lógica para detectar falla de push, cambio automático a email como fallback, tracking de canal utilizado. Entregable: Sistema que garantiza entrega aunque falle un canal.
8. **Plantillas dinámicas**: Sistema de templates con variables, diseño de templates para diferentes tipos de alertas, motor de sustitución de variables. Entregable: Sistema que genera emails personalizados.
9. **Preferencias básicas**: Almacenamiento de preferencias on/off por tipo de notificación, integración con endpoints de envío, UI básica de toggles. Entregable: Usuarios pueden controlar qué notificaciones reciben.
10. **Monitoreo básico**: Tracking de envíos, entregas, opens y clicks, dashboard simple con métricas clave, alertas cuando tasas caen. Entregable: Visibilidad básica sobre performance del sistema.

### Decisiones
- **Resuelta (2025-01-15)**: Proveedor email = SendGrid (balance costo/entregabilidad, API robusta)
- **Resuelta (2025-01-15)**: Sistema de colas = RabbitMQ (ya integrado en plataforma, reduce latencia)
- **Pendiente**: ¿Incluir SMS en MVP o fase posterior? (Fase 6-7) - Opciones: Sí vs No - Impacto: Alcance vs Velocidad de entrega

## Desglose: preferencias-usuario

### Fases
1. **Schema de preferencias**: Diseño de modelo de datos para preferencias, migración de DB, índices para consultas eficientes. Entregable: Estructura de datos lista para almacenar preferencias.
2. **UI básica de toggles**: Pantalla de configuración con switches on/off por tipo de notificación, almacenamiento en DB, integración con auth-core. Entregable: Usuarios pueden activar/desactivar tipos de notificaciones.
3. **Gestión de canales**: Selección de canales por tipo (email, push, SMS), preferencias por dispositivo, manejo de dispositivos múltiples. Entregable: Usuarios pueden elegir canal por tipo de notificación.
4. **Frecuencias y horarios**: Configuración de frecuencia (inmediata, diaria, semanal), horarios de silencio (modo no molestar), zonas horarias por usuario. Entregable: Control temporal sobre cuándo recibir notificaciones.
5. **Reglas condicionales básicas**: Sistema de reglas if/then simple (ej: "solo notificaciones de seguridad fuera de horario laboral"), categorización por urgencia. Entregable: Lógica básica de filtrado contextual.
6. **Preferencias por defecto**: Sistema de defaults inteligentes basados en comportamiento del usuario, onboarding guiado de preferencias. Entregable: Nueva experiencia de usuario con defaults sensibles.

### Decisiones
- **Resuelta (2025-01-15)**: Almacenar preferencias en DB existente (sin nuevo bounded context, reduce complejidad)
- **Resuelta (2025-01-15)**: UI basada en componentes existentes (consistencia visual, menor desarrollo)
- **Pendiente**: ¿Default opt-in u opt-out para nuevos usuarios? (Fase 6) - Opciones: Opt-in vs Opt-out - Impacto: Adopción vs Riesgo spam y compliance

## Desglose: analytics-integration

### Fases
1. **Integración Mixpanel básica**: Setup de tracking de eventos sent, delivered, opened, clicked, bounced, complained. Entregable: Sistema que registra eventos fundamentales del ciclo de notificaciones.
2. **Dashboard de métricas clave**: Métricas clave (tasa de entrega, tasa de apertura, tasa de clic), comparación temporal, filtros por tipo de notificación. Entregable: Dashboard simple con visibilidad básica de performance.
3. **Segmentación por usuario**: Tracking de comportamiento del usuario, análisis de retención post-notificación, identificación de usuarios desenganchados. Entregable: Capacidad de analizar patrones por segmentos de usuarios.
4. **A/B testing básico**: Integración con sistema de experiments existente, test de subject lines, análisis estadístico automático. Entregable: Sistema que puede ejecutar experiments simples en notificaciones.
5. **Reportes programados**: Generación de reportes PDF, exportación a CSV, alertas automáticas cuando métricas caen. Entregable: Sistema que entrega reportes automáticos al equipo.

### Decisiones
- **Resuelta (2025-01-15)**: Usar Mixpanel (ya integrado en plataforma, reduce setup)
- **Resuelta (2025-01-15)**: Dashboards en herramienta existente (Grafana) para consistencia
- **Pendiente**: ¿Nivel de detalle en eventos? (Fase 1) - Opciones: Agregados vs Individuales - Impacto: Granularidad vs Costo de storage

## Decisiones Pendientes

Consolidación de decisiones pendientes de los desgloses anteriores:

### Importantes (afectan calidad)
- SMS en MVP vs fase posterior (notificaciones-core) - Impacto: Alcance vs Velocidad de entrega
- Default opt-in vs opt-out para nuevos usuarios (preferencias-usuario) - Impacto: Adopción vs Riesgo spam y compliance
- Nivel de detalle en eventos de analytics (analytics-integration) - Impacto: Granularidad vs Costo de storage

### Menores (ideal resolver)
- Política de reintentos para emails fallidos (notificaciones-core) - Impacto: Entregabilidad vs Carga del sistema
- Complejidad de reglas avanzadas (preferencias-usuario) - Impacto: Usabilidad vs Flexibilidad
- Frecuencia de reportes automáticos (analytics-integration) - Impacto: Visibilidad vs Overhead

## Recomendación

- **Empezar con**: notificaciones-core
- **Next step**: priorizar-roadmap
- **Justificación**: notificaciones-core desbloquea las otras dos funcionalidades y entrega valor inmediato (alertas críticas). Hay decisiones importantes pendientes (SMS, defaults opt-in) que requieren input del usuario antes de implementar, pero no bloquean el avance de la infraestructura base.
```

## Características de este ejemplo

- **Múltiples funcionalidades**: 3 funcionalidades con diferentes niveles de complejidad
- **Patrones de desglose variados**:
  - `notificaciones-core`: 10 fases (feature complejo con múltiples componentes técnicos, cada fase con entregable específico)
  - `preferencias-usuario`: 6 fases (feature de usuario con evolución progresiva desde schema hasta defaults inteligentes)
  - `analytics-integration`: 5 fases (feature de datos con capas de profundidad desde tracking básico hasta reportes programados)
- **Fases granulares con entregables tangibles**: Cada fase tiene un entregable claro y verificable (ej: "Sistema capaz de enviar emails de prueba", no "infraestructura de email")
- **Dependencias claras**: auth-core → notificaciones-core → preferencias-usuario → analytics-integration
- **Decisiones mixtas**: Mezcla de decisiones resueltas (con fechas y rationale) y pendientes (con referencia a fase específica)
- **Clasificación por severidad**: Decisiones divididas en Importantes y Menores según impacto
- **Status condicionado**: Hay decisiones importantes pendientes que requieren input del usuario
- **Value proposition claro**: Cada funcionalidad tiene un valor específico y diferenciado para el usuario
- **Evolución progresiva**: Cada funcionalidad muestra un camino desde componentes base hasta funcionalidad avanzada, con MVP fragmentado en múltiples fases
