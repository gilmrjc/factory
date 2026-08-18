---
name: capturar-requerimiento
description: >-
  Captura y estructura un requerimiento de producto (idea, feature,
  problema) en un documento con contexto, problema, audiencia afectada,
  resultado esperado, solución propuesta a alto nivel y preguntas
  abiertas. Puede recibir un `FUNCIONALIDAD-SLUG` y leer `discovery-state.md` para
  procesar una funcionalidad concreta de la cola. Genera
  `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/captured-requirement.md` y actualiza el
  estado de avance en `discovery-state.md` si existe. Úsalo cuando el
  usuario traiga una idea o feature request informal, o cuando el
  orquestador de descubrimiento indique el siguiente `FUNCIONALIDAD-SLUG` a
  capturar. Triggers comunes: capturar requerimiento, estructurar una
  idea, documentar un feature request, formalizar un problema. No lo uses
  para describir la forma del producto o la experiencia (usa
  `analizar-idea`), evaluar viabilidad (usa `validar-viabilidad-producto`),
  generar el PRD formal, priorizar (usa `priorizar-roadmap`) ni
  implementar o modificar código.
---

# Capturador de Requerimientos

Captura y estructura un requerimiento de producto bruto. Transforma una idea vaga o descripción informal en documento estructurado listo para validación.

Solo documentación: no valida, no aprueba. Estructura la idea.

## Cuándo usarlo y cuándo no

- **Sí**: existe una idea o feature request informal y se necesita estructurar el requerimiento antes de mapear supuestos o validar viabilidad. La fuente puede ser un mensaje, un email, una descripción pegada o un artefacto previo del workflow (`feature-prioritization.md` o `prerequisites-assessment.md`).
- **No**: describir el producto (usa `analizar-idea`), evaluar viabilidad (usa `validar-viabilidad-producto`), generar el PRD formal, dividir en épicas (usa `dividir-epic`), implementar o modificar código.

NOTA: Al ejecutar las distintas fases, determina las partes que no requieren intervención del usuario y divide las tareas para usar subagentes, ya sea para ejecutarlas en paralelo o de forma consecutiva pero aprovechando el subagente especializado.

## Fase 0 — Resolver entrada

Requerido: `IDEA-DESCRIPCION` o `BREVE`; `FUNCIONALIDAD-SLUG` es opcional y se usa cuando se invoca desde `orquestar-descubrimiento-producto`.

Infiere desde:
- `FUNCIONALIDAD-SLUG` explícito: si el usuario o el orquestador lo provee.
- `discovery-state.md`: si existe, toma el `next` actual como `FUNCIONALIDAD-SLUG` y lee el nombre/descripción de la funcionalidad desde `feature-prioritization.md` o `scope-roadmap.md`.
- Descripción pegada: si el usuario pega la idea/feature request.
- Contenido breve: "Agregar dark mode", "Sistema de notificaciones", etc.
- Artefacto previo: `docs/<domain>/idea/<IDEA-SLUG>/connectivity/prerequisites-assessment.md` o `docs/<domain>/idea/<IDEA-SLUG>/feature-prioritization.md` cuando viene de `evaluar-conectividad-tecnica` o `priorizar-roadmap`.
- Email o chat snippet: si el usuario copia descripción informal.

Pregunta cuando falta: "¿Cuál es la idea que capturo? (descripción breve o completa, `FUNCIONALIDAD-SLUG`, o ruta del artefacto fuente)"

Declara inputs resueltos: idea capturada y fuente.

## Fase A — Analizar Idea Bruta

Lee la descripción e identifica:
1. **Problema central**: ¿Qué problema resuelve?
2. **Contexto**: ¿Por qué importa ahora?
3. **Resultado esperado**: ¿Qué cambia para el usuario o el negocio?
4. **Solución propuesta**: ¿Qué se propone?
5. **Actores**: ¿Quiénes están involucrados?
6. **Preguntas abiertas**: Información faltante.

## Fase B — Estructurar Requerimiento

Estructura el requerimiento siguiendo [assets/captured-requirement-template.md](assets/captured-requirement-template.md).

