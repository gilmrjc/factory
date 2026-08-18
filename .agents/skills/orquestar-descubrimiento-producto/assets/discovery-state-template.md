# Template: Discovery State

Template para `discovery-state.md`: bitácora de seguimiento del Workflow 1 (Descubrimiento de Producto). Vive en `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md` y es la fuente de verdad del avance, tanto para el orquestador como para los skills individuales.

## Frontmatter requerido

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
- `next`: FUNCIONALIDAD-SLUG o skill siguiente que debe ejecutarse.
  - Ejemplos: `notificaciones` (si es un FUNCIONALIDAD-SLUG), `orquestar-diseno-prd`, `workflow-complete`, `needs-review`.

## Cuerpo del documento

```markdown
# Discovery State: <IDEA-SLUG>

## Resumen

- **Idea**: <resumen de la idea>
- **Estado global**: <in-progress | complete | blocked>
- **Siguiente**: <next>
- **Funcionalidades totales**: <N>
- **Con viabilidad Go/Conditional Go**: <N>
- **Rechazadas o bloqueadas**: <N>

## Cola de funcionalidades

Orden de procesamiento. Cada ítem se actualiza a medida que avanza el descubrimiento.

- **Puesto <N>: `<FUNCIONALIDAD-SLUG>`** — <nombre legible>
  - Origen: Puesto <N> de `feature-prioritization.md`
  - Estado: `<pendiente-captura | conectividad-lista | requerimiento-capturado | assumptions-mapeadas | viabilidad-go | viabilidad-conditional-go | viabilidad-no-go | bloqueado>`
  - Conectividad: `<conectado | desconectado | greenfield>`
  - Requerimiento: `<ruta a requirements.md o ->
  - Assumptions: `<ruta a assumption-map.md o stub/->
  - Viabilidad: `<ruta a product-viability.md o ->
  - Veredicto: `<Go | Conditional Go | No-Go | ->
  - Ready for: `<skill orquestador/skill siguiente>`

## Preguntas abiertas globales

Preguntas que afectan a toda la idea o que no pertenecen a una funcionalidad concreta.

- **Críticas**
  - ...
- **Importantes**
  - ...
- **Menores**
  - ...

## Notas de ejecución

Cualquier observación relevante para la reanudación del descubrimiento: decisiones pendientes, acuerdos con el usuario, excepciones.

```

## Reglas de actualización

1. **El orquestador y los skills individuales leen `discovery-state.md` al inicio** para saber cuál es el `next`.
2. **Cada skill actualiza el ítem correspondiente** al terminar.
3. **El `next` del frontmatter apunta siempre al FUNCIONALIDAD-SLUG o skill siguiente**, de modo que un humano o un agente pueda reanudar sin recordar el orden.
4. **Si un skill no encuentra `discovery-state.md`, lo crea** a partir de `feature-prioritization.md` o `scope-roadmap.md`.
