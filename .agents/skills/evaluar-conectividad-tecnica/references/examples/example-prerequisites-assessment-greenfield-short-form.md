---
prd_slug: dashboard-metrics-interno
domain: analytics
date: 2026-08-11
skill: evaluar-conectividad-tecnica
scope: prd
modo: greenfield-short-form
input: docs/analytics/idea/dashboard-metrics-interno/scope-roadmap.md
status: ready
next: capturar-requerimiento
---

# Prerequisites Assessment: dashboard-metrics-interno

## Veredicto: Conectado (greenfield)

El repo `internal-metrics-dashboard` es greenfield: sin codebase/producto previo, sin infraestructura de producto. La funcionalidad es el primer entregable — no extiende uno existente. Conectividad: conectado por vacío (sin prerequisitos previos que falten).

## Componentes a crear (lista mínima)

- **Frontend dashboard** — SPA en React con visualización de métricas en tiempo real
- **Backend API** — Endpoints REST para servir datos de métricas agregadas
- **Database** — PostgreSQL para almacenamiento de métricas históricas
- **Ingest pipeline** — Servicio para recibir y procesar eventos de métricas desde otros servicios internos
- **Auth básico** — Autenticación simple para acceso interno (JWT o session-based)
