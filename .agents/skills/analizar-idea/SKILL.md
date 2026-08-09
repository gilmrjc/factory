---
name: analizar-idea
description: >-
  Analiza preliminarmente una idea de producto definiendo el resultado deseado
  sin mencionar solución. Evalúa alineación estratégica, urgencia,
  disponibilidad de recursos y genera recomendación Proceder/Proceder
  condicional/No proceder. Salida:
  docs/<domain>/idea/<IDEA-SLUG>/idea-analysis.md. Úsalo como gate preliminar
  de viabilidad antes de evaluar-alcance-idea. Triggers comunes: analizar,
  evaluar, validar viabilidad, hacer un gate preliminar, decidir si proceder
  con una idea. Solo análisis: no implementa, no aprueba, no evalúa alcance
  (usa evaluar-alcance-idea). Para implementación usa implementar-plan o
  implementar-ticket.
---

# Analizador de Ideas

Combina análisis preliminar de viabilidad con definición de resultado deseado. Evalúa rápidamente si la idea merece inversión y define el resultado sin mencionar la solución.

Solo análisis: no implementa, no aprueba. Prepara punto de control de aprobación. Para implementación usa implementar-plan o implementar-ticket.

## Cuándo usarlo y cuándo no

Triggers y fronteras base están en el frontmatter. Complementos operativos:

- **Sí**: Gate preliminar de viabilidad antes de invertir tiempo en evaluación de alcance.
- **No (adicionales al frontmatter)**: para aprobación final (usa `validar-viabilidad-producto`), para análisis técnico profundo (usa `evaluar-conectividad-tecnica`). Tampoco para reanudar trabajo ya iniciado — si ya existe un `scope-roadmap.md` producido por `evaluar-alcance-idea`, este skill no aplica como paso inicial.

## Fase 0 — Resolver entrada

Requerido: `IDEA-DESCRIPCION`.

Infiere desde:
- Descripción pegada: si el usuario pega la idea/solicitud de funcionalidad.
- Contenido breve: "Agregar modo oscuro", "Sistema de notificaciones", "Exportar a PDF".
- Email o fragmento de chat: si el usuario copia descripción informal.
- Artefacto upstream: si existe `docs/drafts/<IDEA-SLUG>/esbozo.md` (producido por `esbozar-idea`), leerlo para contexto y decisiones resueltas heredadas.

Pregunta cuando falta: "¿Cuál es la idea que analizo? (descripción breve o completa)"

Genera `IDEA-SLUG` en kebab-case a partir del resultado o, si el resultado aún no está claro, de la frase más representativa de la idea.

## Fase A — Definir Resultado Deseado

Extrae el resultado sin mencionar la solución:

**Criterios de resultado válido**:
- Describe el resultado/estado deseado, no la funcionalidad
- Es medible u observable
- No menciona tecnología o implementación
- Responde a "¿Qué queremos lograr?" no "¿Qué vamos a construir?"

**Ejemplos**:
- Incorrecto: "Implementar sistema de notificaciones" (menciona solución)
- Correcto: "Los usuarios están informados sobre eventos importantes en tiempo real" (resultado)
- Incorrecto: "Agregar modo oscuro" (menciona solución)
- Correcto: "Los usuarios pueden usar el producto cómodamente en ambientes con poca luz" (resultado)

**Si no puede definir resultado sin solución**:
- Marcar como "necesita reformulación"
- Sugerir reformulación de la idea
- `status: blocked` con instrucciones

## Fase B — Evaluar Alineación Estratégica

¿Encaja con visión/plan de trabajo de producto?

**Criterios**:
- ¿Esta idea es consistente con dirección de producto?
- ¿Mueve un norte explícito de la compañía?
- ¿Es esencial o deseable?
- ¿Mantiene foco o lo dispersa?

**Veredicto**: Alineado / Parcialmente alineado / Desalineado

**Estrategia de fallo**: Si no hay información sobre visión/plan de trabajo, marcar como "Parcialmente alineado" y documentar en Preguntas abiertas.

## Fase C — Evaluar Urgencia y Momento

¿Por qué ahora?

