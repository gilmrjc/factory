---
prd_slug: notificaciones-push
domain: reportes
date: 2026-08-10
skill: evaluar-conectividad-tecnica
scope: prd
modo: codebase-existente
input: docs/reportes/idea/notificaciones-push/scope-roadmap.md
status: ready
next: capturar-requerimiento
---

# Prerequisites Assessment: notificaciones-push

## Table of Contents

- [Infraestructura Existente](#infraestructura-existente)
- [Prerequisitos de la Funcionalidad](#prerequisitos-de-la-funcionalidad)
- [Gaps Identificados](#gaps-identificados)
- [Evaluación de Conectividad](#evaluación-de-conectividad)
- [Recomendaciones](#recomendaciones)
- [Acceptance Criteria](#acceptance-criteria)
- [Dependencias](#dependencias)
- [Requisitos Técnicos](#requisitos-técnicos)
- [Análisis del Codebase Actual](#análisis-del-codebase-actual)
- [Matriz de Prerequisitos vs Existentes](#matriz-de-prerequisitos-vs-existentes)
- [Gate de avance (Fase D)](#gate-de-avance-fase-d)
- [Estado de avance](#estado-de-avance)
- [Autoevaluación](#autoevaluación)

## Infraestructura Existente

- **Auth**: JWT con sesiones persistentes. Sistema de usuarios operativo con roles y permisos. Endpoints `/api/auth/*` funcionales.
- **Database**: PostgreSQL 14. Schema `reportes` con tablas `reports`, `report_jobs`, `users`. Migraciones via Prisma.
- **APIs**: REST API en Express. Endpoints de reportes (`/api/reports/*`) con CRUD completo. Webhooks de eventos de reporte ya implementados (`report.completed`, `report.failed`).
- **Servicios**: Cola de jobs en BullMQ (Redis). Servicio de email via SendGrid operativo para emails transactionales. Sin servicio de push notifications.
- **Frontend**: React 18 con TypeScript. SPA con routing via React Router. Estado global via Zustand. Componentes de UI en design system interno.
- **Monitoring**: Logging estructurado via Winston. Métricas en Datadog. Alertas configuradas para errores de API y jobs de reportes.

## Prerequisitos de la Funcionalidad

- **Componentes necesarios**: Servicio de push notifications (FCM/APNS), registro de dispositivos por usuario, integración con webhook `report.completed`.
- **Integraciones requeridas**: Firebase Cloud Messaging (Android), Apple Push Notification Service (iOS), SendGrid (fallback por email, ya existe).
- **Patrones arquitectónicos**: Patrón event-driven ya establecido (webhooks de reporte). Cola de jobs existente reusable para encolar envíos de notificaciones.

## Gaps Identificados

- **Prerequisitos faltantes**: Servicio de push notifications no existe. Registro de dispositivos no existe (no hay tabla ni endpoints). Certificados APNS no configurados.
- **Upgrades necesarios**: SendGrid ya está integrado pero solo para emails transactionales — extender para usar como fallback de push. Esfuerzo: bajo (configuración de template).
- **Deuda técnica relevante**: Sin deuda bloqueante. TODO existente en `report-service` sobre refactoring de webhook dispatch, pero no afecta la integración de notificaciones.

## Evaluación de Conectividad

- **Estado**: Conectado
- **Justificación**: Los prerequisitos críticos (auth, DB, webhooks de reporte, cola de jobs, servicio de email) existen y están operativos. Los prerequisitos faltantes (servicio de push, registro de dispositivos, certificados APNS) son alcanzables con esfuerzo razonable (< 2 semanas). Los patrones arquitectónicos (event-driven, cola de jobs) son compatibles. La integración con bounded contexts existentes (`reportes`, `auth`) es posible sin refactor mayor.
- **Bloqueadores críticos**: Ninguno

## Recomendaciones

- Si conectado: Proceder al siguiente paso del workflow
- Si desconectado: Revisar bridge roadmap y proceder a priorizar features puente

**Veredicto**: Conectado. Proceder a `capturar-requerimiento`.

## Acceptance Criteria

- AC1: El usuario recibe una notificación push cuando su reporte termina de generarse
- AC2: La notificación incluye un enlace directo al reporte terminado
- AC3: Si el push falla, el sistema hace fallback a email
- AC4: El usuario puede opt-out de notificaciones push desde su perfil

## Dependencias

- **Upstream**: `docs/reportes/idea/notificaciones-push/scope-roadmap.md` (funcionalidad definida), `docs/reportes/idea/notificaciones-push/idea-analysis.md` (descripción del producto)
- **Downstream**: `capturar-requerimiento` (estructurar requerimiento formal)

## Requisitos Técnicos

- **Servicio de push notifications** (infraestructura): Nuevo módulo `notification-service` con integración FCM y APNS
- **Registro de dispositivos** (data): Tabla `user_devices` con relación a `users`, endpoints de registro/desregistro
- **Integración con webhook** (integración): Suscripción al evento `report.completed` para disparar notificación
- **Fallback a email** (integración): Reuso de SendGrid existente con nuevo template de "reporte listo"

## Análisis del Codebase Actual

- **Auth (JWT)** — Estado: Operativo. Notas: Sesiones persistentes, roles y permisos funcionales. Reusable sin cambios.
- **Database (PostgreSQL)** — Estado: Operativo. Notas: Schema `reportes` con Prisma. Nueva tabla `user_devices` requiere migración simple.
- **APIs (Express REST)** — Estado: Operativo. Notas: Webhooks de reporte ya implementados. Nuevos endpoints para registro de dispositivos.
- **Servicios (BullMQ + SendGrid)** — Estado: Parcial. Notas: Cola de jobs reusable. SendGrid operativo pero requiere nuevo template. Push service no existe.
- **Frontend (React 18)** — Estado: Operativo. Notas: Design system interno. Nuevo componente de preferencias de notificación.
- **Monitoring (Winston + Datadog)** — Estado: Operativo. Notas: Logging y métricas configurados. Extender para trackear notificaciones enviadas/entregadas.

## Matriz de Prerequisitos vs Existentes

- **Auth system** — Existe en codebase: Sí. Suficiente: Sí. Acción requerida: Ninguna
- **Database (PostgreSQL)** — Existe en codebase: Sí. Suficiente: Sí. Acción requerida: Migración para tabla `user_devices`
- **Webhook `report.completed`** — Existe en codebase: Sí. Suficiente: Sí. Acción requerida: Suscribir notification-service al evento
- **Cola de jobs (BullMQ)** — Existe en codebase: Sí. Suficiente: Sí. Acción requerida: Nueva cola para envío de notificaciones
- **Servicio de email (SendGrid)** — Existe en codebase: Sí. Suficiente: Sí. Acción requerida: Nuevo template de "reporte listo"
- **Servicio de push (FCM/APNS)** — Existe en codebase: No. Suficiente: N/A. Acción requerida: Crear `notification-service` con integración FCM + APNS
- **Registro de dispositivos** — Existe en codebase: No. Suficiente: N/A. Acción requerida: Crear tabla `user_devices` + endpoints de registro

## Gate de avance (Fase D)

- **Inventario de preguntas identificadas**:
  - [Importante] ¿FCM o APNS primero, o ambos en paralelo? — Estado: resuelta inline (ambos en paralelo, esfuerzo similar)
  - [Menor] ¿Usar certificados APNS legacy o Auth Key? — Estado: resuelta inline (Auth Key, recomendado por Apple)
- **Alerta al usuario**: No necesaria — todas las Críticas/Importantes se resolvieron inline durante el análisis.
- **Estado final de avance**: Libre — `status: ready`, `next: capturar-requerimiento`

## Estado de avance

- **Veredicto de conectividad**: Conectado
- **status**: ready
- **next**: capturar-requerimiento
- **Justificación**: Todos los prerequisitos críticos existen o son alcanzables con esfuerzo razonable. Los gaps (push service, registro de dispositivos) son trabajo nuevo dentro de patrones ya establecidos, no infraestructura faltante que requiera features puente.

## Autoevaluación

1. ¿Analicé la infraestructura existente? — Sí, mapeé auth, DB, APIs, servicios, frontend, monitoring
2. ¿Identifiqué los prerequisitos de la funcionalidad? — Sí, listé componentes, integraciones y patrones necesarios
3. ¿Evalué la conectividad correctamente? — Sí, determiné conectado con justificación que cita los criterios del SKILL.md Fase B
4. ¿Generé bridge roadmap cuando fue necesario? — N/A, la funcionalidad está conectada
5. ¿Las features puente tienen valor propio? — N/A, no hay features puente
6. ¿Identifiqué las dependencias correctamente? — N/A, no hay features puente
7. ¿Definí el `status` y `next` del frontmatter correctamente? — Sí, `status: ready`, `next: capturar-requerimiento`
8. ¿Los documentos de salida son accionables? — Sí, contienen recomendaciones claras y next steps
9. ¿Ejecuté y documenté el gate de avance (Fase D)? — Sí, inventario completo, alerta no necesaria, estado libre
10. ¿Clasifiqué las preguntas abiertas por severidad? — Sí, 1 Importante + 1 Menor, ambas resueltas inline
11. ¿Apliqué el path lite correctamente? — N/A, no es greenfield+lite
