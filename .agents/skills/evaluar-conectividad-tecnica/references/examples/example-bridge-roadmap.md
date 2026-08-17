---
prd_slug: recomendaciones-ml
domain: plataforma
date: 2026-08-10
skill: evaluar-conectividad-tecnica
scope: prd
input: prerequisites-assessment.md
status: ready
next: priorizar-roadmap
---

# Bridge Roadmap: recomendaciones-ml

## Table of Contents

- [Análisis de Desconexión](#análisis-de-desconexión)
- [Features Puente](#features-puente)
- [Feature Objetivo](#feature-objetivo)
- [Recomendación de Implementación](#recomendación-de-implementación)

## Análisis de Desconexión

- **Bloqueadores principales**: No existe sistema de tracking de eventos de usuario. No existe data warehouse ni pipelines ETL. No existe servicio de modelo de recomendación.
- **Infraestructura faltante**: Event tracking, data warehouse, ETL pipelines, modelo de recomendaciones, API de recomendaciones.
- **Estimación de esfuerzo total**: 16 semanas (12 semanas de features puente + 4 semanas de feature objetivo)

## Features Puente

### Feature Puente 1: Sistema de tracking de eventos

- **Prerequisitos que construye**: Infraestructura de captura de eventos de usuario (clics, vistas, compras, búsquedas). Base de datos para alimentar el modelo de recomendaciones.
- **Value proposition**: Analytics básico — el equipo de producto puede ver qué hacen los usuarios en la plataforma, qué contenido ven, qué ignoran. Hoy no hay visibilidad de comportamiento.
- **Esfuerzo estimado**: 3 semanas
- **Dependencias**: Ninguna
- **Success criteria**: Eventos de usuario se capturan y almacenan. Dashboard básico muestra top 10 eventos por frecuencia. Equipo de producto consulta eventos sin ayuda de ingeniería.

### Feature Puente 2: Data warehouse y pipelines ETL

- **Prerequisitos que construye**: Almacenamiento estructurado de eventos históricos. Pipelines que transforman eventos crudos en features utilizables por un modelo de ML.
- **Value proposition**: Reporting — el equipo puede construir reportes agregados sobre comportamiento de usuarios (DAU/MAU, retención, funnels). Hoy los reportes requieren queries manuales sobre la DB de producción.
- **Esfuerzo estimado**: 4 semanas
- **Dependencias**: Feature puente 1 (Sistema de tracking de eventos)
- **Success criteria**: Eventos fluyen desde tracking hasta warehouse en < 1 hora. Reportes de DAU/MAU y retención disponibles en dashboard. Equipo construye funnels sin SQL manual.

### Feature Puente 3: API de modelo simple

- **Prerequisitos que construye**: Servicio que consume features del warehouse y devuelve recomendaciones. Patrón de API que el feature objetivo heredará.
- **Value proposition**: Integraciones externas — otros sistemas de la plataforma pueden consultar "contenido popular" y "contenido relacionado" via API. Hoy no existe ninguna forma de obtener recomendaciones de contenido.
- **Esfuerzo estimado**: 3 semanas
- **Dependencias**: Feature puente 2 (Data warehouse y pipelines ETL)
- **Success criteria**: API devuelve recomendaciones rule-based (popular, relacionado por categoría) en < 200ms. Al menos 2 sistemas consumen la API. Cobertura de categorías > 80%.

### Feature Puente 4: Sistema de recomendaciones básico

- **Prerequisitos que construye**: Motor de recomendaciones rule-based que la feature objetivo reemplazará por ML. Validación de que las recomendaciones tienen valor para el usuario antes de invertir en ML.
- **Value proposition**: Recommendations rule-based — los usuarios ven contenido relacionado basado en reglas simples (misma categoría, popular entre usuarios similares). Hoy no hay recomendaciones de ningún tipo.
- **Esfuerzo estimado**: 2 semanas
- **Dependencias**: Feature puente 3 (API de modelo simple)
- **Success criteria**: Recomendaciones rule-based se muestran en 3 ubicaciones de la plataforma. CTR de recomendaciones > 3%. Usuarios reportan utilidad en encuesta de satisfacción.

## Feature Objetivo: recomendaciones-ml

- **Prerequisitos requeridos**: Sistema de tracking de eventos, data warehouse y pipelines ETL, API de modelo simple, sistema de recomendaciones básico.
- **Value proposition**: Recomendaciones personalizadas basadas en ML — cada usuario ve contenido relevante basado en su comportamiento y el de usuarios similares, no en reglas estáticas. El estado final al que conduce el roadmap.
- **Esfuerzo estimado**: 4 semanas
- **Dependencias**: Todas las features puente
- **Success criteria**: Modelo de ML entrenado con datos del warehouse. Recomendaciones personalizadas reemplazan rule-based en las 3 ubicaciones. CTR de recomendaciones ML > 5% (mejora sobre rule-based). Latencia de API < 200ms.

## Recomendación de Implementación

- **Empezar con**: Feature puente 1 (Sistema de tracking de eventos)
- **Justificación**: El tracking de eventos es la base de toda la cadena — sin eventos no hay datos para el warehouse, sin warehouse no hay features para el modelo, sin modelo no hay recomendaciones. Cada feature puente siguiente depende de la anterior, y cada una entrega valor independiente al equipo (analytics, reporting, integraciones, recomendaciones rule-based) antes de llegar al objetivo final.
- **Next step**: priorizar features puente
