---
name: validar-scope-xs
description: >-
  Valida si un cambio es realmente XS (extra small) calificando para fast-track.
  Criterios: <5 archivos, <50 líneas neto, mismo dominio, sin migraciones, sin
  dependencias de features. Salida: `ready-for-fast-track` o `full-pipeline`.
  Úsalo al inicio de cualquier tarea para determinar pipeline apropiado.
argument-hint: "[TICKET-ID | DIFF]"
allowed-tools:
  - read
  - grep
  - find_file_by_name
  - bash
triggers:
  - user
  - model
---

# Validador de Scope XS

Valida si un cambio es realmente extra-small (XS) para fast-track workflow. Aplica criterios objetivos.

Solo análisis: no modifica código. Determina pipeline.

## Fase 0 — Resolver entrada

Requerido: `TICKET-ID` o `DIFF`.

Infiere desde:
- Ticket ID: busca plan de implementación `docs/**/<TICKET-ID>-implementation-plan.md`
- Rama local: `git diff origin/main...HEAD` para ver cambios
- Contenido pegado: si el usuario pega el plan

Pregunta cuando falta: "¿Qué cambio valido? (ticket ID o rama local)"

Declara inputs resueltos: ticket, cambios encontrados.

## Fase A — Calcular Métricas Objetivas

Para el diff actual, calcula:

```
### Métricas de Scope

| Métrica | Valor | Límite XS | Status |
|---|---|---|---|
| Archivos modificados | 3 | <5 | ✅ OK |
| Líneas neto (+ - comentarios) | 42 | <50 | ✅ OK |
| Líneas comentario | 0 | <20 | ✅ OK |
| Cambios de tipo diferente | 1 | <=1 | ✅ OK |
| Nuevas dependencias | 0 | 0 | ✅ OK |
| Tests modificados | 1 | >=1 | ✅ OK |

**Score XS**: 6/6 criterios ✅ → PASS
```

## Fase B — Aplicar Criterios XS

Cada criterio:

```
### Criterio 1: Archivos Modificados

**Límite**: < 5 archivos
**Razón**: Menos archivos = menos cambios de contexto para revisor

**Evaluación**:
- src/services/payment.py (modificado)
- tests/services/test_payment.py (modificado)
- Total: 2 archivos ✅

**Si falla**: 7 archivos → No es XS
```

```
### Criterio 2: Líneas Neto

**Límite**: < 50 líneas de código (sin comentarios)
**Razón**: Rápido de entender, bajo riesgo

**Evaluación**:
- Adiciones: 35 líneas
- Deletions: 5 líneas
- Neto: +30 líneas ✅

**Si falla**: +200 líneas → No es XS
```

```
### Criterio 3: Mismo Dominio/Contexto

**Límite**: Cambios en 1 bounded context máximo
**Razón**: Evita acoplamiento entre dominios

**Evaluación**:
- Cambios en: Payment service (1 BC)
- No toca: User, Auth, Notifications
- ✅ OK

**Si falla**: Modifica Payment + Auth + User → No es XS (múltiples contextos)
```

```
### Criterio 4: Sin Migraciones de DB

**Límite**: Sin cambios de schema
**Razón**: Migraciones requieren deploy coordinado

**Evaluación**:
- Schema changes: None
- Migration files: None
- ✅ OK

**Si falla**: Agrega columna required a tabla grande → No es XS
```

```
### Criterio 5: Sin Dependencias de Features

**Límite**: No requiere cambios en otros sistemas
**Razón**: Cambio aislado, independiente

**Evaluación**:
- Requiere cambios en: None
- Puede deployar solo: Yes
- ✅ OK

**Si falla**: Requiere Web Frontend update → No es XS (no independiente)
```

```
### Criterio 6: Tests Incluidos

**Límite**: >= 1 test case cubierto
**Razón**: Validación básica del cambio

**Evaluación**:
- Tests agregados: 3
- Coverage: 90%
- ✅ OK

**Si falla**: Sin nuevos tests → No es XS (validación insuficiente)
```

## Fase C — Scoring Flexibilidad

Si apenas falla 1-2 criterios, aplica scoring de "casi XS":

```
### Near-XS Cases

**Caso 1**: 6 archivos (límite 5)
- Exceso: +1 archivo
- Impacto: Menor
- Veredicto: MAYBE → Usa criterio de juicio

**Caso 2**: 75 líneas neto (límite 50)
- Exceso: +25 líneas
- Impacto: Moderado
- Veredicto: NO (exceso 50% sobre límite)

**Caso 3**: 2 bounded contexts (límite 1)
- Exceso: +1 BC
- Impacto: Alto (acoplamiento)
- Veredicto: NO definitivo
```

## Fase D — Generar Veredicto

```
### Veredicto: Fast-Track Eligible?

**Opción 1**: XS APPROVED (todos criterios pass)
→ Pipeline: Fast-track (3-4 horas max)
→ Steps: Code → Tests → Quick review → Merge

**Opción 2**: XS BORDERLINE (1-2 criterios near-fail)
→ Pipeline: Standard (user choice)
→ Recomendación: Usar standard para caution

**Opción 3**: XS REJECTED (multiple criterios fail)
→ Pipeline: Full pipeline (7+ pasos)
→ Razón: [Listar criterios que fallaron]
```

## Fase E — Escribir Validación de Scope

Estructura:

1. **Resumen**: ¿Es XS? Veredicto.
2. **Métricas objetivas**: Tabla de valores vs límites
3. **Criterio 1 (Archivos)**: Pass/fail con razón
4. **Criterio 2 (Líneas)**: Pass/fail con razón
5. **Criterio 3 (Dominio)**: Pass/fail con razón
6. **Criterio 4 (Migraciones)**: Pass/fail con razón
7. **Criterio 5 (Dependencias)**: Pass/fail con razón
8. **Criterio 6 (Tests)**: Pass/fail con razón
9. **Scoring final**: XS / Borderline / Full pipeline
10. **Recomendación**: Qué pipeline usar
11. **Ready for**: `fast-track` o `full-pipeline`

## Salida

Escribe en: `docs/<domain>/<TICKET-ID>-xs-validation.md` (o salida en chat)

**Secciones requeridas**:
- Resumen ejecutivo (¿Es XS?)
- Métricas objetivas (tabla)
- Criterio por criterio (Pass/Fail con razón)
- Scoring final
- Recomendación de pipeline
- Ready for (`fast-track`, `full-pipeline`, `borderline`)

Ready for valores:
- `fast-track`: All criterios pass, use 3-4h pipeline
- `full-pipeline`: 1+ criterios fail, use standard 7+ step pipeline
- `borderline`: 1-2 criterios near-fail, user choice between fast-track + caution or full-pipeline
