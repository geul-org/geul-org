---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID ist ein Deklarations-Reference, das mit der Zahl der Q-ID auf einen Wikidata-Eintrag (Item) verweist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID ist ein Deklarations-Reference, das auf einen Wikidata-Eintrag (Item) verweist. Der Zahlenteil der Q-ID ohne das `Q` wird als vorzeichenlose Ganzzahl geschrieben.

## Layout

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[Length-Erweiterungs-TAG]
QID               vorzeichenloses Big-Endian in der kürzesten Breite
```

- Die QID wird in der kürzesten Breite geschrieben. `Q1`~`Q65535` ergeben insgesamt 2 WORD, darüber 3 WORD.
- Die Wikidata-Daten stehen unter CC0.
- Bei Variable ist es eine anonyme Variable der Art, auf die der Eintrag verweist ([Reference](/de/grammar/reference/), Variable).

## Beispiel

| Eintrag | WORD-Folge |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [WIKIDATA-PID](/de/grammar/reference/wikidata-pid/), [TRIPLE](/de/grammar/edge/triple/)
