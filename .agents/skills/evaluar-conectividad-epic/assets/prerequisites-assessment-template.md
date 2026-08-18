# Assessment de Prerequisitos: <EPIC-SLUG>

Template para estructurar el artefacto de salida de `evaluar-conectividad-epic`.

## Objetivo del artefacto

Documento de decisión que responde: ¿el codebase actual soporta este epic, o qué falta para que lo soporte? Mapea los requisitos técnicos del epic a la infraestructura existente, identifica gaps concretos y fija el veredicto de conectividad y el `Ready for`.

## Frontmatter requerido

```yaml
---
epic_slug: <EPIC-SLUG>
prd_slug: <PRD-SLUG>
domain: <domain>
date: <YYYY-MM-DD>
skill: evaluar-conectividad-epic
input: <ruta a epic-plan.md>
status: ready | conditional | blocked
next: dividir-epic | implementar-bridge
---
```

- **status**: `ready` (avance libre), `conditional` (Importantes sin resolver), `blocked` (Críticas sin resolver o información insuficiente).
- **next**: `dividir-epic` si conectado, `implementar-bridge` si desconectado o parcialmente conectado. Omite `next` si `status: blocked`.

## Herencia del PRD

Si existe `docs/<domain>/initiatives/<PRD-SLUG>/connectivity/prerequisites-assessment.md`, empieza con su veredicto y gaps. Este documento añade el detalle concreto para el epic.

## Resumen del Epic

- **Nombre del Epic**: <EPIC-NOMBRE>
- **Slug**: <EPIC-SLUG>
- **Descripción**: <DESCRIPCIÓN-DEL-EPIC>
- **Acceptance Criteria**: <lista de AC del epic, si están disponibles>

## Requisitos Técnicos del Epic

| Requisito | Detalle para este epic | Crítico |
| --- | --- | --- |
| Auth | <qué flujo o permiso necesita> | Sí/No |
| Database | <tablas/columnas/índices necesarios> | Sí/No |
| APIs | <endpoints/contratos necesarios> | Sí/No |
| Servicios | <colas, caché, búsqueda, etc.> | Sí/No |
| Frontend | <componentes/patrones necesarios> | Sí/No |
| Monitoring | <métricas/logs/alertas específicas> | Sí/No |
| Infraestructura | <recursos cloud/escalado/despliegue> | Sí/No |

## Infraestructura Existente vs Requisitos

Para cada requisito:

- **<Requisito>**
  - **Estado en codebase**: Existe / No existe / Parcial
  - **Suficiente para este epic**: Sí / No / Parcial
  - **Notas**: [capacidad, esquema, endpoint, limitación concreta]

## Gaps Identificados

- **Prerequisitos faltantes**: [lista con impacto en el epic y AC afectados]
- **Prerequisitos insuficientes**: [lista con upgrade necesario]
- **Deuda técnica relevante**: [TODOs, FIXMEs, legacy]

## Veredicto de Conectividad

- **Estado**: Conectado / Parcialmente conectado / Desconectado
- **Justificación**: [cita criterios del SKILL.md Fase D y los gaps concretos]
- **Bloqueadores críticos**: [lista o "Ninguno"]
- **Bloqueadores importantes**: [lista o "Ninguno"]

## Recomendación

- **Si conectado**: Proceder a `dividir-epic`
- **Si parcialmente conectado o desconectado**: Generar `bridge-roadmap.md` con funcionalidades puente y `Ready for: implementar-bridge`

## Gate de avance (Fase D)

Obligatorio. Ver `references/advancement-gate-guide.md`.

## Estado de avance

- **Veredicto de conectividad**: Conectado / Parcialmente conectado / Desconectado
- **status**: ready / conditional / blocked
- **next**: `dividir-epic`, `implementar-bridge` u omitido si blocked
- **Justificación**: [alineado con veredicto y gate]

## Convenciones de formato

- Sin emojis. Usa `Sí`/`Parcial`/`No` o `Conectado`/`Parcialmente conectado`/`Desconectado`.
- Slugs en kebab-case, rutas en backticks, nombres de skills en backticks.
- AC del epic vinculados a cada requisito/gap.
