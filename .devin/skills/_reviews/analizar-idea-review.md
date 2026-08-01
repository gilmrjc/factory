# Revisión de skill — analizar-idea

- **Skill**: `analizar-idea`
- **Skills root**: `/Users/gil/projects/alejandria/.devin/skills/`
- **Scope**: single
- **Fecha**: 2026-08-02
- **Referencia cruzada**: output real en `../teleprompter/docs/teleprompter/idea/teleprompter-cli/idea-analysis.md`
- **Revisor**: revisar-skills (GLM-5.2 High)

## Snapshot

| Campo                   | Valor                                                                                                                                                                                                                                         |
|-------------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path                    | `.devin/skills/analizar-idea/SKILL.md`                                                                                                                                                                                                        |
| Líneas (cuerpo)         | 299                                                                                                                                                                                                                                           |
| Tipo clasificado        | `workflow-step`                                                                                                                                                                                                                               |
| Justificación de tipo   | Artefacto principal en disco (`idea-analysis.md`) con Fase 0–G + estrategia de fallo por fase + autoevaluación. No enruta a hijos (no composite), no coordina múltiples skills con puertas (no orchestrator), no es chat-only (no chat-gate). |
| Assets bundled          | `assets/decision-matrix-template.md` (symlink → `_shared/`), `assets/open-questions-template.md` (symlink → `_shared/`)                                                                                                                       |
| Referencias compartidas | `_shared/decision-matrix-template.md`, `_shared/open-questions-template.md`                                                                                                                                                                   |
| Hermanos comparados     | `evaluar-alcance-idea` (mismo workflow, tipo workflow-step), `validar-viabilidad-producto` (mismo patrón de gate go/no-go)                                                                                                                    |

## Auditoría de metadata

### Name audit

- Spec: minúsculas, guiones, ≤64, sin `--`, coincide con directorio — **pass**
- Token principal es verbo (`analizar`) — **pass**
- Verbo coincide con acción principal (analizar idea) — **pass**
- Sufijo de etapa (`-idea`) preciso — **pass**
- No ambiguo vs hermanos (`evaluar-alcance-idea`, `validar-viabilidad-producto`) — **pass**
- Longitud razonable (14 chars) — **pass**

**Name score**: 10

### Description audit

- Tercera persona (sin I/you) — **pass**
- WHAT (analiza preliminarmente + recomendación Proceder/No proceder) — **pass**
- WHEN (gate preliminar antes de evaluar-alcance-idea) — **pass**
- Keywords (analiza, gate preliminar, viabilidad) — **pass**
- Boundary (no implementa, no aprueba, no evalúa alcance; redirige a implementar-plan/ticket, evaluar-alcance-idea) — **pass**
- Longitud 1–1024 — **pass**
- `name` coincide con directorio — **pass**
- Routing test vs hermanos — **pass** (analizar-idea es el primer gate; evaluar-alcance-idea es el siguiente claramente diferenciado)
- No marketing / no vague — **pass**

**Description score**: 9 (slight: la salida declara ambos formatos subdirectorio + legacy, lo cual es correcto pero alarga)

## Auditoría de contrato When/How/What

- When — declara cuándo sí (gate preliminar) y cuándo no (implementar, aprobar, alcance técnico) — **pass**
- How — declara Fases 0–G con herramientas (read, grep, find_file_by_name, write) y estrategia de fallo por fase — **pass**
- What — declara salida `idea-analysis.md` con secciones requeridas, header, autoevaluación, Ready for — **pass**
- Cuándo usarlo y cuándo no presente — **pass**
- Entrada/salida estructuradas como firma — **pass**

## Auditoría de estructura (workflow-step)

- Fase 0 — Resolver entradas — **pass**
- Fase A — Definir Resultado Deseado — **pass** (carga contexto del input)
- Fases B/C/D — Procesar/analizar (alineación, urgencia, recursos) — **pass**
- Fase E — Matriz de decisión — **pass**
- Fase F — Escribir análisis — **pass**
- Fase G — Gate de avance condicionado — **pass**
- Estrategia de fallo en cada fase — **pass** (Fases A–D tienen estrategia de fallo explícita)
- Done when claro (autoevaluación + Ready for) — **pass**
- Cuerpo < 500 líneas (299) — **pass**
- Fases/headings skimmables — **pass**
- Referencias usan `assets/` symlink → `_shared/` — **pass**
- Divulgación progresiva (matriz detallada y gate detallado en templates) — **pass**

## Auditoría de accionabilidad

