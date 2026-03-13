---
title: "Fullend — Full-stack SSOT Orchestrator"
weight: 1
date: 2026-03-09T12:00:00+09:00
lastmod: 2026-03-13T12:00:00+09:00
tags: ["Fullend", "DSL", "SSOT", "cross-validation", "vibe-coding"]
summary: "Eine CLI, die 10 SSOTs kreuzvalidiert und Code generiert. Füllt die Risse des Vibe Codings mit Struktur."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Full-stack SSOT Orchestrator** — eine CLI, die 10 SSOTs auf einmal kreuzvalidiert und Code generiert.

<a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub-Repository</a>

## Die Risse des Vibe Codings

Mit der Verbreitung von Vibe Coding zeichnete sich ein Muster ab.

Man sagt der KI „Bau eine Buchungsfunktion" und sie baut sie. „Füge eine Stornierung hinzu" und sie fügt sie hinzu. Beim fünften Feature geht das zweite kaputt. Das API-Schema wurde geändert, aber das Frontend nicht angepasst. Eine DB-Spalte wurde hinzugefügt, aber der Service-Layer weiß nichts davon.

Die Ursache ist einfach: Die KI kann sich nicht den gesamten Code merken.

Was die Leute dann tun: Wenn etwas kaputtgeht, sagen sie der KI „Reparier das auch." Sie repariert es, und etwas anderes geht kaputt. „Reparier das auch." Die Schleife wiederholt sich. Je größer das Projekt, desto länger die Schleife — bis irgendwann „von vorne anfangen wäre schneller" die logische Konsequenz ist.

## Warum wird Code so groß?

Im Code sind zwei Dinge vermischt.

**Entscheidungen**: Was angezeigt wird, welche API aufgerufen wird, in welcher Reihenfolge verarbeitet wird, was gespeichert wird.
**Verdrahtung**: Der Code, der diese Entscheidungen in einem bestimmten Framework implementiert.

Nehmen wir an, wir bauen ein Reservierungssystem.

```
Entscheidung: „Bei Stornierung: Berechtigung prüfen → Abfrage → Zustandsübergang validieren → Erstattung berechnen → Status ändern → Antwort"
```

Diese eine Entscheidung verteilt sich auf React-Hooks, Go-Handler, SQL-Abfragen, API-Schemata und Terraform-Ressourcen. Jedes wird in die jeweilige Framework-Syntax gehüllt, Fehlerbehandlung und Typkonvertierung kommen hinzu.

Von 100.000 Zeilen Code sind 12.500 Entscheidungen. Die restlichen 87.500 Zeilen sind Verdrahtung.

KI-Agenten haben ein endliches Kontextfenster. Beim Hinzufügen des zehnten Features erinnern sie sich nicht an die vorherigen neun. 100.000 Zeilen können nicht auf einmal gelesen werden.

Trennt man die Entscheidungen heraus, sind es 12.500 Zeilen. Das sind 55% eines 200K-Token-Kontexts. Klein genug, damit eine KI sie in einem Durchgang lesen kann.

## 10 SSOTs

Fullend separiert alle Entscheidungen einer Software in 10 deklarative Spezifikationen. Jede Spezifikation wird zur Single Source of Truth (SSOT) ihres Zuständigkeitsbereichs.

| Zuständigkeit | SSOT | Deklaration |
|---|---|---|
| Projektkonfiguration | fullend.yaml | Tech-Stack, Middleware, Modulpfade |
| Oberfläche | [STML](/de/dsl/stml/) (HTML5 + data-*) | Was angezeigt wird und was passiert |
| API-Vertrag | OpenAPI 3.x | Welche Anfragen empfangen und welche Antworten gesendet werden |
| Service-Ablauf | [SSaC](/de/dsl/ssac/) (.ssac DSL) | In welcher Reihenfolge verarbeitet wird |
| Datenstruktur | SQL DDL + sqlc | Was gespeichert wird |
| Externe Funktionen | Func Spec (Go) | Interface und Implementierung von Custom-Logik |
| Zustandsübergänge | Mermaid stateDiagram | Welche Zustände eine Ressource durchläuft |
| Berechtigungsrichtlinien | OPA Rego | Wer was tun darf |
| Szenarien | Gherkin (.feature) | Überprüfung von Geschäftsabläufen über Endpunkte hinweg |
| Infrastruktur | Terraform HCL | Wo es betrieben wird |

