---
idea_slug: dashboard-metrics-interno
funcionalidad_slug: dashboard-metrics-interno
domain: analytics
date: 2026-08-11
skill: evaluar-conectividad-tecnica
modo: greenfield
input: docs/analytics/idea/dashboard-metrics-interno/scope-roadmap.md
status: ready
next: capturar-requerimiento
---

# Prerequisites Assessment: dashboard-metrics-interno

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

- **Funcionalidad**: dashboard-metrics-interno
- **Veredicto**: Conectado (greenfield)
- **Gaps críticos**: Ninguno
- **Próximo paso**: `capturar-requerimiento`
- **Decisión clave**:
  - El repositorio es greenfield, sin producto previo.
  - La funcionalidad construye su propia infraestructura.
  - No existen prerequisitos técnicos que falten.

## Infraestructura Existente

- **greenfield**: sin infraestructura de producto previa
- **Auth**
  - Estado: No existe (greenfield)
  - Notas: Se requiere auth interno básico para acceso al dashboard.
- **Database**
  - Estado: No existe (greenfield)
  - Notas: Se usará PostgreSQL para métricas históricas.
- **APIs**
  - Estado: No existe (greenfield)
  - Notas: REST API para servir datos agregados.
- **Servicios**
  - Estado: No existe (greenfield)
  - Notas: Ingest pipeline para recibir eventos desde otros servicios internos.
- **Frontend**
  - Estado: No existe (greenfield)
  - Notas: SPA en React con visualización de métricas en tiempo real.
- **Monitoring**
  - Estado: No existe (greenfield)
  - Notas: Se configurará logging estructurado básico.

## Prerequisitos de la Funcionalidad

- **Componentes necesarios**
  - Frontend dashboard en React
  - Backend API REST para métricas agregadas
  - Database PostgreSQL para métricas históricas
  - Ingest pipeline para eventos de métricas
  - Auth básico interno
- **Integraciones requeridas**
  - Servicios internos que emiten eventos de métricas
  - Sistema de auth interno existente (si se comparte con otros productos)
- **Patrones arquitectónicos**
  - Event-driven para ingest de métricas
  - REST API para consultas
  - SPA con actualización periódica

## Gaps Identificados

- **Prerequisitos faltantes**: Ninguno. Greenfield puro: todo se crea para la funcionalidad.
- **Upgrades necesarios**: Ninguno.
- **Deuda técnica relevante**: Ninguna.

## Evaluación de Conectividad

- **Estado**: Conectado (greenfield)
- **Justificación**:
  - El repositorio no tiene producto previo.
  - La funcionalidad no depende de infraestructura existente.
  - Todos los componentes necesarios se construirán dentro del alcance de la funcionalidad.
- **Bloqueadores críticos**: Ninguno

## Recomendaciones

- **Conectado (greenfield)**: Proceder a `capturar-requerimiento`.

## Acceptance Criteria

- AC1: El dashboard consume eventos de métricas desde al menos un servicio interno
- AC2: Los usuarios internos pueden ver métricas agregadas en tiempo real
- AC3: Los datos históricos se almacenan en PostgreSQL
- AC4: El acceso al dashboard requiere autenticación interna

## Dependencias

- **Upstream**
  - `docs/analytics/idea/dashboard-metrics-interno/scope-roadmap.md` (alcance definido)
  - `docs/analytics/idea/dashboard-metrics-interno/idea-analysis.md` (descripción del producto)
- **Downstream**
  - `capturar-requerimiento` (estructurar requerimiento formal)

## Matriz de Prerequisitos vs Existentes

- **Frontend dashboard**
  - Existe en codebase: No
  - Suficiente: N/A
  - Acción requerida: Crear SPA en React
- **Backend API**
  - Existe en codebase: No
  - Suficiente: N/A
  - Acción requerida: Crear REST API para métricas
- **Database PostgreSQL**
  - Existe en codebase: No
  - Suficiente: N/A
  - Acción requerida: Crear schema y migraciones iniciales
- **Ingest pipeline**
  - Existe en codebase: No
  - Suficiente: N/A
  - Acción requerida: Crear servicio para recibir eventos de métricas
- **Auth básico**
  - Existe en codebase: No
  - Suficiente: N/A
  - Acción requerida: Implementar auth interno JWT o session-based

## Gate de avance

- **Inventario de preguntas identificadas**:
  - [Menor] ¿Tipo de auth: JWT o session-based?
    - Estado: resuelta inline
    - Nota: JWT, por consistencia con servicios internos
  - [Menor] ¿Periodicidad de actualización del dashboard en tiempo real?
    - Estado: resuelta inline
    - Nota: Pull cada 30 segundos; no se requiere WebSocket en MVP
- **Alerta al usuario**:
  - No necesaria. Todas las Críticas/Importantes se resolvieron inline durante el análisis.
- **Estado final de avance**:
  - Libre
  - `status: ready`
  - `next: capturar-requerimiento`

## Estado de avance

- **Veredicto de conectividad**: Conectado (greenfield)
- **status**: ready
- **next**: capturar-requerimiento
- **Justificación**:
  - El repositorio es greenfield y la funcionalidad construye su propia base.
  - No hay preguntas críticas ni importantes sin resolver.
  - El análisis confirma que no falta infraestructura previa.
