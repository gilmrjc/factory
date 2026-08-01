# Revisión de skill — evaluar-alcance-idea

- **Skill**: `evaluar-alcance-idea`
- **Skills root**: `/Users/gil/projects/alejandria/.devin/skills/`
- **Scope**: single
- **Fecha**: 2026-08-02
- **Referencia cruzada**: output real en `../teleprompter/docs/teleprompter/idea/teleprompter-cli/scope-roadmap.md`
- **Revisor**: revisar-skills (GLM-5.2 High)

## Snapshot

| Campo                   | Valor                                                                                                                                                                                                                                  |
|-------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Path                    | `.devin/skills/evaluar-alcance-idea/SKILL.md`                                                                                                                                                                                          |
| Líneas (cuerpo)         | 149                                                                                                                                                                                                                                    |
| Tipo clasificado        | `workflow-step`                                                                                                                                                                                                                        |
| Justificación de tipo   | Artefacto principal en disco (`scope-roadmap.md`) con Fase 0–C + autoevaluación. No enruta a hijos (no composite), no coordina múltiples skills con puertas (no orchestrator), no es chat-only (no chat-gate).                          |
| Assets bundled          | `assets/scope-roadmap-template.md` (propio), `assets/open-questions-template.md` (symlink → `_shared/`, añadido en esta revisión)                                                                                                       |
| Referencias compartidas | `_shared/open-questions-template.md`                                                                                                                                                                                                   |
| References bundled      | `references/autoevaluacion-checklist.md`                                                                                                                                                                                               |
| Hermanos comparados     | `analizar-idea` (mismo workflow, tipo workflow-step, predecesor), `priorizar-roadmap` (mismo workflow, tipo workflow-step, sucesor)                                                                                                     |

## Auditoría de metadata

### Name audit

- Spec: minúsculas, guiones, ≤64, sin `--`, coincide con directorio — **pass**
- Token principal es verbo (`evaluar`) — **pass**
- Verbo coincide con acción principal (evaluar alcance) — **pass**
- Sufijo de etapa (`-idea`) preciso — **pass**
- No ambiguo vs hermanos (`analizar-idea`, `priorizar-roadmap`) — **pass**
- Longitud razonable (21 chars) — **pass**

**Name score**: 10

### Description audit

- Tercera persona (sin I/you) — **pass**
- WHAT (evalúa múltiples vs única funcionalidad, divide ideas complejas) — **pass**
- WHEN (después de analizar-idea, antes de priorizar-roadmap) — **pass**
- Keywords (evalúa, alcance, funcionalidades, divide) — **pass**
- Boundary (no evalúa viabilidad preliminar, no prioriza) — **pass**
- Longitud 1–1024 — **pass**
- `name` coincide con directorio — **pass**
- Routing test vs hermanos — **pass** (analizar-idea es viabilidad preliminar; evaluar-alcance-idea es alcance; priorizar-roadmap es priorización)
- No marketing / no vague — **pass**

**Description score**: 9 (slight: la salida declara ambos formatos subdirectorio + legacy, lo cual es correcto pero alarga)

## Auditoría de contrato When/How/What

- When — declara cuándo sí (después de analizar-idea, antes de priorizar-roadmap) y cuándo no (no evalúa viabilidad, no prioriza) — **pass**
- How — declara Fases 0–C con herramientas (read, grep, find_file_by_name, write) — **partial**: sin estrategia de fallo explícita en Fase A (cuando no se puede clasificar el alcance)
- What — declara salida `scope-roadmap.md` con secciones requeridas, header, autoevaluación, Ready for — **pass**
- Cuándo usarlo y cuándo no — **fail**: no hay sección "Cuándo usarlo y cuándo no" (analizar-idea sí la tiene)

## Auditoría de estructura (workflow-step)

- Fase 0 — Resolver entradas — **pass**
- Fase A — Analizar Alcance — **pass** (criterios claros múltiples vs única)
- Fase B — Generar Scope Roadmap — **pass**
- Fase C — Definir Ready For — **partial**: solo 3 valores, sin variante `(condicionado)`
- Fase G — Gate de Avance Condicionado — **fail**: no existe (analizar-idea sí la tiene)
- Estrategia de fallo en cada fase — **fail**: sin estrategia de fallo explícita
- Done when claro (autoevaluación + Ready for) — **pass**
- Cuerpo < 500 líneas (149) — **pass**
- Fases/headings skimmables — **pass**
- Divulgación progresiva (template en assets, checklist en references) — **pass**

