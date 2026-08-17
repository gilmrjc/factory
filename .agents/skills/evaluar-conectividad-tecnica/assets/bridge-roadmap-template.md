# Template: Bridge Roadmap

Template para estructurar el artefacto de salida de `evaluar-conectividad-tecnica` cuando la funcionalidad está desconectada. La ruta del artefacto está definida en el SKILL.md Fase C (Decidir Routing).

## Objetivo del artefacto

Documento de planificación que responde: ¿qué features puente construyen la infraestructura necesaria para que la funcionalidad objetivo pueda entregarse? Cada feature puente tiene valor por sí misma — no es trabajo preparatorio invisible, sino funcionalidad que el usuario puede usar mientras construye el camino hacia el objetivo. Prepara las features puente para priorización.

Solo se genera cuando el `prerequisites-assessment` declaró la funcionalidad como **desconectada**. Si la funcionalidad está conectada, este artefacto no se escribe.

## Frontmatter requerido (al inicio del documento)

```yaml
---
prd_slug: <PRD-SLUG>          # usar epic_slug si scope es epic
domain: <domain>
date: <YYYY-MM-DD>
skill: evaluar-conectividad-tecnica
scope: prd | epic
input: prerequisites-assessment.md
status: ready
next: <priorización de features puente>
---
```

- **scope**: `prd` si la evaluación es a nivel PRD/funcionalidad, `epic` si es a nivel epic. Cambia la ruta del artefacto, no la estructura.
- **status**: siempre `ready` — el bridge roadmap se genera solo cuando la funcionalidad está desconectada y el veredicto es proceder a priorizar features puente.
- **next**: siempre apunta a priorización — las features puente necesitan priorización antes de implementarse.

## Estructura del documento

### 1. Análisis de Desconexión

```markdown
## Análisis de Desconexión

- **Bloqueadores principales**: [Lista — qué prerequisitos críticos faltan]
- **Infraestructura faltante**: [Lista — qué componentes base no están presentes]
- **Estimación de esfuerzo total**: [X semanas — suma de features puente + objetivo]
```

### 2. Features Puente

Una sección por feature puente, en orden de dependencia. Cada feature puente tiene valor por sí misma — si no aporta valor independiente, no es feature puente, es trabajo preparatorio y debe repensarse.

```markdown
## Features Puente

### Feature Puente 1: <Nombre>

- **Prerequisitos que construye**: [Lista — qué infraestructura habilita]
- **Value proposition**: [Valor por sí misma — qué puede hacer el usuario con esta feature]
- **Esfuerzo estimado**: [X semanas]
- **Dependencias**: [Ninguna | lista de features puente previas]
- **Success criteria**: [Cómo validar que la feature entregó su valor]
```

### 3. Feature Objetivo

La funcionalidad original, ahora con sus prerequisitos construidos por las features puente.

```markdown
## Feature Objetivo: <FUNCIONALIDAD original>

- **Prerequisitos requeridos**: [Lista de features puente que deben estar listas]
- **Value proposition**: [Valor final — el estado al que conduce el roadmap]
- **Esfuerzo estimado**: [X semanas]
- **Dependencias**: [Todas las features puente]
- **Success criteria**: [Cómo validar que la feature objetivo entregó su valor]
```

### 4. Recomendación de Implementación

```markdown
## Recomendación de Implementación

- **Empezar con**: [Feature puente 1 — la que no tiene dependencias]
- **Justificación**: [Por qué este orden — secuencia lógica de dependencias]
- **Next step**: priorizar features puente
```

## Convenciones de formato

- Sin emojis en el documento. Usa texto como `Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`. Símbolos tipográficos estándar como `→`, `—`, `≥`, `≤` sí están permitidos.
- Nombres de funcionalidades y slugs en kebab-case.
- Rutas de artefactos y nombres de skills en backticks al referenciarlos.
- Cada feature puente debe tener `value proposition` distinto de "preparar la feature objetivo" — si el único valor es preparatorio, repensar la feature.

## Validación de calidad

El documento está completo cuando:

1. El frontmatter tiene `prd_slug`/`epic_slug`, `domain`, `date`, `skill`, `scope`, `input`, `status` y `next` declarados.
2. El análisis de desconexión lista bloqueadores e infraestructura faltante con estimación total.
3. Cada feature puente tiene value proposition independiente (no puramente preparatorio).
4. Las dependencias entre features puente forman una secuencia lógica sin ciclos.
5. La feature objetivo referencia todas las features puente como dependencias.
6. La recomendación de implementación indica por dónde empezar y justifica el orden.
7. El `next` del frontmatter apunta a priorización (consistente con el veredicto de desconexión).

## Ejemplo de referencia

Para un ejemplo completo del documento final, consulta [references/examples/example-bridge-roadmap.md](../references/examples/example-bridge-roadmap.md) — bridge roadmap de "recomendaciones-ml" con 4 features puente encadenadas por dependencias, cada una con value proposition independiente.
