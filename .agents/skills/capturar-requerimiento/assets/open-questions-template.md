# Template: Preguntas Abiertas

Template para documentar información faltante, incógnitas y decisiones pendientes que requieren aclaración antes de proceder.

## Propósito

Asegurar que los unknowns sean visibles y rastreables. Este template se usa durante `capturar-requerimiento` para estructurar preguntas antes de `mapear-assumptions` o `validar-viabilidad-producto`.

## Categorías de unknowns

- **Información faltante**: Datos o contexto que no está disponible.
- **Incertidumbre técnica**: Aspectos técnicos no resueltos.
- **Ambigüedad de requisitos**: Requerimientos que no son claros.
- **Dependencias externas**: Elementos fuera de control que afectan el proyecto.
- **Riesgos identificados**: Riesgos conocidos que requieren mitigación.

## Formato de documentación

Para cada pregunta abierta, documentar:

1. **Pregunta**: Descripción concreta del unknown.
2. **Categoría**: Una de las categorías anteriores.
3. **Impacto**: Cómo afecta este unknown al proyecto si no se resuelve.
4. **Severidad**: Crítica | Importante | Menor.
5. **Propuesta de resolución**: Cómo se puede resolver.

## Severidad

- **Crítica**: Bloquea el avance. No se puede proceder sin resolver.
- **Importante**: Afecta calidad o alcance, pero no bloquea completamente. El skill debe alertar al usuario y ofrecer avanzar con default conservador.
- **Menor**: No bloquea progreso. Se documenta para seguimiento.

## Ejemplo

```markdown
### Preguntas Abiertas

- **Pregunta**: ¿Qué canales de notificación soporta el MVP?
  - **Categoría**: Ambigüedad de requisitos
  - **Impacto**: Define alcance y tecnologías a integrar
  - **Severidad**: Importante
  - **Propuesta**: Confirmar canales mínimos (email, push, in-app) antes del siguiente paso del workflow
```