## Auditoría de accionabilidad

- Pasos usan verbos imperativos — **pass**
- Inputs requeridos declarados (`IDEA-DESCRIPCION`) — **pass**
- Evidencia medible (criterios de clasificación, timeline, success criteria) — **pass**
- Estrategia de fallo cubre escenarios — **fail**: sin estrategia de fallo
- Unknowns path: Preguntas abiertas + gate — **fail**: no hay gate de avance condicionado ni sección de preguntas abiertas
- Fronteras nombran acción excluida + hermano — **pass**

## Auditoría de completitud

- Done when permite actuar sin re-explorar — **pass**
- Estrategia de fallo completa — **fail**: sin estrategia de fallo
- Autoevaluación antes de terminar — **pass** (referencia checklist en references/)
- Handoff block (Ready for con link relativo) — **partial**: Ready for declarado pero sin link relativo en spec
- Referencias compartidas citadas — **partial**: no referencia open-questions-template (necesario para Fase G)

## Auditoría de responsabilidad

- Una sola acción (evaluar alcance de una idea) — **pass**
- No agrupa múltiples funciones — **pass**
- Evita fregadero de cocina — **pass**
- Sin agujeros de seguridad — **pass**

## Auditoría de resource layout

- Refs bundled usan `assets/` bajo skill root — **pass** (scope-roadmap-template.md)
- Links desde SKILL.md son un nivel (`assets/scope-roadmap-template.md`) — **pass**
- Docs compartidos usan symlink → `_shared/` — **pass** (open-questions-template.md añadido en esta revisión)
- Sin links directos `../_shared/…` desde SKILL.md — **pass**
- Divulgación progresiva — **pass**

Sin filas blocker.

## Auditoría de DRY & assets

- Inventario de assets listado (scope-roadmap-template.md + open-questions-template.md symlink) — **pass**
- Cada asset enlazado con rol declarado desde SKILL.md — **pass**
- Templates largos en `_shared/` (no inlineados) — **pass**
- `assets/` para templates — **pass**
- Sin bloques duplicados sin owner canónico — **pass** (tras añadir Fase G que referencia el template en vez de duplicarlo)
- Composite/orchestrator — n/a

**DRY & assets score**: 9

## Auditoría de escritura directa

Grep scan corrido en SKILL.md + description YAML + assets:

- Sin verbos vagos de manejo de gaps ("considerar", "tener en cuenta", "manejar") — **pass**
- Ruta de desconocidos declarada — **fail** (no hay ruta de desconocidos sin Fase G)
- Fronteras nombran sustituto concreto — **pass**
- Description usa verbos específicos — **pass**

Cero hits fail en wording (el fail es por ausencia de ruta de desconocidos, no por wording vago).

## Auditoría de convenciones (comparación con hermanos)

Hermanos leídos: `analizar-idea` (predecesor), `priorizar-roadmap` (sucesor).

- Estructura de fases consistente (Fase 0 → A → B → … → Salida + Autoevaluación) — **partial**: evaluar-alcance-idea no tiene Fase G ni sección "Cuándo usarlo y cuándo no" que analizar-idea sí tiene
- Naming consistente (verbos infinitivo + sufijo de etapa) — **pass**
- Sin duplicación de contenido con hermanos — **pass**
- Patrones de referencia compartida consistentes — **pass** (tras añadir symlink a open-questions-template)
- Desviaciones intencionales documentadas — **fail**: la ausencia de Fase G no está documentada ni justificada

## Comparación contra output real (teleprompter)

Estructura de `../teleprompter/docs/teleprompter/` comparada con la esperada por el skill:

| Artefacto esperado                        | Existe en teleprompter | Formato                                  |
|-------------------------------------------|------------------------|------------------------------------------|
| `idea/<IDEA-SLUG>/scope-roadmap.md`       | Sí                     | subdirectorio (correcto)                 |
| `idea/<IDEA-SLUG>/idea-analysis.md`       | Sí                     | upstream (analizar-idea)                 |
| `idea/<IDEA-SLUG>/feature-prioritization.md` | Sí                  | downstream (priorizar-roadmap)           |
| `README.md` (índice del dominio)          | Sí                     | estructura completa                      |

La estructura real coincide con la que el skill describe.

### Discrepancias del artefacto `scope-roadmap.md` vs spec del skill

