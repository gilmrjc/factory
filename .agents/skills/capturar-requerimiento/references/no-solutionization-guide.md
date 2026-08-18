# Guía de No-solutionización

La **no-solutionization** es la regla de no cristalizar el diseño de la solución durante `capturar-requerimiento`. El propósito de este skill es entender el problema, el resultado deseado y la propuesta de valor, no decidir cómo se va a construir.

## Qué SÍ se captura

- **Propósito o capacidad**: qué debe lograr la funcionalidad y para quién.
- **Experiencia esperada**: qué cambia para el usuario, no cómo funciona internamente.
- **Restricciones impuestas externamente**: tech stack obligado, regulaciones, integraciones ya existentes, APIs o servicios que deben usarse.
- **Decisiones de alcance**: qué queda dentro del MVP y qué se difiere a post-MVP.

## Qué NO se captura aquí

Cualquier decisión que describa **cómo** se va a construir en vez de **qué** se va a construir o **bajo qué restricciones**. Si aparece durante la captura, se mueve a "Preguntas abiertas" como "decisión de diseño pendiente — se resuelve en fases posteriores del workflow".

Ejemplos de decisiones de solución:

- Estructuras de datos, esquemas, modelos o formatos de archivos.
- Componentes internos, módulos, colas, workers, pipelines o flujos de orquestación.
- Interfaces de usuario específicas, políticas de interacción o mensajes exactos.
- Configuraciones, flags, parámetros, rutas o convenciones de naming.
- Algoritmos, reglas de negocio detalladas, políticas de resolución de conflictos.
- Proveedores, librerías, servicios o canales concretos no impuestos externamente.

## Regla práctica

Si al capturar el requerimiento aparece una decisión que incluye **nombres de partes internas, formatos, pasos técnicos o mecanismos de funcionamiento**, es una decisión de solución. No la registres como resuelta. Documenta una pregunta abierta con categoría `Ambigüedad de requisitos` o `Incertidumbre técnica` para que se resuelva en fases posteriores del workflow, con personas y casos de uso.
