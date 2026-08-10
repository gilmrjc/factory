# Template: Preguntas Abiertas

Template para documentar información faltante e incógnitas que requieren aclaración antes de proceder al siguiente paso del workflow de evaluación de alcance.

## Propósito

Documentar cualquier información faltante, incertidumbres o decisiones pendientes que deben resolverse antes de proceder a la siguiente fase del workflow. Esto asegura que las preguntas abiertas sean visibles y rastreables durante la evaluación de alcance.

## Formato de Documentación

Para cada pregunta abierta, documentar:

1. **Pregunta o issue**: Descripción clara de la incógnita
2. **Impacto**: Cómo afecta esta incógnita a la evaluación de alcance
3. **Severidad**: Crítico / Importante / Menor
4. **Propuesta de resolución**: Cómo se puede resolver

## Severidad Levels

**Crítico**: Bloquea la evaluación de alcance completamente. No se puede proceder sin resolver. Impacto directo en la clasificación de funcionalidad única vs múltiple.

**Importante**: Afecta calidad del análisis o timeline pero no bloquea completamente. Se puede proceder con mitigaciones temporales. Impacto significativo en la precisión del roadmap.

**Menor**: No bloquea la evaluación, pero sería ideal resolver. Procede con incógnita documentada. Impacto limitado o contingente.

## Integración con Status y Next

El avance al siguiente skill no es automático cuando hay preguntas abiertas. Se aplica un **gate de avance condicionado**:

**`status: blocked`**: Hay preguntas **Críticas** sin resolver. No se puede proceder. `next` queda sin definir.

**`status: conditional`**: Hay preguntas **Importantes** sin resolver. El skill debe alertar al usuario antes de avanzar. Si el usuario elige avanzar sin responder, se documenta como "Pendiente, usuario eligió avanzar con default conservador".

**`status: ready`**: No hay preguntas Críticas ni Importantes sin resolver. Pueden haber preguntas Menores. Proceder sin condicionamientos.

## Ejemplo

```markdown
- **Pregunta**: No está claro si la idea describe un sistema de notificaciones completo o solo la infraestructura base
- **Impacto**: No se puede determinar si requiere múltiples PRDs o uno solo
- **Severidad**: Crítico
- **Propuesta**: Realizar experimento mental de implementación y mapeo de código existente
```

1. **Rastreable**: Asignar owner y timeline cuando sea posible
2. **Actualizar**: Revisar periódicamente y marcar como resueltas
3. **Comunicar**: Asegurar que el equipo sea aware de las preguntas abiertas
4. **No bloquear innecesariamente**: Solo marcar como blocked si realmente crítico
5. **Alertar siempre**: Cuando hay preguntas Importantes o Críticas sin resolver, el skill debe alertar al usuario y ofrecer la opción de responder antes de avanzar (avance condicionado). Nunca avanzar en silencio con incógnitas significativas
6. **Heredar pendientes**: Las preguntas que el usuario eligio no resolver en el gate se heredan en el siguiente skill del workflow para que no se pierdan. Documentar con estado "Pendiente, usuario eligio avanzar con default conservador"
