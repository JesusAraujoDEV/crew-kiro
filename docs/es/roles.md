# Catálogo de roles

25 roles, invocados como `/crew:<alias>` (o el prefijo `ALIAS:` donde esté activado). Léelos de dos formas: por **flujo de entrega** (cuándo actúa cada uno — ver la tabla en el [README](README.md#cómo-fluye-el-trabajo)) y por **área** (cómo están organizados, abajo). Tabla de propiedad completa: [`templates/AGENTS.md`](../../templates/AGENTS.md).

## Por área

Cada rol pertenece a exactamente una de seis áreas, de descubrimiento a gobernanza — el plugin no es solo arquitectos, cubre todo el arco.

**1. Negocio y Descubrimiento** — entender qué necesita el cliente, juzgar la viabilidad de negocio, redactar el manifiesto que inicia el proyecto.

| Alias | Rol | Qué hace |
|-------|-----|----------|
| `COM` | commercial-strategist | Descubrimiento con el cliente y viabilidad de negocio; redacta el manifiesto del proyecto — la puerta de entrada, aguas arriba de producto. |
| `PROD` | product-strategist | Visión de producto, roadmap, jobs-to-be-done, priorización y métricas de éxito — aguas arriba de todo rol de producto. |

**2. Producto y Entrega** — convertir la intención en producto y en trabajo ejecutable: stories, criterios de aceptación, secuenciación del equipo.

| Alias | Rol | Qué hace |
|-------|-----|----------|
| `FA` | functional-analyst | Descompone la intención en stories con criterios de aceptación; valida el trabajo entregado contra ellos. |
| `COORD` | delivery-coordinator | Secuencia roles, expone bloqueos, mantiene la fidelidad de la intención — coordinación, no decisiones técnicas ni de producto. |

**3. Diseño y Experiencia** — qué información necesita cada pantalla, cómo se ve y se comporta, y el sistema visual transversal.

| Alias | Rol | Qué hace |
|-------|-----|----------|
| `DEA` | data-experience-architect | Define la especificación informacional por pantalla — qué datos necesita cada vista. |
| `UX` | ux-architect | Layout, interacción, flujo y accesibilidad. |
| `VIS` | visual-identity | Sistema visual transversal: design tokens, tipografía, color, motion, iconografía. |
| `WEB` | web-strategist | Estrategia de marca y contenido para la web pública: posicionamiento, sitemap, mensaje. |
| `COMM` | communications-strategist | La artesanía de CÓMO se comunica cualquier pieza escrita — brief, deck, one-pager, ensayo, doc técnico, discurso, guion: idea-fuerza, arco narrativo, segmentación por público, principios de impacto. Posee el cómo, no el contenido de dominio. |

**4. Ingeniería y Arquitectura** — cómo se construye el sistema: arquitectura, datos, frontend, extensión y contratos de API pública.

| Alias | Rol | Qué hace |
|-------|-----|----------|
| `SYS` | system-architect | Arquitectura, contratos de API, patrones entre módulos. |
| `DA` | data-architect | Esquema, integridad, migraciones, rendimiento de consultas. |
| `MOD` | module-extension-architect | El contrato de extensión plataforma-base ↔ módulos/productos. |
| `DX` | dx-architect | Experiencia de desarrollador de la API/SDK pública: versionado, deprecación, ergonomía. |
| `FE` | frontend-architect | Estado de frontend, fetching de datos, routing, formularios. |

**5. Calidad, Seguridad y Operaciones** — que lo construido sea correcto, seguro, medible y entregable: testing, seguridad, rendimiento, infra, release, analítica.

| Alias | Rol | Qué hace |
|-------|-----|----------|
| `SEC` | security-compliance | Datos personales, RBAC, regulatorio — puede interrumpir a cualquier rol. |
| `QA` | qa-test-architect | Estrategia de testing, fixtures, cobertura de regresión. |
| `SC` | spec-compliance | Veredicto post-implementación: código vs. las especificaciones escritas. |
| `PERF` | performance-reliability | SLOs, error budgets, observabilidad en runtime, presupuestos de rendimiento. |
| `INFRA` | atlas-deploy | Infra cloud, CI/CD, topología de despliegue. |
| `REL` | release-manager | Ciclo de vida del release, versionado, orden de publicación, changelog. |
| `ANA` | analytics-architect | Taxonomía de eventos, KPIs, instrumentación, funnels. |

**6. Gobernanza y Meta** — el propio catálogo y la documentación: roles, estándares, docs, exploración de solo lectura.

| Alias | Rol | Qué hace |
|-------|-----|----------|
| `DOC` | documentation-steward | Estructura de docs, ciclo de vida y prevención de drift. |
| `LEA` | researcher | Exploración de solo lectura — devuelve hallazgos, nunca recomendaciones. |
| `CA` | crew-architect | El catálogo de roles en sí: añadir/fusionar/retirar roles, resolver solapamientos de autoridad, mantener los docs de rol consistentes. |
| `INST` | crew-installer | Instala/activa la crew en un destino para que el prefijo `ALIAS:` funcione. |
