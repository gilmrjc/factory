---
name: mapear-dominio
description: >-
  Elabora una guía de dominio DDD estratégica autocontenida en disco
  (subdominios, bounded contexts, mapas de contexto, arqueología de código,
  comportamiento en ejecución y evaluación). Úsala cuando el equipo necesite una
  referencia de estudio persistente de límites de dominio; no la uses para
  radares de deuda técnica, PRDs, deep-dive puntual o diseño táctico profundo.
argument-hint: "[scope] [taskFolder] [sourcesHint?] [mapState?] [splitMode?]"
allowed-tools:
  - ask_user_question
  - read
  - grep
  - exec
  - write
  - find_file_by_name
triggers:
  - user
  - model
---

## Uso rápido

Invoca: `domain-mapping "<scope>" "<taskFolder>" ["<sourcesHint>"] [<mapState>] [<splitMode>]`

Ejemplo: `domain-mapping "checkout" "docs/domain-maps/checkout" "src/sales, src/payments" "AS_IS"`

- `taskFolder` es obligatoria; si falta, pídela.
- `mapState` default: `AS_IS`; usa `TO_BE` solo si el usuario pide rediseño explícito.
- `splitMode` se decide normalmente en la Fase B.1; no es obligatoria al inicio.

## Propósito

Elabora una guía de dominio DDD estratégica autocontenida y revisable en disco para un producto, módulo o área dada. No ejecuta workflows de refinement/execution/refactor ni cambia código de producto. La salida principal es `domain-map.md` (y partes enlazadas) dentro de un `taskFolder` acordado.

**No** la uses para inventarios de deuda técnica, PRDs de features, deep-dive puntual del tipo "¿cómo funciona X?", mapas organizativos complejos o diseño táctico profundo como cuerpo principal.

## Cuándo usarlo y cuándo no

- **Sí:** se necesita una guía de dominio persistente en disco: subdominios, bounded contexts, mapas de contexto, lenguaje ubicuo, arqueología de código, comportamiento en ejecución y evaluación.
- **No:** inventario de deuda técnica orientado a correcciones → usa el skill apropiado para análisis de cambios.
- **No:** cambiar código o ejecutar refactor.
- **No:** pregunta puntual sin mapa persistente.
- **No:** PRD / definición de feature.
- **No:** diseño táctico profundo (agregados/entidades/repositorios detallados) como cuerpo principal.
- **No:** mapa organizativo / Team Topologies completo como cuerpo principal (anexo breve solo si hay evidencia clara de equipos).

Si el pedido cae en **No**, aborta con una frase que contraste lo pedido con lo que hace este skill; para encontrar el atajo correcto usa `/help`.

## Entrada y salida

- **Entrada:**
  - `scope` (string, obligatorio): producto, módulo o área a mapear.
  - `taskFolder` (path, obligatorio): carpeta donde escribir; pídela si no se indica. No escribas en la raíz del repo.
  - `sourcesHint` (string, opcional): rutas o temas a priorizar.
  - `mapState` (`AS_IS` | `TO_BE`, opcional; default `AS_IS`). `TO_BE` solo si el usuario pide rediseño explícito.
  - `splitMode` (`single` | `by-domain` | `by-size`, opcional; decidir en la fase de inventario).
- **Salida:**
  - **Canónico:** `domain-map.md` en la raíz de `taskFolder`.
  - **Apoyos:** `domain_map_process/session.md`, `domain_map_process/context.md`.
  - **Partes (opcionales):** `domain-map/<slug>.md` o `domain-map/bc-<slug>.md` enlazadas desde el índice.
  - **Evaluación:** bloque `## Evaluación de salida` dentro de `domain-map.md` (o del índice) con rúbrica y `Listo para`.

## Convenciones locales

- Trabaja con archivos locales o el chat.
- Si el usuario proporciona una ruta de archivo como fuente, léela con `read`.
- Si falta `taskFolder`, pídela; nunca escribas el canónico en la raíz del repo.
- Si falta `scope`, pídela; no inventes el dominio completo.
- Persiste apoyos en `domain_map_process/` y el canónico en `domain-map.md`.
- Usa `templates/domain-map-template.md` del skill como guía de secciones canónicas.

## Referencias compartidas

| Referencia | Rol |
|------------|-----|
| [file-discovery.md](references/file-discovery.md) | Resolución de entradas (Fase 0) |

