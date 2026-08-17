---
name: evaluar-conectividad-tecnica
description: >-
  Evalúa si el codebase actual soporta una funcionalidad o qué infraestructura
  falta para que la soporte. Si está conectada, habilita el avance al
  siguiente paso; si está desconectada, genera un bridge roadmap de features
  puente con valor propio que construyen el camino hacia la funcionalidad
  objetivo. Úsalo después de evaluar-alcance-idea o priorizar-roadmap.
  Triggers comunes: evaluar conectividad, validar prerequisitos técnicos,
  identificar features puente, determinar gap de infraestructura. No lo usas
  para evaluar conectividad de un epic específico (usa evaluar-conectividad-epic),
  ni para validar viabilidad técnica a fondo (usa validar-viabilidad-tecnica),
  ni para priorizar funcionalidades (usa priorizar-roadmap).
---

# Evaluador de Conectividad Técnica

Evalúa prerequisitos técnicos y conectividad de una funcionalidad con el codebase actual. Determina si la funcionalidad está conectada al producto existente o si requiere features puente para construir la infraestructura necesaria antes de poder entregarla.

Solo análisis y planificación: no implementa, no modifica código. Prepara la funcionalidad para el siguiente paso.

## Cuándo usarlo y cuándo no

- **Sí**: existe una funcionalidad definida (del scope-roadmap o del roadmap priorizado) y se necesita saber si el codebase actual la soporta o qué falta para que la soporte.
- **No**: evaluar conectividad de un epic específico (usa `evaluar-conectividad-epic`), validar viabilidad técnica a fondo con deuda técnica bloqueante (usa `validar-viabilidad-tecnica`), priorizar funcionalidades (usa `priorizar-roadmap`), implementar o modificar código.

**Scope**: Este skill evalúa conectividad a nivel PRD/funcionalidad.
- **PRD-level**: evalúa si la funcionalidad completa tiene prerequisitos en el codebase.
- **Epic-level**: evalúa si un epic específico tiene prerequisitos (más granular).

NOTA: Al ejecutar las distintas fases, determina las partes que no requieren intervención del usuario y divide las tareas para usar subagentes, ya sea para ejecutar tareas en paralelo o para ejecutarlas de forma consecutiva pero aprovechando el subagente especializado.

## Fase 0 — Resolver entrada

Requerido: `FUNCIONALIDAD-SLUG` o `IDEA-DESCRIPCION`.

Infiere desde:
- Ruta: `docs/<DOMAIN>/idea/<IDEA-SLUG>/scope-roadmap.md` (para extraer una funcionalidad específica).
- Slug: si el usuario especifica una funcionalidad del roadmap.
- Descripción pegada: si el usuario pega la funcionalidad directamente.

Si no se puede inferir la funcionalidad, pregunta: "¿Qué funcionalidad evalúo? (slug del roadmap o descripción)" y detente a esperar la respuesta.

Declara los inputs resueltos: funcionalidad capturada.

## Fase A — Evaluar Prerequisitos Técnicos

Analiza el codebase actual para identificar qué infraestructura existe y qué falta. Determina si el repo es greenfield (sin codebase/producto previo), mapea infraestructura existente, features relacionadas y deuda técnica, y compara los prerequisitos de la funcionalidad contra el estado actual.

**Detección de modo**: Determina si el repo es greenfield Y el perfil es `lite` (ver `analizar-idea`). Esta decisión se usa en la Fase C para seleccionar el template correcto.

Consulta [references/prerequisites-analysis-guide.md](references/prerequisites-analysis-guide.md) para la lógica completa de detección y criterios de modo.

## Fase B — Evaluar Conectividad

Determina si la funcionalidad está conectada al producto actual. Si está conectada, el workflow continúa al siguiente paso. Si está desconectada, genera un roadmap de features puente con valor propio.

Esta fase produce el veredicto de conectividad (conectado/desconectado) y, si aplica, la lista de features puente necesarias.

