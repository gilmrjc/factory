# Checklists de auditoría

Checklists canónicos para `review-skills` Phase B. Llena cada fila pass | partial | missing (o n/a donde se note). Rúbricas de score:

- Metadata — [naming-guide.md](./naming-guide.md) + [description-guide.md](./description-guide.md)
- Resource layout — [resource-layout-guide.md](./resource-layout-guide.md)
- DRY & assets — [dry-assets-guide.md](./dry-assets-guide.md)
- Escritura directa — [direct-writing-guide.md](./direct-writing-guide.md)
- Estructura — [type-checklists/README.md](./type-checklists/README.md)
- Dimensiones 2, 4, 5, 6 — [scoring-rubric.md](./scoring-rubric.md)

## Auditoría de metadata

### Name audit

- Spec: minúsculas, guiones, longitud ≤64, sin `--`, coincide con directorio
- Token principal es verbo (o término de dominio aceptado)
- Verbo coincide con acción principal en SKILL.md body
- Sufijo de etapa es preciso (si aplica)
- No es ambiguo vs hermanos en la misma cadena
- Longitud razonable (< ~35 caracteres a menos que la etapa requiera más)

Name score (1–10) — rúbrica en [naming-guide.md](./naming-guide.md). Si score < 8 o hay mismatch de verbo, incluye renombre propuesto (≤64 caracteres) en hallazgos.

### Description audit

- Tercera persona (sin I/you routing voice)
- WHAT — capacidades + entregable
- WHEN — frases de trigger o etapa de workflow
- Palabras clave de trigger (sustantivos de tarea, sinónimos)
- Boundary — qué NO hace (si hay superposición con hermanos)
- Longitud 1–1024 caracteres
- `name` coincide con directorio; naming spec (ver naming-guide.md)
- Routing test — ¿ganaría vs hermanos para triggers declarados?
- No marketing / no vague / no body leakage

Description score (1–10) — rúbrica en [description-guide.md](./description-guide.md). Si score < 8, incluye rewrite propuesto (texto completo, ≤1024 caracteres) en hallazgos.

## Auditoría de contrato When/How/What

- When — declara cuándo sí y cuándo no usarlo con condiciones concretas
- How — declara cómo ejecutar (pasos, herramientas, fallback)
- What — declara qué producir (formato de salida, artefactos, criterios de éxito)
- Cuándo usarlo y cuándo no — sección presente con condiciones positivas y negativas
- Entrada y salida estructuradas como firma de función (nombre, tipo, obligatoriedad)

## Auditoría de estructura

- Tipo clasificado coincide con cuerpo (ver type-checklists/README.md)
- Elementos requeridos del tipo presentes (per type-checklists/README.md)
- Cuerpo < 500 líneas
- Fases/headings son skimmables con estructura clara
- Referencias usan `references/` bajo skill root o `_shared/` symlink
- Divulgación progresiva — contenido largo no inlinado cuando archivo de referencia aplica

## Auditoría de accionabilidad

- Pasos usan verbos imperativos (verbo + objeto)
- Todos los inputs requeridos están declarados explícitamente
- Evidencia es medible o verificable
- Estrategia de fallo cubre escenarios de error con acciones concretas
- Unknowns path: Open questions y/o ask antes de proceder está declarado
- Fronteras nombran acción excluida, hermano o artefacto con sustituto concreto

## Auditoría de completitud

- Done when (o equivalente de tipo) permite actuar sin re-explorar fuentes
- Estrategia de fallo completa para todas las fases
- Autoevaluación antes de terminar presente
- Handoff block estructurado si es parte de workflow
- Referencias compartidas relevantes citadas en tabla

## Auditoría de responsabilidad

- El skill realiza una sola acción con un verbo clave
- No agrupa múltiples funciones (ej: "ejecutar tests + actualizar PR + notificar")
- Evita fregadero de cocina (todo en uno)
- Evita copia-y-pega de prompts sin adaptar
- Evita plantilla rígida e inmodificable
- Sin agujeros de seguridad (no expone secrets/PII/migraciones)
- Incluye forma de probar trigger o autoevaluación

## Auditoría de resource layout

Per [resource-layout-guide.md](./resource-layout-guide.md).

- Refs bundled usan `references/`, `assets/`, o `scripts/` bajo skill root
- Links desde `SKILL.md` son un nivel de profundidad (`references/foo.md`)
- Docs compartidos usan symlink `references/` → `<skills-root>/_shared/<doc>.md` en vez de link directo
- Sin links directos `../_shared/…` desde `SKILL.md`
- Divulgación progresiva — contenido largo no inlineado cuando aplica archivo de referencia

Cualquier fila blocker — impacto en puntuación per [scoring-rubric.md](./scoring-rubric.md).

## Auditoría de DRY & assets

Corre scan de inventario en [dry-assets-guide.md](./dry-assets-guide.md).

- Inventario de assets listado (`references/`, `assets/`, `scripts/` — o documentado ninguno)
- Cada archivo del inventario enlazado con rol declarado desde `SKILL.md` o desde una referencia enlazada
- Rúbricas/checklists/templates largos en carpeta correcta — no inlineados cuando `references/`/`assets/` aplica
- `assets/` usado para templates/schemas; `scripts/` usado cuando helper ejecutable aplica (o n/a)
- Sin bloques de threshold/checklist/fase duplicados sin un owner canónico
- Composite/orchestrator — fases hijas no copiadas-pegadas en padre (o n/a)
- Candidatos extract-shared documentados con ruta canónica, o `none`

Score DRY & assets (1–10) — rúbrica en [dry-assets-guide.md](./dry-assets-guide.md). Si score < 8 y aplica extract-shared, cita candidatos en hallazgos y usa `extract-shared` Ready for.

## Auditoría de escritura directa

Corre grep scan en [direct-writing-guide.md](./direct-writing-guide.md) en cuerpo del skill + `description` YAML.

- Grep scan corrido; cada hit listado individualmente con `file:` / `line:` / `evidence:` / `veredicto:` (pass | partial | fail) — o documentado cero hits. No agrupes por categoría; cada hit es un item separado
- Cero veredictos fail en líneas de manejo de gaps en Fase B o Fase C
- Ruta de desconocidos: Preguntas abiertas y/o ask antes de proceder declarado
- Pasos de Fase B usan verbos imperativos; barras de evidencia medibles
- Fronteras nombran acción excluida, hermano, o artefacto con sustituto concreto
- Description usa verbos específicos — no "ayuda con" / "asiste" / "maneja"

Formato de cada hit en el documento de revisión:

```text
- file: <SKILL.md | description YAML | references/foo.md | assets/bar.md>
  line: <número de línea>
  evidence: "<excerpt de la frase vaga>"
  veredicto: pass | partial | fail
```

Para cada hit grep partial o fail, agrega hallazgo important con reemplazo directo listo para pegar (formato en [scoring-rubric.md](./scoring-rubric.md#formato-de-hallazgos)). Tres o más hits fail — impacto en puntuación per [scoring-rubric.md](./scoring-rubric.md).

## Auditoría de convenciones (comparación con hermanos)

Lee al menos 2 skills hermanos del mismo tipo en `.devin/skills/`:

- Estructura de fases consistente con hermanos del mismo tipo
- Naming consistente con hermanos (patrones de verbos/sufijos)
- No duplicación de contenido con hermanos
- Patrones de referencia compartida consistentes
- Desviaciones intencionales documentadas

Si hay inconsistencias no documentadas, agrega important finding con referencia a hermanos específicos.
