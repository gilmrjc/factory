---
name: validar-viabilidad-producto
description: >-
  Valida viabilidad de un requerimiento de producto: alineación con visión,
  demanda real, recursos disponibles, riesgo negocio. Salida:
  docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/product-viability.md con go/no-go. Gate
  de aprobación antes de proceder a definir usuarios. Úsalo para decidir si
  invertir tiempo en PRD o rechazar idea.
---

# Validador de Viabilidad de Producto

Valida si un requerimiento de producto es viable: estrategia, demanda, recursos, riesgo. Gate de go/no-go antes de gastar tiempo en PRD completo.

## Refuerzo de ejecución

- Ejecuta este skill dentro de un subagente por fase. No generes el artefacto final hasta que todos los `PAUSA-CHECK` pendientes se resuelvan.
- Si un `PAUSA-CHECK` da **NO**, ejecuta `PAUSA-ACTIVA`, espera la respuesta del usuario y reinicia el paso.
- Si falta información crítica, detente. No evites la pausa asumiendo.

Solo análisis: no aprueba finalmente. Genera recomendación para stakeholders.

## Fase 0 — Resolver entrada

Requerido: `FUNCIONALIDAD-SLUG` o `REQUIREMENTS-RUTA`.

Infiere desde:
- `FUNCIONALIDAD-SLUG` explícito o `discovery-state.md` `next`: si se invoca desde el flujo de descubrimiento, toma el `FUNCIONALIDAD-SLUG` del frontmatter de `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md`.
- Ruta: `docs/**/initiatives/**/requirements.md`
- Contenido pegado: si usuario pega requerimiento capturado
- Requerimiento previo: busca archivo más reciente de `*-requirements.md`
- Existente: busca `docs/**/initiatives/**/product-viability.md` para reanudar/actualizar una validación previa

Pregunta cuando falta: "¿Qué requerimiento valido? (ruta o `FUNCIONALIDAD-SLUG`)"

**Eco**: presenta al usuario el requerimiento y `assumption-map.md` identificados (funcionalidad, dominio, ruta fuente). Si el usuario corrige, aplica la corrección. Si no responde, avanza a Fase A.

Declara inputs resueltos: requerimiento, restricciones leídas.

## Fase A — Validar Alineación Estratégica

¿Encaja con visión/roadmap de producto?

**Puntos de pausa** (detente y pregunta si ocurre):
- No se puede localizar o inferir la **visión de producto** o el **roadmap** del dominio.
- Hay dos interpretaciones posibles de la alineación estratégica y ninguna es claramente correcta.
- El requerimiento contradice explícitamente una declaración de visión/roadmap conocida.

```
### Criterios de Alineación

1. **Visión de Producto**
   - ¿Esta feature es consistent con dirección de producto?
   - ¿Mueve un norte explícito de la compañía?
   
   Ejemplo Sí: "Retención de usuarios es core de Q3 roadmap"
   Ejemplo No: "Nice-to-have, no en roadmap"

2. **Core vs Nice-to-Have**
   - Core: Resuelve pain point crítico, users pagan por esto
   - Nice-to-have: Feature agradable pero no crítica
   
   Veredicto: ¿En cuál categoría cae?

3. **Oportunidad vs Distracción**
   - ¿Esta feature mantiene foco o lo dispersa?
   - ¿Hay feature más importante compitiendo por recursos?
   
   Análisis: Comparar contra roadmap actual
```

## Fase B — Validar Demanda Real

¿Hay evidencia de que usuarios realmente necesitan esto?

**Puntos de pausa** (detente y pregunta si ocurre):
- No se cuenta con ninguna evidencia de demanda y tampoco se puede inferir del contexto.
- El requerimiento asume una necesidad sin declarar de qué usuarios o en qué magnitud.
- El stage (MVP/Growth/Scale) no está claro y esto cambiaría el tipo de evidencia mínima requerida.

