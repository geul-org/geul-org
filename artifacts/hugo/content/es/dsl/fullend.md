---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "Un CLI que valida la consistencia cruzada de 10 SSOTs y genera codigo. Llena las grietas del vibe coding con estructura."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — un CLI que valida la consistencia de 10 SSOTs a la vez y genera codigo.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">Repositorio en GitHub</a>

## Las grietas del vibe coding

Con la popularizacion del vibe coding, un patron comenzo a emerger.

Le pides a una IA que "cree una funcion de reservas" y la crea. Le dices "agrega la funcion de cancelacion" y la agrega. Al agregar la quinta funcion, la segunda se rompe. Cambias el esquema de la API pero no actualizas el frontend. Agregas una columna en la base de datos pero la capa de servicio no lo sabe.

La causa es simple: la IA no puede recordar todo el codigo.

Entonces la gente hace esto: cuando algo se rompe, le dicen a la IA "arregla esto tambien". Lo arregla y otra cosa se rompe. "Arregla eso tambien." El ciclo se repite. Cuanto mas grande es el proyecto, mas largo es el ciclo, hasta que llega el momento en que "seria mas rapido empezar de cero".

## Por que el codigo crece tanto

El codigo mezcla dos cosas.

**Decisiones**: que mostrar, que API llamar, en que orden procesar, que almacenar.
**Cableado**: el codigo que implementa esas decisiones en un framework especifico.

Supongamos que estas construyendo un sistema de reservas.

```
Decision: "Al cancelar una reserva, verificar permisos → consultar → validar transicion de estado → calcular reembolso → cambiar estado → responder"
```

Esta unica decision se dispersa entre hooks de React, handlers de Go, consultas SQL, esquemas de API y recursos de Terraform. Cada parte se envuelve en la sintaxis de su framework, con manejo de errores y conversiones de tipos anadidos.

De 100.000 lineas de codigo, las decisiones son 12.500. Las 87.500 restantes son cableado.

Los agentes de IA tienen una ventana de contexto finita. Al agregar la decima funcion, no pueden recordar las nueve anteriores. No pueden leer 100.000 lineas de una vez.

Separa las decisiones y obtienes 12.500 lineas. Eso es el 55% de un contexto de 200K tokens. Un tamano que la IA puede leer de una sola vez.

## 10 SSOTs

Fullend separa todas las decisiones del software en 10 especificaciones declarativas. Cada especificacion se convierte en la fuente unica de verdad (SSOT) de su area de interes.

| Area de interes | SSOT | Que declara |
|---|---|---|
| Configuracion del proyecto | fullend.yaml | Stack tecnologico, middleware, rutas de modulos |
| Interfaz | [STML](/es/dsl/stml/) (HTML5 + data-*) | Que mostrar y que hacer |
| Contrato API | OpenAPI 3.x | Que peticiones aceptar y que respuestas devolver |
| Flujo de servicio | [SSaC](/es/dsl/ssac/) (.ssac DSL) | En que orden procesar |
| Estructura de datos | SQL DDL + sqlc | Que almacenar |
| Funciones externas | Func Spec (Go) | Interfaz e implementacion de logica personalizada |
| Transiciones de estado | Mermaid stateDiagram | Por que estados pasa un recurso |
| Politicas de autorizacion | OPA Rego | Quien puede hacer que |
| Escenarios | Gherkin (.feature) | Validacion de flujos de negocio entre endpoints |
| Infraestructura | Terraform HCL | Donde ejecutarlo |

OpenAPI, SQL DDL y Terraform son estandares de la industria. Las demas areas de interes no contaban con un DSL SSOT correspondiente. Los flujos de servicio estaban dispersos en handlers de Go, las decisiones de interfaz estaban enterradas en hooks de React, las transiciones de estado se escondian en ramas if-else y los permisos estaban codificados en el middleware. Por eso se disenaron STML, SSaC, Func Spec, la integracion con stateDiagram, la integracion con OPA y la integracion con Gherkin.

