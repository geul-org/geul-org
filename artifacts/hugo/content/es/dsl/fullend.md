---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-09T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "Un CLI que valida cruzadamente cinco SSOTs (STML, OpenAPI, SSaC, SQL DDL, Terraform) y genera código. Llena las grietas del vibe coding con estructura."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — un CLI que valida cruzadamente cinco SSOTs a la vez y genera código.

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
Decisión: "Al crear una reserva, buscar la habitación. Si no existe, devolver 404. Si existe, crearla."
```

Esta única decisión se dispersa entre hooks de React, handlers de Go, consultas SQL, esquemas de API y recursos de Terraform. Cada parte se envuelve en la sintaxis de su framework, con manejo de errores y conversiones de tipos añadidos.

De 100.000 líneas de código, las decisiones son 12.500. Las 87.500 restantes son cableado.

Los agentes de IA tienen una ventana de contexto finita. Al agregar la décima función, no pueden recordar las nueve anteriores. No pueden leer 100.000 líneas de una vez.

Separa las decisiones y obtienes 12.500 líneas. Eso es el 55% de un contexto de 200K tokens. Un tamaño que la IA puede leer de una sola vez.

## Cinco SSOTs

Fullend asigna un DSL a cada una de las cinco capas que componen el software. Cada DSL se convierte en la fuente única de verdad (SSOT) de su capa.

| Capa | DSL | Qué declara |
|---|---|---|
| Interfaz | STML (HTML5 + data-*) | Qué mostrar y qué hacer |
| Contrato API | OpenAPI 3.x | Qué peticiones aceptar y qué respuestas devolver |
| Flujo de servicio | SSaC (Go comment DSL) | En qué orden procesar |
| Estructura de datos | SQL DDL + sqlc | Qué almacenar |
| Infraestructura | Terraform HCL | Dónde ejecutarlo |

OpenAPI, SQL DDL y Terraform son estándares de la industria. No existía un DSL SSOT para la interfaz ni para el flujo de servicio. Las decisiones del frontend estaban enterradas en hooks de React; los flujos de servicio estaban dispersos en handlers de Go. Por eso se diseñaron [STML](/es/dsl/stml/) y [SSaC](/es/dsl/ssac/). Son DSLs creados en este proyecto.

```
specs/
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
└── terraform/*.tf         → HCL
```

`specs/` es la verdad. `artifacts/` se puede regenerar en cualquier momento.

## La validación individual ya existe

Las herramientas de validación para tres capas ya existen.

- sqlc verifica la consistencia entre DDL y consultas.
- Los validadores de OpenAPI verifican la validez del esquema.
- Terraform verifica la sintaxis y dependencias de HCL.

También se crearon validadores integrados para STML y SSaC. SSaC verifica la consistencia interna de los flujos de servicio; STML verifica la alineación entre las declaraciones de UI y OpenAPI.

Cada una de las cinco capas puede validarse por separado. El problema ocurre **entre** ellas.

El frontend muestra un campo con `data-bind="memo"`, pero el esquema de respuesta de la API no tiene `memo`. SSaC llama a `@model Reservation.SoftDelete`, pero no existe el método `SoftDelete` en las consultas de sqlc. OpenAPI declara `x-sort: [created_at]`, pero la tabla DDL no tiene un índice en esa columna.

Las herramientas individuales solo ven su propia capa. No pueden ver las grietas entre capas.

## Ocultar la estructura

"Pero aun así hay que aprender cinco DSLs, ¿no?"

Sí. Pero la estructura no necesita mostrarse al usuario.

Si incluyes las reglas del stack tecnológico y SSOT en el prompt del sistema del agente, el usuario solo necesita decir "crea una función de reservas". El agente agrega automáticamente el endpoint en OpenAPI, crea la tabla en DDL, declara el flujo de servicio en SSaC, dibuja la pantalla en STML y ejecuta `fullend validate` para verificar la consistencia.

El usuario solo ve resultados. La estructura es algo que consume el agente, no algo que el usuario deba aprender.

La experiencia de vibe coding sigue igual. Lo que cambia es que las cosas dejan de romperse detrás de escena.

## El rol de Fullend

Fullend es un validador cruzado. No reinventa herramientas individuales. Llama a cada herramienta e inspecciona los límites entre capas.

```bash
fullend validate specs/
```

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✓ SSaC         7 service functions
✓ STML         4 pages, 6 bindings
✓ Cross        0 mismatches

All SSOT sources are consistent.
```

Si algo falla:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @model Reservation.SoftDelete — method not found in sqlc queries
✗ Cross        1 mismatch

FAILED: Fix errors before codegen.
```

Una vez que la validación pasa, genera código.

```bash
fullend gen specs/ artifacts/
```

sqlc genera modelos de base de datos, oapi-codegen genera tipos de API, SSaC genera funciones de servicio, STML genera componentes React, y Fullend genera el código de conexión que los une.

## Reglas de validación cruzada

El valor único de Fullend está en la validación cruzada.

**OpenAPI <-> DDL**

| Objetivo | Regla |
|---|---|
| x-sort.allowed | ¿Existe la columna en la tabla? |
| x-filter.allowed | ¿Existe la columna en la tabla? |
| x-include.allowed | ¿Es una tabla conectada por FK? |

**SSaC <-> DDL**

| Objetivo | Regla |
|---|---|
| @model Model.Method | ¿Existe el método en las consultas de sqlc? |
| @result Type | ¿Coincide con el tipo derivado de la tabla DDL? |
| @param nombre | ¿Se puede mapear a una columna DDL? |

**SSaC <-> OpenAPI**

| Objetivo | Regla |
|---|---|
| Nombre de función | ¿Coincide con un operationId? |
| @param request | ¿Existe el campo en el esquema de petición? |
| @result + response | ¿Existe el campo en el esquema de respuesta? |

**STML <-> SSaC** — Ambos referencian el mismo operationId de OpenAPI. Si ambas validaciones pasan, la API que llama el frontend y la API que procesa el backend quedan automáticamente garantizadas como consistentes.

## Diseñado para agentes

Fullend fue diseñado para agentes de IA.

Para que un agente escriba specs, necesita conocer los 10 tipos de secuencia de SSaC, los 12 atributos data-* de STML, las extensiones x- de OpenAPI y las reglas de coincidencia de nombres. Para esto se proporciona un manual de aproximadamente 350 líneas para IA. Solo necesita agregarse una vez al prompt del sistema del agente.

El ciclo de validación después de escribir specs es sencillo.

```
Flujo de trabajo del agente:
1. Modificar specs/
2. fullend validate specs/
3. Si hay errores → corregir el SSOT correspondiente → ir a 2
4. Cero errores → fullend gen specs/ artifacts/
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

Lo que los 10 tipos de secuencia no pueden manejar se delega a `call`. Lo que los atributos data-* no pueden manejar se delega a `custom.ts`. Si estas válvulas de escape superan el 20% del total, la estructuración pierde su sentido.

Pero las excepciones se vuelven observables en el momento en que se aíslan. A medida que muchos proyectos se estructuren con Fullend, los patrones recurrentes en `call` y `custom.ts` emergerán.

Los 10 tipos de secuencia de SSaC tampoco se diseñaron desde cero. Convergieron a 10 tras observar cientos de ejemplos de código de servicio. Se espera que el mismo principio se repita con las válvulas de escape. Los patrones frecuentes de `call` se convertirán en nuevos tipos de secuencia; los patrones frecuentes de `custom.ts` se convertirán en nuevos atributos data-*.

Las excepciones no disminuyen — la estructura crece a partir de ellas.

## Expansión del stack tecnológico

Actualmente, Fullend está fijo en Go + React + PostgreSQL + Terraform. Esto es intencional. En la etapa de PoC, lo primero es atravesar completamente un stack.

Sin embargo, tres de los cinco SSOTs (OpenAPI, SQL DDL, Terraform) ya son independientes del lenguaje. Los 10 tipos de secuencia de SSaC son patrones agnósticos al lenguaje — simplemente se expresan como comentarios de Go. STML usa atributos HTML5 data-* y es independiente del framework.

La expansión es cuestión de agregar backends de generación de código. La lógica de validación y las reglas de validación cruzada se mantienen sin cambios.

## Relación con GEUL

Cinco DSLs componen el SSOT del software. Un SSOT son datos estructurados. Los datos estructurados son un grafo. Un grafo se puede codificar en GEUL.

El `data-fetch="ListReservations"` de STML es una relación entre entidades. El `@sequence get → @model → @guard → @response` de SSaC es una secuencia de eventos. Las definiciones de endpoints de OpenAPI son contratos. Todas son estructuras semánticas expresables como aristas triple, aristas event6 y nodos entidad de GEUL.

La forma en que Fullend realiza la validación cruzada entre cinco DSLs — coincidencia simbólica, verificación de consistencia de tipos, verificación de integridad referencial — opera bajo el mismo principio que la verificación mecánica en los flujos de GEUL.

## Licencia

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
