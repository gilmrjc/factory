---
name: mapear-casos-uso
description: >-
  Mapea casos de uso concretos para cada persona. Define: happy path, alternativa
  paths, edge cases, precondiciones y postcondiciones. Salida:
  docs/<domain>/<REQ-SLUG>-use-cases.md con matriz de casos y flujos.
  Úsalo después de definir usuarios para entender workflows específicos.
argument-hint: "[REQ-SLUG | PERSONAS-RUTA]"
allowed-tools:
  - read
  - grep
  - find_file_by_name
  - write
triggers:
  - user
  - model
---

# Mapeador de Casos de Uso

Mapea casos de uso concretos para cada persona. Define flujos: happy path, alternativas, edge cases. Transforma personas en workflows específicos.

Solo documentación: no diseña, no decide. Mapea usos reales.

## Fase 0 — Resolver entrada

Requerido: `REQ-SLUG` o `PERSONAS-RUTA`.

Infiere desde:
- Ruta: `docs/**/<REQ-SLUG>-personas.md`
- Contenido pegado: si usuario pega definición de personas
- Previo: busca archivo más reciente de `*-personas.md`

Pregunta cuando falta: "¿Qué requerimiento? (ruta o slug)"

Declara inputs resueltos: requerimiento, personas leídas.

## Fase A — Analizar Personas y Pain Points

Para cada persona primaria, preguntar:
- ¿Qué tareas principales hace hoy? (workflow actual)
- ¿Dónde ocurren fricción/pain points?
- ¿Cómo la feature resolvería el workflow?

## Fase B — Mapear Happy Path por Persona

Happy path = camino ideal, sin errores.

```
### Persona: María - Happy Path

**Trigger**: Usuario inactivo por 7+ días sin engagarse

**Precondiciones**:
- Sistema detectó inactividad (telemetría configured)
- Notificación rule activa para "inactive user"
- User preferencias allow push notifications

**Paso a Paso**:
1. Sistema detecta María no logeó en 7 días
2. Sistema chequea user engagement metrics
3. Sistema genera alert: "User at risk: João inactivo"
4. Push notification enviado a María's phone: "1 user inactive - revisit"
5. María ve notificación, tap → app abre user dashboard
6. María ve João inactivo, cliquea "send re-engage email"
7. Sistema envia email a João con oportunidades
8. (Days later) João loguea, re-engages
9. Sistema marques María's alert como "resolved"

**Postcondiciones**:
- Alert resuelto
- João re-engaged (métrica tracks)
- María sabe qué pasó

**Metrics**:
- Time-to-notification: < 5 min
- Time-to-action: < 30 min
- Re-engagement rate: > 30%
```

## Fase C — Mapear Paths Alternativos

Variaciones del happy path:

```
### Persona: María - Alternative Paths

**Path 1: Notification preferences**
- María recibe notificación pero prefer email
- Sistema respeta preferencia, envia email instead
- Result: Same outcome, different channel

**Path 2: Alert fatigue**
- María recibe 3 alerts en 1 hora (too many)
- Sistema batches next 3 alerts into 1 digest
- Result: María no overwhelmed

**Path 3: Already engaged**
- Alert says "User at risk" pero user just logged in
- System fetches latest data
- Result: Alert auto-resolves, María no notified (false positive avoided)

**Path 4: Manual snooze**
- María vé alert pero not ready to action
- Clicks "snooze 1 day"
- Result: Alert reappears tomorrow

Mapeo:
| Caso | Trigger | Resultado | Probabilidad |
|------|---------|-----------|--------------|
| Happy | Detects + notifies + acts | Re-engaged | 60% |
| Alt 1 | Prefers email | Email sent | 20% |
| Alt 2 | Multiple alerts | Batched | 10% |
| Alt 3 | Already engaged | Dismissed auto | 5% |
| Alt 4 | Snoozed | Reappears later | 15% |
```

## Fase D — Mapear Edge Cases y Error Paths

Qué pasa cuando algo sale mal:

```
### Edge Cases / Error Paths

**Edge 1: User deleted**
- Precondición: Alert triggered para deleted user
- Resultado: Alert safely skipped, no error
- Handling: Check user existence before sending

**Edge 2: Notification service down**
- Precondición: Push notification fails
- Resultado: Fallback to email or in-app bell
- Handling: Retry logic + alternative channel

**Edge 3: Data stale**
- Precondición: Metrics data 24h old
- Resultado: Alert might be inaccurate
- Handling: Refresh data before alert, o marcar como "last checked"

**Edge 4: Alert storm**
- Precondición: 100 users inactivo simultaneously
- Resultado: System overload
- Handling: Queue alerts, distribute over time

**Edge 5: User unsubscribed**
- Precondición: User turned off all notifications
- Resultado: Alert respects preference, not sent
- Handling: Check subscription status before sending
```

