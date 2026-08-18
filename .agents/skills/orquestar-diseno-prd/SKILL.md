---
name: orquestar-diseno-prd
description: >-
  Toma un requerimiento validado y produce un PRD formal. Define usuarios,
  mapea casos de uso con happy path, alternativas y edge cases, valida
  flujos complejos con demo opcional, diseña experimentos (Growth/Scale)
  y consolida visión, requisitos funcionales, no-funcionales y criterios
  experimentales en `prd.md`. Genera `personas-mapping.md`, `use-cases.md`,
  `experiment-design.md` (condicional), `prd-workflow-summary.md` y el
  roadmap actualizado. Ready for: `planificar-epics`.
---

# Orquestador de Diseño de PRD

Orquesta la segunda mitad del proceso: toma un requerimiento validado, define usuarios, mapea casos de uso, diseña experimentos (si aplica) y consolida todo en un PRD formal.

**Fases**:
0.5. **Reconstrucción de estado** — Lee `workflow-state.md` y carga artefactos de descubrimiento (`requirements.md`, `product-viability.md`, `assumption-map.md`).
1. `definir-usuarios` — Personas canónicas + mapeo por PRD.
2. `mapear-casos-uso` — Happy path, alternativas, edge cases, success metrics.
3. `construir-demo` (opcional) — Visibilidad de flujos complejos.
4. `disenar-experimentos` (condicional) — Solo para stage Growth/Scale.
5. `generar-prd` — PRD formal consolidado.
6. Loop de procesamiento para múltiples funcionalidades aprobadas.
7. Consolidar resultados y generar `roadmap.md` actualizado.
8. Gate de cierre y reporte final.

## Cuándo usarlo y cuándo no

- **Sí**: el usuario tiene un requerimiento validado (`product-viability.md` con Go/Conditional Go) y quiere generar el `prd.md`.
- **No**: no se ha validado viabilidad (usa `orquestar-descubrimiento-producto` primero), el usuario quiere el proceso completo de idea a PRD (usa `orquestar-descubrimiento-producto` seguido de `orquestar-diseno-prd`), o quiere ejecutar un skill individual (invócalo directamente).

## Entrada y salida

- **Entrada**: `PRD-SLUG` (string, obligatorio) — slug de la funcionalidad aprobada en descubrimiento. `IDEA-SLUG` es opcional para contexto.
- **Salida**: `docs/<domain>/initiatives/<PRD-SLUG>/prd.md` (Main Deliverable), `personas-mapping.md`, `use-cases.md`, `experiment-design.md` (condicional o stub), `prd-workflow-summary.md`; actualiza `docs/<domain>/roadmap.md`.
- **Ready for**: `planificar-epics` | `needs-review` | `blocked`.

## Referencias compartidas

| Referencia | Rol |
|------------|-----|
| [file-discovery.md](references/file-discovery.md) | Resolución de entradas compartida |
| [state-reconstruction.md](references/state-reconstruction.md) | Reanudación y skip-check |
| [artifact-catalog.md](references/artifact-catalog.md) | Inventario de artefactos |
| [orchestrator-pattern.md](references/orchestrator-pattern.md) | Template de orquestadores |

## Protocolo de delegación

Delega cada fase a un agente hijo que lee el `SKILL.md` del skill hijo, ejecuta la fase y termina con el handoff block. En hosts sin delegación, ejecuta inline.

### Handoff block template

```markdown
## Handoff — <nombre-fase>
- PRD-SLUG: …
- IDEA-SLUG: …
- Artefacto: <ruta o "none">
- Ready for / Siguiente paso: <valor del menú del skill>
- Bloqueadores: <lista o "none">
- Resumen: <2–4 oraciones>
```

## Fases

### Fase 0.5 — Reconstrucción y Carga de Artefactos

