---
name: analizar-idea
description: >-
  Toma una idea de producto (esbozo o idea bruta) y redacta una descripción
  narrativa del producto con suficiente detalle para permitir análisis técnico
  posterior y descomposición en épicas y tareas, sin entrar en stack,
  arquitectura ni implementación. Úsalo cuando el usuario tenga una idea y
  quiera describir la forma del producto o funcionalidad antes de formalizar
  requerimientos. Triggers comunes: describir, narrar, bosquejar la solución,
  definir la funcionalidad, qué construir. No lo uses para explicar el
  problema, ni para evaluar viabilidad, ni para estructurar requerimientos
  formales o generar PRDs.
---

# Analizador de Ideas

Toma una idea que contenga el problema a resolver y redacta una descripción narrativa del producto que la resuelve. La descripción es de nivel producto: pinta el problema, el resultado al que conduce y la solución que conecta ambos. Sirve para entender qué es el producto, qué experiencia ofrece, qué forma tiene, qué comportamientos entrega, qué no es, sin mencionar tecnología, arquitectura ni implementación. El detalle es lo suficientemente completo para que quien gestione el desarrollo pueda hacer un análisis posterior y descomponer en épicas y tareas sin tener que volver a preguntar lo básico. La viabilidad, el alcance, la priorización, las personas, los casos de uso y el PRD son trabajo de skills posteriores.

## Refuerzo de ejecución

- Ejecuta este skill dentro de un subagente por fase. No generes el artefacto final hasta que todos los `PAUSA-CHECK` pendientes se resuelvan.
- Si un `PAUSA-CHECK` da **NO**, ejecuta `PAUSA-ACTIVA`, espera la respuesta del usuario y reinicia el paso.
- Si falta información crítica, detente. No evites la pausa asumiendo.

## Cuándo usarlo y cuándo no

- **Sí**: la idea ya describe un problema claro y necesitas explicar qué producto lo resuelve antes de avanzar a formalización. El objetivo es pintar el producto y la experiencia, no la implementación.
- **No**: esbozar el resultado sin solución, evaluar viabilidad o generar go/no-go, estructurar requerimientos formales, dividir alcance, definir personas o casos de uso, o generar el PRD. Detener si la descripción empieza a incluir stack técnico, esquemas de datos o detalles de implementación.

NOTA: Al ejecutar las distintas fases, determina las partes que no requieren intervención del usuario y divide las tareas para usar subagentes, ya sea para ejecutar tareas en paralelo o para ejecutarlas de forma consecutiva pero aprovechando el subagente especializado.

## Fase 0 — Resolver entrada

Requerido: `IDEA-DESCRIPCION` (texto con la idea, por vago que sea el producto).

Infiere desde:
- Idea expresada en el mensaje: "Quiero algo para que la gente exporte reportes", "estaría bueno notificar a los usuarios", "modo oscuro".
- Archivo referenciado en el mensaje: si el usuario menciona un archivo que contiene la idea, úsalo y cita la ruta.

**PAUSA-CHECK**: ¿Se infiere al menos una idea y un resultado deseado del input?
- SI → registra `IDEA-DESCRIPCION` y continúa.
- NO → **PAUSA-ACTIVA**:
  - **Detectado**: No logro inferir la idea o el resultado que se quiere lograr.
  - **Pregunta**: "¿Cuál es la idea y qué resultado quieres lograr? (si no queda claro el problema a resolver, usa `esbozar-idea` primero)"
  - **Acción**: espera la respuesta, añádela al input y reinicia este paso.

## Fase A — Eco y diagnóstico inicial

Devuelve al usuario un eco breve de lo que entendiste (problema y objetivo) y un diagnóstico inicial de qué tan lista está la idea para ser descrita como producto.

**Diagnóstico de madurez** (clasifica la idea en uno de estos estados):

- **Verde**: hay un resultado pero no hay ninguna imagen del producto que lo resuelve. Necesita diálogo completo.
- **Borrador**: hay un resultado y alguna noción vaga del producto, pero mezclada con solución técnica o sin claridad sobre la experiencia generada. Necesita diálogo focalizado.
- **Casi lista**: el resultado está claro, el producto es visible y la experiencia se intuye. Diálogo mínimo de confirmación.

**Diagnóstico de nivel** (clasifica la idea en uno de estos niveles):

- **Producto**: idea de producto completo, nuevo producto o iniciativa nueva que define su propio espacio.
- **Feature**: idea de funcionalidad nueva dentro de un producto existente.

Criterios para distinguir nivel:

- **Producto**: no hay producto previo o la idea define un espacio nuevo (no extiende uno existente). Requiere crear módulos nuevos y no existe un punto claro del sistema que pueda absorber la idea.
- **Feature**: hay un módulo en el producto existente que se puede usar como base para realizar una función específica ("modo oscuro", "exportar reportes", "notificaciones push", "agregar autenticación con Google"). Generalmente se expresa como una extensión para mejorar la experiencia del usuario.

