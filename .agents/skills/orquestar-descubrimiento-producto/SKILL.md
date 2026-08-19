---
name: orquestar-descubrimiento-producto
description: >-
  Toma una idea con resultado claro y decide si vale la pena construirla.
  Describe el producto que la resuelve, evalúa alcance y estrategia,
  prioriza funcionalidades, revisa conectividad técnica, estructura el
  requerimiento, mapea assumptions y valida viabilidad de negocio.
  Entrega `requirements.md`, `assumption-map.md` y `product-viability.md`
  con veredicto Go/No-Go, más el roadmap consolidado del dominio.
  Ready for: `orquestar-diseno-prd`.
---

# Orquestador de Descubrimiento de Producto

Orquesta la primera mitad del proceso: toma una idea con resultado claro, la describe, divide el alcance, prioriza, evalúa conectividad, estructura el requerimiento, mapea assumptions y valida la viabilidad de producto. El objetivo es decidir **si conviene construir la funcionalidad** antes de invertir en personas, casos de uso y PRD.

## Refuerzo de ejecución

- **No escribas artefactos con `write`**. Cada fase se delega a un subagente (`run_subagent`) que ejecuta el skill correspondiente.
- **Cada fase es individual**. Nunca un solo subagente ejecuta todo el workflow.
- Si un subagente retorna `PAUSA-ACTIVA`, propaga la pregunta al usuario, espera respuesta y reanuda el mismo subagente/fase.
- El orquestador solo lee artefactos, genera `Handoff blocks` y decide el `next`.

**Fases**:
0. `esbozar-idea` (previo, no incluido) — `esbozar-idea` corre a mano cuando la idea no tiene resultado claro.
0.5. **Reconstrucción de estado** — Lee `workflow-state.md` para reanudar.
1. `analizar-idea` — Descripción narrativa del producto.
2. `evaluar-alcance-idea` [GATE] — Viabilidad preliminar, división en funcionalidades, profile `full/lite`.
3. `priorizar-roadmap` [GATE] — Ranking RICE de funcionalidades/features puente; crea/actualiza `discovery-state.md`.
4. `evaluar-conectividad-tecnica` [GATE] — Conectado/desconectado/greenfield.
5. `capturar-requerimiento` — Requerimiento estructurado.
6. `mapear-assumptions` (recomendado) — 4 buckets, matriz riesgo/evidencia.
7. `construir-spike` (gate de feasibility) — Solo si assumptions de feasibility de riesgo medio/alto lo requieren.
8. `validar-viabilidad-producto` [GATE] — Go / Conditional Go / No-Go.
9. Loop de procesamiento para múltiples funcionalidades.
10. Consolidar resultados y generar/actualizar `roadmap.md` del dominio.

## Cuándo usarlo y cuándo no

- **Sí**: el usuario quiere decidir si una idea vale la pena, estructurar el requerimiento y validar viabilidad antes de diseñar el PRD.
- **No**: el usuario quiere generar el PRD completo (usa `orquestar-diseno-prd` tras el descubrimiento), ejecutar skills individuales (invócalos directamente), o ya pasó el descubrimiento y quiere diseñar el PRD (usa `orquestar-diseno-prd`).

## Entrada y salida

- **Entrada**: `IDEA-DESCRIPCION` (string, obligatorio) — descripción breve o completa de la idea con un resultado claro. Si no lo tiene, sugiere `esbozar-idea` primero.
- **Salida**: `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md` con el estado de la cola de funcionalidades y `docs/<domain>/roadmap.md` consolidado del dominio; artefactos por funcionalidad: `requirements.md`, `assumption-map.md` (o stub de omisión), `product-viability.md`.
- **Ready for**: `orquestar-diseno-prd` (Go/Conditional Go), `workflow-complete` (todos No-Go o bloqueados), `needs-review` (requiere decisión ejecutiva), `blocked` (faltan datos).

## Referencias compartidas

| Referencia | Rol |
|------------|-----|
| [file-discovery.md](references/file-discovery.md) | Resolución de entradas compartida |
| [state-reconstruction.md](references/state-reconstruction.md) | Formato de `workflow-state.md` y skip-check |
| [artifact-catalog.md](references/artifact-catalog.md) | Inventario canónico de artefactos |
| [orchestrator-pattern.md](references/orchestrator-pattern.md) | Template canónico para orquestadores |

## Protocolo de delegación

El orquestador **nunca** delega el workflow completo a un solo subagente. Ejecuta cada fase de forma individual mediante `run_subagent`, y mantiene el control del flujo entre fases.

### Reglas obligatorias

- **Ejecuta cada fase con `run_subagent`**. No ejecutes las fases "inline" escribiendo directamente los artefactos con `write`.
- El orquestador **nunca** crea ni modifica los artefactos de salida de un skill con `write`. Los artefactos los genera el subagente de la fase.
- El orquestador solo lee artefactos existentes para reconstruir estado o evaluar handoffs.
- Un subagente ejecuta **una sola fase** (un skill) y luego termina.
- El subagente **no** decide cuál es la siguiente fase; eso lo hace el orquestador principal.
- El subagente **no** reanuda por sí solo; el orquestador principal decide si reanudar con la respuesta del usuario.

