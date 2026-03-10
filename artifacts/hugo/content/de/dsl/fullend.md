---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-10T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "Eine CLI, die die Kreuz-Konsistenz von 10 SSOTs validiert und Code generiert. Die Risse des Vibe Codings werden durch Struktur geschlossen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — Eine CLI, die die Konsistenz von 10 SSOTs auf einmal validiert und Code generiert.

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
Entscheidung: "Bei Stornierung Berechtigung prüfen → Abfrage → Zustandsübergang validieren → Erstattung berechnen → Status ändern → Antwort"
```

Diese eine Zeile Entscheidung verteilt sich auf React-Hooks, Go-Handler, SQL-Abfragen, API-Schemata und Terraform-Ressourcen. Jedes wird in die jeweilige Framework-Syntax gehüllt, Fehlerbehandlung und Typkonvertierung kommen hinzu.

Von 100.000 Zeilen Code sind 12.500 Entscheidungen. Die restlichen 87.500 Zeilen sind Verdrahtung.

KI-Agenten haben ein endliches Kontextfenster. Beim Hinzufügen des zehnten Features erinnern sie sich nicht an die vorherigen neun. 100.000 Zeilen können nicht auf einmal gelesen werden.

Trennt man nur die Entscheidungen heraus, sind es 12.500 Zeilen. Das sind 55% eines 200K-Token-Kontexts. Eine Größe, die die KI auf einmal lesen kann.

## 10 SSOTs

Fullend separiert alle Entscheidungen einer Software in 10 deklarative Spezifikationen. Jede Spezifikation wird zur Single Source of Truth (SSOT) ihres Zuständigkeitsbereichs.

| Zuständigkeit | SSOT | Deklaration |
|---|---|---|
| Projekteinstellung | fullend.yaml | Tech-Stack, Middleware, Modulpfade |
| Oberfläche | [STML](/de/dsl/stml/) (HTML5 + data-*) | Was wird angezeigt und was passiert |
| API-Vertrag | OpenAPI 3.x | Welche Anfragen werden empfangen, welche Antworten gesendet |
| Service-Ablauf | [SSaC](/de/dsl/ssac/) (Go comment DSL) | In welcher Reihenfolge wird verarbeitet |
| Datenstruktur | SQL DDL + sqlc | Was wird gespeichert |
| Externe Funktionen | Func Spec (Go) | Interface und Implementierung von Custom-Logik |
| Zustandsübergänge | Mermaid stateDiagram | Welche Zustände durchläuft eine Ressource |
| Berechtigungsrichtlinien | OPA Rego | Wer darf was tun |
| Szenarien | Gherkin (.feature) | Überprüfung von Geschäftsabläufen über Endpunkte hinweg |
| Infrastruktur | Terraform HCL | Wo wird es betrieben |

OpenAPI, SQL DDL und Terraform sind Industriestandards. Für die übrigen Zuständigkeiten gab es keine entsprechenden SSOT-DSLs. Service-Abläufe zerstreuten sich in Go-Handlern, Oberflächenentscheidungen versanken in React-Hooks, Zustandsübergänge versteckten sich in if-else-Verzweigungen, Berechtigungen waren in Middleware hartcodiert. Deshalb wurden STML, SSaC, Func Spec, stateDiagram-Integration, OPA-Integration und Gherkin-Integration entworfen. Das sind die in diesem Projekt erstellten DSLs und Integrationen.

```
specs/my-project/
├── fullend.yaml           → Projekteinstellung
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

`specs/` ist die Wahrheit. `artifacts/` kann jederzeit neu generiert werden.

## Einzelvalidierung existiert bereits

Validierungstools für mehrere Schichten existieren bereits.

- sqlc prüft die Konsistenz von DDL und Abfragen.
- OpenAPI-Validatoren prüfen die Gültigkeit des Schemas.
- Terraform prüft die Syntax und Abhängigkeiten von HCL.

Auch für STML und SSaC haben wir jeweils eingebaute Validatoren erstellt. SSaC prüft die interne Konsistenz von Service-Abläufen, STML prüft die Übereinstimmung von UI-Deklarationen und OpenAPI.

Jede SSOT kann sich selbst validieren. Das Problem entsteht **dazwischen**.

Das Frontend zeigt ein Feld mit `data-bind="memo"` an, aber im API-Antwortschema gibt es kein `memo`. SSaC ruft `@delete Reservation.SoftDelete(request.ReservationID)` auf, aber in den sqlc-Abfragen gibt es keine `SoftDelete`-Methode. Im Zustandsdiagramm ist ein `PublishCourse`-Übergang definiert, aber es gibt keine entsprechende SSaC-Funktion. Die OPA-Richtlinie prüft die Eigentümerschaft der Ressource `course` über `courses.instructor_id`, aber die DDL hat keine solche Spalte.

