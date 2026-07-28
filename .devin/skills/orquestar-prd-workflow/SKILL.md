---
name: orquestar-prd-workflow
description: >-
  Orquestador que ejecuta workflow completo de PRD: capturar-requerimiento →
  validar-viabilidad-producto → definir-usuarios → mapear-casos-uso →
  generar-prd. Automatiza secuencia con gates de go/no-go y genera PRD completo
  listo para planificación arquitectónica. Entrada: Idea bruta. Salida: PRD
  formal. Úsalo como entry point: Idea → PRD en un skill.
argument-hint: "[IDEA-DESCRIPCION]"
allowed-tools:
  - read
  - grep
  - find_file_by_name
  - write
  - bash
triggers:
  - user
  - model
---

# Orquestador de Workflow PRD

Orquestador que ejecuta workflow completo: Idea bruta → PRD formal. Coordina 5 skills en secuencia con gates de validación.

**Workflow**:
1. `capturar-requerimiento` → Requirements structured
2. `validar-viabilidad-producto` [GATE] → Go/No-Go
3. `definir-usuarios` → Personas
4. `mapear-casos-uso` → Use cases
5. `generar-prd` → PRD formal
6. Consolidate results → PRD listo

Solo orquestación: no ejecuta skills directamente. Coordina y reporta.

## Fase 0 — Resolver entrada

Requerido: `IDEA-DESCRIPCION`.

Infiere desde:
- Descripción pegada: breve descripción de la idea
- Email/chat snippet: si usuario copia descripción informal
- Contenido breve: "Agregar dark mode", "2FA", etc.

Pregunta cuando falta: "¿Cuál es la idea? (descripción breve o completa)"

Declara inputs resueltos: idea capturada.

## Fase A — Paso 1: Capturar Requerimiento

```
### Paso 1: Capturar Requerimiento

Invoca: capturar-requerimiento [IDEA]

Salida esperada: docs/<domain>/<REQ-SLUG>-requirements.md
- Problema
- Audiencia afectada
- Solución propuesta
- Restricciones
- Preguntas abiertas

Status: ✅ Requirements capturados
Siguiente: Paso 2
```

## Fase B — Paso 2: Validar Viabilidad (GATE)

```
### Paso 2: Validar Viabilidad Producto [GATE]

Invoca: validar-viabilidad-producto [REQ-SLUG]

Salida esperada: docs/<domain>/<REQ-SLUG>-viability.md
- Alineación estratégica
- Validación demanda
- Disponibilidad recursos
- Análisis riesgo
- **Veredicto**: Go/Conditional Go/No-Go

IF Go or Conditional Go:
  → Procede a Paso 3
  
IF No-Go:
  → STOP
  → Reporta razones
  → Ready for: "blocked"
  
IF Conditional Go:
  → Reporta condiciones
  → (Usuario resuelve condiciones manualmente)
  → Luego continúa a Paso 3
```

## Fase C — Paso 3: Definir Usuarios

```
### Paso 3: Definir Usuarios

Invoca: definir-usuarios [REQ-SLUG]

Salida esperada: docs/<domain>/<REQ-SLUG>-personas.md
- Estado del producto (MVP/Growth/Scale)
- Persona 1 (primaria): datos, motivación, pain points, comportamiento
- Persona 2 (primaria): completa
- Persona 3 (secundaria, si aplica): abreviada
- Hipótesis adopción

Status: ✅ Usuarios definidos
Siguiente: Paso 4
```

## Fase D — Paso 4: Mapear Casos de Uso

```
### Paso 4: Mapear Casos de Uso

Invoca: mapear-casos-uso [REQ-SLUG]

Salida esperada: docs/<domain>/<REQ-SLUG>-use-cases.md
- Happy path por persona
- Alternative paths
- Edge cases
- Matriz de casos (tabla)
- Success metrics

Status: ✅ Casos de uso mapeados
Siguiente: Paso 5
```

## Fase E — Paso 5: Generar PRD (FINAL)

```
### Paso 5: Generar PRD

Invoca: generar-prd [REQ-SLUG]

Salida esperada: docs/<domain>/<REQ-SLUG>-prd.md
- Executive Summary
- Problem Statement
- Personas y Use Cases
- Requisitos Funcionales
- Requisitos No-Funcionales
- **Requisitos Experimentales** (ESTADO-ESPECÍFICOS)
- Metrics de éxito
- Go/No-Go criteria
- Timeline, Recursos, Riesgos
- Ready for: planificar-desde-prd

Status: ✅ PRD generado
Siguiente: Validación (si required)
```

## Fase F — Consolidar Resultados