### Ejecución paso a paso

1. El orquestador invoca `run_subagent` para la fase actual.
2. El subagente ejecuta el skill correspondiente.
3. El orquestador principal recibe el resultado del subagente y decide:
   - Si retorna un `PAUSA-ACTIVA`:
     - Propaga al usuario: **Detectado** y **Pregunta**.
     - Espera la respuesta.
     - Reanuda **el mismo subagente/fase** con la respuesta añadida al input (usa `resume` del subagente si está disponible, o re-invoca con el contexto completo).
   - Si retorna un artefacto final:
     - Evalúa el handoff.
     - Si `status: conditional` o `blocked`, aplica el Protocolo de Gate de Avance Condicionado.
     - Si `status: ready`, avanza a la siguiente fase.

### Plantilla de subagente por fase

Para cada fase, invoca `run_subagent` con `profile: subagent_general` y un `task` específico:

- **Fase Pre-A** — `analizar-idea`:
  ```
  Ejecuta el skill `analizar-idea` con IDEA-DESCRIPCION: <descripción>. Lee su SKILL.md, sigue cada PAUSA-CHECK/PAUSA-ACTIVA y devuelve el artefacto `docs/<domain>/idea/<IDEA-SLUG>/idea-analysis.md` o el PAUSA-ACTIVA activado.
  ```

- **Fase A** — `evaluar-alcance-idea`:
  ```
  Ejecuta el skill `evaluar-alcance-idea` usando `idea-analysis.md`. Sigue sus PAUSA-CHECK/PAUSA-ACTIVA y devuelve `scope-roadmap.md` o pausa.
  ```

- **Fase B** — `priorizar-roadmap`:
  ```
  Ejecuta el skill `priorizar-roadmap` sobre `scope-roadmap.md`. Sigue sus PAUSA-CHECK/PAUSA-ACTIVA y devuelve `feature-prioritization.md` y `discovery-state.md` o pausa.
  ```

- **Fase C** — `evaluar-conectividad-tecnica`:
  ```
  Ejecuta el skill `evaluar-conectividad-tecnica` para el FUNCIONALIDAD-SLUG del `next` de `discovery-state.md`. Sigue sus PAUSA-CHECK/PAUSA-ACTIVA y devuelve `prerequisites-assessment.md` (y `bridge-roadmap.md` si aplica) o pausa.
  ```

- **Fase D** — `capturar-requerimiento`:
  ```
  Ejecuta el skill `capturar-requerimiento` para el FUNCIONALIDAD-SLUG del `next` de `discovery-state.md`. Sigue sus PAUSA-CHECK/PAUSA-ACTIVA y devuelve `captured-requirement.md` o pausa.
  ```

- **Fase D.5** — `mapear-assumptions`:
  ```
  Ejecuta el skill `mapear-assumptions` para el FUNCIONALIDAD-SLUG del `next` de `discovery-state.md`. Sigue sus PAUSA-CHECK/PAUSA-ACTIVA y devuelve `assumption-map.md` o pausa.
  ```

- **Fase D.5.5** — `construir-spike`:
  ```
  Ejecuta el skill `construir-spike` para la pregunta de feasibility. Sigue sus PAUSA-CHECK/PAUSA-ACTIVA y devuelve notas de spike o pausa.
  ```

- **Fase E** — `validar-viabilidad-producto`:
  ```
  Ejecuta el skill `validar-viabilidad-producto` para el FUNCIONALIDAD-SLUG del `next` de `discovery-state.md`. Sigue sus PAUSA-CHECK/PAUSA-ACTIVA y devuelve `product-viability.md` o pausa.
  ```

### Handoff entre fases

Después de cada fase, el orquestador genera el `Handoff block` y lo usa para decidir el `next`.

### Handoff block template

```markdown
## Handoff — <nombre-fase>
- IDEA-SLUG: …
- FUNCIONALIDAD-SLUG: … (o null)
- Artefacto: <ruta o "none">
- Ready for / Siguiente paso: <valor del menú del skill>
- Bloqueadores: <lista o "none">
- Resumen: <2–4 oraciones>
```

## Protocolo de Gate de Avance Condicionado

Después de **cada** fase delegada (A, B, C, D, D.5, E, D.5.5), el orquestador debe:

1. Leer el artefacto generado y su frontmatter `status` y `next`.
2. Si `status: ready` y `next` está definido, continuar automáticamente a la siguiente fase.
3. Si `status: conditional`:
   - Presentar al usuario el resumen y el inventario de preguntas abiertas marcadas como Importantes.
   - Preguntar: "¿Quieres resolver estas preguntas ahora o avanzar con el default conservador?"
   - Si el usuario elige resolver, detenerse y esperar respuestas; cuando reanude, re-ejecutar la misma fase.
   - Si el usuario elige avanzar, registrar la decisión y continuar.
4. Si `status: blocked`:
   - Presentar al usuario las preguntas abiertas críticas.
   - Detenerse. No avanzar hasta que el usuario resuelva o cancele.
   - Actualizar `discovery-state.md` con `estado: bloqueado` y `next: blocked`.

