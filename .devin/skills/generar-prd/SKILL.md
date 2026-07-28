---
name: generar-prd
description: >-
  Genera PRD formal consolidando: visión, personas, casos de uso, requisitos
  funcionales, no-funcionales, y CRITERIOS EXPERIMENTALES. Salida:
  docs/<domain>/<REQ-SLUG>-prd.md con PRD completo. Criterios experimentales
  son estado-específicos (MVP: signups+surveys, Growth: A/B landing, Scale: A/B
  in-app). Úsalo después de mapear casos para generar PRD listo para
  planificación arquitectónica.
argument-hint: "[REQ-SLUG | USE-CASES-RUTA]"
allowed-tools:
  - read
  - grep
  - find_file_by_name
  - write
triggers:
  - user
  - model
---

# Generador de PRD

Genera PRD formal consolidando: requerimientos capturados, personas, casos de uso, requisitos técnicos, y CRITERIOS EXPERIMENTALES contextualizados al estado del producto.

Solo documentación: no aprueba. Genera documento formal.

## Fase 0 — Resolver entrada

Requerido: `REQ-SLUG` o `USE-CASES-RUTA`.

Infiere desde:
- Ruta: `docs/**/<REQ-SLUG>-use-cases.md`
- Contenido pegado: si usuario pega casos de uso
- Previo: busca archivo más reciente de `*-use-cases.md`

Pregunta cuando falta: "¿Qué requerimiento? (ruta o slug)"

Declara inputs resueltos: requerimiento, casos de uso leídos.

## Fase A — Consolidar Visión

Toma del requerimiento y viabilidad:
- Problema de negocio
- Solución propuesta
- Personas afectadas
- Restricciones y timeline

## Fase B — Consolidar Requisitos Funcionales

De casos de uso, extrae:
- **Happy paths**: Workflows principales de cada persona
- **Alternative paths**: Variaciones importantes
- **Edge cases**: Manejo de errores, estados especiales
- **Precondiciones/Postcondiciones**: Estado antes y después

Estructura:
```
### Requisitos Funcionales

**RF-1: Alert Management**
- Sistema debe detectar user inactividad (>7 days)
- Sistema debe generar alerts para personas autorizadas
- Sistema debe respetar user notification preferences
- Sistema debe batching si >1 alert per hour
- Usuarios pueden snooze, dismiss, o action alerts

**RF-2: Re-engagement Flow**
- Sistema debe enviar automated email para inactivos
- Sistema debe track clicks e re-engagement
- CS puede manually trigger re-engage flows
- Metrics visible en dashboard

**RF-3: User Preferences**
- Users controlan notification channels (email, push, in-app)
- Users controlan frequency (immediate, daily digest)
- Users pueden opt-out completamente
```

## Fase C — Consolidar Requisitos No-Funcionales

```
### Requisitos No-Funcionales

**Performance**:
- Alert delivery: < 5 min latency
- Dashboard load: < 2 sec
- Re-engagement email: sent within 1 hour of action

**Reliability**:
- System uptime: 99.5%
- Notification delivery reliability: 99%
- Graceful degradation if notification service down

**Scalability**:
- Handle 10K+ concurrent alerts
- Handle 1M+ notifications per day
- Database: < 100ms query at peak

**Security**:
- User notification preferences encrypted
- No PII in audit logs
- Webhook signature verification

**Compliance**:
- GDPR: users can request deletion of notifications
- SOC2: audit logs of all alert actions
```

## Fase D — Definir Criterios Experimentales (CRÍTICO)

**Los criterios deben ser apropiados al estado del producto:**

```
### Criterios Experimentales (ESTADO-ESPECÍFICOS)

## IF MVP (<1000 users, <3 months)

**Métrica de Éxito Primary**:
- Sign-ups de usuarios que solicitan notificaciones: >60%
- Razón: Early adopters indicarán si feature is desirable

**Validación Secundaria**:
- User surveys (5+ users): "Does this solve your problem?"
- In-app usage: Users activando feature within first week
- NO: A/B tests (muestra muy pequeña, falta data)

**Success Threshold**:
- >60% signup opt-in = Feature is desirable
- >70% of opted-in using weekly = Feature is usable
- Negative feedback on 0-1 critical issues = Feature OK

**Timeline**: 2 weeks de observación post-launch

---

## ELIF Growth (1K-10K users, 3-12 months)

**Métrica de Éxito Primary**:
- A/B test landing page: Feature describe vs control
- Conversion rate: users enabling notifications
- Success: >25% conversion rate (p < 0.05)

**Validación Secundaria**:
- Retention increase: users with alerts > users without
- Support tickets reduction: <15% decrease acceptable
- User surveys: 50+ responses on usability

**Experimental Design**:
- Landing page A/B test (2 weeks)
- Cohort retention analysis (4 weeks)
- Surveys (concurrent)

**Success Threshold**:
- >25% conversion in A/B test
- Retention uplift >5% vs control
- No critical UX issues in surveys

**Timeline**: 4-6 weeks

---

## ELSE Scale (10K+ users, 1+ years)

**Métrica de Éxito Primary**:
- In-app A/B test: alerts enabled vs disabled
- Measure: user engagement, retention, NPS
- Success: retention uplift >3%, NPS neutral or positive

**Validación Secundaria**:
- Cohort analysis: age, geography, persona
- Business impact: LTV increase if retention up
- CS impact: ticket reduction (if measurable)

**Experimental Design**:
- In-app holdout: 10% control, 90% treatment
- Duration: 4 weeks minimum
- Segmented by: persona, region, cohort

**Success Threshold**:
- Retention uplift >3% (statistically significant)
- NPS no degradation
- <5% increase in support tickets (if any)

**Timeline**: 4 weeks

---

## GENERAL: Fallback if State Unknown

Usar MVP criteria (conservative). Upgrade después si growth evident.

```