```
### Validación de Demanda

**Para MVP o Early Stage** (< 1000 usuarios, < 3 meses):
- Sí: Feedback directo de usuarios (mínimo 5-10)
- Sí: Support tickets mencionando este problema
- Sí: Churn analysis (¿causa de abandono?)
- Sí: User interviews (cualitativo)
- No: NO usar: A/B tests (muestra muy pequeña), Surveys (sesgadas)

**Para Growth Stage** (1K-10K usuarios, 3-12 meses):
- Sí: Support tickets + trending
- Sí: Surveys con mínimo 50 respuestas
- Sí: Telemetría (users clicking "request feature"?)
- Sí: NPS/CSAT comments mencionando pain point
- Parcial: A/B test landing page si es risky

**Para Scale** (10K+ usuarios, 1+ años):
- Sí: A/B tests con landing page
- Sí: Cohort analysis (retención impact)
- Sí: Surveys con 100+ respuestas
- Sí: Competitive analysis (market size)

**Matriz: Estado × Validación**

| Estado | Mínimo Evidencia | Deseable |
|--------|-----------------|----------|
| MVP | 5+ user interviews | + Support tickets |
| Growth | Support tickets + 50 surveys | + Telemetría |
| Scale | A/B landing page | + Cohort analysis |
```

## Fase C — Validar Recursos

¿Tenemos recursos para hacerlo bien?

**Puntos de pausa** (detente y pregunta si ocurre):
- No se puede inferir la disponibilidad del **equipo** o del **Product Owner**.
- El requerimiento implica un **nuevo tech stack** o **licencias** sin aprobación conocida.
- Hay una **dependencia crítica** de otro equipo, sistema o proveedor externo que no se ha validado.

```
### Checklist de Recursos

**Equipo**:
- Backend devs: ¿Cantidad? ¿Disponibilidad?
- Frontend devs: ¿Cantidad? ¿Disponibilidad?
- QA: ¿Existe? ¿Puede hacer testing?
- Product: ¿Owner asignado? ¿Tiempo disponible?

**Tiempo**:
- Estimación inicial: [Pedir a architects]
- Timeline requerido: [De requerimiento]
- Buffer: ¿Hay margen? (típico: +30%)
- Competencia: ¿Hay features más importantes?

**Infraestructura**:
- ¿Necesita new tech stack? (aprobado?)
- ¿Integración con sistemas existentes? (documentado?)
- ¿Cambios de DB schema? (reversible?)

**Veredicto**:
- Sí: Recursos suficientes
- Parcial: Resources tight (factible pero riesgoso)
- No: Recursos insuficientes (rechazar o postpone)
```

## Fase D — Validar Riesgo de Negocio

¿Cuál es el downside si falla?

**Puntos de pausa** (detente y pregunta si ocurre):
- Hay un riesgo de **regulatory, compliance o legal** que no se puede evaluar sin input experto.
- El riesgo de **adopción** o **competencia** es alto y no se cuenta con mitigación documentada.
- Hay un riesgo técnico que depende de decisiones de arquitectura que aún no se han tomado.

```
### Matriz de Riesgo

| Riesgo | Probabilidad | Impacto | Mitigación |
|--------|--------------|---------|-----------|
| **Technical risk** | | | |
| New tech unknown | Media | Medio | Spike técnico |
| Legacy code complexity | Alta | Bajo | Refactor previo |
| Integration failure | Baja | Alto | Integration tests |
| **Business risk** | | | |
| User adoption < 20% | Media | Medio | Start with MVP |
| Competitor ships first | Baja | Alto | Acelerar timeline |
| Regulatory compliance | Baja | Crítico | Legal review |
| **Opportunity risk** | | | |
| Feature becomes irrelevant | Baja | Crítico | User validation |
| Market shift | Baja | Alto | Monitor trends |

**Veredicto**: Riesgo total = ¿Aceptable para compañía?
- Sí: Riesgo bajo/manejable
- Parcial: Riesgo medio (proceder con caution)
- No: Riesgo alto (reconsiderar)
```

## Fase E — Generar Veredicto

```
### Go/No-Go Decision Matrix

| Criterio | Status | Weight |
|----------|--------|--------|
| Alineación estratégica | Sí: Aligned | 25% |
| Validación demanda | Sí: Validated (5+ users) | 25% |
| Recursos disponibles | Sí: Suficientes | 25% |
| Riesgo manejable | Sí: Low-Medium | 25% |

**SCORE**: 100% → GO
**Veredicto**: Proceder a definir usuarios

---

**CASO 2: Partial Go**

| Criterio | Status | Weight |
|----------|--------|--------|
| Alineación estratégica | Sí: Aligned | 25% |
| Validación demanda | Parcial: Weak (2 users) | 25% |
| Recursos disponibles | Parcial: Tight (backend only 50%) | 25% |
| Riesgo manejable | Parcial: Medium | 25% |

**SCORE**: 75% → CONDITIONAL GO
**Veredicto**: Proceder CON:
- Spike técnico (2 semanas)
- Validación adicional (5+ more user interviews)
- Recursos confirmados

---

**CASO 3: No-Go**

| Criterio | Status | Weight |
|----------|--------|--------|
| Alineación estratégica | No: Off-roadmap | 25% |
| Validación demanda | No: No evidence | 25% |
| Recursos disponibles | No: Team fully committed | 25% |
| Riesgo manejable | No: High regulatory risk | 25% |

**SCORE**: 0% → NO-GO
**Veredicto**: Rechazar o Postpone
**Razones**: Off-roadmap, validación débil, recursos no disponibles
```

