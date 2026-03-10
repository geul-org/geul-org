---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "Un CLI que valida cruzadamente 10 SSOTs y genera código. Llena las grietas del vibe coding con estructura."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — un CLI que valida la consistencia de 10 SSOTs a la vez y genera código.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Repositorio en GitHub</a>

## Las grietas del vibe coding

Con la popularización del vibe coding, un patrón comenzó a emerger.

Le pides a una IA que "cree una función de reservas" y la crea. Le dices "agrega la función de cancelación" y la agrega. Al llegar a la quinta función, la segunda se rompe. Cambias el esquema de la API pero no actualizas el frontend. Agregas una columna en la base de datos pero la capa de servicio no lo sabe.

La causa es simple: la IA no puede recordar todo el código.

Entonces la gente hace esto: cuando algo se rompe, le dicen a la IA "arregla esto también". Lo arregla y otra cosa se rompe. "Arregla eso también." El ciclo se repite. Cuanto más grande es el proyecto, más largo es el ciclo, hasta que llega el momento en que "sería más rápido empezar de cero".

## Por qué el código crece tanto

El código mezcla dos cosas.

**Decisiones**: qué mostrar, qué API llamar, en qué orden procesar, qué almacenar.
**Cableado**: el código que implementa esas decisiones en un framework específico.

Supongamos que estás construyendo un sistema de reservas.

```
Decisión: "Al cancelar una reserva, verificar permisos → consultar → validar transición de estado → calcular reembolso → cambiar estado → responder"
```

Esta única decisión se dispersa entre hooks de React, handlers de Go, consultas SQL, esquemas de API y recursos de Terraform. Cada parte se envuelve en la sintaxis de su framework, con manejo de errores y conversiones de tipos añadidos.

De 100.000 líneas de código, las decisiones son 12.500. Las 87.500 restantes son cableado.

Los agentes de IA tienen una ventana de contexto finita. Al agregar la décima función, no pueden recordar las nueve anteriores. No pueden leer 100.000 líneas de una vez.

Separa las decisiones y obtienes 12.500 líneas. Eso es el 55% de un contexto de 200K tokens. Un tamaño que la IA puede leer de una sola vez.

## 10 SSOTs

Fullend separa todas las decisiones del software en 10 especificaciones declarativas. Cada especificación se convierte en la fuente única de verdad (SSOT) de su área de interés.

| Área de interés | SSOT | Qué declara |
|---|---|---|
| Configuración del proyecto | fullend.yaml | Stack tecnológico, middleware, rutas de módulos |
| Interfaz | [STML](/es/dsl/stml/) (HTML5 + data-*) | Qué mostrar y qué hacer |
| Contrato API | OpenAPI 3.x | Qué peticiones aceptar y qué respuestas devolver |
| Flujo de servicio | [SSaC](/es/dsl/ssac/) (Go comment DSL) | En qué orden procesar |
| Estructura de datos | SQL DDL + sqlc | Qué almacenar |
| Funciones externas | Func Spec (Go) | Interfaz e implementación de lógica personalizada |
| Transiciones de estado | Mermaid stateDiagram | Por qué estados pasa un recurso |
| Políticas de autorización | OPA Rego | Quién puede hacer qué |
| Escenarios | Gherkin (.feature) | Validación de flujos de negocio entre endpoints |
| Infraestructura | Terraform HCL | Dónde ejecutarlo |

OpenAPI, SQL DDL y Terraform son estándares de la industria. Las demás áreas de interés no contaban con un DSL SSOT correspondiente. Los flujos de servicio estaban dispersos en handlers de Go, las decisiones de interfaz estaban enterradas en hooks de React, las transiciones de estado se escondían en ramas if-else y los permisos estaban codificados en el middleware. Por eso se diseñaron STML, SSaC, Func Spec, la integración con stateDiagram, la integración con OPA y la integración con Gherkin. Son DSLs e integraciones creados en este proyecto.

```
specs/my-project/
├── fullend.yaml           → Configuración del proyecto
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
├── func/<pkg>/*.go        → Func Spec
├── states/*.md            → Mermaid stateDiagram
├── policy/*.rego          → OPA Rego
├── scenario/*.feature     → Gherkin
└── terraform/*.tf         → HCL
```

`specs/` es la verdad. `artifacts/` se puede regenerar en cualquier momento.

## La validación individual ya existe

Las herramientas de validación para varias capas ya existen.

- sqlc verifica la consistencia entre DDL y consultas.
- Los validadores de OpenAPI verifican la validez del esquema.
- Terraform verifica la sintaxis y dependencias de HCL.

