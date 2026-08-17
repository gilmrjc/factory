# Guía de Análisis de Prerequisitos Técnicos

Esta guía define cómo analizar el codebase actual para identificar qué infraestructura existe y qué falta para soportar la funcionalidad.

## Detección de greenfield

Antes de enumerar infraestructura, verifica si el repo destino tiene codebase/producto previo. Señales de greenfield:

- Repo vacío o recién inicializado (sin `src/`, sin `package.json` previo, sin módulos de aplicación).
- Sin infraestructura de producto (auth, DB, APIs, servicios, frontend, monitoring).
- La funcionalidad es el primer entregable del producto (no extiende uno existente).

Si el repo es greenfield, **no te saltes el paso**: ejecuta el análisis de forma reducida (ver "Modo greenfield" abajo) y produce el artefacto obligatorio. La conectividad se evalúa como "conectado por vacío" (sin prerequisitos previos que falten), pero el artefacto queda como registro de la decisión.

## Inventario (modo codebase existente)

### Infraestructura existente

- Auth system (JWT, OAuth, sessions, etc.)
- Database (PostgreSQL, MongoDB, etc., schemas existentes)
- APIs (REST, GraphQL, endpoints existentes)
- Servicios (queue, cache, search, email, etc.)
- Frontend framework y patrones
- Monitoring y logging

### Features implementadas relacionadas

- Busca features similares con `grep` y `find_file_by_name`.
- Identifica patrones arquitectónicos usados.
- Mapea bounded contexts existentes.

### Deuda técnica relevante

- TODOs, FIXMEs, deprecated code.
- Legacy systems que afectan la funcionalidad.
- Known limitations o constraints.

### Comparación prerequisitos vs estado actual

- ¿Qué componentes necesita la funcionalidad?
- ¿Cuáles existen?
- ¿Cuáles faltan?
- ¿Cuáles necesitan upgrades?

## Modo greenfield

Cuando el repo es greenfield (sin codebase/producto previo):

- Infraestructura existente: ninguna (declara explícitamente "greenfield — sin infraestructura previa").
- Prerequisitos de la funcionalidad: lista los que la funcionalidad aporta o requiere (ej: runtime, dependencias externas, convenciones de archivos).
- Gaps: ninguno bloqueante (la funcionalidad construye su propia base) o lista los pocos que falten.
- Conectividad: **conectado (greenfield)** — sin prerequisitos previos que falten porque no hay producto previo del que depender.
- Genera el artefacto obligatorio con veredicto "conectado (greenfield)" y justificación. No te saltes el paso: el artefacto es el registro de la decisión.

## Modo greenfield — short-form (path lite)

Cuando el repo es greenfield Y `profile: lite` (ver `analizar-idea`), emite un **short-form** en vez del assessment completo. El assessment completo para greenfield es 90% filas "No existe / No aplica (greenfield)" — ceremonia innecesaria para un MVP interno. El short-form preserva el veredicto y los componentes a crear, sin enumerar cada categoría de infraestructura como N/A.

Para el template del short-form, consulta [assets/prerequisites-assessment-greenfield-short-form-template.md](../assets/prerequisites-assessment-greenfield-short-form-template.md).

Salta el escaneo de auth/DB/APIs/servicios/frontend/monitoring (todos N/A en greenfield). Solo lista los componentes que la funcionalidad aporta o requiere. Si hay gaps bloqueantes (ej: "acceso al scope npm debe confirmarse"), lístalos como notas — pero en greenfield puro normalmente no los hay.
