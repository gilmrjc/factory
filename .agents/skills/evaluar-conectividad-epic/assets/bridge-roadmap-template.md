# Roadmap de Funcionalidades Puente: <EPIC-SLUG>

Template para estructurar el artefacto de salida de `evaluar-conectividad-epic` cuando el epic está desconectado o parcialmente conectado.

## Objetivo del artefacto

Documento de planificación que responde: ¿qué funcionalidades puente construyen la infraestructura necesaria para que el epic se pueda implementar? Cada funcionalidad puente tiene valor por sí misma y aporta un prerequisito faltante. Incluye estimación de puntos, acceptance criteria, dependencias, timeline y trade-offs.

## Frontmatter requerido

```yaml
---
epic_slug: <EPIC-SLUG>
prd_slug: <PRD-SLUG>
domain: <domain>
date: <YYYY-MM-DD>
skill: evaluar-conectividad-epic
input: <ruta a prerequisites-assessment.md>
status: ready
next: implementar-bridge
---
```

- **status**: siempre `ready` — el roadmap se genera solo cuando el epic requiere funcionalidades puente.
- **next**: siempre `implementar-bridge`.

## Resumen

- **Epic objetivo**: <EPIC-NOMBRE>
- **Estado de conectividad**: Parcialmente conectado / Desconectado
- **Objetivo del bridge**: Construir prerequisitos faltantes para conectar el epic al codebase

## Análisis de Desconexión

- **Bloqueadores principales**: [lista]
- **Infraestructura faltante**: [lista]
- **Estimación de esfuerzo total**: [X puntos / Y semanas]

## Funcionalidades Puente

Una sección por funcionalidad puente, en orden de dependencia.

### Funcionalidad Puente 1: <NOMBRE>

- **Prerequisitos que construye**: [lista]
- **Value proposition**: [valor por sí misma]
- **Alcance**: [lista de tareas]
- **Acceptance Criteria**: [lista]
- **Esfuerzo estimado**: [1-8 puntos]
- **Dependencias**: [Ninguna | lista]
- **Archivos/componentes que toca**: [lista]

### Funcionalidad Puente N: <NOMBRE>

...

## Epic Objetivo

La implementación del epic una vez construidos los prerequisitos.

- **Prerequisitos requeridos**: [lista de funcionalidades puente]
- **Value proposition**: [valor final]
- **Esfuerzo estimado**: [X puntos]
- **Success criteria**: [cómo validar]

## Secuencia de Implementación

1. Funcionalidad Puente 1 — Semana X
2. Funcionalidad Puente 2 — Semana Y
3. ...

**Paralelización**: [qué se puede hacer en paralelo y qué no]

## Trade-offs

### Opción A: <descripción>

- **Ventajas**: ...
- **Desventajas**: ...
- **Riesgos**: ...

### Opción B: <descripción>

- **Ventajas**: ...
- **Desventajas**: ...
- **Riesgos**: ...

### Opción C: <descripción>

- **Ventajas**: ...
- **Desventajas**: ...
- **Riesgos**: ...

## Recomendación

- **Opción seleccionada**: [A/B/C]
- **Justificación**: [por qué]
- **Next step**: `implementar-bridge`

## Convenciones de formato

- Sin emojis.
- Estimaciones en puntos de esfuerzo (1-8).
- Cada funcionalidad puente con value proposition independiente.
- Dependencias sin ciclos.
- Epic objetivo referencia todas las funcionalidades puente como dependencias.
