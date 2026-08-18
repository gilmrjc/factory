# Patrón de Orquestación — Descubrimiento de Producto

Guía de implementación para `orquestar-descubrimiento-producto`. Documenta el contrato de `discovery-state.md` y cómo los skills del Workflow 1 coordinan el avance de múltiples funcionalidades.

## 1. Propósito

El orquestador recorre una cola de funcionalidades priorizadas, delega cada fase a skills especializados y mantiene `discovery-state.md` como fuente de verdad del avance. El archivo es legible y actualizable tanto por el orquestador como por invocaciones individuales de skills.

## 2. Contrato de `discovery-state.md`

### Ubicación

`docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md`

### Frontmatter

```yaml
---
idea_slug: <IDEA-SLUG>
domain: <DOMAIN>
date: <YYYY-MM-DD>
status: in-progress | complete | blocked
next: <FUNCIONALIDAD-SLUG del ítem a procesar o skill siguiente>
---
```

- `status`: estado global del descubrimiento.
  - `in-progress`: quedan funcionalidades pendientes.
  - `complete`: todas las funcionalidades tienen veredicto de viabilidad.
  - `blocked`: hay un blocker que impide continuar.
- `next`: FUNCIONALIDAD-SLUG activo o skill siguiente.
  - Ejemplos: `notificaciones`, `orquestar-diseno-prd`, `workflow-complete`, `needs-review`.

### Sección `## Cola de funcionalidades`

Cada ítem es una entrada anidada:

```markdown
- **Puesto <N>: `<FUNCIONALIDAD-SLUG>`** — <nombre legible>
  - Origen: Puesto <N> de `feature-prioritization.md`
  - Estado: `<pendiente-captura | conectividad-lista | requerimiento-capturado | assumptions-mapeadas | viabilidad-go | viabilidad-conditional-go | viabilidad-no-go | bloqueado>`
  - Conectividad: `<conectado | parcialmente-conectado | desconectado | greenfield>`
  - Requerimiento: `<ruta a captured-requirement.md o requirements.md | ->`
  - Assumptions: `<ruta a assumption-map.md | stub | ->`
  - Viabilidad: `<ruta a product-viability.md | ->`
  - Veredicto: `<Go | Conditional Go | No-Go | ->`
  - Ready for: `<skill orquestador/skill siguiente>`
```

### Estados permitidos por ítem

| Estado | Significado |
|--------|-------------|
| `pendiente-captura` | Aún no se ha procesado. |
| `conectividad-lista` | `evaluar-conectividad-tecnica` terminó. |
| `requerimiento-capturado` | `capturar-requerimiento` terminó. |
| `assumptions-mapeadas` | `mapear-assumptions` terminó (o stub registrado). |
| `viabilidad-go` | `validar-viabilidad-producto` retornó Go. |
| `viabilidad-conditional-go` | Retornó Conditional Go. |
| `viabilidad-no-go` | Retornó No-Go. |
| `bloqueado` | Preguntas abiertas críticas sin resolver. |

## 3. Flujo del orquestador

### Fases

1. `analizar-idea` — obligatorio. Si el resultado no está claro, `Ready for: esbozar-idea`.
2. `evaluar-alcance-idea` — gate. Si `No proceder`, detener. Genera `scope-roadmap.md`.
3. `priorizar-roadmap` — genera `feature-prioritization.md` y crea/actualiza `discovery-state.md`.
4. `evaluar-conectividad-tecnica` — toma `next`, genera `prerequisites-assessment.md` y `bridge-roadmap.md` si aplica.
5. `capturar-requerimiento` — genera `captured-requirement.md` (o `requirements.md`).
6. `mapear-assumptions` — recomendado. Genera `assumption-map.md` o stub.
7. `construir-spike` — condicional, si `assumption-map.md` indica `spike-required: yes`.
8. `validar-viabilidad-producto` — gate. Actualiza veredicto en `discovery-state.md`.
9. **Loop** — si `next` apunta a un `FUNCIONALIDAD-SLUG` pendiente, repetir desde la fase 4. Si `next` apunta a un skill terminal, continuar a consolidación.
10. **Consolidación** — generar/actualizar `discovery-state.md` con resumen global y `roadmap.md` del dominio.