Notas específicas para esta fase:
- **Solución propuesta**: describe propósito/capacidad. Aplica [references/no-solutionization-guide.md](references/no-solutionization-guide.md); si el usuario menciona detalles de implementación, regístralos en "Preguntas abiertas" como "decisión de diseño pendiente — se resuelve en fases posteriores del workflow".
- **Preguntas abiertas**: extrae unknowns con [assets/open-questions-template.md](assets/open-questions-template.md).

## Fase C — Gate de avance y cierre

Esta fase valida la completitud, ejecuta el gate de avance condicionado y genera el artefacto final.

### 1. Validar completitud

Checklist interno:
- Problema está claro.
- Contexto y resultado esperado documentados.
- Usuarios identificados.
- Solución propuesta descrita.
- Preguntas abiertas listadas.

Si algo falta, agregarlo o listarlo en preguntas abiertas.

### 2. Ejecutar gate de avance condicionado

**Gate obligatorio.** Después de completar el análisis (Fases A–B) y antes de fijar el `status` y `next`, ejecuta este gate. El documento **no está completo** hasta que el gate se ejecute y se documente, incluso si todas las preguntas se resolvieron inline.

Consulta `_shared/open-questions-template.md` para el flujo de alerta, manejo de respuestas y herencia de preguntas pendientes.

Clasifica preguntas abiertas por severidad (Crítica / Importante / Menor) y fija el `status`:
- `ready`: sin Críticas/Importantes pendientes.
- `conditional`: Importantes pendientes y el usuario acepta avanzar.
- `blocked`: Críticas pendientes → omite `next`.

El `next` de este skill es:
- `next: mapear-assumptions` (recomendado)
- `next: validar-viabilidad-producto` (si se omite `mapear-assumptions`)

### 3. Escribir artefacto final

Escribe el documento siguiendo [assets/captured-requirement-template.md](assets/captured-requirement-template.md). El `status` y `next` van en el frontmatter, no como sección del body. `next` se omite si `status: blocked`.

### 4. Actualizar `discovery-state.md`

Si existe `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md`:
- Localiza el ítem con el `FUNCIONALIDAD-SLUG` capturado.
- Marca `estado: requerimiento-capturado`.
- Añade la ruta a `captured-requirement.md` (o `requirements.md`) en el campo `Requerimiento`.
- Determina el siguiente `FUNCIONALIDAD-SLUG` con `estado: pendiente-captura` y actualiza el `next` del frontmatter de `discovery-state.md` con ese slug. Si no hay más pendientes, deja `next: mapear-assumptions` (o `validar-viabilidad-producto` si se omite assumptions) y `status: in-progress`.

Si no existe `discovery-state.md` y se invocó individualmente, crea uno mínimo con el ítem capturado marcado y `next: mapear-assumptions`.

### 5. Actualizar README

Si existe `docs/<domain>/idea/<IDEA-SLUG>/README.md` o `docs/<domain>/README.md`, añade el enlace al `captured-requirement.md` en la tabla de "Puntos de entrada".

---

## Salida

Escribe en: `docs/<domain>/idea/<IDEA-SLUG>/<FUNCIONALIDAD-SLUG>/captured-requirement.md`

## Checklist de salida

Verificación final, no parte del artefacto. Antes de terminar, verifica cada ítem:

### Contenido

1. Problema declarado en 2-3 oraciones claras.
2. Contexto y resultado esperado documentados.
3. Audiencia primaria, secundaria e interna identificada.
4. Solución propuesta descrita en lenguaje simple, sin detalles de diseño.
5. Preguntas abiertas listadas con categoría, impacto, severidad y propuesta de resolución.
6. No-solutionización: la solución propuesta no incluye detalles de diseño.
7. Gate de avance documentado con inventario y estado final.
8. `status` y `next` correctos en el frontmatter (`next` ausente si `blocked`).

### Formato

9. Frontmatter con `idea_slug`, `domain`, `date`, `skill`, `input`, `status`, `next` correctos.
10. Table of Contents (TOC) presente después del título y antes de la primera sección.
11. Sin emojis en el documento.

---

## Ejemplo Completo

Ver ejemplo canónico en [references/examples/example-captured-requirement.md](references/examples/example-captured-requirement.md) (`sistema-de-notificaciones`).