**PAUSA-CHECK**: ¿El usuario confirma o corrige el diagnóstico?
- SI (confirma o no responde sin corrección) → continúa a Fase B.
- NO (corrige) → **PAUSA-ACTIVA**:
  - **Detectado**: El usuario ajustó el diagnóstico o la interpretación.
  - **Pregunta**: "Gracias por la corrección. ¿Puedes aclarar la parte que no coincidió?"
  - **Acción**: aplica la corrección, actualiza el diagnóstico y reinicia este paso.
- SI, pero madurez "Verde" → **PAUSA-ACTIVA**:
  - **Detectado**: La idea es demasiado vaga para describir el producto.
  - **Pregunta**: "La idea aún está muy verde. ¿Quieres primero esbozarla con `esbozar-idea`, o me das más contexto del problema y el resultado?"
  - **Acción**: espera la respuesta y reinicia este paso.

## Fase B - Resolución de dominio

`domain` es la carpeta raíz que agrupa los artefactos del proceso de descubrimiento y diseño de producto.

El diagnóstico de nivel (Producto vs Feature) informa la lógica: **Feature** → dominio del producto existente que extiende; **Producto** → dominio nuevo o existente según encaje. Resumen operativo:

1. **Inventariar dominios existentes** en `docs/`.
2. **Inferir 1–3 candidatos** en kebab-case del área de producto (no técnica).
3. **Filtrar por nivel**: Feature → solo dominios existentes; Producto → existentes o nuevo.
4. **Decidir**: 0 candidatos → preguntar; 1 candidato → usar; >1 candidatos → preguntar.

Consulta [references/domain-resolution-guide.md](references/domain-resolution-guide.md) para la lógica completa, ejemplos y reglas.

## Fase C — Diálogo de descripción interactiva

Conduce un diálogo de ida y vuelta con el usuario. **Describe el producto, no la implementación**: el objetivo es pintar el problema, el resultado y la solución con suficiente detalle para planificar, no cómo se construye. Si el usuario empieza a proponer stack técnico o arquitectura, redirígelo al producto.

Trabaja en bloques pequeños (2 o 3 preguntas a la vez). No todas las preguntas necesitan respuesta explícita: muchas se infieren del diálogo o del repo.

### Paso 1 — Confirmar el problema

**PAUSA-CHECK**: ¿Se puede confirmar o inferir el problema central (síntomas, quién sufre, workaround actual)?
- SI → registra `problema confirmado` y continúa.
- NO → **PAUSA-ACTIVA**:
  - **Detectado**: No logro confirmar el problema central.
  - **Pregunta**: "¿Qué síntomas observas hoy, quién los sufre y qué workaround usan?"
  - **Acción**: espera la respuesta, añádela y reinicia este paso.

### Paso 2 — Confirmar el resultado

**PAUSA-CHECK**: ¿Se puede describir el estado final al que se quiere llegar?
- SI → registra `resultado esperado` y continúa.
- NO → **PAUSA-ACTIVA**:
  - **Detectado**: No logro describir el resultado esperado.
  - **Pregunta**: "¿Cómo cambia la experiencia del usuario cuando esto esté listo? ¿Qué deja de pasar?"
  - **Acción**: espera la respuesta, añádela y reinicia este paso.

### Paso 3 — Pintar la solución

**PAUSA-CHECK**: ¿Se puede pintar el producto/solución en términos de experiencia, sin tecnología?
- SI → registra `solución propuesta` y continúa.
- NO, el usuario propone stack o arquitectura → **PAUSA-ACTIVA**:
  - **Detectado**: La descripción incluye detalles de implementación.
  - **Pregunta**: "Entiendo que mencionas `<detalle técnico>`. ¿Qué experiencia quieres que el usuario viva con eso?"
  - **Acción**: registra el detalle como "decisión de diseño pendiente", espera la aclaración de experiencia y reinicia este paso.
- NO, no hay propuesta → **PAUSA-ACTIVA**:
  - **Detectado**: No hay descripción de la solución.
  - **Pregunta**: "¿Qué producto entrega ese estado final? Descríbelo por la experiencia del usuario."
  - **Acción**: espera la respuesta y reinicia este paso.

### Paso 4 — Explorar comportamientos clave

**PAUSA-CHECK**: ¿Se identifican 2-5 comportamientos clave del producto en términos de experiencia?
- SI → registra `comportamientos clave` y continúa.
- NO → **PAUSA-ACTIVA**:
  - **Detectado**: No logro identificar comportamientos clave.
  - **Pregunta**: "¿Qué hace el producto? Dame 2-5 acciones principales que el usuario puede realizar."
  - **Acción**: espera la respuesta y reinicia este paso.

### Paso 5 — Explorar escenarios y variantes

**PAUSA-CHECK**: ¿Se identifican escenarios alternativos (fallos, saturación, ausencia, datos faltantes, permisos denegados, timeout)?
- SI → registra `variantes`.
- NO, pero hay dudas → **PAUSA-ACTIVA**:
  - **Detectado**: No quedan claros los escenarios alternativos.
  - **Pregunta**: "¿Qué pasa cuando algo falla, falta o hay demasiados datos? ¿Hay variantes de experiencia que deba conocer?"
  - **Acción**: espera la respuesta y reinicia este paso.
