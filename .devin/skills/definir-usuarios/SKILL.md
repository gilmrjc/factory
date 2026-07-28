---
name: definir-usuarios
description: >-
  Define user personas primarias y secundarias para un requerimiento. Detalla:
  motivaciones, pain points, casos de uso, comportamientos. Salida:
  docs/<domain>/<REQ-SLUG>-personas.md con 2-3 personas completas. Úsalo
  después de validar viabilidad para entender quién usará la feature.
argument-hint: "[REQ-SLUG | VIABILITY-RUTA]"
allowed-tools:
  - read
  - grep
  - find_file_by_name
  - write
triggers:
  - user
  - model
---

# Definidor de Usuarios

Define user personas en detalle: motivaciones, pain points, comportamientos, contexto. Transforma audiencia abstracta en personas concretas.

Solo documentación: no valida, no diseña. Define a quiénes servimos.

## Fase 0 — Resolver entrada

Requerido: `REQ-SLUG` o `VIABILITY-RUTA`.

Infiere desde:
- Ruta: `docs/**/<REQ-SLUG>-viability.md`
- Contenido pegado: si usuario pega validación de viabilidad
- Requerimiento previo: busca archivo más reciente

Pregunta cuando falta: "¿Qué requerimiento? (ruta o slug)"

Declara inputs resueltos: requerimiento, audiencia identificada.

## Fase A — Analizar Audiencia Identificada

Del requerimiento, extrae:
- **Usuarios primarios**: Quién sufre el problema más
- **Usuarios secundarios**: Quién se beneficia indirectamente
- **Actores internos**: Soporte, ventas, product, etc.

Para cada segmento, preguntar:
- ¿Quiénes son específicamente?
- ¿Qué los define? (edad, rol, nivel técnico, etc.)
- ¿Cuántos son aproximadamente?
- ¿Qué motivaciones tienen?

## Fase B — Definir Personas Primarias (2-3 máximo)

Estructura de persona:

```
### Persona 1: [Nombre descriptivo / Rol]

**Datos demográficos**:
- Edad/Rango: [ej: 25-35]
- Rol/Título: [ej: Product Manager, CEO, User]
- Experiencia: [años en rol, nivel técnico]
- Contexto: [dónde trabaja, tamaño empresa, industria]

**Motivación Principal**:
[1 oración clara de qué quieren lograr]

Ejemplo:
"María quiere reducir el tiempo que tarda en descubrir 
oportunidades de engagement para no perder clientes."

**Pain Points (top 3)**:
1. [Problema específico que enfrenta]
2. [Problema específico]
3. [Problema específico]

Ejemplo:
1. No recibe alertas de cambios importantes en su cuenta
2. Chequea manualmente cada mañana (5 min/día, 25 min/semana)
3. Se pierde oportunidades time-sensitive

**Comportamiento Actual**:
- ¿Cómo resuelve el problema hoy? (workaround)
- ¿Con qué herramientas? (existentes)
- ¿Frecuencia de interacción?

Ejemplo:
- Chequea inbox cada 30 min (distracción)
- Usa calendarios/reminders manuales
- Pierde 10-15% de oportunidades

**Necesidad que Resuelve**:
- ¿Cómo cambiaría su trabajo con la feature?
- ¿Cuánto tiempo/dinero ahorraría?
- ¿Nuevo comportamiento positivo?

Ejemplo:
- Recibe alertas instant → reduce tiempo 25 min/semana
- Menos ansiedad (no pierde oportunidades)
- Mejor focus en trabajo importante

**Contexto de Uso**:
- ¿Dónde usa la feature? (web, mobile, email)
- ¿Cuándo? (horario, frecuencia)
- ¿Con qué dispositivos?

Ejemplo:
- Web: durante trabajo (90%)
- Mobile: en camino entre reuniones (5%)
- Email: resumen diario (5%)
```

## Fase C — Definir Personas Secundarias

Para cada persona secundaria, usa template abreviado:

```
### Persona 2: [Nombre/Rol]

**Rol**: [Qué hace]
**Motivación**: [Qué quiere lograr, 1 oración]
**Pain Points**: [Máximo 2-3]
**Conexión con Primaria**: [Cómo se relaciona]

Ejemplo:
**Rol**: Customer Support Agent
**Motivación**: Resolver tickets más rápido sin llamadas repetidas
**Pain Points**: 
- Usuarios no saben su estado (30% de tickets)
- Espera setup manual (15 min por user)
**Conexión**: Si usuarios reciben notificaciones, CS no necesita explicar
```

## Fase D — Mapear Contexto de Producto

Considerar estado del producto:

