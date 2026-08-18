# Guía de Análisis de Prerequisitos Técnicos: Nivel Epic

Esta guía define cómo analizar el codebase actual para determinar si un epic específico está conectado, parcialmente conectado o desconectado.

## Diferencia con el análisis de PRD

- El análisis de PRD (`evaluar-conectividad-tecnica`) decide a alto nivel si una funcionalidad completa cabe en el producto.
- El análisis de epic profundiza en los requisitos concretos del epic, sus acceptance criteria, alcance y dependencias, y los compara con la infraestructura existente punto a punto.

## Herencia del PRD

Antes de escanear el codebase, lee `docs/<domain>/initiatives/<PRD-SLUG>/connectivity/prerequisites-assessment.md` si existe. Usa su veredicto como punto de partida:

- Si el PRD declaró `Conectado`, el epic sigue analizando: el PRD no mapea acceptance criteria ni detalles técnicos.
- Si el PRD declaró `Desconectado`, el epic hereda los gaps identificados y solo añade el detalle necesario para este epic.
- Si el PRD declaró `Conectado (greenfield)`, el epic trata el repositorio como greenfield solo si es el primer epic del producto. En productos maduros, el epic no es greenfield.

## Inventario a nivel epic

No listes toda la infraestructura genérica del producto. Enfócate en lo que el epic necesita:

- **Auth**: ¿los flujos del epic requieren permisos, scopes o métodos no cubiertos?
- **Database**: ¿el epic requiere tablas, columnas, índices o migraciones que no existen?
- **APIs**: ¿requiere endpoints, contratos o versionados nuevos?
- **Servicios**: ¿usa colas, caché, búsqueda, email, etc.?
- **Frontend**: ¿requiere componentes, estados o patrones no disponibles?
- **Monitoring**: ¿necesita métricas, logs o alertas específicas del epic?
- **Infraestructura**: ¿necesita recursos cloud, despliegue o escalado concretos?

## Mapeo de Acceptance Criteria

Cada acceptance criterion del epic debe mapearse a uno o varios requisitos técnicos. Si un AC no puede cumplirse con la infraestructura actual, es un gap.

- **AC**: [descripción] → **Requisito técnico**: [componente] → **Estado**: [Existe/Suficiente | Falta/Insuficiente]

## Comparación prerequisitos vs existentes

Para cada requisito del epic:

1. ¿Qué necesita el epic exactamente? (schema, endpoint, permiso, etc.)
2. ¿Cuál es el estado actual en el codebase?
3. ¿Es suficiente para el epic? (capacidad, escalabilidad, patrón)
4. Si no es suficiente: ¿se resuelve con un upgrade o requiere una funcionalidad puente nueva?

## Veredicto

- **Conectado**: todos los requisitos críticos del epic existen y son suficientes.
- **Parcialmente conectado**: la mayoría existe, pero faltan o son insuficientes algunos requisitos no críticos, o hay bloqueadores importantes.
- **Desconectado**: falta infraestructura crítica para el epic.

## Modo greenfield

Un epic normalmente no es greenfield. Si el PRD es greenfield y este es el primer epic, trátalo como greenfield solo si no hay codebase previo. Si hay codebase previo, asume codebase existente.
