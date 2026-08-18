---
name: priorizar-roadmap
description: >-
  Toma un roadmap de funcionalidades (incluidas las funcionalidades puente) y prioriza sus ítems
  usando metodología RICE (Reach, Impact, Confidence, Effort). Genera un
  ranking con justificaciones, dependencias y recomendación de cuál
  implementar primero. Úsalo cuando el usuario tenga múltiples funcionalidades
  y necesite decidir cuál implementar primero. Triggers
  comunes: priorizar, ordenar, decidir qué funcionalidad implementar
  primero, comparar valor vs esfuerzo. No lo uses para planificar épicas
  dentro de un PRD, para evaluar viabilidad técnica a fondo ni para dividir
  un epic en tareas.
---

# Priorizador de Roadmap

Toma un roadmap de funcionalidades (incluidas funcionalidades puente) y produce un ranking priorizado con la metodología RICE. El resultado es un documento de decisión: ordena los ítems por valor vs esfuerzo, deja claro por qué un ítem va antes que otro y señala qué está bloqueado por dependencias.

No define el producto, no evalúa viabilidad técnica ni divide el trabajo en tareas; eso corresponde a skills posteriores.

## Cuándo usarlo y cuándo no

- **Sí**: el usuario ya tiene un scope-roadmap o bridge-roadmap, o una lista de funcionalidades (incluidas funcionalidades puente), y necesita decidir cuál implementar primero.
- **No**: cuando solo haya un ítem predefinido, cuando aún no se conozca el alcance de cada ítem, cuando se requiera evaluar conectividad técnica o viabilidad, o cuando se quieran planificar épicas o dividir en tareas.

NOTA: Al ejecutar las distintas fases, determina las partes que no requieren intervención del usuario y divide las tareas para usar subagentes, ya sea para ejecutarlas en paralelo o de forma consecutiva.

## Fase 0 — Resolver entrada

Requerido: `ROADMAP-ENTRADA` (ruta a `scope-roadmap.md` o `bridge-roadmap.md`, o contenido pegado).

Infiere a partir de:
- Contenido breve: "prioriza el roadmap de X", "ordena las funcionalidades del bridge roadmap", "¿cuál implementamos primero?", "ordena las funcionalidades"
- Artefacto: si existe `docs/<domain>/idea/<IDEA-SLUG>/scope-roadmap.md` (producido por `evaluar-alcance-idea`) o `docs/<domain>/idea/<IDEA-SLUG>/connectivity/bridge-roadmap.md` (producido por `evaluar-conectividad-tecnica`), leerlo para heredar la lista de ítems, alcance, value proposition y dependencias
- Contenido pegado: si el usuario pega el contenido del roadmap, úsalo directamente

Pregunta si falta: "¿Qué roadmap priorizo? (ruta del scope-roadmap, bridge-roadmap, o pega el contenido)" y espera la respuesta.

## Fase A — Eco, diagnóstico y lectura del roadmap

### Eco breve

Devuelve un **eco breve obligatorio** antes de puntuar: resume el input resuelto, número de ítems, nivel (`producto` / `funcionalidad`), dominio y calidad del roadmap (`crudo`, `parcial`, `listo`). Luego pregunta: *"¿Avanzo con esta lectura o corrijo algo?"* y **espera la respuesta**. No extraigas, puntúes ni priorices hasta confirmar.

### Diagnóstico de calidad

Clasifica el roadmap en `crudo` (solo nombres), `parcial` (faltan datos) o `listo` (cada ítem tiene alcance, value prop y evidencia para RICE). Si es `crudo` o `parcial`, identifica las preguntas abiertas y su severidad para Fase G, pero no detengas el flujo salvo que falte el roadmap mismo.

### Caso N=1

Si el roadmap tiene una única funcionalidad, la priorización es trivial: calcula el RICE raw y la Puntuación RICE (0-100) como *revisión de coherencia*, emite el stub de [assets/n1-stub-template.md](assets/n1-stub-template.md) y salta a Fase D y Fase G. No generes ranking ni matriz de dependencias.

