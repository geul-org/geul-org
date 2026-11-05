---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE est un Edge d'énoncé orienté qui relie une Reference à un enregistrement Object pour définir ou lier ce qu'est cette Reference."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `REFERENCE-NODE` (BIND du document de spécification `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| Document de spécification | `0x00000000/codecs/0x00000A00/` (cible de DECLARE `0A00`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 0 |
| Kind | Edge · famille : énoncé, groupe : désignation et nom |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Liaison orientée où Subject, une Reference, désigne Object |
| Côté Hugo | `edge/reference-node.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |
| 2 | `object` | #3 | enregistrement | `000F` section 0 entière (joker, Reference), `020F` section 1 entière (joker, Reference), `040F` section 2 entière (joker, Reference), `060F` section 3 entière (joker, Value), `080F` section 4 entière (joker, Value) |  |

REFERENCE-NODE est un Edge d'énoncé orienté qui relie une Reference à un enregistrement Object pour définir ou lier ce qu'est cette Reference. Codec `0x0A0L`.

Subject désigne Object. Cette liaison n'est pas [SAME-NODE](0x0A1L-same-node.md), qui affirme une identité sémantique, et ne signifie pas non plus que les octets des deux enregistrements sont identiques.

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 enregistrement Reference ou Value
```

## Interprétation et validité {#해석과-유효성}

- Subject doit être exactement un enregistrement [Reference](../reference/_index.md) complet. Ses limites se trouvent par sa propre Length ; s'il n'est pas une Reference ou est incomplet, il est invalid.
- Object doit être exactement un enregistrement Reference ou Value complet. Ses limites se trouvent par sa propre Length ; s'il est un Edge ou un Meta, ou incomplet, il est invalid.
- Si Object est une Reference, la chaîne de Reference suivie par les liaisons REFERENCE-NODE ne doit pas être cyclique et le LOCAL doit finir par être résolu. Un cycle de résolution et un LOCAL dangling sont invalid.
- Si, dans un même document, un ID LOCAL est lié à des Object en conflit, c'est invalid. La portée du LOCAL, l'ID, la largeur minimale et la règle de fusion suivent [LOCAL](../reference/0x005L-local.md).
- Toutes les Reference n'ont pas à être liées par REFERENCE-NODE.
- L'usage représentatif est `LOCAL → UTF8-LANGUAGE-TEXT`. Lorsqu'un LOCAL est placé dans Object de [LABEL](0x0A4L-label.md), le texte est résolu par cette liaison du même document.

Il ne faut pas interpréter à l'envers la direction dans laquelle Subject désigne Object. Le sens et les règles détaillées de SAME et DIFFERENT sont fixés par leurs formats respectifs.

## Longueur {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` est le nombre de WORD du TAG d'extension de Length, `N_id` celui de l'enregistrement LOCAL de l'Edge Id, `N_subject` et `N_object` le nombre total de WORD de chaque enregistrement. Le curseur, une fois Subject et Object lus, doit coïncider exactement avec la fin de l'Edge.

## Exemple (non normatif) {#예시-비규범}

L'Edge Id est `0008`, Subject est LOCAL 1, Object est l'[UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) de `Donald Trump` (en).

- L'Edge Id est `0051 0008`, soit 2 WORD.
- Subject est `0051 0001`, soit 2 WORD.
- Object est la langue `0761 656E` (BCP47 `en`) + un texte de 12 octets (pair), donc `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), 9 WORD au total. Le TAG est `0788`.
- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. Le TAG est `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## Pages liées {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000A00/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
