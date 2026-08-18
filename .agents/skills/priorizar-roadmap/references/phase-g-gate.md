# Fase G — Gate de avance condicionado

## Principio

Las preguntas abiertas no bloquean automáticamente, pero el usuario debe ser alertado y tener la opción de responderlas antes de avanzar. El avance es condicionado, no automático. La alerta ocurre **antes** de fijar el `Ready for` y el `next`.

## Estados de avance

1. **Registra las preguntas abiertas**: Críticas / Importantes / Menores.
   - Incluye las resueltas inline durante las Fases A-E.
   - El inventario refleja todo lo identificado con su estado de resolución.
2. **Clasificar estado de avance**:
   - **Avance bloqueado**: hay preguntas Críticas sin resolver → `status: blocked`, `next` omitido.
   - **Avance condicionado**: hay preguntas Importantes sin resolver → `status: conditional`, `next: evaluar-conectividad-tecnica`. Alertar al usuario; si avanza sin responder, documentar pendientes con default conservador.
   - **Avance libre**: todas las Críticas e Importantes están resueltas → `status: ready`, `next: evaluar-conectividad-tecnica`.

## Documentación del gate

Añade al artefacto una subsección "Gate de avance (Fase G)" con:

- Inventario de preguntas identificadas (críticas/importantes/menores) con estado.
- Si hubo alerta: confirmación de presentación al usuario y decisión.
- Estado final de avance y justificación del `Ready for`.

## Formato de preguntas

Cada pregunta documenta:

- **Severidad**: `Crítico` / `Importante` / `Menor`.
- **Pregunta**: una sola oración concreta.
- **Estado**: `resuelta inline` / `resuelta en gate` / `pendiente`.
- **Impacto** (opcional): por qué afecta al avance.
- **Default conservador** (si aplica): qué asumir si el usuario avanza sin resolver.

Ejemplo:

```markdown
- **[Importante]** ¿Tenemos confirmación del equipo legal para procesar datos sensibles? — Estado: pendiente. Default: asumir que no y limitar el alcance a datos no sensibles en el MVP.
```

Agrúpalas en el artefacto bajo `## Preguntas abiertas` con subsecciones:

- **Críticas**: impiden avanzar sin respuesta.
- **Importantes**: condicionan el avance; se puede avanzar con default conservador.
- **Menores**: documentadas, no condicionan.

## Reglas

- Nunca omitir la alerta cuando hay preguntas Críticas o Importantes sin resolver.
- Nunca marcar `status: ready` con Críticas o Importantes sin resolver.
- Nunca omitir la subsección "Gate de avance (Fase G)".
- Las preguntas Menores se documentan pero no condicionan.
- Si todas las preguntas se resolvieron inline, documentar el gate igual: inventario con "resuelta inline", avance libre.
