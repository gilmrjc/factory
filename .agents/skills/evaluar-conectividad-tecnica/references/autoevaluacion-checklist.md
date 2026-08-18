# Autoevaluación Checklist: evaluar-conectividad-tecnica

Después de completar la evaluación de conectividad, responde estas preguntas:

1. **¿Analicé la infraestructura existente?**
   - [ ] Sí, mapeé auth, DB, APIs, servicios, frontend, monitoring (o declaré greenfield)
   - [ ] No, el análisis de infraestructura está incompleto

2. **¿Identifiqué los prerequisitos de la funcionalidad?**
   - [ ] Sí, listé componentes, integraciones y patrones necesarios
   - [ ] No, los prerequisitos no están claros

3. **¿Evalué la conectividad correctamente?**
   - [ ] Sí, determiné conectado/parcialmente conectado/desconectado con justificación que cita los criterios del SKILL.md Fase C
   - [ ] No, la evaluación de conectividad no es clara o no cita criterios

4. **¿Generé roadmap de funcionalidades puente cuando fue necesario?**
   - [ ] Sí, creé funcionalidades puente con valor propio y dependencias cuando la funcionalidad estuvo desconectada
   - [ ] No, no generé roadmap de funcionalidades puente cuando era necesario, o lo generé cuando no correspondía

5. **¿Las funcionalidades puente tienen valor propio?**
   - [ ] Sí, cada funcionalidad puente tiene un value proposition claro e independiente (no puramente preparatorio)
   - [ ] No, las funcionalidades puente no tienen valor por sí mismas o su único valor es preparar la funcionalidad objetivo

6. **¿Identifiqué las dependencias correctamente?**
   - [ ] Sí, las dependencias entre funcionalidades puente están claras y forman una secuencia sin ciclos
   - [ ] No, las dependencias no están identificadas o hay ciclos

7. **¿Definí el `status` y `next` del frontmatter correctamente?**
   - [ ] Sí, `status` y `next` apuntan al siguiente paso correcto según el veredicto de conectividad (`ready` si conectado/parcialmente conectado/desconectado, `blocked` sin `next` si información insuficiente), con `conditional` si hay preguntas Importantes sin resolver
   - [ ] No, el `status`/`next` no es claro, es incorrecto, o no refleja el estado de avance del gate

8. **¿Los documentos de salida son accionables?**
   - [ ] Sí, contienen recomendaciones claras y next steps
   - [ ] No, falta claridad en qué hacer después

9. **¿Ejecuté y documenté el gate de avance (Fase D)?**
   - [ ] Sí, el inventario de preguntas está completo, la alerta al usuario está documentada (si hubo), y el estado final de avance justifica el `status`/`next` del frontmatter
   - [ ] No, omití el gate, no documenté el inventario, o no registré la alerta

10. **¿Clasifiqué las preguntas abiertas por severidad y las heredé al siguiente skill?**
    - [ ] Sí, cada pregunta abierta tiene severidad (Crítica/Importante/Menor) y las pendientes se documentan para herencia
    - [ ] No, las preguntas abiertas no están clasificadas o se pierden al avanzar

Si alguna respuesta es "No", revisa y completa antes de marcar el skill como terminado.