- Pasos usan verbos imperativos — **pass**
- Inputs requeridos declarados (`IDEA-DESCRIPCION`) — **pass**
- Evidencia medible (matriz con weights, scores, umbrales) — **pass**
- Estrategia de fallo cubre escenarios — **pass**
- Unknowns path: Preguntas abiertas + Fase G gate — **pass**
- Fronteras nombran acción excluida + hermano — **pass**

## Auditoría de completitud

- Done when permite actuar sin re-explorar — **pass**
- Estrategia de fallo completa — **pass**
- Autoevaluación antes de terminar — **pass**
- Handoff block (Ready for con link relativo) — **pass**
- Referencias compartidas citadas — **pass**

## Auditoría de responsabilidad

- Una sola acción (analizar viabilidad preliminar de una idea) — **pass**
- No agrupa múltiples funciones — **pass**
- Evita fregadero de cocina — **pass**
- Sin agujeros de seguridad — **pass**

## Auditoría de resource layout

- Refs bundled usan `assets/` bajo skill root — **pass**
- Links desde SKILL.md son un nivel (`assets/decision-matrix-template.md`) — **pass**
- Docs compartidos usan symlink → `_shared/` — **pass**
- Sin links directos `../_shared/…` desde SKILL.md — **pass**
- Divulgación progresiva — **pass**

Sin filas blocker.

## Auditoría de DRY & assets

- Inventario de assets listado (2 symlinks) — **pass**
- Cada asset enlazado con rol declarado desde SKILL.md — **pass**
- Templates largos en `_shared/` (no inlineados) — **pass**
- `assets/` para templates — **pass**
- Sin bloques duplicados sin owner canónico — **partial**: la Fase G del SKILL.md duplica la sección "Integración con Ready For — Avance Condicionado" del `open-questions-template.md`. Ambos describen el mismo flujo de gate. Owner canónico debería ser el template; el skill debería referenciar en vez de re-inlinear.
- Composite/orchestrator — n/a

**DRY & assets score**: 8 (un partial por duplicación Fase G ↔ template)

## Auditoría de escritura directa

Grep scan corrido en SKILL.md + description YAML + assets:

- `SKILL.md:104` "¿Riesgo técnico manejable?" — **pass** (criterio de evaluación, no instrucción de manejo de gaps; "manejable" es adjetivo de veredicto, no verbo vago)
- `SKILL.md:162` "Inventariar preguntas abiertas" — **pass** (falso positivo: "Inventariar" = verbo inventory, no "inventar")
- Cero veredictos fail en manejo de gaps — **pass**
- Ruta de desconocidos declarada (Preguntas abiertas + Fase G) — **pass**
- Fronteras nombran sustituto concreto — **pass**
- Description usa verbos específicos — **pass**

Cero hits fail.

## Auditoría de convenciones (comparación con hermanos)

Hermanos leídos: `evaluar-alcance-idea`, `validar-viabilidad-producto` (vía descripción).

- Estructura de fases consistente (Fase 0 → A → B → … → Salida + Autoevaluación) — **pass**
- Naming consistente (verbos infinitivo + sufijo de etapa) — **pass**
- Sin duplicación de contenido con hermanos — **pass** (cada skill tiene su propio artefacto)
- Patrones de referencia compartida consistentes (ambos usan `assets/` symlink → `_shared/`) — **pass**
- Desviaciones intencionales documentadas — **pass** (analizar-idea es el único con Fase G de gate de avance condicionado; justificado por ser el primer skill del workflow)

## Comparación contra output real (teleprompter)

Estructura de `../teleprompter/docs/teleprompter/` comparada con la esperada por el skill:

| Artefacto esperado                           | Existe en teleprompter | Formato                                                           |
|----------------------------------------------|------------------------|-------------------------------------------------------------------|
| `idea/<IDEA-SLUG>/idea-analysis.md`          | Sí                     | subdirectorio (correcto)                                          |
| `idea/<IDEA-SLUG>/scope-roadmap.md`          | Sí                     | subdirectorio (correcto)                                          |
| `idea/<IDEA-SLUG>/feature-prioritization.md` | Sí                     | subdirectorio (correcto)                                          |
| `README.md` (índice del dominio)             | Sí                     | estructura completa (Puntos de entrada, Estructura, Convenciones) |
| `initiatives/<PRD-SLUG>/`                    | Sí                     | downstream                                                        |
| `personas/`, `adr/`                          | Sí                     | downstream                                                        |

La estructura real coincide con la que el skill describe/anticipa. El README del dominio sigue exactamente la "Estructura requerida del README del dominio" del skill.

