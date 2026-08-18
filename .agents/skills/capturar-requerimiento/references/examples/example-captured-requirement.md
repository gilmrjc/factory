---
idea_slug: sistema-de-notificaciones
domain: plataforma
date: 2026-08-18
skill: capturar-requerimiento
input: docs/plataforma/idea/sistema-de-notificaciones/feature-prioritization.md
status: conditional
next: mapear-assumptions
---

# Captured Requirement: Sistema de Notificaciones

## Table of Contents

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Contexto](#contexto)
- [Problema](#problema)
- [Audiencia Afectada](#audiencia-afectada)
- [Resultado Esperado](#resultado-esperado)
- [Solución Propuesta](#solución-propuesta)
- [Preguntas Abiertas](#preguntas-abiertas)
- [Gate de avance](#gate-de-avance)

## Resumen Ejecutivo

Implementar sistema centralizado de notificaciones para alertar a usuarios sobre eventos importantes, mejorando engagement y retención.

## Contexto

La iniciativa de retención Q3 identificó que la falta de comunicación oportuna reduce el reconocimiento de oportunidades. Se quiere habilitar comunicación proactiva antes del launch de Q3. SendGrid ya está operativo como proveedor de email transaccional.

## Problema

Usuarios pierden oportunidades importantes porque no reciben alertas sobre cambios en su cuenta o eventos time-sensitive. Actualmente 30% abandona sin reconocer oportunidades debido a falta de comunicación. No existe canal unificado de notificaciones.

## Audiencia Afectada

- **Primaria**: Usuarios activos (5K diarios, creciendo 20%/mes)
- **Secundaria**: Nuevos usuarios en onboarding (500/semana)
- **Interna**: CS, Product, Sales (upsell)

## Resultado Esperado

Los usuarios reciben alertas relevantes por los canales que eligen, con una frecuencia que no sientan como spam. Se puede medir el impacto en retención y engagement dentro de 8 semanas después del lanzamiento.

## Solución Propuesta

Sistema de notificaciones omnichannel:
- Email (transaccional + digest)
- Push (mobile app)
- In-app bell notification
- Preferencias por usuario (qué y cómo recibir)

**No-solutionización**: las decisiones de formato, esquemas, mecanismos de cola, endpoints, políticas de frecuencia y rate-limiting se definen en fases posteriores del workflow.

## Preguntas Abiertas

- **Pregunta**: ¿La app mobile ya tiene push notifications habilitadas?
  - **Categoría**: Incertidumbre técnica
  - **Impacto**: Define si push es viable para el MVP o se difiere
  - **Severidad**: Importante
  - **Propuesta**: Confirmar si la app mobile ya soporta push antes de `mapear-assumptions`
- **Pregunta**: ¿Frecuencia máxima de notificaciones por usuario?
  - **Categoría**: Ambigüedad de requisitos
  - **Impacto**: Afecta diseño de preferencias y posible spam
  - **Severidad**: Menor
  - **Propuesta**: Definir límite en fases posteriores del workflow tras mapear casos de uso
- **Pregunta**: ¿Soportar webhooks de terceros como canal de notificación?
  - **Categoría**: Dependencias externas
  - **Impacto**: Define integraciones y alcance de canales
  - **Severidad**: Menor
  - **Propuesta**: Decidir en fases posteriores del workflow si es post-MVP

## Gate de avance

- **Inventario de preguntas identificadas**:
  - [Importante] ¿La app mobile ya tiene push notifications habilitadas? — Estado: pendiente
  - [Menor] ¿Frecuencia máxima de notificaciones por usuario? — Estado: pendiente
  - [Menor] ¿Soportar webhooks de terceros como canal de notificación? — Estado: pendiente
- **Alerta al usuario**: Hay una pregunta Importante pendiente (push mobile). Se avanza asumiendo que si no hay push, se difiere a post-MVP y se cubre email + in-app para el MVP.
- **Estado final de avance**: Condicionado — `status: conditional`, `next: mapear-assumptions`
