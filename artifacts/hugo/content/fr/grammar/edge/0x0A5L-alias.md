---
title: "ALIAS (0x0A5L)"
weight: 165
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ALIAS est un Edge d'énoncé qui relie à Subject, par Object, un autre nom (alias)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `ALIAS` (BIND du document de spécification `ALIAS`) |
| TAG ID | `0x0A5L` |
| Codec ID | `0x00000A50` |
| Document de spécification | `0x00000000/codecs/0x00000A50/` (cible de DECLARE `0A50`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 5 |
| Kind | Edge · famille : énoncé, groupe : désignation et nom |
| TAG WORD | `0000 1010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Liaison d'un autre nom (alias) de Subject. Disposition identique à LABEL |
| Côté Hugo | `edge/alias.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |
| 2 | `object` | #3 | enregistrement | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

ALIAS est un Edge d'énoncé qui relie à Subject, par Object, un autre nom (alias). Codec `0x0A5L`.

[LABEL](0x0A4L-label.md) est le nom représentatif dans cette langue (au plus un par langue), et ALIAS est un autre nom du même objet (plusieurs par langue, « also known as » de Wikidata). Il sert surtout à la recherche. La disposition et la validité sont identiques à LABEL.

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 0101 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 Value UTF8-LANGUAGE-TEXT ou 1 enregistrement Reference LOCAL
```

## Interprétation et validité {#해석과-유효성}

- Les règles de Subject et d'Object sont celles de [LABEL](0x0A4L-label.md) (Object est un [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) ou un LOCAL qui s'y résout).
- On peut placer plusieurs ALIAS pour un même Subject et une même langue. L'ordre est celui du document.
- On ne place pas en ALIAS le même texte que le LABEL du même Subject et de la même langue (un seul LABEL suffit comme nom représentatif). Cette règle est une recommandation.
- Le document de spécification de geul.org restreint Object par [CODEC](0x0BEL-codec.md) (`0780`·`0790`·`0050`, comme LABEL).

## Exemple (non normatif) {#예시-비규범}

Edge Id `0003`, Subject Q42 (`0141 002A`), Object `DNA` (en) : langue `0761 656E` (BCP47 `en`) + texte de 3 octets (impair) → `UTF8-LANGUAGE-TEXT-ODD` (`0x079L`), `0794 0761 656E 444E 4100`.

- TAG 1 + Edge Id 2 + Subject 2 + Object 5 = 10 WORD, `LLLL=1001`. Le TAG est `0A59`.

```
0A59 0051 0003 0141 002A 0794 0761 656E 444E 4100
```

## Pages liées {#관련-페이지}

- [Edge](_index.md), [LABEL](0x0A4L-label.md), [DESCRIPTION](0x0A6L-description.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000A50/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A5000000000
BODY
#1 DECLARE 0x0A50
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "ALIAS"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
