---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD est un Edge d'énoncé qui déclare un champ du Payload d'un Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `FIELD` (BIND du document de spécification `FIELD`) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| Document de spécification | `0x00000000/codecs/0x00000BC0/` (cible de DECLARE `0BC0`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 28 |
| Kind | Edge · famille : énoncé, groupe : divers |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Un champ du Payload. DECLARE d'appartenance, largeur : enregistrement (Length du TAG) ou valeur brute de n WORD |
| Côté Hugo | `edge/field.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | enregistrement | `0050` LOCAL |  |
| 2 | `width` | #3 | valeur brute 1 WORD |  | `0x0000` record, `0xFFFF` rest |

FIELD est un Edge d'énoncé qui déclare un champ du Payload d'un Codec. Codec `0x0BCL`.

FIELD désigne son propre [DECLARE](0x0BBL-declare.md). Les FIELD qui désignent un même DECLARE composent le Payload dans l'ordre du document. La disposition est intégrée au décodeur ([document de spécification de Codec](../codec-spec.md)).

## Disposition {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           enregistrement Reference LOCAL
DECLARE           enregistrement Reference LOCAL. L'Edge DECLARE auquel appartient ce champ
largeur           1 WORD. 0 = enregistrement, n (1~65534) = valeur brute de n WORD, 0xFFFF = valeur brute restante
```

## Interprétation et validité {#해석과-유효성}

- DECLARE désigne un Edge DECLARE du même document. Un FIELD n'appartient qu'à un seul DECLARE. L'ordre n'est pas écrit à part : c'est l'ordre dans lequel les enregistrements FIELD sont placés dans le document.
- Le document de spécification de FIELD déclare DECLARE comme un champ de largeur `0` (enregistrement), CODEC `0050` (LOCAL). Dans le graphe de la visionneuse, il est donc dessiné comme un lien FIELD → DECLARE.
- La largeur `0` est un champ d'enregistrement. Il commence par un TAG WORD et se lit sur la Length de ce TAG (règles d'interprétation de [DECLARE](0x0BBL-declare.md)).
- La largeur `n` (1~65534) est un champ de valeur brute. Il fait toujours exactement n WORD.
- La largeur `0xFFFF` est la valeur brute restante. On n'en place qu'une par DECLARE, et elle peut être au début, au milieu ou à la fin. Sa largeur est celle des WORD restants, fixés par la Length du TAG de l'enregistrement englobant, moins la largeur des champs suivants. Tous les champs après le champ restant doivent donc être des valeurs brutes de largeur fixe (un enregistrement ne peut être lu que depuis le début pour connaître sa fin). Elle peut faire 0 WORD. On n'y attache pas d'ENUM.
- Le Kind et le Codec que le champ accepte se précisent par [CODEC](0x0BEL-codec.md). Un champ d'enregistrement sans CODEC accepte n'importe quel enregistrement ; avec CODEC, il doit être l'un d'eux. Si l'on place un CODEC sur un champ de valeur brute, on interprète cette valeur brute comme la Value privée de son TAG.
- Le nom d'un champ se lie à l'Edge Id du FIELD par [BIND](0x0A3L-bind.md) (par ex. `doc`, `hash`). Tout UTF8-TEXT attaché à DECLARE, FIELD, ENUM et CODEC passe par BIND, et non par un autre Edge comme LABEL.
- Le sens des valeurs de code d'un champ de valeur brute s'attache par [ENUM](0x0BDL-enum.md).
- Un champ qui désigne un autre nœud dans le graphe n'est pas indiqué à part. Si un champ d'enregistrement est une Reference, c'est le lien.

## Longueur {#길이}

```
total = 1 + 2 + 2 + 1 WORD   (quand l'Edge Id et DECLARE sont des ID de 1 WORD LOCAL)
```

## Exemple (non normatif) {#예시-비규범}

- Champ d'enregistrement : Edge Id 7, DECLARE #1, largeur `0`. TAG 1 + Edge Id 2 + DECLARE 2 + largeur 1 = 6 WORD. Pour n'accepter que LOCAL, voir l'exemple de [CODEC](0x0BEL-codec.md).

```
0BC5 0051 0007 0051 0001 0000
```

- Pour un champ de valeur brute comme le hachage du contenu, voir l'exemple de [DECLARE](0x0BBL-declare.md).

## Pages liées {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [document de spécification de Codec](../codec-spec.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000BC0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
