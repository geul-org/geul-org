---
title: "ABSENT (0x000L)"
weight: 0
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "ABSENT est un marqueur d'emplacement qui signifie « non renseigné »."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ABSENT est un [marqueur d'emplacement](../slot-marker.md) qui signifie « non renseigné ». Il parle du document : cet emplacement n'a pas été rempli. Il n'affirme rien sur le monde.

| Élément | Valeur |
|---|---|
| Nom | `ABSENT` (BIND `ABSENT` du document de spécification) |
| TAG ID | `0x000L` |
| Codec ID | `0x00000000` |
| Document de spécification | `0x00000000/codecs/0x00000000/` (cible DECLARE `0000`) |
| Section | 0 `0000` (entité Reference), offset dans la section C = 0 |
| Kind | Reference · classification : marqueur d'emplacement |
| TAG WORD | `0000 0000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Non renseigné. Un champ facultatif a été omis. N'affirme rien sur le monde |
| Côté Hugo | `reference/slot-marker.md` |

## Disposition {#레이아웃}

```
TAG WORD          0000 0000 0000 0000      WORD 0x0000, 1 WORD
```

- Il n'y a pas de Payload. Il n'y a ni ID de cible ni Quantifier ([marqueur d'emplacement](../slot-marker.md#레이아웃)).
- Pour `0x000L`, une forme avec Payload (L ≥ 1) est Reserved.
- Notation textuelle de `geul show` et `geul add` : `ABSENT`.

## Sens {#뜻}

| Élément | Non renseigné |
|---|---|
| De quoi parle-t-il | **Le document** : cet emplacement n'a pas été rempli |
| Logique | N'affirme rien |
| Hypothèse sur le monde | Monde ouvert (aucune information) |
| Wikidata | Le snak correspondant n'existe pas |

## Acceptation {#수용}

- Seuls les champs dont la cible CODEC est `0000` l'acceptent. Ce champ est un **champ facultatif**. Pour omettre un champ facultatif, on écrit à sa place un seul WORD `0x0000`. Un champ facultatif occupe toujours son emplacement ([document de spécification de Codec](../codec-spec.md#선택-필드와-자리-표지)). Exemples : Origin de [SOURCE](../edge/0x0C0L-source.md), unité, borne inférieure et borne supérieure de [QUANTITY](../value/0x066L-quantity.md).
- Il ne peut pas être utilisé dans un joker, dans un champ sans CODEC, à la place d'un enregistrement HEAD ou BODY, à la place d'un Edge Id, ni dans un champ de valeur brute (règle commune des [marqueurs d'emplacement](../slot-marker.md#수용-규칙)).

## Obligations du lecteur {#읽는-쪽의-의무}

- **ABSENT n'affirme rien sur le monde.** On ne le lit ni comme UNKNOWN-VALUE ni comme NO-VALUE.
- Il est interdit qu'un convertisseur écrive en UNKNOWN-VALUE une valeur qu'il n'a pas pu transcrire (présente dans la source), car la source connaît la valeur. Pour un emplacement que la source n'a pas renseigné (par exemple l'Origin de [SOURCE](../edge/0x0C0L-source.md) pour une provenance que la source ne décrit pas), le convertisseur écrit aussi ABSENT.
- Dans le graphe de verdict, pour ABSENT et pour une absence d'énoncé, tous les opérateurs de comparaison sont indéterminés (U). Pour lire ABSENT comme empty, le côté entrée doit déclarer un monde fermé ([TOULMIN](../toulmin/_index.md#미상-위에서-판정하기)).

## Exemple {#예시}

`0x0000`, 1 WORD. Exemple : l'emplacement de l'unité d'un QUANTITY dont l'unité n'est pas renseignée.

## Document de Codec {#코덱-문서}

Le document de Codec ne comporte qu'un seul DECLARE (cible `0000`). Sans Payload, il n'y a pas de FIELD. Le décodeur intègre le sens du marqueur et ses règles d'acceptation ([couche 0](../publishing.md#층)). Pour lire le marqueur, on ne consulte pas le document de Codec.

## Pages liées {#관련-페이지}

- [marqueur d'emplacement](../slot-marker.md), [UNKNOWN-VALUE](0x001L-unknown-value.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [document de spécification de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000000/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000000000000000
BODY
#1 DECLARE 0x0000
#2 BIND #1 "ABSENT"
```
