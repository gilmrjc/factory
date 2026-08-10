---
name: evaluar-alcance-idea
description: >-
  Gate preliminar de viabilidad y evaluación de alcance de una idea. Primero
  evalúa alineación estratégica, urgencia y disponibilidad básica de
  recursos para decidir si la idea merece inversión (fail-fast). Si procede,
  evalúa si contiene múltiples funcionalidades o una sola, divide ideas
  complejas en funcionalidades individuales con alcance, value proposition y
  timeline, y declara profile (full/lite). Salida:
  docs/<domain>/idea/<IDEA-SLUG>/scope-roadmap.md. Úsalo después de
  analizar-idea y antes de priorizar-roadmap. No lo usas para describir el
  producto (usa analizar-idea), ni para validar viabilidad de negocio a
  fondo (usa validar-viabilidad-producto), ni para priorizar (usa
  priorizar-roadmap).
---

# Evaluador de Alcance de Ideas

Primero actúa como gate preliminar de viabilidad: evalúa si la idea merece inversión antes de dedicar tiempo a dividir alcance. Si procede, evalúa si la idea contiene múltiples funcionalidades que requieren PRDs separados o una sola funcionalidad cohesiva que justifica un solo PRD, y divide ideas complejas en funcionalidades individuales manejables.

Solo análisis y planificación: no implementa, no modifica código. Prepara la idea para priorización.

## Cuándo usarlo y cuándo no

- **Sí**: Después de `analizar-idea` (descripción del producto aprobada) para evaluar viabilidad preliminar y si la idea requiere múltiples PRDs o uno solo
- **No**: Para describir el producto (usa `analizar-idea`), para viabilidad de negocio a fondo con matriz de decisión (usa `validar-viabilidad-producto`), para priorizar funcionalidades (usa `priorizar-roadmap`), para conectividad técnica (usa `evaluar-conectividad-tecnica`), para implementar (usa `implementar-plan` o `implementar-ticket`)

## Fase 0 — Resolver entrada

Requerido: `IDEA-DESCRIPCION`.

Infiere desde:
- Descripción pegada: si el usuario pega la idea/feature request
- Contenido breve: "Agregar dark mode", "Sistema de notificaciones", etc.
- Email o chat snippet: si el usuario copia descripción informal
- Artefacto upstream: si existe `docs/<domain>/idea/<IDEA-SLUG>/idea-analysis.md` (producido por `analizar-idea`), leerlo para heredar la descripción del producto, problema, estado final, beneficiarios y decisiones resueltas

Pregunta cuando falta: "¿Cuál es la idea que evalúo? (descripción breve o completa)"

Declara inputs resueltos: idea capturada.

## Fase A — Gate preliminar de viabilidad

**Fail-fast.** Antes de invertir tiempo en dividir alcance, evalúa si la idea merece inversión. Si no procede, el workflow se detiene aquí sin pasar a la Fase B.

### A.1 — Alinearación estratégica

¿Encaja con visión/plan de trabajo de producto?

**Criterios**:
- ¿Esta idea es consistente con dirección de producto?
- ¿Mueve un norte explícito de la compañía?
- ¿Es esencial o deseable?
- ¿Mantiene foco o lo dispersa?

**Veredicto**: Alineado / Parcialmente alineado / Desalineado

**Estrategia de fallo**: Si no hay información sobre visión/plan de trabajo, marcar como "Parcialmente alineado" y documentar en Preguntas abiertas.

### A.2 — Urgencia y momento

¿Por qué ahora?

**Criterios**:
- ¿Hay fecha límite externa (regulatorio, mercado, cliente)?
- ¿Es bloqueante para otra iniciativa?
- ¿Es oportunidad sensible al tiempo?
- ¿Puede esperar sin costo significativo?

**Veredicto**: Urgente / Importante / Puede esperar

**Estrategia de fallo**: Si no hay información sobre fechas límite o prioridades, marcar como "Importante" (default conservador) y documentar en Preguntas abiertas.

### A.3 — Disponibilidad básica de recursos

Verificación rápida de viabilidad:

**Criterios**:
- ¿Equipo disponible (capacidad básica)?
- ¿Stack tecnológico compatible con arquitectura existente?
- ¿Dependencias externas críticas disponibles?
- ¿Riesgo técnico manejable?

**Veredicto**: Viable / Desafiante / No viable

**Estrategia de fallo**: Si no hay información sobre recursos, marcar como "Desafiante" (default conservador) y documentar en Preguntas abiertas.

### A.4 — Recomendación preliminar y profile

Combina los tres veredictos en una recomendación:

