---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Declara lógica de servicio en comentarios Go y genera código de implementación. 10 tipos de secuencia fijos cubren todas las operaciones de contrato binario en la capa de servicio."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — genera código de servicio desde un DSL de comentarios Go.

La lógica de servicio es una serie de decisiones: qué modelo consultar, contra qué protegerse, cuándo rechazar, qué devolver. Estas decisiones pertenecen a quien entiende el negocio — pero quedan enterradas en boilerplate, dispersas entre capas y perdidas en reescrituras.

SSaC preserva estas decisiones como una especificación declarativa. Declaras **qué** sucede y **en qué orden**. La herramienta genera la implementación.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## Idea Central

Toda función de servicio es una secuencia de pasos. Cada paso sigue un contrato binario: **éxito → siguiente línea, fallo → return**. No es una abstracción inventada — es cómo ya funciona la lógica de servicio. SSaC lo hace explícito.

10 tipos de secuencia fijos cubren todas las operaciones de la capa de servicio que siguen este contrato. Lo que no encaje, se delega a `call`. El conjunto está cerrado por diseño.

Sin LLM, sin inferencia — codegen simbólico puro desde plantillas. La especificación es la fuente de verdad.

## Ejemplo

```go
// @sequence get
// @model Project.FindByID
// @param ProjectID request
// @result project Project

// @sequence guard nil project
// @message "project not found"

// @sequence post
// @model Session.Create
// @param ProjectID request
// @param Command request
// @result session Session

// @sequence response json
// @var session
func CreateSession(w http.ResponseWriter, r *http.Request) {}
```

Esta declaración de 10 líneas genera el siguiente código:

```go
func CreateSession(w http.ResponseWriter, r *http.Request) {
    projectID := r.FormValue("ProjectID")
    command := r.FormValue("Command")

    project, err := projectModel.FindByID(projectID)
    if err != nil {
        http.Error(w, "Project lookup failed", http.StatusInternalServerError)
        return
    }

    if project == nil {
        http.Error(w, "project not found", http.StatusNotFound)
        return
    }

    session, err := sessionModel.Create(projectID, command)
    if err != nil {
        http.Error(w, "Session creation failed", http.StatusInternalServerError)
        return
    }

    w.Header().Set("Content-Type", "application/json")
    json.NewEncoder(w).Encode(map[string]interface{}{
        "session": session,
    })
}
```

## Tipos de Secuencia (10)

| Tipo | Rol |
|---|---|
| `authorize` | Verificación de permisos (OPA, etc.) |
| `get` | Búsqueda de recursos |
| `guard nil` | Salir si es nulo |
| `guard exists` | Salir si existe |
| `post` | Creación de recursos |
| `put` | Actualización de recursos |
| `delete` | Eliminación de recursos |
| `password` | Comparación de contraseñas |
| `call` | Llamada externa (@component / @func) |
| `response` | Devolver respuesta (json) |

## Funciones de Codegen

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
      allowed: [room, user]
```

## Licencia

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
