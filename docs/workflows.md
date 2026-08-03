# Workflows de Skills

Este documento es el mapa de ruta para operar el proceso de producto→código mediante la librería de skills. Úsalo para saber en qué punto del proceso estás, qué skill sigue, y si conviene invocar un orquestador end-to-end o skills individuales a mano.

Cada workflow representa una sesión de trabajo con inicio y fin claros, agrupada por alcance, área de expertise y tipo de actividad, y se encadena con el siguiente para formar un proceso end-to-end completo: **Idea → PRD → Epic → Ticket → Implementación → PR → Merge**.

## Tabla de Contenidos

- [Diagrama Maestro: Proceso E2E Completo](#diagrama-maestro-proceso-e2e-completo)
- [Resumen de Workflows: Entrada / Salida / Ready for](#resumen-de-workflows-entrada--salida--ready-for)
- [Orquestadores y módulos transversales](#orquestadores-y-módulos-transversales)
- [Paso previo opcional: Esbozo de idea (`esbozar-idea`)](#paso-previo-opcional-esbozo-de-idea-esbozar-idea)
- [Workflow 1: Descubrimiento de Producto (Idea → PRDs)](#workflow-1-descubrimiento-de-producto-idea--prds)
- [Workflow 2: Gestión de Epics (Planificación Estratégica)](#workflow-2-gestión-de-epics-planificación-estratégica)
- [Workflow 3: Preparación de Ticket](#workflow-3-preparación-de-ticket)
- [Workflow 4: Ejecución de Implementación](#workflow-4-ejecución-de-implementación)
- [Workflow 5: Revisión de PRs](#workflow-5-revisión-de-prs)
- [Workflow 6: Implementación End-to-End (Orquestador)](#workflow-6-implementación-end-to-end-orquestador)
- [Módulo Transversal: Comprensión y Enseñanza](#módulo-transversal-comprensión-y-enseñanza)
- [Skills Desconectados / Standalone](#skills-desconectados--standalone)
- [Resumen de Interconexiones](#resumen-de-interconexiones)

## Diagrama Maestro: Proceso E2E Completo

```mermaid
flowchart LR
    Pminus1[esbozar-idea<br/>opcional] -.->|idea muy verde| P0

    subgraph WF1["1. Descubrimiento de Producto"]
        direction TB
        P0[Idea bruta] --> P1[analizar-idea]
        P1 --> P2[evaluar-alcance-idea]
        P2 --> P3[priorizar-roadmap]
        P3 --> P4[evaluar-conectividad-tecnica]
        P4 --> P5[orquestar-prd-workflow]
        P5 --> P6[Uno o múltiples PRDs puntuados]
    end

    subgraph WF2["2. Planificación de Epics"]
        direction TB
        E1[orquestar-epic-workflow] --> E2[Uno o múltiples epics validados]
    end

    subgraph WF3["3. Preparación de Ticket"]
        direction TB
        T1[crear-ticket] --> T2[revisar-ticket / brief / clasificar-tareas]
        T2 --> T3[planificar-implementacion]
        T3 --> T4[Plan puntuado]
    end

    subgraph WF4["4. Ejecución de Implementación"]
        direction TB
        I1[implementar-plan] --> I2[actualizar-mapeo-contextos]
        I2 --> I3[revisar-cambios-locales]
        I3 --> I4[analizar-cambios-codigo]
    end

    subgraph WF5["5. Revisión de PR"]
        direction TB
        R1[revisar-pr] --> R2[clasificar-comentarios / mejorar-pr]
        R2 --> R3[Ready for merge]
    end

    WF1 --> WF2 --> WF3 --> WF4 --> WF5
```

## Resumen de Workflows: Entrada / Salida / Ready for

- **1. Descubrimiento de Producto**
  - Entrada: Idea bruta (o esbozo pulido por `esbozar-idea` — paso previo opcional)
  - Artefacto de salida: `prd.md` (uno o múltiples) + `prd-workflow-summary.md` + `prd-roadmap-state.md` + `roadmap.md` consolidado del dominio
  - Ready for: `planificar-epics`
- **2. Gestión de Epics**
  - Entrada: PRD
  - Artefacto de salida: `tasks.md` por epic + validación completa
  - Ready for: `crear-ticket`
- **3. Preparación de Ticket**
  - Entrada: Epic-tasks o brief
  - Artefacto de salida: `implementation-plan.md` puntuado
  - Ready for: `implement`
- **4. Ejecución de Implementación**
  - Entrada: Plan puntuado
  - Artefacto de salida: Cambios locales verificados + `code-analysis-summary.md`
  - Ready for: Abrir PR
- **5. Revisión de PRs**
  - Entrada: PR abierto
  - Artefacto de salida: `pr-<N>-review.md` + comentarios postables
  - Ready for: `merge`
- **6. Implementación End-to-End**
  - Entrada: Ticket sin plan previo
  - Artefacto de salida: Código verificado localmente (orquesta 3 + parte de 4)
  - Ready for: Abrir PR (opcional)

## Orquestadores y módulos transversales

Los siguientes orquestadores automatizan workflows completos. Úsalos cuando quieras avanzar sin invocar cada skill a mano:

- **`orquestar-prd-workflow`** orquesta el Workflow 1 completo (incluyendo `analizar-idea`, `evaluar-alcance-idea`, `priorizar-roadmap` y `evaluar-conectividad-tecnica` como gates iniciales).
- **`orquestar-epic-workflow`** orquesta el Workflow 2 completo (incluyendo priorización de epics, evaluación de conectividad por epic, gates de Go/No-Go, rama opcional de spike técnico y loop de procesamiento para múltiples epics).
- **`implementar-ticket`** (Workflow 6) orquesta el Workflow 3 completo más la fase de codificación y verificación del Workflow 4. **No reemplaza al Workflow 4 completo**: no encadena automáticamente `actualizar-mapeo-contextos`, `revisar-cambios-locales` ni `revisar-cambios-implementados` (ver límite de alcance en Workflow 6).
- **Módulo transversal Comprensión y Enseñanza** puede insertarse como puerta opcional antes del Workflow 4 o antes del Workflow 5.
- **`esbozar-idea`** es un paso previo opcional al Workflow 1 (no es un orquestador). Conduce un chat interactivo que pulle una idea muy verde en un esbozo ligero (`docs/drafts/<slug>/esbozo.md`) listo para `analizar-idea`. No evalúa viabilidad ni añade detalle — solo formula el resultado deseado sin soluciónizar. No está encadenado en `orquestar-prd-workflow`; se invoca a mano cuando la idea no está lista para el flujo 1.

---

## Paso previo opcional: Esbozo de idea (`esbozar-idea`)

Antes del Workflow 1, cuando la idea está muy verde o vaga para entrar al flujo, `esbozar-idea` conduce un chat interactivo de ida y vuelta que la pulle en un esbozo ligero y bien formado.

- **Entrada**: idea bruta vaga (texto libre del usuario).
- **Artefacto de salida**: `docs/drafts/<IDEA-SLUG>/esbozo.md` — artefacto temporal de staging (vive fuera de `docs/<domain>/` porque la idea aún no está comprometida con un dominio ni con el flujo 1).
- **Ready for**: `analizar-idea` / `orquestar-prd-workflow` / `bloqueado`.

**Límite de alcance**: el esbozo es deliberadamente ligero — declara el resultado deseado sin soluciónizar, beneficiarios y motivación. **No** evalúa viabilidad (eso es `analizar-idea`), ni estructura requerimientos (`capturar-requerimiento`), ni divide alcance (`evaluar-alcance-idea`), ni define personas/casos de uso/métricas. El detalle es trabajo del flujo 1. El esbozo se escribe para que `analizar-idea` pueda evaluarlo sin tener que reformularlo primero.

No es parte del orquestador `orquestar-prd-workflow` — se invoca a mano cuando hace falta. Si la idea ya está bien formada, se omite y se entra directo al Workflow 1.

---

## Workflow 1: Descubrimiento de Producto (Idea → PRDs)

Workflow que transforma una idea de producto bruta en uno o múltiples PRDs formales listos para planificación arquitectónica, con puntos de salida a spike técnico o demo interactivo cuando la idea o los flujos no están claros. Incluye análisis preliminar con descubrimiento basado en resultados, evaluación de alcance para dividir ideas complejas en funcionalidades individuales, priorización basada en valor vs esfuerzo, evaluación de conectividad para generar features puente cuando la idea está desconectada, mapeo de assumptions (framework de David Bland) y diseño riguroso de experimentos antes del PRD.

```mermaid
flowchart TD
    A[analizar-idea] -->|detecta profile: full o lite| B{Humano: Proceder/No proceder?}
    B -->|No proceder| X[Exit temprano]
    B -->|Proceder| C[evaluar-alcance-idea]
    C --> D{¿Múltiples funcionalidades?}
    D -->|Sí| E[priorizar-roadmap]
    D -->|No, N=1| D2[stub priorización N=1]
    D -->|Sí| E2
    D2 --> E2[evaluar-conectividad-tecnica]
    E --> E2
    E2 --> F{¿Greenfield + lite?}
    F -->|Sí| G2[connectivity short-form]
    F -->|No| G[connectivity full]
    G2 --> H[capturar-requerimiento]
    G --> H
    H -.->|recomendado| I[mapear-assumptions]
    H -->|omitido con registro| I2
    I --> I2{¿Feasibility assumption risk>=Medio, evidence<=Baja?}
    I2 -->|Sí| I3[construir-spike feasibility gate]
    I2 -->|No| J
    I3 --> J[validar-viabilidad-producto]
    J --> K{Humano: Proceder/No proceder?}
    K -->|No proceder| X
    K -->|Proceder condicional riesgo técnico| L[construir-spike]
    K -->|Proceder| M
    L --> M[definir-usuarios]
    M --> N[mapear-casos-uso]
    N --> N2[gate: métrica medible por success metric]
    N2 --> O{Stage}
    O -.->|stage Growth/Scale| P[disenar-experimentos]
    O -->|stage MVP: omitido con stub| Q
    P --> Q[generar-prd]
    Q --> R2[gate: no-duplicación de condiciones/Go-No-Go]
    R2 --> R{¿Más funcionalidades?}
    R -->|Sí| S[Actualizar roadmap]
    S --> E
    R -->|No| T[prd-workflow-summary + prd-roadmap-state + roadmap.md]

    style A fill:#e1f5ff
    style I fill:#e1f5ff,stroke-dasharray: 5 5
    style P fill:#e1f5ff,stroke-dasharray: 5 5
    style M fill:#fff4e1
    style N fill:#fff4e1
    style Q fill:#e1ffe1
    style T fill:#e1ffe1
    style I3 fill:#fff4e1,stroke-dasharray: 5 5
    style N2 fill:#ffe1e1
    style R2 fill:#ffe1e1
    style D2 fill:#e1ffe1
    style G2 fill:#e1ffe1
```

**Propósito**: Convertir una idea informal en uno o múltiples requerimientos estructurados, validados por viabilidad de negocio, con personas y casos de uso concretos, consolidados en PRDs con criterios experimentales estado-específicos (MVP/Growth/Scale). Incluye análisis preliminar con descubrimiento basado en resultados, evaluación de alcance para evitar PRDs gigantescos, priorización inteligente basada en RICE, evaluación de conectividad con el codebase actual, mapeo de assumptions (framework de David Bland), gates de calidad de razonamiento (no-solutionización, spike por feasibility, métrica medible, no-duplicación), path lite para dogfooding/internal, y diseño riguroso de experimentos.

**Descripción narrativa**: Este workflow inicia con `analizar-idea`, que combina un gate rápido de viabilidad con la definición del resultado deseado sin mencionar la solución. Evalúa:

1. **Descubrimiento basado en resultados + profile**: `analizar-idea` define el resultado deseado (resultado/estado, no funcionalidad) y valida que sea medible sin mencionar tecnología o implementación. Si no puede definirse sin solución, marca como "necesita reformulación". Evalúa alineación estratégica, urgencia y disponibilidad básica de recursos para generar una recomendación preliminar Proceder/Proceder condicional/No proceder. Además, declara un campo `profile: full | lite` que el orquestador consume para activar shortcuts (stub RICE N=1, connectivity short-form, 1 persona, experiment-design omitido por defecto). `lite` aplica a dogfooding/internal tool/1-2 personas/greenfield/MVP N=1; `full` a producto externo/Growth-Scale/N>1. Genera `docs/<domain>/idea/<IDEA-SLUG>/idea-analysis.md`.

2. **Alcance**: `evaluar-alcance-idea` determina si la idea describe múltiples funcionalidades independientes (ej: "sistema de notificaciones + sistema de archivos") o una funcionalidad cohesiva (ej: "alertas de inactividad"). Si son múltiples funcionalidades, las divide en elementos individuales con alcance, propuesta de valor y cronograma, generando `docs/<domain>/idea/<IDEA-SLUG>/scope-roadmap.md`.

3. **Priorización**: `priorizar-roadmap` calcula puntuaciones RICE (Alcance × Impacto × Confianza / Esfuerzo) para cada funcionalidad, generando `docs/<domain>/idea/<IDEA-SLUG>/feature-prioritization.md` con ranking basado en valor vs esfuerzo. Ajusta por dependencias, marcando elementos bloqueados. **Path lite (N=1)**: si `scope-roadmap.md` declara "funcionalidad única", emite un stub con el score RICE como sanity check (no roadmap ranqueado) — reduce ceremonia para MVPs dogfooding.

4. **Conectividad**: `evaluar-conectividad-tecnica` analiza el codebase actual (auth, DB, APIs, servicios, frontend, monitoring) para identificar prerequisitos existentes. Determina si la funcionalidad está conectada (prerequisitos existen), desconectada (falta infraestructura crítica) o **greenfield** (repo sin codebase/producto previo — conectado por vacío, sin prerequisitos previos que falten). En modo greenfield el paso no se salta: genera el artefacto obligatorio con veredicto "conectado (greenfield)" como registro de la decisión. **Path lite (greenfield + profile=lite)**: emite un short-form (tabla mínima de componentes a crear, sin enumerar cada categoría de infraestructura como N/A). Si está desconectada, genera plan de trabajo de funcionalidades puente que construyen la infraestructura necesaria paso a paso, escribiendo `docs/<domain>/initiatives/<PRD-SLUG>/bridge-roadmap.md`.

El orquestador selecciona la funcionalidad más prioritaria y ejecuta el workflow PRD estándar (`capturar-requerimiento` → `mapear-assumptions` (recomendado) → **gate de spike por feasibility assumption** → `validar-viabilidad-producto` → `definir-usuarios` → `mapear-casos-uso` → `disenar-experimentos` (condicional al stage) → `generar-prd`). Después de generar cada PRD, verifica si hay más funcionalidades pendientes en el roadmap. Si sí, actualiza el estado, selecciona la siguiente funcionalidad prioritaria y repite el proceso. Si no, genera los artefactos de cierre: `docs/<domain>/idea/<IDEA-SLUG>/prd-roadmap-state.md` con el estado final del roadmap, `docs/<domain>/initiatives/<PRD-SLUG>/prd-workflow-summary.md` con el resumen del workflow, y `docs/<domain>/roadmap.md` consolidado del dominio.

`capturar-requerimiento` estructura la idea en documento formal con problema, audiencia afectada, solución propuesta y restricciones, escribiendo `docs/<domain>/initiatives/<PRD-SLUG>/requirements.md`. **Gate de no-solutionización**: las "Decisiones resueltas" solo pueden ser de tipo (a) restricciones de timing/recursos/negocio, (b) restricciones de tech stack impuestas externamente, (c) decisiones de alcance. NO se permiten decisiones de diseño de solución (formato de archivos, flags, políticas de UX, mecanismos de handoff) — esas se toman en `generar-prd` (sección RF), informadas por personas y casos de uso.

Este artefacto pasa a `mapear-assumptions` (**recomendado, no bloqueante**), que identifica assumptions en 4 buckets (desirability, viability, feasibility, usability) usando el framework de David Bland. Genera matriz 2x2 (risk vs evidence) y prioriza assumptions de alto riesgo/baja evidencia para focus discovery, escribiendo `docs/<domain>/initiatives/<PRD-SLUG>/assumption-map.md`. Para cada assumption priorizado, sugiere tipo de experimento apropiado (fake door, prototype, spike, etc.) y declara un campo `spike-required: yes/no` (con `spike-question:` cuando `yes`) que el orquestador consume para disparar spikes de feasibility. **Si se omite** (greenfield de bajo riesgo, dogfooding, internal tool), la omisión debe registrarse: un stub `assumption-map.md` con veredicto "Omitido" y razón, o un campo "Pasos omitidos" en `requirements.md`. Sin registro, la trazabilidad del proceso se pierde.

**Gate de spike por feasibility assumption** (nuevo, entre `mapear-assumptions` y `validar-viabilidad-producto`): el orquestador filtra assumptions donde bucket=feasibility, risk∈{Alto,Medio}, evidence∈{Baja,Media}, spike-required=yes. Si hay matches, invoca `construir-spike` por cada assumption **antes** de `validar-viabilidad-producto`, sin depender de que el veredicto general sea "Conditional Go por riesgo técnico". Esto frena el problema donde un assumption de feasibility queda enterrado porque el veredicto general es por demanda.

Luego `validar-viabilidad-producto` actúa como **gate** del workflow: evalúa alineación estratégica (Fase A), demanda real con evidencia estado-apropiada (Fase B), disponibilidad de recursos (Fase C) y riesgo de negocio con matriz de probabilidad/impacto (Fase D), genera veredicto Proceder/Proceder condicional/No proceder con matriz de decisión ponderada (Fase E) y escribe `docs/<domain>/initiatives/<PRD-SLUG>/product-viability.md` (Fase F).

- Si el veredicto es **No proceder**, el workflow se detiene: se rechaza o pospone la idea sin invertir más tiempo.
- Si el veredicto es **Proceder condicional** por riesgo técnico no resuelto (tecnología desconocida, integración incierta), `Ready for: spike` dirige a `construir-spike`, que responde la pregunta de diseño puntual con un boceto desechable y notas de hallazgos. El spike no implementa la funcionalidad real; solo resuelve la incógnita técnica antes de invertir en personas y casos de uso. Resuelta la pregunta, el workflow retoma en `definir-usuarios`.
- Si el veredicto es **Proceder**, continúa directo a `definir-usuarios`.

`definir-usuarios` detalla personas primarias y secundarias con motivaciones, pain points, comportamientos e hipótesis de adopción. **Path lite (profile=lite)**: 1 persona primaria (el dogfooder) + 0-1 secundaria (solo si hay un rol distinto claro). **Path full**: 2-3 personas (regla original). Usa una arquitectura de dos capas: **personas canónicas** compartidas a nivel dominio en `docs/<domain>/personas/<persona-slug>.md` (una por archivo, reutilizables entre iniciativas del mismo dominio sin duplicar contenido) y un **mapeo por PRD** en `docs/<domain>/initiatives/<PRD-SLUG>/personas-mapping.md` que referencia las personas canónicas con su rol específico en el PRD. **Nota**: Este workflow asume que la validación de hipótesis con usuarios ya ocurrió previamente o se asume validada por otros medios.

Este artefacto alimenta a `mapear-casos-uso`, que mapea happy path, paths alternativos, edge cases, precondiciones y postcondiciones por persona (Fases A-E), consolida una matriz de casos de uso con success metrics (Fase F) y escribe `docs/<domain>/initiatives/<PRD-SLUG>/use-cases.md` (Fase G). **Gate de métrica medible**: cada success metric declara un campo `measurement` (telemetría / survey / auto-reporte / manual / no-medible-en-MVP). Las métricas con measurement manual/survey/auto-reporte tienen thresholds cualitativos (no numéricos firmes). Las `no-medible-en-MVP` se marcan como observación post-MVP y no cuentan para Go/No-Go.

**Punto opcional de visibilidad**: cuando los flujos mapeados son complejos (state machines, multi-paso, sincronización) y el equipo o los stakeholders necesitan verlos correr antes de comprometerse al PRD, se puede invocar `construir-demo` tomando `docs/<domain>/initiatives/<PRD-SLUG>/use-cases.md` como documento de contexto. El demo construye un artefacto ejecutable temporal (HTML, CLI o script) que hace tangibles los casos de uso mapeados, generando `docs/<domain>/initiatives/<PRD-SLUG>/harness-notes.md`. Es desechable por defecto y no reemplaza al PRD ni a una implementación real; su único objetivo es validar que los flujos mapeados capturan el comportamiento esperado antes de formalizarlos.

`disenar-experimentos` (**condicional al stage**) diseña el setup riguroso del experimento antes del PRD: articula hypothesis (null + alternative), define primary metric y guardrail metrics, calcula sample size y MDE, establece duración del test y decision rules (continue/kill/pivot), y define setup técnico (population, treatment, comparator, randomization). Escribe `docs/<domain>/initiatives/<PRD-SLUG>/experiment-design.md`. **Solo se ejecuta en stage Growth/Scale** (data suficiente para A/B testing). En stage MVP se omite (A/B no apropiado), pero la omisión se registra con un stub `experiment-design.md` con veredicto "Omitido por stage MVP" para preservar trazabilidad.

Finalmente, `generar-prd` consolida requerimiento, viabilidad, personas, casos de uso y diseño de experimentos en un PRD formal con visión, requisitos funcionales y no-funcionales, y **criterios experimentales estado-específicos** (MVP: signups + surveys; Growth: A/B landing; Scale: A/B in-app), escribiendo `docs/<domain>/initiatives/<PRD-SLUG>/prd.md` con `Ready for: planificar-epics`. **Gate de no-duplicación**: las secciones 6 (Requisitos Experimentales) y 11 (Riesgos) **referencian** (no reescriben) los artefactos upstream (`experiment-design.md`, `product-viability.md` §5/§7, `assumption-map.md`). **Gate anti-pre-especificación**: la sección 9 (Timeline) declara solo la restricción de timeline (ej: "MVP target: ~3-4 semanas"), no descompone en fases de implementación con dependencias — esa decomposition es job de `planificar-epics` (Workflow 2).

**Entry point recomendado**: `orquestar-prd-workflow [IDEA-DESCRIPCION]` automatiza las fases con los mismos gates, incluyendo las ramas opcionales (división de alcance para múltiples funcionalidades, funcionalidades puente para ideas desconectadas, spike ante Proceder condicional por riesgo técnico, **gate de spike por feasibility assumption** antes de `validar-viabilidad-producto`, demo tras `mapear-casos-uso` cuando los flujos son complejos), loop de procesamiento para múltiples funcionalidades, **detección de profile (full/lite)** que activa shortcuts lite, consolida los artefactos y escribe `docs/<domain>/initiatives/<PRD-SLUG>/prd-workflow-summary.md` con `Ready for: planificar-epics`. Las ramas opcionales solo se ejecutan cuando su condición dispara — no corren en cada invocación. El orquestador incluye un **gate de cierre** que verifica que los artefactos de cierre obligatorios (`prd.md`, `prd-roadmap-state.md`, `prd-workflow-summary.md`, `roadmap.md`, `workflow-state.md`) y los artefactos por funcionalidad existen en disco, y que las omisiones justificadas (assumptions en greenfield, experimentos en MVP) están registradas antes de marcar `Ready for: planificar-epics`. El algoritmo de reconstrucción de estado vive en `references/state-reconstruction.md`.

El PRD resultante es la entrada directa del **Workflow 2**.

---

## Workflow 2: Gestión de Epics (Planificación Estratégica)

Workflow que transforma un PRD en uno o múltiples epics validados con documentación técnica completa, con priorización basada en valor vs esfuerzo, evaluación de conectividad por epic, gates de Go/No-Go en múltiples puntos, rama opcional de spike técnico ante riesgos no resueltos y loop de procesamiento para múltiples epics. Incluye validación técnica, arquitectura visual, estrategia de testing y decisiones arquitectónicas documentadas.

```mermaid
flowchart TD
    A[planificar-epics] --> B{¿Múltiples epics?}
    B -->|Sí| C[priorizar-epics]
    B -->|No| D[Seleccionar epic]
    C --> D
    D --> E[evaluar-conectividad-epic]
    E --> F{¿Conectado?}
    F -->|No| G[generar-bridge-roadmap-epic]
    F -->|Sí| H[dividir-epic]
    G --> H
    H --> I[generar-trd]
    I --> J{Humano: Go/No-Go?}
    J -->|No-Go| X[Exit temprano]
    J -->|Go| K[validar-viabilidad-tecnica]
    K --> L{¿Riesgo técnico?}
    L -->|Sí| M[construir-spike]
    L -->|No| N[validar-epic-completo]
    M --> N
    N --> O[validar-viabilidad-tecnica]
    N --> P[generar-arquitectura]
    N --> Q[generar-estrategia-testing]
    N --> R[sugerir-casos-prueba]
    I --> S[generar-adr]
    O --> T[Consolidar validación]
    P --> T
    Q --> T
    R --> T
    S --> T
    T --> U{¿Más epics?}
    U -->|Sí| V[Actualizar roadmap]
    V --> D
    U -->|No| W[Workflow completo]

    style A fill:#e1f5ff
    style C fill:#e1f5ff
    style E fill:#e1f5ff
    style H fill:#fff4e1
    style I fill:#fff4e1
    style N fill:#ffe1e1
    style O fill:#ffe1e1
    style P fill:#ffe1e1
    style Q fill:#ffe1e1
    style R fill:#ffe1e1
    style S fill:#e1ffe1
    style T fill:#e1ffe1
```

**Propósito**: Convertir iniciativas de producto (PRDs) en uno o múltiples epics estructurados con validación técnica, arquitectura visual, estrategia de testing y decisiones arquitectónicas documentadas. Incluye priorización de epics basada en RICE, evaluación de conectividad por epic con features puente cuando está desconectado, gates de Go/No-Go en múltiples puntos (TRD, viabilidad técnica, validación completa), rama opcional de spike técnico ante riesgos no resueltos y loop de procesamiento para múltiples epics.

**Descripción narrativa**: Este workflow comienza con validación de entrada: verifica que el PRD proviene del **Workflow 1** y tiene `Ready for: planificar-epics`. Si el PRD no cumple, sugiere ejecutar el Workflow 1 primero.

1. **Planificación de epics**: `planificar-epics` analiza el PRD (Fase A: validar objetivo, usuarios, criterios de éxito, **y consume el veredicto condicional de `product-viability.md`** — si fue Conditional Go, mapea las condiciones heredadas a riesgos/prerequisitos por epic), **consume el artefacto de conectividad de WF1** (`prerequisites-assessment.md` — si greenfield, skip del grep por arquitecturas existentes; si no, lo usa como punto de partida) (Fase B), estructura **1-7 epics** (1-3 para funcionalidad única con fases internas lineales, 3-7 para múltiples funcionalidades) donde cada epic entrega **valor verificable** (independencia de deploy deseable pero no obligatoria para features secuenciales) (Fase C), mapea dependencias entre epics (Fase D) y genera `docs/<domain>/initiatives/<PRD-SLUG>/epics/epic-plan.md` (Fase E).

2. **Priorización de epics**: Si hay múltiples epics, `priorizar-epics` calcula scores RICE (Reach × Impact × Confidence / Effort) para cada epic, generando `docs/<domain>/initiatives/<PRD-SLUG>/epic-prioritization.md` con ranking basado en valor vs esfuerzo. Ajusta por dependencias, marcando epics bloqueados. El orquestador selecciona el epic más prioritario.

3. **Conectividad por epic**: `evaluar-conectividad-epic` analiza el codebase actual (auth, DB, APIs, servicios, frontend, monitoring) para identificar prerequisitos existentes específicos del epic seleccionado. Determina si el epic está conectado (prerequisitos existen) o desconectado (falta infraestructura crítica). Si está desconectado, genera roadmap de features puente que construyen la infraestructura necesaria paso a paso, escribiendo `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/bridge-roadmap.md`.

4. **División del epic**: `dividir-epic` carga el epic seleccionado y el contexto técnico (Fase A), divide el epic en 5-12 tareas atómicas con AC, archivos que toca y estimaciones 1-8 puntos (Fase B), mapea artefactos del codebase por tarea (Fase C), detecta dependencias entre tareas (Fase D) y genera `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/tasks.md` (Fase F).

5. **TRD y gate de revisión**: `generar-trd` analiza AC técnicos del epic (Fase A), especifica arquitectura general, modelos de datos, APIs, integraciones y comportamientos críticos (Fases B-E), define testing strategy y riesgos (Fases F-G) y genera `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/trd.md` (Fase H). Este punto actúa como **gate** de revisión de requisitos técnicos antes de invertir en arquitectura. Si el humano marca No-Go, el workflow se detiene sin invertir más tiempo.

6. **Rama opcional de spike técnico**: `validar-viabilidad-tecnica` analiza el codebase, valida construcciones nuevas vs reutilización, identifica deuda técnica bloqueante, compara con precedentes, detecta brechas de infraestructura y genera `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/viability-assessment.md`. Si detecta riesgo técnico no resuelto (tecnología desconocida, integración incierta), `Ready for: spike` dirige a `construir-spike`, que responde la pregunta de diseño puntual con un boceto desechable y notas de hallazgos. El spike no implementa la feature real; solo resuelve la incógnita técnica antes de invertir en arquitectura. Resuelta la pregunta, el workflow retoma en `validar-epic-completo`.

7. **Validación completa del epic**: El orquestador `validar-epic-completo` ejecuta en secuencia:
   - `validar-viabilidad-tecnica` (si no se ejecutó antes o tras el spike)
   - `generar-arquitectura` (analiza TRD para componentes, crea diagramas Mermaid de componentes, flujos y deployment, define matriz de comunicación, escalabilidad, resiliencia, seguridad y monitoreo, genera `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/architecture.md`)
   - `generar-estrategia-testing` (identifica componentes críticos, aplica metodología ZOMBIE por componente, define matriz de cobertura unit/integration/E2E, especifica test data strategy y validaciones por layer, genera `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/test-strategy.md`)
   - `sugerir-casos-prueba` (analiza el epic plan para generar test cases a nivel de epic, genera happy path, edge cases, error cases, boundary cases, side effects, concurrency e integration cases con ejemplos concretos, genera `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/test-cases.md`)

8. **ADRs**: Paralelamente, `generar-adr` toma el TRD, identifica 2-5 decisiones arquitectónicas clave (Fase A), genera ADRs en formato MADR con Context, Decision, Rationale, Consequences y Alternatives (Fase B), crea referencias cruzadas con TRD y tareas (Fase E) y escribe `docs/<domain>/adr/ADR-001-*.md` (Fase F).

9. **Consolidación y gate final**: El orquestador consolida todos los hallazgos en `docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/complete-validation.md` con matriz de decisión y plan de acción. Este punto actúa como **gate final** de aprobación antes de pasar a implementación. Si el humano marca No-Go, el workflow se detiene.

10. **Loop de procesamiento**: Después de validar un epic, el orquestador verifica si hay más epics pendientes en el roadmap. Si sí, actualiza el estado en `docs/<domain>/initiatives/<PRD-SLUG>/epic-roadmap-state.md`, selecciona el siguiente epic prioritario y repite el proceso desde la evaluación de conectividad. Si no, genera `docs/<domain>/initiatives/<PRD-SLUG>/workflow-summary.md` con el resumen consolidado de todos los epics validados, matriz de decisión global y plan de acción.

**Camino alternativo ligero**: cuando no se necesita el paquete completo de `validar-epic-completo` (viabilidad técnica + arquitectura + test strategy) sino solo un chequeo rápido de documentación, impacto predicho y test cases sobre el epic plan, `analizar-cambios-codigo` ejecuta `detectar-documentacion-faltante` → `predecir-impacto-cambio` → `sugerir-casos-prueba` en secuencia y genera un resumen consolidado. No sustituye a `validar-epic-completo`: es un análisis más liviano para epics de bajo riesgo o iteraciones sobre un epic ya validado antes. Su contraparte de tickets (Workflow 4) es `revisar-cambios-implementados`, que además valida impacto real vs. predicho.

**Entry point recomendado**: `orquestar-epic-workflow [PRD-PATH]` automatiza las 10 fases con los mismos gates, incluyendo las tres ramas opcionales (priorización de epics para múltiples epics, features puente para epics desconectados, spike ante riesgo técnico no resuelto), loop de procesamiento para múltiples epics, consolida los artefactos y escribe `docs/<domain>/initiatives/<PRD-SLUG>/workflow-summary.md` con `Ready for: crear-ticket`. Las ramas opcionales solo se ejecutan cuando su condición dispara — no corren en cada invocación.

**Skills nuevos creados para este workflow:**

- `priorizar-epics` - Prioriza epics usando metodología RICE
- `evaluar-conectividad-epic` - Evalúa prerequisitos técnicos por epic
- `orquestar-epic-workflow` - Orquestador centralizado del workflow completo

**Skills actualizados:**

- `planificar-epics` - Agregada validación de `Ready for: planificar-epics` en el PRD
- `generar-trd` - Agregado gate de Go/No-Go después de generar el TRD
- `validar-epic-completo` - Agregado gate final de Go/No-Go antes de consolidar validación

Los epics validados (`docs/<domain>/initiatives/<PRD-SLUG>/epics/<EPIC-SLUG>/tasks.md`) son la entrada de `crear-ticket` en el **Workflow 3**.

---

## Workflow 3: Preparación de Ticket

Sesión de trabajo de análisis y planificación: desde una idea, epic o brief hasta un plan de implementación puntuado listo para codificar. No escribe código de producción.

```mermaid
flowchart TD
    A[crear-ticket] --> B[revisar-ticket]
    B --> C[generar-brief-contexto]
    C --> D[clasificar-tareas]
    D -->|resolve-questions| Q[Preguntas abiertas al usuario]
    D -->|spike| S[construir-spike]
    D -->|demo| H[construir-demo]
    D -->|planificar-implementacion| E[planificar-implementacion]
    S --> E
    H --> E
    E --> F[predecir-impacto-cambio]
    E --> G[sugerir-casos-prueba]
    F --> P[Plan ajustado y puntuado]
    G --> P

    style A fill:#e1f5ff
    style B fill:#ffe1e1
    style C fill:#fff4e1
    style D fill:#fff4e1
    style Q fill:#ffe1e1
    style S fill:#fff4e1
    style H fill:#fff4e1
    style E fill:#fff4e1
    style F fill:#ffe1e1
    style G fill:#ffe1e1
    style P fill:#e1ffe1
```

**Propósito**: Pipeline de análisis previo a la codificación: crea o carga el ticket, lo pasa por gate de calidad, construye contexto de investigación, decide si hace falta desbloquear preguntas de diseño (spike) o visibilidad de runtime (demo) antes de planificar, y produce un plan de implementación puntuado con impacto y test cases predichos.

**Descripción narrativa**:

1. **Creación del ticket**: `crear-ticket` resuelve la entrada desde conversación, brief, notas, seguimiento de PR o el epic-task producido por el Workflow 2 (Fase 0), usa subagentes en paralelo para búsqueda en herramientas de gestión, documentación y pase de codebase/convention (Fase A), redacta el borrador con Problema, Alcance (in/out), Requisitos, Testing/QA, Criterios de aceptación, Preguntas abiertas y Referencias (Fase B), puntúa según draft-rating-rubric y genera el archivo `docs/<domain>/<slug>.md` (Fase C).

2. **Gate de calidad del ticket**: `revisar-ticket` carga el ticket y brief de investigación (Fase A), usa subagentes en paralelo para ticket-deps, feasibility y conventions (Fase A), evalúa problema, AC, alcance, dependencias, estimación, factibilidad y drift a plan de implementación (Fase B), genera brief de revisión con puntuación, hallazgos estructurados y Ready for (Fase C).

3. **Brief de contexto**: si el ticket pasa (Ready for = context-brief o plan), `generar-brief-contexto` toma el ticket, usa subagentes en paralelo para ticket-deps, docs y codebase (Fase A), investiga y verifica cruzadamente comportamiento actual contra codebase citando ≥3 rutas de entry-point (Fase B), genera research brief con resumen del ticket, mapa de epic/dependencias, notas de producto, estado actual del codebase, brechas vs AC, riesgos, Preguntas abiertas y outline sugerido (Fase C), escribiendo `docs/<domain>/<TICKET-SLUG>-context-brief.md`.

4. **Gate de triage**: `clasificar-tareas` hace verificación cruzada con el codebase citando ≥2 rutas reales de entry points, divide ítems de trabajo en Primary (requiere juicio: diseño, lógica de dominio, límites de auth/PHI, contratos de API, decisiones arquitectura) y Secondary (preparación/apalancamiento: mapas del codebase, plomería de fixtures, limpieza de lint/tipos, docs, scaffolding de tests), anota dependencias entre ítems, elige próximo paso mapeado al ítem Primary de mayor riesgo y genera `docs/<domain>/<TICKET-SLUG>-ticket-work-triage.md` con puntuación y Ready for:
   - **`resolve-questions`**: hay preguntas abiertas bloqueantes; se detiene y se le pide al usuario resolverlas.
   - **`spike`**: una pregunta de diseño no está clara; `construir-spike` la resuelve con un boceto desechable antes de planificar.
   - **`demo`**: se necesita ver comportamiento en runtime (state machines, sync, edge cases) antes de planificar; `construir-demo` construye el artefacto ejecutable temporal.
   - **`planificar-implementacion`**: no hay bloqueos, se procede directo a planificar.

5. **Planificación**: resuelto el spike o demo (si aplicó), `planificar-implementacion` usa subagentes en paralelo para context-load, ticket-deps y conventions (Fase A), mapea cada AC a un paso del plan, lista efectos de segundo orden, produce guía paso a paso con commits pequeños (propósito + archivos + tests), nombra comandos de validación dirigidos (Fase B), genera plan puntuado `docs/<domain>/<TICKET-ID>-implementation-plan.md` (Fase C).

6. **Análisis pre-implementación (paralelo)**: después de `planificar-implementacion`, se ejecutan en paralelo `predecir-impacto-cambio` y `sugerir-casos-prueba`.
   - `predecir-impacto-cambio` analiza el plan para detectar breaking changes, mapear dependencias downstream, predecir impacto en performance y seguridad, e identificar esfuerzo de cascade updates (Fase A), genera `docs/<domain>/<TICKET-ID>-impact-analysis.md` con matriz de riesgos y timeline (Fase B).
   - `sugerir-casos-prueba` analiza el plan para identificar happy path, edge cases, error cases, boundary cases, side effects, concurrency e integration cases (Fase A), genera `docs/<domain>/<TICKET-ID>-test-cases.md` con matriz de cobertura y recomendaciones (Fase B).

El resultado es un plan puntuado (≥9, `Ready for: implement`) con impacto y test cases predichos, listo para el **Workflow 4**.

---

## Workflow 4: Ejecución de Implementación

Sesión de trabajo de codificación y validación: desde un plan puntuado hasta cambios locales listos para PR, con documentación, mapa de dominio y cobertura de tests verificados contra lo predicho en el Workflow 3.

```mermaid
flowchart TD
    A[implementar-plan] --> B[actualizar-mapeo-contextos]
    B --> C[revisar-cambios-locales]
    C --> D[revisar-cambios-implementados]

    D --> E[detectar-documentacion-faltante]
    D --> F[validar-impacto-real]
    D --> G[validar-casos-prueba-implementados]

    style A fill:#e1f5ff
    style B fill:#e1ffe1
    style C fill:#ffe1e1
    style D fill:#ffe1e1
    style E fill:#ffe1e1
    style F fill:#ffe1e1
    style G fill:#ffe1e1
```

**Propósito**: Ejecutar el plan puntuado como cambios locales, mantener el domain map sincronizado, pasar el gate de revisión local y validar retrospectivamente que la documentación, el impacto real y la cobertura de tests coinciden con lo predicho en 2a — antes de abrir PR.

**Descripción narrativa**:

1. **Implementación**: este workflow toma el plan ajustado con consideraciones de impacto y test cases (salida del Workflow 3) como entrada de `implementar-plan`, que aplica gates de readiness del plan (Fase 0), carga el plan y confirma working tree limpio (Fase A), ejecuta la guía paso a paso aplicando cambios locales pequeños, ejecutando validación dirigida después de cada chunk, siguiendo convenciones del proyecto y citando ≥2 rutas de archivos hermanos (Fase B), genera notas de implementación con cambios aplicados, cobertura de AC, resultados de validación y seguimientos (Fase C), escribiendo `docs/<domain>/<TICKET-ID>-implementation-notes.md`.

2. **Sincronización del domain map**: `actualizar-mapeo-contextos` carga el plan o diff de rama (Fase A), analiza cambios de dominio clasificando nuevas agregaciones, relaciones, contextos limitados y APIs públicas (Fase B), actualiza `docs/<domain>/domain-map.md` con nuevas agregaciones, contextos, relaciones inter-contexto y APIs (Fase C), detecta architectural smells (duplicación, ciclos) y valida integridad del domain map (Fases D-F).

3. **Gate antes de PR**: `revisar-cambios-locales` carga el ticket/brief y diff local vs base (Fase A), ejecuta checklist completo de AC, valida comandos de validación, cita pase de convenciones (≥2 rutas hermanas) y nota efectos de segundo orden (Fase B), genera resumen en chat con puntuación, estado de AC, hallazgos y Ready for, y opcionalmente escribe `docs/<domain>/<TICKET-SLUG>-local-review.md` (Fases C-D).

4. **Validación post-implementación**: el orquestador `revisar-cambios-implementados` toma el plan o rama y ejecuta en secuencia tres sub-skills:
   - `detectar-documentacion-faltante` analiza código nuevo, valida docstrings de funciones públicas, comentarios en lógica compleja, ejemplos de APIs, edge cases documentados, decisiones arquitectónicas en ADRs, README/setup docs y TODOs/FIXMEs bien formados. Genera `docs/<domain>/<TICKET-ID>-documentation-gaps.md` con gaps críticos/mayores/menores.
   - `validar-impacto-real` compara el impacto predicho en `docs/<domain>/<TICKET-ID>-impact-analysis.md` con el impacto real del código implementado, valida que los breaking changes detectados fueron mitigados y verifica que los servicios downstream afectados fueron notificados/actualizados. Genera `docs/<domain>/<TICKET-ID>-impact-validation.md` con veredicto de validación.
   - `validar-casos-prueba-implementados` compara los casos de prueba sugeridos en `docs/<domain>/<TICKET-ID>-test-cases.md` con los tests implementados, valida cobertura de happy path, edge cases, error cases, etc., e identifica gaps de cobertura. Genera `docs/<domain>/<TICKET-ID>-test-coverage-validation.md` con matriz de implementación y recomendaciones.

El orquestador consolida todos los hallazgos en `docs/<domain>/<TICKET-ID>-code-analysis-summary.md` con checklist de acción (bloqueadores/mayores/menores/testing/cascade) y timeline consolidado. El resultado son cambios locales verificados, listos para abrir PR y entrar al **Workflow 5**.

> **Nota**: el Workflow 3 (Preparación) y el Workflow 4 (Ejecución), en conjunto, cubren el mismo alcance que el antiguo "Workflow 2: Implementación de Tickets" — se dividieron en dos sesiones de trabajo (planificación vs. ejecución) porque tienen expertise, artefactos de entrada/salida y puntos de pausa naturales distintos. El Workflow 6 (`implementar-ticket`) orquesta el Workflow 3 completo y solo la parte de codificación del Workflow 4 (ver más abajo).

---

## Workflow 5: Revisión de PRs

Workflow para revisar y mejorar Pull Requests, con fast-track para cambios triviales (XS).

```mermaid
flowchart TD
    A[revisar-pr] --> B{¿Comentarios?}
    B -->|Sí| C[clasificar-comentarios]
    B -->|No| D{¿Mejoras necesarias?}
    C --> D
    D -->|Sí| E[mejorar-pr]
    D -->|No| F[Ready for merge]

    style A fill:#ffe1e1
    style B fill:#fff4e1
    style C fill:#ffe1e1
    style D fill:#fff4e1
    style E fill:#e1ffe1
    style F fill:#e1ffe1
```

**Fast-track para cambios XS**:

```mermaid
flowchart TD
    A[validar-tarea-trivial] --> B{¿Es trivial?}
    B -->|Sí| C[revisar-cambio-minimo]
    B -->|No| D[revisar-pr]
    C --> E[Ready for merge]

    style A fill:#fff4e1
    style B fill:#fff4e1
    style C fill:#e1ffe1
    style D fill:#ffe1e1
    style E fill:#e1ffe1
```

**Propósito**: Revisión estructurada de PRs con clasificación de comentarios y ciclo de mejora, con fast-track para cambios pequeños.

**Descripción narrativa**: El workflow tiene **dos caminos** según el tamaño del cambio.

**Camino A — Fast-track para cambios XS (triviales)**:

1. **Gate de trivialidad**: `validar-tarea-trivial` determina si el cambio califica para fast-track (<5 archivos, <50 líneas neto, mismo dominio, sin migraciones). Si no califica, deriva al Camino B.

2. **Revisión mínima**: `revisar-cambio-minimo` valida pre-condición, ejecuta checklist rápido (funcionalidad: lógica correcta, no bugs obvios, tests verdes; testing: ≥1 test nuevo, tests existentes pasan; documentación básica: docstring si función pública nueva, comentarios si lógica no obvia; no breaking changes: no removed endpoints/renamed fields/type changes/required fields sin default; security básico: no hardcoded secrets, no SQL injection/XSS/auth bypass) y genera veredicto rápido (approve/minor changes/escalate) con Ready for (merge/needs-minor-fixes/full-review/blocked).

**Camino B — Revisión completa (cambios no triviales)**:

1. **Revisión del PR**: `revisar-pr` carga o genera brief de contexto puntuado (busca `docs/**/<TICKET-ID>-context-brief.md` o ejecuta `context-brief` si falta o puntuación < 9), carga diff completo del PR e hilos de revisión existentes, ejecuta checklist de AC, valida comandos de validación, cita pase de convenciones (≥2 rutas hermanas) y nota efectos de segundo orden, genera brief de revisión `docs/<domain>/<TICKET-ID>-pr-<PR-NUMBER>-review.md` con puntuación del cambio, checklist de AC, hallazgos por severidad, estado de validación, pase de convenciones, efectos de segundo orden, puntuación del brief y Ready for (merge-nits-only/improve/blocked), y genera archivo de comentarios postables `docs/<domain>/<TICKET-ID>-pr-<PR-NUMBER>-review-comments.md`.

2. **Clasificación de comentarios**: si hay comentarios abiertos, `clasificar-comentarios` carga fuentes resueltas, REVIEW-COMMENTS-DOC y PRIOR-TRIAGE-DOC, enumera hilos de revisión abiertos excluyendo resueltos/ya procesados, agrupa comentarios temáticamente, compara patrones con archivos similares citando rutas hermanas para veredictos disagree/partially agree, produce bloques por hilo con veredicto, severidad (blocker/important/nit/out of scope), caso con citas, respuesta propuesta y acción (implement fix/reply and resolve/ask clarifying question/defer), genera clasificación `docs/<domain>/<TICKET-ID>-pr-<PR-NUMBER>-comments-triage.md` con resumen de grupos, convenciones disputadas, bloques por hilo, lista de acciones ordenada, fuera del alcance, puntuación y Ready for (yes/no con blockers).

3. **Mejora del PR**: si la revisión indica mejoras (Ready for = improve), `mejorar-pr` carga ticket y opcionalmente REVIEW-DOC-SLUG, relee AC, lee hallazgos de revisión previa o ejecuta revisión temática completa si falta, puntúa el PR con rúbrica (10: todo AC cumplido, validación dirigida pasa, cero hallazgos; 9: máximo 3 nits; 8: ≥1 important; 7: deuda arquitectura; 5-6: AC parcial/faltante; 1-4: enfoque incorrecto o blocker), aplica correcciones en cambios locales pequeños ordenando hallazgos de blocker a important, coincide con convenciones, cubre regresiones con tests dirigidos, vuelve a puntuar y genera notas de mejora con puntuación inicial/final, correcciones aplicadas, vacíos restantes, nits opcionales, seguimientos y Ready for (local-review/corregir-mas-localmente/blocked).

El resultado es un PR listo para merge con calidad garantizada, cerrando el proceso e2e iniciado en el Workflow 1.

---

## Workflow 6: Implementación End-to-End (Orquestador)

Workflow orquestado (`implementar-ticket`) que automatiza el Workflow 3 completo más la fase de codificación y verificación del Workflow 4, con las mismas ramas de spike/demo/quiz que sus contrapartes manuales.

> **Límite de alcance conocido**: a diferencia del Workflow 4 manual, `implementar-ticket` no encadena automáticamente `actualizar-mapeo-contextos`, `revisar-cambios-locales` ni `revisar-cambios-implementados` tras la verificación. Si se necesita el gate de revisión local y la validación post-implementación completa (por ejemplo, antes de abrir PR sin pasar por la fase de PR), hay que invocar el resto del Workflow 4 manualmente. Este workflow es ideal cuando el usuario quiere implementar un ticket de extremo a extremo con mínima intervención hasta tener el código verificado localmente, no como reemplazo total del Workflow 4.

```mermaid
flowchart TD
    A[implementar-ticket] --> B[revisar-ticket]
    B --> C[generar-brief-contexto]
    C --> D[clasificar-tareas]
    D -->|Ready for: spike| S[construir-spike]
    D -->|Ready for: demo| H[construir-demo]
    D -->|Ready for: planificar-implementacion| E[planificar-implementacion]
    S --> E
    H --> E
    E -->|Ready for: implement| Qz{¿Auth/PHI o dominio desconocido?}
    Qz -->|opcional, si usuario aprueba| QZ[ejecutar-quiz-comprension]
    Qz -->|no aplica / usuario omite| F[implementar-plan]
    QZ --> F
    F --> G[Verificación: lint/typecheck/test]
    G -->|usuario pide PR| PR[commit + PR + revisar-pr + mejorar-pr si menor a 9]
    G -->|si no| END[Fin de fase automatizada]

    style A fill:#e1f5ff
    style B fill:#ffe1e1
    style C fill:#fff4e1
    style D fill:#fff4e1
    style S fill:#fff4e1
    style H fill:#fff4e1
    style E fill:#fff4e1
    style Qz fill:#fff4e1
    style QZ fill:#ffe1e1
    style F fill:#e1ffe1
    style G fill:#ffe1e1
    style PR fill:#e1ffe1
    style END fill:#fff4e1
```

**Propósito**: Orquestador que encadena la preparación (2a) y la ejecución de codificación (parte de 2b) de un ticket automáticamente. Se usa cuando no existe un plan puntuado previo y el usuario quiere avanzar sin invocar cada skill manualmente.

**Descripción narrativa**: Este orquestador resuelve `TICKET-SLUG` y escanea `docs/**/<TICKET-SLUG>-*.md` para detectar artefactos existentes y aplicar resume flags (saltar fases si artefactos ya existen con puntuación ≥9) (Fase 0).

**Fase 1** ejecuta `revisar-ticket`, que genera `docs/<domain>/<TICKET-SLUG>-revisando-ticket.md` con Ready for (`blocked`/`refine`/`generar-brief-contexto`/`clasificar-tareas`/`planificar-implementacion`). En `blocked` o `refine`, el orquestador se detiene y pregunta cómo proceder.

**Fase 2** ejecuta `generar-brief-contexto`, que genera `docs/<domain>/<TICKET-SLUG>-research-brief.md`.

**Fase 3** ejecuta `clasificar-tareas`, que genera `docs/<domain>/<TICKET-SLUG>-ticket-work-triage.md` con Ready for (`blocked`/`resolve-questions`/`spike`/`demo`/`planificar-implementacion`). En `spike`, invoca `construir-spike` y retorna a Fase 4 cuando las notas tengan puntuación ≥9. En `demo`, invoca `construir-demo` y retorna a Fase 4. Esta es la misma rama de investigación que en el Workflow 1 (spike) y el Workflow 3 (spike/demo) — aquí resuelve preguntas de diseño o necesidades de visibilidad de runtime a nivel de tarea, no de producto.

**Fase 4** ejecuta `planificar-implementacion`, que genera `docs/<domain>/<TICKET-ID>-implementation-plan.md` con Ready for (`blocked`/`spike`/`generar-brief-contexto`/`implement`). Antes de Fase 6, ofrece `ejecutar-quiz-comprension` (**Fase 5**, opcional) cuando el ticket toque auth/PHI, dominios desconocidos o flujo de datos complejo; procede solo cuando el usuario aprueba explícitamente omitirlo.

**Fase 6** ejecuta `implementar-plan`, que aplica gates de readiness del plan, carga el plan y confirma working tree limpio, ejecuta la guía paso a paso aplicando cambios locales pequeños con validación dirigida después de cada chunk, genera `docs/<domain>/<TICKET-ID>-implementation-report.md` con Ready for (`blocked`/`fix-locally`/`revisar-cambios-locales`).

**Fase 7** ejecuta verificación con los comandos de `AGENTS.md` (lint, typecheck, test) según lo que cambió, reporta resultados en chat. Si todos los comandos pasan y el usuario no pide PR, el workflow **termina aquí** — no ejecuta automáticamente `actualizar-mapeo-contextos`, `revisar-cambios-locales` ni `revisar-cambios-implementados`.

**Fase 8** (opcional, solo si el usuario pide abrir PR) crea commit y Pull Request, invoca `revisar-pr` y si la puntuación es < 9 invoca `mejorar-pr`.

---

## Módulo Transversal: Comprensión y Enseñanza

A diferencia de los workflows 1-6, este módulo no tiene un lugar fijo en la secuencia: es una **puerta de calidad insertable** antes de implementar o revisar, no una etapa de producción de artefactos con inicio y fin propios de una sesión de codificación o planificación.

```mermaid
flowchart TD
    A[explicar-cambio] --> B[ejecutar-quiz-comprension]

    style A fill:#fff4e1
    style B fill:#ffe1e1
```

**Propósito**: Generar documentos didácticos y validar comprensión mediante quizzes en vivo antes de implementar o revisar.

**Puntos de inserción recomendados**:

- Antes del Workflow 4 / Fase 6 de implementar-ticket, cuando el ticket toca auth/PHI, dominios desconocidos o flujo de datos complejo (ya wireado explícitamente como Fase 5 opcional en el Workflow 6).
- Antes del Workflow 5, cuando quien revisa el PR no participó en el diseño original.
- De forma independiente, para onboarding o discusión de diseño sin que exista todavía un ticket o PR.

**Descripción narrativa**: `explicar-cambio` resuelve `TICKET-ID` desde PR, conversación o archivo de contexto, elige fuente (local + documentación + PR opcional, PR primario, o diff de rama local) (Fase 0), carga fuentes resueltas para objetivo, AC, objetivos excluidos y restricciones de arquitectura, carga diff completo y historial de commits vs base cuando PR o diff local están en alcance (Fase A), construye explicador en orden de historia con secciones: Antecedentes (sistema existente con rutas citadas), Objetivo e intuición, Recorrido narrativo (ordenado con snippets mínimos + prosa + citas de ruta), Efectos de segundo orden (callers, jobs, serializadores, mobile/legacy, auth/PHI, feature flags), Mapeo de criterios de aceptación (checklist vinculado), Quiz de autoevaluación (5+ preguntas + clave de respuestas) (Fase B), puntúa según explainer-rubric, escribe `docs/<dominio>/<TICKET-ID>-explain-change.md` (o variante de PR) con puntuación del explicador, Ready for (planning-implementation/implement-ticket/pr-review/blocked) y Preguntas abiertas (Fase C).

Luego, `ejecutar-quiz-comprension` resuelve fuente del quiz (CONTEXT-DOC, DOC-SOURCE, PR-NUMBER o LOCAL-DIFF) (Fase 0), lee fuente resuelta lo suficiente para calificar respuestas (objetivo, AC, objetivos excluidos, entry points, auth/PHI, modos de fallo, efectos de segundo orden), redacta lista de 5-10 preguntas cubriendo objetivo/objetivos excluidos, flujo de datos principal o entry points, flag crítico o límite de auth/PHI, modo de fallo o edge case, efecto de segundo orden, anota respuesta esperada corta, puntero de evidencia y si prueba tema bloqueante, puntúa set de preguntas según quiz-design-rubric (Fase A), pregunta al humano una pregunta a la vez, califica cada respuesta (correct/partial/miss) citando evidencia, hace pregunta de seguimiento enfocada en partial (máximo 2 seguimientos totales), da pista corta en miss, reprueba puerta en miss de tema bloqueante (límite de auth/PHI, entry point o flujo de datos incorrecto, criterio de aceptación omitido) (Fase B), reporta puntuación del diseño del quiz, preguntas y respuestas calificadas, misses bloqueantes con punteros de re-lectura, resultado de puerta (pass/fail), Ready for (implement/review/neither) y vacíos a cerrar (Fase C).

La salida permanece solo en el chat — ningún archivo durable.

---

## Skills Desconectados / Standalone

Los siguientes skills no forman parte de ningún workflow secuencial — se invocan de forma puntual e independiente:

| Skill              | Propósito                                                                                                                                                       |
|--------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **mapear-dominio** | Genera guía de dominio DDD estratégica autocontenida (subdominios, bounded contexts, mapas de contexto). No es para radares de deuda técnica ni diseño táctico. |
| **revisar-skills** | Evalúa calidad de SKILL.md contra mejores prácticas de diseño de agent skills. Para auditoría de skills, no para crearlos ni ejecutar tests.                    |

> `construir-demo` y `construir-spike` **ya no se listan como standalone**: son ramas de investigación conectadas y documentadas explícitamente en el Workflow 1 (spike ante Conditional Go, demo tras mapear casos de uso), el Workflow 3 (gate de `clasificar-tareas`) y el Workflow 6 (Fase 3). Se siguen pudiendo invocar de forma puntual, pero tienen puntos de entrada definidos en el proceso e2e.

---

## Resumen de Interconexiones

**Skills que actúan como orquestadores**:

- `orquestar-prd-workflow`: orquesta el Workflow 1 completo (Idea → PRD)
- `implementar-ticket`: orquesta el Workflow 3 completo + codificación/verificación del Workflow 4 (ver límite de alcance en Workflow 6)
- `validar-epic-completo`: orquesta validación técnica de epics (Workflow 2)
- `analizar-cambios-codigo`: orquesta análisis liviano de impacto predicho (alternativa a `validar-epic-completo` en Workflow 2)
- `revisar-cambios-implementados`: orquesta análisis de calidad de código con validación de impacto real (Workflow 4)

**Skills que actúan como gates**:

- `validar-viabilidad-producto`: gate de go/no-go de producto antes de invertir en PRD (Workflow 1)
- `revisar-ticket`: gate de calidad de tickets (Workflow 3)
- `clasificar-tareas`: gate de triage que decide entre resolver preguntas, spike, demo o planificar (Workflow 3)
- `validar-tarea-trivial`: gate para determinar pipeline apropiado (Workflow 5)
- `revisar-cambios-locales`: gate antes de crear PR (Workflow 4)
- `revisar-pr`: gate de calidad de PRs (Workflow 5)

**Skills que generan documentación persistente**:

- `generar-prd`, `definir-usuarios`, `mapear-casos-uso` (Workflow 1)
- `generar-trd`, `generar-arquitectura`, `generar-adr`, `generar-estrategia-testing` (Workflow 2)
- `explicar-cambio`, `mapear-dominio` (transversal / standalone)

Los workflows están diseñados para ser modulares y permitir entrada/salida en diferentes puntos según el estado del trabajo, encadenándose en el orden 1 → 2 → 3 → 4 → 5 para cubrir el proceso completo desde la idea hasta el merge. El Workflow 6 es un orquestador opcional que automatiza 3 + parte de 4.