También se crearon validadores integrados para STML y SSaC. SSaC verifica la consistencia interna de los flujos de servicio; STML verifica la alineación entre las declaraciones de UI y OpenAPI.

Cada SSOT puede validarse por separado. El problema ocurre **entre** ellos.

El frontend muestra un campo con `data-bind="memo"`, pero el esquema de respuesta de la API no tiene `memo`. SSaC llama a `@delete Reservation.SoftDelete(request.ReservationID)`, pero no existe el método `SoftDelete` en las consultas de sqlc. El diagrama de estados define una transición `PublishCourse`, pero no existe la función correspondiente en SSaC. La política OPA consulta la propiedad del recurso `course` mediante `courses.instructor_id`, pero esa columna no existe en DDL.

Las herramientas individuales solo ven su propia capa. No pueden ver las grietas entre capas.

## Ocultar la estructura

"Pero aun así hay que aprender 10 DSLs, ¿no?"

Sí. Pero la estructura no necesita mostrarse al usuario.

Si incluyes las reglas del stack tecnológico y SSOT en el prompt del sistema del agente, el usuario solo necesita decir "crea una función de reservas". El agente agrega automáticamente el endpoint en OpenAPI, crea la tabla en DDL, declara el flujo de servicio en SSaC, dibuja el diagrama de estados, escribe la política OPA, dibuja la pantalla en STML y ejecuta `fullend validate` para verificar la consistencia.

El usuario solo ve resultados. La estructura es algo que consume el agente, no algo que el usuario deba aprender.

La experiencia de vibe coding sigue igual. Lo que cambia es que las cosas dejan de romperse detrás de escena.

## El rol de Fullend

Fullend es un validador cruzado. No reinventa herramientas individuales. Llama a cada herramienta e inspecciona los límites entre SSOTs.

```bash
fullend validate specs/my-project
```