OpenAPI, SQL DDL und Terraform sind Industriestandards. Für die übrigen Zuständigkeiten gab es keine entsprechenden SSOT-DSLs. Service-Abläufe zerstreuten sich in Go-Handlern, Oberflächenentscheidungen versanken in React-Hooks, Zustandsübergänge versteckten sich in if-else-Verzweigungen und Berechtigungen waren in Middleware hartcodiert. Deshalb wurden STML, SSaC, Func Spec, stateDiagram-Integration, OPA-Integration und Gherkin-Integration entworfen.

```
specs/my-project/
├── fullend.yaml             → Projektkonfiguration
├── api/openapi.yaml         → OpenAPI 3.x
├── db/*.sql                 → SQL DDL + sqlc-Abfragen
├── service/**/*.ssac        → SSaC (.ssac-Erweiterung)
├── model/*.go               → Go-Structs (// @dto)
├── func/<pkg>/*.go          → Func Spec
├── states/*.md              → Mermaid stateDiagram
├── policy/*.rego            → OPA Rego
├── scenario/*.feature       → Gherkin
├── frontend/*.html          → STML
└── terraform/*.tf           → HCL
```

`specs/` ist die Wahrheit. `artifacts/` kann jederzeit neu generiert werden.

## Einzelvalidierung existiert bereits

Validierungstools für mehrere Schichten existieren bereits.

- sqlc prüft die Konsistenz zwischen DDL und Abfragen.
- OpenAPI-Validatoren prüfen die Schema-Gültigkeit.
- Terraform prüft HCL-Syntax und Abhängigkeiten.

Auch für STML und SSaC wurden eingebaute Validatoren erstellt. SSaC prüft die interne Konsistenz von Service-Abläufen; STML prüft die Übereinstimmung zwischen UI-Deklarationen und OpenAPI.

Jede SSOT kann für sich validiert werden. Das Problem entsteht **dazwischen**.

Das Frontend zeigt ein Feld mit `data-bind="memo"` an, aber im API-Antwortschema gibt es kein `memo`. SSaC ruft `@delete Reservation.SoftDelete(request.ReservationID)` auf, aber in den sqlc-Abfragen gibt es keine `SoftDelete`-Methode. Im Zustandsdiagramm ist ein `PublishCourse`-Übergang definiert, aber es gibt keine entsprechende SSaC-Funktion. Die OPA-Richtlinie prüft die Eigentümerschaft der Ressource `course` über `courses.instructor_id`, aber die DDL hat keine solche Spalte.

Einzeltools sehen nur ihre eigene Schicht. Die Risse zwischen den Schichten bleiben unsichtbar.

## Struktur verbergen

„Muss man trotzdem 10 DSLs lernen?"

Ja. Aber die Struktur muss dem Nutzer nicht gezeigt werden.

Wenn man den Tech-Stack und die SSOT-Regeln in den System-Prompt des Agenten einbettet, muss der Nutzer nur noch „Bau eine Buchungsfunktion" sagen. Der Agent fügt den Endpunkt in OpenAPI hinzu, erstellt die Tabelle in DDL, deklariert den Service-Ablauf in SSaC, zeichnet das Zustandsdiagramm, schreibt die OPA-Richtlinie, zeichnet den Bildschirm in STML und führt `fullend validate` aus, um die Konsistenz zu prüfen.

Der Nutzer sieht nur Ergebnisse. Struktur wird vom Agenten konsumiert, nicht vom Nutzer gelernt.

Das Vibe-Coding-Erlebnis bleibt gleich. Was sich ändert: Im Hintergrund geht nichts mehr kaputt.

## Was Fullend tut

Fullend ist ein Kreuzvalidierer. Es erfindet keine Einzeltools neu. Es ruft jedes Tool auf und prüft die Grenzen zwischen den SSOTs.

```bash
fullend validate <specs-dir>
fullend validate --skip states,terraform <specs-dir>
```

Validiert jede der 10 SSOTs einzeln und kreuzvalidiert dann zwischen ihnen. Func wird nur validiert, wenn ein `func/`-Verzeichnis existiert. Mit `--skip` können bestimmte SSOTs ausgeschlossen werden.

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

Nach bestandener Validierung wird Code generiert. Die `--skip`-Option funktioniert genauso wie bei validate.

```bash
fullend gen <specs-dir> <artifacts-dir>
fullend gen --skip terraform <specs-dir> <artifacts-dir>
```

sqlc generiert DB-Modelle, oapi-codegen generiert API-Typen, SSaC generiert gin-Handler, STML generiert React-Komponenten, Zustandsmaschinen-Pakete und OPA-Authorizer werden generiert, Hurl-Tests werden aus Gherkin generiert, und Fullend generiert den verbindenden Glue-Code.

### gen-model

