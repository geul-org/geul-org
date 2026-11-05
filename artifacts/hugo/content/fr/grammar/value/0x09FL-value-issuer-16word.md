---
title: "VALUE-ISSUER-16WORD (0x09FL)"
weight: 159
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-16WORD est un format de Value défini par un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-16WORD est un format de Value défini par un Issuer. C'est l'une des trois dernières cases de la zone Value, avec une largeur d'Issuer de 16 WORD. La disposition ISSUER est la même pour les trois Kind ([Enregistrement et TAG WORD](../record.md#issuer-형식-레코드)).

| Élément | Valeur |
|---|---|
| Nom | `VALUE-ISSUER-16WORD` (BIND `VALUE-ISSUER-16WORD` du document de spécification) |
| TAG ID | `0x09FL` |
| Codec ID | `0x000009F0` |
| Document de spécification | `0x00000000/codecs/0x000009F0/` (cible de DECLARE `09F0`) |
| Section | 4 `0100` (Value), décalage dans la section C = 31 |
| Kind | Value · classification : format d'Issuer |
| TAG WORD | `0000 1001 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Description de l'index | Issuer 16 WORD et numéro de Codec 2 WORD. Le format est fixé par le document de Codec de l'Issuer |
| Côté Hugo | `value/_index.md` |

## Disposition {#레이아웃}

```
TAG WORD          0000 1001 1111 LLLL      Codec 0x09FL
[TAG d'extension Length]
Issuer            16 WORD
Numéro de Codec   2 WORD. Défini par l'Issuer
Payload           Fixé par le document de Codec publié par l'Issuer
```

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([Document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format reçu (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valeur brute de 16 WORD |  |  |
| 2 | `codec` | #3 | valeur brute de 2 WORD |  |  |
| 3 | `payload` | #4 | reste de valeur brute (`0xFFFF`) |  |  |

La composition de `payload` est fixée par le document de Codec de cet Issuer.

## Interprétation et validité {#해석과-유효성}

- GEUL ne connaît que la frontière du Payload grâce à Length. Un décodeur qui ne connaît pas le format connaît le Kind, la Length, l'Issuer et le numéro de Codec, et saute le reste grâce à Length.
- L'interprétation du Payload est fixée par le document de Codec de l'Issuer. Les Value de format d'Issuer actuellement enregistrés figurent dans l'[index des Codec](../codec-index.md#value-issuer-형식).
- L'Issuer s'écrit avec la largeur la plus courte dans laquelle la valeur tient ([Issuer et publication](../issuer.md#issuer-등급)). Si les 12 WORD de poids fort de la valeur de l'Issuer sont à 0, c'est invalid. Cette valeur s'écrit avec un code de largeur plus étroite.
- Le numéro de Codec fait 2 WORD. L'Issuer l'attribue sans chevauchement à l'intérieur de son propre `codecs/`, quel que soit le Kind. S'il manque de numéros, on fait émettre un Issuer de plus.
- Le document de Codec se place sous `<Issuer>/codecs/<numéro de Codec>/` de cet Issuer ([Adresse de publication et liste des versions](../publishing.md#id-표기)).
- La licence d'un format d'Issuer est fixée par cet Issuer ([Issuer et publication](../issuer.md#라이선스)).

## Pages liées {#관련-페이지}

- [Value — format d'Issuer](_index.md#issuer-형식), [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md), [VALUE-ISSUER-4WORD](0x09EL-value-issuer-4word.md)
- [Enregistrement et TAG WORD](../record.md#issuer-형식-레코드), [Issuer et publication](../issuer.md)

## Texte original du document de spécification {#규격-문서-원문}

Aspect du document de spécification `0x00000000/codecs/0x000009F0/latest.geul` lu avec `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009F000000000
BODY
#1 DECLARE 0x09F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
