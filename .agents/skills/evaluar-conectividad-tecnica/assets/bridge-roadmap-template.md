# Template: Roadmap de Funcionalidades Puente

Template para estructurar el artefacto de salida de `evaluar-conectividad-tecnica` cuando la funcionalidad está desconectada o parcialmente conectada. La ruta del artefacto está definida en el SKILL.md Fase C.

## Objetivo del artefacto

Documento de planificación que responde: ¿qué funcionalidades puente construyen la infraestructura necesaria para que la funcionalidad objetivo pueda entregarse? Cada funcionalidad puente tiene valor por sí misma: no es trabajo preparatorio invisible, sino funcionalidad que el usuario puede usar mientras construye el camino hacia el objetivo. Prepara las funcionalidades puente para priorización.

Solo se genera cuando el `prerequisites-assessment` declaró la funcionalidad como **desconectada** o **parcialmente conectada**. Si la funcionalidad está conectada, este artefacto no se escribe.

## Frontmatter requerido (al inicio del documento)

```yaml
---
idea_slug: <IDEA-SLUG>
funcionalidad_slug: <FUNCIONALIDAD-SLUG>  # slug de la funcionalidad dentro del scope-roadmap
domain: <domain>
date: <YYYY-MM-DD>
skill: evaluar-conectividad-tecnica
input: prerequisites-assessment.md
status: ready
next: priorizar-roadmap
---
```

- **status**: siempre `ready` — el roadmap de funcionalidades puente se genera solo cuando la funcionalidad está desconectada o parcialmente conectada y el veredicto es proceder a priorizar.
- **next**: siempre apunta a priorización — las funcionalidades puente necesitan priorización antes de implementarse.

## Estructura del documento

**IMPORTANTE**:
- Incluye un Table of Contents (TOC) después del título y antes de la primera sección.
- Usa listas anidadas para atributos múltiples bajo un mismo ítem.
- No asignes puntos de complejidad. El esfuerzo se puntúa en `priorizar-roadmap` (Effort, escala 1-10).

### 1. Análisis de Desconexión

```markdown
## Análisis de Desconexión

- **Bloqueadores principales**
  - [Bloqueador 1: qué prerequisito crítico falta]
  - [Bloqueador 2]
- **Infraestructura faltante**
  - [Componente base 1 que no está presente]
  - [Componente base 2]
```

### 2. Funcionalidades Puente

Una sección por funcionalidad puente, en orden de dependencia. Cada funcionalidad puente tiene valor por sí misma: si no aporta valor independiente, no es funcionalidad puente, es trabajo preparatorio y debe repensarse.

```markdown
## Funcionalidades Puente

### Funcionalidad Puente 1: <Nombre>

- **Prerequisitos que construye**
  - [Infraestructura o capacidad 1 que habilita]
  - [Infraestructura o capacidad 2]
- **Value proposition**
  - [Valor por sí misma: qué puede hacer el usuario con esta funcionalidad]
  - [Problema de hoy que resuelve]
- **Dependencias**: [Ninguna | lista de funcionalidades puente previas]
- **Success criteria**
  - [Criterio 1]
  - [Criterio 2]
```

### 3. Funcionalidad Objetivo

La funcionalidad original, ahora con sus prerequisitos construidos por las funcionalidades puente.

```markdown
## Funcionalidad Objetivo: <FUNCIONALIDAD original>

- **Prerequisitos requeridos**
  - [Funcionalidad puente 1]
  - [Funcionalidad puente 2]
- **Value proposition**
  - [Valor final: el estado al que conduce el roadmap]
  - [Diferencia respecto al estado actual]
- **Dependencias**: [Todas las funcionalidades puente]
- **Success criteria**
  - [Criterio 1]
  - [Criterio 2]
```

### 4. Recomendación de Implementación

```markdown
## Recomendación de Implementación

- **Empezar con**: [Funcionalidad puente 1: la que no tiene dependencias]
- **Justificación**
  - [Razón 1: por qué este orden]
  - [Razón 2: secuencia lógica de dependencias]
- **Próximo paso inmediato**: priorizar `[funcionalidad-puente-1]` en `priorizar-roadmap`
```

## Convenciones de formato

- Sin emojis en el documento. Usa texto como `Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`.
- Nombres de funcionalidades y slugs en kebab-case.
- Rutas de artefactos y nombres de skills en backticks.
- Símbolos tipográficos como `→`, `≥`, `≤` permitidos. Evita el em dash (`—`) como puntuación.
- Cada funcionalidad puente debe tener `value proposition` distinto de "preparar la funcionalidad objetivo" — si el único valor es preparatorio, repensar la funcionalidad.

## Validación de calidad

El documento está completo cuando:

1. El frontmatter tiene `idea_slug`, `funcionalidad_slug`, `domain`, `date`, `skill`, `input`, `status` y `next` declarados.
2. Table of Contents (TOC) presente después del título y antes de la primera sección.
3. El análisis de desconexión lista bloqueadores e infraestructura faltante.
4. Cada funcionalidad puente tiene value proposition independiente (no puramente preparatorio).
5. Las dependencias entre funcionalidades puente forman una secuencia lógica sin ciclos.
6. La funcionalidad objetivo referencia todas las funcionalidades puente como dependencias.
7. La recomendación de implementación indica por dónde empezar y justifica el orden.
8. El `next` del frontmatter apunta a priorización.

## Ejemplo de referencia

Para un ejemplo completo del documento final, consulta [references/examples/example-bridge-roadmap.md](../references/examples/example-bridge-roadmap.md) — roadmap de funcionalidades puente de "recomendaciones-ml" con 4 funcionalidades puente encadenadas por dependencias, cada una con value proposition independiente.