```
specs/my-project/
├── fullend.yaml             → Configuracion del proyecto
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc queries
├── service/**/*.ssac        → SSaC (extension .ssac)
├── model/*.go               → Go structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` es la verdad. `artifacts/` se puede regenerar en cualquier momento.

## La validacion individual ya existe

Las herramientas de validacion para varias capas ya existen.

- sqlc verifica la consistencia entre DDL y consultas.
- Los validadores de OpenAPI verifican la validez del esquema.
- Terraform verifica la sintaxis y dependencias de HCL.

Tambien se crearon validadores integrados para STML y SSaC. SSaC verifica la consistencia interna de los flujos de servicio; STML verifica la alineacion entre las declaraciones de UI y OpenAPI.

Cada SSOT puede validarse por separado. El problema ocurre **entre** ellos.

El frontend muestra un campo con `data-bind="memo"`, pero el esquema de respuesta de la API no tiene `memo`. SSaC llama a `@delete Reservation.SoftDelete(request.ReservationID)`, pero no existe el metodo `SoftDelete` en las consultas de sqlc. El diagrama de estados define una transicion `PublishCourse`, pero no existe la funcion correspondiente en SSaC. La politica OPA consulta la propiedad del recurso `course` mediante `courses.instructor_id`, pero esa columna no existe en DDL.

Las herramientas individuales solo ven su propia capa. No pueden ver las grietas entre capas.

## Ocultar la estructura

"Pero aun asi hay que aprender 10 DSLs, ¿no?"

Si. Pero la estructura no necesita mostrarse al usuario.

Si incluyes las reglas del stack tecnologico y SSOT en el prompt del sistema del agente, el usuario solo necesita decir "crea una funcion de reservas". El agente agrega automaticamente el endpoint en OpenAPI, crea la tabla en DDL, declara el flujo de servicio en SSaC, dibuja el diagrama de estados, escribe la politica OPA, dibuja la pantalla en STML y ejecuta `fullend validate` para verificar la consistencia.

El usuario solo ve resultados. La estructura es algo que consume el agente, no algo que el usuario deba aprender.

La experiencia de vibe coding sigue igual. Lo que cambia es que las cosas dejan de romperse detras de escena.

## El rol de Fullend

Fullend es un validador cruzado. No reinventa herramientas individuales. Llama a cada herramienta e inspecciona los limites entre SSOTs.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

Valida individualmente los 10 SSOTs y luego realiza la validacion cruzada. Func solo se valida cuando existe el directorio `func/`. Con `--skip` se pueden excluir SSOTs especificos.

```
✓ Config       my-project, go/gin, typescript/react
✓ OpenAPI      7 endpoints
✓ DDL          3 tables, 18 columns
✓ SSaC         7 service functions
✓ Model        3 files
✓ STML         4 pages, 6 bindings
✓ States       1 diagrams, 3 transitions
✓ Policy       1 files, 5 rules, 3 ownership mappings
✓ Scenario     4 features, 5 scenarios
✓ Func         3 funcs
✓ Terraform    2 files
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

Una vez que la validacion pasa, genera codigo. La opcion `--skip` se usa igual que en validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc genera modelos de base de datos, oapi-codegen genera tipos de API, SSaC genera handlers de gin, STML genera componentes React, se generan el paquete de maquina de estados y el OPA Authorizer, Gherkin genera tests Hurl, y Fullend genera el codigo de conexion que los une.

### gen-model

Genera archivos de modelo Go (interfaz + tipos + cliente HTTP) a partir de un documento OpenAPI externo. Acepta archivos locales o URLs como entrada.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

Rastrea todos los nodos SSOT conectados a una operacion de API. Al ingresar un operationId, devuelve un mapa file:line de todas las capas.

```bash
fullend chain <operationId> <specs-dir>
```

```
── Feature Chain: AcceptProposal ──

  OpenAPI    api/openapi.yaml:296                          POST /proposals/{id}/accept
  SSaC       service/proposal/accept_proposal.ssac:19      @get @empty @auth @state @put @call @post @response
  DDL        db/gigs.sql:1                                 CREATE TABLE gigs
  DDL        db/proposals.sql:1                            CREATE TABLE proposals
  DDL        db/transactions.sql:1                         CREATE TABLE transactions
  Rego       policy/authz.rego:3                           resource: gig
  StateDiag  states/gig.md:7                               diagram: gig → AcceptProposal
  StateDiag  states/proposal.md:6                          diagram: proposal → AcceptProposal
  FuncSpec   func/billing/hold_escrow.go:8                 @func billing.HoldEscrow
  Gherkin    scenario/gig_lifecycle.feature:4              Scenario: Happy Path - Full Gig Lifecycle