```
✓ Config       fullend.yaml valid
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✓ SSaC         7 service functions
✓ STML         4 pages, 6 bindings
✓ States       2 diagrams
✓ Policy       3 rules
✓ Scenario     2 features
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

Si algo falla:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

Una vez que la validación pasa, genera código.

```bash
fullend gen specs/my-project artifacts/my-project
```

sqlc genera modelos de base de datos, oapi-codegen genera tipos de API, SSaC genera handlers de gin, STML genera componentes React, se generan el paquete de máquina de estados y el OPA Authorizer, Gherkin genera tests Hurl, y Fullend genera el código de conexión que los une.

## Reglas de validación cruzada

El valor único de Fullend está en la validación cruzada. Después de que cada herramienta valida su propia capa, Fullend detecta las inconsistencias entre SSOTs.

**OpenAPI ↔ DDL**

| Objetivo | Regla |
|---|---|
| x-sort.allowed | ¿Existe la columna en la tabla? |
| x-sort ↔ DDL index | ¿Tiene la columna un índice? (WARNING) |
| x-filter.allowed | ¿Existe la columna en la tabla? |
| x-include.allowed | ¿Es una tabla conectada por FK? |

**SSaC ↔ DDL**

| Objetivo | Regla |
|---|---|
| Model.Method | ¿Existe el método en las consultas de sqlc? |
| @result Type | ¿Coincide con el tipo derivado de la tabla DDL? |
| Campo de argumento | ¿Se puede convertir a una columna DDL? |

**SSaC ↔ OpenAPI**

| Objetivo | Regla |
|---|---|
| Nombre de función | ¿Coincide con un operationId? |
| Argumento request | ¿Existe el campo en el esquema de petición? |
| Campo @response | ¿Existe el campo en el esquema de respuesta? |

**States ↔ SSaC ↔ OpenAPI**

| Objetivo | Regla |
|---|---|
| Evento de transición | ¿Coincide con un nombre de función SSaC? |
| Evento de transición | ¿Coincide con un operationId de OpenAPI? |
| SSaC @state | ¿Existe el stateDiagram referenciado? |
| Campo @state | ¿Existe como columna DDL? |

**Policy ↔ SSaC ↔ DDL**

| Objetivo | Regla |
|---|---|
| allow (action, resource) | ¿Coincide con @auth de SSaC? |
| @ownership table.column | ¿Existe en DDL? |
| @ownership via join | ¿Existen las FK de la tabla de unión en DDL? |

**Func ↔ SSaC**

| Objetivo | Regla |
|---|---|
| Referencia @call | ¿Existe la implementación Func correspondiente? |
| Cantidad/tipo de argumentos | ¿Coinciden los argumentos de @call con los campos de Request? |
| Cuerpo de la función | ¿No es un stub TODO? (WARNING) |

**Scenario ↔ OpenAPI**

| Objetivo | Regla |
|---|---|
| operationId | ¿Existe en OpenAPI? |
| HTTP method | ¿Coincide con el método de OpenAPI? |
| Campo JSON | ¿Existe en el esquema de petición? |

**STML ↔ SSaC** — Ambos referencian el mismo operationId de OpenAPI. Si ambas validaciones pasan, la API que llama el frontend y la API que procesa el backend quedan automáticamente garantizadas como consistentes.

## Diseñado para agentes

Fullend fue diseñado para agentes de IA.

Para que un agente escriba specs, necesita conocer los 10 tipos de secuencia de SSaC, los atributos data-* de STML, las extensiones x- de OpenAPI, las reglas de stateDiagram, los patrones de políticas OPA, la sintaxis de escenarios Gherkin, las reglas de Func Spec y las reglas de coincidencia de nombres. Para esto se proporciona un manual de aproximadamente 830 líneas para IA. Solo necesita agregarse una vez al prompt del sistema del agente.

El ciclo de validación después de escribir specs es sencillo.

```
Flujo de trabajo del agente:
1. Modificar specs/
2. fullend validate specs/my-project
3. Si hay errores → corregir el SSOT correspondiente → ir a 2
4. Cero errores → fullend gen specs/my-project artifacts/my-project
```

No es necesario entender todo el sistema. Solo hay que corregir lo que validate señala y la consistencia se restaura. Un modelo inteligente acierta a la primera; un modelo más pequeño lo logra en tres intentos. El resultado es el mismo.

## Tamaño del SSOT por escala

| Escala | Ejemplo | SSOT | Código de implementación | Uso de contexto |
|---|---|---|---|---|
| Pequeño | Reservas de peluquería | ~1.500 líneas | ~10K líneas | ~8% |
| Mediano | Clase Jira/Notion | ~12.500 líneas | ~100K líneas | ~55% |
| Grande | Clase Shopify | ~30.000 líneas | ~300K líneas | ~90% |

Basado en un contexto de 200K tokens. Hasta un SaaS mediano, un agente puede leer todo el diseño de una sola vez.

## Convertir excepciones en patrones

Lo que los 10 tipos de secuencia no pueden manejar se delega a `@call`. Lo que los atributos data-* no pueden manejar se delega a `custom.ts`. Si estos mecanismos de escape superan el 20% del total, la estructuración pierde su sentido.

Pero las excepciones se vuelven observables en el momento en que se aíslan. A medida que muchos proyectos se estructuren con Fullend, los patrones recurrentes en `@call` y `custom.ts` emergerán.

Los 10 tipos de secuencia de SSaC tampoco se diseñaron desde cero. Convergieron a 10 tras observar cientos de ejemplos de código de servicio. Se espera que el mismo principio se repita con los mecanismos de escape. Los patrones frecuentes de `@call` se convertirán en nuevos tipos de secuencia; los patrones frecuentes de `custom.ts` se convertirán en nuevos atributos data-*.

Las excepciones no disminuyen — la estructura crece a partir de ellas.

## Expansión del stack tecnológico

Actualmente, Fullend está fijo en Go (gin) + React + PostgreSQL + Terraform. Esto es intencional. En la etapa de PoC, lo primero es atravesar completamente un stack.

Sin embargo, gran parte de los 10 SSOTs (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) ya son independientes del lenguaje. Los 10 tipos de secuencia de SSaC son patrones agnósticos al lenguaje — simplemente se expresan como comentarios de Go. STML usa atributos HTML5 data-* y es independiente del framework.

La expansión es cuestión de agregar backends de generación de código. La lógica de validación y las reglas de validación cruzada se mantienen sin cambios.

## Relación con GEUL

Los 10 SSOTs componen todas las decisiones del software. Un SSOT son datos estructurados. Los datos estructurados son un grafo. Un grafo se puede codificar en GEUL.

El `data-fetch="ListReservations"` de STML es una relación entre entidades. El `@get → @empty → @state → @call → @put → @response` de SSaC es una secuencia de eventos. Las transiciones de stateDiagram son un grafo de estados. Las políticas OPA son relaciones de autorización. Las definiciones de endpoints de OpenAPI son contratos. Todas son estructuras semánticas expresables como aristas triple, aristas event6 y nodos entidad de GEUL.

La forma en que Fullend realiza la validación cruzada entre 10 SSOTs — coincidencia simbólica, verificación de consistencia de tipos, verificación de integridad referencial — opera bajo el mismo principio que la verificación mecánica en los flujos de GEUL.

## Licencia

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
