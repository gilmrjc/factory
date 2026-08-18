---
name: evaluar-conectividad-epic
description: >-
  Evalúa conectividad técnica de un epic específico. Toma un epic del plan de
  epics y el codebase actual, y determina si está conectado, parcialmente
  conectado o desconectado. Genera el assessment de prerequisitos y, si aplica,
  un roadmap de funcionalidades puente para construir la infraestructura
  necesaria. Úsalo después de seleccionar un epic y antes de dividirlo en
  tareas. Triggers comunes: evaluar conectividad de un epic, validar
  prerequisitos técnicos de un epic, identificar funcionalidades puente para un
  epic. No lo uses para evaluar conectividad de una funcionalidad completa
  (usa evaluar-conectividad-tecnica) ni para validar viabilidad técnica a fondo
  (usa validar-viabilidad-tecnica).
---

# Evaluador de Conectividad de Epic

Evalúa los prerequisitos técnicos y la conectividad de un epic específico con el codebase actual. Genera el assessment de prerequisitos y un roadmap de funcionalidades puente cuando el epic está desconectado o parcialmente conectado. Úsalo después de seleccionar un epic del plan de epics y antes de dividir el epic en tareas.

## Cuándo usarlo y cuándo no

- **Sí**: hay un epic seleccionado del `epic-plan.md` y se necesita saber si el codebase actual lo soporta o qué funcionalidades puente faltan.
- **No**: evaluar conectividad de una funcionalidad completa a nivel PRD (usa `evaluar-conectividad-tecnica`), validar viabilidad técnica a fondo (usa `validar-viabilidad-tecnica`), priorizar funcionalidades (usa `priorizar-roadmap`).

**Scope**: Este skill evalúa conectividad a nivel epic. Para funcionalidades/PRD, usa `evaluar-conectividad-tecnica`.

NOTA: Al ejecutar las distintas fases, determina las partes que no requieren intervención del usuario y divide las tareas para usar subagentes, ya sea para ejecutar tareas en paralelo o para ejecutarlas de forma consecutiva pero aprovechando el subagente especializado.

## Input

- Ruta al documento de plan de epics: `docs/<domain>/initiatives/<PRD-SLUG>/epics/epic-plan.md`
- Epic seleccionado (slug o ID)
- (Opcional) Contexto técnico adicional: stack actual, arquitectura existente

## Salida

Comienza por asegurar el espacio de trabajo. Genera o actualiza `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/` según sea necesario.

Al finalizar escribe los documentos:

- **Assessment de prerequisitos**: `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/prerequisites-assessment.md` con:
  - Frontmatter: `epic_slug`, `domain`, `prd_slug`, `date`, `skill`, `profile`, `status`, `next`
  - Análisis de prerequisitos existentes vs requeridos
  - Veredicto: Conectado / Parcialmente conectado / Desconectado
  - Lista de prerequisitos faltantes
  - Gate de avance documentado
- **Roadmap de funcionalidades puente (si aplica)**: `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/bridge-roadmap.md` con:
  - Funcionalidades puente para construir infraestructura necesaria
  - Secuencia de implementación
  - Estimaciones por funcionalidad puente
  - `Ready for: implementar-bridge`

Si existe `docs/<domain>/initiatives/<PRD-SLUG>/README.md` o `docs/<domain>/README.md`, actualiza la tabla de "Puntos de entrada" con los enlaces a los artefactos recién generados.

`status` y `next` van en el frontmatter, no como sección del body. `next` se omite si `status` es `blocked`.

## Checklist de salida

Verificación final, no parte del artefacto. Antes de terminar, verifica cada ítem:

### Contenido

1. Epic seleccionado correctamente identificado y leído del plan.
2. Requisitos técnicos del epic identificados (auth, DB, APIs, servicios, frontend, monitoring, infraestructura).
3. Codebase explorado para identificar infraestructura existente.
4. Matriz de prerequisitos vs existentes generada.
5. Veredicto de conectividad claro y justificado.
6. Funcionalidades puente definidas con alcance, AC, estimaciones y dependencias (si aplica).
7. Secuencia de implementación de funcionalidades puente lógica y ordenada (si aplica).
8. Gate de avance ejecutado y documentado con inventario de preguntas abiertas.
9. `status` y `next` correctos según Fase H (`next` ausente si `blocked`).

### Formato

10. Frontmatter con `epic_slug`, `domain`, `prd_slug`, `date`, `skill`, `profile`, `status`, `next` correctos.
11. Sección **"Gate de avance"** presente y documentada con clasificación por severidad (críticas/importantes/menores).
12. Sin emojis en el documento, usa texto como `Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`.

