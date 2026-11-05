---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER est une Reference de désignation-déclaration qui désigne l'Issuer lui-même."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `ISSUER-POINTER` (BIND `ISSUER-POINTER` du document de spécification) |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| Document de spécification | `0x00000000/codecs/0x00000400/` (cible DECLARE `0400`) |
| Section | 2 `0010` (Reference divers), offset dans la section C = 0 |
| Kind | Reference · classification : désignation-déclaration |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Côté Hugo | `reference/issuer-pointer.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)).

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | valeur brute restante (`0xFFFF`) |  |  |

ISSUER-POINTER est une Reference de désignation-déclaration qui désigne l'Issuer lui-même. Il devient la cible du `BIND` du nom de l'Issuer, de `LABEL` et des Edge de verdict.

## Disposition {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[TAG d'extension de Length]
Issuer            2/4/16 WORD
```

- La largeur de l'Issuer est celle de tout le Payload. Le Codec ne la subdivise pas. Si la largeur n'est pas de 2, 4 ou 16 WORD, ou si la valeur de l'Issuer tient dans une largeur plus étroite, c'est invalid (forme canonique de l'Issuer).
- Si l'Issuer fait 16 WORD, le total est de 17 WORD, d'où 1 WORD d'extension de Length.
- C'est une seule place de Codec, `0x040L`. Il n'y a pas de quantification (Identified).
- La valeur de l'Issuer suit l'attribution décrite dans [Issuer](../issuer.md).
- Usages : Subject du BIND dans la liste des Issuer `issuers/` ([adresse de publication et liste des versions](../publishing.md#issuer-목록)), LABEL du nom d'affichage de l'Issuer, verdict sur un Issuer, signataire, et toute place où l'Issuer lui-même est la cible.
- La forme qui désigne l'Issuer lui-même est ISSUER-POINTER, et seulement lui. Désigner un Issuer par `EXTERNAL-ISSUER-*` avec l'ID de document `0` et l'ID de cible `0` est invalid.

## Exemple {#예시}

| Issuer | Séquence de WORD |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## Pages liées {#관련-페이지}

- [Reference](_index.md), [DOC-POINTER](0x041L-doc-pointer.md), [EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md), [Issuer et publication](../issuer.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000400/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
