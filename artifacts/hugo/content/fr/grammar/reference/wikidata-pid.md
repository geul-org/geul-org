---
title: "WIKIDATA-PID"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "WIKIDATA-PID est une Reference de déclaration qui désigne une propriété (Property) de Wikidata par la partie numérique de son P-ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WIKIDATA-PID est une Reference de déclaration qui désigne une propriété (Property) de Wikidata. On écrit en entier non signé la partie numérique du P-ID, privée du `P`.

## Disposition

```
TAG WORD          0000 0LLL L010 1QQQ      CCCC = 0101
[TAG d'extension de Length]
PID               unsigned big-endian sur la largeur la plus courte
```

- Le PID s'écrit sur la largeur la plus courte. Les numéros de propriété actuels tiennent dans 1 WORD, soit 2 WORD au total, et au-delà de 65535 on passe naturellement à 3 WORD.
- On l'emploie surtout à la place de Predicate de [TRIPLE](/fr/grammar/edge/triple/) et de Property de [QUALIFIER](/fr/grammar/edge/qualifier/).

## Exemple

| Propriété | Suite de WORD |
|---|---|
| `P31` (instance of) | `00A8 001F` |
| `P279` (subclass of) | `00A8 0117` |
| `P569` (date of birth) | `00A8 0239` |

## Pages liées

- [Reference](/fr/grammar/reference/), [WIKIDATA-QID](/fr/grammar/reference/wikidata-qid/), [TRIPLE](/fr/grammar/edge/triple/), [QUALIFIER](/fr/grammar/edge/qualifier/)