Generiert eine Go-Modelldatei (Interface + Typen + HTTP-Client) aus einem externen OpenAPI-Dokument. Akzeptiert einen lokalen Dateipfad oder eine URL.

```bash
fullend gen-model <openapi-source> <output-dir>
fullend gen-model https://api.stripe.com/openapi.yaml ./external/
```

### chain

Verfolgt alle SSOT-Knoten, die mit einer einzelnen API-Operation verbunden sind. Eine operationId rein, vollständige schichtübergreifende file:line-Zuordnung raus.

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

Zeigt eine Zusammenfassung der erkannten SSOTs und ihrer Statistiken.

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

## Eingebaute Funktionen und Modelle

Fullend liefert häufig verwendete Funktionsimplementierungen und Modell-Interfaces mit. Sie können in SSaC über `@call` aufgerufen werden.

### Standard-Funktionen (pkg/)

| Paket | Funktion | Beschreibung |
|---|---|---|
| `auth` | `hashPassword` | bcrypt-Passwort-Hashing |
| `auth` | `verifyPassword` | bcrypt-Passwort-Verifizierung |
| `auth` | `issueToken` | JWT-Access-Token-Generierung (24h) |
| `auth` | `verifyToken` | JWT-Token-Verifizierung + Claims-Extraktion |
| `auth` | `refreshToken` | Refresh-Token-Generierung (7 Tage) |
| `auth` | `generateResetToken` | Zufälliges Hex-Token für Passwort-Reset |
| `crypto` | `encrypt` | AES-256-GCM symmetrische Verschlüsselung |
| `crypto` | `decrypt` | AES-256-GCM Entschlüsselung |
| `crypto` | `generateOTP` | TOTP-Secret + QR-Bereitstellungs-URL |
| `crypto` | `verifyOTP` | TOTP-Code-Verifizierung |
| `storage` | `uploadFile` | S3-kompatibler Datei-Upload |
| `storage` | `deleteFile` | S3-kompatible Datei-Löschung |
| `storage` | `presignURL` | S3-vorsignierte Download-URL |
| `mail` | `sendEmail` | SMTP-Klartext-E-Mail |
| `mail` | `sendTemplateEmail` | Go-Template-HTML-E-Mail über SMTP |
| `text` | `generateSlug` | Unicode zu URL-sicherem Slug |
| `text` | `sanitizeHTML` | XSS-Präventions-HTML-Bereinigung |
| `text` | `truncateText` | Unicode-sichere Textkürzung |
| `image` | `ogImage` | OG-Bild-Generierung (1200x630, PNG) |
| `image` | `thumbnail` | Vorschaubild-Generierung (200x200, PNG) |

Projekte können diese überschreiben, indem sie eigene Implementierungen in `specs/<project>/func/<pkg>/` bereitstellen.

### Eingebaute Modelle (pkg/)

Paketpräfix-@model-Interfaces für Nicht-DDL-I/O. Konfiguriert über `fullend.yaml`.

