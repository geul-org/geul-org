---
title: "SSaC — Service Sequences as Code"
weight: 3
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["SSaC", "DSL", "SSOT", "Go", "codegen"]
summary: "Ein einzelner Go-Kommentar ist eine Sequenz. 10 feste Sequenztypen decken jede binäre Verzweigung in der Serviceschicht ab, und symbolische Codegenerierung erzeugt gin-Handler."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Service Sequences as Code** — ein einzelner Go-Kommentar ist eine Sequenz. Deklarieren Sie ihn, und ein gin-Handler wird generiert.

Servicelogik ist eine Reihe von Entscheidungen: welches Modell abfragen, wogegen schützen, wann ablehnen, was zurückgeben. Diese Entscheidungen gehören der Person, die das Geschäft versteht — aber sie werden in Boilerplate begraben, über Schichten verstreut und bei Rewrites verloren.

SSaC bewahrt diese Entscheidungen als deklarative Spezifikation. Deklarieren Sie **was** passiert und **in welcher Reihenfolge**, eine Zeile nach der anderen, und das Tool generiert die Implementierung.

```
specs/service/*.go  →  ssac validate  →  ssac gen  →  artifacts/service/*.go
   (Kommentar-DSL)       (Validierung)     (Codegen)     (gin + gofmt)
```

<a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub-Repository</a>

## Kernidee

Jede Servicefunktion ist eine Sequenz von Schritten. Jeder Schritt folgt einem binären Vertrag: **Erfolg → nächste Zeile, Fehler → return**. Das ist keine Abstraktion, die wir erfunden haben — so funktioniert Servicelogik bereits. SSaC macht es explizit.

10 feste Sequenztypen decken jede Serviceschicht-Operation ab, die diesem Vertrag folgt. Was nicht passt, wird an `@call` delegiert. Die Menge ist designbedingt geschlossen.

Kein LLM, keine Inferenz — reine symbolische Codegenerierung aus Templates. Die Spezifikation ist die Single Source of Truth.

## Syntax — Eine Zeile, eine Sequenz

Ab v2 ist jede Sequenz eine einzelne Kommentarzeile. Nur `@response` verwendet einen mehrzeiligen Block.

**CRUD — Modelloperationen**

```go
// @get Type var = Model.Method(args...)        — Lesen (Ergebnis erforderlich)
// @post Type var = Model.Method(args...)       — Erstellen (Ergebnis erforderlich)
// @put Model.Method(args...)                   — Aktualisieren (kein Ergebnis)
// @delete Model.Method(args...)                — Löschen (kein Ergebnis)
```

Argumentformat: `source.Field` oder `"Literal"`

- `request.CourseID` — aus der HTTP-Anfrage
- `course.InstructorID` — aus einer vorherigen Ergebnisvariablen
- `currentUser.ID` — aus dem Auth-Kontext
- `"cancelled"` — String-Literal

**Guards**

```go
// @empty target "message"                      — Fehler bei nil/zero (404)
// @exists target "message"                     — Fehler bei nicht nil/zero (409)
```

Ziel: eine Variable (`course`) oder Variable.Feld (`course.InstructorID`)

**Zustandsübergänge**

```go
// @state diagramID {key: var.Field, ...} "transition" "message"
```

**Berechtigungsprüfung — OPA**

```go
// @auth "action" "resource" {key: var.Field, ...} "message"
```

**Externe Aufrufe**

```go
// @call Type var = package.Func(args...)       — mit Ergebnis
// @call package.Func(args...)                  — ohne Ergebnis
```

**Antwort — Feld-Mapping-Block**

```go
// @response {
//   fieldName: variable,
//   fieldName: variable.Member,
//   fieldName: "literal"
// }
```

## Beispiel

```go
package service

import "myapp/auth"

// @auth "cancel" "reservation" {id: request.ReservationID} "Nicht berechtigt"
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @empty reservation "Reservierung nicht gefunden"
// @state reservation {status: reservation.Status} "cancel" "Stornierung nicht möglich"
// @call Refund refund = billing.CalculateRefund(reservation.ID, reservation.StartAt, reservation.EndAt)
// @put Reservation.UpdateStatus(request.ReservationID, "cancelled")
// @get Reservation reservation = Reservation.FindByID(request.ReservationID)
// @response {
//   reservation: reservation,
//   refund: refund
// }
func CancelReservation() {}
```

10-Zeilen-Deklaration. Jede Zeile ist eine Sequenz, die von oben nach unten der Reihe nach ausgeführt wird. Berechtigung → Lesen → Guard → Zustandsübergang → externer Aufruf → Aktualisierung → erneutes Lesen → Antwort.

## Sequenztypen (10)

| Typ | Rolle |
|---|---|
| `@auth` | Berechtigungsprüfung (OPA-Richtlinie) |
| `@get` | Ressource lesen |
| `@empty` | Beenden bei nil/zero (404) |
| `@exists` | Beenden bei nicht nil/zero (409) |
| `@post` | Ressource erstellen |
| `@put` | Ressource aktualisieren |
| `@delete` | Ressource löschen |
| `@state` | Zustandsübergang validieren |
| `@call` | Externe Paketfunktion aufrufen |
| `@response` | Antwort zurückgeben (Feld-Mapping) |

## Validierung

Interne Validierung (immer):
- Fehlende Pflichtargumente je Typ
- `Model.Method`-Format
- Variablenfluss (Referenz vor Deklaration)

Externe SSOT-Kreuzvalidierung (bei erkannter Projektstruktur):
- Modell-/Methodenexistenz (sqlc-Abfragen, Go-Interfaces)
- Request-/Response-Feldexistenz (OpenAPI)
- Paket-/Funktionsexistenz (Go-Interfaces)
- Warnung bei veralteten Daten: Response nach put/delete ohne erneutes Lesen (WARNING)
- Zustandsdiagramm-Existenz und Übergangsvalidität
- OPA-Richtliniendatei-Existenz

## Codegen-Funktionen

Wenn externe SSOT (Symboltabellen) verfügbar sind, bietet `ssac gen` zusätzliche Funktionen. Der generierte Code verwendet das gin-Framework.

- **Typkonvertierung**: DDL-Spaltentypen → `strconv.ParseInt`, `time.Parse`, frühzeitiger 400 Bad Request Return
- **Guard-Werttypen**: Typbewusste Zero-Checks (`int` → `== 0`/`> 0`, Pointer → `== nil`/`!= nil`)
- **Modell-Interface-Ableitung**: Kreuzreferenz aus 3 SSOT-Quellen → `<outDir>/model/models_gen.go`
- **@state Codegen**: Ruft `CanTransition` aus dem Zustandsdiagramm-Paket auf
- **@auth Codegen**: Ruft `authz.Check(currentUser, "action", "resource", authz.Input{...})` auf
- **@call Codegen**: Guard-Stil (401) ohne Ergebnis, Value-Stil (500) mit Ergebnis
- **Domain-Ordnerstruktur**: `service/auth/login.go` → `outDir/auth/login.go`, `package auth`

## OpenAPI x-Erweiterungen

Infrastrukturparameter (Paginierung, Sortierung, Filterung, Relationseinbindung) werden in OpenAPI-`x-`-Erweiterungen deklariert. In SSaC-Spezifikationen werden nur Geschäftsparameter deklariert. Der Codegenerator liest `x-`-Erweiterungen und konstruiert `QueryOpts` automatisch.

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

## Lizenz

MIT — <a href="https://github.com/geul-org/ssac" target="_blank" rel="noopener">GitHub-Repository</a>
