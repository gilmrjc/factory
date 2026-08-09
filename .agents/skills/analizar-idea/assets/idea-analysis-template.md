# Template: Análisis Preliminar de Idea

Template para estructurar el artefacto de salida de `analizar-idea`. El agente sigue este formato al escribir `docs/<domain>/idea/<IDEA-SLUG>/idea-analysis.md`.

## Frontmatter requerido (al inicio del documento)

```yaml
---
idea_slug: <IDEA-SLUG>
domain: <domain>
date: <YYYY-MM-DD>
skill: analizar-idea
input: <descripción del usuario o ruta del artefacto fuente>
profile: full | lite
status: ready | conditional | blocked
next: evaluar-alcance-idea
---
```

El campo **input** documenta la fuente: texto libre pegado por el usuario (`Input: descripción del usuario`) o ruta del artefacto fuente si existe (ej. issue, email). **No omitas** la línea `input` aunque el detalle vaya en la sección "Resumen de la idea".

El campo **profile** indica el nivel de ceremonia del workflow downstream (`full` o `lite`). Criterios completos en `assets/decision-matrix-template.md` sección "Detección de profile".

El campo **status** describe el estado del análisis: `ready` (avance libre), `conditional` (avance condicionado por preguntas Importantes), o `blocked` (no avanza). La lógica completa para decidir el valor está en [references/gate-guide.md](../references/gate-guide.md).

El campo **next** es la señal de routing al siguiente skill. Presente solo cuando `status` es `ready` o `conditional`. Valor: `evaluar-alcance-idea`. La decisión se toma en la Fase G (ver SKILL.md). Si `status` es `blocked`, `next` se omite.

## Secciones requeridas

- Frontmatter requerido (al inicio del documento, incluyendo `input`, `profile`, `status` y `next`)
- (Opcional) Nota de relación con artefactos downstream — ver abajo
- Resumen de la idea (input del usuario) — preserva el input original para contexto
- Declaración de resultado (sin mención de solución)
- Validación de resultado (válido/necesita reformulación)
- Alineación estratégica
- Urgencia y momento
- Disponibilidad de recursos
- Recomendación preliminar (Proceder/Proceder condicional/No proceder)
- Profile: `full` o `lite` (con justificación — ver criterios en `assets/decision-matrix-template.md`)
- Matriz de decisión (4 columnas, justificaciones en lista debajo — ver `assets/decision-matrix-template.md`)
- Fase F — Observaciones de diseño relevantes para el siguiente paso: insights de diseño que no son parte del gate pero aceleran `evaluar-alcance-idea`
- Gate de avance (Fase G): inventario de preguntas identificadas (críticas/importantes/menores) con estado de resolución, evidencia de la alerta al usuario (si hubo) y estado final de avance que justifica `status` y `next`. **Obligatoria** incluso si todas las preguntas se resolvieron inline.
- Preguntas Abiertas (resueltas/pendientes): documenta decisiones tomadas con severidad original y estado de resolución. Marcar como "Pendiente — usuario eligió avanzar con valor por defecto conservador" las que el usuario decidió no resolver en el gate de la Fase G.
- Checklist de salida (validación de contenido + formato)

## Convenciones de formato del documento

- Sin emojis en el documento (matriz, validación, checklist de salida). Usa texto: `Pass`/`Partial`/`Fail`, `Sí`/`Parcial`/`No`. Símbolos tipográficos estándar (`→`, `—`, `≥`, `≤`) sí están permitidos.
- La matriz de decisión tiene 4 columnas; las justificaciones van en lista debajo, no como columna extra. Reglas completas en `assets/decision-matrix-template.md`.
- `status` y `next` van en el frontmatter, no como sección del body.

## Nota opcional: Relación idea ↔ artefactos downstream

Cuando ya existen artefactos downstream generados por skills posteriores del workflow (scope-roadmap, PRD, epics), añade al inicio del documento (justo después del frontmatter) una nota breve que relacione esta idea con sus artefactos derivados, para facilitar navegación.

