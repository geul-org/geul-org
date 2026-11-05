---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER est une Reference de désignation-déclaration qui désigne une version d'un document publié par un Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DOC-POINTER` (BIND `DOC-POINTER` du document de spécification) |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| Document de spécification | `0x00000000/codecs/0x00000410/` (cible DECLARE `0410`) |
| Section | 2 `0010` (Reference divers), offset dans la section C = 1 |
| Kind | Reference · classification : désignation-déclaration |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Côté Hugo | `reference/doc-pointer.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valeur brute restante (`0xFFFF`) |  |  |
| 2 | `doc` | #3 | valeur brute 4 WORD |  |  |
| 3 | `version` | #4 | valeur brute 2 WORD |  |  |

DOC-POINTER est une Reference de désignation-déclaration qui désigne une version d'un document publié par un Issuer. Il devient la cible de la publication, de la deprecation et de la suppression d'un document, de la version citée, et des énoncés portant sur le document.

## Disposition {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[TAG d'extension de Length]
Issuer            2/4/16 WORD
ID de document    4 WORD
ID de version     2 WORD
```

## Interprétation et validité {#해석과-유효성}

- La largeur de l'Issuer est ce qui reste du Payload une fois retirés les 6 WORD de l'ID de document et de l'ID de version. Le Codec ne la subdivise pas. Si la largeur n'est pas de 2, 4 ou 16 WORD, ou si la valeur de l'Issuer tient dans une largeur plus étroite, c'est invalid (forme canonique de l'Issuer).
- L'ID de version n'est pas omis. Si l'on autorisait l'omission, la longueur du Payload seule ne suffirait pas à déterminer la largeur de l'Issuer (Issuer de 4 WORD sans version et Issuer de 2 WORD avec version feraient tous deux 8 WORD).
- L'ID de version `0` est la version la plus récente. Il est lié à la version en vigueur au moment de l'interprétation. Les autres valeurs sont fixées à cette version ([PUBLICATION](../edge/0x0B8L-publication.md)).
- L'ID de document `0` est le document d'index des définitions de termes de l'Issuer. L'Issuer lui-même se désigne par [ISSUER-POINTER](0x040L-issuer-pointer.md).
- Tout Issuer réserve les ID de document `0x0000000000000000` et `0xFFFFFFFFFFFFFFFF` ([Issuer et publication](../issuer.md#용어-정의-문서)). `0xFFFFFFFFFFFFFFFF` sert à la liste des Issuer `issuers/` de l'Issuer `0x00000000`, et les autres Issuer ne l'emploient pas. PUBLICATION, DEPRECATION et TOMBSTONE de `issuers/versions.geul` désignent par cette valeur les versions de la liste ([adresse de publication et liste des versions](../publishing.md#목록-문서)).
- C'est une seule place de Codec, `0x041L`. Il n'y a pas de quantification (Identified).
- La forme qui désigne un document d'un Issuer est DOC-POINTER, et seulement lui. Désigner un document par `EXTERNAL-ISSUER-*` (Issuer, ID de document, ID de cible `0`) ou par `EXTERNAL-POINTER-*` (IMPORT ID, ID de cible `0`) est invalid.
- Emplois : Meta [DOC-ID](../meta/0x1C7L-doc-id.md) et [IMPORT-DOC](../meta/0x1E4L-import-doc.md), PUBLICATION, DEPRECATION et TOMBSTONE de la liste des versions.
- Un document de Codec n'a pas d'ID de document. Un document de Codec et ses versions se désignent par [CODEC-POINTER](0x042L-codec-pointer.md).

## Exemple {#예시}

Le document `0xFFFF000000000001` de l'Issuer GEUL `0x00000000`.

| Version | Séquence de WORD |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| la plus récente (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + ID de document 4 + ID de version 2 = 9 WORD, `LLLL=1000`. Le TAG est `0000 0100 0001 1000` = `0418`.

## Pages liées {#관련-페이지}

- [Reference](_index.md), [ISSUER-POINTER](0x040L-issuer-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer et publication](../issuer.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000410/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