- **Proceder**: los tres veredictos son positivos o levemente parciales. Avanza a Fase B.
- **Proceder condicional**: hay veredictos parciales pero manejables. Avanza a Fase B con preguntas abiertas Importantes documentadas.
- **No proceder**: hay un veredicto bloqueante (Desalineado + Puede esperar + No viable, o combinación que hace la idea inviable). `Ready for: bloqueado`. Fin del workflow.

**Declaración de `profile`** (consumido por el orquestador para activar shortcuts):

- **`lite`**: dogfooding / internal tool / 1-2 personas / greenfield / MVP N=1. Activa stub RICE N=1, connectivity short-form, 1 persona, experiment-design omitido por defecto.
- **`full`**: producto externo / Growth-Scale / N>1. Path completo sin shortcuts.

Criterios para distinguir: si la descripción del producto (heredada de `analizar-idea`) indica un producto interno o herramienta para uso propio, o si el alcance preliminar sugiere una sola funcionalidad cohesiva, declara `lite`. Si es producto externo o el alcance sugiere múltiples funcionalidades, declara `full`. El profile puede refinarse después de la Fase B si el análisis de alcance cambia el panorama.

## Fase B — Analizar Alcance de la Idea

Evalúa si la idea contiene múltiples funcionalidades o una sola:

**Criterios para múltiples funcionalidades**:
- La idea describe varias features independientes que pueden tener PRDs separados
- Ejemplos: "sistema de notificaciones + sistema de archivos + sistema de chat"
- Múltiples bounded contexts impactados
- Timeline > 1 mes para implementación completa
- Requiere múltiples equipos o especialidades
- Tiene componentes naturales que pueden entregarse independientemente

**Criterios para funcionalidad única**:
- La idea describe una feature cohesiva que justifica un solo PRD
- Ejemplos: "alertas de inactividad", "exportar a PDF", "2FA"
- Dominio único o bounded context existente
- Timeline < 1 mes
- Implementable por 1-2 personas
- No tiene componentes naturales independientes

**Estrategia de fallo**: Si no se puede clasificar con confianza (la idea es ambigua o mezcla concerns), marcar como "clasificación ambigua". Documentar preguntas abiertas (Crítica: "¿la idea describe N features independientes o una feature con sub-componentes?"). Dejar que la Fase G decida el avance. No forzar una clasificación.

**Si son múltiples funcionalidades**:
- Dividir en funcionalidades individuales con alcance claro
- Para cada funcionalidad: definir alcance, value proposition, timeline, dependencias
- Generar roadmap de funcionalidades con prioridades relativas

**Si es funcionalidad única**:
- No dividir, pasar directo a evaluación de conectividad
- Generar scope-roadmap con una sola funcionalidad

## Fase C — Generar Scope Roadmap

Usa el template en `assets/scope-roadmap-template.md` y rellena con:

**Análisis de alcance**:
- Tipo: Múltiples funcionalidades / Funcionalidad única
- Justificación: Por qué se clasificó así
- Timeline estimado completo: X semanas

**Estrategia de división** (si aplica):
- Enfoque: Funcionalidades independientes
- Justificación: Por qué este enfoque

**Roadmap de funcionalidades**:

Para cada funcionalidad:
- **Nombre**: Identificador claro
- **Alcance**: Qué incluye esta funcionalidad
- **Value proposition**: Valor principal que entrega
- **Prerequisitos**: Qué necesita antes (dependencias)
- **Timeline**: X semanas estimadas
- **Success criteria**: Cómo validar esta funcionalidad

**Desglose interno de PRDs/funcionalidades**:

Para cada funcionalidad/PRD, desglosar en fases internas:
- Descripción de cada fase
- **Decisiones resueltas** (con fecha): decisiones de diseño ya tomadas, heredadas de `analizar-idea` o resueltas durante esta evaluación
- **Decisiones pendientes**: decisiones que no se pudieron resolver, con opciones enumeradas y trade-offs. Estas son las preguntas abiertas que alimentan la Fase G.

**Notas de modelo**: Aclaraciones de conceptos clave que puedan ser ambiguos (ej: qué constituye una "funcionalidad", criterios de división, definición de bounded context, framing correcto del producto).

**Recomendación de implementación**:
- Empezar con: Funcionalidad X
- Justificación: Por qué este orden
- Next step: `priorizar-roadmap` para priorizar funcionalidades

## Fase D — Clasificar Estado de Avance (preliminar)

Antes de fijar el `Ready for`, clasifica el estado de avance preliminar basado en la clasificación de alcance:

**Si es funcionalidad única**:
- Estado preliminar: `evaluar-conectividad-tecnica`

