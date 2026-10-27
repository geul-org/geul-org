---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL ist ein Deklarations-Reference, das mit einer von geul.org unter CC0 vergebenen Entitäts-ID auf ein Objekt verweist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL ist ein Deklarations-Reference, das auf eine von geul.org unter CC0 vergebene Entität verweist. Es ist eine fortlaufende ID, deren Nummer keine Bedeutung trägt. Kennungen, deren Bits Bedeutung tragen, übernimmt der eigene Codec [GEUL-SIDX](/de/grammar/reference/geul-sidx/) (`0011`).

## Layout

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length-Erweiterungs-TAG]
GEUL ID           vorzeichenloses Big-Endian in der kürzesten Breite
```

- Kleine Nummern werden häufig verwendeten Entitäten zugewiesen. Eine ID, die in 1 WORD passt, ergibt insgesamt 2 WORD.
- Vergabe der IDs und Register verwaltet geul.org. In das Register kommt nur, was aus CC0-Quellen stammt.
- Bei Variable ist es eine anonyme Variable dieser Art ([Reference](/de/grammar/reference/), Variable).

## Beispiel

| GEUL ID | WORD-Folge |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## Offene Fragen

- Vergaberegeln für GEUL IDs und Veröffentlichungsformat des Registers.

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [GEUL-SIDX](/de/grammar/reference/geul-sidx/)