```
### Consolidación

Documentos generados:
1. docs/<domain>/<REQ-SLUG>-requirements.md
2. docs/<domain>/<REQ-SLUG>-viability.md
3. docs/<domain>/<REQ-SLUG>-personas.md
4. docs/<domain>/<REQ-SLUG>-use-cases.md
5. docs/<domain>/<REQ-SLUG>-prd.md ← MAIN DELIVERABLE

All linked in final PRD.

Status: ✅ Workflow completo
Next: Sign-off → planificar-desde-prd
```

## Fase G — Reporte de Workflow

Estructura del reporte final:

```
## Reporte: Idea → PRD Workflow

### Idea Original
[Descripción bruta original]

### Validación
✅ Capturado: Requirements structured
✅ Viabilidad: Go [Razones principales]
✅ Usuarios: 2-3 personas definidas
✅ Casos: Happy paths + alternativas mapeados
✅ PRD: Generado con criterios experimentales

### Artefactos
- docs/<domain>/<REQ-SLUG>-requirements.md
- docs/<domain>/<REQ-SLUG>-viability.md
- docs/<domain>/<REQ-SLUG>-personas.md
- docs/<domain>/<REQ-SLUG>-use-cases.md
- docs/<domain>/<REQ-SLUG>-prd.md ← Main

### Criterios Experimentales
Estado: Growth (1K-10K users)
→ A/B landing page test
→ Cohort retention analysis
→ Success: >25% conversion, +5% retention

### Siguiente Paso
Ready para: planificar-desde-prd
Timeline: [Basado en restricciones en requirements]

### Quality Checklist
✅ PRD es completo (Executive Summary + todo)
✅ Personas definidas (primarias + motivaciones)
✅ Casos de uso mapeados (happy + alternativa + edge)
✅ Criterios experimentales son estado-específicos
✅ Success metrics tienen thresholds claros
✅ Timeline es realista
✅ Riesgos documentados
```

## Salida

Escribe en: `docs/<domain>/<REQ-SLUG>-workflow-summary.md`

**Secciones requeridas**:
- Idea original y objetivo
- Status de cada paso (✅ completado, ⚠️ conditional, ❌ bloqueado)
- Artefactos generados (5 documentos)
- Resumen de hallazgos principales
- Criterios experimentales (estado-específicos)
- Quality checklist
- Siguiente paso (planificar-desde-prd o escalación)
- Ready for: `planificar-desde-prd` o `blocked`

Ready for valores:
- `planificar-desde-prd`: Workflow completo, PRD aprobado y listo
- `needs-review`: PRD completo pero awaiting sign-off ejecutivo
- `blocked`: No-Go en viabilidad u otro gate no pasado
- `conditional-go`: Go condicional, condiciones deben resolverse primero

---

## Diagrama de Flujo

```
Idea bruta
    ↓
capturar-requerimiento
    ↓
Requirements capturados
    ↓
validar-viabilidad-producto [GATE]
    ↓
    ├─→ No-Go → STOP (bloqueado)
    ├─→ Conditional Go → Resuelve condiciones → Continúa
    └─→ Go → Continúa
    ↓
definir-usuarios
    ↓
Personas definidas
    ↓
mapear-casos-uso
    ↓
Casos mapeados
    ↓
generar-prd
    ↓
PRD formal + Criterios Experimentales
    ↓
Consolidate & Summary
    ↓
Ready para: planificar-desde-prd
```

---

## Notas Operacionales

### Timings Esperados (Dependiendo Estado)

| Fase | MVP | Growth | Scale |
|------|-----|--------|-------|
| Capturar | 1h | 1h | 1h |
| Validar | 2h | 2h | 2h |
| Usuarios | 4h | 4h | 4h |
| Casos | 4h | 4h | 4h |
| PRD | 4h | 4h | 4h |
| **Total** | **15h** | **15h** | **15h** |

Total workflow: ~1-2 días de trabajo (no lineal, puede parallelizar)

### Criterios Experimentales por Estado

```
MVP (<1000 users):
  Metric: Feature adoption
  Test: Manual surveys + signups
  Timeline: 2 weeks
  Success: >60% adoption

Growth (1K-10K users):
  Metric: Retention lift
  Test: A/B landing page + cohorts
  Timeline: 4-6 weeks
  Success: >25% conversion, +5% retention

Scale (10K+ users):
  Metric: LTV impact + engagement
  Test: In-app A/B + cohort analysis
  Timeline: 4 weeks
  Success: >3% retention lift, NPS stable
```

**CRÍTICO**: PRD debe especificar estado + criterios apropiados.