## Estrategia de fallo

- **Sin `scope`**: Pedir alcance; no inventar el dominio.
- **Sin `taskFolder`**: Pedir ruta; no escribir en la raíz del repo.
- **Evidencia insuficiente**: Mapear lo observable; marcar supuestos; no inventar BC sin evidencia.
- **Un solo contexto aparente**: Canvas completo + justificación de por qué no se parte.
- **Mapa crece / ≥2 dominios**: Proponer división; migrar a `domain-map/`; índice actualizado.
- **Parte sin enlace**: Corregir antes de cerrar.
- **Usuario pide táctica profunda**: Anexo ≤10 líneas o diferir; no sustituir la guía.
- **Usuario pide `TO_BE`**: Declarar `mapState=TO_BE`; no mezclar con `AS_IS` sin etiquetar.
- **Diagrama ASCII o flechas D→U**: Reescribir Mermaid U→D antes de persistir.
- **Todo etiquetado C/S**: Revisar capa 1; degradar a UpstreamDownstream si no hay backlog compartido.
- **Evaluación `bloqueado`**: No cerrar como listo; listar huecos y completar una iteración.
- **Puntuación no sube a ≥ 9 tras 2 rondas**: Detente e informa los bloqueos restantes; no iterar indefinidamente.

## Resumen del flujo

- **0 — Resolver entradas**: Validar y declarar parámetros obligatorios — `scope` y `taskFolder` resueltos
- **A — Cargar**: Fijar alcance, carpeta y estado del mapa — `scope`, `taskFolder` y `mapState` declarados
- **B — Elaborar**: Descubrir subdominios, bounded contexts, relaciones y comportamiento — Subdominios, canvases, ≥2 mapas, ≥2 historias
- **C — Persistir**: Escribir `domain-map.md` (+ partes) y evaluar — Entregable en disco con `## Evaluación de salida`

## Fase 0 — Resolver entradas

Requerido: `scope` (string) y `taskFolder` (path). Opcional: `sourcesHint` (string), `mapState` (`AS_IS` | `TO_BE`), `splitMode` (`single` | `by-domain` | `by-size`).

Declara las entradas resueltas en el chat, luego procede.

## Fase A — Cargar y arrancar

1. Resolver `taskFolder` (absoluto o relativo). Crear `domain_map_process/{session,context}.md`.
2. Si existe `domain-map.md` / `domain-map/` / `domain-map-*.md` previo, resumirlo y proponer 2–4 opciones (consolidar / reestructurar / empezar de nuevo + sugerida) usando `ask_user_question`.
3. Fijar `scope`, `sourcesHint` y `mapState` (`AS_IS` default).

**Criterio de salida A:** `scope` escrito; `taskFolder` válido; `mapState` declarado; decisión sobre legado en `session.md`.

## Fase B — Elaborar el mapa

### B.1 — Inventario y división

1. Inventariar capacidades con evidencia (rutas, comandos, artefactos en disco).
2. Decidir `splitMode`.
3. Borrador de subdominios Núcleo / Soporte / Genérico + criterios.

**Criterio B.1:** tabla de subdominios con evidencia; `splitMode` decidido.

### B.2 — Bounded contexts + arqueología

1. Diseñar BCs (no "carpeta = contexto"): propósito, límites, clasificación, roles de dominio, **interfaz pública**, lenguaje ubicuo + anti-términos, comunicación entrada/salida tipada (comando | consulta | evento | documento/archivo), reglas de límite, ownership tentativo.
2. En cada BC **Núcleo**, completar arqueología (entrar por, leer después, fósil/trampa, ancla de contrato/prueba).
3. Soporte / Genérico: ficha corta (propósito + límites + 1 línea de arqueología).

**Criterio B.2:** todo Núcleo tiene canvas (interfaz + mensajes tipados) + arqueología; Soporte al menos ficha; ninguno sin límites.

### B.3 — Mapas de contexto por perspectiva

1. Elegir ≥2 perspectivas distintas del catálogo; formular la pregunta de cada mapa.
2. Por mapa: leyenda solo de tipos/roles usados + tabla 2 capas + Mermaid U→D; matriz U×D si ≥5 BCs.
3. Discriminar CustomerSupplier vs UpstreamDownstream; apilar roles cuando aplique; demarcar BBoM si existe.