```

### status

Muestra un resumen del estado de los SSOTs detectados.

```bash
fullend status <specs-dir>
```

```
SSOT Status:
  OpenAPI      api/openapi.yaml               7 endpoints
  DDL          db                             3 tables, 18 columns
  SSaC         service                        7 functions
  STML         frontend                       4 pages
  States       states                         1 diagrams, 3 transitions
  Policy       policy                         1 files, 5 rules
  Scenario     scenario                       4 features, 5 scenarios
  Func         func                           3 funcs
```

## Funciones y modelos integrados

Fullend incluye implementaciones de funciones de uso frecuente e interfaces de modelos. Se pueden invocar con `@call` desde SSaC.

### Default Functions (pkg/)

| Paquete | Funcion | Descripcion |
|---|---|---|
| `auth` | `hashPassword` | Hashing de contrasena con bcrypt |
| `auth` | `verifyPassword` | Verificacion de contrasena con bcrypt |
| `auth` | `issueToken` | Generacion de token de acceso JWT (24h) |
| `auth` | `verifyToken` | Verificacion de token JWT + extraccion de claims |
| `auth` | `refreshToken` | Generacion de refresh token (7 dias) |
| `auth` | `generateResetToken` | Token hex aleatorio para restablecimiento de contrasena |
| `crypto` | `encrypt` | Cifrado simetrico AES-256-GCM |
| `crypto` | `decrypt` | Descifrado AES-256-GCM |
| `crypto` | `generateOTP` | Secreto TOTP + URL de aprovisionamiento QR |
| `crypto` | `verifyOTP` | Verificacion de codigo TOTP |
| `storage` | `uploadFile` | Subida de archivos compatible con S3 |
| `storage` | `deleteFile` | Eliminacion de archivos compatible con S3 |
| `storage` | `presignURL` | URL de descarga presigned de S3 |
| `mail` | `sendEmail` | Correo electronico de texto plano por SMTP |
| `mail` | `sendTemplateEmail` | Correo electronico HTML con plantilla Go (SMTP) |
| `text` | `generateSlug` | Unicode → slug seguro para URL |
| `text` | `sanitizeHTML` | Sanitizacion de HTML contra XSS |
| `text` | `truncateText` | Truncado de texto seguro para Unicode |
| `image` | `ogImage` | Generacion de imagen OG (1200x630, PNG) |
| `image` | `thumbnail` | Generacion de miniatura (200x200, PNG) |

Si se coloca una implementacion con el mismo nombre en `specs/<project>/func/<pkg>/`, se sobreescribe la predeterminada.

### Built-in Models (pkg/)

Interfaces @model con prefijo de paquete para I/O no relacional que no se define con DDL. El backend se configura en `fullend.yaml`.

| Paquete | Interfaz | Backend | Uso en SSaC |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (generado)

Fullend genera `internal/middleware/bearerauth.go` especifico del proyecto a partir de la configuracion de claims en `fullend.yaml`.

| Middleware | Disparador | Descripcion |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | Extrae `*model.CurrentUser` del JWT y lo establece en el contexto de gin |

El campo `security` de OpenAPI determina los grupos de rutas. Las operaciones con `security: [{bearerAuth: []}]` pertenecen al grupo auth; las que no lo tienen, al grupo public.

## Reglas de validacion cruzada

El valor unico de Fullend esta en la validacion cruzada. Despues de que cada herramienta valida su propia capa, Fullend detecta las inconsistencias entre SSOTs.

**fullend.yaml ↔ OpenAPI**
| Objetivo de validacion | Regla |
|---|---|
| Nombre de middleware | ¿Coincide con la clave de securitySchemes? |

**OpenAPI ↔ DDL**
| Objetivo de validacion | Regla |
|---|---|
| x-sort.allowed | ¿Existe la columna en la tabla? |
| x-sort ↔ DDL index | ¿Tiene la columna un indice? (WARNING) |
| x-filter.allowed | ¿Existe la columna en la tabla? |
| x-include.allowed | ¿Es una tabla conectada por FK? |

**SSaC ↔ DDL**
| Objetivo de validacion | Regla |
|---|---|
| Model.Method | ¿Existe el metodo en las consultas de sqlc? |
| @result Type | ¿Coincide con el tipo derivado de la tabla DDL? |
| Campo de argumento | ¿Se puede convertir a una columna DDL? |

**SSaC ↔ OpenAPI**
| Objetivo de validacion | Regla |
|---|---|
| Nombre de funcion | ¿Coincide con un operationId? |
| Argumento request | ¿Existe el campo en el esquema de peticion? |
| Campo @response | ¿Existe el campo en el esquema de respuesta? |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**
| Objetivo de validacion | Regla |
|---|---|
| Evento de transicion | ¿Coincide con un nombre de funcion SSaC? |
| Evento de transicion | ¿Coincide con un operationId de OpenAPI? |
| SSaC @state | ¿Existe el stateDiagram referenciado? |
| Campo @state | ¿Existe como columna DDL? |

**Policy ↔ SSaC ↔ DDL ↔ States**
| Objetivo de validacion | Regla |
|---|---|
| allow (action, resource) | ¿Coincide con @auth de SSaC? |
| @ownership table.column | ¿Existe en DDL? |
| @ownership via join | ¿Existen las FK de la tabla de union en DDL? |
| Evento de transicion de estado | ¿Existe una regla Rego correspondiente a la transicion con @auth? |

**Func ↔ SSaC**
| Objetivo de validacion | Regla |
|---|---|
| Referencia @call | ¿Existe la implementacion Func correspondiente? |
| Cantidad de argumentos | ¿Coincide el numero de argumentos de @call con los campos de Request? |
| Tipo de argumentos | ¿Coinciden los tipos por posicion a traves de DDL/OpenAPI? |
| Resultado/respuesta | ¿Hay consistencia en result/response? |
| Cuerpo de la funcion | ¿No es un stub TODO? (WARNING) |

**Scenario ↔ OpenAPI ↔ States**
| Objetivo de validacion | Regla |
|---|---|
| operationId | ¿Existe en OpenAPI? |
| HTTP method | ¿Coincide con el metodo de OpenAPI? |
| Campo JSON | ¿Existe en el esquema de peticion? |
| Orden de pasos | ¿Sigue las reglas de transicion de estado? |

**Queue (Pub/Sub)**
| Objetivo de validacion | Regla |
|---|---|
| @publish topic | ¿Existe una funcion @subscribe correspondiente? |
| Campos payload/message | ¿Hay consistencia? |
| Configuracion de queue | ¿Existe queue config en fullend.yaml? |

**STML ↔ SSaC** — Ambos referencian el mismo operationId de OpenAPI. Si ambas validaciones pasan, la consistencia entre la API que llama el frontend y la API que procesa el backend queda automaticamente garantizada.

## Testing en tiempo de ejecucion

`fullend gen` genera tests [Hurl](https://hurl.dev) a partir de las especificaciones OpenAPI y los escenarios Gherkin.

```bash
# Despues de iniciar el servidor:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

