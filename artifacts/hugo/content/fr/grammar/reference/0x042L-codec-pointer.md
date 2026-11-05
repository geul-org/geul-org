---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER est une Reference de désignation-déclaration qui désigne une version d'un document de Codec publié par un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER est une Reference de désignation-déclaration qui désigne une version d'un document de Codec publié par un Issuer. Un document de Codec n'a pas d'ID de document ; il se désigne lui-même, ainsi que sa version, par CODEC-POINTER.

| Élément | Valeur |
|---|---|
| Nom | `CODEC-POINTER` (BIND `CODEC-POINTER` du document de spécification) |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| Document de spécification | `0x00000000/codecs/0x00000420/` (cible DECLARE `0420`) |
| Section | 2 `0010` (Reference divers), offset dans la section C = 2 |
| Kind | Reference · classification : désignation-déclaration |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Une version d'un Codec d'Issuer. Issuer + Codec ID de 2 WORD + ID de version de 2 WORD, sans ID de cible |
| Côté Hugo | `reference/codec-pointer.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valeur brute restante (`0xFFFF`) |  |  |
| 2 | `codec` | #3 | valeur brute 2 WORD |  |  |
| 3 | `version` | #4 | valeur brute 2 WORD |  |  |

## Disposition {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[TAG d'extension de Length]
Issuer            2/4/16 WORD
Codec ID          2 WORD
ID de version     2 WORD
```

## Interprétation et validité {#해석과-유효성}

- La largeur de l'Issuer est ce qui reste du Payload une fois retirés les 4 WORD du Codec ID et de l'ID de version. Le Payload fait 6, 8 ou 20 WORD ; toute autre longueur est invalid. Si la valeur de l'Issuer tient dans une largeur plus étroite, c'est invalid (forme canonique de l'Issuer).
- Si l'Issuer fait 16 WORD, le total est de 21 WORD, d'où 1 WORD d'extension de Length.
- Le Codec ID fait 32 bits. Le Codec ID d'un code direct GEUL est la valeur de son TAG WORD (L=0) écrite sur 32 bits (TRIPLE `0x0AAL` → `0x00000AA0`). Le Codec ID d'un Codec d'Issuer est le numéro de Codec de l'enregistrement, que l'Issuer fixe sans chevauchement dans son propre `codecs/`, quel que soit le Kind ([adresse de publication et liste des versions](../publishing.md#id-표기)).
- L'ID de version `0` est la version la plus récente. Les autres valeurs sont fixées à cette version.
- C'est une seule place de Codec, `0x042L`. Il n'y a pas de quantification (Identified). Étant en section 2, on ne le lit pas selon la quantification ou le système.
- Emplois : Meta [DOC-ID](../meta/0x1C7L-doc-id.md) d'un document de Codec, [PUBLICATION](../edge/0x0B8L-publication.md), DEPRECATION et TOMBSTONE de la liste des versions d'un Codec, [IMPORT-DOC](../meta/0x1E4L-import-doc.md) qui importe un document de Codec. Il remplace DOC-POINTER à ces places.
- L'adresse de publication est `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<ID de version>.geul` ([adresse de publication et liste des versions](../publishing.md#공표-주소)).

## Exemple {#예시}

Le Codec TRIPLE (Codec ID `0x00000AA0`) de l'Issuer GEUL `0x00000000`.

| Version | Séquence de WORD |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| la plus récente (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + ID de version 2 = 7 WORD, `LLLL=0110`. Le TAG est `0000 0100 0010 0110` = `0426`.

## Pages liées {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [document de spécification de Codec](../codec-spec.md)
- [adresse de publication et liste des versions](../publishing.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000420/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
