# El crew para no desarrolladores

No necesitas comandos ni conocer los roles. En un workspace Kiro con crew-kiro instalado, describe la decisión o el resultado en lenguaje normal; Kiro elige automáticamente al especialista pertinente.

```text
Ayúdame a decidir si esta oportunidad es comercialmente viable.
Convierte estas notas de stakeholders en criterios de aceptación claros.
Define los KPIs que demostrarían si funciona el onboarding.
Muéstrame qué está bloqueado y qué decisión destrabaría la entrega.
```

Si quieres intencionalmente una sola lente, un alias como `COM:`, `PROD:`, `FA:`, `COORD:` o `ANA:` es un override opcional.

## Trabajo ejecutivo y comercial

| Necesidad | Rol dueño |
|---|---|
| Discovery de cliente, viabilidad, manifiesto, mensaje del sitio público | `commercial-strategist` |
| Alcance, prioridad, roadmap, usuario objetivo y resultado de éxito | `product-strategist` |
| KPIs, funnels, taxonomía de eventos y medición de experimentos | `analytics-architect` |

Los briefs bajo `docs/briefs/` son documentos de decisión para revisión y aprobación humana. Puedes leer Markdown desde el host del repositorio sin herramientas locales.

No edites tablas de estimación de implementación, historial inmutable `docs/work/`, código o standards técnicos salvo que seas dueño de esas decisiones.

## Trabajo de análisis y entrega

| Necesidad | Rol dueño |
|---|---|
| Stories, criterios de aceptación, casos límite y validación funcional | `functional-analyst` |
| Secuencia, dependencias, bloqueos e integridad de handoffs | `delivery-coordinator` |
| Información que una pantalla debe mostrar y cómo se actúa sobre ella | `data-experience-architect` |

Stories y requirements son editables hasta Closed en modo team. Los ítems cerrados son historia; las correcciones van en ítems nuevos enlazados. Un ítem Ready necesita criterios completos, sin ambigüedad y al menos un escenario de prueba.

Quien ejecuta—no el analista—añade la tabla `## Estimation` durante planning y registra timestamps mientras sucede el trabajo.

## Cuando la solicitud cruza límites

Haz la pregunta completa una vez. El agente Kiro principal consulta otras autoridades cuando hace falta y devuelve una respuesta integrada con un dueño por decisión. No necesitas rutear tú los seguimientos técnicos.

Seguridad/compliance puede bloquear un manejo inseguro de datos sensibles o permisos. Los dueños humanos de producto, negocio y tecnología siguen aprobando sus decisiones; el routing automático no elimina responsabilidad humana.
