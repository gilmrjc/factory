# Template: Stub N=1

Template para el stub de salida de `priorizar-roadmap` cuando el roadmap contiene una única funcionalidad priorizable.

## Frontmatter requerido

```yaml
---
idea_slug: <IDEA-SLUG>
domain: <DOMAIN>
date: <YYYY-MM-DD>
skill: priorizar-roadmap
input: <ruta del artefacto fuente: scope-roadmap.md o bridge-roadmap.md>
status: ready | conditional | blocked
next: evaluar-conectividad-tecnica
---
```

- `status` indica el resultado del gate: `ready` si no hay Críticas/Importantes pendientes, `conditional` si hay Importantes y el usuario decide avanzar, `blocked` si hay Críticas pendientes.
- `next` va presente solo cuando `status` es `ready` o `conditional`. Si `status` es `blocked`, omite `next`.

## Cuerpo del documento

```markdown
# Feature Prioritization: <IDEA-SLUG>

## Veredicto: Funcionalidad única — sin priorización

- Ítems totales: 1
- Ítems priorizables: 1
- Puntuación RICE (0-100): <puntuación> (RICE raw: <rice_raw>; Reach=<r>, Impact=<i>, Confidence=<c>, Effort=<e>)
- Justificación de la revisión de coherencia: <1-2 líneas>
- Ready for: `evaluar-conectividad-tecnica`
- Ruta del siguiente artefacto: `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/prerequisites-assessment.md`
```
