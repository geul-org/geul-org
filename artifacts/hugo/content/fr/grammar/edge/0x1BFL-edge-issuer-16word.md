---
title: "EDGE-ISSUER-16WORD (0x1BFL)"
weight: 447
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-16WORD est un format d'Edge défini par un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-16WORD est un format d'Edge défini par un Issuer. C'est l'une des trois dernières cases de la zone Edge, et la largeur de l'Issuer est de 16 WORD. La disposition ISSUER est la même pour les trois Kind ([Enregistrement et TAG WORD](../record.md#issuer-형식-레코드)).

| Rubrique | Valeur |
|---|---|
| Nom | `EDGE-ISSUER-16WORD` (document de spécification BIND `EDGE-ISSUER-16WORD`) |
| TAG ID | `0x1BFL` |
| Codec ID | `0x00001BF0` |
| Document de spécification | `0x00000000/codecs/0x00001BF0/` (cible DECLARE `1BF0`) |
| Section | 13 `1101` (Edge (3 dernières cases ISSUER)), décalage dans la section C = 31 |
| Kind | Edge · classification : format Issuer |
| TAG WORD | `0001 1011 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Issuer 16 WORD et numéro de Codec 2 WORD. Le format est fixé par le document de Codec de l'Issuer |
| Côté Hugo | `edge/_index.md` |

## Disposition {#레이아웃}

```
TAG WORD          0001 1011 1111 LLLL      Codec 0x1BFL
[TAG d'extension Length]
Issuer            16 WORD
Numéro de Codec   2 WORD. Défini par l'Issuer
Edge Id           enregistrement LOCAL Reference. Premier élément après l'Issuer et le numéro de Codec
Reste du Payload  Fixé par le document de Codec publié par l'Issuer
```

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par un FIELD. L'Edge Id d'EDGE-ISSUER vient après le numéro de Codec, avant le champ `payload` ([disposition](#레이아웃)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valeur brute 16 WORD |  |  |
| 2 | `codec` | #3 | valeur brute 2 WORD |  |  |
| 3 | `payload` | #4 | reste en valeur brute (`0xFFFF`) |  |  |

La composition de `payload` est fixée par le document de Codec de cet Issuer.

## Interprétation et validité {#해석과-유효성}

- GEUL ne connaît par Length que la limite du Payload. Un décodeur qui ignore le format connaît Kind, Length, Issuer et numéro de Codec, et saute par Length.
- Le Payload commence par l'Edge Id (LOCAL Reference) ([Edge](_index.md#레이아웃)). Les composants après l'Edge Id sont fixés par le document de Codec de l'Issuer.
- L'Issuer s'écrit avec la largeur la plus courte qui contient la valeur ([Issuer et publication](../issuer.md#issuer-등급)). Si les 12 WORD de poids fort de la valeur d'Issuer sont 0, c'est invalid. Cette valeur s'écrit avec un code de largeur plus étroite.
- Le numéro de Codec fait 2 WORD. L'Issuer l'attribue sans chevauchement dans son propre `codecs/`, quel que soit le Kind. Si les numéros manquent, on se fait délivrer un Issuer de plus.
- Le document de Codec se place sous `<Issuer>/codecs/<numéro de Codec>/` de cet Issuer ([adresse de publication et liste des versions](../publishing.md#id-표기)).
- La licence d'un format Issuer est fixée par cet Issuer ([Issuer et publication](../issuer.md#라이선스)).

## Pages liées {#관련-페이지}

- [Edge — Edge de format Issuer](_index.md#issuer-형식-edge), [EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md), [EDGE-ISSUER-4WORD](0x1BEL-edge-issuer-4word.md)
- [Enregistrement et TAG WORD](../record.md#issuer-형식-레코드), [Issuer et publication](../issuer.md)

## Texte original du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00001BF0/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BF000000000
BODY
#1 DECLARE 0x1BF0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