**Formato**:
> **Relación idea ↔ PRD**: esta idea (`idea/<IDEA-SLUG>/`) es la fase pre-PRD. Su alcance se dividió y la parte prioridad N (RICE X) derivó en el PRD activo `initiatives/<PRD-SLUG>/` (PRD N — <descripción>). Ver [scope-roadmap.md](scope-roadmap.md).

Solo se añade cuando los artefactos downstream existen. En la primera ejecución del skill (sin downstream), se omite.

## Qué NO va en este análisis

Estos contenidos pertenecen a skills posteriores y **no** deben desarrollarse en el análisis preliminar:

- Evaluación de alcance (múltiples vs única funcionalidad) → `evaluar-alcance-idea`
- Priorización RICE de funcionalidades → `priorizar-roadmap`
- Conectividad técnica / features puente → `evaluar-conectividad-tecnica`
- Captura de requerimientos formales → `capturar-requerimiento`
- Validación de viabilidad de producto (demanda, riesgo negocio) → `validar-viabilidad-producto`
- Mapeo de assumptions (matriz 2x2, risk vs evidence) → `mapear-assumptions`
- Personas detalladas → `definir-usuarios`
- Casos de uso (happy path, edge cases) → `mapear-casos-uso`
- Métricas de éxito / diseño de experimentos → `disenar-experimentos`
- PRD → `generar-prd`

Si el usuario introdujo alguno de estos durante el diálogo, regístralo como nota breve en "Fase F — Observaciones de diseño" o como Pregunta abierta, sin desarrollarlo.

## Distinciones clave para no confundir secciones

- **Resultado deseado** vs **Problema**: el resultado es el estado futuro que quieres lograr; el problema son los síntomas observables del dolor actual. Ambos se formulan sin solución. El análisis preliminar se centra en el resultado; el problema lo trabaja `esbozar-idea` upstream.
- **Alineación estratégica** vs **Urgencia**: la alineación evalúa si la idea encaja con la visión/dirección del producto; la urgencia evalúa el momento (¿por qué ahora?). Una idea puede estar alineada pero no ser urgente, o ser urgente pero no estar alineada.
- **Recursos básicos** vs **Viabilidad técnica**: los recursos básicos son una verificación rápida (equipo, stack, dependencias); la viabilidad técnica es un análisis profundo de deuda técnica y construcciones nuevas. Los recursos básicos van aquí; la viabilidad técnica va en `validar-viabilidad-tecnica`.
- **Recomendación preliminar** vs **Aprobación final**: la recomendación preliminar (Proceder/Condicional/No proceder) es un gate de viabilidad rápida; la aprobación final la da `validar-viabilidad-producto`. La recomendación preliminar no aprueba ni rechaza definitivamente.
- **Profile** vs **Recomendación**: el `profile` (full/lite) indica cuánta ceremonia aplica el workflow downstream; la recomendación (Proceder/Condicional/No proceder) indica si avanza. Son señales ortogonales — un PRD puede ser `Proceder` con `profile: lite` o `Proceder` con `profile: full`.
- **Observaciones de diseño (Fase F)** vs **Gate de avance (Fase G)**: las observaciones de diseño son insights que aceleran el siguiente skill pero no condicionan el avance; el gate es la verificación obligatoria que decide `status` y `next`. Ambas coexisten.

## Ejemplos canónicos

Para referencia de formato, consulta el ejemplo canónico correspondiente al veredicto:

- **Proceder**: [references/examples/example-proceder.md](../references/examples/example-proceder.md) — análisis de "notificaciones-push" con `status: ready`, todas las secciones desarrolladas, gate resuelto inline.
- **Proceder condicional**: [references/examples/example-condicional.md](../references/examples/example-condicional.md) — análisis de "marketplace-interno" con `status: conditional`, preguntas Importantes pendientes, gate con alerta al usuario.