## Fase B — Calcular RICE y Puntuación RICE (0-100)

Sigue [references/phase-b-rice-scoring.md](references/phase-b-rice-scoring.md) para leer el roadmap, extraer los ítems y calcular el RICE y la Puntuación RICE (0-100) por ítem.

**Fórmula base:**
```
RICE = (Reach × Impact × Confidence) / Effort
Puntuación RICE (0-100) = 100 × RICE / (RICE + 1)
```

Consulta la guía para escalas, calibración con roadmaps anteriores, normalización 0-100, ejemplo canónico y tratamiento de datos faltantes.

## Fase C — Ajustar por dependencias

### Reglas de ordenamiento

- Ordena primero por dependencias: los ítems desbloqueados van antes que los bloqueados; dentro de los desbloqueados, prioriza los que desbloquean otros.
- Luego, dentro de cada bloque de dependencias, ordena por Puntuación RICE (0-100) de mayor a menor.
- Marca los ítems con dependencias no cumplidas como `Bloqueado` y consérvalos en el ranking con nota de bloqueo.

### Tipos de dependencias

- **Técnicas**: requiere funcionalidad puente, API, migración o infraestructura.
- **Secuenciales**: otro ítem del roadmap debe implementarse primero.
- **Organizacionales**: depende de equipo, permisos o aprobaciones externas.

## Fase D — Generar roadmap priorizado

Rellena el template en [assets/prioritized-roadmap-template.md](assets/prioritized-roadmap-template.md):

- Frontmatter con `status` y `next`
- Resumen de priorización
- Roadmap ordenado por dependencias y, dentro de cada bloque de dependencias, por Puntuación RICE (0-100)
- Recomendación de implementación
- Notas de escala
- Autoevaluación
- Gate de avance (Fase G)
- Preguntas abiertas
- Ready for

No escribas el documento final hasta haber completado las Fases E–G.

## Fase E — Definir Ready for

**Si hay ítems priorizables**:
- `Ready for: evaluar-conectividad-tecnica` con el ítem más prioritario

**Si hay preguntas abiertas sin resolver**:
- `Ready for: blocked` con las preguntas abiertas que impiden avanzar

## Fase F — Actualizar `discovery-state.md` y README del dominio

Después de escribir `feature-prioritization.md`:

1. **Actualiza `discovery-state.md`**: crea o actualiza `docs/<domain>/idea/<IDEA-SLUG>/discovery-state.md`:
   - Copia el ranking de funcionalidades en `## Cola de funcionalidades`.
   - Marca todos los ítems con `estado: pendiente-captura`.
   - Asigna `next` al `FUNCIONALIDAD-SLUG` del ítem más prioritario y `estado: in-progress`.
   - Conserva los estados previos si el archivo ya existe.
2. **Actualiza `docs/<domain>/README.md`**:
   - Añade o refresca la entrada `Ver la priorización de funcionalidades/PRDs del dominio` → `idea/<IDEA-SLUG>/feature-prioritization.md` en la tabla de "Puntos de entrada".
   - Si el README no existe, salta a la Fase G.

## Fase G — Gate de avance condicionado

Sigue [references/phase-g-gate.md](references/phase-g-gate.md), que incluye el formato de preguntas abiertas.

- Registra las preguntas abiertas por severidad (Crítico / Importante / Menor).
- Decide `status` (`ready` / `conditional` / `blocked`) y `next`.
- Documenta la ejecución del gate en el artefacto.
- No definas el `Ready for` ni escribas el artefacto final hasta completar esta fase.

## Salida

Escribe en: `docs/<domain>/idea/<IDEA-SLUG>/feature-prioritization.md`.

El documento sigue la estructura de [assets/prioritized-roadmap-template.md](assets/prioritized-roadmap-template.md).

## Checklist de salida

Verificación final, no parte del artefacto. Antes de terminar, aplica el checklist de [references/autoevaluacion-checklist.md](references/autoevaluacion-checklist.md) y verifica estos ítems adicionales:

- `status` y `next` van en el frontmatter, no en el body.
- Sin emojis en el documento.