**Si son múltiples funcionalidades**:
- Estado preliminar: `priorizar-roadmap`

**Si la clasificación es ambigua o la información es insuficiente**:
- Estado preliminar: `bloqueado`

El estado preliminar se refina en la Fase G según las preguntas abiertas (decisiones pendientes) identificadas.

## Fase G — Gate de Avance Condicionado (Preguntas Abiertas)

**Gate obligatorio.** Después de completar el análisis (Fases A–D) y antes de fijar el `Ready for` y escribir el documento final, ejecuta este gate. El documento **no está completo** hasta que Fase G se ejecuta y se documenta, incluso si todas las preguntas se resolvieron inline durante las Fases B/C.

**Principio**: Las preguntas abiertas (decisiones pendientes) no bloquean automáticamente el avance, pero el usuario debe ser alertado y tener la opción de responderlas antes de avanzar. El avance es **condicionado**, no automático. La alerta ocurre **antes de comenzar** la siguiente etapa (fijar el `Ready for` y avanzar al siguiente skill), no después.

### Estados de avance

1. **Inventariar preguntas abiertas**: Reúne todas las decisiones pendientes identificadas en el desglose de fases internas (Fase C) y las preguntas de las estrategias de fallo de Fases A y B, clasificadas por severidad (Crítico / Importante / Menor). Incluye también las preguntas que se resolvieron inline durante el análisis — el inventario debe reflejar todo lo que se identificó, con su estado de resolución.

   **Clasificación de severidad para decisiones pendientes**:
   - **Crítico**: Bloquea la implementación de la funcionalidad (ej: decisión de modelo de distribución sin la cual no se puede estimar alcance/timeline)
   - **Importante**: Afecta calidad o timeline pero no bloquea completamente (ej: UX de selección, multi-paquete sí/no)
   - **Menor**: No bloquea progreso, ideal resolver (ej: versionado independiente vs atado)

2. **Clasificar el estado de avance** (combina con el estado preliminar de Fase D):
   - **Avance bloqueado**: Hay preguntas Críticas sin resolver → `Ready for: bloqueado`
   - **Avance condicionado**: Hay preguntas Importantes sin resolver → `Ready for: [siguiente skill] (condicionado)`. Alerta al usuario con el inventario; ofrece responder ahora o avanzar con default conservador.
   - **Avance libre**: Solo hay preguntas Menores o todas las Críticas/Importantes están resueltas → `Ready for: [siguiente skill]`

3. **Documentar la ejecución del gate**: Con independencia del resultado, añade al documento una subsección "Gate de avance (Fase G)" que registre:
   - Inventario de preguntas identificadas (críticas/importantes/menores) con su estado (resuelta inline / resuelta en gate / pendiente).
   - Si hubo alerta: confirma que se presentó al usuario y qué decidió.
   - Estado final de avance (bloqueado / condicionado / libre) que justifica el `Ready for`.

### Reglas

- **Nunca** omitir la alerta cuando hay preguntas Críticas o Importantes sin resolver.
- **Nunca** marcar `Ready for: [siguiente skill]` (libre) si hay preguntas Importantes o Críticas sin resolver.
- **Nunca** omitir la subsección "Gate de avance (Fase G)" del documento — es la evidencia de que el gate se ejecutó.
- Las preguntas Menores no requieren alerta ni condicionan el avance; se documentan para seguimiento.
- Si todas las preguntas se resolvieron inline durante B/C, el gate sigue documentándose (inventario con estado "resuelta inline", avance libre) — el gate no se omite, se registra como ejecutado sin alerta necesaria.

### Ejemplo canónico — Gate con todas resueltas inline

Cuando todas las decisiones pendientes se resolvieron inline durante B/C (caso más común en ideas bien formadas), la subsección "Gate de avance (Fase G)" del documento se ve así:

```markdown
## Gate de avance (Fase G)

- **Inventario de preguntas identificadas**:
  - [Importante] ¿Formato del manifiesto incluye campo version? — Estado: resuelta inline
  - [Importante] ¿Ubicación del archivo de handoff? — Estado: resuelta inline
  - [Menor] ¿Convención de rutas destino configurable? — Estado: resuelta inline
- **Alerta al usuario**: No necesaria — todas las Críticas/Importantes se resolvieron inline durante el análisis.
- **Estado final de avance**: Libre — `Ready for: priorizar-roadmap`
```

Para el flujo detallado del gate (formato de alerta, manejo de respuestas del usuario, herencia de preguntas pendientes en el siguiente skill, best practices), consultar `assets/open-questions-template.md` sección "Integración con Ready For — Avance Condicionado".

