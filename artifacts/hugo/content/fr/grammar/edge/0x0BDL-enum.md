---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM est un Edge d'énoncé qui attache un sens à une valeur de code d'un champ de valeur brute."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `ENUM` (BIND du document de spécification `ENUM`) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| Document de spécification | `0x00000000/codecs/0x00000BD0/` (cible de DECLARE `0BD0`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 29 |
| Kind | Edge · famille : énoncé, groupe : divers |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Une valeur de code d'un champ de valeur brute. Champ, valeur de code |
| Côté Hugo | `edge/enum.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | enregistrement | `0050` LOCAL |  |
| 2 | `code` | #3 | valeur brute restante (`0xFFFF`) |  |  |

ENUM est un Edge d'énoncé qui attache un sens à une valeur de code d'un champ de valeur brute. Codec `0x0BDL`.

Avec [FIELD](0x0BCL-field.md), c'est le vocabulaire pour écrire une spécification de Codec. La disposition est intégrée au décodeur ([document de spécification de Codec](../codec-spec.md)).

## Disposition {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
champ             enregistrement Reference LOCAL désignant l'Edge FIELD
valeur de code    valeur brute. Autant de WORD que la largeur de ce FIELD
```

## Interprétation et validité {#해석과-유효성}

- Le champ doit être un FIELD de valeur brute (largeur `n ≥ 1`). On n'attache pas d'ENUM à un champ d'enregistrement. Le sens d'un enregistrement est donné par le Codec de cet enregistrement.
- La valeur de code a exactement la largeur de ce FIELD. On vérifie les limites par la Length de l'enregistrement ENUM.
- On ne déclare pas deux fois la même valeur de code pour un champ.
- Le nom d'une valeur de code se lie à l'Edge Id d'ENUM par [BIND](0x0A3L-bind.md). Tout UTF8-TEXT attaché à DECLARE, FIELD, ENUM et CODEC passe par BIND, et non par un autre Edge comme LABEL.
- Une valeur de code non déclarée n'est pas une erreur. La visionneuse l'affiche telle quelle comme valeur brute. Fermer ou non les valeurs admises relève de la spécification du Codec, et le vocabulaire actuel n'a pas de marque de fermeture.

## Longueur {#길이}

```
total = 1 + N_len + N_id + N_field + n WORD
```

## Exemple (non normatif) {#예시-비규범}

On déclare le code `0x0001` pour le champ de catégorie de motif (FIELD #4, valeur brute 1 WORD) du document de spécification de TOMBSTONE. Edge Id 10. Le nom se lie à part par BIND. La table des codes de catégorie de motif n'est pas encore fixée, la valeur de code est donc un exemple.

- TAG 1 + Edge Id 2 + champ 2 + valeur de code 1 = 6 WORD, `LLLL = 0101`.

```
0BD5 0051 000A 0051 0004 0001
```

Le document de spécification de TRIPLE place trois ENUM (`0`·`1`·`2`) sur le champ Rank (FIELD #5) et les lie par BIND à `normal`·`preferred`·`deprecated` ([TRIPLE](0x0AAL-triple.md)).

## Pages liées {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [FIELD](0x0BCL-field.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [document de spécification de Codec](../codec-spec.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000BD0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