Este protocolo aplica incluso cuando el orquestador delega a un agente hijo: el agente hijo ejecuta el skill y el orquestador evalúa el handoff.

## Fases

### Fase 0.5 — Reconstrucción de Estado

Aplica el algoritmo de [state-reconstruction.md](references/state-reconstruction.md).

### Fase Pre-A — Analizar Idea

`analizar-idea` es obligatorio. Si `idea-analysis.md` no existe, invócalo. Si el resultado no está claro, reporta `Ready for: esbozar-idea` y detente.

### Fase A — Evaluar Alcance

`evaluar-alcance-idea`. Si `No proceder` por desalineación estratégica, detente. Si múltiples funcionalidades, divide y guarda `scope-roadmap.md`. Aplica el Protocolo de Gate de Avance Condicionado.

### Fase B — Priorizar Roadmap

`priorizar-roadmap` sobre `scope-roadmap.md` o bridge-roadmap. Genera `feature-prioritization.md` y actualiza `discovery-state.md` con el ranking (Fase F.5 del skill). Aplica el Protocolo de Gate de Avance Condicionado.

### Fase C — Evaluar Conectividad Técnica

Toma el `next` de `discovery-state.md` (un FUNCIONALIDAD-SLUG) y ejecuta `evaluar-conectividad-tecnica`. Si desconectado, genera `bridge-roadmap.md`, re-prioriza y actualiza `discovery-state.md` con la feature puente más prioritaria. Marca el ítem con `estado: conectividad-lista` y `conectividad: <conectado|desconectado|greenfield>`. Aplica el Protocolo de Gate de Avance Condicionado.

### Fase D — Capturar Requerimiento

Toma el `next` de `discovery-state.md` y ejecuta `capturar-requerimiento [FUNCIONALIDAD-SLUG]`. El skill genera `requirements.md` y actualiza `discovery-state.md` marcando el ítem como `requerimiento-capturado` y asignando el siguiente FUNCIONALIDAD-SLUG pendiente a `next`. Aplica el Protocolo de Gate de Avance Condicionado.

### Fase D.5 — Mapear Assumptions

`mapear-assumptions` (recomendado). Si se omite, registra stub con justificación. Aplica el Protocolo de Gate de Avance Condicionado.

### Fase D.5.5 — Gate de Spike por Feasibility

Si `assumption-map.md` contiene assumptions `feasibility` con riesgo medio/alto y evidencia baja/media, invoca `construir-spike` por cada una antes de la viabilidad. Aplica el Protocolo de Gate de Avance Condicionado al terminar cada spike.

### Fase E — Validar Viabilidad

`validar-viabilidad-producto`. Veredicto:

- **Go** → actualiza estado, continúa a consolidación.
- **Conditional Go** → extrae condiciones. Si son técnicas, resuelve con spike; si no, documenta y continúa.
- **No-Go** → marca funcionalidad como rechazada y vuelve al loop (Fase I).

Aplica el Protocolo de Gate de Avance Condicionado.

### Fase I — Loop de Procesamiento

Lee `discovery-state.md`. Si hay un FUNCIONALIDAD-SLUG en `next` con `estado: pendiente-captura`, selecciónalo y repite desde Fase C. Si `next` apunta a un skill (`orquestar-diseno-prd`, `workflow-complete`, `needs-review`, `blocked`) o no quedan ítems pendientes, continúa a Fase J.

### Fase J — Consolidar resultados

Genera/actualiza `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md` con el resumen global y el estado de cada funcionalidad.

### Fase K — Roadmap Consolidado del Dominio

Actualiza `docs/<domain>/roadmap.md` con funcionalidades descubiertas, sus scores RICE, veredictos de viabilidad y siguiente paso: `orquestar-diseno-prd` para las aprobadas.

## Autoevaluación antes de terminar

- ¿Resolvió `IDEA-DESCRIPCION` y validó que el resultado es claro?
- ¿Aplicó skip-check de `workflow-state.md` en cada fase?
- ¿Generó `requirements.md` y `product-viability.md` para cada funcionalidad aprobada?
- ¿Registró omisiones justificadas de `assumption-map.md`?
- ¿Actualizó `discovery-state.md` y `roadmap.md` del dominio?
- ¿El veredicto final es `Ready for: orquestar-diseno-prd | workflow-complete | needs-review | blocked`?

## Termina cuando

El `discovery-state.md` refleja el estado de todas las funcionalidades, `roadmap.md` está actualizado, y el reporte final incluye la lista de funcionalidades listas para diseño de PRD y las rechazadas/bloqueadas.

```markdown
## Handoff — orquestar-descubrimiento-producto
- IDEA-SLUG: …
- Skills root: …
- Funcionalidades aprobadas: <lista de FUNCIONALIDAD-SLUGs o "none">
- Funcionalidades rechazadas/bloqueadas: <lista o "none">
- Ready for: orquestar-diseno-prd | workflow-complete | needs-review | blocked
- Blockers: <lista o "none">
- Summary: <2–4 oraciones>
- Siguiente eslabón: orquestar-diseno-prd/SKILL.md
```