```
### Contexto: Estado del Producto & Usuarios

**MVP (<1000 users)**:
- Usuarios: Early adopters, tech-savvy
- Comportamiento: Exploración, tolerance alto a bugs
- Canales: In-app primarily, email secondary
- Feedback: Direct interviews, qualitative
- Testing: Surveys + signup metrics (NO A/B tests)

**Growth (1K-10K users)**:
- Usuarios: Early adopters + pragmatists
- Comportamiento: Feature exploration, workflow established
- Canales: Multi-channel (web, mobile, email)
- Feedback: Surveys, telemetría, support tickets
- Testing: A/B landing pages para risky features

**Scale (10K+ users)**:
- Usuarios: Pragmatists + laggards
- Comportamiento: Established workflows, learning curve sensitive
- Canales: Full omnichannel
- Feedback: Analytics, NPS, surveys
- Testing: A/B tests en-app, cohort analysis

**Implicación para Personas**:
Si MVP: personas son tech-early-adopters
Si Growth: personas son mezcla, incluir pragmatists
Si Scale: agregar personas de laggards también
```

## Fase E — Validar Personas

Checklist:
- ✅ ¿Cada persona tiene motivación clara?
- ✅ ¿Pain points son específicos (no genéricos)?
- ✅ ¿Comportamiento actual documentado?
- ✅ ¿Contexto de producto considerado?
- ✅ ¿Primarias vs secundarias diferenciadas?
- ✅ ¿2-3 personas es suficiente (no overcomplicate)?

## Fase F — Escribir Definición de Usuarios

Estructura:

1. **Resumen ejecutivo**: Quiénes son los usuarios, segmentos principales
2. **Estado del producto**: MVP/Growth/Scale, implicaciones
3. **Persona 1 (primaria)**: Completa con contexto
4. **Persona 2 (primaria)**: Completa con contexto
5. **Persona 3 (secundaria, si aplica)**: Abreviada
6. **Diferencias entre personas**: Cómo varían necesidades
7. **Hipótesis de adopción**: ¿Cuál persona adopta primero?
8. **Ready for**: `mapear-casos-uso`

## Salida

Escribe en: `docs/<domain>/<REQ-SLUG>-personas.md`

**Secciones requeridas**:
- Resumen ejecutivo
- Estado del producto y contexto
- Persona 1 (primaria): datos, motivación, pain points, comportamiento, necesidad, contexto
- Persona 2 (primaria): completa
- Persona 3 (secundaria, si existe): abreviada
- Diferencias entre personas
- Hipótesis de adopción (cuál persona adopta primero)
- Ready for (`mapear-casos-uso`, `blocked`)

Ready for valores:
- `mapear-casos-uso`: Personas definidas, proceder a casos de uso
- `blocked`: Personas insuficientemente claras, necesita más research

---

## Ejemplo Completo

```markdown
# Personas: Sistema de Notificaciones

## Estado del Producto
Growth stage (3K activos, creciendo 20%/mes)
→ Personas: Mix de early adopters + pragmatists

## Persona 1: María (Early Adopter)

**Datos demográficos**:
- Edad: 28, Product Manager en SaaS
- Experiencia: 5 años PM, tech-savvy
- Contexto: Startup 50 personas, ágil

**Motivación**:
Maximizar engagement de usuarios para retención y NRR

**Pain Points**:
1. No sabe qué usuarios se están yendo (churn signal bajo)
2. Chequea manualmente cada 30 min (context switching)
3. Pierde oportunidades de re-engage (5-10% más churn)

**Comportamiento Actual**:
- Chequea inbox, chat, analytics constantemente
- Usa calendar reminders manuales
- Escala manualmente a CS cuando detecta issue

**Necesidad**:
Alertas automáticas sobre usuarios inactivos o de riesgo
→ Reducir context switching 30 min/día
→ Proactive retention +5-10%

**Contexto de Uso**:
- Web (desktop): 80% durante trabajo
- Mobile: 10% en transit
- Email digest: 10% revisión noche anterior

---

## Persona 2: João (Pragmatist)

**Datos demográficos**:
- Edad: 42, Head of Customer Success
- Experiencia: 15 años CS, moderate tech
- Contexto: Mid-market, 200+ clientes

**Motivación**:
Eficiencia en soporte sin faltar a SLAs

**Pain Points**:
1. 30% de tickets son questions sobre status (resuelven fácil)
2. Usuario churn porque no conocen features
3. Team sobreextendido (6 agents, 200 clientes)

**Necesidad**:
Usuarios auto-informados mediante notificaciones
→ Reduce tickets 15-20%
→ Team puede focus en complex issues

---

## Diferencias Entre Personas

| Aspecto | María | João |
|---------|-------|------|
| Adopción | Rápida (day 1) | Gradual (semana 1-2) |
| Canales | Push + web | Email mainly |
| Frecuencia | Multiple daily | Daily digest |
| Pain driver | Oportunidad loss | Cost/efficiency |

**Hipótesis adopción**: María adopta primero (early adopter), 
João después (pragmatist) cuando ve reduction en tickets.
```
