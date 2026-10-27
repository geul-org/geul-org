---
title: "SOURCE et sections"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Formats ISSUER de GEUL 0xC000~0xC005 qui écrivent le texte original rédigé (SOURCE), les chaînes (TEXT), les sections et cas (SECTION, CASE-BEGIN, CASE-END) et les paragraphes descriptifs (PROSE) d'un document TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Enregistrements qui écrivent le texte original et les sections d'un document TOULMIN. Ce sont tous des Edge employant un numéro de format sous `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` (GEUL) ([TOULMIN](/fr/grammar/edge/toulmin/#formats-issuer)).

## Formats

| Numéro de format | Nom | Disposition |
|---|---|---|
| `0xC000` | SOURCE | ID, WORD de largeur de SPAN, Value UTF8 |
| `0xC001` | TEXT | ID, Value UTF8 |
| `0xC002` | SECTION | ID, code de section 1 WORD |
| `0xC003` | CASE-BEGIN | ID, REF (cas) |
| `0xC004` | CASE-END | ID, REF (cas) |
| `0xC005` | PROSE | ID, SPAN |

- ID est l'Edge Id, REF l'Edge Id d'un enregistrement de ce document (champs communs de [TOULMIN](/fr/grammar/edge/toulmin/#champs-communs)).
- La Value UTF8 est un enregistrement Value [UTF8-TEXT](/fr/grammar/value/text/utf8-text/). Elle contient les octets tels quels.

## SOURCE

C'est tout le texte original rédigé. Tout SPAN est une étendue en octets dans ce texte original.

```
ID
WORD de largeur de SPAN   2 bits de poids fort = largeur (00=1, 01=2, 10=4, 11=8 WORD), 14 autres bits = 0
Texte original            enregistrement Value UTF8-TEXT
```

- SOURCE est le premier enregistrement du BODY. Il y en a un par document.
- Un SPAN a deux champs : l'octet de début et le nombre d'octets. Chaque champ est un entier non signé de la largeur (1/2/4/8 WORD) fixée par le WORD de largeur de SPAN.

## TEXT

C'est un nom ou une chaîne. Les listes F_WITH et F_GROUNDS de NODE et le LABEL et IMPORTED-FROM de LINK le désignent par REF.

## SECTION

Début d'une section. Le code de section fait 1 WORD.

| Code | Section | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | Règles à expression conditionnelle |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- On n'emploie pas `0`. Les sections sont déclarées dans l'ordre de ces codes.
- Le titre d'une section est le PROSE qui suit immédiatement SECTION.

## CASE-BEGIN, CASE-END

- L'étendue d'un cas va de CASE-BEGIN à CASE-END qui désignent le même cas (NODE CASE-DECLARE).

## PROSE

Paragraphe descriptif qui n'est pas une règle. Il ne désigne que l'étendue (SPAN) du texte original.

## Pages liées

- [TOULMIN](/fr/grammar/edge/toulmin/), [NODE](/fr/grammar/edge/toulmin/node/), [LINK](/fr/grammar/edge/toulmin/link/)
