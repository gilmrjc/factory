---
idea_slug: notificaciones-push
funcionalidad_slug: notificaciones-push
domain: reportes
date: 2026-08-10
skill: evaluar-conectividad-tecnica
modo: codebase-existente
input: docs/reportes/idea/notificaciones-push/scope-roadmap.md
status: ready
next: capturar-requerimiento
---

# Prerequisites Assessment: notificaciones-push

## Table of Contents

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Infraestructura Existente](#infraestructura-existente)
- [Prerequisitos de la Funcionalidad](#prerequisitos-de-la-funcionalidad)
- [Gaps Identificados](#gaps-identificados)
- [Evaluación de Conectividad](#evaluación-de-conectividad)
- [Recomendaciones](#recomendaciones)
- [Acceptance Criteria](#acceptance-criteria)
- [Dependencias](#dependencias)
- [Matriz de Prerequisitos vs Existentes](#matriz-de-prerequisitos-vs-existentes)
- [Gate de avance](#gate-de-avance)
- [Estado de avance](#estado-de-avance)

## Resumen Ejecutivo

- **Funcionalidad**: notificaciones-push
- **Veredicto**: Conectado
- **Gaps críticos**: Ninguno
- **Próximo paso**: `capturar-requerimiento`
- **Decisión clave**:
  - La infraestructura de producto necesaria (auth, DB, cola, email, webhooks) existe y es compatible.
  - Los gaps (push service, registro de dispositivos, certificados APNS) son trabajo nuevo sin dependencias de producto previo.

## Infraestructura Existente

- **Auth**
  - Estado: Operativo
  - Notas: JWT con sesiones persistentes. Sistema de usuarios con roles y permisos. Endpoints `/api/auth/*` funcionales.
- **Database**
  - Estado: Operativo
  - Notas: PostgreSQL 14. Schema `reportes` con tablas `reports`, `report_jobs`, `users`. Migraciones via Prisma.
- **APIs**
  - Estado: Operativo
  - Notas: REST API en Express. Endpoints de reportes (`/api/reports/*`) con CRUD completo. Webhooks de eventos de reporte ya implementados (`report.completed`, `report.failed`).
- **Servicios**
  - Estado: Parcial
  - Notas: Cola de jobs en BullMQ (Redis). Servicio de email via SendGrid operativo para emails transactionales. Sin servicio de push notifications.
- **Frontend**
  - Estado: Operativo
  - Notas: React 18 con TypeScript. SPA con routing via React Router. Estado global via Zustand. Componentes de UI en design system interno.
- **Monitoring**
  - Estado: Operativo
  - Notas: Logging estructurado via Winston. Métricas en Datadog. Alertas configuradas para errores de API y jobs de reportes.

## Prerequisitos de la Funcionalidad

- **Componentes necesarios**
  - Servicio de push notifications (FCM/APNS)
  - Registro de dispositivos por usuario
  - Integración con webhook `report.completed`
- **Integraciones requeridas**
  - Firebase Cloud Messaging (Android)
  - Apple Push Notification Service (iOS)
  - SendGrid (fallback por email, ya existe)
- **Patrones arquitectónicos**
  - Patrón event-driven ya establecido (webhooks de reporte)
  - Cola de jobs existente reusable para encolar envíos de notificaciones

## Gaps Identificados

- **Prerequisitos faltantes**
  - Servicio de push notifications no existe
  - Registro de dispositivos no existe (no hay tabla ni endpoints)
  - Certificados APNS no configurados
- **Upgrades necesarios**
  - SendGrid está integrado solo para emails transactionales
    - Esfuerzo: bajo
    - Acción: configurar template de "reporte listo" para fallback
- **Deuda técnica relevante**
  - TODO existente en `report-service` sobre refactoring de webhook dispatch
    - Impacto: no afecta la integración de notificaciones

## Evaluación de Conectividad

- **Estado**: Conectado
- **Justificación**:
  - Los prerequisitos críticos (auth, DB, webhooks de reporte, cola de jobs, servicio de email) existen y están operativos.
  - Los prerequisitos faltantes (servicio de push, registro de dispositivos, certificados APNS) son alcanzables sin requerir nuevas funcionalidades puente.
  - Los patrones arquitectónicos (event-driven, cola de jobs) son compatibles.
  - La integración con bounded contexts existentes (`reportes`, `auth`) es posible sin refactor mayor.
- **Bloqueadores críticos**: Ninguno

## Recomendaciones

- **Conectado**:
  - Proceder a `capturar-requerimiento`.

## Acceptance Criteria

- AC1: El usuario recibe una notificación push cuando su reporte termina de generarse
- AC2: La notificación incluye un enlace directo al reporte terminado
- AC3: Si el push falla, el sistema hace fallback a email
- AC4: El usuario puede opt-out de notificaciones push desde su perfil

## Dependencias

- **Upstream**
  - `docs/reportes/idea/notificaciones-push/scope-roadmap.md` (funcionalidad definida)
  - `docs/reportes/idea/notificaciones-push/idea-analysis.md` (descripción del producto)
- **Downstream**
  - `capturar-requerimiento` (estructurar requerimiento formal)

## Matriz de Prerequisitos vs Existentes

- **Auth system**
  - Existe en codebase: Sí
  - Suficiente: Sí
  - Acción requerida: Ninguna
- **Database (PostgreSQL)**
  - Existe en codebase: Sí
  - Suficiente: Sí
  - Acción requerida: Migración para tabla `user_devices`
- **Webhook `report.completed`**
  - Existe en codebase: Sí
  - Suficiente: Sí
  - Acción requerida: Suscribir notification-service al evento
- **Cola de jobs (BullMQ)**
  - Existe en codebase: Sí
  - Suficiente: Sí
  - Acción requerida: Nueva cola para envío de notificaciones
- **Servicio de email (SendGrid)**
  - Existe en codebase: Sí
  - Suficiente: Sí
  - Acción requerida: Nuevo template de "reporte listo"
- **Servicio de push (FCM/APNS)**
  - Existe en codebase: No
  - Suficiente: N/A
  - Acción requerida: Crear `notification-service` con integración FCM + APNS
- **Registro de dispositivos**
  - Existe en codebase: No
  - Suficiente: N/A
  - Acción requerida: Crear tabla `user_devices` + endpoints de registro

## Gate de avance

- **Inventario de preguntas identificadas**:
  - [Importante] ¿FCM o APNS primero, o ambos en paralelo?
    - Estado: resuelta inline
    - Nota: ambos en paralelo, complejidad similar
  - [Menor] ¿Usar certificados APNS legacy o Auth Key?
    - Estado: resuelta inline
    - Nota: Auth Key, recomendado por Apple
- **Alerta al usuario**:
  - No necesaria. Todas las Críticas/Importantes se resolvieron inline durante el análisis.
- **Estado final de avance**:
  - Libre
  - `status: ready`
  - `next: capturar-requerimiento`

## Estado de avance

- **Veredicto de conectividad**: Conectado
- **status**: ready
- **next**: capturar-requerimiento
- **Justificación**:
  - Todos los prerequisitos críticos existen o son alcanzables sin requerir nuevas funcionalidades puente.
  - Los gaps (push service, registro de dispositivos) son trabajo nuevo dentro de patrones ya establecidos, no infraestructura faltante que requiera funcionalidades puente.
