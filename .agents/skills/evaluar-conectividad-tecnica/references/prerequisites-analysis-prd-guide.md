# Guía de Análisis de Prerequisitos Técnicos: Nivel PRD/Funcionalidad

Esta guía define cómo analizar el codebase actual a nivel PRD/funcionalidad. Identifica qué infraestructura existe y qué falta para soportar la funcionalidad completa.

## Table of Contents

- [Detección de greenfield](#detección-de-greenfield)
- [Inventario (modo codebase existente)](#inventario-modo-codebase-existente)
  - [Proceso de análisis](#proceso-de-análisis)
  - [Dimensiones a evaluar](#dimensiones-a-evaluar)
  - [Features implementadas relacionadas](#features-implementadas-relacionadas)
  - [Deuda técnica relevante](#deuda-técnica-relevante)
  - [Comparación prerequisitos vs estado actual](#comparación-prerequisitos-vs-estado-actual)
  - [Ejemplo de veredicto](#ejemplo-de-veredicto)
- [Modo greenfield](#modo-greenfield)

## Detección de greenfield

Antes de enumerar infraestructura, verifica si el repositorio destino tiene codebase/producto previo.

**Señales de greenfield**:

- Repositorio vacío o recién inicializado (sin `src/`, sin gestor de paquetes previo, sin módulos de aplicación).
- Sin infraestructura de producto (auth, DB, APIs, servicios, frontend, monitoring).
- La funcionalidad es el primer entregable del producto (no extiende uno existente).

**Si el repositorio es greenfield**, ejecuta el análisis de forma reducida. Consulta "Modo greenfield" más abajo. Produce el artefacto obligatorio. La conectividad se evalúa como "conectado por vacío" (sin prerequisitos previos que falten). El artefacto queda como registro de la decisión.

## Inventario (modo codebase existente)

Este modo aplica cuando el repositorio tiene un producto o codebase previo. El objetivo no es listar toda la infraestructura del producto, sino identificar qué necesita la funcionalidad completa y si el codebase actual lo soporta.

### Proceso de análisis

Sigue este orden para evitar ruido innecesario:

1. Lee la descripción de la funcionalidad y extrae los componentes técnicos que necesita.
2. Explora el codebase para confirmar si cada componente existe.
3. Evalúa si el componente existente es suficiente para la funcionalidad completa.
4. Registra gaps, upgrades y decisiones pendientes.

### Dimensiones a evaluar

Para cada dimensión, responde tres preguntas: ¿existe?, ¿es suficiente? y ¿qué falta o qué hay que mejorar?

#### Auth

- ¿Qué sistema de autenticación existe? (JWT, OAuth, session-based, etc.)
- ¿Cubre los roles, scopes o permisos que la funcionalidad requiere?
- ¿Necesita extensión, nuevo método o integración externa?

#### Database

- ¿Qué motor y esquema existe? (PostgreSQL, MongoDB, Redis, etc.)
- ¿La funcionalidad requiere tablas, columnas, índices o migraciones nuevas?
- ¿Hay datos históricos, volumen o relaciones que afectan el diseño?
- ¿La calidad y estructura de los datos históricos soportan el comportamiento esperado? (brownfield)

#### APIs

- ¿Qué estilo de API usa el producto? (REST, GraphQL, gRPC)
- ¿Existen endpoints o contratos similares que se puedan extender?
- ¿La funcionalidad requiere endpoints nuevos o cambios de versión?

#### Servicios

- ¿Qué servicios internos o externos existen? (queue, cache, search, email, notificaciones)
- ¿Cuáles de ellos necesita la funcionalidad?
- ¿Falta algún servicio o hay que crear uno nuevo?

#### Frontend

- ¿Qué framework y design system usa el producto?
- ¿Existen componentes, pantallas o flujos que se puedan reutilizar?
- ¿La funcionalidad requiere patrones de estado o navegación nuevos?

#### Monitoring y logging

- ¿Hay métricas, logs o alertas configuradas?
- ¿La funcionalidad requiere trazabilidad específica?

#### Infraestructura

- ¿Qué cloud, orquestación o despliegue existe?
- ¿La funcionalidad requiere recursos, escalado o integraciones de infraestructura nuevas?

### Features implementadas relacionadas

- Busca features similares con `grep` y `find_file_by_name`.
- Identifica patrones arquitectónicos usados.
- Mapea bounded contexts existentes y cómo la nueva funcionalidad se conecta con ellos.

### Deuda técnica relevante

- TODOs, FIXMEs o deprecated code que afectan la funcionalidad.
- Legacy systems que limitan el alcance o la implementación.
- Limitaciones conocidas del stack actual (versiones end-of-life, falta de tests, acoplamiento).
- Estado de salud de los componentes que se reutilizarán (coverage, documentación, acoplamiento).

### Comparación prerequisitos vs estado actual

Para cada componente que la funcionalidad necesita:

1. ¿Qué necesita exactamente?
2. ¿Existe en el codebase?
3. ¿Es suficiente para la funcionalidad completa?
4. Si no es suficiente: ¿se resuelve con un upgrade o requiere una funcionalidad puente nueva?

### Ejemplo de veredicto

- **Auth JWT**: Existe: Sí. Suficiente: Sí. Acción: Ninguna.
- **DB de usuarios**: Existe: Sí. Suficiente: Parcial. Acción: Migración para campo `notification_preferences`.
- **Servicio de push**: Existe: No. Suficiente: N/A. Acción: Crear `notification-service`.

Este formato es una guía. Usa el template formal en [assets/prerequisites-assessment-template.md](../assets/prerequisites-assessment-template.md) para el artefacto final.

## Modo greenfield

Cuando el repositorio es greenfield (sin codebase/producto previo):

- Infraestructura de producto: ninguna. Declara explícitamente "greenfield: sin infraestructura de producto previa".
- Infraestructura básica del repositorio: evalúa si existe aunque sea mínima. Revisa: gestor de paquetes, contenedores, archivos de configuración, directorios base y convenciones de proyecto. Adapta los ejemplos al stack (ej. `package.json`/`requirements.txt`/`Cargo.toml`, `Dockerfile`/`Containerfile`, `.env.example`, `Makefile`, CI/CD, `src/`/`tests/`).
- Prerequisitos de la funcionalidad: lista los que la funcionalidad aporta o requiere (ej: runtime, dependencias externas, convenciones de archivos).
- Requisitos base que no se pueden inferir: si son críticos para la funcionalidad (runtime, SDKs, cuentas de servicio, entornos de prueba, dominios, licencias, accesos a APIs externas), haz una pregunta enfocada y detente a esperar la respuesta. Si son menores, regístralos como preguntas abiertas.
- Gaps: lista los que faltan, incluso en greenfield. No asumas que no hay bloqueantes solo porque no hay producto previo.
- Conectividad: **conectado (greenfield)** si los requisitos base están disponibles o confirmados. **Desconectado** si falta infraestructura base crítica.
- Genera el artefacto obligatorio con veredicto "conectado (greenfield)" o "desconectado" y justificación. No omitas este paso: el artefacto es el registro de la decisión.

En greenfield, omite el escaneo detallado de auth/DB/APIs/servicios/frontend/monitoring como infraestructura de producto. Evalúa la infraestructura básica del repositorio. Lista los componentes que la funcionalidad aporta o requiere. Si hay dudas sobre requisitos base, pregunta al usuario antes de declarar el veredicto. Si hay gaps bloqueantes (ej: "acceso al registro de paquetes debe confirmarse"), lístalos como notas.