### Discrepancias del artefacto `idea-analysis.md` vs spec del skill

1. **Matriz de decisión con 5ª columna "Justificación" inline** — El output real añadió una columna `Justificación` con texto largo en celdas. El skill (Fase E) y el template especifican 4 columnas (`Criterio | Status | Weight | Score`) con justificaciones en lista debajo. Violación del spec de tabla (celdas ≤50 chars).
2. **Emojis en Status (✅/⚠️)** — El output real usa emojis en la matriz y la validación. El skill usa texto `Pass / Partial / Fail` en su ejemplo, pero no prohíbe explícitamente emojis. La convención canónica (direct-writing-guide) los prohíbe.
3. **Fase G no evidenciada** — El output real tiene todas las preguntas resueltas inline en "Preguntas Abiertas (resueltas)". No hay evidencia de que el gate de la Fase G se ejecutara como alerta. El `Ready for` es avance libre (`priorizar-roadmap`), correcto porque todas se resolvieron, pero el gate no dejó rastro documentado.
4. **Campo `Input:` ausente del header** — El header real tiene slug/dominio/fecha/skill pero no `Input:`. El skill lo requiere.
5. **`Ready for` fuera de los 3 valores canónicos** — El output dice `priorizar-roadmap` (downstream ya ejecutado). El skill lista solo `evaluar-alcance-idea`, `evaluar-alcance-idea (condicionado)`, `bloqueado`. La "Nota opcional" cubre el caso pero la lista de valores no.

## Dimensiones (1–10)

| Dim | Nombre                 | Gate | Score | Evidencia                                                    |
|-----|------------------------|------|-------|--------------------------------------------------------------|
| 1   | Metadata               | pass | 9     | Name 10, Description 9; cero blocker                         |
| 2   | Contrato When/How/What | pass | 9     | When/How/What pass; cero blocker                             |
| 3   | Estructura             | pass | 9     | workflow-step completo, 299 líneas, skimmable; 1 partial DRY |
| 4   | Accionabilidad         | pass | 9     | imperativo, inputs, evidencia medible, unknowns path         |
| 5   | Completitud            | pass | 9     | done when, estrategia fallo, autoevaluación, handoff         |
| 6   | Responsabilidad        | pass | 9     | acción única, sin anti-patrones                              |

**Overall**: 9.0

## Fortalezas

- Fase G de gate de avance condicionado es un diseño sólido y poco común en skills hermanos: convierte preguntas abiertas de "documentation-only" en un gate accionable con alerta al usuario.
- Estrategia de fallo explícita en cada fase (A–D) con defaults conservadores documentados.
- Header y secciones requeridas bien especificadas; el output real las sigue casi al 100%.
- Uso correcto de symlinks a `_shared/` para templates (resource layout canónico).
- Autoevaluación de 8 ítems accionable.
- README del dominio bien especificado y verificado contra output real.

## Hallazgos

### H1 — important — Matriz de decisión: prohibir columna Justificación inline

**Evidencia**: El output real (`teleprompter/.../idea-analysis.md:58-63`) añadió una 5ª columna `Justificación` con texto largo. El skill (Fase E, líneas 116-121) y el template declaran 4 columnas con justificaciones en lista, pero el skill no prohíbe explícitamente la 5ª columna.

**Impacto**: El agente añade la columna porque es "más legible", violando la regla de celdas ≤50 chars y creando drift entre el spec y el output.

**Acción**: Añadir nota explícita en Fase E: "La matriz tiene exactamente 4 columnas. Las justificaciones van en lista debajo, no como 5ª columna. No añadas una columna Justificación a la tabla."

### H2 — important — Status sin emojis (convención canónica)

**Evidencia**: El output real usa ✅/⚠️ en la matriz y validación. El skill no referencia la convención no-emoji.

**Impacto**: Los artefactos generados mezclan formatos (texto vs emoji) y degradan legibilidad en terminales.

**Acción**: Añadir nota en Fase E: "Usa texto para Status: `Pass`/`Partial`/`Fail` (o `Sí`/`Parcial`/`No`). No uses emojis (✅/⚠️/❌)."

### H3 — important — Fase G: reforzar gate como precondición dura + documentar ejecución

**Evidencia**: El output real no deja rastro del gate. Las preguntas se resolvieron inline y el gate no se evidenció. El usuario reporta que "assets que generan preguntas abiertas no bloquean el avance".

**Impacto**: El gate existe en el skill pero es "soft": el agente puede resolver preguntas inline y saltar la alerta. El usuario no es alertado "antes de comenzar" la siguiente etapa cuando quedan preguntas.

