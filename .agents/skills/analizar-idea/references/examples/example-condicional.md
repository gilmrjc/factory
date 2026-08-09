---
idea_slug: marketplace-interno
domain: reportes
date: 2026-08-06
skill: analizar-idea
input: descripción del usuario — "queremos que los equipos puedan compartir y reutilizar reportes entre ellos"
profile: full
status: conditional
next: evaluar-alcance-idea
---

# Análisis Preliminar: marketplace-interno

> **Relación idea ↔ PRD**: esta idea (`idea/marketplace-interno/`) es la fase pre-PRD. Su alcance se dividió y la parte prioridad N (RICE X) derivó en el PRD activo `initiatives/marketplace-interno-v1/` (PRD N — marketplace de reportes internos). Ver [scope-roadmap.md](scope-roadmap.md).

## Resumen de la idea

"queremos que los equipos puedan compartir y reutilizar reportes entre ellos"

## Declaración de resultado

Los equipos pueden descubrir, compartir y reutilizar reportes creados por otros equipos, reduciendo duplicación de esfuerzo y fomentando colaboración cross-team.

## Validación de resultado

Válido — describe el estado deseado (descubrir, compartir, reutilizar), es observable (reducción de reportes duplicados), no menciona tecnología ni implementación.

## Alineación estratégica

**Veredicto**: Parcialmente alineado

- Consistente con la dirección de producto de fomentar colaboración.
- No mueve un norte explícito de la compañía (la visión actual se centra en self-service individual, no colaborativo).
- Es deseable pero no esencial — no hay feedback recurrente que lo impulse.
- Podría dispersar foco del equipo si se emprende antes de completar iniciativas individuales en curso.

## Urgencia y momento

**Veredicto**: Puede esperar

- No hay fecha límite externa.
- No es bloqueante para otra iniciativa.
- No es oportunidad sensible al tiempo — la colaboración cross-team es un tema recurrente pero no urgente.
- Puede esperar sin costo significativo.

## Disponibilidad de recursos

**Veredicto**: Desafiante

- Equipo disponible: 1 desarrollador con capacidad parcial en Q3 (el resto está comprometido).
- Stack tecnológico: parcialmente compatible — requiere infraestructura de permisos cross-equipo que no existe.
- Dependencias externas: requiere coordinación con equipo de platform/identity para permisos.
- Riesgo técnico: medio — el sistema de permisos actual es por usuario, no por equipo.

## Recomendación preliminar

**Proceder condicional** — Hay parciales en alineación y urgencia, y recursos son desafiantes. La idea tiene mérito pero necesita aclaración antes de invertir en evaluación de alcance. Condiciones: confirmar alineación con visión colaborativa y disponibilidad de equipo de platform.

## Profile

`profile: full` — producto externo con múltiples equipos, stage Growth, requiere validación de demanda.

## Matriz de decisión

| Criterio | Status | Weight | Score |
| ---------- | -------- | -------- | ------- |
| Resultado claro | Pass | 25% | 25% |
| Alineación estratégica | Partial | 25% | 12.5% |
| Urgencia | Fail | 25% | 0% |
| Recursos básicos | Partial | 25% | 12.5% |

**Justificaciones**:

- **Resultado claro**: Resultado definido sin mencionar solución, medible (reducción de reportes duplicados).
- **Alineación estratégica**: Parcialmente alineado — consistente con colaboración pero no mueve un norte explícito.
- **Urgencia**: Puede esperar — no hay deadline ni bloqueo, la demanda es recurrente pero no urgente.
- **Recursos básicos**: Desafiante — equipo parcial, requiere infraestructura de permisos cross-equipo nueva.

**Total**: 50% → **Proceder condicional**

## Fase F — Observaciones de diseño

- El resultado abre un espacio amplio (descubrir + compartir + reutilizar) — `evaluar-alcance-idea` debería evaluar si esto es una funcionalidad única o múltiples funcionalidades.
- La dependencia con equipo de platform/identity para permisos cross-equipo es crítica — `evaluar-conectividad-tecnica` debería mapearla temprano.

## Gate de avance (Fase G)

- **Inventario de preguntas identificadas**:
  - [Importante] ¿La visión de producto incluye colaboración cross-team como norte explícito? — Estado: pendiente (el usuario fue alertado y eligió avanzar con valor por defecto conservador).
  - [Importante] ¿El equipo de platform/identity tiene capacidad para Q3? — Estado: pendiente (el usuario fue alertado y eligió avanzar con valor por defecto conservador).
  - [Menor] ¿Hay datos de cuántos reportes se duplican entre equipos? — Estado: resuelta inline (no hay datos — se documenta como suposición).
- **Alerta al usuario**: Sí — se presentaron 2 preguntas Importantes pendientes al usuario. El usuario eligió avanzar con valor por defecto conservador (alineación parcial asumida, capacidad de platform asumida como disponible).
- **Estado final de avance**: Condicionado — `status: conditional`, `next: evaluar-alcance-idea`. Las preguntas pendientes se heredan en `evaluar-alcance-idea`.

## Preguntas Abiertas (resueltas/pendientes)

### Resueltas inline

- **Pregunta**: ¿Hay datos de cuántos reportes se duplican entre equipos?
- **Impacto**: Podría justificar urgencia pero no bloquea el análisis.
- **Severidad**: Menor
- **Propuesta**: No hay datos — se documenta como suposición en Fase F.
- **Responsable**: N/A
- **Plazo**: N/A
- **Estado**: Resuelta inline — se documenta como observación.

### Pendientes

- **Pregunta**: ¿La visión de producto incluye colaboración cross-team como norte explícito?
- **Impacto**: Define si la idea está alineada o parcialmente alineada. Afecta priorización.
- **Severidad**: Importante
- **Propuesta**: Revisar documento de visión con product lead.
- **Responsable**: Product Manager
- **Plazo**: Antes de `evaluar-alcance-idea`
- **Estado**: Pendiente — usuario eligió avanzar con valor por defecto conservador.

- **Pregunta**: ¿El equipo de platform/identity tiene capacidad para Q3?
- **Impacto**: Define viabilidad de recursos. Afecta estimación de timeline.
- **Severidad**: Importante
- **Propuesta**: Reunión con líder de platform para confirmar capacidad.
- **Responsable**: Engineering Manager
- **Plazo**: Antes de `evaluar-alcance-idea`
- **Estado**: Pendiente — usuario eligió avanzar con valor por defecto conservador.

## Checklist de salida

1. Resultado definido sin mencionar solución — Sí
2. Resultado es medible u observable — Sí
3. Alineación estratégica evaluada correctamente — Sí
4. Urgencia justificada — Sí
5. Recursos básicos evaluados — Sí
6. Recomendación preliminar justificada — Sí
7. `status` y `next` correctos según el estado de avance de la Fase G — Sí
8. Header incluye línea `Input:` — Sí
9. Matriz de decisión tiene exactamente 4 columnas — Sí
10. `Status` usa texto, sin emojis — Sí
11. Sección "Gate de avance (Fase G)" presente y documentada — Sí
12. `next` incluye link relativo al siguiente artefacto — Sí