Tests generados:
- **smoke.hurl** — Test de humo de endpoints OpenAPI (generado automaticamente)
- **scenario-*.hurl** — Tests de escenarios de negocio (generados a partir de archivos .feature)
- **invariant-*.hurl** — Tests de invariantes entre endpoints (generados a partir de archivos .feature)

## Disenado para agentes

Fullend fue disenado para agentes de IA.

Para que un agente escriba specs, necesita conocer los 10 tipos de secuencia de SSaC, los atributos data-* de STML, las extensiones x- de OpenAPI, las reglas de stateDiagram, los patrones de politicas OPA, la sintaxis de escenarios Gherkin, las reglas de Func Spec y las reglas de coincidencia de nombres. Para esto se proporciona un manual de aproximadamente 830 lineas para IA. Solo necesita agregarse una vez al prompt del sistema del agente.

El ciclo de validacion despues de escribir specs es sencillo.

```
Flujo de trabajo del agente:
1. Modificar specs/
2. fullend validate specs/my-project
3. Si hay errores → corregir el SSOT correspondiente → ir a 2
4. Cero errores → fullend gen specs/my-project artifacts/my-project
```

No es necesario entender todo el sistema. Solo hay que corregir lo que validate senala y la consistencia se restaura. Un modelo inteligente acierta a la primera; un modelo mas pequeno lo logra en tres intentos. El resultado es el mismo.

