---
name: evaluar-conectividad-tecnica
description: >-
  Evalúa conectividad técnica de una funcionalidad a nivel PRD. Toma una
  funcionalidad del roadmap y el codebase actual, y determina si está conectada
  o qué infraestructura falta para que la soporte. Si está conectada,
  genera el assessment de prerequisitos y habilita el avance; si está
  desconectada, genera un roadmap de funcionalidades puente con valor propio.
  Úsalo cuando necesites evaluar conectividad de una funcionalidad completa
  antes de capturar requerimientos o priorizar. Triggers comunes: evaluar
  conectividad de una funcionalidad, validar prerequisitos técnicos de un PRD,
  identificar funcionalidades puente a nivel producto, determinar brecha de
  infraestructura. No lo uses para evaluar conectividad de un epic
  específico (usa evaluar-conectividad-epic), ni para validar viabilidad
  técnica a fondo (usa validar-viabilidad-tecnica), ni para priorizar
  funcionalidades (usa priorizar-roadmap).
---

# Evaluador de Conectividad Técnica (PRD / Funcionalidad)

Evalúa los prerequisitos técnicos y la conectividad de una funcionalidad a nivel PRD con el codebase actual. Determina si la funcionalidad está conectada al producto existente o si necesita funcionalidades puente para construir la infraestructura necesaria.

Solo analiza y planifica: no implementa ni modifica código; prepara la funcionalidad para el siguiente paso.

## Cuándo usarlo y cuándo no

- **Sí**: existe una funcionalidad definida a nivel PRD (del `scope-roadmap.md` o del roadmap priorizado) y se necesita saber si el codebase actual la soporta o qué falta para que la soporte.
- **No**: evaluar conectividad de un epic específico (usa `evaluar-conectividad-epic`), validar viabilidad técnica a fondo con deuda técnica bloqueante (usa `validar-viabilidad-tecnica`), priorizar funcionalidades (usa `priorizar-roadmap`), implementar o modificar código.

**Scope**: Este skill evalúa conectividad a nivel PRD/funcionalidad. Para evaluar un epic específico, usa `evaluar-conectividad-epic`.

NOTA: Al ejecutar las distintas fases, determina las partes que no requieren intervención del usuario y divide las tareas para usar subagentes, ya sea para ejecutar tareas en paralelo o para ejecutarlas de forma consecutiva pero aprovechando el subagente especializado.

## Fase 0: Resolver entrada

Requerido: `FUNCIONALIDAD-SLUG` o `IDEA-DESCRIPCION`.

Infiere desde:
- Ruta: `docs/<DOMAIN>/idea/<IDEA-SLUG>/scope-roadmap.md` (para extraer una funcionalidad específica del alcance de la idea).
- Slug: si el usuario especifica una funcionalidad del roadmap.
- Descripción pegada: si el usuario pega la funcionalidad directamente.

Si no se puede inferir la funcionalidad, pregunta: "¿Qué funcionalidad evalúo? (slug del roadmap o descripción)" y detente a esperar la respuesta.

Declara los inputs resueltos: funcionalidad capturada.

## Fase A: Eco y diagnóstico inicial

Devuelve al usuario un eco breve de lo que entendiste (funcionalidad, dominio, PRD asociado) y un diagnóstico inicial de qué tan lista está la funcionalidad para evaluar conectividad.

**Diagnóstico de madurez** (clasifica la entrada en uno de estos estados):

- **Verde**: no hay funcionalidad seleccionada o no se puede inferir del roadmap/PRD, necesita resolver entrada primero.
- **Borrador**: la funcionalidad existe pero carece de alcance, propuesta de valor o dependencias claras; necesita diálogo focalizado.
- **Casi lista**: la funcionalidad tiene alcance y propuesta de valor definidos; diálogo mínimo de confirmación.

**Diagnóstico de nivel** (clasifica la funcionalidad en uno de estos niveles):

- **Funcionalidad puente**: la funcionalidad se propone como infraestructura habilitante para otras funcionalidades.
- **Funcionalidad de valor directo**: la funcionalidad entrega valor directo al usuario final.

Presenta ambos diagnósticos y confirma que quiere evaluar la conectividad antes de avanzar. Si el diagnóstico de madurez es "Verde", detente a resolver la entrada. En cualquier caso espera la confirmación.

## Fase B: Evaluar Prerequisitos Técnicos

Analiza el codebase actual para identificar qué infraestructura existe y qué falta.

