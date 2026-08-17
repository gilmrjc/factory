# Guía de Evaluación de Conectividad

Esta guía define cómo determinar si la funcionalidad está conectada al producto actual y qué hacer cuando está desconectada.

## Criterios de conectividad

La funcionalidad está conectada cuando:

- Prerequisitos críticos existen.
- Prerequisitos faltantes son alcanzables con esfuerzo razonable (< 2 semanas).
- Patrones arquitectónicos son compatibles.
- Integración con bounded contexts existentes es posible.
- **Greenfield**: sin prerequisitos previos que falten → conectado por vacío.

## Si la funcionalidad está conectada

- El workflow continúa al siguiente paso.
- Genera el prerequisites-assessment con análisis positivo (en modo greenfield, con veredicto "conectado (greenfield)" y justificación). La ruta del artefacto está definida en el SKILL.md Fase C (Decidir Routing).

## Si la funcionalidad está desconectada

Señales de desconexión:

- Faltan prerequisitos críticos que no existen.
- Infraestructura base no está presente.
- Patrones arquitectónicos son incompatibles.
- Integración requiere refactor mayor.

Genera un roadmap de **features puente**:

- Features intermedias que construyen la infraestructura necesaria.
- Cada feature puente tiene valor por sí misma.
- Secuencia lógica de dependencias.
- Estimación de esfuerzo por feature.

## Ejemplo canónico

Features puente para "sistema de recomendaciones ML":

1. Feature puente 1: Sistema de tracking de eventos (value: analytics básico).
2. Feature puente 2: Data warehouse y pipelines ETL (value: reporting).
3. Feature puente 3: API de modelo simple (value: integraciones externas).
4. Feature puente 4: Sistema de recomendaciones básico (value: recommendations rule-based).
5. Feature objetivo: Sistema de recomendaciones ML completo.