Einzeltools sehen nur ihre eigene Schicht. Die Risse zwischen den Schichten bleiben unsichtbar.

## Struktur verbergen

"Muss man trotzdem 10 DSLs lernen?"

Ja. Aber die Struktur muss dem Nutzer nicht gezeigt werden.

Wenn man den Tech-Stack und die SSOT-Regeln vorab in den System-Prompt des Agenten einfügt, muss der Nutzer nur noch "Bau eine Buchungsfunktion" sagen. Der Agent fügt selbständig Endpunkte in OpenAPI hinzu, erstellt Tabellen in DDL, deklariert Service-Abläufe in SSaC, zeichnet Zustandsdiagramme, erstellt OPA-Richtlinien, zeichnet Oberflächen in STML und führt `fullend validate` aus, um die Konsistenz zu prüfen.

Der Nutzer sieht nur das Ergebnis. Struktur ist etwas, das der Agent konsumiert — nicht etwas, das der Nutzer lernen muss.

Das Vibe-Coding-Erlebnis bleibt gleich. Was sich ändert: Im Hintergrund geht nichts mehr kaputt.

## Die Rolle von Fullend

Fullend ist ein Kreuzvalidierer. Es erfindet keine Einzeltools neu. Es ruft jedes Tool auf und prüft die Grenzen zwischen den SSOTs.

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

Bei einem Fehler:

```
✓ DDL          3 tables, 18 columns
✓ OpenAPI      7 endpoints
✗ SSaC         CancelReservation
               @delete Reservation.SoftDelete — method not found in sqlc queries
✗ States       course: PublishCourse transition → no SSaC function
✗ Cross        2 mismatches

FAILED: Fix errors before codegen.
```

Nach bestandener Validierung wird Code generiert.

```bash
fullend gen specs/my-project artifacts/my-project
```

sqlc generiert DB-Modelle, oapi-codegen generiert API-Typen, SSaC generiert gin-Handler, STML generiert React-Komponenten, Zustandsmaschinen-Pakete und OPA-Authorizer werden generiert, aus Gherkin werden Hurl-Tests generiert, und Fullend generiert den verbindenden Glue-Code.

## Kreuzvalidierungs-Regeln

Der einzigartige Wert von Fullend liegt in der Kreuzvalidierung. Nachdem jedes Einzeltool seine eigene Schicht validiert hat, fängt Fullend die Inkonsistenzen zwischen den SSOTs ab.

**OpenAPI ↔ DDL**

| Validierungsziel | Regel |
|---|---|
| x-sort.allowed | Existiert die entsprechende Spalte in der Tabelle |
| x-sort ↔ DDL index | Hat die Spalte einen Index (WARNING) |
| x-filter.allowed | Existiert die entsprechende Spalte in der Tabelle |
| x-include.allowed | Ist es eine durch FK-Beziehung verbundene Tabelle |

**SSaC ↔ DDL**

| Validierungsziel | Regel |
|---|---|
| Model.Method | Existiert die Methode in den sqlc-Abfragen |
| @result Type | Stimmt er mit dem aus der DDL-Tabelle abgeleiteten Typ überein |
| Argument-Felder | Können sie in DDL-Spalten umgewandelt werden |

**SSaC ↔ OpenAPI**

| Validierungsziel | Regel |
|---|---|
| Funktionsname | Stimmt er mit der operationId überein |
| request-Argumente | Existiert das Feld im Anfrageschema |
| @response-Felder | Existiert das Feld im Antwortschema |

**States ↔ SSaC ↔ OpenAPI**

| Validierungsziel | Regel |
|---|---|
| Übergangsereignis | Stimmt es mit dem SSaC-Funktionsnamen überein |
| Übergangsereignis | Stimmt es mit der OpenAPI operationId überein |
| SSaC @state | Existiert das referenzierte stateDiagram |
| @state-Feld | Existiert die Spalte in der DDL |

**Policy ↔ SSaC ↔ DDL**

| Validierungsziel | Regel |
|---|---|
| allow (action, resource) | Stimmt es mit SSaC @auth überein |
| @ownership table.column | Existiert es in der DDL |
| @ownership via join | Existiert der Join-Tabellen-FK in der DDL |

**Func ↔ SSaC**