**Criterio B.3:** ≥2 mapas de perspectivas distintas; cero ASCII; cada arista con tipo (capa 1) y roles si aplican (capa 2).

### B.4 — Ejecución, bloques estructurales, navegación

1. ≥2 historias de dominio (actor → acción → artefacto); incluir error o umbral.
2. Bloques estructurales ligeros (entrada → módulos, máx. 2 niveles). Aclarar que no son C4 ni context map.
3. Guía de estudio (3 pasadas) + índice si el documento es largo.
4. Polisemia, trazabilidad subdominio↔BC, decisiones de frontera, preguntas de estudio, supuestos.

**Criterio B.4:** historias + bloques + guía de estudio; polisemia y trazabilidad completas; ≥3 preguntas de estudio.

## Fase C — Persistir y evaluar

### C.1 — Persistir

1. Escribir según `splitMode`. `domain-map.md` es documento final (sin narrativa del proceso).
2. Actualizar `context.md` (`splitMode`, `mapState`, rutas, fecha).
3. `domain-map.md` nunca desaparece; toda parte enlazada desde el índice.

**Criterio C.1:** canónico (+ partes) en disco; enlaces íntegros; lectura rápida visible; `mapState` declarado.

### C.2 — Evaluación de salida

1. Aplicar la rúbrica con evidencia citada del propio entregable.
2. Asignar exactamente un `Listo para`.
3. Si `bloqueado` o puntuación global < 7: volver a la fase con huecos; máximo 2 ciclos de mejora en la misma invocación.
4. Registrar el resultado de la evaluación dentro de `domain-map.md`.

**Criterio C.2:** bloque `## Evaluación de salida` completo; `Listo para` ≠ `bloqueado` o el usuario aceptó cerrar con huecos explícitos.

## Contrato de contenido (el conjunto debe cumplirlo)

1. **Navegación:** índice + Guía de estudio (3 pasadas).
2. **Estado del mapa:** declarar `AS_IS` (default) o `TO_BE` en Contexto y alcance.
3. **Subdominios:** Núcleo (Core) / Soporte (Supporting) / Genérico (Generic) + evidencia + criterios.
4. **Bounded contexts:** canvas por contexto (Núcleo completo; Soporte ficha corta) con interfaz pública y mensajes tipados.
5. **Arqueología** en cada BC **Núcleo:** entrar por / leer después / fósil o trampa / prueba o ancla de contrato.
6. **Mapas de contexto pequeños (≥2)** por **perspectivas distintas**. Cada uno: leyenda aplicada + tabla de relaciones (2 capas) + Mermaid U→D; matriz U×D si ≥5 BCs.
7. **Comportamiento en ejecución / historias de dominio (≥2):** actor → acción → artefacto (camino feliz + al menos un fallo o umbral).
8. **Bloques estructurales ligeros:** puntos de entrada y módulos (máx. 2 niveles) solo para arqueología.
9. **Polisemia**, **trazabilidad** subdominio↔BC, **decisiones de frontera**, **preguntas de estudio**, **supuestos**.
10. **Evaluación de salida** con rúbrica y `Listo para`.

Un entregable que solo liste carpetas no cumple. Un mapa que idealiza el futuro sin evidencia, presentado como `AS_IS`, no cumple.

## Semántica de context map (2 capas)

Cada arista tiene **tipo de relación** (capa 1) y, si aplica, **roles de integración** apilables (capa 2). Los roles **no son mutuamente excluyentes**.

### Capa 1 — Tipo de relación

- **Partnership**: El fallo de entrega de uno implica fallo del otro; coordinación bilateral (simétrica)
- **SharedKernel**: Subconjunto de modelo/código explícito y pequeño; cambio = consulta bilateral (simétrica)
- **UpstreamDownstream**: El U influye en el D; el D no empuja la planificación del U (asimétrica U→D)
- **CustomerSupplier**: Como U→D, y las prioridades del D factorizan en el backlog del U (asimétrica U→D)
- **SeparateWays**: Sin integración relevante (relación de equipo *Free*)
- **BigBallOfMud**: Zona de modelos mezclados / fronteras rotas; demarcar, no propagar el modelo

### Capa 2 — Roles de integración (apilables)

