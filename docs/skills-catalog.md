# Catálogo de Skills (52)

Índice de referencia de los 52 skills de `factory`, agrupados por rol dentro del proceso. La columna *Salida* muestra el artefacto durable típico (rutas relativas al proyecto integrado, bajo `docs/<domain>/...`).

Para la descripción narrativa de cada workflow, gates y ramas opcionales, ver [`workflows.md`](workflows.md).

## Tabla de Contenidos

- [Paso previo — Esbozo de idea](#paso-previo--esbozo-de-idea)
- [Workflow 1 — Descubrimiento de Producto](#workflow-1--descubrimiento-de-producto)
- [Workflow 2 — Gestión de Epics](#workflow-2--gestión-de-epics)
- [Workflow 3 — Preparación de Ticket](#workflow-3--preparación-de-ticket)
- [Workflow 4 — Ejecución de Implementación](#workflow-4--ejecución-de-implementación)
- [Workflow 5 — Revisión de PRs](#workflow-5--revisión-de-prs)
- [Transversal y Standalone](#transversal-y-standalone)

## Paso previo — Esbozo de idea

Paso opcional antes del Workflow 1 cuando la idea está muy verde para entrar al flujo. No es parte de ningún orquestador; se invoca a mano.

- **`esbozar-idea`**: Chat interactivo que pulle una idea bruta en un esbozo ligero listo para `analizar-idea` → `docs/drafts/<slug>/esbozo.md` (temporal)

## Workflow 1 — Descubrimiento de Producto

- **`analizar-idea`**: Gate preliminar de viabilidad con outcome-driven discovery → `…/idea/<slug>/idea-analysis.md`
- **`evaluar-alcance-idea`**: Divide ideas complejas en funcionalidades individuales → `…/idea/<slug>/scope-roadmap.md`
- **`refinar-alcance-idea`**: Refina alcance cuando `evaluar-alcance-idea` lo indica
- **`priorizar-roadmap`**: Priorización RICE (valor vs esfuerzo) → `…/idea/<slug>/feature-prioritization.md`
- **`evaluar-conectividad-tecnica`**: Evalúa prerequisitos en el codebase; genera features puente → `…/prerequisites-assessment.md` + `…/bridge-roadmap.md`
- **`capturar-requerimiento`**: Estructura la idea en documento formal (gate de no-solutionización) → `…/initiatives/<slug>/requirements.md`
- **`mapear-assumptions`**: Mapea assumptions (framework David Bland); dispara spikes de feasibility → `…/assumption-map.md`
- **`validar-viabilidad-producto`**: Gate Go/No-Go de negocio antes del PRD → `…/viability.md`
- **`definir-usuarios`**: Define personas primarias y secundarias → `…/personas.md`
- **`mapear-casos-uso`**: Mapea happy path, alternativos y edge cases → `…/use-cases.md`
- **`disenar-experimentos`**: Diseña experimentos rigurosos (condicional al stage Growth/Scale) → `…/experiment-design.md`
- **`generar-prd`**: Genera PRD formal con criterios experimentales → `…/prd.md`
- **`construir-spike`**: Spike técnico ante riesgo de feasibility / Conditional Go → `…/spike-notes.md`
- **`construir-demo`**: Demo interactivo cuando los flujos no están claros → `…/demo-notes.md`

## Workflow 2 — Gestión de Epics

- **`planificar-epics`**: Transforma PRD en estructura de epics → `…/epic-plan.md`
- **`priorizar-epics`**: Priorización de epics basada en RICE → `…/epic-prioritization.md`
- **`evaluar-conectividad-epic`**: Prerequisitos por epic + features puente → `…/prerequisites-assessment.md` + `…/bridge-roadmap.md`
- **`dividir-epic`**: Divide epic en tareas atómicas → `…/tasks.md`
- **`generar-trd`**: Especifica requisitos técnicos → `…/trd.md`
- **`validar-viabilidad-tecnica`**: Valida viabilidad técnica contra el codebase → `…/viability-assessment.md`
- **`generar-arquitectura`**: Documentación arquitectónica visual (C4, secuencias) → `…/architecture.md`
- **`generar-adr`**: Decisiones de arquitectura (ADRs) → `…/adr-<N>.md`
- **`generar-estrategia-testing`**: Estrategia de testing (ZOMBIE) → `…/test-strategy.md`
- **`sugerir-casos-prueba`**: Casos de prueba a nivel de epic → `…/test-cases.md`
- **`validar-epic-completo`**: Orquesta validación técnica completa del epic → `…/complete-validation.md`

## Workflow 3 — Preparación de Ticket

- **`crear-ticket`**: Crea ticket desde epic-tasks o brief → `…/<ticket-id>-ticket.md`
- **`revisar-ticket`**: Gate de calidad de tickets → `…/<ticket-id>-revisando-ticket.md`
- **`generar-brief-contexto`**: Brief de contexto puntuado para el ticket → `…/<ticket-id>-context-brief.md`
- **`clasificar-tareas`**: Gate de triage: resolver preguntas / spike / demo / planificar → `…/<ticket-id>-ticket-work-triage.md`
- **`planificar-implementacion`**: Plan de implementación puntuado → `…/<ticket-id>-implementation-plan.md`

## Workflow 4 — Ejecución de Implementación

- **`implementar-plan`**: Aplica el plan paso a paso con validación dirigida → `…/<ticket-id>-implementation-report.md`
- **`actualizar-mapeo-contextos`**: Actualiza el mapeo de contextos del codebase
- **`revisar-cambios-locales`**: Gate antes de crear PR
- **`revisar-cambios-implementados`**: Orquesta análisis de calidad + validación de impacto real → `…/code-analysis-summary.md`
- **`analizar-cambios-codigo`**: Análisis liviano de impacto predicho (alternativa a `validar-epic-completo`)
- **`predecir-impacto-cambio`**: Predice impacto de un cambio antes de aplicarlo
- **`validar-impacto-real`**: Valida el impacto real tras la implementación
- **`validar-casos-prueba-implementados`**: Valida casos de prueba implementados
- **`detectar-documentacion-faltante`**: Detecta documentación faltante tras cambios

## Workflow 5 — Revisión de PRs

- **`validar-tarea-trivial`**: Gate que determina pipeline apropiado (mínimo vs completo) — sin salida durable
- **`revisar-cambio-minimo`**: Revisión mínima para cambios triviales — sin salida durable
- **`revisar-pr`**: Gate de calidad de PRs — `…/<ticket-id>-pr-<N>-review.md` + `…-review-comments.md`
- **`clasificar-comentarios`**: Clasifica hilos de revisión y propone respuestas — `…/<ticket-id>-pr-<N>-comments-triage.md`
- **`mejorar-pr`**: Aplica correcciones y vuelve a puntuar — `…/mejora-pr-*.md`

## Transversal y Standalone

- **`explicar-cambio`**: Documento didáctico antes de implementar/revisar — `…/<ticket-id>-explain-change.md`
- **`ejecutar-quiz-comprension`**: Quiz en vivo para validar comprensión (salida solo en chat) — sin salida durable
- **`mapear-dominio`**: Guía de dominio DDD estratégica autocontenida — sin salida durable
- **`revisar-skills`**: Audita calidad de `SKILL.md` contra mejores prácticas — sin salida durable
