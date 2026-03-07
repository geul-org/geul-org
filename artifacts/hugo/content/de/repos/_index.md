---
title: "Repositories"
date: 2026-02-28T12:00:00+09:00
summary: "GitHub-Repositories des GEUL-Projekts. Sprachdesign, Encoding-Pipeline, Suchmaschine und Website."
image: "/images/og-default.webp"
---

Das GEUL-Projekt besteht aus vier Repositories.

Die Sprache entwerfen (geul), die Entitäten der Welt in 64 Bit kodieren (geul-sidx), über diesem Index suchen (silk) und erklären, warum all das notwendig ist (geul-org).

---

## geul

Eine semantisch ausgerichtete künstliche Sprache und ein binäres Streamformat für KI.

Ein 2-Byte-Sprachsystem (65.536 Symbole), das für eindeutige Kommunikation zwischen Menschen und KI entwickelt wurde. Jede Aussage trägt ihre Quelle, ihren Zeitstempel und ihr Konfidenzniveau. Jede Entität hat einen eindeutigen Bezeichner. Das Streamformat arbeitet in 16-Bit-Einheiten und definiert 10 Pakettypen (Verb Edge, Entity Node, Triple Edge usw.) unter einem 10-Bit-Präfix-Schema.

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| Sprache | Go, Python |
| Lizenz | MIT |

---

## geul-sidx

SIDX (Semantic-aligned Index) Codebuch-Builder und Encoding-Pipeline.

Kodiert 108,8 Millionen Wikidata-Entitäten in 64-Bit-strukturierte Bezeichner. Definiert 63 Entitätstypen, entwirft 48-Bit-Attributschemata pro Typ, baut Codebücher und validiert die Encoding-Ergebnisse (VALID). Der Produzent der Indizes und Codebücher, die SILK konsumiert.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| Sprache | Python |
| Lizenz | MIT |

---

## silk

SILK (Symbolic Index for LLM Knowledge) — eine neuro-symbolische Sucharchitektur.

Sucht mit 64-Bit-Ganzzahlen. Keine Vektordatenbank, kein ANN-Graph, kein Embedding-Modell erforderlich. Eine einzige bitweise NumPy-AND-Operation durchsucht 100 Millionen Datensätze, und die zentrale These ist, dass Python allein optimierte C++/Rust-Vektorsuche übertrifft. Bietet eine hybride Abfrage-Pipeline, die Codebuch-Suche mit LLM-Unterstützung kombiniert.

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| Sprache | Python |
| Lizenz | MIT |

---

## geul-org

Der Quellcode dieser Website.

Ein Hugo-Generator für statische Websites mit Unterstützung für 12 Sprachen. Bereitgestellt über S3 + CloudFront, mit einer CloudFront Function für Spracherkennung und saubere URLs.

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| Sprache | Hugo (Go Templates), CSS |
| Lizenz | MIT |
