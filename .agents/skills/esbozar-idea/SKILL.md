---
name: esbozar-idea
description: >-
  Inicia un chat interactivo para esbozar y pulir una idea de producto bruta
  hasta convertirla en un esbozo ligero y bien formado que sirve como entrada
  a analizar-idea. Conduce un diálogo de ida y vuelta enfocado en el resultado
  deseado (sin soluciónizar), beneficiarios y motivación, sin entrar en
  viabilidad, alcance, priorización ni detalles técnicos. Salida:
  docs/drafts/<IDEA-SLUG>/esbozo.md. Úsalo cuando el usuario tenga una idea
  muy verde o vaga que no está lista para analizar-idea, y quiera darle forma
  interactiva antes de avanzar. No lo usas para evaluar viabilidad (usa
  analizar-idea), estructurar requerimientos formales (usa
  capturar-requerimiento), dividir alcance (usa evaluar-alcance-idea) ni
  generar PRDs (usa generar-prd o orquestar-prd-workflow).
---

# Esbozador de Ideas

Inicia un chat interactivo que esboza y pule una idea bruta hasta dejarla lista para `analizar-idea`. El esbozo es deliberadamente ligero: declara el resultado deseado sin mencionar la solución, quién se beneficia y por qué ahora — nada más. El detalle (viabilidad, alcance, priorización, personas, casos de uso, PRD) es trabajo de skills posteriores.

Solo formulación interactiva: no evalúa viabilidad, no aprueba, no estructura requerimientos formales. Prepara la idea para que `analizar-idea` pueda evaluarla sin tener que reformularla primero.

## Cuándo usarlo y cuándo no

- **Sí**: el usuario tiene una idea muy verde o vaga que no está lista para `analizar-idea`, y quiere pulirla interactivamente antes de avanzar. También cuando el usuario pide "esbozar", "dar forma a", "pulir", "redactar" o "aclarar" una idea.
- **No**: para evaluar viabilidad (usa `analizar-idea`), estructurar requerimientos formales (usa `capturar-requerimiento`), dividir alcance (usa `evaluar-alcance-idea`), priorizar (usa `priorizar-roadmap`), definir personas (usa `definir-usuarios`) o generar PRDs (usa `generar-prd` o `orquestar-prd-workflow`). Tampoco para reanudar trabajo ya iniciado — si ya existe un `idea-analysis.md` producido por `analizar-idea`, este skill no aplica.

## Fase 0 — Resolver entrada

Requerido: `IDEA-DESCRIPCION` (texto libre, por vago que sea).

Infiere desde:
- Descripción pegada: si el usuario pega la idea/solicitud/fragmento de chat/email.
- Idea expresada en el mensaje: "Quiero algo para que la gente exporte reportes", "estaría bueno notificar a los usuarios", "modo oscuro".
- Archivo abierto en el IDE: si la metadata lista un archivo abierto cuyo contenido es una idea bruta no estructurada, úsalo y cita la ruta.

Pregunta cuando falta: "¿Cuál es la idea que quieres esbozar? (puede ser vaga — la puliremos juntos)"

Declara inputs resueltos: idea capturada (preserva el texto original del usuario para la sección "Resumen de la idea").

Genera `IDEA-SLUG` en kebab-case a partir del resultado o, si el resultado aún no está claro, de la frase más representativa de la idea (ej. "exportar reportes a PDF" → `exportar-reportes-pdf`). El slug puede refinarse en la Fase C si el diálogo aclara el resultado.

## Fase A — Eco y diagnóstico inicial

Devuelve al usuario un eco breve de lo que entendiste y un diagnóstico inicial de qué tan lista está la idea para pasar a `analizar-idea`.

**Diagnóstico** (clasifica la idea en uno de estos estados):

- **Verde**: solo una frase suelta, sin resultado claro ni beneficiario. Necesita diálogo completo.
- **Borrador**: hay un resultado implícito y algún beneficiario, pero está mezclado con solución o falta claridad. Necesita diálogo focalizado.
- **Casi lista**: el resultado está claro y sin solución, hay beneficiario y motivación. Diálogo mínimo de confirmación.

Presenta el diagnóstico al usuario y confirma que quiere pulirla antes de avanzar. Si el usuario ya trae una idea bien formada (estado "Casi lista"), ofrece saltar directamente a `analizar-idea` en lugar de forzar el diálogo.

## Fase B — Diálogo de pulido interactivo

Conduce un diálogo de ida y vuelta con el usuario. **No soluciónices**: el objetivo es clarificar el resultado deseado, no diseñar la solución. Si el usuario empieza a proponer solución, redirígelo al resultado ("¿Qué quieres lograr con eso?").

