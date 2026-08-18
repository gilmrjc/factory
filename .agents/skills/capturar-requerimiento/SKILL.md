---
name: capturar-requerimiento
description: >-
  Captura y estructura un requerimiento bruto de producto (idea, feature,
  problema). Genera documento con: problema, usuarios afectados, solución
  propuesta, restricciones. Salida:
  docs/<domain>/initiatives/<PRD-SLUG>/requirements.md. Úsalo para estructurar
  ideas antes de validación de viabilidad.
---

# Capturador de Requerimientos

Captura y estructura un requerimiento de producto bruto. Transforma una idea vaga o descripción informal en documento estructurado listo para validación.

Solo documentación: no valida, no aprueba. Estructura la idea.

## Fase 0 — Resolver entrada

Requerido: `IDEA-DESCRIPCION` o `BREVE`.

Infiere desde:
- Descripción pegada: si el usuario pega la idea/feature request
- Contenido breve: "Agregar dark mode", "Sistema de notificaciones", etc.
- Artefacto previo: `docs/<domain>/idea/<IDEA-SLUG>/connectivity/prerequisites-assessment.md` o `docs/<domain>/idea/<IDEA-SLUG>/feature-prioritization.md` cuando viene de `evaluar-conectividad-tecnica` o `priorizar-roadmap`.
- Email o chat snippet: si el usuario copia descripción informal

Pregunta cuando falta: "¿Cuál es la idea que capturo? (descripción breve o completa, o ruta del artefacto fuente)"

Declara inputs resueltos: idea capturada y fuente.

## Fase A — Analizar Idea Bruta

Lee la descripción e identifica:
1. **Problema central**: ¿Qué problema resuelve?
2. **Contexto**: ¿Por qué importa ahora?
3. **Solución propuesta**: ¿Qué se propone?
4. **Actores**: ¿Quiénes están involucrados?
5. **Restricciones mencionadas**: tiempo, presupuesto, tech, etc.

## Fase B — Estructurar Requerimiento

Genera documento con secciones:

```markdown
### 1. Problema
**Declaración de problema**: 
[En 2-3 oraciones, qué problema existe]

### 2. Audiencia Afectada
- **Usuarios primarios**: [Quién sufre el problema más]
- **Usuarios secundarios**: [Quién se beneficia indirectamente]
- **Internos**: [Product, Sales, Support, etc.]

### 3. Solución Propuesta
**Descripción de alto nivel**:
[Qué se va a construir, en lenguaje simple — solo el "qué", no el "cómo"]

**Regla de no-solutionización**: la solución propuesta se describe a nivel de **propósito/capacidad**, no de detalle de diseño. NO incluir aquí: formato de archivos, flags de CLI, políticas de UX (overwrite/skip/abort), mecanismos de handoff, esquemas de manifiesto, rutas destino, políticas de colisiones. Esas decisiones se toman en `generar-prd` (sección RF), informadas por personas y casos de uso. Si el usuario las menciona al capturar la idea, registrarlas en "Preguntas abiertas" como "decisión de diseño pendiente — se resuelve en generar-prd", no en "Decisiones resueltas".

### 4. Restricciones Conocidas
- **Timing**: [Cuándo se necesita, si hay deadline]
- **Recursos**: [Equipo disponible, restricciones]
- **Técnicas**: [Tech stack obligatorio, sistemas existentes que afecta]
- **Negocio**: [Budget si es conocido, prioridad relativa]

### 5. Preguntas Abiertas
[Lo que NO se sabe y necesita clarificación]
```

## Fase C — Gate de avance y cierre

Esta fase valida la completitud, ejecuta el gate de avance condicionado y genera el artefacto final.

### 1. Validar completitud

Checklist interno:
- Problema está claro.
- Usuarios identificados.
- Solución propuesta descrita.
- Restricciones documentadas.
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

Ruta: `docs/<domain>/initiatives/<PRD-SLUG>/requirements.md`

Frontmatter requerido:

```yaml
---
prd_slug: <PRD-SLUG>
domain: <DOMAIN>
date: <YYYY-MM-DD>
skill: capturar-requerimiento
input: <ruta del artefacto fuente o descripción pegada>
status: ready | conditional | blocked
next: <mapear-assumptions | validar-viabilidad-producto>
---
```

Cuerpo:

