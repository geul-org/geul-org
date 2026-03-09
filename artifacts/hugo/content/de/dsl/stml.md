---
title: "STML — SSOT Template Markup Language"
weight: 1
date: 2026-03-08T12:00:00+09:00
lastmod: 2026-03-08T12:00:00+09:00
tags: ["STML", "DSL", "SSOT", "frontend", "React", "OpenAPI"]
summary: "Eine framework-unabhängige UI-Deklarationssprache. Definiert, was Seiten zeigen und tun, mit HTML5 data-*-Attributen, validiert symbolisch gegen OpenAPI und generiert React-Code."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**SSOT Template Markup Language** — framework-unabhängige UI-Deklaration.

Frontend-Code mischt zwei Dinge: **Ihre Entscheidungen** und **Framework-Verdrahtung**. Welche API aufrufen, welche Felder zeigen, in welcher Reihenfolge, unter welchen Bedingungen — diese Entscheidungen sind in React Hooks oder Vue Composables vergraben. Beim Framework-Wechsel oder Refactoring werden Entscheidungen neu interpretiert oder gehen verloren.

STML trennt sie. Entscheidungen bleiben in Standard-HTML mit `data-*`-Attributen. Framework-Verdrahtung wird generiert oder delegiert.

<a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub-Repository</a>

## Was erhalten bleibt

Alles im STML-HTML ist eine Benutzerentscheidung:

- **Welche API-Endpunkte** aufrufen (`data-fetch`, `data-action`)
- **Welche Felder** anzeigen oder erfassen (`data-bind`, `data-field`)
- **In welcher Reihenfolge** Elemente erscheinen (DOM-Struktur)
- **Wie es aussieht** (Tailwind-Klassen, HTML-Tags)
- **Welcher Text** Benutzer sehen (Überschriften, Platzhalter, Button-Labels)
- **Welche Bedingungen** die Sichtbarkeit steuern (`data-state`)
- **Welche Komponenten** spezielle UX handhaben (`data-component`)
- **Listenverhalten** — Paginierung, Sortierung, Filterung

Nicht React. Nicht Vue. Es ist, was Ihre Seite tut, in Standard-HTML5 deklariert.

## Validierung

Der integrierte Validator prüft STML gegen OpenAPI vor der Code-Generierung:

- Existiert die operationId? Ist die HTTP-Methode korrekt?
- Stimmen Request-, Response-Felder und Parameter mit dem Schema überein?
- Sind Sort/Filter/Include-Spalten in den erlaubten Listen?
- Existieren referenzierte Komponenten?

Erkennt Frontend-API-Inkonsistenzen zur CI-Zeit, nicht zur Laufzeit.

```bash
stml validate specs/my-project    # 12 symbolische Prüfungen gegen OpenAPI
```

## data-*-Attribute

| Attribut | Was es deklariert |
|---|---|
| `data-fetch` | Lädt Daten von einem GET-Endpunkt |
| `data-action` | Sendet Daten an einen POST/PUT/DELETE-Endpunkt |
| `data-field` | Erfasst ein Request-Body-Feld |
| `data-bind` | Zeigt ein Response-Feld an |
| `data-param-*` | Operation benötigt einen Pfad-/Query-Parameter |
| `data-each` | Iteriert über ein Array-Feld |
| `data-state` | Bedingte Anzeige |
| `data-component` | Delegiert an eine benutzerdefinierte Komponente |
| `data-paginate` | Paginierte Liste |
| `data-sort` | Sortierbare Liste (Standard-Spalte und -Richtung) |
| `data-filter` | Filterbare Liste (welche Spalten) |
| `data-include` | Bezieht verwandte Ressourcen ein |

## Lizenz

MIT — <a href="https://github.com/geul-org/stml" target="_blank" rel="noopener">GitHub</a>