Haz **como máximo 3 rondas** de preguntas. Cada ronda agrupa 1–3 preguntas relacionadas. No interroges al usuario con un cuestionario largo de una sola vez — el pulido es conversacional.

### Preguntas núcleo (cubren el mínimo para pasar a `analizar-idea`)

1. **Resultado deseado**: ¿Qué resultado o estado quieres lograr? (describe el estado deseado, no la funcionalidad). Criterio de resultado válido (mismo que `analizar-idea` Fase A):
   - Describe el resultado/estado, no la funcionalidad
   - Es medible u observable
   - No menciona tecnología o implementación
   - Responde a "¿Qué queremos lograr?" no "¿Qué vamos a construir?"

   Si el usuario no puede formularlo sin solución, ayúdalo a reformular con ejemplos (ver abajo). Si tras 2 intentos no se logra, marca como "necesita reformulación" y documenta en Preguntas abiertas — el esbozo puede escribirse igual con el resultado marcado como pendiente, y `analizar-idea` lo detectará.

2. **Beneficiarios**: ¿Quién se beneficia de ese resultado? (light — un rol o segmento, no personas detalladas; las personas formales las define `definir-usuarios`).

3. **Motivación**: ¿Por qué ahora? (light y opcional — fecha límite, bloqueante, oportunidad sensible al tiempo, o "puede esperar". No es el análisis de urgencia de `analizar-idea`, solo el contexto que el usuario tenga a mano).

### Preguntas opcionales (solo si surgen naturalmente del diálogo)

4. **Fuera de alcance**: ¿Hay algo que explícitamente NO incluye esta idea? (light — ayuda a `evaluar-alcance-idea` a no inflar el PRD).

5. **Contexto adicional**: cualquier nota, referencia o restricción que el usuario quiera registrar sin desarrollar.

### Ejemplos de reformulación de solución → resultado

- Solución: "Implementar sistema de notificaciones" → Resultado: "Los usuarios están informados sobre eventos importantes en tiempo real"
- Solución: "Agregar modo oscuro" → Resultado: "Los usuarios pueden usar el producto cómodamente en ambientes con poca luz"
- Solución: "Hacer un export a PDF" → Resultado: "Los usuarios pueden llevarse un registro durable de sus datos fuera del producto"

### Reglas del diálogo

- **No soluciónices**: si el usuario propone "quiero un dashboard con X", pregunta "¿Qué decisión o acción quieres que alguien pueda tomar con eso?".
- **No evalúes viabilidad**: no juzgues si la idea es viable, alineada o prioritaria — eso es `analizar-idea`. Tu trabajo es que el resultado esté claro, no que sea buena idea.
- **No dividas alcance**: si la idea parece contener múltiples funcionalidades, no la dividas — documenta la sospecha en Preguntas abiertas y deja que `evaluar-alcance-idea` haga el split.
- **No profundices en personas/casos de uso/métricas**: un rol o segmento basta. Lo demás es de skills posteriores.
- **Mantén ligereza**: el esbozo no debe tener muchos detalles. Si el usuario empieza a detallar requisitos, redirígelo: "eso lo trabaja el skill siguiente — aquí lo dejamos como nota".

## Fase C — Consolidar esbozo

Tras el diálogo, consolida el esbozo en el artefacto usando el template en `assets/esbozo-template.md`. Estructura:

1. **Header**: Idea slug, Fecha, Skill: esbozar-idea, Input: texto original del usuario (preserva el input literal).
2. **Resumen de la idea**: el input original del usuario, sin reformular (para contexto).
3. **Resultado deseado**: 1–2 frases del resultado/estado deseado, sin mención de solución. Si no pudo formularse sin solución, marcar como "necesita reformulación" y dejar el mejor intento.
4. **Beneficiarios**: rol o segmento (light).
5. **Motivación**: por qué ahora (light, opcional — "no especificada" es un valor válido).
6. **Fuera de alcance**: lo que explícitamente no incluye (light, opcional).
7. **Notas adicionales**: contexto o restricciones breves del usuario (opcional).
8. **Preguntas abiertas**: incógnitas que el usuario no resolvió en el diálogo y que hereda el skill siguiente (clasificadas por severidad Crítico/Importante/Menor). Usar el template en `assets/open-questions-template.md` para el formato.
9. **Ready for**: `analizar-idea` / `orquestar-prd-workflow` / `bloqueado` (ver Fase D).

**Convenciones de formato**: sin emojis. Usa texto (`Sí`/`Parcial`/`No`, `Pass`/`Partial`/`Fail` cuando aplique). Símbolos tipográficos estándar (`→`, `—`) permitidos.

