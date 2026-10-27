---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE ist ein Definitions-Meta, das die Standardsprache der Dokumenttexte als Sprach-Value deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Deklariert die Standardsprache der Dokumenttexte. Texte ohne eigene Sprachangabe sind in dieser Sprache.

## Layout

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length-Erweiterungs-TAG]
Payload           ein Sprach-Value
```

- Codec: Meta `0x16`, Definitionsklasse (`001`)
- Payload: eingebetteter Value ([LANGUAGE-BCP47-CODE](/de/grammar/value/text/language-bcp47-code/) oder [LANGUAGE-SHORT-CODE](/de/grammar/value/text/language-short-code/))
- Anzahl: höchstens eins

## Interpretation und Gültigkeit

- TANGEUL-Dokumente geben die Sprache (Locale) an, in der sie verfasst sind (z. B. `en`, `ko`).

## Beispiel

- `en`: `0x1916 0x08C6 0x656E`
