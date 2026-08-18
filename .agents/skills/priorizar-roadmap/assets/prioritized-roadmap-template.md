# Template: Feature Prioritization

Template para estructurar el artefacto de salida de `priorizar-roadmap`. El agente sigue este formato al escribir `docs/<domain>/idea/<IDEA-SLUG>/feature-prioritization.md`.

## Frontmatter requerido (al inicio del documento)

```yaml
---
idea_slug: <IDEA-SLUG>
domain: <DOMAIN>
date: <YYYY-MM-DD>
skill: priorizar-roadmap
input: <ruta del artefacto fuente: scope-roadmap.md o bridge-roadmap.md>
status: ready | conditional | blocked
next: evaluar-conectividad-tecnica
---
```

- `status` indica el resultado del gate: `ready` (avance libre), `conditional` (avance condicionado por preguntas Importantes), `blocked` (no avanza).
- `next` va presente solo cuando `status` es `ready` o `conditional`. Si `status` es `blocked`, omite `next`.
- La decisión del `status` y `next` se toma en Fase G siguiendo `../references/phase-g-gate.md`.

## Cuerpo del documento

```markdown
# Feature Prioritization: <IDEA-SLUG>

## Resumen de priorización

- **Metodología**: RICE (Reach × Impact × Confidence / Effort)
- **Ítems totales**: [X]
- **Ítems bloqueados**: [Y]
- **Ítems priorizables**: [Z]

## Roadmap priorizado

Ordena primero por dependencias (ítems desbloqueados primero; si un ítem desbloquea otros, priorízalo). Luego, dentro de cada bloque, ordena por Puntuación RICE (0-100) de mayor a menor.

### Puesto 1: [Nombre]

- **Puntuación RICE (0-100)**: [Valor normalizado] (RICE raw: [Valor calculado])
- **Reach**: [Valor + justificación]
- **Impact**: [Valor + justificación]
- **Confidence**: [Valor + justificación]
- **Effort**: [Valor + justificación]
- **Estado**: Priorizable / Bloqueado
- **Dependencias**: [Ninguna / lista]
- **Recomendación**: Implementar ahora / Esperar dependencias

### Puesto 2: [Nombre]

... (repetir estructura para cada ítem)

## Recomendación de implementación

- **Ítem prioritario**: [Primer ítem con estado `Priorizable` en el ranking; si Puesto 1 está `Bloqueado`, saltar al siguiente `Priorizable`]
- **Justificación**: [Por qué este ítem]
- **Next step**: `evaluar-conectividad-tecnica` si hay un ítem `Priorizable`; `blocked` si hay preguntas abiertas sin resolver
- **Ruta del siguiente artefacto esperado**: `docs/<domain>/initiatives/<PRD-SLUG>/connectivity/prerequisites-assessment.md`

## Notas de escala usadas

Documenta las escalas aplicadas para RICE:

- Reach: 1-10 (1 = pocos usuarios, 10 = muchos usuarios)
- Impact: 0.25-3 (0.25 = mínimo, 3 = masivo)
- Confidence: 50%-100% (50% = baja confianza, 100% = alta confianza)
- Effort: 1-10 puntos de complejidad (1 = trivial, 10 = muy complejo)
- Puntuación RICE (0-100): `100 × RICE / (RICE + 1)`. `RICE = 1.0` es el ítem de referencia (Reach 4, Impact 1, Confidence 100%, Effort 4) y obtiene 50%.
- Cuando dos puntuaciones estén muy cercanas, usa `RICE raw` para desempatar.

## Autoevaluación

Aplica el checklist de `../references/autoevaluacion-checklist.md`. Esta es una evaluación interna por lo que no es necesario incluir los resultados en esta sección.

## Gate de avance

- **Inventario de preguntas identificadas**:
  - [Crítico/Importante/Menor] [Pregunta] — Estado: [resuelta inline / resuelta en gate / pendiente]
- **Alerta al usuario**: [No necesaria / presentada; usuario decidió avanzar con default conservador]
- **Estado final de avance**: [Libre / Condicionado / Bloqueado] — `Ready for: [next]`

## Preguntas abiertas

- **Críticas**
  - ...
- **Importantes**
  - ...
- **Menores**
  - ...

## Ready for

- `evaluar-conectividad-tecnica`: Roadmap priorizado, proceder a evaluar conectividad del ítem más prioritario antes de capturar requerimiento.
- `blocked`: Preguntas abiertas sin resolver.
```
