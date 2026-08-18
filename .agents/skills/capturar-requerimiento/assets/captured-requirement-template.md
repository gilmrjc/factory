# Template: Captured Requirement

Template para el artefacto de salida de `capturar-requerimiento`.

## Frontmatter requerido

```yaml
---
idea_slug: <IDEA-SLUG>
domain: <DOMAIN>
date: <YYYY-MM-DD>
skill: capturar-requerimiento
input: <ruta del artefacto fuente o descripción pegada>
status: ready | conditional | blocked
next: <mapear-assumptions | validar-viabilidad-producto>
---
```

## Table of Contents

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Contexto](#contexto)
- [Problema](#problema)
- [Audiencia Afectada](#audiencia-afectada)
- [Resultado Esperado](#resultado-esperado)
- [Solución Propuesta](#solución-propuesta)
- [Preguntas Abiertas](#preguntas-abiertas)
- [Gate de avance](#gate-de-avance)

`status` y `next` van en el frontmatter, no como sección del body. `next` se omite si `status: blocked`.

## Resumen Ejecutivo

[1-2 oraciones que resuman el requerimiento, el problema y el resultado esperado.]

## Contexto

[¿Por qué importa ahora? ¿Qué cambio externo o interno lo activa? ¿Qué iniciativa o decisión previa lo contextualiza?]

## Problema

[Descripción clara del pain point. Síntomas actuales, quién lo sufre y workaround actual.]

## Audiencia Afectada

- **Primaria**: [quién sufre el problema más; magnitud si se conoce]
- **Secundaria**: [quién se beneficia indirectamente]
- **Interna**: [roles o áreas internas impactadas]

## Resultado Esperado

[Estado final al que se quiere llegar. Qué cambia para el usuario o el negocio después de implementarlo.]

## Solución Propuesta

[Descripción de alto nivel de qué se va a construir, en lenguaje simple. Solo el "qué" y para quién, no el "cómo".]

**No-solutionización**: las decisiones de formato, esquemas, mecanismos, endpoints, políticas y algoritmos se definen en fases posteriores del workflow.

## Preguntas Abiertas

Usa [assets/open-questions-template.md](assets/open-questions-template.md).

```markdown
- **Pregunta**: [descripción concreta del unknown]
  - **Categoría**: [Información faltante | Incertidumbre técnica | Ambigüedad de requisitos | Dependencias externas | Riesgos identificados]
  - **Impacto**: [cómo afecta al proyecto si no se resuelve]
  - **Severidad**: [Crítica | Importante | Menor]
  - **Propuesta**: [cómo se puede resolver]
```

## Gate de avance

- **Inventario de preguntas identificadas**:
  - [<Severidad>] <Pregunta> — Estado: <resuelta inline | resuelta en gate | pendiente>
- **Alerta al usuario**: <No necesaria / Sí — se ofreció responder y el usuario decidió...>
- **Estado final de avance**: <Libre | Condicionado | Bloqueado> — `status: <ready | conditional | blocked>`, `next: <skill>`
