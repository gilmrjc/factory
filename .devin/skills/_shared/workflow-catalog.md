# Catálogo de workflow

Índice compartido de skills, rutas de artefactos y orden de llamada típico para la biblioteca de workflows de tickets y PR. Expuesto vía `references/workflow-catalog.md` (symlink a `<skills-root>/_shared/workflow-catalog.md`).

Para resolución de entradas (Fase 0, tiers de contexto, orden de inferencia, descubrimiento de documentación), ver [file-discovery.md](./file-discovery.md).

## Workflow de tickets orquestado

Entrada por defecto para trabajo de tickets de extremo a extremo: `.devin/skills/implement-ticket/SKILL.md`. Ejecuta skills en orden vía subagentes y respeta puertas entre fases (review → context → triage → plan → implement).

Invocables solos cuando los artefactos ya existen:

- **Revisión** → `ticket-review` → `…-ticket-review.md`
  - Rol: Puntúa calidad del ticket (AC, alcance, deps, estimación)
- **Contexto** → `context-brief` → `…-research-brief.md`
  - Rol: Reúne información de tarea (codebase, deps, riesgos)
- **Triage** → `tasks-triage` → `…-ticket-work-triage.md`
  - Rol: Divide alcance Primary vs Secondary
- **Plan** → `planning-implementation` → `…-implementation-plan.md`
  - Rol: Plan de implementación commit por commit
- **Implementar** → `implementing` → `…-implementation-report.md` + commits locales
  - Rol: Implementa el plan localmente

## Cadena de workflow de PR

Pasos con alcance PR (también invocables solos). Orden típico: contexto → revisión → correcciones del autor → triage de nuevos threads.

- **Contexto** → `context-brief` → `…-research-brief.md`
  - Rol: Reúne información de tarea
- **Revisión** → `pr-review` → `…-pr-<N>-review.md` + `…-pr-<N>-review-comments.md`
  - Rol: Revisor: aprobar o solicitar cambios (sin correcciones de código)
- **Mejorar** → `pr-improvement` → `…-pr-<N>-improvement-notes.md` + commits locales
  - Rol: Autor: aplica hallazgos de revisión localmente
- **Triage de threads** → (no implementado aún) → `…-pr-<N>-comments-triage.md`
  - Rol: Autor/revisor: solo threads abiertos nuevos

## Ramas de exploración y comprensión

- **Spike** → `spike` → `…-spike-notes.md`
  - Cuándo usar: Diseño o ruta de integración desconocida
- **Demo** → `harness` → `…-demo-notes.md`
  - Cuándo usar: UI o comportamiento necesita prueba visible
- **Quiz** → `understanding-quiz` → chat-only
  - Cuándo usar: Puerta de comprensión antes de implementar o revisar

## Nomenclatura de artefactos (auto-descubrimiento)

Dado `TICKET-SLUG`, busca en el repo:

- `docs/**/<TICKET-SLUG>-research-brief.md` → `CONTEXT-DOC` por defecto
- `docs/**/<TICKET-SLUG>-ticket-review.md`
- `docs/**/<TICKET-SLUG>-ticket-work-triage.md`
- `docs/**/<TICKET-SLUG>-spike-notes.md`
- `docs/**/<TICKET-SLUG>-demo-notes.md`
- `docs/**/<TICKET-SLUG>-implementation-plan.md`
- `docs/**/<TICKET-SLUG>-implementation-report.md`
- `docs/**/<TICKET-SLUG>-pr-<PR-NUMBER>-review.md`
- `docs/**/<TICKET-SLUG>-pr-<PR-NUMBER>-review-comments.md`
- `docs/**/<TICKET-SLUG>-pr-<PR-NUMBER>-comments-triage.md`
- `docs/**/<TICKET-SLUG>-pr-<PR-NUMBER>-improvement-notes.md`

Cuando múltiples candidatos coincidan, prefiere el tipo de artefacto para el paso de workflow actual (ver las tablas de workflow orquestado, PR y exploración arriba). Si sigue ambiguo, pregunta.
