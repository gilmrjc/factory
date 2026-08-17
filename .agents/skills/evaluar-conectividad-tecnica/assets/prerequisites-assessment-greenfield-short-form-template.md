# Template: Prerequisites Assessment (Greenfield Short-Form)

Template para estructurar el artefacto de salida de `evaluar-conectividad-tecnica` en modo greenfield-short-form.

Este template se usa cuando:

- El repo es greenfield (sin codebase/producto previo)
- El perfil es `lite` (ver `analizar-idea`)

El assessment completo para greenfield es 90% filas "No existe / No aplica (greenfield)" — ceremonia innecesaria para un MVP interno. El short-form preserva el veredicto y los componentes a crear, sin enumerar cada categoría de infraestructura como N/A.

## Frontmatter requerido (al inicio del documento)

```yaml
---
prd_slug: <PRD-SLUG>
domain: <domain>
date: <YYYY-MM-DD>
skill: evaluar-conectividad-tecnica
scope: prd
modo: greenfield-short-form
input: <ruta del artefacto fuente>
status: ready
next: <según veredicto, ver Fase D>
---
```

- **modo**: `greenfield-short-form` (greenfield Y `profile: lite`)
- **status**: `ready` (avance libre) — en greenfield puro normalmente no hay bloqueantes
- **next**: la señal de routing al siguiente skill. El valor se define en la Fase D según el veredicto de conectividad.

## Estructura del documento

```markdown
# Prerequisites Assessment: <PRD-SLUG>

## Veredicto: Conectado (greenfield)

El repo `<repo>` es greenfield: sin codebase/producto previo, sin infraestructura de producto. La funcionalidad es el primer entregable — no extiende uno existente. Conectividad: conectado por vacío (sin prerequisitos previos que falten).

## Componentes a crear (lista mínima)

- **<componente 1>** — <se crea como parte del MVP>
- **<componente 2>** — <se crea como parte del MVP>
```

## Convenciones de formato

- Sin emojis en el documento. Usa texto como `Pass`/`Partial`/`Fail` o `Sí`/`Parcial`/`No`.
- Nombres de funcionalidades y slugs en kebab-case.
- Rutas de artefactos en backticks.
- Nombres de skills en backticks al referenciarlos.

## Validación de calidad

El documento está completo cuando:

1. El frontmatter tiene `prd_slug`, `domain`, `date`, `skill`, `scope`, `modo`, `input`, `status` y `next` declarados.
2. El veredicto declara "Conectado (greenfield)" con justificación.
3. La lista de componentes a crear está presente y es mínima (solo lo necesario para el MVP).
4. No se enumeran categorías de infraestructura como N/A (auth, DB, APIs, servicios, frontend, monitoring).

## Ejemplo de referencia

Para un ejemplo completo del documento final, consulta [references/examples/example-prerequisites-assessment-greenfield-short-form.md](../references/examples/example-prerequisites-assessment-greenfield-short-form.md) — assessment de "dashboard-metrics-interno" en modo greenfield-short-form, veredicto conectado (greenfield).