1. **Resumen ejecutivo**: 1-2 oraciones del requerimiento
2. **Problema**: Descripción clara del pain point
3. **Audiencia afectada**: Primarios, secundarios, internos
4. **Solución propuesta**: Descripción de alto nivel
5. **Restricciones**: Timing, recursos, técnicas, negocio
6. **Preguntas abiertas**: Qué se necesita clarificar
7. **Restricciones y Decisiones de Alcance** (opcional): decisiones tomadas durante la captura, con fecha de resolución. **Gate de no-solutionización**: solo restricciones de timing/recursos/negocio, tech stack impuesto externamente o decisiones de alcance. NO decisiones de diseño de solución (ver Fase B).
8. **Gate de avance (Fase C)**: inventario de preguntas, alerta si aplica, estado final de avance.

`status` y `next` van en el frontmatter, no como sección del body. `next` se omite si `status: blocked`.

### 4. Actualizar README

Si existe `docs/<domain>/initiatives/<PRD-SLUG>/README.md` o `docs/<domain>/README.md`, añade el enlace al `requirements.md` en la tabla de "Puntos de entrada".

### 5. Autoevaluación interna

Aplica el checklist interno antes de terminar:
- [ ] Problema declarado en 2-3 oraciones claras
- [ ] Audiencia primaria, secundaria e interna identificada
- [ ] Solución propuesta descrita en lenguaje simple
- [ ] Restricciones documentadas
- [ ] Preguntas abiertas listadas
- [ ] Decisiones resueltas documentadas con fecha (si aplica)
- [ ] No-solutionización: ninguna decisión resuelta es de detalle de diseño
- [ ] Gate de avance documentado
- [ ] `status` y `next` correctos
- [ ] Documento de salida accionable

Esta autoevaluación no se incluye en el artefacto final.

---

## Ejemplo Completo

```markdown
---
prd_slug: sistema-de-notificaciones
domain: plataforma
date: 2026-08-18
skill: capturar-requerimiento
input: docs/plataforma/idea/sistema-de-notificaciones/feature-prioritization.md
status: ready
next: mapear-assumptions
---

# Requirements: Sistema de Notificaciones

## Table of Contents

- [Resumen Ejecutivo](#resumen-ejecutivo)
- [Problema](#problema)
- [Audiencia Afectada](#audiencia-afectada)
- [Solución Propuesta](#solución-propuesta)
- [Restricciones](#restricciones)
- [Preguntas Abiertas](#preguntas-abiertas)
- [Gate de avance](#gate-de-avance)

## Resumen Ejecutivo

Implementar sistema centralizado de notificaciones para alertar a usuarios sobre eventos importantes, mejorando engagement y retención.

## Problema

Usuarios pierden oportunidades importantes porque no reciben alertas sobre cambios en su cuenta o eventos time-sensitive. Actualmente 30% abandona sin reconocer oportunidades debido a falta de comunicación.

## Audiencia Afectada

- **Primaria**: Usuarios activos (5K diarios, creciendo 20%/mes)
- **Secundaria**: Nuevos usuarios en onboarding (500/semana)
- **Interna**: CS team (reduce tickets), Product, Sales (upsell)

## Solución Propuesta

Sistema de notificaciones omnichannel:
- Email (transaccional + digest)
- Push (mobile app)
- In-app bell notification
- Preferencias por usuario (qué y cómo recibir)

**No-solutionización**: las decisiones de formato, esquemas, mecanismos de cola y endpoints se definen en `generar-prd`.

## Restricciones

- **Timing**: Before Q3 feature launch
- **Recursos**: 1 backend, 1 frontend, 1 QA
- **Técnica**: Usar SendGrid existente, integrar con analytics
- **Negocio**: High priority (retention iniciativa)

## Preguntas Abiertas

- ¿Frecuencia máxima? (evitar spam)
- ¿Soportar webhooks third-party?
- ¿A/B test en diferentes cadencias?

## Gate de avance

- **Inventario de preguntas identificadas**:
  - [Menor] ¿Frecuencia máxima? — Estado: pendiente
  - [Menor] ¿Soportar webhooks third-party? — Estado: pendiente
  - [Menor] ¿A/B test en diferentes cadencias? — Estado: pendiente
- **Alerta al usuario**: No necesaria — solo preguntas Menores, no bloquean el avance.
- **Estado final de avance**: Libre — `status: ready`, `next: mapear-assumptions`
```
