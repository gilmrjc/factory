# Template: Prerequisites Assessment

Template para estructurar el artefacto de salida de `evaluar-conectividad-tecnica` en modo codebase-existente o greenfield completo.

**Nota**: Si el repo es greenfield Y `profile: lite`, usa el template short-form en [prerequisites-assessment-greenfield-short-form-template.md](prerequisites-assessment-greenfield-short-form-template.md) en lugar de este template completo.

## Table of Contents

- [Objetivo del artefacto](#objetivo-del-artefacto)
- [Frontmatter requerido](#frontmatter-requerido-al-inicio-del-documento)
- [Estructura del documento](#estructura-del-documento)
  - [Infraestructura Existente](#1-infraestructura-existente)
  - [Prerequisitos de la Funcionalidad](#2-prerequisitos-de-la-funcionalidad)
  - [Gaps Identificados](#3-gaps-identificados)
  - [Evaluación de Conectividad](#4-evaluación-de-conectividad)
  - [Recomendaciones](#5-recomendaciones)
  - [Acceptance Criteria](#6-acceptance-criteria-si-disponibles)
  - [Dependencias](#7-dependencias-upstreamdownstream)
  - [Listas requeridas](#8-listas-requeridas)
  - [Gate de avance](#9-gate-de-avance-fase-g)
  - [Estado de avance y next](#10-estado-de-avance-y-next)
  - [Autoevaluación](#11-autoevaluación)
- [Convenciones de formato](#convenciones-de-formato)
- [Validación de calidad](#validación-de-calidad)
- [Ejemplo de referencia](#ejemplo-de-referencia)

## Objetivo del artefacto

Documento de decisión que responde: ¿el codebase actual soporta la funcionalidad, o qué falta para que la soporte? Registra la infraestructura existente, los prerequisitos de la funcionalidad, los gaps, el veredicto de conectividad y la recomendación de avance. No implementa ni modifica código: prepara la funcionalidad para el siguiente paso del workflow.

## Frontmatter requerido (al inicio del documento)

```yaml
---
feature_slug: <FEATURE-SLUG>  # usar epic_slug si scope es epic
domain: <domain>
date: <YYYY-MM-DD>
skill: evaluar-conectividad-tecnica
modo: codebase-existente | greenfield | greenfield-short-form
input: <ruta del artefacto fuente (scope-roadmap o epic)>
status: ready | conditional | blocked
next: <según veredicto de conectividad, ver Fase D>
---
```

- **modo**: `codebase-existente` (repo con producto previo), `greenfield` (repo sin producto previo, assessment completo), `greenfield-short-form` (greenfield Y `profile: lite`, assessment reducido).
- **status**: `ready` (avance libre), `conditional` (Importantes sin resolver), `blocked` (Críticas sin resolver o información insuficiente). Lógica en el SKILL.md Fase D.
- **next**: la señal de routing al siguiente skill. Presente solo cuando `status` es `ready` o `conditional`. El valor se define en la Fase D según el veredicto de conectividad. Omite `next` si `status: blocked`.

## Estructura del documento

**IMPORTANTE**: El artefacto final debe incluir un Table of Contents (TOC) al inicio, después del título principal y antes de la primera sección. El TOC debe incluir enlaces a todas las secciones principales y subsecciones del documento.

### 1. Infraestructura Existente

```markdown
## Infraestructura Existente

- **Auth**: [Estado actual o "No existe"]
- **Database**: [Estado actual o "No existe"]
- **APIs**: [Estado actual o "No existe"]
- **Servicios**: [queue, cache, search, email, etc. — estado actual o "No existe"]
- **Frontend**: [Framework y patrones, o "No existe"]
- **Monitoring**: [Logging, métricas, alertas, o "No existe"]
```

En modo greenfield, declara "greenfield — sin infraestructura previa" como primer ítem y deja el resto como "No existe (greenfield)".

### 2. Prerequisitos de la Funcionalidad

```markdown
## Prerequisitos de la Funcionalidad

- **Componentes necesarios**: [Lista]
- **Integraciones requeridas**: [Lista]
- **Patrones arquitectónicos**: [Lista]
```

### 3. Gaps Identificados

```markdown
## Gaps Identificados

- **Prerequisitos faltantes**: [Lista con impacto]
- **Upgrades necesarios**: [Lista con esfuerzo]
- **Deuda técnica relevante**: [TODOs, FIXMEs, legacy, known limitations]
```

### 4. Evaluación de Conectividad

```markdown
## Evaluación de Conectividad

- **Estado**: Conectado | Conectado (greenfield) | Desconectado
- **Justificación**: [Por qué este veredicto, citando los criterios del SKILL.md Fase B]
- **Bloqueadores críticos**: [Lista si aplica, o "Ninguno"]
```

### 5. Recomendaciones

```markdown
## Recomendaciones

- Si conectado: Proceder al siguiente paso del workflow
- Si desconectado: Revisar bridge roadmap y proceder a priorizar features puente
```

### 6. Acceptance Criteria (si disponibles)

```markdown
## Acceptance Criteria

- [AC del epic/funcionalidad si están disponibles en el artefacto fuente, o "No disponibles en esta etapa"]
```

### 7. Dependencias Upstream/Downstream

```markdown
## Dependencias

- **Upstream**: [Artefactos/skills que alimentan este assessment]
- **Downstream**: [Skills que consumen este assessment según el veredicto de conectividad]
```

### 8. Listas requeridas

Listas que deben aparecer en el documento (pueden integrarse en las secciones 1–3 o ir como sección aparte):

```markdown
### Requisitos Técnicos

- **<Requisito>** (<Tipo>): <Detalle>

### Análisis del Codebase Actual

- **<Componente>** — Estado: <Estado>. Notas: <Notas>

### Matriz de Prerequisitos vs Existentes

- **<Prerequisito>** — Existe en codebase: <Sí/No>. Suficiente: <Sí/No>. Acción requerida: <Acción>
```

### 9. Gate de avance

**Obligatoria** incluso si todas las preguntas se resolvieron inline durante las Fases A o B.

```markdown
## Gate de avance

- **Inventario de preguntas identificadas**:
  - [Crítica/Importante/Menor] <pregunta> — Estado: resuelta inline | resuelta en gate | pendiente
- **Alerta al usuario**: [No necesaria — todas las Críticas/Importantes resueltas inline | Sí, ver registro]
- **Estado final de avance**: Bloqueado | Condicionado | Libre
```

### 10. Estado de avance y next

El `status` y `next` se fijan en el frontmatter según el veredicto de conectividad (Fase B) y el gate (Fase D). La lógica de mapeo veredicto → status/next está definida en el SKILL.md Fase D. Esta sección del body documenta la justificación:

```markdown
## Estado de avance

- **Veredicto de conectividad**: Conectado | Conectado (greenfield) | Desconectado
- **status**: ready | conditional | blocked
- **next**: [según veredicto, ver Fase D] (omito si blocked)
- **Justificación**: [Por qué este status/next, alineado con el veredicto de conectividad y el gate]
```

### 11. Autoevaluación

```markdown
## Autoevaluación

[Checklist de validación — ver references/autoevaluacion-checklist.md]
```

## Convenciones de formato

- Sin emojis en el documento. Usa texto como `Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`. Símbolos tipográficos estándar como `→`, `—`, `≥`, `≤` sí están permitidos.
- Nombres de funcionalidades y slugs en kebab-case.
- Rutas de artefactos en backticks.
- Nombres de skills en backticks al referenciarlos.

## Validación de calidad

El documento está completo cuando:

1. El frontmatter tiene `prd_slug`/`epic_slug`, `domain`, `date`, `skill`, `scope`, `modo`, `input`, `status` y `next` declarados (`next` ausente si `status: blocked`).
2. La infraestructura existente está mapeada (o declarada greenfield).
3. Los prerequisitos de la funcionalidad están listados.
4. Los gaps están identificados con impacto.
5. El veredicto de conectividad cita los criterios del SKILL.md Fase B.
6. Las tres listas requeridas están presentes y completas.
7. El gate de avance está documentado con inventario y estado final.
8. El `status` y `next` del frontmatter son consistentes con el veredicto y el gate.
9. La autoevaluación pasa todos los ítems.

## Ejemplo de referencia

Para un ejemplo completo del documento final en modo codebase-existente, consulta [references/examples/example-prerequisites-assessment.md](../references/examples/example-prerequisites-assessment.md) — assessment de "notificaciones-push" en modo codebase-existente, veredicto conectado, con todas las secciones desarrolladas.

Para un ejemplo en modo greenfield-short-form, consulta [references/examples/example-prerequisites-assessment-greenfield-short-form.md](../references/examples/example-prerequisites-assessment-greenfield-short-form.md) — assessment de "dashboard-metrics-interno" en modo greenfield-short-form, veredicto conectado (greenfield).
