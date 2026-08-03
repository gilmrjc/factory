# Guía de layout de recursos

Layout alineado con la spec para skills bajo revisión. Checklist de auditoría: [audit-checklists.md](./audit-checklists.md#auditoría-de-resource-layout). Impacto en puntuación: [scoring-rubric.md](./scoring-rubric.md).

## Layout estándar

| Ubicación                | Rol                                       |
|--------------------------|-------------------------------------------|
| `skill-name/SKILL.md`    | Requerido — instrucciones                 |
| `skill-name/references/` | Docs suplementarios (cargan bajo demanda) |
| `skill-name/assets/`     | Templates, schemas, archivos estáticos    |
| `skill-name/scripts/`    | Helpers ejecutables                       |

## Docs compartidos (`_shared/`)

Las librerías de skills pueden mantener docs canónicos compartidos en `<skills-root>/_shared/<doc>.md`. Aplica las mismas reglas de escritura directa y estilo que en `SKILL.md`.

- **Accesibilidad** — Cada consumidor expone los docs compartidos vía `references/` del skill (symlink o copia)
- **Link desde SKILL.md** — Usa `references/foo.md` — un nivel bajo el root del skill
- **Blocker** — Links directos `../_shared/…` desde `SKILL.md`, o links fuera del árbol del skill

Marca violaciones de layout como hallazgos blocker — impacto en puntuación per [audit-checklists.md](./audit-checklists.md#auditoría-de-resource-layout).

## Divulgación progresiva

El contenido de referencia largo pertenece a `references/`, `assets/`, o `scripts/` — no inlinado en `SKILL.md` cuando un archivo separado aplica.

- **Rúbricas, checklists, tablas de gate** → `references/`
- **Templates de documentos, schemas** → `assets/`
- **Scripts de validación, generadores** → `scripts/`
- **Instrucciones cortas de acción (< 30 líneas)** → Puede quedar inline en `SKILL.md`

## Qué es un blocker de layout

- Links de `SKILL.md` a `../_shared/` directamente (deben pasar por `references/`)
- Archivos en `references/` no enlazados desde ningún lugar (huérfanos)
- Rúbricas de puntuación completas inlineadas en `SKILL.md` (> 50 líneas de contenido de referencia)
- Checklists de auditoría inlineados cuando existe un archivo en `references/` equivalente
