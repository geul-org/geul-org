---
title: "SSaC — Service Sequences as Code"
weight: 2
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Deklariert Servicelogik in Go-Kommentaren und generiert Implementierungscode. 10 feste Sequenztypen decken alle Binärvertrags-Operationen in der Serviceschicht ab."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — generiert Servicecode aus Go-Kommentar-DSL.

Servicelogik ist eine Reihe von Entscheidungen: Welches Modell abfragen, wogegen schützen, wann ablehnen, was zurückgeben. Diese Entscheidungen gehören dem, der das Geschäft versteht — aber sie werden in Boilerplate begraben, über Schichten verstreut und bei Rewrites verloren.

SSaC bewahrt diese Entscheidungen als deklarative Spezifikation. Sie deklarieren **was** passiert und **in welcher Reihenfolge**. Das Tool generiert die Implementierung.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>

## Kernidee

Jede Servicefunktion ist eine Sequenz von Schritten. Jeder Schritt folgt einem Binärvertrag: **Erfolg → nächste Zeile, Fehler → return**. Das ist keine Abstraktion, die wir erfunden haben — so funktioniert Servicelogik bereits. SSaC macht es explizit.

10 feste Sequenztypen decken alle Serviceschicht-Operationen ab, die diesem Vertrag folgen. Was nicht passt, wird an `call` delegiert. Die Menge ist designbedingt geschlossen.

Kein LLM, keine Inferenz — reine symbolische Codegenerierung aus Templates. Die Spezifikation ist die Quelle der Wahrheit.

## Beispiel

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

Diese 10-Zeilen-Deklaration generiert folgenden Code:

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

## Sequenztypen (10)

| Typ | Rolle |
|---|---|
| `authorize` | Berechtigungsprüfung (OPA, etc.) |
| `get` | Ressourcensuche |
| `guard nil` | Beenden wenn null |
| `guard exists` | Beenden wenn vorhanden |
| `post` | Ressourcenerstellung |
| `put` | Ressourcenaktualisierung |
| `delete` | Ressourcenlöschung |
| `password` | Passwortvergleich |
| `call` | Externer Aufruf (@component / @func) |
| `response` | Antwort zurückgeben (json) |

## Codegen-Funktionen

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

## Lizenz

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub</a>
