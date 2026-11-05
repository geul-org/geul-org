---
title: "REFERENCE-ISSUER-16WORD (0x05FL)"
weight: 95
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-16WORD est un format de Reference défini par l'Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-16WORD est un format de Reference défini par l'Issuer. C'est l'une des trois dernières places de la zone Reference, avec un Issuer de 16 WORD. La disposition ISSUER est la même pour les trois Kind ([enregistrement et TAG WORD](../record.md#issuer-형식-레코드)).

| Élément | Valeur |
|---|---|
| Nom | `REFERENCE-ISSUER-16WORD` (BIND `REFERENCE-ISSUER-16WORD` du document de spécification) |
| TAG ID | `0x05FL` |
| Codec ID | `0x000005F0` |
| Document de spécification | `0x00000000/codecs/0x000005F0/` (cible DECLARE `05F0`) |
| Section | 2 `0010` (Reference divers), offset dans la section C = 31 |
| Kind | Reference · classification : format d'Issuer |
| TAG WORD | `0000 0101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Issuer de 16 WORD et numéro de Codec de 2 WORD. Le format est fixé par le document de Codec de l'Issuer |
| Côté Hugo | `reference/reference-issuer.md` |

## Disposition {#레이아웃}

```
TAG WORD          0000 0101 1111 LLLL      Codec 0x05FL
[TAG d'extension de Length]
Issuer            16 WORD
Numéro de Codec   2 WORD. Défini par l'Issuer
Payload           Fixé par le document de Codec publié par l'Issuer
```

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valeur brute 16 WORD |  |  |
| 2 | `codec` | #3 | valeur brute 2 WORD |  |  |
| 3 | `payload` | #4 | valeur brute restante (`0xFFFF`) |  |  |

La composition de `payload` est fixée par le document de Codec de cet Issuer.

## Interprétation et validité {#해석과-유효성}

- GEUL ne connaît que la frontière du Payload, donnée par Length. Un décodeur qui ne connaît pas le format lit jusqu'au Kind, à Length, à l'Issuer et au numéro de Codec, puis saute selon Length.
- Le sens du numéro de Codec, la quantification et ce qui est désigné sont fixés par le document de Codec publié par l'Issuer. Les règles communes des Reference, comme la largeur minimale de l'ID de cible ou la lecture de la quantification, ne s'appliquent pas ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- L'Issuer s'écrit sur la plus courte largeur où la valeur tient ([Issuer et publication](../issuer.md#issuer-등급)). Si les 12 WORD de poids fort de la valeur de l'Issuer valent 0, c'est invalid. Cette valeur s'écrit avec le code d'une largeur plus étroite.
- Le numéro de Codec fait 2 WORD. L'Issuer l'attribue sans chevauchement dans son propre `codecs/`, quel que soit le Kind. S'il manque de numéros, on se fait émettre un Issuer supplémentaire.
- Le document de Codec se place sous `<Issuer>/codecs/<numéro de Codec>/` de cet Issuer ([adresse de publication et liste des versions](../publishing.md#id-표기)).
- La licence d'un format d'Issuer est fixée par cet Issuer ([Issuer et publication](../issuer.md#라이선스)).

## Pages liées {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)
- [enregistrement et TAG WORD](../record.md#issuer-형식-레코드), [Issuer et publication](../issuer.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x000005F0/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005F000000000
BODY
#1 DECLARE 0x05F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