## Fase D — Gate de listo para `analizar-idea`

**Gate obligatorio.** Antes de fijar el `Ready for` y escribir el documento final, verifica que el esbozo está listo para pasar a `analizar-idea`.

### Criterios de readiness

- **Resultado claro**: el resultado está formulado sin mención de solución Y es medible/observable → avanza libre.
- **Resultado parcial**: el resultado está formulado pero mezcla solución, o es observable pero ambiguo → avanza condicionado (documenta en Preguntas abiertas; `analizar-idea` Fase A lo detectará y reformulará).
- **Resultado bloqueado**: no pudo formularse ningún resultado sin solución tras 2 intentos → `bloqueado`. El esbozo se escribe igual (con el mejor intento y la marca "necesita reformulación"), pero el `Ready for` es `bloqueado` y se invita al usuario a reformular manualmente antes de reintentar.

### Mapeo a Ready for

- Avance libre → `analizar-idea` (o `orquestar-prd-workflow` si el usuario prefiere orquestar). Link relativo al siguiente artefacto: `../../<domain>/idea/<IDEA-SLUG>/idea-analysis.md` (a crear por `analizar-idea`).
- Avance condicionado → `analizar-idea (condicionado)`. Las preguntas Importantes pendientes se heredan en `analizar-idea`.
- Bloqueado → `bloqueado`. No avanza hasta reformular.

### Documentación del gate

Añade al esbozo una subsección "Gate de avance (Fase D)" que registre:
- Estado del resultado (claro / parcial / bloqueado) con justificación.
- Preguntas abiertas identificadas (críticas/importantes/menores) con su estado (resueltas inline / pendientes).
- Estado final de avance (libre / condicionado / bloqueado) que justifica el `Ready for`.

El gate se documenta siempre, incluso si el resultado está claro y no hay preguntas pendientes (inventario vacío, avance libre).

## Salida

Escribe en: `docs/drafts/<IDEA-SLUG>/esbozo.md`

Es un **artefacto temporal de staging**: vive fuera de `docs/<domain>/` porque la idea aún no está comprometida con un dominio. Cuando `analizar-idea` se ejecute, producirá el artefacto durable `docs/<domain>/idea/<IDEA-SLUG>/idea-analysis.md`; el esbozo puede mantenerse como trazabilidad del diálogo previo o eliminarse a discreción del usuario.

Para la estructura completa del artefacto (header, secciones, convenciones, valores de `Ready for` con links), usa el template en `assets/esbozo-template.md`.

### README del dominio (índice)

Este skill **no** crea ni actualiza `docs/<domain>/README.md` — el esbozo es pre-dominio y temporal. La creación del índice de dominio es responsabilidad de `analizar-idea`.

## Checklist de salida

Antes de marcar el skill como terminado, verifica cada ítem. Si alguno es "No", revisa y completa antes de terminar.

### Contenido

1. Resultado deseado formulado (o marcado como "necesita reformulación" tras 2 intentos)
2. Resultado, cuando está formulado, no menciona solución ni tecnología
3. Beneficiarios registrados (al menos un rol o segmento, o "no especificado")
4. Input original del usuario preservado en "Resumen de la idea"
5. `Ready for` correcto según el estado de avance de la Fase D

### Formato

6. Header incluye línea `Input:` con el texto original del usuario
7. Sin emojis en el documento (usa texto: `Sí`/`Parcial`/`No`, `Pass`/`Partial`/`Fail`)
8. Sección **"Gate de avance (Fase D)"** presente y documentada con estado del resultado, inventario de preguntas y estado final de avance — obligatoria incluso si el resultado está claro
9. `Ready for` incluye link relativo al siguiente artefacto (cuando no es `bloqueado`)
10. El esbozo es ligero: no contiene requisitos formales, personas detalladas, casos de uso, métricas ni diseño de solución (esos son de skills posteriores)

## Preguntas Abiertas

Usa el template en `assets/open-questions-template.md` para documentar incógnitas no resueltas durante el diálogo. Estas preguntas se heredan en `analizar-idea` y alimentan su gate de avance.

**Categorías comunes para este skill**:
- El resultado no pudo formularse sin mencionar solución (Crítico — bloquea el avance)
- El beneficiario no está claro (Importante — `analizar-idea` puede avanzar con default conservador)
- La motivación/temporización no está especificada (Menor — no condiciona el avance)
- Sospecha de múltiples funcionalidades en una sola idea (Importante — lo resuelve `evaluar-alcance-idea`)

**Importante**: las preguntas abiertas generadas en la Fase B alimentan directamente el gate de la Fase D. No se avanza con preguntas Críticas sin resolver.