## Fase F — Escribir Validación y actualizar `discovery-state.md`

Estructura del documento:

1. **Resumen ejecutivo**: Go/No-Go + rationale
2. **Alineación Estratégica**: ¿Encaja con visión?
3. **Validación de Demanda Real**: Evidencia nivel-apropiada
4. **Disponibilidad de Recursos**: Equipo, tiempo, tech
5. **Análisis de Riesgo**: Técnico, negocio, oportunidad
6. **Veredicto final**: Go/Conditional Go/No-Go
7. **Condiciones (si Conditional)**: Qué debe resolverse
8. **Ready for**: `definir-usuarios` o `blocked` (con ruta relativa del siguiente artefacto)

**Actualización de `discovery-state.md`**: después de escribir el artefacto, si existe `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md`:
- Marca el ítem del `FUNCIONALIDAD-SLUG` según el veredicto:
  - `Go` → `estado: viabilidad-go`, `veredicto: Go`, `ready-for: orquestar-diseno-prd`
  - `Conditional Go` → `estado: viabilidad-conditional-go`, `veredicto: Conditional Go`, `ready-for: <spike|validar-viabilidad-producto>`
  - `No-Go` → `estado: viabilidad-no-go`, `veredicto: No-Go`, `ready-for: workflow-complete`
- Añade la ruta a `product-viability.md`.
- Determina el siguiente `FUNCIONALIDAD-SLUG` pendiente y actualiza `next`. Si no quedan pendientes, fija `next` según el resumen global (p.ej. `orquestar-diseno-prd` si hay al menos un `Go`, `workflow-complete` si todos son `No-Go`, `needs-review` si hay `Conditional Go` con riesgo ejecutivo).

## Salida

Escribe en: `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/product-viability.md`

**Header requerido** (al inicio del documento):
- idea_slug: <IDEA-SLUG>
- funcionalidad_slug: <FUNCIONALIDAD-SLUG>
- Req slug
- Dominio
- Fecha
- Skill: validar-viabilidad-producto
- Input: ruta del artefacto fuente (requirements.md)
- Stage (MVP/Growth/Scale, cuando aplique)
- status: ready | conditional | blocked
- next: <orquestar-diseno-prd | validar-viabilidad-producto | spike | workflow-complete | needs-review | blocked>

**Secciones requeridas**:
- Header requerido
- 1. Resumen ejecutivo (Go/No-Go)
- 2. Alineación Estratégica
- 3. Validación de Demanda Real (estado-apropiada)
- 4. Disponibilidad de Recursos
- 5. Matriz de Riesgo
- 6. Veredicto Final (con score)
- 7. Condiciones si Conditional Go
- Autoevaluación (checklist de validación)
- Ready for (`definir-usuarios`, `blocked`, `spike`)

**Autoevaluación (checklist de validación)**:
- [ ] Alineación estratégica evaluada contra visión/roadmap explícito
- [ ] Demanda validada con evidencia apropiada al stage (MVP/Growth/Scale)
- [ ] Recursos (equipo, tiempo, infraestructura) verificados
- [ ] Riesgos técnicos, de negocio y de oportunidad mapeados
- [ ] Score calculado y veredicto (Go/Conditional Go/No-Go) justificado
- [ ] Condiciones de Conditional Go listadas y accionables
- [ ] Ready for definido correctamente
- [ ] Documento de salida accionable para stakeholders

Ready for valores:
- `definir-usuarios`: Go approved, proceder a definir personas
- `blocked`: No-Go o Conditional Go con condiciones críticas no resueltas
- `spike`: Conditional Go, necesita spike técnico primero

En la sección Ready for, incluye la ruta relativa del siguiente artefacto esperado (ej: `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/personas-mapping.md`).

---

## Nota Importante

**Este es un gate binario**:
- Sí: Go: Procede a PRD (invierte tiempo)
- No: No-Go: Rechaza idea sin gastar recursos
- Parcial: Conditional Go: Resuelve condiciones, luego decide

**Objetivo**: Filtrar ideas temprano, evitar PRDs de features que no deberían hacerse.