## Tamano del SSOT por escala

| Escala | Ejemplo | SSOT | Codigo de implementacion | Uso de contexto |
|---|---|---|---|---|
| Pequeno | Reservas de peluqueria | ~1.500 lineas | ~10.000 lineas | ~8% |
| Mediano | Nivel Jira/Notion | ~12.500 lineas | ~100.000 lineas | ~55% |
| Grande | Nivel Shopify | ~30.000 lineas | ~300.000 lineas | ~90% |

Basado en un contexto de 200K tokens. Hasta un SaaS mediano, un agente puede leer todo el diseno de una sola vez.

## Convertir excepciones en patrones

Lo que los 10 tipos de secuencia no pueden manejar se delega a `@call`. Lo que los atributos data-* no pueden manejar se delega a `custom.ts`. Si estos mecanismos de escape superan el 20% del total, la estructuracion pierde su sentido.

Pero las excepciones se vuelven observables en el momento en que se aislan. A medida que muchos proyectos se estructuren con Fullend, los patrones recurrentes en `@call` y `custom.ts` emergeran.

Los 10 tipos de secuencia de SSaC tampoco se disenaron desde cero. Convergieron a 10 tras observar cientos de ejemplos de codigo de servicio. Se espera que el mismo principio se repita con los mecanismos de escape. Los patrones frecuentes de `@call` se convertiran en nuevos tipos de secuencia; los patrones frecuentes de `custom.ts` se convertiran en nuevos atributos data-*.

Las excepciones no disminuyen — la estructura crece a partir de ellas.

## Expansion del stack tecnologico

Actualmente, Fullend esta fijo en Go(gin) + React + PostgreSQL + Terraform. Esto es intencional. En la etapa de PoC, lo primero es atravesar completamente un stack.

Sin embargo, gran parte de los 10 SSOTs (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) ya son independientes del lenguaje. Los 10 tipos de secuencia de SSaC son patrones agnosticos al lenguaje — simplemente se expresan como comentarios de Go. STML usa atributos HTML5 data-* y es independiente del framework.

La expansion es cuestion de agregar backends de generacion de codigo. La logica de validacion y las reglas de validacion cruzada se mantienen sin cambios.

## Relacion con GEUL

Los 10 SSOTs componen todas las decisiones del software. Un SSOT son datos estructurados. Los datos estructurados son un grafo. Un grafo se puede codificar en GEUL.

El `data-fetch="ListReservations"` de STML es una relacion entre entidades. El `@get → @empty → @state → @call → @put → @response` de SSaC es una secuencia de eventos. Las transiciones de stateDiagram son un grafo de estados. Las politicas OPA son relaciones de autorizacion. Las definiciones de endpoints de OpenAPI son contratos. Todas son estructuras semanticas expresables como aristas triple, aristas event6 y nodos entidad de GEUL.

La forma en que Fullend realiza la validacion cruzada entre 10 SSOTs — coincidencia simbolica, verificacion de consistencia de tipos, verificacion de integridad referencial — opera bajo el mismo principio que la verificacion mecanica en los flujos de GEUL.

## Licencia

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