Aplica [state-reconstruction.md](references/state-reconstruction.md). Verifica que existan:
- `docs/<domain>/idea/<IDEA-SLUG>/<PRD-SLUG>/captured-requirement.md` (o `requirements.md`)
- `docs/<domain>/idea/<IDEA-SLUG>/<PRD-SLUG>/product-viability.md` con Go/Conditional Go
- `docs/<domain>/idea/<IDEA-SLUG>/<PRD-SLUG>/assumption-map.md` (recomendado) o stub de omisión

Si falta `product-viability.md` o el veredicto es No-Go, detente con `Ready for: orquestar-descubrimiento-producto`.

### Fase F — Definir Usuarios

Invoca `definir-usuarios [PRD-SLUG]`. Genera/actualiza personas canónicas en `docs/<domain>/personas/` y el mapeo en `docs/<domain>/initiatives/<PRD-SLUG>/personas-mapping.md`.

### Fase G — Mapear Casos de Uso

Invoca `mapear-casos-uso [PRD-SLUG]` usando `personas-mapping.md`. Genera `use-cases.md`.

### Fase G.5 — Demo Opcional

Si los casos de uso incluyen flujos complejos (state machines, sync, multi-paso) y el equipo lo solicita, invoca `construir-demo` con `use-cases.md` como contexto. No bloquea.

### Fase G.6 — Diseñar Experimentos (condicional)

Lee el stage desde `product-viability.md` o `personas-mapping.md`.

- Stage MVP: omite y genera stub `experiment-design.md` con justificación.
- Stage Growth/Scale: invoca `disenar-experimentos [PRD-SLUG]`.

### Fase H — Generar PRD

Invoca `generar-prd [PRD-SLUG]` consolidando `requirements.md`, `product-viability.md`, `personas-mapping.md`, `use-cases.md` y `experiment-design.md` (o stub). Genera `prd.md` con `Ready for: planificar-epics`.

### Fase I — Loop de Procesamiento

Si `discovery-state.md` tiene más funcionalidades en `viabilidad-go` sin PRD, selecciona la siguiente y repite desde Fase F. Si no, continúa a Fase J.

### Fase J — Consolidar Resultados

Actualiza `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md` con PRDs generados y estados.

### Fase K.1 — Gate de Cierre

Verifica contra [artifact-catalog.md](references/artifact-catalog.md) que existan: `prd.md`, `discovery-state.md`, `prd-workflow-summary.md`, `roadmap.md`, `workflow-state.md`. Si falta alguno, genera o registra omisión justificada.

### Fase K.2 — Reporte y Salida

Escribe `docs/<domain>/initiatives/<PRD-SLUG>/prd-workflow-summary.md` con:
- Resumen del requerimiento y viabilidad heredados
- Personas y casos de uso clave
- Experimentos diseñados u omisión justificada
- Lista de PRDs generados
- Quality checklist por PRD
- Ready for: `planificar-epics`
- Siguiente eslabón: `orquestar-epic-workflow/SKILL.md`

## Autoevaluación antes de terminar

- ¿Cargó `requirements.md` y `product-viability.md` (Go/Conditional Go) antes de empezar?
- ¿Generó `personas-mapping.md` y `use-cases.md`?
- ¿Omitió o ejecutó `disenar-experimentos` según el stage con registro?
- ¿Generó `prd.md` con `Ready for: planificar-epics`?
- ¿Actualizó `discovery-state.md` y `roadmap.md`?
- ¿Verificó artefactos de cierre contra `artifact-catalog.md`?

## Termina cuando

El `prd.md` está en disco, `prd-workflow-summary.md` tiene `Ready for: planificar-epics`, todos los artefactos de cierre obligatorios existen o están justificados, y el reporte final enlaza `orquestar-epic-workflow/SKILL.md`.

```markdown
## Handoff — orquestar-diseno-prd
- IDEA-SLUG: …
- PRD-SLUG: …
- Skills root: …
- PRD: <ruta>
- Ready for: planificar-epics | needs-review | blocked
- Blockers: <lista o "none">
- Summary: <2–4 oraciones>
- Siguiente eslabón: orquestar-epic-workflow/SKILL.md
```
