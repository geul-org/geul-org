---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
summary: "GitHub-Repositories des GEUL-Projekts. Sprachspezifikation, Grammatik-Codebücher, Suche, DSL und Website."
image: "/images/og-default.webp"
---

Alle Repositories befinden sich in der [geul-org](https://github.com/geul-org) GitHub-Organisation.

---

## Sprache

### geul

Eine semantisch ausgerichtete künstliche Sprache und ein binäres Streamformat für KI.

Ein 2-Byte-Sprachsystem (65.536 Symbole), das für eindeutige Kommunikation zwischen Menschen und KI entwickelt wurde. Jede Aussage trägt ihre Quelle, ihren Zeitstempel und ihr Konfidenzniveau. Jede Entität hat einen eindeutigen Bezeichner. Das Streamformat arbeitet in 16-Bit-Einheiten und definiert 10 Pakettypen (Verb Edge, Entity Node, Triple Edge usw.) unter einem 10-Bit-Präfix-Schema.

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| Sprache | Go, Python |
| Lizenz | MIT |

---

## Grammatik

### geul-verb

Verb-SIDX-16-Bit-Codebuch (WordNet-basiert).

Ordnet WordNet-Verb-Synsets 16-Bit-Codes zu, die in GEUL-Verb-Edge-Paketen verwendet werden. Stellt das Verbvokabular bereit, das das Streamformat konsumiert.

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| Sprache | Python |
| Lizenz | MIT |

### geul-entity

Entitäts-SIDX-48-Bit-Codebuch (Wikidata-basiert).

Kodiert Wikidata-Entitäten in 48-Bit-strukturierte Bezeichner. Definiert Entitätstypen, entwirft Attributschemata pro Typ und baut die Codebücher, die SILK konsumiert.

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| Sprache | Python |
| Lizenz | MIT |

### geul-quantities

Mengenknoten-Codebuch.

Definiert das Kodierungsschema für Mengenwerte — Zahlen mit Einheiten, Bereiche und Genauigkeit — die in GEUL-Quantity-Node-Paketen verwendet werden.

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| Sprache | Python |
| Lizenz | MIT |

### geul-ast

AST-Edge-Codebuch.

Definiert das Kodierungsschema für Kanten abstrakter Syntaxbäume und ermöglicht strukturierte Codedarstellung innerhalb des GEUL-Streamformats.

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| Sprache | Python |
| Lizenz | MIT |

---

## Suche

### silk

SILK (Symbolic Index for LLM Knowledge) — eine neuro-symbolische Sucharchitektur.

Sucht mit 64-Bit-Ganzzahlen. Keine Vektordatenbank, kein ANN-Graph, kein Embedding-Modell erforderlich. Eine einzige bitweise NumPy-AND-Operation durchsucht 100 Millionen Datensätze, und die zentrale These ist, dass Python allein optimierte C++/Rust-Vektorsuche übertrifft. Bietet eine hybride Abfrage-Pipeline, die Codebuch-Suche mit LLM-Unterstützung kombiniert.

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| Sprache | Python |
| Lizenz | MIT |

---

## DSL

### ssac

Service Sequences as Code — parst deklarative Servicelogik aus Go-Kommentaren und generiert Go-Implementierungscode via CLI.

Definiert Service-Abläufe als strukturierte Kommentare in Go-Quelldateien. Das CLI liest diese Deklarationen und generiert den entsprechenden Implementierungscode, wodurch Boilerplate eliminiert wird, während die Logik lesbar und versionskontrolliert bleibt.

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| Sprache | Go |
| Lizenz | MIT |

---

## Website

### geul-org

Der Quellcode dieser Website.

Ein Hugo-Generator für statische Websites mit Unterstützung für 12 Sprachen. Bereitgestellt über S3 + CloudFront, mit einer CloudFront Function für Spracherkennung und saubere URLs.

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| Sprache | Hugo (Go Templates), CSS |
| Lizenz | MIT |
