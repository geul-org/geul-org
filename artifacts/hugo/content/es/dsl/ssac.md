---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Un solo comentario Go es una secuencia. 10 tipos de secuencia fijos cubren todas las bifurcaciones binarias en la capa de servicio. El codegen simbólico produce handlers gin."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — un solo comentario Go es una secuencia. Declárala y se genera un handler gin.

La lógica de servicio es una serie de decisiones: qué modelo consultar, contra qué protegerse, cuándo rechazar, qué devolver. Estas decisiones pertenecen a quien entiende el negocio, pero quedan enterradas en boilerplate, dispersas entre capas y perdidas en reescrituras.

SSaC preserva estas decisiones como especificaciones declarativas. Declara **qué** sucede y **en qué orden**, una línea a la vez, y la herramienta genera la implementación.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (comentario DSL)      (validación)     (codegen)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Repositorio en GitHub</a>

## Idea Central

Toda función de servicio es una secuencia de pasos. Cada paso sigue un contrato binario: **éxito → siguiente línea, fallo → return**. Esto no es una abstracción que inventamos — es cómo ya funciona la lógica de servicio. SSaC lo hace explícito.

10 tipos de secuencia fijos cubren todas las operaciones de la capa de servicio que siguen este contrato. Lo que no encaje se delega a `@call`. El conjunto está cerrado por diseño.

Sin LLM, sin inferencia — codegen simbólico puro basado en plantillas. La especificación es la fuente única de verdad.

## Sintaxis — Una Línea, Una Secuencia

A partir de v2, cada secuencia es una sola línea de comentario. Solo `@response` usa un bloque de varias líneas.

**CRUD — Operaciones de Modelo**

```go
// @get Type var = Model.Method(args...)        — consulta (resultado requerido)
// @post Type var = Model.Method(args...)       — creación (resultado requerido)
// @put Model.Method(args...)                   — actualización (sin resultado)
// @delete Model.Method(args...)                — eliminación (sin resultado)
```

Formato de argumentos: `source.Field` o `"literal"`

- `request.CourseID` — desde la solicitud HTTP
- `course.InstructorID` — desde una variable de resultado anterior
- `currentUser.ID` — desde el contexto de autenticación
- `"cancelled"` — literal de cadena

**Guardas**

```go
// @empty target "message"                      — falla si nil/zero (404)
// @exists target "message"                     — falla si no es nil/zero (409)
```

Objetivo: una variable (`course`) o variable.campo (`course.InstructorID`)

**Transiciones de Estado**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**Autorización — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**Llamadas Externas**

```go
// @call Type var = package.Func(args...)       — con resultado
// @call package.Func(args...)                  — sin resultado
```

**Respuesta — Bloque de Mapeo de Campos**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## Ejemplo

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "sin autorización"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "reservación no encontrada"
// @state reservation {status: reservation.Status} "cancel" "no se puede cancelar"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

Declaración de 10 líneas. Cada línea es una secuencia, ejecutada de arriba hacia abajo en orden. Autorización → consulta → guarda → transición de estado → llamada externa → actualización → reconsulta → respuesta.

## Tipos de Secuencia (10)

| Tipo | Rol |
|---|---|
| `@auth` | Verificación de autorización (política OPA) |
| `@get` | Consulta de recurso |
| `@empty` | Terminar si nil/zero (404) |
| `@exists` | Terminar si no es nil/zero (409) |
| `@post` | Creación de recurso |
| `@put` | Actualización de recurso |
| `@delete` | Eliminación de recurso |
| `@state` | Validación de transición de estado |
| `@call` | Llamada a función de paquete externo |
| `@response` | Devolver respuesta (mapeo de campos) |

## Validación

Validación interna (siempre):
- Argumentos requeridos faltantes por tipo
- Formato `Model.Method`
- Flujo de variables (referencia antes de declaración)

Validación cruzada SSOT externa (cuando se detecta estructura de proyecto):
- Existencia de modelo/método (consultas sqlc, interfaces Go)
- Existencia de campos de request/response (OpenAPI)
- Existencia de paquete/función (interfaces Go)
- Advertencia de datos obsoletos: response después de put/delete sin reconsulta (WARNING)
- Existencia de diagrama de estado y validez de transición
- Existencia de archivo de política OPA

## Funciones de Codegen

Cuando el SSOT externo (tablas de símbolos) está disponible, `ssac gen` proporciona funcionalidades adicionales. El código generado usa el framework gin.

- **Conversión de tipos**: Tipos de columna DDL → `strconv.ParseInt`, `time.Parse`, retorno temprano 400 Bad Request
- **Tipos de valores de guarda**: Verificaciones de cero según tipo (`int` → `== 0`/`> 0`, puntero → `== nil`/`!= nil`)
- **Derivación de interfaz de modelo**: Cruce de 3 fuentes SSOT → `<outDir>/model/models_gen.go`
- **Codegen de @state**: Llama a `CanTransition` del paquete de diagrama de estado
- **Codegen de @auth**: Llama a `authz.Check(currentUser, "action", "resource", authz.Input{...})`
- **Codegen de @call**: Estilo guarda (401) sin resultado, estilo valor (500) con resultado
- **Estructura de carpetas por dominio**: `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## Extensiones x- de OpenAPI

Los parámetros de infraestructura (paginación, ordenamiento, filtrado, inclusión de relaciones) se declaran en extensiones `x-` de OpenAPI. Solo los parámetros de negocio se declaran en las especificaciones SSaC. El generador de código lee las extensiones `x-` y construye automáticamente `QueryOpts`.

```yaml
/api/reservations:
  get:
    operationId: ListReservations
    x-pagination:
      style: offset
      defaultLimit: 20
      maxLimit: 100
    x-sort:
      allowed: [start_at, created_at]
      default: start_at
      direction: desc
    x-filter:
      allowed: [status, room_id]
    x-include:
      allowed: [room_id:rooms.id, user_id:users.id]
```

## Licencia

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">Repositorio en GitHub</a>
