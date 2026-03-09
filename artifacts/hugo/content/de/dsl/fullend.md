---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-09T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "Eine CLI, die die Kreuz-Konsistenz von 5 SSOTs (STML, OpenAPI, SSaC, SQL DDL, Terraform) validiert und Code generiert. Die Risse des Vibe Codings werden durch Struktur geschlossen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — Eine CLI, die die Konsistenz von 5 SSOTs auf einmal validiert und Code generiert.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub-Repository</a>

## Die Risse des Vibe Codings

Mit der Verbreitung von Vibe Coding zeichnen sich Muster ab.

Man sagt der KI "Bau eine Buchungsfunktion" und sie baut sie. "Füge eine Stornierung hinzu" und sie fügt sie hinzu. Beim fünften Feature geht das zweite kaputt. Das API-Schema wurde geändert, aber das Frontend nicht angepasst. Eine DB-Spalte wurde hinzugefügt, aber der Service-Layer weiß nichts davon.

Die Ursache ist einfach: Die KI kann sich nicht den gesamten Code merken.

Was die Leute dann tun: Wenn sie den Bruch entdecken, sagen sie der KI "Reparier das auch". Nach der Reparatur bricht etwas anderes. "Reparier das auch." Diese Schleife wiederholt sich. Je größer das Projekt, desto länger die Schleife — bis irgendwann "Von vorne anfangen wäre schneller" die logische Konsequenz ist.

## Warum wächst Code?

Im Code sind zwei Dinge vermischt.

**Entscheidungen**: Was angezeigt wird, welche API aufgerufen wird, in welcher Reihenfolge verarbeitet wird, was gespeichert wird.
**Verdrahtung**: Der Code, der diese Entscheidungen in einem bestimmten Framework implementiert.

Nehmen wir an, wir bauen ein Reservierungssystem.

```
Entscheidung: "Bei Reservierungserstellung Raum abfragen, falls nicht vorhanden 404, sonst erstellen"
```

Diese eine Zeile Entscheidung verteilt sich auf React-Hooks, Go-Handler, SQL-Abfragen, API-Schemata und Terraform-Ressourcen. Jedes wird in die jeweilige Framework-Syntax gehüllt, Fehlerbehandlung und Typkonvertierung kommen hinzu.

Von 100.000 Zeilen Code sind 12.500 Entscheidungen. Die restlichen 87.500 Zeilen sind Verdrahtung.

KI-Agenten haben ein endliches Kontextfenster. Beim Hinzufügen des zehnten Features erinnern sie sich nicht an die vorherigen neun. 100.000 Zeilen können nicht auf einmal gelesen werden.

Trennt man nur die Entscheidungen heraus, sind es 12.500 Zeilen. Das sind 55% eines 200K-Token-Kontexts. Eine Größe, die die KI auf einmal lesen kann.

## 5 SSOTs

Fullend ordnet den 5 Schichten einer Software jeweils eine DSL zu. Jede DSL wird zur Single Source of Truth (SSOT) ihrer Schicht.

| Schicht | DSL | Deklaration |
|---|---|---|
| Oberfläche | STML (HTML5 + data-*) | Was wird angezeigt und was passiert |
| API-Vertrag | OpenAPI 3.x | Welche Anfragen werden empfangen, welche Antworten gesendet |
| Service-Ablauf | SSaC (Go comment DSL) | In welcher Reihenfolge wird verarbeitet |
| Datenstruktur | SQL DDL + sqlc | Was wird gespeichert |
| Infrastruktur | Terraform HCL | Wo wird es betrieben |

OpenAPI, SQL DDL und Terraform sind Industriestandards. Für Oberfläche und Service-Ablauf gab es keine entsprechenden SSOT-DSLs. Frontend-Entscheidungen versanken in React-Hooks, Service-Abläufe zerstreuten sich in Go-Handlern. Deshalb haben wir [STML](/de/dsl/stml/) und [SSaC](/de/dsl/ssac/) entworfen. Sie sind die in diesem Projekt erstellten DSLs.

```
specs/
├── frontend/*.html        → STML
├── api/openapi.yaml       → OpenAPI 3.x
├── service/*.go           → SSaC
├── db/*.sql               → SQL DDL + sqlc queries
└── terraform/*.tf         → HCL
```

`specs/` ist die Wahrheit. `artifacts/` kann jederzeit neu generiert werden.