- **OHS** (U): Protocolo/API estable abierto a varios consumidores — Catálogo expone API de productos a Pedidos y Facturación
- **PL** (U): Lenguaje/formato publicado de intercambio — JSON Schema / Protobuf / iCal entre contextos
- **Conformist** (D): El D adopta el modelo del U sin traducir — Notificaciones usa el payload de Pedidos tal cual
- **ACL** (D): El D traduce/protege su modelo frente al U — Checkout adapta un ERP legado a su propio modelo

**Reglas duras:**

1. No etiquetes todo como CustomerSupplier: sin influencia en planificación del U → UpstreamDownstream (+ Conformist o ACL).
2. Partnership / SharedKernel no fuerzan U/D falso; si hay asimetría real, usa UpstreamDownstream o CustomerSupplier.
3. SharedKernel: declara alcance; prioriza piezas de baja volatilidad; si crece sin consulta → riesgo (hacia BBoM o acoplamiento).
4. Una arista puede llevar varios roles (`OHS+PL`, `Conformist` → evolución a `ACL`).
5. Partnership coordina equipos/contextos; evita ciclos runtime de dependencias duras.
6. Mapa organizacional / Team Topologies solo como anexo ≤15 líneas si hay evidencia de equipos.

### Catálogo de perspectivas (elige ≥2 distintas)

1. **Runtime / ciclo mecánico** — ¿quién escribe qué artefacto en ejecución?
2. **Propagación de modelo / PL** — ¿qué lenguaje publicado viaja entre contextos?
3. **Frontera semántica / polisemia** — ¿dónde el mismo término cambia de significado?
4. **Influencia de planificación** — ¿hay CustomerSupplier real o solo UpstreamDownstream?
5. **Ownership / dependencia de entrega** — ¿quién debe coordinar releases? (solo con evidencia)

### Convención Mermaid

- Flecha siempre **upstream → downstream** (influencia).
- Nodos = bounded contexts (no carpetas).
- Etiqueta = tipo + roles, p. ej. `U/D + OHS+PL→ACL` o `Partnership`.
- BBoM: nodo o subgrafo marcado; sin aristas que "legitimen" el lodo como modelo limpio.
- Cero ASCII art.

## Disposición de archivos

- **`single`**: Un dominio; la guía cabe en un `.md` — Solo `domain-map.md`
- **`by-domain`**: ≥2 dominios claros — Índice + `domain-map/<dominio>.md`
- **`by-size`**: Un dominio con muchos canvases — Índice + partes `bc-*.md` / dominio

**Reglas:** (1) `domain-map.md` nunca desaparece. (2) Toda parte enlazada desde el índice. (3) El contrato se cumple en el **conjunto**. (4) Nombres kebab-case ASCII. (5) Antes de dividir: 2–4 alternativas + "Otra" + sugerida.

## Rúbrica de evaluación de salida (1–10)

- **Navegación / estudio**
  - 0–3: Sin índice ni guía
  - 4–6: Solo Lectura rápida
  - 7–8: Guía 3 pasadas
  - 9–10: Guía + índice + preguntas de estudio
- **Subdominios**
  - 0–3: Lista sin evidencia
  - 4–6: Evidencia parcial
  - 7–8: Núcleo/Soporte/Genérico + criterios
  - 9–10: Tensiones explícitas
- **Canvases + arqueología**
  - 0–3: Nombres sueltos
  - 4–6: Canvases sin arqueología / sin mensajes tipados
  - 7–8: Núcleo con arqueología + interfaz
  - 9–10: Núcleo+Soporte coherentes
- **Mapas de contexto**
  - 0–3: Uno confuso / ASCII / todo C/S
  - 4–6: Un solo mapa completo
  - 7–8: ≥2 perspectivas; capa 1+2
  - 9–10: Roles apilados bien discriminados; BBoM si aplica
- **Ejecución + bloques**
  - 0–3: Ausente
  - 4–6: Solo uno de los dos
  - 7–8: Historias + bloques acotados
  - 9–10: Historias con fallo + bloques ≠ C4
- **Lenguaje / polisemia**
  - 0–3: Ausente
  - 4–6: Glosario débil
  - 7–8: Polisemia con mitigación
  - 9–10: Anti-términos por BC
- **Autocontención del doc**
  - 0–3: Depende del chat/legado
  - 4–6: Huecos "ver X externo"
  - 7–8: Se entiende solo
  - 9–10: Preguntas de estudio respondibles; AS_IS claro

