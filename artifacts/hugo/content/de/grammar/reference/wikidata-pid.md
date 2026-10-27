---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID ist ein Deklarations-Reference, das mit der Zahl der P-ID auf eine Wikidata-Eigenschaft (Property) verweist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID ist ein Deklarations-Reference, das auf eine Wikidata-Eigenschaft (Property) verweist. Der Zahlenteil der P-ID ohne das `P` wird als vorzeichenlose Ganzzahl geschrieben.

## Layout

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[Length-Erweiterungs-TAG]
PID               vorzeichenloses Big-Endian in der kürzesten Breite
```

- Die PID wird in der kürzesten Breite geschrieben. Die derzeitigen Eigenschaftsnummern passen in 1 WORD und ergeben insgesamt 2 WORD; über 65535 wächst es von selbst auf 3 WORD.
- Es wird vor allem an der Stelle des Predicate eines [TRIPLE](/de/grammar/edge/triple/) und der Property eines [QUALIFIER](/de/grammar/edge/qualifier/) verwendet.

## Beispiel

| Eigenschaft | WORD-Folge |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [WIKIDATA-QID](/de/grammar/reference/wikidata-qid/), [TRIPLE](/de/grammar/edge/triple/), [QUALIFIER](/de/grammar/edge/qualifier/)
