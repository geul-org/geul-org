---
title: "WIKIDATA-QID"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-QID est une Reference de déclaration qui désigne un élément (Item) de Wikidata par la partie numérique de son Q-ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-QID est une Reference de déclaration qui désigne un élément (Item) de Wikidata. On écrit en entier non signé la partie numérique du Q-ID, privée du `Q`.

## Disposition

```
TAG WORD          0000 0LLL L010 0QQQ      CCCC = 0100
[TAG d'extension de Length]
QID               unsigned big-endian sur la largeur la plus courte
```

- Le QID s'écrit sur la largeur la plus courte. De `Q1` à `Q65535`, 2 WORD au total, au-delà 3 WORD.
- Les données de Wikidata sont en CC0.
- Si c'est Variable, c'est une variable anonyme de l'espèce que désigne cet élément ([Reference](/fr/grammar/reference/), Variable).

## Exemple

| Élément | Suite de WORD |
|---|---|
| `Q5` (human) | `00A0 0005` |
| `Q76` (Barack Obama) | `00A0 004C` |
| `Q884` (South Korea) | `00A0 0374` |
| `Q317521` (Elon Musk) | `0120 0004 D851` |
| `Q30461` (president), Variable | `00A4 76FD` |

## Pages liées

- [Reference](/fr/grammar/reference/), [WIKIDATA-PID](/fr/grammar/reference/wikidata-pid/), [TRIPLE](/fr/grammar/edge/triple/)