1. **Autoevaluación ausente** — El output real no incluye sección de Autoevaluación. El SKILL.md la requiere (línea 128) y referencia `references/autoevaluacion-checklist.md`.
2. **Ready for sin link relativo** — El output real dice `priorizar-roadmap` sin link relativo al siguiente artefacto. El SKILL.md declara "Ready for con link relativo" pero no lo ejemplifica claramente.
3. **Decisiones pendientes críticas sin gate** — El output real tiene "Decisión pendiente (crítica): modelo de distribución" en PRD 2 (Fase 6) y múltiples "Decisión pendiente" en Fases 7-8, pero el `Ready for` es `priorizar-roadmap` (avance libre) sin alerta ni gate de avance condicionado. **Esta es la observación principal del usuario**: las preguntas abiertas (decisiones pendientes) no bloquean ni condicionan el avance.
4. **No hay sección de Preguntas Abiertas consolidada** — Las decisiones pendientes están dispersas en las fases internas pero no hay una sección consolidada con severidad (Crítico/Importante/Menor) que alimente un gate.
5. **No hay sección "Gate de avance"** — No hay evidencia de que se ejecutó un gate de avance condicionado.
6. **Header completo** — El header real incluye slug, dominio, fecha, skill, input. **Pass**.
7. **Desglose interno de PRDs con fases y decisiones** — El output real incluye un desglose rico de fases internas (Fases 1-8) con decisiones resueltas (con fecha) y pendientes. **Pass** — el skill debería formalizar este patrón como sección requerida (ya lo hace en línea 125).
8. **Notas de modelo** — El output real incluye "Nota de modelo" sobre catálogo vs manifiesto. **Pass** — el skill lo requiere (línea 126).

## Dimensiones (1–10)

| Dim | Nombre                 | Gate   | Score | Evidencia                                                                                |
|-----|------------------------|--------|-------|------------------------------------------------------------------------------------------|
| 1   | Metadata               | pass   | 9     | Name 10, Description 9; cero blocker                                                     |
| 2   | Contrato When/How/What | partial| 7     | When pass, How partial (sin estrategia de fallo), What pass; sin sección "Cuándo usar"   |
| 3   | Estructura             | fail   | 6     | Sin Fase G, sin estrategia de fallo; workflow-step incompleto vs hermano analizar-idea   |
| 4   | Accionabilidad         | fail   | 6     | Sin estrategia de fallo, sin unknowns path/gate                                          |
| 5   | Completitud            | fail   | 6     | Sin estrategia de fallo completa, sin gate, handoff sin link relativo                    |
| 6   | Responsabilidad        | pass   | 9     | Acción única, sin anti-patrones                                                          |

**Overall**: 7.2

## Fortalezas

- Criterios claros para clasificar múltiples funcionalidades vs funcionalidad única (Fase A).
- Template de scope-roadmap en assets/ con estructura básica correcta.
- Sección "Desglose interno de PRDs/funcionalidades" y "Notas de modelo" ya especificadas en Salida (líneas 125-126) — el output real las sigue bien.
- Autoevaluación referenciada via checklist en references/.
- Naming y description limpios, sin ambigüedad vs hermanos.

## Hallazgos

### H1 — blocker — Sin Fase G: Gate de Avance Condicionado

**Evidencia**: El skill no tiene Fase G. El output real tiene decisiones pendientes críticas (modelo de distribución, UX de selección) en PRD 2 pero el `Ready for` es `priorizar-roadmap` (avance libre) sin alerta ni gate. El usuario reporta: "assets que generan preguntas abiertas no bloquean el avance a la siguiente etapa".

**Impacto**: Las decisiones pendientes críticas se ignoran al avanzar. El siguiente skill (`priorizar-roadmap`) recibe un scope-roadmap con decisiones críticas sin resolver y no tiene mecanismo para heredarlas. El usuario no es alertado antes de avanzar.

**Acción**: Añadir Fase G — Gate de Avance Condicionado (replicar patrón de analizar-idea, adaptado a los dos branches de Ready for: `priorizar-roadmap` y `evaluar-conectividad-tecnica`). Las "decisiones pendientes" identificadas en el desglose de fases internas son las preguntas abiertas que alimentan el gate.

### H2 — important — Sin estrategia de fallo explícita en Fase A

**Evidencia**: La Fase A clasifica en múltiples/única pero no dice qué hacer cuando la clasificación es ambigua o la información es insuficiente. La Fase C menciona "Ready for: blocked con preguntas abiertas" pero no hay estrategia de fallo en A que genere esas preguntas.

**Impacto**: El agente no tiene guía de qué hacer cuando no puede clasificar el alcance, llevando a clasificaciones forzadas o a avance sin gate.

