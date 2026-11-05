---
title: "UNKNOWN-VALUE (0x001L)"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "UNKNOWN-VALUE est un marqueur d'emplacement qui signifie « inconnu »."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNKNOWN-VALUE est un [marqueur d'emplacement](../slot-marker.md) qui signifie « inconnu ». C'est une affirmation sur le monde : une valeur existe, mais on ne sait pas laquelle.

| Élément | Valeur |
|---|---|
| Nom | `UNKNOWN-VALUE` (BIND `UNKNOWN-VALUE` du document de spécification) |
| TAG ID | `0x001L` |
| Codec ID | `0x00000010` |
| Document de spécification | `0x00000000/codecs/0x00000010/` (cible DECLARE `0010`) |
| Section | 0 `0000` (entité Reference), offset dans la section C = 1 |
| Kind | Reference · classification : marqueur d'emplacement |
| TAG WORD | `0000 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Inconnu. Une valeur existe, mais on ne sait pas laquelle (Wikidata `somevalue`) |
| Côté Hugo | `reference/slot-marker.md` |

## Disposition {#레이아웃}

```
TAG WORD          0000 0000 0001 0000      WORD 0x0010, 1 WORD
```

- Il n'y a pas de Payload. Il n'y a ni ID de cible ni Quantifier ([marqueur d'emplacement](../slot-marker.md#레이아웃)).
- Pour `0x001L`, une forme avec Payload (L ≥ 1) est Reserved.
- Notation textuelle de `geul show` et `geul add` : `UNKNOWN`.

## Sens {#뜻}

| Élément | Inconnu |
|---|---|
| De quoi parle-t-il | **Le monde** : une valeur existe. On ne sait pas laquelle |
| Logique | `∃x. P(s, x)`, x n'est pas identifié |
| Hypothèse sur le monde | Existence fermée, identité ouverte |
| Wikidata | `somevalue` |

## Acceptation {#수용}

- Seuls les champs dont la cible CODEC est `0010` l'acceptent. Ce champ reçoit l'affirmation « inconnu ». Exemples : Object de [TRIPLE](../edge/0x0AAL-triple.md), Value de [QUALIFIER](../edge/0x0ABL-qualifier.md), Origin de [SOURCE](../edge/0x0C0L-source.md).
- Il ne peut pas être utilisé dans un joker, dans un champ sans CODEC, à la place d'un enregistrement HEAD ou BODY, à la place d'un Edge Id, ni dans un champ de valeur brute (règle commune des [marqueurs d'emplacement](../slot-marker.md#수용-규칙)).

## Obligations du lecteur {#읽는-쪽의-의무}

- **UNKNOWN-VALUE n'est pas une valeur mais une affirmation d'existence.** Il n'est égal à aucune autre valeur et n'en diffère pas non plus (résultat de comparaison indéterminé). Deux UNKNOWN-VALUE ne sont pas non plus considérés comme la même valeur. Chaque occurrence est une quantification existentielle indépendante (comme un nœud vide de Wikidata).
- Ainsi, deux TRIPLE identiques octet pour octet (`P40 Q… UNKNOWN` ×2) ne sont pas des doublons. Il peut y avoir deux enfants, ou un seul. Un TRIPLE contenant UNKNOWN-VALUE n'est pas fusionné comme doublon.
- Si l'identité est établie plus tard, on publie une nouvelle version corrigée de ce TRIPLE. UNKNOWN-VALUE ne peut pas être désigné. Pour une coréférence, on utilise un LOCAL Variable (Variable de [Reference](_index.md#quantifier)).
- **Le rank s'applique de la même façon.** Pour choisir la valeur représentative (truthy), un TRIPLE UNKNOWN-VALUE est aussi candidat.
- **Utilisé comme valeur de QUALIFIER, il change le sens de cette qualification.** Avec `P582 = UNKNOWN`, c'est terminé et l'on ignore la date. On ne le lit pas comme une proposition encore valide.
- UNKNOWN-VALUE est une affirmation d'existence ; on ne l'utilise donc que lorsque la source le dit. On n'écrit pas en UNKNOWN-VALUE une valeur qu'on n'a pas pu transcrire.

## Exemple {#예시}

`0x0010`, 1 WORD. Exemple : on ignore la date de fin (P582) de la frontière Q30–Q34266 : `0AB7 0051 0C58 0191 0246 0051 080C 0010` (QUALIFIER, l'emplacement Value vaut `0010`).

## Document de Codec {#코덱-문서}

Le document de Codec ne comporte qu'un seul DECLARE (cible `0010`). Sans Payload, il n'y a pas de FIELD. Le décodeur intègre le sens du marqueur et ses règles d'acceptation ([couche 0](../publishing.md#층)). Pour lire le marqueur, on ne consulte pas le document de Codec.

## Pages liées {#관련-페이지}

- [marqueur d'emplacement](../slot-marker.md), [ABSENT](0x000L-absent.md), [NO-VALUE](0x002L-no-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [document de spécification de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000010/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000001000000000
BODY
#1 DECLARE 0x0010
#2 BIND #1 "UNKNOWN-VALUE"
```