## Salida

Escribe en (formato principal): `docs/<domain>/idea/<IDEA-SLUG>/scope-roadmap.md` (subdirectorio)
Compatibilidad legacy: `docs/<domain>/idea/<IDEA-SLUG>-scope-roadmap.md` (prefijo)

Para la estructura completa del artefacto (header requerido, secciones requeridas, convenciones de formato, estructura del desglose interno, y valores de `Ready for` con links), usa el template en `assets/scope-roadmap-template.md`.

**Resumen de secciones requeridas** (ver template para detalle):
- Header (incluyendo línea `Input:` y `profile`)
- Gate preliminar de viabilidad (Fase A): alineación estratégica, urgencia, recursos, recomendación preliminar, profile
- Análisis de alcance, Estrategia de división, Notas de modelo
- Desglose interno de PRDs/funcionalidades (con fases, decisiones resueltas/pendientes)
- Roadmap de Funcionalidades (tabla resumen + detalle)
- Recomendación de implementación
- Gate de avance (Fase G) — **obligatoria** incluso si todas las preguntas se resolvieron inline
- Preguntas Abiertas (resueltas/pendientes), Checklist de salida, Ready for con link relativo

**Convenciones clave** (ver template para detalle):
- Sin emojis: usa `Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`

### README del dominio (índice)

Si existe `docs/<domain>/README.md` (creado por `analizar-idea`), actualiza la tabla de "Puntos de entrada" con un enlace al scope-roadmap recién generado: `idea/<IDEA-SLUG>/scope-roadmap.md`. Actualiza el árbol de estructura si hay nuevos archivos.

Si no existe `docs/<domain>/README.md`, la creación del README es responsabilidad de `analizar-idea` (primer skill del workflow). `evaluar-alcance-idea` solo actualiza el README existente; si falta, delega la creación a `analizar-idea` y documenta la ausencia como observación en el scope-roadmap.

**Nota**: Si la Fase A recomienda "No proceder", el scope-roadmap se escribe igual con el veredicto de viabilidad y `Ready for: bloqueado`, pero no se actualiza el README con entradas de roadmap — la idea no avanza.

## Checklist de salida

Antes de marcar el skill como terminado, verifica cada ítem. Si alguno es "No", revisa y completa antes de terminar — el documento no está completo hasta que todos pasan.

### Contenido

1. Gate preliminar de viabilidad evaluado correctamente (alineación, urgencia, recursos)
2. Recomendación preliminar justificada (Proceder / Proceder condicional / No proceder)
3. `profile` declarado con justificación (`full` / `lite`)
4. Evaluación correcta del alcance (múltiples funcionalidades vs única)
5. División del alcance cuando fue necesario
6. Identificación de funcionalidades con alcance claro
7. Value proposition definido para cada funcionalidad
8. Timeline estimado realista
9. Dependencias identificadas entre funcionalidades
10. `Ready for` correcto según el estado de avance de la Fase G (o `bloqueado` si la Fase A recomienda No proceder)

### Formato (verificación de convenciones)

11. Header incluye línea `Input:` y `profile` (no la omitas aunque el input sea texto libre del usuario)
12. Sección **"Gate de avance (Fase G)"** presente y documentada con inventario de preguntas, evidencia de alerta (si hubo) y estado final de avance — **obligatoria incluso si todas las preguntas se resolvieron inline**
13. `Ready for` incluye link relativo al siguiente artefacto (o `bloqueado` sin link si la Fase A recomienda No proceder)
14. Sin emojis en el documento — usa texto (`Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`)

## Preguntas Abiertas

Usar template en `assets/open-questions-template.md` para documentar información faltante. El flujo de avance condicionado está definido en la **Fase G** y detallado en la sección "Integración con Ready For — Avance Condicionado" del template.

**Categorías comunes para este skill**:
- Si la visión/plan de trabajo de producto no está clara (Fase A.1)
- Si no hay información sobre fechas límite externas (Fase A.2)
- Si la disponibilidad de recursos es desconocida (Fase A.3)
- Si la idea es ambigua entre múltiples funcionalidades y una funcionalidad con sub-componentes (Fase B)
- Si las dependencias entre funcionalidades no están claras
- Si el timeline estimado no puede calcularse sin resolver decisiones de diseño
- Si los bounded contexts impactados no están claros

**Importante**: Las decisiones pendientes identificadas en el desglose de fases internas (Fase C) y las preguntas de las estrategias de fallo de Fases A y B alimentan directamente el gate de la Fase G. No se avanza al siguiente skill sin pasar por ese gate.