Consulta [references/connectivity-evaluation-guide.md](references/connectivity-evaluation-guide.md) para la lógica completa de criterios de conectividad/desconexión, generación de features puente y ejemplo canónico.

## Fase C — Decidir Routing

Centraliza la decisión de qué template usar y qué documentos generar según el modo detectado en Fase A y el veredicto de conectividad de Fase B.

**Selección de template según modo:**

- **Greenfield + profile: lite**: Usa `assets/prerequisites-assessment-greenfield-short-form-template.md` (short-form reducido, sin enumerar infraestructura N/A).
- **Codebase existente o greenfield completo**: Usa `assets/prerequisites-assessment-template.md` (estructura completa con todas las secciones).

**Documentos a generar:**

- **Prerequisites Assessment** (siempre): `docs/<domain>/initiatives/<PRD-SLUG>/connectivity/prerequisites-assessment.md`
  - Si es epic-level: `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/prerequisites-assessment.md` (sin subcarpeta `connectivity/`)

- **Bridge Roadmap** (solo si desconectado): `docs/<domain>/initiatives/<PRD-SLUG>/connectivity/bridge-roadmap.md`
  - Si es epic-level: `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/bridge-roadmap.md` (sin subcarpeta `connectivity/`)

Esta fase produce un plan de generación: qué template usar y qué documentos escribir. La ejecución de la generación ocurre en la Fase E.

## Fase D — Gate de Avance (Preguntas Abiertas)

**Gate obligatorio.** Después de completar el análisis (Fases A–C) y antes de generar los documentos finales, ejecuta este gate. El documento no está completo hasta que esta fase se ejecuta y se documenta, incluso si todas las preguntas se resolvieron inline durante las Fases A o B.

Esta fase evalúa las preguntas abiertas identificadas durante el análisis y fija el `status` y `next` finales del frontmatter:

**Lógica de status/next según veredicto de conectividad:**

- **Si la funcionalidad está conectada** (incluye greenfield):
  - Sin preguntas críticas/importantes pendientes: `status: ready`, `next: capturar-requerimiento`
  - Con preguntas importantes pendientes: `status: conditional`, `next: capturar-requerimiento`
  - Con preguntas críticas pendientes: `status: blocked` (sin `next`)

- **Si la funcionalidad está desconectada**:
  - Sin preguntas críticas/importantes pendientes: `status: ready`, `next: priorizar-roadmap`
  - Con preguntas importantes pendientes: `status: conditional`, `next: priorizar-roadmap`
  - Con preguntas críticas pendientes: `status: blocked` (sin `next`)

- **Si la información es insuficiente**:
  - `status: blocked` (sin `next`) con preguntas abiertas documentadas

Consulta [references/advancement-gate-guide.md](references/advancement-gate-guide.md) para la lógica completa de estados de avance, clasificación de severidad, reglas y ejemplo canónico.

## Fase E — Generar Documentos

Escribe los artefactos finales según el plan de generación definido en la Fase C, usando el `status` y `next` fijados en la Fase D.

**Generación de Prerequisites Assessment** (siempre):
- Usa el template seleccionado en Fase C (short-form o completo)
- Incluye frontmatter con `status` y `next` de Fase D
- Documenta el gate de avance (Fase D) en la sección correspondiente
- Sigue las convenciones de formato y validación de calidad del template

**Generación de Bridge Roadmap** (solo si desconectado):
- Usa `assets/bridge-roadmap-template.md`
- Incluye frontmatter con `status` y `next` de Fase D
- Documenta las features puente generadas en Fase B
- Sigue las convenciones de formato y validación de calidad del template

Esta fase es la última del skill: después de escribir los documentos, el skill termina.

## Autoevaluación

Después de completar la evaluación de conectividad, valida contra el checklist en `references/autoevaluacion-checklist.md`. Si alguna respuesta es "No", revisa y completa antes de marcar el skill como terminado.
