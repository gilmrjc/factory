# Guía de Gate de Avance Condicionado

Esta guía define cómo ejecutar el gate de avance condicionado basado en preguntas abiertas identificadas durante el análisis.

## Principio

Las preguntas abiertas no bloquean automáticamente el avance, pero el usuario debe ser alertado y tener la opción de responderlas antes de avanzar. El avance es **condicionado**, no automático. La alerta ocurre **antes de** fijar el `status` y `next` y avanzar al siguiente skill (definido por el veredicto de conectividad en esta misma fase).

## Estados de avance

### 1. Inventariar preguntas abiertas

Reúne todas las preguntas generadas durante las Fases A y B, clasificadas por severidad (Crítica / Importante / Menor). Incluye también las preguntas que se resolvieron inline durante el análisis — el inventario debe reflejar todo lo que se identificó, con su estado de resolución.

**Clasificación de severidad**:

- **Crítica**: bloquea la implementación de la funcionalidad (ej: dependencia externa no confirmada que hace imposible la conectividad).
- **Importante**: afecta calidad o timeline pero no bloquea completamente (ej: versión de API a integrar, patrón arquitectónico a seguir).
- **Menor**: no bloquea progreso, ideal resolver (ej: convención de naming, detalle de monitoring).

### 2. Clasificar el estado de avance

Combina con el veredicto de conectividad de Fase B:

- **Avance bloqueado**: hay preguntas Críticas sin resolver → `status: blocked` (sin `next`).
- **Avance condicionado**: hay preguntas Importantes sin resolver → `status: conditional`, `next: <siguiente>` donde `<siguiente>` se define según el veredicto de conectividad (ver Fase D del SKILL.md). Alerta al usuario con el inventario; ofrece responder ahora o avanzar con default conservador.
- **Avance libre**: solo hay preguntas Menores o todas las Críticas/Importantes están resueltas → `status: ready`, `next: <siguiente>`.

### 3. Documentar la ejecución del gate

Con independencia del resultado, añade al documento una subsección "Gate de avance (Fase D)" que registre:

- Inventario de preguntas identificadas (críticas/importantes/menores) con su estado (resuelta inline / resuelta en gate / pendiente).
- Si hubo alerta: confirma que se presentó al usuario y qué decidió.
- Estado final de avance (bloqueado / condicionado / libre) que justifica el `status` y `next` del frontmatter.

## Reglas

- **Nunca** omitas la alerta cuando hay preguntas Críticas o Importantes sin resolver.
- **Nunca** marques `status: ready` si hay preguntas Importantes o Críticas sin resolver.
- **Nunca** omitas la subsección "Gate de avance (Fase D)" del documento — es la evidencia de que el gate se ejecutó.
- Las preguntas Menores no requieren alerta ni condicionan el avance; se documentan para seguimiento.
- Si todas las preguntas se resolvieron inline durante A o B, el gate sigue documentándose (inventario con estado "resuelta inline", avance libre) — el gate no se omite, se registra como ejecutado sin alerta necesaria.

## Ejemplo canónico — Gate con todas resueltas inline

```markdown
## Gate de avance (Fase D)

- **Inventario de preguntas identificadas**:
  - [Importante] ¿El servicio de auth existente soporta los flujos del PRD? — Estado: resuelta inline
  - [Menor] ¿Versionado de la API interna documentado? — Estado: resuelta inline
- **Alerta al usuario**: No necesaria — todas las Críticas/Importantes se resolvieron inline durante el análisis.
- **Estado final de avance**: Libre — `status: ready`, `next: <según veredicto>`
```

Para el flujo detallado del gate (formato de alerta, manejo de respuestas del usuario, herencia de preguntas pendientes en el siguiente skill, best practices), consulta `_shared/open-questions-template.md` sección "Integración con Ready For — Avance Condicionado".
