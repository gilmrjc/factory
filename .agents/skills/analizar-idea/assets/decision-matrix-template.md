# Template: Matriz de Decisión con Weights

Template para estructurar decisiones de go/no-go con criterios ponderados.

## Estructura básica

La matriz de scoring va en tabla (celdas cortas ≤50 chars). Las justificaciones van en lista debajo de la tabla, no en celdas — la prosa explicativa supera los 50 chars y degrada la legibilidad de la tabla.

**Reglas de formato (no opcionales)**:

- La tabla tiene **exactamente 4 columnas**: `Criterio | Status | Weight | Score`. No añadas una 5ª columna `Justificación` a la tabla — las justificaciones van en lista debajo.
- `Status` usa **texto**, no emojis: `Pass` / `Partial` / `Fail` (o `Sí` / `Parcial` / `No`). No uses `✅` / `⚠️` / `❌`.

| Criterio | Status | Weight | Score |
| ---------- | -------- | -------- | ------- |
| Resultado claro | Pass / Partial / Fail | 25% | 25% / 12.5% / 0% |
| Alineación estratégica | Pass / Partial / Fail | 25% | 25% / 12.5% / 0% |
| Urgencia | Pass / Partial / Fail | 25% | 25% / 12.5% / 0% |
| Recursos básicos | Pass / Partial / Fail | 25% | 25% / 12.5% / 0% |

**Justificaciones** (una por criterio, en lista):

- **Resultado claro**: Por qué este status
- **Alineación estratégica**: Por qué este status
- **Urgencia**: Por qué este status
- **Recursos básicos**: Por qué este status

**Total Score**: Suma de scores (0-100%)
**Recomendación**: Proceder / Proceder condicional / No proceder

## Sistema de scoring

### Status values

**Pass**: Criterio completamente cumplido — Score: 100% del weight asignado. Evidencia clara y convincente.

**Partial**: Criterio parcialmente cumplido — Score: 50% del weight asignado. Evidencia incompleta o ambigua. Requiere aclaración o mitigación.

**Fail**: Criterio no cumplido — Score: 0% del weight asignado. Evidencia insuficiente o contraria. Bloquea o requiere cambios significativos.

### Weight assignment

**Reglas de weight**:
- Suma debe ser 100%
- Criterios críticos deben tener weight ≥ 25%
- Criterios "nice-to-have" pueden tener weight ≤ 15%
- Default: 25% cada uno (4 criterios igualmente importantes)

## Umbrales de decisión

### Proceder (Go)

**Score**: ≥ 80%
**Condiciones**: La mayoría de criterios Pass. Máximo 1 criterio Partial. Ningún criterio crítico Fail.
**Mapeo a status**: `status: ready`, `next: evaluar-alcance-idea` (refinado por Fase G según preguntas abiertas).

### Proceder condicional (Conditional Go)

**Score**: 50-79%
**Condiciones**: Mezcla de Pass y Partial. 1-2 criterios Fail pero no críticos. Condiciones identificadas y mitigables.
**Mapeo a status**: `status: conditional`, `next: evaluar-alcance-idea` (o `status: blocked` según severidad de preguntas abiertas — ver Fase G).

### No proceder (No-Go)

**Score**: < 50%
**Condiciones**: Múltiples criterios Fail. Al menos 1 criterio crítico Fail. Score muy bajo (< 25%).
**Mapeo a status**: `status: blocked` (next se omite).

## Detección de profile (full / lite)

Además del veredicto, declara un campo `profile` que el orquestador (`orquestar-prd-workflow` Fase 0) consume para activar shortcuts lite. Criterios:

- `profile: lite` cuando **al menos 2** de:
  - dogfooding O internal tool (no producto externo)
  - 1-2 personas
  - greenfield (sin codebase de producto previo)
  - stage MVP con N=1 funcionalidad
- `profile: full` cuando:
  - producto externo, O
  - stage Growth/Scale, O
  - N>1 funcionalidades, O
  - requiere validación de demanda externa

El `profile` no reemplaza el veredicto (Proceder/Condicional/No proceder) — es una señal ortogonal sobre cuánta ceremonia aplica el workflow downstream. Un PRD puede ser `Proceder` con `profile: lite` (dogfooding) o `Proceder` con `profile: full` (producto externo Growth).

## Ejemplo canónico — Gate de Discovery (analizar-idea)

| Criterio | Status | Weight | Score |
| ---------- | -------- | -------- | ------- |
| Resultado claro | Pass | 25% | 25% |
| Alineación estratégica | Pass | 25% | 25% |
| Urgencia | Partial | 25% | 12.5% |
| Recursos básicos | Pass | 25% | 25% |

**Justificaciones**:

- **Resultado claro**: Resultado definido sin mencionar solución
- **Alineación estratégica**: Alineado con roadmap Q3
- **Urgencia**: No hay deadline externo pero es importante
- **Recursos básicos**: Equipo disponible, tech stack compatible

**Total**: 87.5% → **Proceder** → `status: ready`, `next: evaluar-alcance-idea`

## Errores comunes

1. **Weights no suman 100%**: Rompe la lógica del scoring
2. **Criterios vagos**: "Se ve bien" no es un criterio evaluable
3. **Justificaciones insuficientes**: Status sin evidencia no es creíble
4. **Umbrales inapropiados**: Demasiado estrictos o muy liberales para el contexto
5. **Ignorar condiciones**: Score alto pero con bloqueadores críticos debe ser Proceder condicional
