# Guía de Evaluación de Conectividad

Esta guía define cómo determinar si la funcionalidad está conectada al producto actual y qué hacer cuando está desconectada.

## Criterios de conectividad

La funcionalidad está conectada cuando:

- Prerequisitos críticos existen.
- Prerequisitos faltantes son alcanzables sin requerir nuevas funcionalidades puente.
- Patrones arquitectónicos son compatibles.
- Integración con bounded contexts existentes es posible.
- **Greenfield**: sin prerequisitos previos que falten → conectado por vacío.

## Si la funcionalidad está conectada

- El workflow continúa al siguiente paso.
- Genera el prerequisites-assessment con análisis positivo (en modo greenfield, con veredicto "conectado (greenfield)" y justificación). La ruta del artefacto está definida en el SKILL.md Fase C.

## Si la funcionalidad está parcialmente conectada

Señales de conexión parcial:

- Los prerequisitos críticos existen.
- Faltan requisitos no críticos o hay deuda técnica que dificulta la implementación directa.
- La funcionalidad puede avanzar con funcionalidades puente limitadas o con un trabajo de mejora técnica.

Acción: genera el `prerequisites-assessment` documentando los gaps no críticos. Decide con el usuario si generar un bridge roadmap pequeño o avanzar a `capturar-requerimiento` con advertencias.

## Si la funcionalidad está desconectada

Señales de desconexión:

- Faltan prerequisitos críticos que no existen.
- Infraestructura base no está presente.
- Patrones arquitectónicos son incompatibles.
- Integración requiere refactor mayor.

Genera un roadmap de **funcionalidades puente**:

- Funcionalidades intermedias que construyen la infraestructura necesaria.
- Cada funcionalidad puente tiene valor por sí misma.
- Secuencia lógica de dependencias.
- No asignes puntos de complejidad: el esfuerzo se puntúa en `priorizar-roadmap` (Effort, escala 1-10).

## Ejemplo canónico

Funcionalidades puente para "sistema de recomendaciones ML":

1. Funcionalidad puente 1: Sistema de tracking de eventos (value: analytics básico).
2. Funcionalidad puente 2: Data warehouse y pipelines ETL (value: reporting).
3. Funcionalidad puente 3: API de modelo simple (value: integraciones externas).
4. Funcionalidad puente 4: Sistema de recomendaciones básico (value: recommendations rule-based).
5. Funcionalidad objetivo: Sistema de recomendaciones ML completo.