**Acción**: Añadir estrategia de fallo en Fase A: "Si no se puede clasificar con confianza, marcar como 'clasificación ambigua', documentar preguntas abiertas (Crítica: ¿la idea describe N features independientes?), y dejar que Fase G decida el avance."

### H3 — important — Sin sección "Cuándo usarlo y cuándo no"

**Evidencia**: analizar-idea tiene sección "Cuándo usarlo y cuándo no" (líneas 29-32). evaluar-alcance-idea no la tiene.

**Impacto**: El routing del skill depende solo del description YAML. Una sección explícita en el cuerpo mejora la accionabilidad y consistencia con hermanos.

**Acción**: Añadir sección "Cuándo usarlo y cuándo no" después del intro.

### H4 — important — Ready for sin variante (condicionado) y sin link relativo

**Evidencia**: La Fase C solo declara 3 valores (`priorizar-roadmap`, `evaluar-conectividad-tecnica`, `blocked`) sin variantes `(condicionado)`. La sección Salida menciona "Ready for con link relativo" pero los valores listados no incluyen links.

**Impacto**: No hay mecanismo para expresar avance condicionado. El output real no incluye link relativo.

**Acción**: Añadir variantes `(condicionado)` a ambos branches y links relativos en los valores de Ready for.

### H5 — important — Autoevaluación ausente en output real

**Evidencia**: El output real no incluye sección de Autoevaluación. El skill la requiere pero el output no la refleja.

**Impacto**: El gate de autoevaluación es "soft" — el agente puede omitirlo sin violar un hard constraint en el template.

**Acción**: Incluir sección de Autoevaluación en el template `scope-roadmap-template.md` para que el agente la rellene por defecto.

### H6 — important — Template sin header, gate, preguntas, autoeval ni Ready for

**Evidencia**: `assets/scope-roadmap-template.md` solo tiene Análisis, Estrategia, Roadmap y Recomendación. No incluye header, notas de modelo, desglose de fases internas, preguntas abiertas, gate de avance, autoevaluación ni Ready for con link.

**Impacto**: El agente genera un artefacto incompleto porque el template no le recuerda todas las secciones requeridas.

**Acción**: Actualizar el template con todas las secciones requeridas (header, notas de modelo, desglose de fases, preguntas abiertas, gate de avance, autoevaluación, Ready for).

### H7 — optional — autoevaluacion-checklist.md en references/ vs inline

**Evidencia**: `references/autoevaluacion-checklist.md` es un checklist con checkboxes que se rellena en el output. analizar-idea mantiene la autoevaluación inline en SKILL.md.

**Impacto**: Menor — el archivo en references/ funciona pero añade un salto de indirection.

**Acción**: Mantener en references/ (es una guía de validación, no un template que se copia literal), pero asegurar que el template `scope-roadmap-template.md` incluya una sección de Autoevaluación que referencie los ítems del checklist.

## Mejoras opcionales (overall < 9, no aplican)

N/A — el overall es 7.2, las mejoras opcionales se aplican tras subir el score.

## Review-brief

| Q | Pregunta | Respuesta |
| --- | ---------- | ----------- |
| Q1 | ¿Tipo clasificado correcto? | Sí — workflow-step |
| Q2 | ¿Auditoría de layout sin filas blocker? | Sí |
| Q3 | ¿Cero hits fail en escritura directa? | Sí (wording), No (ruta de desconocidos ausente) |
| Q4 | ¿Compara con ≥2 hermanos? | Sí (analizar-idea, priorizar-roadmap) |
| Q5 | ¿Review escrito en disco? | Sí (este archivo) |
| Q6 | ¿Ready for consistente con gates? | No — `improve` (overall 7.2, 1 hallazgo blocker, 5 important) |

**Review-brief score**: 5/6 (Q6 falla: Ready for `improve` es consistente con gates violados)

## Ready for

`improve` — Overall 7.2, 1 hallazgo blocker (H1: sin Fase G), 5 hallazgos important. El skill es funcional pero le falta el gate de avance condicionado que su predecesor `analizar-idea` ya implementa. El output real confirma el gap: decisiones pendientes críticas no condicionan el avance. Las mejoras se aplican en este PR.

## Preguntas abiertas

- ¿Se debe sincronizar la copia del skill en `teleprompter/.agents/skills/evaluar-alcance-idea/` con las mejoras aplicadas aquí? — fuera de scope de esta revisión; flaggear al usuario.
