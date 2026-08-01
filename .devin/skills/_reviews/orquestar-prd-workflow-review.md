# orquestar-prd-workflow Skill Review

## 1. Snapshot del skill

- **Path**: `/Users/gil/projects/alejandria/.devin/skills/orquestar-prd-workflow/SKILL.md`
- **Skills root**: `/Users/gil/projects/alejandria/.devin/skills/`
- **Tipo clasificado**: `orchestrator`
  - Justificación: Coordina 7+ skills hijos en secuencia con gates `[GATE]` de go/no-go entre pasos y un loop de procesamiento para múltiples funcionalidades. Tie-breaker composite vs orchestrator resuelto a favor de orchestrator porque define gates inter-paso más allá de la delegación (veredictos Proceder/No proceder, Go/No-Go/Conditional Go, Conectado/Desconectado).
- **Host**: agnóstico (no hardcodea APIs de un entorno específico); `allowed-tools` lista `bash` en vez de `exec` (ver hallazgo important #8).
- **Tamaño**: 995 líneas / 40 KB (vs guía ≤ 500 líneas).
- **Assets bundled**: ninguno — el directorio del skill contiene únicamente `SKILL.md` (sin `references/`, `assets/`, `scripts/`).

## 2. Auditoría de name

Checklist ([audit-checklists.md § Name](../revisar-skills/references/audit-checklists.md)):

- Spec (minúsculas, guiones, ≤64, sin `--`, coincide con directorio): **pass** — `orquestar-prd-workflow` (23 chars, coincide con directorio).
- Token principal es verbo en infinitivo: **pass** — `orquestar` (patrón canónico en naming-guide.md).
- Verbo coincide con acción principal en body: **pass** — el body orquesta el workflow completo.
- Sufijo de etapa es preciso: **partial** — `-workflow` no es sufijo estándar en naming-guide.md (-review/-brief/-plan/-triage), pero `orquestar-*-workflow` es convención de dominio establecida por el hermano `orquestar-epic-workflow`.
- No es ambiguo vs hermanos: **pass** — diferenciación clara vs `orquestar-epic-workflow` (epics desde PRD) e `implementar-ticket` (ticket end-to-end).
- Longitud razonable (< ~35): **pass** — 23 chars.

**Name score: 9/10** — pass en spec/verbo/ambigüedad; un partial menor en sufijo no estándar pero respeta convención de dominio.
**Alineación de acción**: sí — verbo `orquestar` citado en línea 2 del frontmatter y línea 17 del body coincide con la acción principal.
**Renombre propuesto**: none (score ≥ 8).

## 3. Auditoría de description

Checklist ([audit-checklists.md § Description](../revisar-skills/references/audit-checklists.md)):

- Tercera persona (sin I/you): **pass** — "Orquesta…", "Úsalo…", "No lo usas…".
- WHAT — capacidades + entregable: **pass** — "Orquesta el workflow completo de PRD (…9 skills…) con gates… Genera uno o múltiples PRDs listos para planificación arquitectónica."
- WHEN — frases de trigger: **pass** — "Úsalo cuando el usuario pida crear, generar, desarrollar o implementar PRDs desde una idea bruta."
- Palabras clave de trigger: **pass** — crear, generar, desarrollar, implementar, PRDs, idea bruta.
- Boundary — qué NO hace: **pass** — "No lo usas para ejecutar skills individuales del workflow."
- Longitud 1–1024: **pass** — ~620 chars (folded scalar).
- `name` coincide con directorio: **pass**.
- Routing test: ver abajo.
- No marketing / no vague / no body leakage: **pass** — sin body leakage pese a enumerar los 9 skills (la enumeración es routing-relevante).

**Routing test** (≥ 2 frases trigger vs hermanos):

- Trigger "crear/generar PRDs desde una idea bruta" → hermano más cercano `orquestar-epic-workflow` (crea epics desde un PRD, no desde idea bruta) → **win**: este skill es el único que arranca en idea bruta.
- Trigger "implementar PRDs" → hermano más cercano `implementar-ticket` (implementa un ticket, no genera PRDs) → **win**: boundary "PRDs listos para planificación arquitectónica" vs "ticket end-to-end" separa claramente.
- Trigger "ejecutar skills individuales del workflow" → boundary explícita "No lo usas" → **win** vs skills hijos (`capturar-requerimiento`, `generar-prd`, etc.).

**Description score: 9/10** — pass en todas las filas; routing win claro contra ambos hermanos.

## 4. Auditoría de resource layout

Checklist ([audit-checklists.md § Resource layout](../revisar-skills/references/audit-checklists.md)):

- Refs bundled usan `references/`/`assets/`/`scripts/` bajo skill root: **missing** — no existe ninguna de las tres carpetas.
- Links desde `SKILL.md` son un nivel de profundidad (`references/foo.md`): **n/a** (sin links de referencia).
- Docs compartidos usan symlink `references/` → `_shared/`: **missing** — no referencia `_shared/file-discovery.md` ni `_shared/workflow-catalog.md` que sí usan hermanos.
- Sin links directos `../_shared/…` desde `SKILL.md`: **pass** (no hay links).
- Divulgación progresiva — contenido largo no inlineado: **fail** — bloques de referencia largos inlineados: formato de `workflow-state.md` (líneas 73-99), tabla canónica pasos→artefactos (147-166), notas operacionales (933-993), tabla de timings (958-971), criterios experimentales por estado (973-993), diagrama de flujo (865-929). Todos candidatos a `references/`.

**Resumen pass/fail**: 1 pass, 2 missing, 1 fail, 1 n/a.
**Blocker de layout**: sí — contenido de referencia grande inlineado cuando `references/` aplica (resource-layout-guide.md § "Qué es un blocker de layout"). Impacto: Dimension 3 ≤ 6; overall ≤ 6.

## 5. Auditoría DRY & assets

**Inventario de assets**: ninguno (carpeta del skill = solo `SKILL.md`).

Checklist ([audit-checklists.md § DRY & assets](../revisar-skills/references/audit-checklists.md)):

- Inventario de assets listado: **pass** (documentado ninguno).
- Cada archivo del inventario enlazado con rol: **n/a**.
- Rúbricas/checklists/templates largos en carpeta correcta — no inlineados: **fail** — formato de state file, tabla canónica, notas operacionales, criterios experimentales inlineados.
- `assets/` para templates/schemas; `scripts/` para helpers: **n/a** (no aplica).
- Sin bloques de threshold/checklist/fase duplicados sin owner canónico: **fail** — el bloque `SKIP-CHECK para paso <STEP>` se repite verbatim en ~15 fases (Pre-A, A, B, C, D, D.5, D.5.5, E, 4.5, F, G, 6.5, G.5, H, I); el inventario de artefactos por funcionalidad aparece 4× (Fase 0.5 tabla, Fase J, Fase K.6, Fase K reporte); la instrucción "Actualiza workflow-state.md" se repite en cada fase.
- Composite/orchestrator — fases hijas no copiadas-pegadas en padre: **fail** — cada fase copia la spec de salida del skill hijo (ej. Fase D lista "Problema, Audiencia afectada, Solución propuesta, Restricciones" que es la salida de `capturar-requerimiento`; Fase H lista las secciones del PRD que genera `generar-prd`). Anti-patrón explícito en dry-assets-guide.md item 6.
- Candidatos extract-shared documentados: ver abajo.

**Candidatos extract-shared**:

- `references/skip-check-pattern.md` (canónico) — el patrón SKIP-CHECK definido en líneas 168-185, referenciado desde cada fase. Consumidores: este skill; potencialmente `orquestar-epic-workflow` e `implementar-ticket`.
- `references/workflow-state-format.md` — formato de `workflow-state.md` (líneas 73-99) + tabla canónica pasos→artefactos (147-166). Consumidores: este skill, `orquestar-epic-workflow`.
- `references/artifact-catalog.md` — inventario canónico de artefactos por funcionalidad (consolidar las 4 copias en una). Consumidores: este skill.
- `_shared/file-discovery.md` ya existe — symlinkear vía `references/` como hace `implementar-ticket`.

**DRY & assets score: 5/10** — gate fail (rúbricas grandes inlineadas + duplicación dañina intra-skill + fases hijas copiadas). Matriz: gate fail → 5–6; múltiples filas fail → 5.

## 6. Auditoría de escritura directa

**Grep scan** ([direct-writing-guide.md](../revisar-skills/references/direct-writing-guide.md)) corrido sobre `SKILL.md` + frontmatter:

| file | line | evidence | veredicto |
|------|------|----------|-----------|
| SKILL.md | 63 | `- Contenido breve: "Agregar dark mode", "2FA", etc.` | partial — `etc.` tras ejemplos concretos; reemplazo: lista cerrada o "entre otros ejemplos breves" |
| SKILL.md | 177, 364, 400, 438, 540, 568, 598, 662, 724, 789-802, 833-839 | `✅`, `⏭️`, `⏳` (22 ocurrencias) | **fail** — emojis prohibidos en SKILL.md por direct-writing-guide.md § "Uso de emojis" |

Checklist:

- Grep scan corrido; cada hit listado: **pass** (tabla arriba).
- Cero veredictos fail en líneas de manejo de gaps en Fase B/C: **fail** — 22 hits fail de emojis.
- Ruta de desconocidos: Preguntas abiertas y/o ask: **pass** — cada gate tiene "Information insufficient → STOP, Reporta preguntas abiertas, Ready for: blocked".
- Pasos de Fase B usan verbos imperativos: **partial** — pseudocode mezcla imperativos con descriptivos ("Status: ✅ …").
- Fronteras nombran acción excluida con sustituto: **partial** — "Solo orquestación: no ejecuta skills directamente" nombra la exclusión pero no el hermano a usar en su lugar para un paso individual.
- Description usa verbos específicos — no "ayuda con"/"asiste"/"maneja": **pass**.

**Reemplazos listos para pegar** (hits fail):

- Línea 177: `→ Reporta: "⏭️ Skip <STEP>: artefacto ya presente y registrado en state"` → `→ Reporta: "Skip <STEP>: artefacto ya presente y registrado en state"`
- Líneas 364/400/438/540/568/598/662/724: `Status: ✅ <X>` → `Status: Pass — <X>`; `⏭️ Omitido con registro` → `Skip — omitido con registro`
- Líneas 789-791, 833-839: `✅ <item>` → `Pass — <item>` (checklist de reporte/quality)
- Líneas 800-802: `prd.md ✅` → `prd.md (done)`; `prd.md ⏳ (pendiente)` → `prd.md (pending)`
- Línea 63: `"Agregar dark mode", "2FA", etc.` → `"Agregar dark mode", "2FA", "Agregar exportación PDF"` (lista cerrada de 3 ejemplos)

**Hard cap**: 3+ hits fail de escritura directa → Dimension 4 ≤ 6.

## 7. Rewrite de description propuesto

`none` — description score = 9.

## 8. Anchors de convención de hermanos

Hermanos leídos (mismo tipo `orchestrator`):

1. `/Users/gil/projects/alejandria/.devin/skills/orquestar-epic-workflow/SKILL.md`
   - **Diferencia de convención específica**: 130 líneas, sin frontmatter (sin `name`/`description` YAML → invisible a routing automático), sin resume/state file, sin handoff block. orquestar-prd-workflow es notablemente más maduro en reanudación (Fase 0.5 + `workflow-state.md`) pero 7.6× más largo y sin extract de referencia.
2. `/Users/gil/projects/alejandria/.claude/skills/implementar-ticket/SKILL.md`
   - **Diferencia de convención específica**: 253 líneas con frontmatter completo, **protocolo de delegación explícito** (líneas 66-109) con plantilla de prompt por fase, **perfiles de delegación por paso** (explore/general/analysis, líneas 84-94), **handoff block estructurado** (líneas 74-82), `references/` con symlinks a `_shared/file-discovery.md` y `_shared/workflow-catalog.md`, resume flags por artefacto. orquestar-prd-workflow **no** tiene ninguno de estos cuatro elementos requeridos por el checklist de tipo orchestrator — esta es la desviación principal.

## 9. Auditoría de cuerpo

Checklist compartido ([type-checklists/shared.md](../revisar-skills/references/type-checklists/shared.md)):

- Propósito de apertura — audiencia y tarea: **pass** — líneas 17-19 declaran audiencia (orquestador) y tarea (Idea bruta → PRDs), enlaza skills adyacentes implícitamente vía la lista del workflow.
- Fronteras — acciones excluidas concretas o skills hermanos: **partial** — "Solo orquestación: no ejecuta skills directamente" (l. 54) + boundary en description; no nombra el hermano a usar para un paso individual ni el downstream `orquestar-epic-workflow`.
- Ruta de desconocidos — Preguntas abiertas y/o ask: **pass** — cada gate tiene rama "Information insufficient → STOP, Reporta preguntas abiertas".
- Links de recursos — `references/foo.md`, no `../_shared/`: **missing** — sin `references/`; contenido de referencia inlineado.
- Links a skills hermanos cuando está en cadena: **partial** — nombra skills hijos pero no linkea el downstream `orquestar-epic-workflow` ni el upstream del chain.

Checklist tipo `orchestrator` ([type-checklists/orchestrator.md](../revisar-skills/references/type-checklists/orchestrator.md)) — Requerido:

- Workflow overview con diagrama de pasos: **pass** — líneas 21-53 (overview) + 865-929 (diagrama de flujo).
- Protocolo de delegación explícito: **missing** — dice "Invoca: <skill>" pero sin protocolo (sin plantilla de prompt, sin regla "el hijo lee el SKILL.md completo antes de actuar", sin manejo de hosts con/sin subagentes). Ver `implementar-ticket` líneas 66-109 como anchor.
- Perfiles de delegación por paso: **missing** — sin perfiles explore/general/analysis por fase.
- Gates entre pasos con tabla de decisión: **partial** — gates marcados `[GATE]` con lógica IF/ELSE inline, pero sin tabla consolidada de decisión.
- Handoff block estructurado: **missing** — sin plantilla de handoff que los skills hijos deban retornar (contrastar `implementar-ticket` líneas 74-82).
- Checklist de orquestador con tracking: **partial** — `workflow-state.md` con `completed-steps` funciona como tracking, pero no hay checklist explícito de orquestador.
- Done when claro: **partial** — Fase K.6 (gate de cierre) + Fase K (reporte) actúan como done-when; sin sección "Done when" explícita.

Checklist tipo `orchestrator` — Recomendado:

- Referencias compartidas (workflow-catalog, file-discovery): **missing** — no referencia `_shared/file-discovery.md` ni workflow-catalog; path resolution hardcoded en Fase 0.
- Resume flags para reanudar workflow: **pass** — Fase 0.5 es extensa y robusta (verificación cruzada de artefactos, detección de inconsistencias, reanudación manual documentada).
- Estrategia de fallo por gate: **partial** — cada gate tiene rama STOP/blocked, pero no hay estrategia consolidada por gate ni manejo de fallo transitorio (ej. skill hijo retorna error sin Ready for).

## 10. Puntuación por dimensión + overall

| Dim | Gate | Cobertura | Score | Evidencia |
| ----- | ------ | ----------- | ------- | ----------- |
| D1 Metadata | pass | 6/6 filas pass (1 partial sufijo) | 9 | name pass spec/verbo/ambigüedad; description pass WHAT/WHEN/boundary/routing |
| D2 Contrato When/How/What | pass | 3/3 pass | 9 | When (idea bruta, no skills individuales), How (fases+tools+fallback), What (PRDs+artefactos+Ready for) |
| D3 Estructura | fail | tipo partial + longitud fail + nav partial | 6 | 995 líneas > 600 (fail longitud); tipo orchestrator sin protocolo delegación/handoff/perfiles; contenido referencia inlineado (layout blocker) |
| D4 Accionabilidad | fail | imperativo partial, inputs pass, medible pass | 6 | hard cap: 22 hits fail de emojis → D4 ≤ 6 |
| D5 Completitud | fail | done-when partial, fallo partial, autoeval missing | 6 | sin sección Autoevaluación (sibling orquestar-epic-workflow la tiene l.119-130); hard cap sin estrategia de fallo completa → D5 ≤ 6 |
| D6 Responsabilidad | partial | única pass, anti-patrones partial | 8 | única acción (orquestar PRD workflow); anti-patrón: fases hijas copiadas-pegadas + plantilla rígida repetida |

**Overall = media(9, 9, 6, 6, 6, 8) = 44/6 = 7.3 → 7**
**Hard caps aplicados**: layout blocker → overall ≤ 6. **Overall final: 6/10** (banda 5–6: cualquier dimensión ≤ 6 + blocker de layout).

## 11. Fortalezas

- **Reanudación idempotente best-in-class**: Fase 0.5 con `workflow-state.md`, verificación cruzada de artefactos, detección de inconsistencias, skip-check por fase y reanudación manual documentada — supera a `orquestar-epic-workflow` (sin resume) y es más granular que `implementar-ticket` (resume por artefacto).
- **Gate logic explícita y consistente**: cada `[GATE]` tiene ramas Go/No-Go/Conditional + rama "Information insufficient → blocked", con actualización de estado del roadmap.
- **Trazabilidad de artefactos completa**: Fase K.6 verifica artefactos de cierre obligatorios antes de marcar `Ready for: planificar-epics`, incluyendo omisiones justificadas (assumptions en greenfield, experimentos en MVP).
- **Boundary de description precisa**: "PRDs desde una idea bruta" + "No lo usas para ejecutar skills individuales" gana routing contra ambos hermanos.
- **Loop de procesamiento multi-funcionalidad bien definido** con reinicio de `last-completed-step` por funcionalidad y conservación del historial en `completed-steps`.

## 12. Hallazgos

### Blocker

```plain text
file: SKILL.md body
section/line: todo el cuerpo, 995 líneas
impact: blocker
evidence:
  995 líneas vs guía ≤ 500; bloques de referencia inlineados: formato workflow-state.md (73-99),
  tabla canónica pasos→artefactos (147-166), notas operacionales (933-993), tabla timings (958-971),
  criterios experimentales por estado (973-993), diagrama de flujo (865-929)
finding: vs resource-layout-guide.md § "Qué es un blocker de layout" (rúbricas/checklists/templates largos inlineados cuando references/ aplica) y scoring-rubric.md hard cap (>500 líneas → D3 ≤ 7; >600 fail)
fix:
  1. Crear references/ y mover: references/workflow-state-format.md (l.69-166),
     references/operational-notes.md (l.933-993), references/flow-diagram.md (l.865-929),
     references/experimental-criteria.md (l.973-993).
  2. Reemplazar cada bloque movido por una línea de carga: "Ver references/workflow-state-format.md".
  3. Meta: reducir cuerpo a < 500 líneas.
```

```plain text
file: SKILL.md body
section/line: 177, 364, 400, 438, 540, 568, 598, 662, 724, 789-802, 833-839 (22 ocurrencias)
impact: blocker
evidence:
  ✅ ⏭️ ⏳ usados como marcadores de status en pseudocode y checklists
finding: vs direct-writing-guide.md § "Uso de emojis" (prohibidos en SKILL.md; reemplazos canónicos ✅→Pass/Sí, ⏭️→Skip)
fix: aplicar reemplazos de §6 (Pass/Skip/done/pending). Hard cap: 3+ hits fail → D4 ≤ 6.
```

```plain text
file: SKILL.md body
section/line: ausente — sin "Protocolo de delegación" / "Handoff block" / "Perfiles de delegación por fase"
impact: blocker
evidence:
  El body dice "Invoca: <skill> [ARG]" pero no define protocolo (plantilla de prompt, regla
  "hijo lee SKILL.md completo antes de actuar", manejo hosts con/sin subagentes), ni handoff
  block template, ni perfiles por fase
finding: vs type-checklists/orchestrator.md (Requerido: protocolo de delegación explícito, perfiles de delegación por paso, handoff block estructurado). Anchor: implementar-ticket/SKILL.md l.66-109
fix: añadir sección "Protocolo de delegación" (plantilla de prompt + regla de lectura + manejo de hosts) y "Handoff — <fase>" block template; tabular perfiles por fase (explore/general/analysis).
```

```plain text
file: SKILL.md body
section/line: ausente — sin sección "Autoevaluación antes de terminar"
impact: blocker
evidence:
  Ningún checklist de autoevaluación antes de cerrar; Fase K (reporte) no es autoevaluación
finding: vs audit-checklists.md § Completitud (Autoevaluación antes de terminar presente) y scoring-rubric.md D5. Anchor: orquestar-epic-workflow/SKILL.md l.119-130
fix: añadir sección "Autoevaluación antes de terminar" con checklist (¿state file refleja cierre? ¿artefactos de cierre verificados? ¿roadmap consolidado generado? ¿Ready for = planificar-epics?).
```

### Important

```plain text
file: SKILL.md body
section/line: 168-185 + repetido en ~15 fases (Pre-A, A, B, C, D, D.5, D.5.5, E, 4.5, F, G, 6.5, G.5, H, I)
impact: important
evidence:
  Bloque "SKIP-CHECK para paso <STEP>: IF … AND artefacto existe → Skip … ELSE → Ejecuta …"
  duplicado verbatim en cada fase
finding: vs dry-assets-guide.md § "Duplicación intra-skill" (bloques de fase duplicados sin owner canónico)
fix: extraer references/skip-check-pattern.md (canónico), referenciarlo desde cada fase con una línea: "Aplica skip-check de references/skip-check-pattern.md para <STEP> (artefacto: <ruta>)."
```

```plain text
file: SKILL.md body
section/line: 151-166 (Fase 0.5), 708-719 (Fase J), 750-764 (Fase K.6), 805-817 (Fase K)
impact: important
evidence:
  Inventario de artefactos por funcionalidad listado 4× con ligeras variaciones
finding: vs dry-assets-guide.md § "Duplicación intra-skill"
fix: canonicalizar en references/artifact-catalog.md una sola tabla (step | artefacto | fase | obligatorio/opcional), referenciarla desde Fase 0.5, J, K.6 y K.
```

```plain text
file: SKILL.md body
section/line: 353-358 (Fase D), 455-460 (Fase E), 529-534 (Fase F), 557-562 (Fase G), 646-656 (Fase H)
impact: important
evidence:
  Cada fase copia la spec de salida del skill hijo (ej. Fase D lista "Problema, Audiencia afectada,
  Solución propuesta, Restricciones" = salida de capturar-requerimiento; Fase H lista secciones del PRD)
finding: vs dry-assets-guide.md item 6 (Composite/orchestrator — fases hijas no copiadas-pegadas en padre)
fix: reemplazar cada "Salida esperada" detallada por "Salida esperada: ver <skill-hijo>/SKILL.md § Salida" + solo el artefacto canónico (ruta). El orquestador no debe re-especificar el output del hijo.
```

```plain text
file: frontmatter
section/line: allowed-tools, línea 11 (`bash`)
impact: important
evidence:
  allowed-tools: [..., bash] vs implementar-ticket usa `exec` (y `edit`, `glob`)
finding: inconsistencia de convención con hermano del mismo tipo; `bash` no es nombre canónico de herramienta en el entorno del repo
fix: cambiar `bash` → `exec`; considerar añadir `edit` si el orquestador puede corregir state files inline.
```

```plain text
file: SKILL.md body
section/line: Fase 0 (56-67) — sin referencia a file-discovery.md
impact: important
evidence:
  Resuelve IDEA-DESCRIPCION inline sin referenciar _shared/file-discovery.md
finding: vs type-checklists/orchestrator.md Recomendado (Referencias compartidas: workflow-catalog, file-discovery). Anchor: implementar-ticket/SKILL.md l.33 (symlink references/file-discovery.md → _shared/)
fix: crear symlink references/file-discovery.md → ../../_shared/file-discovery.md y referenciarlo en Fase 0.
```

```plain text
file: SKILL.md body
section/line: sin links a orquestar-epic-workflow (downstream) ni a skills hijos como cadena
impact: important
evidence:
  El workflow termina en "Ready for: planificar-epics" pero no enlaza orquestar-epic-workflow
  como siguiente eslabón de la cadena
finding: vs type-checklists/shared.md (Links a skills hermanos cuando está en cadena — requerido para orchestrator)
fix: en Fase K / Salida, añadir "Siguiente eslabón: orquestar-epic-workflow/SKILL.md (para cada PRD generado)".
```

### Mejoras opcionales (no afectan scores)

- Línea 63: `"2FA", etc.` → lista cerrada de 3 ejemplos breves (ver §6).
- Description: añadir trigger keywords "idear", "definir PRD", "producto requirements document" para ampliar routing.
- Fase K.5/K.6: la numeración de fases (K.5, K.6, K) es no monotónica — renombrar a K, K.1, K.2 o consolidar.

## 13. Score del brief de revisión

**Review-brief score: 10/10** (Q: 7/7, C: 7/7; Raw = 14 → 10)

- Q1 Routing: pass — 3 frases trigger con hermano más cercano y resultado win documentado (§3).
- Q2 Alineación de acción: pass — verbo `orquestar` citado, alineación sí (§2).
- Q3 Evidencia de gate: pass — cada dimensión lista gate pass/partial/fail con evidencia (§10).
- Q4 Delta de hermanos: pass — 2 hermanos con diferencia específica (orquestar-epic-workflow: sin frontmatter/130 líneas; implementar-ticket: protocolo delegación/handoff/perfiles/references) (§8).
- Q5 Trazabilidad de hallazgos: pass — cada hallazgo cita sección de spec/guía/path de hermano (§12).
- Q6 Fit de Ready for: pass — Ready for = `revise-skill` coincide con blockers (layout, emojis, delegación, autoeval); approve gates no aplican.
- Q7 Escritura directa: pass — tabla de hits grep + reemplazos listos para pegar (§6).
- C1–C7: pass — todos los checklists llenados fila por fila; inventario presente; 6 scores + overall con gate y cobertura.

## 14. Ready for

**`revise-skill`**

Razón: 4 hallazgos blocker (longitud 995 líneas con referencia inlineada, 22 emojis prohibidos, protocolo de delegación/handoff/perfiles ausente, autoevaluación ausente) + 6 important. Overall = 6 (banda 5–6 por dimensión ≤ 6 + layout blocker). Approve gates no pasan (metadata 9 pero estructura 6, accionabilidad 6, completitud 6, DRY 5). Los fixes están listados en §12 y son accionables desde este archivo sin re-explorar fuentes.

## 15. Preguntas abiertas

- ¿El orquestador debe delegar a subagentes (perfiles explore/general/analysis) o ejecuta los skills hijos inline? Asumido: depende del host — pero el skill debe declarar ambos modos como hace `implementar-ticket`. Vacío real a confirmar con el maintainer.
- ¿`bash` en `allowed-tools` es intencional o un rename pendiente a `exec`? Asumido inconsistencia (hallazgo important #8).
- ¿La numeración de fases K.5/K.6/K refleja una inserción tardía o es deliberada? Asumido accidental (mejora opcional).
