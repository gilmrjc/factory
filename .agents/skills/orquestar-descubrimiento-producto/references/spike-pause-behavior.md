# Spike: Por qué los skills no hacen las pausas internas

## Hipótesis principal

Los puntos de pausa actuales son **descriptivos**, no **ejecutables**. El skill dice:

> **Puntos de pausa** (detente y pregunta si ocurre):
> - No se puede inferir el **problema central** o el **resultado esperado**.

Pero no hay un **check obligatorio** en el flujo que evalúe si la condición se cumple, ni una **acción explícita** (`STOP`, `PAUSA-ACTIVA`, `PREGUNTA`) que el LLM deba ejecutar. El modelo lee el texto como contexto, no como una instrucción de control.

## Diagnóstico de causas

### 1. Las pausas son notas, no pasos del algoritmo

En `capturar-requerimiento`, `mapear-assumptions` y `validar-viabilidad-producto`, los "Puntos de pausa" aparecen como listas al final de una fase. El flujo principal de la fase no los referencia. El LLM ejecuta Fase A → Fase B → ... sin un momento en el que deba decir "evalúo si aplican las pausas".

### 2. No hay un formato canónico de "pausa activa"

No existe una convención como `STOP: <condición>` o `PAUSA-ACTIVA: <pregunta>` que el LLM aprenda a reconocer como un punto de control. Las instrucciones actuales son variaciones de "detente y pregunta si ocurre", pero la lógica condicional queda implícita.

### 3. El gate final oculta las pausas internas

Los skills terminan con un `status` y `next` en el frontmatter. Si el status sale `ready`, el orquestador avanza. Las pausas internas nunca llegan a materializarse como preguntas al usuario porque el skill prefiere "completar" y dejar preguntas abiertas documentadas.

### 4. El prompt no conecta condición con pregunta exacta

Cada punto de pausa dice qué detectar, pero no qué mensaje emitir. El LLM no sabe qué formular: ¿una pregunta general? ¿varias? ¿bloquear o continuar?

## Propuesta de solución (spike)

### Formato `PAUSA-CHECK`

Crear un protocolo canónico dentro de cada skill. En lugar de "Puntos de pausa", usar bloques explícitos en el flujo de la fase:

```markdown
**PAUSA-CHECK — Antes de continuar**
Para cada criterio, evalúa SI/NO. Si cualquier respuesta es NO, ejecuta `PAUSA-ACTIVA`.

- [ ] ¿El problema central es claro? → SI / NO
- [ ] ¿El resultado esperado es claro? → SI / NO
- [ ] ¿La audiencia afectada es clara? → SI / NO

**PAUSA-ACTIVA**
Si el criterio X es NO:
1. Presenta al usuario el problema detectado.
2. Formula una pregunta concreta y única.
3. Detente y espera la respuesta.
4. Con la respuesta, actualiza el artefacto y re-evalúa el PAUSA-CHECK.
```

### Patrón en `capturar-requerimiento`

Reescribir Fase A como una secuencia de pasos con checks:

```markdown
## Fase A — Analizar Idea Bruta

### Paso 1 — Extraer problema central
Intenta identificar el problema central del input. Si no es posible, ejecuta `PAUSA-ACTIVA` con:
- **Detectado**: No logro identificar el problema central.
- **Pregunta**: "¿Qué problema concreto resuelve esta funcionalidad?"

### Paso 2 — Extraer resultado esperado
...
```

### Patrón para el orquestador

El orquestador no necesita saber los detalles internos: solo debe reconocer cuando un skill no entrega un artefacto final sino una `PAUSA-ACTIVA`. El contrato es:

- Si el skill retorna un artefacto → evalúa handoff.
- Si el skill retorna una `PAUSA-ACTIVA` (sin artefacto) → propaga la pregunta al usuario y reanuda el mismo skill con la respuesta añadida al contexto.

## Criterios de éxito del spike

1. Un skill (recomendado `capturar-requerimiento`) se prueba con el nuevo formato.
2. En una simulación, el skill se detiene cuando falta el problema central y formula una pregunta concreta.
3. El skill no completa el artefacto hasta que el usuario responde o explícitamente acepta avanzar con default conservador.

## Recomendación

No añadir más textos de "Puntos de pausa". Convertir los puntos de pausa en **pasos algorítmicos con checks SI/NO** y **acciones explícitas de pausa**. De lo contrario, seguirán siendo invisibles para el LLM.