## Einzelvalidierung existiert bereits

Validierungstools für 3 Schichten existieren bereits.

- sqlc prüft die Konsistenz von DDL und Abfragen.
- OpenAPI-Validatoren prüfen die Gültigkeit des Schemas.
- Terraform prüft die Syntax und Abhängigkeiten von HCL.

Auch für STML und SSaC haben wir jeweils eingebaute Validatoren erstellt. SSaC prüft die interne Konsistenz von Service-Abläufen, STML prüft die Übereinstimmung von UI-Deklarationen und OpenAPI.

Jede der 5 Schichten kann sich selbst validieren. Das Problem entsteht **dazwischen**.

Das Frontend zeigt ein Feld mit `data-bind="memo"` an, aber im API-Antwortschema gibt es kein `memo`. SSaC ruft `@model Reservation.SoftDelete` auf, aber in den sqlc-Abfragen gibt es keine `SoftDelete`-Methode. OpenAPI deklariert `x-sort: [created_at]`, aber in der DDL-Tabelle fehlt der entsprechende Spaltenindex.

Einzeltools sehen nur ihre eigene Schicht. Die Risse zwischen den Schichten bleiben unsichtbar.

## Struktur verbergen

"Muss man trotzdem 5 DSLs lernen?"

Ja. Aber die Struktur muss dem Nutzer nicht gezeigt werden.

Wenn man den Techstack und die SSOT-Regeln vorab in den System-Prompt des Agenten einfügt, muss der Nutzer nur noch "Bau eine Buchungsfunktion" sagen. Der Agent fügt selbständig Endpunkte in OpenAPI hinzu, erstellt Tabellen in DDL, deklariert Service-Abläufe in SSaC, zeichnet Oberflächen in STML und führt `fullend validate` aus, um die Konsistenz zu prüfen.

Der Nutzer sieht nur das Ergebnis. Struktur ist etwas, das der Agent konsumiert — nicht etwas, das der Nutzer lernen muss.

Das Vibe-Coding-Erlebnis bleibt gleich. Was sich ändert: Im Hintergrund geht nichts mehr kaputt.

## Die Rolle von Fullend

Fullend ist ein Kreuzvalidierer. Es erfindet keine Einzeltools neu. Es ruft jedes Tool auf und prüft die Grenzen zwischen den Schichten.

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

Bei einem Fehler:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @model Reservation.SoftDelete — method not found in sqlc queries
✗ Cross        1 mismatch