**Criterios**:
- ¿Hay fecha límite externa (regulatorio, mercado, cliente)?
- ¿Es bloqueante para otra iniciativa?
- ¿Es oportunidad sensible al tiempo?
- ¿Puede esperar sin costo significativo?

**Veredicto**: Urgente / Importante / Puede esperar

**Estrategia de fallo**: Si no hay información sobre fechas límite o prioridades, marcar como "Importante" (default conservador) y documentar en Preguntas abiertas.

## Fase D — Evaluar Disponibilidad Básica de Recursos

Verificación rápida de viabilidad:

**Criterios**:
- ¿Equipo disponible (capacidad básica)?
- ¿Stack tecnológico compatible con arquitectura existente?
- ¿Dependencias externas críticas disponibles?
- ¿Riesgo técnico manejable?

**Veredicto**: Viable / Desafiante / No viable

**Estrategia de fallo**: Si no hay información sobre recursos, marcar como "Desafiante" (default conservador) y documentar en Preguntas abiertas.

## Fase E — Generar Recomendación Preliminar

Usar template en [decision-matrix-template.md](assets/decision-matrix-template.md) para estructurar la decisión. El template especifica la matriz de scoring (4 columnas, justificaciones en lista debajo), sistema de scoring, umbrales de decisión, detección de `profile` (full/lite) y ejemplo canónico. Síguelo literalmente.

**Resumen operativo**:

- La matriz evalúa 4 criterios: resultado claro, alineación estratégica, urgencia, recursos básicos (25% cada uno por defecto).
- La recomendación (Proceder/Proceder condicional/No proceder) se mapea a `status` y `next` según los umbrales del template, refinado por la Fase G según preguntas abiertas.
- Declara `profile` (full/lite) según los criterios del template. El orquestador lo consume para activar shortcuts lite.

**Mapeo recomendación → status/next** (refinado por la Fase G):
- Proceder → `status: ready`, `next: evaluar-alcance-idea` (avance libre, sin preguntas Críticas/Importantes sin resolver)
- Proceder condicional → `status: conditional`, `next: evaluar-alcance-idea` (o `status: blocked` según severidad de preguntas abiertas)
- No proceder → `status: blocked` (next se omite)

## Fase F — Escribir Análisis Preliminar

Consolida el análisis usando el template en [idea-analysis-template.md](assets/idea-analysis-template.md). El template especifica frontmatter requerido, secciones requeridas, convenciones de formato, nota opcional de relación con downstream, "Qué NO va en este análisis" y "Distinciones clave para no confundir secciones". Síguelo literalmente.

Para referencia de formato, consulta el ejemplo canónico correspondiente al veredicto:
- **Proceder**: [references/examples/example-proceder.md](references/examples/example-proceder.md) — análisis de "notificaciones-push" con `status: ready`, gate resuelto inline.
- **Proceder condicional**: [references/examples/example-condicional.md](references/examples/example-condicional.md) — análisis de "marketplace-interno" con `status: conditional`, gate con alerta al usuario.

**Resumen de secciones requeridas** (ver template para detalle):
- Frontmatter (incluyendo `input`, `profile`, `status` y `next`)
- (Opcional) Nota de relación con artefactos downstream
- Resumen de la idea, Declaración de resultado, Validación de resultado
- Alineación estratégica, Urgencia y momento, Disponibilidad de recursos
- Recomendación preliminar, Profile, Matriz de decisión
- Observaciones de diseño (Fase F): insights que no son parte del gate pero aceleran `evaluar-alcance-idea`
- Gate de avance (Fase G) — **obligatoria** incluso si todas las preguntas se resolvieron inline
- Preguntas Abiertas (resueltas/pendientes), Checklist de salida

**Convenciones clave** (ver template para detalle):
- Sin emojis: usa `Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`
- Matriz de decisión: 4 columnas, justificaciones en lista debajo
- `status` y `next` van en el frontmatter, no como sección del body

## Fase G — Gate de Avance Condicionado (Preguntas Abiertas)

**Gate obligatorio.** Después de completar el análisis (Fases A–F) y antes de fijar `status` y `next` en el frontmatter y escribir el documento final, ejecuta este gate. El documento **no está completo** hasta que Fase G se ejecuta y se documenta, incluso si todas las preguntas se resolvieron inline durante las Fases B/C/D.