| Validierungsziel | Regel |
|---|---|
| @call-Referenz | Gibt es eine entsprechende Func-Implementierung |
| Anzahl/Typ der Argumente | Stimmen @call-Argumente und Request-Felder überein |
| Funktionskörper | Ist es kein TODO-Stub (WARNING) |

**Scenario ↔ OpenAPI**

| Validierungsziel | Regel |
|---|---|
| operationId | Existiert sie in OpenAPI |
| HTTP-Methode | Stimmt sie mit der OpenAPI-Methode überein |
| JSON-Felder | Existieren sie im Anfrageschema |

**STML ↔ SSaC** — Beide referenzieren dieselbe OpenAPI operationId. Wenn beide Validierungen bestanden sind, wird die Übereinstimmung zwischen der API, die das Frontend aufruft, und der API, die das Backend verarbeitet, automatisch garantiert.

## Entworfen für Agenten

Fullend wurde für KI-Agenten entworfen.

Damit ein Agent Specs schreiben kann, muss er die 10 Sequenztypen von SSaC, die data-*-Attribute von STML, die OpenAPI-x-Erweiterungen, die stateDiagram-Regeln, die OPA-Richtlinienmuster, die Gherkin-Szenario-Syntax, die Func-Spec-Regeln und die Namens-Matching-Regeln kennen. Dafür wird ein etwa 830-zeiliges KI-Handbuch bereitgestellt. Es muss einmal in den System-Prompt des Agenten eingefügt werden.

Die Validierungsschleife nach dem Schreiben der Specs ist einfach.

```
Agenten-Workflow:
1. specs/ bearbeiten
2. fullend validate specs/my-project
3. Bei Fehlern → betroffene SSOT korrigieren → zurück zu 2
4. 0 Fehler → fullend gen specs/my-project artifacts/my-project
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

Was mit den 10 Sequenztypen nicht abgedeckt wird, landet in `@call`. Was mit data-*-Attributen nicht abgedeckt wird, landet in `custom.ts`. Wenn dieser Escape Hatch 20% des Ganzen übersteigt, verliert die Strukturierung an Bedeutung.

Doch Ausnahmen werden beobachtbar, sobald sie isoliert sind. Wenn viele Projekte mit Fullend strukturiert werden, werden sich in `@call` und `custom.ts` wiederkehrende Muster zeigen.

Auch die 10 Sequenztypen von SSaC wurden nicht von Anfang an entworfen. Sie konvergierten auf 10, nachdem Hunderte von Service-Code-Beispielen beobachtet wurden. Dasselbe Prinzip wird sich bei den Escape Hatches wiederholen. Häufig auftretende `@call`-Muster werden zu neuen Sequenztypen, häufig auftretende `custom.ts`-Muster werden zu neuen data-*-Attributen.

Die Ausnahmen verschwinden nicht — aus den Ausnahmen wächst Struktur.

## Erweiterung des Tech-Stacks

Derzeit ist Fullend auf Go (gin) + React + PostgreSQL + Terraform festgelegt. Das ist beabsichtigt. In der PoC-Phase hat es Priorität, einen Stack durchgängig zu durchdringen.

Jedoch sind viele der 10 SSOTs (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) bereits sprachunabhängig. Die 10 Sequenztypen von SSaC sind sprachunabhängige Muster — sie werden lediglich als Go-Kommentare ausgedrückt. STML basiert auf HTML5-data-*-Attributen und ist frameworkunabhängig.

Die Erweiterung ist eine Frage der Hinzufügung von Code-Generierungs-Backends. Validierungslogik und Kreuzvalidierungsregeln bleiben erhalten.

## Beziehung zu GEUL

10 SSOTs bilden die gesamten Entscheidungen einer Software. SSOT ist strukturierte Daten. Strukturierte Daten sind ein Graph. Ein Graph kann in GEUL kodiert werden.

STMLs `data-fetch="ListReservations"` ist eine Beziehung zwischen Entitäten. SSaCs `@get → @empty → @state → @call → @put → @response` ist eine Ereignissequenz. Zustandsdiagramm-Übergänge sind ein Zustandsgraph. OPA-Richtlinien sind Berechtigungsbeziehungen. Die Endpunktdefinitionen von OpenAPI sind Verträge. Alles semantische Strukturen, die sich als GEUL-Triple-Edges, Event6-Edges und Entity-Nodes darstellen lassen.

Die Art, wie Fullend die Kreuzvalidierung zwischen 10 SSOTs durchführt — symbolisches Matching, Typkonsistenzprüfung, referenzielle Integrität — folgt demselben Prinzip wie die maschinelle Verifikation in GEUL-Streams.

## Lizenz

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub-Repository</a>