FAILED: Fix errors before codegen.
```

Nach bestandener Validierung wird Code generiert.

```bash
fullend gen specs/ artifacts/
```

sqlc generiert DB-Modelle, oapi-codegen generiert API-Typen, SSaC generiert Service-Funktionen, STML generiert React-Komponenten, und Fullend generiert den verbindenden Glue-Code.

## Kreuzvalidierungs-Regeln

Der einzigartige Wert von Fullend liegt in der Kreuzvalidierung.

**OpenAPI ↔ DDL**

| Validierungsziel | Regel |
|---|---|
| x-sort.allowed | Existiert die entsprechende Spalte in der Tabelle |
| x-filter.allowed | Existiert die entsprechende Spalte in der Tabelle |
| x-include.allowed | Ist es eine durch FK-Beziehung verbundene Tabelle |

**SSaC ↔ DDL**

| Validierungsziel | Regel |
|---|---|
| @model Model.Method | Existiert die Methode in den sqlc-Abfragen |
| @result Type | Stimmt sie mit dem aus der DDL-Tabelle abgeleiteten Typ überein |
| @param Name | Kann er in eine DDL-Spalte umgewandelt werden |

**SSaC ↔ OpenAPI**

| Validierungsziel | Regel |
|---|---|
| Funktionsname | Stimmt er mit der operationId überein |
| @param request | Existiert das Feld im Anfrageschema |
| @result + response | Existiert das Feld im Antwortschema |

**STML ↔ SSaC** — Beide referenzieren dieselbe OpenAPI operationId. Wenn beide Validierungen bestanden sind, wird die Übereinstimmung zwischen der API, die das Frontend aufruft, und der API, die das Backend verarbeitet, automatisch garantiert.

## Entworfen für Agenten

Fullend wurde für KI-Agenten entworfen.

Damit ein Agent Specs schreiben kann, muss er die 10 Sequenztypen von SSaC, die 12 data-*-Attribute von STML, die OpenAPI-x-Erweiterungen und die Namensmatchingregeln kennen. Dafür wird ein etwa 350-zeiliges KI-Handbuch bereitgestellt. Es muss einmal in den System-Prompt des Agenten eingefügt werden.

Die Validierungsschleife nach dem Schreiben der Specs ist einfach.

```
Agenten-Workflow:
1. specs/ bearbeiten
2. fullend validate specs/
3. Bei Fehlern → betroffene SSOT korrigieren → zurück zu 2
4. 0 Fehler → fullend gen specs/ artifacts/
```

Man muss nicht das gesamte System verstehen. Wenn man nur die Stellen korrigiert, auf die validate zeigt, wird die Konsistenz wiederhergestellt. Intelligente Modelle schaffen es beim ersten Mal, kleinere Modelle nach drei Versuchen. Das Ergebnis ist dasselbe.

## SSOT-Größe nach Skalierung

| Skalierung | Beispiel | SSOT | Implementierungscode | Kontextauslastung |
|---|---|---|---|---|
| Klein | Friseursalon-Buchung | ~1.500 Zeilen | ~10.000 Zeilen | ~8% |
| Mittel | Jira, Notion-Klasse | ~12.500 Zeilen | ~100.000 Zeilen | ~55% |
| Groß | Shopify-Klasse | ~30.000 Zeilen | ~300.000 Zeilen | ~90% |

Basierend auf 200K-Token-Kontext. Bis zur Größe eines mittleren SaaS kann ein Agent das gesamte Design auf einmal lesen.

## Muster aus Ausnahmen

Was mit den 10 Sequenztypen nicht abgedeckt wird, landet in `call`. Was mit data-*-Attributen nicht abgedeckt wird, landet in `custom.ts`. Wenn dieser Escape Hatch 20% des Ganzen übersteigt, verliert die Strukturierung an Bedeutung.

Doch Ausnahmen werden beobachtbar, sobald sie isoliert sind. Wenn viele Projekte mit Fullend strukturiert werden, werden sich in `call` und `custom.ts` wiederkehrende Muster zeigen.

Auch die 10 Sequenztypen von SSaC wurden nicht von Anfang an entworfen. Sie konvergierten auf 10, nachdem Hunderte von Service-Code-Beispielen beobachtet wurden. Dasselbe Prinzip wird sich bei den Escape Hatches wiederholen. Häufig auftretende `call`-Muster werden zu neuen Sequenztypen, häufig auftretende `custom.ts`-Muster werden zu neuen data-*-Attributen.

Die Ausnahmen verschwinden nicht — aus den Ausnahmen wächst Struktur.

## Erweiterung des Tech-Stacks

Derzeit ist Fullend auf Go + React + PostgreSQL + Terraform festgelegt. Das ist beabsichtigt. In der PoC-Phase hat es Priorität, einen Stack durchgängig zu durchdringen.

Jedoch sind 3 der 5 SSOTs (OpenAPI, SQL DDL, Terraform) bereits sprachunabhängig. Die 10 Sequenztypen von SSaC sind sprachunabhängige Muster — sie werden lediglich als Go-Kommentare ausgedrückt. STML basiert auf HTML5-data-*-Attributen und ist frameworkunabhängig.

Die Erweiterung ist eine Frage der Hinzufügung von Code-Generierungs-Backends. Validierungslogik und Kreuzvalidierungsregeln bleiben erhalten.

## Beziehung zu GEUL

5 DSLs bilden das SSOT einer Software. SSOT ist strukturierte Daten. Strukturierte Daten sind ein Graph. Ein Graph kann in GEUL kodiert werden.

STMLs `data-fetch="ListReservations"` ist eine Beziehung zwischen Entitäten. SSaCs `@sequence get → @model → @guard → @response` ist eine Ereignissequenz. Die Endpunktdefinitionen von OpenAPI sind Verträge. Alles semantische Strukturen, die sich als GEUL-Triple-Edges, Event6-Edges und Entity-Nodes darstellen lassen.

Die Art, wie Fullend die Kreuzvalidierung zwischen 5 DSLs durchführt — symbolisches Matching, Typkonsistenzprüfung, referenzielle Integrität — folgt demselben Prinzip wie die maschinelle Verifikation in GEUL-Streams.

## Lizenz

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