**Acción**:

1. Hacer Fase G obligatoria: el documento no está completo hasta que Fase G se ejecute y documente, incluso si todas las preguntas se resolvieron inline.
2. Añadir subsección requerida "Gate de avance (Fase G)" al output: inventario de preguntas (críticas/importantes/menores), cómo se resolvieron, estado final de avance.
3. Clarificar "alertar antes de avanzar": la alerta se presenta en chat antes de fijar el `Ready for` y antes de avanzar al siguiente skill.
4. Incluso si las preguntas se resuelven inline durante B/C/D, el inventario de Fase G debe documentarse mostrando que fueron identificadas y resueltas.

### H4 — important — DRY: Fase G duplica sección del open-questions-template

**Evidencia**: La Fase G del SKILL.md (líneas 154-195) y la sección "Integración con Ready For — Avance Condicionado" del `open-questions-template.md` (líneas 114-163) describen el mismo flujo de gate.

**Impacto**: Drift entre ambas descripciones; el owner canónico no está claro.

**Acción**: Mantener el flujo canónico en el template. En el skill, resumir los 3 estados de avance + reglas, y referenciar el template para el flujo detallado. (No eliminar Fase G del skill — es el punto de invocación — pero reducir la duplicación.)

### H5 — optional — Campo Input del header ausente en output real

**Evidencia**: El output real no incluye `Input:` en el header.

**Acción**: Clarificar en "Salida" que el header debe incluir línea `Input:` incluso cuando es texto libre del usuario.

### H6 — optional — Ready for: caso downstream ya ejecutado

**Evidencia**: El output real usa `priorizar-roadmap` (downstream ya ejecutado), fuera de los 3 valores canónicos listados.

**Acción**: Añadir nota en "Ready for valores" cubriendo el caso de re-ejecución / actualización cuando downstream ya existe.

### H7 — important — workflows.md: paths legacy desactualizados

**Evidencia**: `docs/workflows.md` líneas 95, 97, 99, 103, 125 usan formato legacy `<IDEA-SLUG>-idea-analysis.md` etc. El skill y el output real usan subdirectorio `<IDEA-SLUG>/idea-analysis.md`. Además, línea 99 dice `prioritized-roadmap.md` pero el skill `priorizar-roadmap` genera `feature-prioritization.md`.

**Impacto**: Documentación de workflow inconsistente con skills y outputs reales.

**Acción**: Actualizar 5 paths a subdirectorio + corregir `prioritized-roadmap.md` → `feature-prioritization.md`.

### H8 — optional — Terminología "Resultado claro" vs "Outcome claro"

**Evidencia**: El skill usa "resultado" en Fase A pero el template usa "Outcome claro" en el ejemplo de analizar-idea.

**Acción**: Alinear el template a "Resultado claro" para consistencia con el skill.

## Mejoras opcionales (overall ≥ 9)

- Considerar extraer la especificación del README del dominio a una referencia compartida, dado que otros skills del workflow 0 también pueden crear/actualizar el README. (No bloqueante; el skill es el primero del workflow y tiene sentido que lo owning.)
- El `argument-hint: "[IDEA-DESCRIPCION]"` es claro; sin cambios.

## Review-brief

| Q | Pregunta | Respuesta |
| --- | ---------- | ----------- |
| Q1 | ¿Tipo clasificado correcto? | Sí — workflow-step |
| Q2 | ¿Auditoría de layout sin filas blocker? | Sí |
| Q3 | ¿Cero hits fail en escritura directa? | Sí |
| Q4 | ¿Compara con ≥2 hermanos? | Sí (evaluar-alcance-idea, validar-viabilidad-producto) |
| Q5 | ¿Review escrito en disco? | Sí (este archivo) |
| Q6 | ¿Ready for consistente con gates? | Sí — `improve` (overall 9, 4 hallazgos important ≤ 2 gate para approve, pero H1/H2/H3/H4 justifican improve para alinear output real) |

**Review-brief score**: 6/6

## Ready for

`improve` — Overall 9.0, sin hallazgos blocker, 4 hallazgos important. El skill es de alta calidad pero el output real revela 4 desviaciones del spec (matriz con columna extra, emojis, gate no evidenciado, DRY) que justifican mejoras para alinear spec ↔ output. Las mejoras se aplican en este PR.

## Preguntas abiertas

- ¿Se debe sincronizar la copia del skill en `teleprompter/.agents/skills/analizar-idea/` con las mejoras aplicadas aquí? (Su description aún declara solo el path legacy.) — fuera de scope de esta revisión; flaggear al usuario.
