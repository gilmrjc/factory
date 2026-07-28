---
name: planificar-desde-prd
description: >-
  Lee un PRD (Product Requirements Document) y genera una estructura de epics
  con dependencias, criterios de aceptación, y secuencia de implementación.
  Salida: docs/<domain>/<PRD-SLUG>-epic-plan.md con división de trabajo. Valida
  viabilidad técnica contra el codebase existente. Úsalo para descomponer
  iniciativas grandes en epics ordenadas.
argument-hint: "[PRD-RUTA | PRD-CONTENIDO]"
allowed-tools:
  - read
  - grep
  - find_file_by_name
  - write
triggers:
  - user
  - model
---

# Planificador desde PRD

Lee un PRD y estructura epics con criterios de aceptación, dependencias y secuencia de implementación recomendada. Salida: documento de plan de epics listo para atomic task breakdown.

Solo análisis: no crea tickets en tu herramienta de gestión, no implementa. Úsalo al inicio de iniciativas grandes para mapear trabajo.

## Fase 0 — Resolver entrada

Requerido: `PRD-SOURCE`. Infierelo desde:
- Ruta local: `docs/**/*prd*.md`, `docs/**/iniciativa*.md`
- Contenido pegado: si el usuario pega el PRD completo en chat
- URL: si la documentación está en tu herramienta de documentación de referencia

Pregunta cuando falta: "¿Dónde está el PRD? (ruta local, URL, o pega el contenido)"

Declara inputs resueltos antes de proceder.

## Fase A — Validar PRD

Verifica que el PRD contenga:
- ✅ Objetivo de negocio claro
- ✅ Usuario/persona objetivo
- ✅ Criterios de éxito (métricas, KPIs)
- ✅ Restricciones conocidas (tiempo, recursos, tech debt)
- ✅ Alcance explícito (qué SÍ, qué NO)

Si faltan elementos críticos: detente y lista brechas en Preguntas abiertas. No continúes sin objetivo claro.

## Fase B — Analizar Codebase para Viabilidad

1. Identifica 2-3 arquitecturas existentes que el PRD tocará (búsqueda `grep` por dominio/feature)
2. Detecta **deuda técnica conocida** que bloquee features (ej. legacy auth, monolith refactor pending)
3. Busca **precedentes**: features similares ya implementadas
4. Anota **riesgos técnicos**: si el PRD requiere componentes no existentes, lista construcciones nuevas necesarias

## Fase C — Estructurar Epics

Agrupa requerimientos en **3-7 epics** siguiendo el template en `references/epic-structure-template.md`.

**Reglas de épic:**
- Cada epic debe ser **deployable de forma independiente** (feature flag, API nueva, schema migration)
- Si dos epics tienen dependencia fuerte → combínalos o añade "sequential" en orden sugerido
- Máximo 3-4 semanas por epic (si > L, sugiere dividir)

## Fase D — Mapear Dependencias

Crea una tabla de dependencias siguiendo el template en `references/dependency-table-template.md`.

Detecta **ciclos** (A → B → A): si existen, reestructura o explícita "reconciliation point".

## Fase E — Escribir Plan de Epics

Estructura del documento:

1. **Resumen ejecutivo**: objetivo PRD + # epics + timeline grueso
2. **Matriz de epics**: tabla con todos los epics, AC, deps, riesgos, orden
3. **Secuencia recomendada**: "implementa en orden [1, 2, 3…] o paralelo [A||B, luego C]"
4. **Riesgos y mitigaciones**: deuda técnica conocida, construcciones nuevas, integraciones
5. **Preguntas abiertas**: elementos del PRD no clarificados
6. **Ready for siguiente paso**: `divide-epics` (crear estructura de tareas atómicas) o `blocked` si se necesita validación de PRD primero

## Salida

Escribe en: `docs/<domain>/<PRD-SLUG>-epic-plan.md`

**Secciones requeridas**:
- Resumen del PRD leído
- Matriz de epics (tabla)
- Secuencia recomendada con justificación
- Riesgos técnicos identificados
- Preguntas abiertas
- Ready for (`divide-epics` o `blocked`)

Ready for valores:
- `dividir-epic`: Epics está clara, proceder a desglose de tareas atómicas
- `blocked`: Faltan clarificaciones en PRD antes de proceder
- `refine-prd`: PRD necesita refinamiento antes de planificar

## Autoevaluación

Antes de finalizar, verifica:

- [ ] **Inputs completos**: PRD identificado y leído completamente
- [ ] **Validación PRD**: Objetivo, usuario, criterios de éxito, restricciones y alcance están claros
- [ ] **Análisis codebase**: Arquitecturas identificadas, deuda técnica detectada, precedentes encontrados
- [ ] **Epics bien estructurados**: 3-7 epics, cada uno con objetivo, AC, dependencias, riesgos, estimación
- [ ] **Epics deployables**: Cada epic puede desplegarse independientemente
- [ ] **Tamaño de epics**: Ningún epic > 4 semanas (L/XL), si los hay, sugiere división
- [ ] **Dependencias mapeadas**: Tabla completa sin ciclos (o con reconciliation points explícitos)
- [ ] **Secuencia lógica**: Orden recomendado tiene justificación clara
- [ ] **Riesgos documentados**: Riesgos técnicos identificados con mitigaciones
- [ ] **Preguntas abiertas**: Brechas del PRD listadas si existen
- [ ] **Ready for correcto**: Valor apropiado según estado del PRD y epics
- [ ] **Archivo creado**: `docs/<domain>/<PRD-SLUG>-epic-plan.md` con todas las secciones requeridas