Consulta [references/gate-guide.md](references/gate-guide.md) para la lógica completa de severidad, estados de avance, flujo del gate y reglas. Resumen operativo:

1. **Decisión de status**: evalúa el inventario de preguntas abiertas. `ready` si no hay Críticas/Importantes sin resolver. `conditional` si hay Importantes sin resolver (el usuario fue alertado y eligió avanzar). `blocked` si hay Críticas sin resolver.
2. **Decisión de next**: si `status` es `ready` o `conditional`, `next: evaluar-alcance-idea`. Si `blocked`, `next` se omite. Enlace relativo al siguiente artefacto: `../<IDEA-SLUG>/scope-roadmap.md` (o `../<IDEA-SLUG>-scope-roadmap.md` en formato legacy) (a crear por `evaluar-alcance-idea`).
3. **Documentación del gate**: añade al análisis una subsección "Gate de avance (Fase G)" que registre inventario de preguntas (críticas/importantes/menores) con estado de resolución, evidencia de alerta (si hubo), y estado final de avance. Obligatoria incluso si todas las preguntas se resolvieron inline.

## Salida

Escribe en (formato principal): `docs/<domain>/idea/<IDEA-SLUG>/idea-analysis.md` (subdirectorio)
Compatibilidad legacy: `docs/<domain>/idea/<IDEA-SLUG>-idea-analysis.md` (prefijo)

Para la estructura completa del artefacto (frontmatter requerido, secciones requeridas, convenciones de formato, nota opcional de relación con downstream, "Qué NO va" y "Distinciones clave"), usa el template en [idea-analysis-template.md](assets/idea-analysis-template.md).

### README del dominio (índice)

Como primer skill del Workflow 0, este skill es responsable de crear o actualizar el índice del dominio en `docs/<domain>/README.md`. La estructura requerida (título, puntos de entrada, árbol, convenciones) está especificada en [domain-readme-spec.md](references/domain-readme-spec.md) — ese spec es compartido con otros skills del workflow que actualizan el README.

- **Si no existe**: créalo con la estructura completa del spec.
- **Si existe**: actualiza la tabla de "Puntos de entrada" con `idea/<IDEA-SLUG>/idea-analysis.md` y el árbol de estructura si hay nuevos archivos.

## Checklist de salida

Verificación interna del agente — no se incluye en el artefacto. Antes de terminar, verifica contra el template en [idea-analysis-template.md](assets/idea-analysis-template.md):

### Contenido

1. Resultado definido sin mencionar solución
2. Resultado es medible u observable
3. Alineación estratégica evaluada correctamente
4. Urgencia justificada
5. Recursos básicos evaluados
6. Recomendación preliminar justificada
7. `profile` declarado con justificación
8. `status` y `next` correctos según el estado de avance de la Fase G

### Formato (verificación de convenciones)

9. Frontmatter incluye `input`, `profile`, `status` y `next` (`next` ausente si `blocked`)
10. Matriz de decisión tiene **exactamente 4 columnas** (`Criterio | Status | Weight | Score`) — sin 5ª columna `Justificación` en la tabla; las justificaciones van en lista debajo
11. `Status` usa **texto** (`Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`) — sin emojis (`✅`/`⚠️`/`❌`) en matriz, validación ni checklist de salida
12. Sección **"Gate de avance (Fase G)"** presente y documentada con inventario de preguntas, evidencia de alerta (si hubo) y estado final de avance — **obligatoria incluso si todas las preguntas se resolvieron inline**
13. `status` y `next` van en el frontmatter, no como sección del body

## Preguntas Abiertas

Usa el template en [open-questions-template.md](assets/open-questions-template.md) para el formato. La lógica de severidad y decisión de avance se define en la Fase G y está detallada en [references/gate-guide.md](references/gate-guide.md).

**Categorías comunes para este skill**:
- Si la visión/plan de trabajo de producto no está clara
- Si no hay información sobre fechas límite externas
- Si la disponibilidad de recursos es desconocida
- Si el resultado no puede definirse sin mencionar solución

Las preguntas abiertas generadas en las estrategias de fallo de las Fases B, C y D alimentan directamente el gate de la Fase G. No se avanza al siguiente skill sin pasar por ese gate.