### Lógica del `next`

- Al inicio de cada vuelta, leer `discovery-state.md` y usar `next`.
- Si `next` es un `FUNCIONALIDAD-SLUG` con `estado: pendiente-captura`, procesar conectividad.
- Si `next` es `capturar-requerimiento`, `mapear-assumptions`, `validar-viabilidad-producto`, etc., invocar ese skill para el `FUNCIONALIDAD-SLUG` actual.
- Si `next` es `orquestar-diseno-prd`, `workflow-complete`, `needs-review` o `blocked`, terminar.

### Features puente

Si `evaluar-conectividad-tecnica` retorna `desconectado` o `parcialmente-conectado`:

1. Genera `bridge-roadmap.md`.
2. Re-ejecuta `priorizar-roadmap` sobre el `bridge-roadmap`.
3. `priorizar-roadmap` actualiza `discovery-state.md` preservando estados previos e insertando la feature puente más prioritaria.

## 4. Responsabilidades de los skills individuales

| Skill | Lee `discovery-state.md` | Actualiza ítem | Campo `next` que deja |
|-------|--------------------------|----------------|------------------------|
| `priorizar-roadmap` | Sí si existe | Crea/actualiza toda la cola | `FUNCIONALIDAD-SLUG` del puesto 1 |
| `evaluar-conectividad-tecnica` | Sí | `estado`, `conectividad`, `prerequisites-assessment`, `bridge-roadmap` | `FUNCIONALIDAD-SLUG` siguiente o `capturar-requerimiento` |
| `capturar-requerimiento` | Sí | `estado`, `Requerimiento` | `FUNCIONALIDAD-SLUG` siguiente o `mapear-assumptions` |
| `mapear-assumptions` | Sí | `estado`, `Assumptions` | `validar-viabilidad-producto` |
| `validar-viabilidad-producto` | Sí | `estado`, `Veredicto`, `Viabilidad` | `FUNCIONALIDAD-SLUG` siguiente o skill terminal |
| `orquestar-descubrimiento-producto` | Sí | Resumen global, `status`, `next` final | `orquestar-diseno-prd` / `workflow-complete` / `needs-review` / `blocked` |

## 5. Convenciones de ruta

### Descubrimiento (namespace `idea`)

- `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md`
- `docs/<domain>/idea/<IDEA-SLUG>/feature-prioritization.md`
- `docs/<domain>/idea/<IDEA-SLUG>/scope-roadmap.md`
- `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/prerequisites-assessment.md`
- `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/bridge-roadmap.md`
- `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/captured-requirement.md`
- `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/assumption-map.md`
- `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/product-viability.md`
- `docs/<domain>/roadmap.md` (consolidado del dominio)

### Diseño de PRD (namespace `initiatives`)

Solo el Workflow 2 (`orquestar-diseno-prd`) usa `initiatives/<PRD-SLUG>`. El `PRD-SLUG` es el `FUNCIONALIDAD-SLUG` aprobado en descubrimiento.

## 6. Reanudación y ejecución individual

- Si `discovery-state.md` existe, cualquier skill debe leerlo para saber cuál `FUNCIONALIDAD-SLUG` procesar.
- Si un skill individual se invoca sin `discovery-state.md`, debe crearse uno mínimo a partir de `feature-prioritization.md` o `scope-roadmap.md` si hay suficiente información.
- El orquestador nunca es el único propietario del avance: los skills actualizan el estado directamente.

## 7. Anti-patrones

- **No** usar `PRD-SLUG` como nombre del slug en descubrimiento; usar `FUNCIONALIDAD-SLUG`.
- **No** mutar `feature-prioritization.md` como log de ejecución; es un artefacto de decisión inmutable.
- **No** dejar que el orquestador sea el único creador de `discovery-state.md`; `priorizar-roadmap` lo crea/actualiza.
- **No** usar tablas en `discovery-state.md`; preferir listas anidadas.
- **No** almacenar artefactos de descubrimiento en `initiatives/`; reservar `initiatives/` para el Workflow 2.