## Fase E — Mapear Casos de Uso de Actores Secundarios

Si aplica (CS, Support, etc.):

```
### Persona: João (CS Agent) - Happy Path

**Trigger**: Customer about to churn

**Precondición**:
- CS agent reviewing dashboard
- Notification bell shows "User X at risk: inactive 14 days"

**Paso a Paso**:
1. João ve notification of at-risk user
2. João clicks para ver details
3. João reviews user's engagement history
4. João clicks "send automated re-engage flow" or "schedule call"
5. System respects choice, actúa
6. João marks alert as "in progress" or "resolved"

**Postcondiciones**:
- User either re-engaged or churned (known)
- CS focus on other priorities
```

## Fase F — Crear Matriz de Casos de Uso

Tabla consolidada:

```
## Matriz de Casos de Uso

| ID | Persona | Trigger | Precondiciones | Happy Path | Edge Cases | Éxito? |
|----|---------|---------|----------------|-----------|-----------|--------|
| UC1 | María | Inactividad 7d | Telemetry OK | Alert→Action→Reeng | Stale data, deleted user | 60%+ |
| UC2 | María | Multiple alerts | >3 in 1h | Batch digest | Rate limiting OK | 50%+ |
| UC3 | João | At-risk user | Dashboard open | View→Action→Track | User churned before action | 40%+ |
| UC4 | Admin | Monitor health | Dashboard | See alerts statistics | System down | N/A |

**Criterio de éxito**: ¿Qué métrica determina si use case is working?
- UC1: 30%+ re-engagement rate
- UC2: User satisfaction (not overwhelmed)
- UC3: CS efficiency (tickets reduced 15%)
```

## Fase G — Escribir Mapeo de Casos de Uso

Estructura:

1. **Resumen ejecutivo**: # casos, personas cubiertas
2. **Happy path por persona**: Flujo ideal paso a paso
3. **Alternative paths**: Variaciones comunes
4. **Edge cases y errores**: Qué pasa si algo falla
5. **Actores secundarios**: CS, Support, Admin si aplica
6. **Matriz de casos**: Tabla consolidada con success metrics
7. **Completitud**: ¿Todos los workflows cubiertos?
8. **Ready for**: `generar-prd`

## Salida

Escribe en: `docs/<domain>/<REQ-SLUG>-use-cases.md`

**Secciones requeridas**:
- Resumen ejecutivo
- Happy path por cada persona primaria (paso a paso)
- Alternative paths (por persona)
- Edge cases y error handling
- Actores secundarios (si aplica)
- Matriz de casos de uso (tabla con success metrics)
- Completitud check
- Ready for (`generar-prd`, `blocked`)

Ready for valores:
- `generar-prd`: Casos de uso mapeados, proceder a PRD
- `blocked`: Workflows no claros o incompletos, aclarar primero

---

## Ejemplo Completo: Sistema Notificaciones

```markdown
# Use Cases: Sistema de Notificaciones

## UC1: María Receives Alert (Happy Path)

**Precondiciones**:
- User inactividad detector activo
- María permitió push notifications
- Sistema tiene datos de engagament

**Flujo**:
1. Sistema detecta user inactivo 7+ days
2. Alert rule triggered: "inactive_user_7d"
3. Notificación envia a María's device: "User João inactivo - revisit"
4. María tap notificación
5. App abre user detail page para João
6. María ve: "Last login: 7 days ago", engagement score: low
7. María clicks "send re-engage flow"
8. Sistema envia automated email a João
9. Sistema track: alert marked as "actioned"

**Postcondiciones**:
- Alert resolved (manual action)
- Email sent to user
- María informed

**Success Metric**: 30%+ users re-engaged within 7 days

---

## UC2: Alert Batching (Alternative Path)

**Trigger**: María receives 5 inactivity alerts in 1 hour

**Precondiciones**: Alert batching rule: "max 1 alert per hour"

**Flujo**:
1. Sistema detecta 5 inactivity alerts queued
2. Sistema batches: "5 users inactivo today - need attention?"
3. Notificación enviada (1 alert instead of 5)
4. María decides how many to action

**Success Metric**: User satisfaction (not overwhelmed)

---

## Edge Case: User Already Re-engaged

**Trigger**: Alert says "inactivo" pero user just logged in

**Precondiciones**: Alert queued but data stale (2h old)

**Handling**:
1. Before sending alert, check current user status
2. If user logged in recently, skip alert
3. Result: False positive avoided

**Success Metric**: 0% false positive alerts
```