- Detecta si el repositorio es greenfield (sin codebase/producto previo).
- Si es greenfield, evalúa la infraestructura básica del repositorio: gestor de paquetes, contenedores, archivos de configuración, directorios base y convenciones de proyecto. Si un requisito base es crítico y no se puede inferir (runtime, SDKs, cuentas de servicio, entornos, dominios, licencias, accesos a APIs externas), haz una pregunta enfocada y detente a esperar la respuesta. Si es menor, regístralo como pregunta abierta.
- Si es codebase existente, mapea la infraestructura de producto (auth, DB, APIs, servicios, frontend, monitoring). Enfócate en los bounded contexts y features relacionadas; no escanees todo el repo capa por capa si el alcance de la funcionalidad es claro.
- En brownfield, evalúa la calidad de los datos históricos, el estado de salud de los componentes legacy y las limitaciones del stack.
- Identifica features relacionadas y deuda técnica relevante.
- Compara los prerequisitos de la funcionalidad contra el estado actual.

**Detección de modo**: determina si el repositorio es greenfield. El modo se usa en Fase C para el veredicto y en la generación de artefactos para rellenar el frontmatter y la sección de infraestructura.

Consulta [references/prerequisites-analysis-prd-guide.md](references/prerequisites-analysis-prd-guide.md) para la lógica completa de detección y criterios de modo.

## Fase C: Evaluar Conectividad y Decidir Documentos

Determina si la funcionalidad está conectada, parcialmente conectada o desconectada del producto actual. Si está desconectada, genera un roadmap de funcionalidades puente con valor propio.

Esta fase produce:
- El veredicto de conectividad (conectado / parcialmente conectado / desconectado).
- La lista de funcionalidades puente (si aplica).
- La decisión de documentos a generar.

**Criterios de veredicto:**

- **Conectado**: todos los prerequisitos críticos existen o son alcanzables sin funcionalidades puente.
- **Parcialmente conectado**: la mayoría de los prerequisitos existen, pero faltan o son insuficientes algunos requisitos no críticos.
- **Desconectado**: falta infraestructura crítica; requiere funcionalidades puente con valor propio.

**Documentos a generar:**

- **Prerequisites Assessment** (siempre): `docs/<domain>/idea/<IDEA-SLUG>/connectivity/prerequisites-assessment.md`.
- **Bridge Roadmap** (solo si desconectado o parcialmente conectado): `docs/<domain>/idea/<IDEA-SLUG>/connectivity/bridge-roadmap.md`.

Consulta [references/connectivity-evaluation-guide.md](references/connectivity-evaluation-guide.md) para la lógica completa de criterios de conectividad/desconexión, generación de funcionalidades puente y ejemplo canónico.

## Fase D: Gate de avance y cierre

Esta fase fija el `status` y `next` y genera los artefactos finales.

1. **Gate**: ejecuta [references/advancement-gate-guide.md](references/advancement-gate-guide.md). Clasifica preguntas abiertas (Crítica / Importante / Menor), alerta al usuario si aplica y fija el `status`:
   - `ready`: sin Críticas/Importantes pendientes.
   - `conditional`: Importantes pendientes y el usuario acepta avanzar.
   - `blocked`: Críticas pendientes → omite `next`.

2. **Fijar `next`** según veredicto de conectividad:
   - **Conectado** (incluye greenfield): `next: capturar-requerimiento`
   - **Parcialmente conectado** o **desconectado**: `next: priorizar-roadmap`
   - **Información insuficiente**: sin `next`

3. **Generar artefactos**:
   - **Prerequisites Assessment** (siempre): `docs/<domain>/idea/<IDEA-SLUG>/connectivity/prerequisites-assessment.md`.
   - **Bridge Roadmap** (solo si desconectado o parcialmente conectado): `docs/<domain>/idea/<IDEA-SLUG>/connectivity/bridge-roadmap.md`.

   Ambos artefactos deben incluir frontmatter `status` y `next`, TOC, gate de avance documentado y seguir sus templates.

4. **Actualizar README**: si existe `docs/<domain>/idea/<IDEA-SLUG>/README.md` o `docs/<domain>/README.md`, añade los enlaces a los artefactos en la tabla de "Puntos de entrada".

5. **Checklist de salida** (interno): antes de terminar, verifica:
   - Funcionalidad y modo correctos.
   - Veredicto de conectividad justificado.
   - Gate de avance documentado con `status` y `next` correctos.
   - Artefactos con frontmatter y formato correctos.

   Aplica el checklist completo de [references/autoevaluacion-checklist.md](references/autoevaluacion-checklist.md).