## Fases

### Fase 0: Resolver entrada

Requerido: `EPIC-SELECCIONADO` y `EPIC-PLAN-PATH`.

Infiere desde:
- Referencia explícita del usuario al epic o al plan de epics.
- Artefacto: si existe `docs/<domain>/initiatives/<PRD-SLUG>/epics/epic-plan.md`, leerlo para identificar el epic.
- Contenido breve: "evaluar conectividad del epic X", "¿el epic Y está conectado?".

Si falta el epic seleccionado o la ruta al plan, pregunta: "¿Qué epic del plan de epics quieres evaluar? (slug, ID o referencia al plan)" y detente a esperar la respuesta.

### Fase A: Eco y diagnóstico inicial

Devuelve al usuario un eco breve de lo que entendiste (epic, dominio, PRD asociado) y un diagnóstico inicial de qué tan listo está el epic para evaluar conectividad.

**Diagnóstico de madurez** (clasifica el epic en uno de estos estados):

- **Verde**: no hay epic seleccionado o no se puede leer del plan, necesita resolver entrada primero.
- **Borrador**: el epic existe pero carece de AC, alcance o dependencias claras; necesita diálogo focalizado.
- **Casi lista**: el epic tiene AC, alcance y dependencias definidas; diálogo mínimo de confirmación.

**Diagnóstico de nivel** (clasifica el epic en uno de estos niveles):

- **Epic puente**: el epic se propone como infraestructura habilitante para otros epics.
- **Epic funcional**: el epic entrega valor directo al usuario final.

Presenta ambos diagnósticos y confirma que quiere evaluar la conectividad antes de avanzar. Si el diagnóstico de madurez es "Verde", detente a resolver la entrada. En cualquier caso espera la confirmación.

### Fase B: Analizar epic seleccionado
- Lee `docs/<domain>/initiatives/<PRD-SLUG>/epics/epic-plan.md`.
- Extrae los detalles del epic seleccionado: AC, alcance, dependencias.
- Identifica los requisitos técnicos implícitos: auth, DB, APIs, servicios, frontend, monitoring.
- Lee `docs/<domain>/initiatives/<PRD-SLUG>/connectivity/prerequisites-assessment.md` si existe. Hereda el veredicto del PRD y los gaps identificados.
- Mapea el contexto técnico adicional si lo proporcionan.

Consulta [references/prerequisites-analysis-epic-guide.md](references/prerequisites-analysis-epic-guide.md) para la lógica completa de herencia del PRD, mapeo de AC y criterios de veredicto a nivel epic.

### Fase C: Analizar codebase actual
- Explorar el codebase para identificar infraestructura existente:
  - **Auth**: ¿Sistema de autenticación existe? ¿OAuth, JWT, session-based?
  - **DB**: ¿Qué DBs existen? ¿PostgreSQL, MongoDB, Redis? ¿Esquemas actuales?
  - **APIs**: ¿Qué APIs existen? ¿REST, GraphQL, gRPC? ¿Endpoints relevantes?
  - **Servicios**: ¿Qué microservicios o módulos existen? ¿Monolith vs distributed?
  - **Frontend**: ¿Qué framework? ¿React, Vue, Angular? ¿State management?
  - **Monitoring**: ¿Hay logging, metrics, tracing? ¿Prometheus, Grafana, ELK?
  - **Infraestructura**: ¿Cloud provider? ¿AWS, GCP, Azure? ¿Kubernetes, serverless?

### Fase D: Comparar prerequisitos vs existentes
Para cada requisito técnico del epic:
- Verificar si existe en el codebase
- Si existe, evaluar si es suficiente para el epic (capacidad, escalabilidad, features)
- Si no existe, marcar como prerequisito faltante
- Si existe pero es insuficiente, marcar como prerequisito a mejorar

### Fase E: Generar veredicto de conectividad
- **Conectado**: Todos los prerequisitos existen y son suficientes
- **Parcialmente conectado**: La mayoría de prerequisitos existen, algunos faltantes o insuficientes
- **Desconectado**: Infraestructura crítica faltante (ej: no hay DB, no hay sistema de auth)

### Fase F: Generar roadmap de funcionalidades puente (si desconectado)
Si el epic está desconectado o parcialmente conectado:
- Identificar funcionalidades puente necesarias para construir prerequisitos faltantes
- Para cada funcionalidad puente:
  - Definir alcance y AC
  - Estimar esfuerzo (1-8 puntos)
  - Identificar dependencias con otras funcionalidades puente