**Puntuación global:** promedio redondeado de los 7 criterios.

Un mapa debe cumplir estos estándares antes de poder puntuar ≥ 9:

- Las secciones requeridas del contrato de contenido están presentes con contenido real.
- ≥2 mapas de perspectivas distintas con capa 1+2 + Mermaid U→D.
- ≥2 historias + arqueología + interfaz/mensajes en cada Núcleo.
- Rúbrica rellenada y un solo `Listo para`.
- Sin pedir al lector que salga a URLs o a skills ajenas para completar el sentido del mapa.

Verificación rápida de 9 vs 8: si el lector necesitaría consultar fuentes externas o el chat para entender el mapa, puntúa ≤ 8. Si el mapa se sostiene solo con solo nits de redacción, puntúa ≥ 9.

Mejora el mapa en **como máximo 2** rondas de revisión hasta que la puntuación sea ≥ 9. Si sigue por debajo de 9 después de 2 rondas, detente e informa los bloqueos en lugar de iterar indefinidamente.

**Listo para** (exactamente uno; literales de contrato — no traducir): `fusionar-solo-detalles` | `mejorar` | `bloqueado`.

- `fusionar-solo-detalles` — puntuación ≥ 8 y sin criterio < 6.
- `mejorar` — puntuación 6–7, o algún criterio 4–5 sin romper usabilidad.
- `bloqueado` — puntuación ≤ 5, o falta contrato obligatorio (p. ej. sin Mermaid, sin arqueología en Núcleo, sin evaluación, capas de relación mezcladas/omitidas).

## Mal resultado (evitar)

- Carpetas disfrazadas de subdominios/BCs.
- Un solo mapa de contexto "dios" o diagrama ASCII.
- Todo etiquetado CustomerSupplier sin evidencia de backlog compartido.
- Canvases Núcleo sin arqueología, sin interfaz pública o sin tipo de mensaje.
- Confundir bloques estructurales con C4 o con el context map.
- Presentar deseo (`TO_BE`) como `AS_IS`.
- Cerrar solo en el chat o con código "de ejemplo".
- Referencias a URLs externas o "abre el documento X" para entender el mapa.
- Evaluación omitida o `Listo para` múltiple/ambiguo.
- Narrativa de "en esta sesión hicimos…" dentro del canónico.

## Autoevaluación antes de terminar

- ¿Se cumplieron los criterios de salida de las fases 0, A, B y C?
- ¿`scope` y `taskFolder` resueltos y declarados?
- ¿`mapState` declarado y coherente con el contenido?
- ¿≥2 mapas de perspectivas distintas con capa 1+2 + Mermaid U→D?
- ¿≥2 historias + arqueología + interfaz/mensajes en cada Núcleo?
- ¿Rúbrica rellenada y un solo `Listo para`?
- ¿Sin pedir al lector que salga a URLs o a skills ajenas para completar el sentido del mapa?
- ¿Entregables persistidos en disco (`domain-map.md` + `domain_map_process/`)?

## Termina cuando

Los criterios de las fases 0, A, B y C se cumplen (o `bloqueado` se documentó con aceptación del usuario); `domain-map.md` (+ partes) y `domain_map_process/` están persistidos.

## Encabezados del canónico

Tras el `#` del título del índice/`single`: orden **`## Contexto y alcance`** → **`## Lectura rápida`** → resto según la plantilla incluida. La Lectura rápida resume dominio, contextos clave, relación crítica y pendientes (sin historial de redacción).

## Handoff

```text
## Handoff

**Skill:** domain-mapping
**Scope:** <scope>
**TaskFolder:** <taskFolder>
**MapState:** <AS_IS | TO_BE>
**SplitMode:** <single | by-domain | by-size>

### Entregables
- `domain-map.md` (canónico)
- `domain_map_process/session.md`
- `domain_map_process/context.md`
- Partes opcionales: `domain-map/<slug>.md` o `domain-map/bc-<slug>.md`

### Evaluación
- Puntuación global: <X/10>
- Listo para: <fusionar-solo-detalles | mejorar | bloqueado>
- Observaciones: <breve resumen de hallazgos principales>

### Próximo paso sugerido
<según Listo para: fusionar, mejorar con iteración adicional, o desbloquear dependencias>
```