- NO y no parecen relevantes → registra `No aplica` y continúa.

### Paso 6 — Aclarar el beneficiario

**PAUSA-CHECK**: ¿Se sabe quién se beneficia (rol o segmento)?
- SI → registra `beneficiario`.
- NO → **PAUSA-ACTIVA**:
  - **Detectado**: No queda claro el beneficiario.
  - **Pregunta**: "¿Quién usa o se beneficia de este producto/funcionalidad?"
  - **Acción**: espera la respuesta y reinicia este paso.

El nivel diagnosticado en la Fase A modula el alcance del diálogo:
- **Producto** → diálogo amplio para establecer un espacio nuevo (la experiencia se describe de cero)
- **Feature** → diálogo acotado que asume el producto existente como contexto y extiende lo que ya existe.

La diferencia de alcance por nivel está ejemplificada en [references/examples/example-producto.md](references/examples/example-producto.md) y [references/examples/example-feature.md](references/examples/example-feature.md).

## Fase D — Consolidar descripción

Consolida la descripción usando el template en [idea-analysis-template.md](assets/idea-analysis-template.md). El template especifica la estructura del artefacto. Sigue el template como guía, no de forma literal. Decide si necesitas ajustar la estructura según el tipo de información disponible.

El artefacto se escribe en forma narrativa (prosa), pero con la densidad necesaria para que quien gestione el desarrollo pueda hacer análisis técnico y descomponer en épicas y tareas sin tener que volver a preguntar lo básico. Los comportamientos clave son las semillas de épicas/tareas: cada uno es una unidad de producto descomponible. Las variantes se declaran como decisiones diferidas, no se resuelven aquí.

Para referencia de formato, consulta el ejemplo canónico correspondiente al nivel:
- **Producto**: [references/examples/example-producto.md](references/examples/example-producto.md) — descripción de "marketplace-interno" con solución amplia y fronteras numerosas.
- **Feature**: [references/examples/example-feature.md](references/examples/example-feature.md) — descripción de "notificaciones-push" con solución acotada y fronteras con "No aplica" como base.

Refina `IDEA-SLUG` si el diálogo aclaró el producto desde la Fase 0.

Para las preguntas abiertas, usa el template en [open-questions-template.md](assets/open-questions-template.md).

## Fase E — Gate de listo para evaluar alcance

**Gate obligatorio.** Antes de fijar `status` y `next` en el frontmatter y escribir el documento final, verifica que la descripción está lista para `evaluar-alcance-idea` (o un orquestador de descubrimiento).

El gate evalúa si la narrativa pinta un producto válido, no si llenó campos. Las preguntas del gate (2 Críticas, 2 Importantes, 2 Menores) están especificadas en [idea-analysis-template.md](assets/idea-analysis-template.md). Sigue las instrucciones del template al escribir el artefacto. Resumen operativo:

1. **Decisión de status**: evalúa el inventario de preguntas abiertas. `ready` si no hay Críticas/Importantes sin resolver. `conditional` si hay Importantes sin resolver (alertaste al usuario y eligió avanzar). `blocked` si hay Críticas sin resolver.
2. **Decisión de next**: si `status` es `ready` o `conditional`, `next: evaluar-alcance-idea` (o `orquestar-descubrimiento-producto`). Si `blocked`, `next` se omite.
3. **Documentación del gate**: añade al artefacto una subsección "Gate de avance" que registre inventario de preguntas (críticas/importantes/menores) con estado de resolución, evidencia de alerta (si hubo), y estado final de avance. Obligatoria incluso si todas las preguntas se resolvieron inline.

Consulta [references/gate-guide.md](references/gate-guide.md) para la lógica completa de severidad, estados de avance, flujo del gate y reglas.

## Salida

Comienza por generar el espacio de trabajo. Genera el readme del dominio siguiendo [references/domain-readme-spec.md](references/domain-readme-spec.md):

- **Si no existe `docs/<domain>/README.md`**: créalo con la estructura completa del spec. En esta primera ejecución del workflow, la única fila con artefacto real en "Puntos de entrada" es `idea/<IDEA-SLUG>/idea-analysis.md`; las demás (roadmap, personas, ADRs, PRD, epics) quedan como placeholders pendientes que los skills posteriores poblarán.
- **Si ya existe `docs/<domain>/README.md`**: actualiza la tabla de "Puntos de entrada" con el enlace al `idea-analysis.md` recién generado.

Al finalizar escribe el documento final en: `docs/<domain>/idea/<IDEA-SLUG>/idea-analysis.md`

## Checklist de salida

Verificación final, no parte del artefacto. Antes de terminar, verifica el checklist en [idea-analysis-template.md](assets/idea-analysis-template.md) (sección "Checklist de salida") más estos dos ítems adicionales:

- Frontmatter con `domain`, `level`, `status` y `next` correctos según Fase A (dominio) y Fase D (status/next, `next` ausente si `blocked`)
- `status` y `next` van en el frontmatter, no como sección del body