- Secuenciar funcionalidades puente en orden lógico
- Generar `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/bridge-roadmap.md` con:
  - Lista de funcionalidades puente con estimaciones
  - Secuencia de implementación
  - Timeline sugerido
  - Trade-offs (¿implementar bridge vs cambiar arquitectura del epic?)
  - `Ready for: implementar-bridge`

### Fase G: Escribir assessment de prerequisitos

**Fase G.1: Consolidar matriz de conectividad**

Generar `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/prerequisites-assessment.md` con:
- Resumen del epic y sus requisitos técnicos
- Análisis de infraestructura existente
- Matriz de prerequisitos vs existentes
- Veredicto de conectividad (Conectado/Parcialmente conectado/Desconectado)
- Lista de prerequisitos faltantes o insuficientes
- Recomendación: proceder a dividir-epic (si conectado) o implementar roadmap de funcionalidades puente (si desconectado o parcialmente conectado)

**Fase G.2: Estado preliminar de avance**

Antes de fijar `status` y `next` en el frontmatter, clasifica el estado preliminar según el veredicto:

- **Conectado**: `next: dividir-epic`
- **Parcialmente conectado**: `next: implementar-bridge` (con funcionalidades puente identificadas)
- **Desconectado**: `next: implementar-bridge`
- **Información insuficiente**: `status: blocked` (sin `next`)

### Fase H: Gate de avance condicionado (preguntas abiertas)

**Gate obligatorio.** Ejecuta este gate después de completar el análisis (Fases A–G) y antes de fijar el `status` y `next` en el frontmatter. El documento no está completo hasta que este gate se ejecuta y se documenta.

Evalúa preguntas abiertas de severidad crítica, importante y menor que puedan bloquear o condicionar el avance. Ejemplos de preguntas a considerar:

- ¿El epic tiene AC suficientemente claros para evaluar conectividad? (Crítica)
- ¿Se identificaron todos los prerequisitos técnicos del epic? (Importante)
- ¿La evaluación del codebase cubrió los dominios relevantes? (Importante)
- ¿Hay ambigüedad en el veredicto de conectividad? (Menor)
- ¿Se confirmaron supuestos sobre el stack actual? (Menor)

Resumen operativo:

1. **Decisión de `status`**: evalúa el inventario de preguntas abiertas. `ready` si no hay Críticas/Importantes sin resolver. `conditional` si hay Importantes sin resolver (el usuario fue alertado y eligió avanzar). `blocked` si hay Críticas sin resolver.
2. **Decisión de `next`**: si `status` es `ready` o `conditional`, `next: dividir-epic` (si Conectado) o `next: implementar-bridge` (si Parcialmente conectado/Desconectado). Si `blocked`, `next` se omite.
3. **Documentación del gate**: añade al artefacto una subsección "Gate de avance" que registre el inventario de preguntas (críticas/importantes/menores) con estado de resolución, evidencia de alerta (si hubo) y estado final de avance. Obligatoria incluso si todas las preguntas se resolvieron inline.

Consulta [references/gate-guide.md](references/gate-guide.md) para la lógica completa de severidad, estados de avance, flujo del gate y reglas.

Para las preguntas abiertas, usa el template en [assets/open-questions-template.md](assets/open-questions-template.md).

## Referencias

- `evaluar-conectividad-tecnica/SKILL.md` - Skill para evaluar conectividad de funcionalidades/PRD
- [references/prerequisites-analysis-epic-guide.md](references/prerequisites-analysis-epic-guide.md) - Guía de análisis a nivel epic
- `assets/prerequisites-assessment-template.md` - Template para el assessment del epic
- `assets/bridge-roadmap-template.md` - Template para el roadmap de funcionalidades puente del epic
- `_shared/infrastructure-analysis-table.md` - Template para análisis de infraestructura

## Autoevaluación

- ¿Resolviste correctamente el epic seleccionado y la ruta al plan?
- ¿Analizaste todos los prerequisitos técnicos del epic?
- ¿Exploraste el codebase para identificar infraestructura existente?
- ¿Comparaste prerequisitos vs existentes sistemáticamente?
- ¿Generaste veredicto claro de conectividad?
- ¿Si está desconectado o parcialmente conectado, generaste roadmap de funcionalidades puente con la secuencia correcta?
- ¿Ejecutaste y documentaste el gate de avance con inventario de preguntas abiertas?
- ¿El frontmatter tiene `status` y `next` correctos (`next` ausente si `status` es `blocked`)?
