---
name: capturar-requerimiento
description: >-
  Captura y estructura un requerimiento bruto de producto (idea, feature,
  problema). Genera documento con: problema, usuarios afectados, solución
  propuesta, restricciones. Salida:
  docs/<domain>/<REQ-SLUG>-requirements.md. Punto de entrada para
  workflow PRD. Úsalo para estructurar ideas antes de validación de viabilidad.
argument-hint: "[IDEA-DESCRIPCION | BREVE]"
allowed-tools:
  - read
  - grep
  - find_file_by_name
  - write
triggers:
  - user
  - model
---

# Capturador de Requerimientos

Captura y estructura un requerimiento de producto bruto. Transforma una idea vagaba o descripción informal en documento estructurado listo para validación.

Solo documentación: no valida, no aprueba. Estructura la idea.

## Fase 0 — Resolver entrada

Requerido: `IDEA-DESCRIPCION` o `BREVE`.

Infiere desde:
- Descripción pegada: si el usuario pega la idea/feature request
- Contenido breve: "Agregar dark mode", "Sistema de notificaciones", etc.
- Email o chat snippet: si el usuario copia descripción informal

Pregunta cuando falta: "¿Cuál es la idea que capturo? (descripción breve o completa)"

Declara inputs resueltos: idea capturada.

## Fase A — Analizar Idea Bruta

Lee la descripción e identifica:
1. **Problema central**: ¿Qué problema resuelve?
2. **Contexto**: ¿Por qué importa ahora?
3. **Solución propuesta**: ¿Qué se propone?
4. **Actores**: ¿Quiénes están involucrados?
5. **Restricciones mencionadas**: tiempo, presupuesto, tech, etc.

## Fase B — Estructurar Requerimiento

Genera documento con secciones:

```
### 1. Problema
**Declaración de problema**: 
[En 2-3 oraciones, qué problema existe]

Ejemplo:
"Los usuarios no reciben notificaciones importantes de su cuenta, 
causando que se pierdan oportunidades de engagement. 
Actualmente no hay sistema de notificaciones."

### 2. Audiencia Afectada
- **Usuarios primarios**: [Quién sufre el problema más]
- **Usuarios secundarios**: [Quién se beneficia indirectamente]
- **Internos**: [Product, Sales, Support, etc.]

Ejemplo:
- Primarios: Usuarios activos (ej: 5K diarios)
- Secundarios: Nuevos usuarios (onboarding)
- Internos: CS team (reduce tickets), Product

### 3. Solución Propuesta
**Descripción de alto nivel**: 
[Qué se va a construir, en lenguaje simple]

Ejemplo:
"Sistema de notificaciones que alerta a usuarios sobre:
- Nuevo mensaje (email + push si enabled)
- Cambio en su cuenta (email)
- Oportunidad time-sensitive (push + email)

Con preferencias: los usuarios eligen qué y cómo recibir notificaciones."

### 4. Restricciones Conocidas
- **Timing**: [Cuándo se necesita, si hay deadline]
- **Recursos**: [Equipo disponible, restricciones]
- **Técnicas**: [Tech stack obligatorio, sistemas existentes que afecta]
- **Negocio**: [Budget si es conocido, prioridad relativa]

Ejemplo:
- Timing: "Necesitado antes de Q3 feature launch"
- Recursos: "1 backend dev, 1 frontend dev"
- Técnicas: "Debe integrar con email service existente (SendGrid)"
- Negocio: "Part of retention initiative, high priority"

### 5. Preguntas Abiertas
[Lo que NO se sabe y necesita clarificación]

Ejemplo:
- ¿Qué canales de notificación? (email only, SMS, push?)
- ¿Qué frecuencia máxima? (evitar spam)
- ¿Integración con sistema de analytics existente?
- ¿Soporte para webhooks de terceros?
```

## Fase C — Validar Completitud

Checklist:
- ✅ ¿Problema está claro?
- ✅ ¿Usuarios identificados?
- ✅ ¿Solución propuesta descrita?
- ✅ ¿Restricciones documentadas?
- ✅ ¿Preguntas abiertas listadas?

Si algo falta, agregarlo o listarlo en preguntas abiertas.

## Fase D — Escribir Requerimiento Capturado

Estructura:

1. **Resumen ejecutivo**: 1-2 oraciones del requerimiento
2. **Problema**: Descripción clara del pain point
3. **Audiencia afectada**: Primarios, secundarios, internos
4. **Solución propuesta**: Descripción de alto nivel
5. **Restricciones**: Timing, recursos, técnicas, negocio
6. **Preguntas abiertas**: Qué se necesita clarificar
7. **Ready for**: `validar-viabilidad-producto`

## Salida

Escribe en: `docs/<domain>/<REQ-SLUG>-requirements.md`

**Secciones requeridas**:
- Resumen ejecutivo
- Descripción del problema
- Audiencia afectada (primaria, secundaria, interna)
- Solución propuesta (alto nivel)
- Restricciones conocidas
- Preguntas abiertas
- Ready for (`validar-viabilidad-producto`, `blocked` si información crítica falta)

Ready for valores:
- `validar-viabilidad-producto`: Requerimiento estructurado, proceder a validación
- `blocked`: Información crítica faltante, no proceder hasta aclarar

---

## Ejemplo Completo

```markdown
# Requirements: Sistema de Notificaciones

## Resumen
Implementar sistema centralizado de notificaciones para alertar a usuarios 
sobre eventos importantes en tiempo real, mejorando engagement y retención.

## Problema
Usuarios pierden oportunidades importantes porque no reciben alertas sobre 
cambios en su cuenta o eventos time-sensitive. Actualmente 30% abandona sin 
reconocer oportunidades debido a falta de comunicación.

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

## Restricciones
- Timing: Before Q3 feature launch (8 semanas)
- Recursos: 1 backend, 1 frontend, 1 QA
- Tech: Usar SendGrid existente, integrar con analytics
- Negocio: High priority (retention iniciativa)

## Preguntas Abiertas
- ¿Frecuencia máxima? (evitar spam)
- ¿Soportar webhooks third-party?
- ¿A/B test en diferentes cadencias?
```
