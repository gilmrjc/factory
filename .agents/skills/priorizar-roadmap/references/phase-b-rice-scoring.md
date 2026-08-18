# Fase B — Cálculo del RICE y la Puntuación RICE (0-100)

## Contenido

- [Preparación: leer y extraer ítems](#preparación-leer-y-extraer-ítems)
- [Fórmula](#fórmula)
- [Escalas](#escalas)
  - [Reach (Alcance)](#reach-alcance)
  - [Impact (Impacto)](#impact-impacto)
  - [Confidence (Confianza)](#confidence-confianza)
  - [Effort (Esfuerzo / Complejidad)](#effort-esfuerzo--complejidad)
  - [Escala de complejidad para Effort](#escala-de-complejidad-para-effort)
- [Ejemplo canónico](#ejemplo-canónico)
- [Puntuación RICE (0-100)](#puntuación-rice-0-100)
  - [Calibración con roadmaps anteriores](#calibración-con-roadmaps-anteriores)
- [Datos faltantes](#datos-faltantes)

## Preparación: leer y extraer ítems

Antes de puntuar, lee el roadmap de entrada y extrae para cada ítem:

- **Nombre**
- **Alcance** (qué incluye y qué no)
- **Value proposition** (qué ganancia entrega)
- **Dependencias** (ítems previos, funcionalidades puente, equipos, aprobaciones u otros requisitos previos)
- **Puntos de complejidad preliminar** (inferir del alcance, fases y dependencias; se usan para el componente `Effort`)

Usa estos datos para asignar `Reach`, `Impact`, `Confidence` y `Effort` con justificación.

## Fórmula

```
RICE = (Reach × Impact × Confidence) / Effort
```

## Escalas

### Reach (Alcance)

- Escala: 1 (pocos usuarios) a 10 (muchos usuarios).
- Periodo: típicamente 1 mes.
- Ejemplo: "Alertas de inactividad" → Reach: 8 (impacta 80% de usuarios activos).

### Impact (Impacto)

- Escala: 0.25 (mínimo) a 3 (masivo).
- Relación con el objetivo principal: retención, ingresos, eficiencia u otros objetivos principales
- Ejemplo: "Alertas de inactividad" → Impact: 2 (alto impacto en retención).

### Confidence (Confianza)

- Escala: 50% (baja confianza) a 100% (alta confianza).
- Refleja cuánta evidencia hay para Reach e Impact.
- Ejemplo: "Alertas de inactividad" → Confidence: 80% (data histórica disponible).

### Effort (Esfuerzo / Complejidad)

- Escala: 1 (trivial) a 10 (muy complejo).
- Unidad: puntos de complejidad, inferidos del alcance, número de fases y dependencias.
- Ejemplo: "Alertas de inactividad" → Effort: 5 (ítem aislado, 3 fases, dependencia de auth-core).

### Escala de complejidad para Effort

Escala interna de complejidad relativa; no mide tiempo de implementación.

| Puntos | Descripción de complejidad |
|---|---|
| 1-2 | Trivial: pocas fases, sin dependencias externas, alcance claro. |
| 3-4 | Simple: 1-2 fases, dependencias conocidas y controladas. |
| 5-6 | Medio: varias fases, dependencias de otros features o decisiones pendientes. |
| 7-8 | Complejo: múltiples bounded contexts, integraciones o alto riesgo técnico. |
| 9-10 | Muy complejo: desconocido, arriesgado o con muchas incógnitas; considerar dividir el ítem. |

Los puntos no miden tiempo de implementación; miden cuánto trabajo *relativo* implica el ítem respecto a los demás.

## Ejemplo canónico

- RICE = (8 × 2 × 0.8) / 3 = 12.8 / 3 = 4.27
- Puntuación RICE = 100 × 4.27 / (4.27 + 1) = 81%

## Puntuación RICE (0-100)

Para que la puntuación sea interpretable y comparable entre distintos roadmaps, normaliza el RICE raw a una escala 0-100 usando un **valor de referencia fijo**:

```
RICE_ref = 1.0
Puntuación RICE = 100 × RICE / (RICE + RICE_ref)
```

**Qué representa el 1.0:** es el RICE de un ítem de referencia canónico:

- Reach: 4
- Impact: 1
- Confidence: 100%
- Effort: 4

Es decir, un ítem sólido y bien entendido: alcance medio (4/10), impacto medio (1), confianza alta y esfuerzo medio (4). Un ítem con `RICE = 1.0` obtiene exactamente `50%`.

**Cómo interpretar la puntuación:**

| RICE raw | Puntuación 0-100 | Significado |
|---|---|---|
| 0.1 | 9% | Mucho peor que el ítem de referencia |
| 0.5 | 33% | Bajo |
| 1.0 | 50% | Igual al ítem de referencia |
| 1.5 | 60% | Bueno |
| 2.0 | 67% | Muy bueno |
| 3.0 | 75% | Excelente |
| 4.27 | 81% | Ejemplo canónico del skill |
| 5.0 | 83% | Excepcional |
| 10.0 | 91% | Cercano al máximo práctico |
| 30.0 | 97% | Cercano al máximo teórico |

La puntuación no depende del máximo del roadmap actual, por lo que `70%` en un roadmap es comparable a `70%` en otro.

Cuando dos ítems tengan puntuaciones 0-100 cercanas (ej. 70% vs 72%), compara sus **RICE raw** para desempatar. La puntuación 0-100 es para comunicación y ranking; el RICE raw conserva la granularidad del cálculo.

### Calibración con roadmaps anteriores

Si existen priorizaciones previas, busca `docs/**/feature-prioritization.md` y revísalas global e intra-dominio:

- Compara los puntos de complejidad (`Effort`) asignados a ítems de alcance similar, tanto en tu dominio como en otros.
- Calcula la mediana de `RICE raw` y `Puntuación RICE` históricas para validar o ajustar el `RICE_ref = 1.0`.
- Si tu dominio tiene suficiente historial, da más peso a su calibración; si no, usa la calibración global de todos los roadmaps disponibles.

Si no hay roadmaps anteriores, aplica directamente la escala interna y el `RICE_ref = 1.0`.

## Datos faltantes

Si falta un componente para un ítem:

1. Intenta inferirlo del contexto (value prop, alcance, fases, dependencias).
2. Si no puedes inferirlo, documentarlo como Pregunta abierta (Crítica/Importante) para Fase G.
3. Usa defaults conservadores solo cuando el usuario apruebe avanzar condicionado.
