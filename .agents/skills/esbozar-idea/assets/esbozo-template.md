# Template: Esbozo de Idea

Template para estructurar el artefacto de salida de `esbozar-idea`. El agente sigue este formato al escribir `docs/drafts/<IDEA-SLUG>/esbozo.md`.

El esbozo es un **artefacto temporal de staging** previo a `analizar-idea`. Es deliberadamente ligero: declara el resultado deseado sin solución, beneficiarios y motivación. El detalle (viabilidad, alcance, priorización, personas, casos de uso, PRD) es trabajo de skills posteriores.

## Header requerido (al inicio del documento)

- Idea slug
- Fecha
- Skill: esbozar-idea
- Input: texto original del usuario (preserva el input literal, por vago que sea). **No omitas la línea `Input:`** aunque el input sea texto libre pegado por el usuario.

## Secciones requeridas

- Header requerido (al inicio del documento, incluyendo línea `Input:`)
- Resumen de la idea (input original del usuario, sin reformular — preserva el texto literal para contexto)
- Resultado deseado (1–2 frases, sin mención de solución). Si no pudo formularse sin solución, marcar como "necesita reformulación" y dejar el mejor intento.
- Beneficiarios (rol o segmento, light — "no especificado" es un valor válido)
- Motivación (por qué ahora, light y opcional — "no especificada" es un valor válido)
- Fuera de alcance (lo que explícitamente no incluye, light, opcional — omítelo si no surgió del diálogo)
- Notas adicionales (contexto o restricciones breves del usuario, opcional — omítelo si no aplica)
- Gate de avance (Fase D): estado del resultado (claro / parcial / bloqueado) con justificación, inventario de preguntas identificadas (críticas/importantes/menores) con estado de resolución, y estado final de avance que justifica el `Ready for`. **Obligatoria** incluso si el resultado está claro y no hay preguntas pendientes.
- Preguntas Abiertas (resueltas/pendientes): documenta incógnitas no resueltas durante el diálogo, clasificadas por severidad. Las pendientes se heredan en `analizar-idea`.
- Checklist de salida (validación de contenido + formato)
- Ready for (`analizar-idea`, `analizar-idea (condicionado)`, `orquestar-prd-workflow`, o `bloqueado`) con link relativo al siguiente artefacto cuando no es `bloqueado`

## Convenciones de formato del documento

- Sin emojis en el documento (resultado, gate, checklist de salida). Usa texto: `Sí`/`Parcial`/`No`, `Pass`/`Partial`/`Fail`. Símbolos tipográficos estándar (`→`, `—`, `≥`, `≤`) sí están permitidos.
- El esbozo es ligero: **no** incluyas requisitos formales, personas detalladas, casos de uso, métricas de éxito, diseño de experimentos ni diseño de solución. Esos son trabajo de skills posteriores. Si el usuario los mencionó durante el diálogo, resúmelos en una sola línea bajo "Notas adicionales" sin desarrollarlos.

## Lligereza: qué NO va en el esbozo

Estos contenidos pertenecen a skills posteriores y **no** deben desarrollarse en el esbozo:

- Análisis de viabilidad (alineación, urgencia, recursos) → `analizar-idea`
- Requerimientos formales estructurados → `capturar-requerimiento`
- División de alcance / múltiples funcionalidades → `evaluar-alcance-idea`
- Priorización RICE → `priorizar-roadmap`
- Conectividad técnica / features puente → `evaluar-conectividad-tecnica`
- Mapeo de assumptions → `mapear-assumptions`
- Personas detalladas → `definir-usuarios`
- Casos de uso (happy path, edge cases) → `mapear-casos-uso`
- Métricas de éxito / diseño de experimentos → `disenar-experimentos`
- PRD → `generar-prd`

Si el usuario introdujo alguno de estos durante el diálogo, regístralo como nota breve en "Notas adicionales" o como Pregunta abierta, sin desarrollarlo.

## Ready for valores (con link relativo al siguiente artefacto)

- `analizar-idea`: Resultado claro, sin mención de solución, medible/observable. Avance libre (sin preguntas Críticas/Importantes sin resolver). Link: `../../<domain>/idea/<IDEA-SLUG>/idea-analysis.md` (a crear por `analizar-idea`).
- `analizar-idea (condicionado)`: Resultado formulado pero mezcla solución o es ambiguo; o hay preguntas Importantes sin resolver. El usuario fue alertado y eligió avanzar. Las preguntas pendientes se heredan en `analizar-idea`. Link: `../../<domain>/idea/<IDEA-SLUG>/idea-analysis.md`.
- `orquestar-prd-workflow`: Mismo criterio que `analizar-idea` (avance libre), cuando el usuario prefiere orquestar en lugar de invocar skills individuales. El orquestador arranca en `analizar-idea` igual.
- `bloqueado`: El resultado no pudo formularse sin solución tras 2 intentos. No avanza hasta reformular. Sin link (no hay siguiente artefacto hasta reformular).

## Ejemplo canónico — Esbozo con resultado claro

```markdown
# Esbozo: exportar-reportes-pdf

- Idea slug: exportar-reportes-pdf
- Fecha: 2026-08-02
- Skill: esbozar-idea
- Input: "estaría bueno que la gente se pueda llevar sus reportes"

## Resumen de la idea
"estaría bueno que la gente se pueda llevar sus reportes"

## Resultado deseado
Los usuarios pueden llevarse un registro durable de sus reportes fuera del producto, en un formato que puedan archivar o compartir sin depender de la plataforma.

## Beneficiarios
Usuarios finales que consumen reportes (no especificado cuáles — lo define `definir-usuarios`).

## Motivación
No especificada.

## Fuera de alcance
No surge del diálogo.

## Notas adicionales
El usuario mencionó "PDF" como ejemplo, pero se redirigió al resultado para no soluciónizar.

## Gate de avance (Fase D)
- **Estado del resultado**: Claro — formulado sin mención de solución, medible (registro durable fuera de la plataforma).
- **Inventario de preguntas identificadas**:
  - [Menor] ¿Qué formatos específicos? — Estado: pendiente (lo trabaja un skill posterior, no bloquea).
- **Estado final de avance**: Libre — `Ready for: analizar-idea`.

## Preguntas Abiertas
- **Pregunta**: ¿Qué formatos específicos de exportación soportar?
- **Impacto**: No bloquea el esbozo; un skill posterior lo resolverá en `capturar-requerimiento` / `mapear-casos-uso`.
- **Severidad**: Menor
- **Propuesta**: Heredar en `analizar-idea`.

## Checklist de salida
1. Resultado deseado formulado: Sí
2. Resultado no menciona solución: Sí
3. Beneficiarios registrados: Sí
4. Input original preservado: Sí
5. Ready for correcto: Sí
6. Header incluye Input: Sí
7. Sin emojis: Sí
8. Gate de avance (Fase D) documentado: Sí
9. Ready for con link relativo: Sí
10. Esbozo ligero (sin requisitos/personas/casos de uso/métricas): Sí

## Ready for
[analizar-idea](../../<domain>/idea/exportar-reportes-pdf/idea-analysis.md)
```