| Paket | Interface | Backends | SSaC-Verwendung |
|---|---|---|---|
| `session` | `SessionModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `session.Session.Get({key: ...})` |
| `cache` | `CacheModel` (Set/Get/Delete + TTL) | PostgreSQL, Memory | `cache.Cache.Set({key: ..., value: ..., ttl: ...})` |
| `file` | `FileModel` (Upload/Download/Delete) | S3, LocalFile | `file.File.Upload({key: ..., body: ...})` |
| `queue` | Singleton Pub/Sub (Publish/Subscribe) | PostgreSQL, Memory | `@publish "topic" {payload}` |

### Middleware (Generiert)

Fullend generiert projektspezifische `internal/middleware/bearerauth.go` aus der `fullend.yaml`-Claims-Konfiguration.

| Middleware | Auslöser | Beschreibung |
|---|---|---|
| `BearerAuth(secret)` | `securitySchemes.bearerAuth` + `backend.auth.claims` | Extrahiert JWT → setzt `*model.CurrentUser` im gin-Kontext |

Die Routen-Gruppierung wird durch das OpenAPI-`security`-Feld bestimmt. Operationen mit `security: [{bearerAuth: []}]` kommen in die Auth-Gruppe; Operationen ohne in die öffentliche Gruppe.

## Kreuzvalidierungs-Regeln

Der einzigartige Wert von Fullend liegt in der Kreuzvalidierung. Nachdem Einzeltools ihre eigenen Schichten validiert haben, fängt Fullend Inkonsistenzen zwischen den SSOTs ab.

**fullend.yaml ↔ OpenAPI**
| Ziel | Regel |
|---|---|
| Middleware-Name | Stimmt er mit einem securitySchemes-Schlüssel überein? |

**OpenAPI ↔ DDL**
| Ziel | Regel |
|---|---|
| x-sort.allowed | Existiert die Spalte in der Tabelle? |
| x-sort ↔ DDL-Index | Hat die Spalte einen Index? (WARNING) |
| x-filter.allowed | Existiert die Spalte in der Tabelle? |
| x-include.allowed | Ist es eine durch FK verbundene Tabelle? |

**SSaC ↔ DDL**
| Ziel | Regel |
|---|---|
| Model.Method | Existiert die Methode in den sqlc-Abfragen? |
| @result Type | Stimmt er mit dem aus der DDL-Tabelle abgeleiteten Typ überein? |
| Argument-Felder | Können sie auf DDL-Spalten abgebildet werden? |

**SSaC ↔ OpenAPI**
| Ziel | Regel |
|---|---|
| Funktionsname | Stimmt er mit einer operationId überein? |
| request-Argumente | Existiert das Feld im Anfrageschema? |
| @response-Felder | Existiert das Feld im Antwortschema? |

**States ↔ SSaC ↔ OpenAPI ↔ DDL**
| Ziel | Regel |
|---|---|
| Übergangsereignis | Stimmt es mit einem SSaC-Funktionsnamen überein? |
| Übergangsereignis | Stimmt es mit einer OpenAPI-operationId überein? |
| SSaC @state | Existiert das referenzierte stateDiagram? |
| @state-Feld | Existiert es als DDL-Spalte? |

**Policy ↔ SSaC ↔ DDL ↔ States**
| Ziel | Regel |
|---|---|
| allow (action, resource) | Stimmt es mit SSaC @auth überein? |
| @ownership table.column | Existiert es in der DDL? |
| @ownership via join | Existiert der Join-Tabellen-FK in der DDL? |
| Zustandsübergangsereignis | Gibt es eine passende Rego-Regel für Übergänge mit @auth? |

**Func ↔ SSaC**
| Ziel | Regel |
|---|---|
| @call-Referenz | Gibt es eine entsprechende Func-Implementierung? |
| Argumentanzahl | Stimmt die Anzahl der @call-Argumente mit den Request-Feldern überein? |
| Argumenttypen | Stimmen die positionellen Typen über DDL/OpenAPI überein? |
| Ergebnis/Antwort | Ist result/response konsistent? |
| Funktionskörper | Ist es kein TODO-Stub? (WARNING) |

**Scenario ↔ OpenAPI ↔ States**
| Ziel | Regel |
|---|---|
| operationId | Existiert sie in OpenAPI? |
| HTTP-Methode | Stimmt sie mit der OpenAPI-Methode überein? |
| JSON-Felder | Existieren sie im Anfrageschema? |
| Schritt-Reihenfolge | Folgt sie den Zustandsübergangs-Regeln? |

**Queue (Pub/Sub)**
| Ziel | Regel |
|---|---|
| @publish-Topic | Gibt es eine passende @subscribe-Funktion? |
| payload/message-Felder | Sind sie konsistent? |
| Queue-Konfiguration | Hat fullend.yaml eine Queue-Konfiguration? |

**STML ↔ SSaC** — Beide referenzieren dieselbe OpenAPI-operationId. Wenn beide Validierungen bestanden sind, wird die Übereinstimmung zwischen der API, die das Frontend aufruft, und der API, die das Backend verarbeitet, automatisch garantiert.

## Laufzeit-Tests

`fullend gen` generiert [Hurl](https://hurl.dev)-Tests aus OpenAPI-Spezifikationen und Gherkin-Szenarien.

```bash
# Server starten, dann:
hurl --test --variable host=http://localhost:8080 artifacts/my-project/tests/*.hurl
```

Generierte Tests:
- **smoke.hurl** — OpenAPI-Endpunkt-Smoke-Tests (automatisch generiert)
- **scenario-*.hurl** — Geschäftsszenario-Tests (aus .feature-Dateien)
- **invariant-*.hurl** — Endpunktübergreifende Invarianten-Tests (aus .feature-Dateien)

## Entworfen für Agenten

Fullend wurde für KI-Agenten entworfen.

Damit ein Agent Specs schreiben kann, muss er die 10 Sequenztypen von SSaC, die data-*-Attribute von STML, die OpenAPI-x-Erweiterungen, die stateDiagram-Regeln, die OPA-Richtlinienmuster, die Gherkin-Szenario-Syntax, die Func-Spec-Regeln und die Namens-Matching-Regeln kennen. Ein etwa 830-zeiliges KI-Handbuch wird bereitgestellt. Es muss nur einmal in den System-Prompt des Agenten eingefügt werden.

Die Validierungsschleife nach dem Schreiben der Specs ist einfach.

```
Agenten-Workflow:
1. specs/ bearbeiten
2. fullend validate specs/my-project
3. Bei Fehlern → betroffene SSOT korrigieren → zurück zu 2
4. Null Fehler → fullend gen specs/my-project artifacts/my-project
```

Man muss nicht das gesamte System verstehen. Einfach korrigieren, worauf validate zeigt, und die Konsistenz ist wiederhergestellt. Ein intelligentes Modell schafft es beim ersten Mal; ein kleineres Modell braucht drei Versuche. Das Ergebnis ist dasselbe.

## SSOT-Größe nach Skalierung

| Skalierung | Beispiel | SSOT | Implementierungscode | Kontextauslastung |
|---|---|---|---|---|
| Klein | Friseursalon-Buchung | ~1.500 Zeilen | ~10.000 Zeilen | ~8% |
| Mittel | Jira/Notion-Klasse | ~12.500 Zeilen | ~100.000 Zeilen | ~55% |
| Groß | Shopify-Klasse | ~30.000 Zeilen | ~300.000 Zeilen | ~90% |

Basierend auf 200K-Token-Kontext. Bis zur Größe eines mittleren SaaS kann ein Agent das gesamte Design in einem Durchgang lesen.

## Ausnahmen in Muster verwandeln

Was die 10 Sequenztypen nicht abdecken können, fällt an `@call` durch. Was die data-*-Attribute nicht abdecken können, fällt an `custom.ts` durch. Wenn diese Escape Hatches 20% des Gesamtumfangs übersteigen, verliert die Strukturierung ihren Sinn.

Doch Ausnahmen werden beobachtbar, sobald sie isoliert sind. Wenn viele Projekte Fullend einsetzen, werden sich in `@call` und `custom.ts` wiederkehrende Muster zeigen.

Auch die 10 Sequenztypen von SSaC wurden nicht von Grund auf entworfen. Sie konvergierten auf 10, nachdem Hunderte von Service-Code-Beispielen beobachtet wurden. Dasselbe Prinzip wird sich bei den Escape Hatches wiederholen. Häufig auftretende `@call`-Muster werden zu neuen Sequenztypen; häufig auftretende `custom.ts`-Muster werden zu neuen data-*-Attributen.

Ausnahmen schrumpfen nicht — Struktur wächst aus ihnen.

## Erweiterung des Tech-Stacks

Derzeit ist Fullend auf Go(gin) + React + PostgreSQL + Terraform festgelegt. Das ist beabsichtigt. In der PoC-Phase hat die vollständige Durchdringung eines Stacks Priorität.

Jedoch sind viele der 10 SSOTs (OpenAPI, SQL DDL, Terraform, Mermaid, OPA Rego, Gherkin) bereits sprachunabhängig. Die 10 Sequenztypen von SSaC sind sprachunabhängige Muster — sie werden lediglich als Go-Kommentare ausgedrückt. STML basiert auf HTML5-data-*-Attributen und ist frameworkunabhängig.

Die Erweiterung ist eine Frage der Hinzufügung von Code-Generierungs-Backends. Validierungslogik und Kreuzvalidierungsregeln bleiben unverändert.

## Beziehung zu GEUL

Die 10 SSOTs bilden alle Entscheidungen einer Software ab. Ein SSOT ist strukturierte Daten. Strukturierte Daten sind ein Graph. Ein Graph kann in GEUL kodiert werden.

STMLs `data-fetch="ListReservations"` ist eine Beziehung zwischen Entitäten. SSaCs `@get → @empty → @state → @call → @put → @response` ist eine Ereignissequenz. Zustandsdiagramm-Übergänge sind Zustandsgraphen. OPA-Richtlinien sind Berechtigungsbeziehungen. Die Endpunktdefinitionen von OpenAPI sind Verträge. All dies sind semantische Strukturen, die sich als GEULs Triple-Edges, Event6-Edges und Entity-Nodes ausdrücken lassen.

Die Art, wie Fullend die Kreuzvalidierung zwischen 10 SSOTs durchführt — symbolisches Matching, Typkonsistenzprüfung, referenzielle Integritätsprüfung — folgt demselben Prinzip wie die maschinelle Verifikation in GEUL-Streams.

## Lizenz

MIT — <a href="https://github.com/geul-org/fullend" target="_blank" rel="noopener">GitHub</a>
