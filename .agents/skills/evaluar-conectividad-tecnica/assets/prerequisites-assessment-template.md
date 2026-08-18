# Template: Prerequisites Assessment

Template para estructurar el artefacto de salida de `evaluar-conectividad-tecnica` en modo codebase-existente o greenfield.

## Table of Contents

- [Objetivo del artefacto](#objetivo-del-artefacto)
- [Frontmatter requerido](#frontmatter-requerido-al-inicio-del-documento)
- [Estructura del documento](#estructura-del-documento)
  - [Resumen Ejecutivo](#resumen-ejecutivo)
  - [Infraestructura Existente](#infraestructura-existente)
  - [Prerequisitos de la Funcionalidad](#prerequisitos-de-la-funcionalidad)
  - [Gaps Identificados](#gaps-identificados)
  - [Evaluación de Conectividad](#evaluación-de-conectividad)
  - [Recomendaciones](#recomendaciones)
  - [Acceptance Criteria](#acceptance-criteria-si-disponibles)
  - [Dependencias](#dependencias)
  - [Matriz de Prerequisitos vs Existentes](#matriz-de-prerequisitos-vs-existentes)
  - [Gate de avance](#gate-de-avance)
  - [Estado de avance](#estado-de-avance)
- [Convenciones de formato](#convenciones-de-formato)
- [Validación de calidad](#validación-de-calidad)
- [Ejemplo de referencia](#ejemplo-de-referencia)

## Objetivo del artefacto

Documento de decisión que responde: ¿el codebase actual soporta la funcionalidad, o qué falta para que la soporte? Registra la infraestructura existente, los prerequisitos, los gaps, el veredicto de conectividad y la recomendación de avance.

## Frontmatter requerido (al inicio del documento)

```yaml
---
idea_slug: <IDEA-SLUG>
funcionalidad_slug: <FUNCIONALIDAD-SLUG>  # slug de la funcionalidad dentro del scope-roadmap
domain: <domain>
date: <YYYY-MM-DD>
skill: evaluar-conectividad-tecnica
modo: codebase-existente | greenfield
input: <ruta del scope-roadmap.md de la idea>
status: ready | conditional | blocked
next: <según veredicto, ver SKILL.md Fase D>
---
```

- **modo**: `codebase-existente` (repo con producto previo) o `greenfield` (repo sin producto previo).
- **status**: `ready` (avance libre), `conditional` (Importantes sin resolver), `blocked` (Críticas sin resolver o información insuficiente). Lógica en el SKILL.md Fase D.
- **next**: la señal de routing al siguiente skill. Presente solo cuando `status` es `ready` o `conditional`.

## Estructura del documento

**IMPORTANTE**:
- Incluye un Table of Contents (TOC) después del título y antes de la primera sección.
- Las secciones son guías: usa listas anidadas o descripción en línea según lo que haga el documento más claro. El objetivo es comunicar, no llenar campos.
- No asignes puntos de complejidad. El esfuerzo se puntúa en `priorizar-roadmap` (Effort, escala 1-10).

### Resumen Ejecutivo

```markdown
## Resumen Ejecutivo

- **Funcionalidad**: [<funcionalidad-slug>]
- **Veredicto**: [Conectado / Parcialmente conectado / Desconectado]
- **Gaps críticos**: [Lista breve, ej. "Ninguno" o "Faltan servicio de push y registro de dispositivos"]
- **Próximo paso**: [capturar-requerimiento / priorizar funcionalidades puente: <primera-puente> / resolver preguntas abiertas]
- **Decisión clave**: [Una oración: ej. La infraestructura crítica existe y los gaps son alcanzables sin funcionalidades puente]
```

### Infraestructura Existente

```markdown
## Infraestructura Existente

- **Auth**: [Tecnología y estado: ej. JWT con sesiones persistentes, roles y permisos. Endpoints /api/auth/* funcionales. O "No existe".]
- **Database**: [Motor, esquema y estado: ej. PostgreSQL 14. Schema reportes con tablas X, Y. Migraciones via Prisma. O "No existe".]
- **APIs**: [Estilo y endpoints relevantes: ej. REST API en Express. Endpoints /api/reports/*. Webhooks implementados. O "No existe".]
- **Servicios**: [Colas, cache, email, etc.: ej. BullMQ en Redis. SendGrid para emails transactionales. O "No existe".]
- **Frontend**: [Framework y patrones: ej. React 18 con TypeScript. SPA con React Router. O "No existe".]
- **Monitoring**: [Logging, métricas, alertas: ej. Winston + Datadog. O "No existe".]
```

En modo greenfield, declara primero: `greenfield: sin infraestructura de producto previa`. Luego evalúa la infraestructura básica del repositorio (gestor de paquetes, contenedores, archivos de configuración, directorios base, convenciones). Deja las dimensiones de producto como "No existe (greenfield)".

### Prerequisitos de la Funcionalidad

```markdown
## Prerequisitos de la Funcionalidad

- **Componentes necesarios**: [Lista: ej. servicio de push, tabla de dispositivos, endpoint de registro]
- **Integraciones requeridas**: [Lista: ej. FCM, APNS, SendGrid]
- **Patrones arquitectónicos**: [Lista: ej. event-driven, cola de jobs]
```

### Gaps Identificados

```markdown
## Gaps Identificados

- **Prerequisitos faltantes**: [Lista con impacto: ej. "Servicio de push no existe" — Impacto alto]
- **Upgrades necesarios**: [Lista con impacto: ej. "Extender SendGrid para fallback de push" — Impacto bajo]
- **Deuda técnica relevante**: [TODOs, FIXMEs, legacy, limitaciones: ej. TODO en `report-service` sobre refactoring de webhooks]
```

### Evaluación de Conectividad

```markdown
## Evaluación de Conectividad

- **Estado**: Conectado | Conectado (greenfield) | Parcialmente conectado | Desconectado
- **Justificación**: [Por qué este veredicto: ej. los prerequisitos críticos existen, los faltantes son alcanzables sin requerir funcionalidades puente, patrones compatibles]
- **Bloqueadores críticos**: [Lista si aplica, o "Ninguno"]
```

### Recomendaciones

```markdown
## Recomendaciones

- **Conectado**: `next: capturar-requerimiento`.
- **Parcialmente conectado**: Decidir con el usuario si avanzar con advertencias o generar funcionalidades puente limitadas.
- **Desconectado**: Generar bridge roadmap y `next: priorizar-roadmap`.
```

### Acceptance Criteria (si disponibles)

```markdown
## Acceptance Criteria

- [AC del epic/funcionalidad si están disponibles en el artefacto fuente, o "No disponibles en esta etapa"]
```

### Dependencias

```markdown
## Dependencias

- **Upstream**: [Artefactos/skills que alimentan este assessment]
- **Downstream**: [Skills que consumen este assessment según el veredicto de conectividad]
```

### Matriz de Prerequisitos vs Existentes

```markdown
## Matriz de Prerequisitos vs Existentes

- **<Prerequisito>**: Existe en codebase: <Sí/No>. Suficiente: <Sí/No>. Acción requerida: <Acción>
```

Esta sección es opcional si ya cubriste el análisis en Infraestructura y Gaps. Úsala cuando quieras una vista consolidada.

### Gate de avance

```markdown
## Gate de avance

- **Inventario de preguntas identificadas**:
  - [Crítica/Importante/Menor] <pregunta>: Estado: resuelta inline | resuelta en gate | pendiente
- **Alerta al usuario**: [No necesaria: todas las Críticas/Importantes resueltas inline | Sí, ver registro]
- **Estado final de avance**: Bloqueado | Condicionado | Libre
```

### Estado de avance

```markdown
## Estado de avance

- **Veredicto de conectividad**: Conectado | Conectado (greenfield) | Parcialmente conectado | Desconectado
- **status**: ready | conditional | blocked
- **next**: [según veredicto, ver Fase D] (omito si blocked)
- **Justificación**: [Por qué este status/next, alineado con el veredicto y el gate]
```

## Convenciones de formato

- Sin emojis en el documento. Usa texto como `Sí`/`Parcial`/`No`.
- Nombres de funcionalidades y slugs en kebab-case.
- Rutas de artefactos y skills en backticks.
- Símbolos tipográficos como `→`, `≥`, `≤` permitidos. Evita el em dash (`—`) como puntuación.

## Validación de calidad

El documento está completo cuando:

1. El frontmatter tiene `idea_slug`, `funcionalidad_slug`, `domain`, `date`, `skill`, `modo`, `input`, `status` y `next` declarados (`next` ausente si `status: blocked`).
2. Table of Contents (TOC) presente después del título y antes de la primera sección.
3. El resumen ejecutivo incluye veredicto, gaps críticos y próximo paso.
4. La infraestructura existente está mapeada (o declarada greenfield).
5. Los prerequisitos de la funcionalidad están listados.
6. Los gaps están identificados con impacto.
7. El veredicto de conectividad cita los criterios del SKILL.md Fase C.
8. El gate de avance está documentado con inventario y estado final.
9. El `status` y `next` del frontmatter son consistentes con el veredicto y el gate.

La autoevaluación (ver `references/autoevaluacion-checklist.md`) es interna: el agente la usa antes de declarar el skill terminado, pero no se incluye en el artefacto final.

## Ejemplo de referencia

Para ver el template con datos reales:

- **Codebase existente**: [references/examples/example-prerequisites-assessment.md](../references/examples/example-prerequisites-assessment.md) — assessment de "notificaciones-push" (veredicto conectado).
- **Greenfield**: [references/examples/example-prerequisites-assessment-greenfield.md](../references/examples/example-prerequisites-assessment-greenfield.md) — assessment de "dashboard-metrics-interno" (veredicto conectado greenfield).

Usa ambos ejemplos como referencia de qué nivel de detalle y formato esperar.