## Fase E — Mapear Métricas de Éxito

```
### Métricas de Éxito (Estado-Específicas)

**North Star Metric** (estado-dependent):
- MVP: Feature adoption (% enabling)
- Growth: Retention lift from feature
- Scale: LTV impact + engagement lift

**Supporting Metrics**:
- Engagement: alerts delivered, actions taken, time-to-action
- Retention: churn reduction in alert-enabled cohort
- Satisfaction: NPS, CSAT for feature
- Technical: latency, reliability, error rates

**Observacion Strategy**:
- MVP: Manual surveys + in-app tracking
- Growth: Telemetría + survey + A/B landing
- Scale: Full cohort analysis + in-app A/B

**Evaluation Timeline** (estado-dependent):
- MVP: 2 weeks post-launch
- Growth: 4-6 weeks (A/B test duration)
- Scale: 4 weeks minimum in-app test
```

## Fase F — Definir Go/No-Go Criteria

```
### Go/No-Go Decision Criteria

**Go Criteria**:
- (MVP) >60% adoption, no critical issues
- (Growth) >25% A/B conversion, retention neutral/positive
- (Scale) >3% retention uplift, NPS no degradation

**No-Go Criteria**:
- (MVP) <30% adoption after 2 weeks
- (Growth) <15% A/B conversion
- (Scale) >5% retention decrease or >10 NPS drop

**Conditional Go**:
- If partially successful but unclear, extend test
- OR pivot: change alert cadence, channels, targeting
- Then re-evaluate in 2 weeks
```

## Fase G — Escribir PRD Formal

Estructura completa:

1. **Executive Summary**: Qué se construye, por qué, metrics de éxito
2. **Problem Statement**: El problema de negocio
3. **Personas**: Quiénes son los usuarios, motivaciones
4. **Use Cases**: Workflows principales y alternativas
5. **Requisitos Funcionales**: Feature-by-feature
6. **Requisitos No-Funcionales**: Performance, security, compliance
7. **Requisitos Experimentales** (ESTADO-ESPECÍFICOS): 
   - Métrica primaria de éxito
   - Validación secundaria
   - Criterios go/no-go
   - Timeline de evaluación
8. **Out of Scope**: Qué NO se hace
9. **Timeline**: Fechas principales
10. **Recursos**: Equipo asignado
11. **Riesgos y Mitigaciones**: Qué puede salir mal
12. **Sign-off**: Aprobaciones necesarias

## Salida

Escribe en: `docs/<domain>/<REQ-SLUG>-prd.md`

**Secciones requeridas**:
- Executive Summary (1 pág)
- Problem Statement
- Personas y use cases (ref a documentos previos)
- Requisitos Funcionales (numbered)
- Requisitos No-Funcionales
- **Requisitos Experimentales (CRITICAL)**: Estado-específicos con métricas, criterios, timeline
- Metrics de éxito (con thresholds)
- Go/No-Go decision criteria
- Out of Scope
- Timeline
- Recursos
- Riesgos
- Sign-off
- Ready for: `planificar-desde-prd` (architecture planning)

Ready for valores:
- `planificar-desde-prd`: PRD aprobado, proceder a planificación arquitectónica
- `needs-review`: PRD completo pero necesita sign-off ejecutivo
- `blocked`: Criterios experimentales insuficientes, aclarar primero

---

## Nota Crítica: Criterios Experimentales

**El PRD debe ser específico al ESTADO del producto:**

```
Estado del Producto → Criterios Experimentales Apropiados

MVP (Desembarco inicial)
└─ ¿Quieren esto? → Signups + Surveys (cualitativo)
   └─ NO: A/B tests (muestra: 100 users, varianza: 50%+, invalida)

Growth (Validación de mercado)
└─ ¿Cómo responden? → A/B landing pages + Surveys
   └─ Cohort analysis (retención, engagement)
   └─ A/B in-app cuando estés listo

Scale (Optimización)
└─ ¿Maximizar impacto? → A/B in-app + Cohort analysis
   └─ Full statistical rigor (p < 0.05, N sufficiently large)
   └─ Multi-variate testing si múltiples variables

**Si estado unknown**: Usar MVP criteria (conservative)
```

**Evita estos errores**:
- ❌ A/B test en MVP (muestra insuficiente)
- ❌ Surveys solo en Scale (ineficiente, muestra sesgada)
- ❌ Criterios no-específicos ("users love it" - indefinido)
- ❌ Timeline de evaluación irreal (A/B test 1 semana = insuficiente)
