---
title: "NO-VALUE (0x002L)"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "NO-VALUE est un marqueur d'emplacement qui signifie « aucune valeur »."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NO-VALUE est un [marqueur d'emplacement](../slot-marker.md) qui signifie « aucune valeur ». C'est une affirmation sur le monde : il n'y a pas de valeur.

| Élément | Valeur |
|---|---|
| Nom | `NO-VALUE` (BIND `NO-VALUE` du document de spécification) |
| TAG ID | `0x002L` |
| Codec ID | `0x00000020` |
| Document de spécification | `0x00000000/codecs/0x00000020/` (cible DECLARE `0020`) |
| Section | 0 `0000` (entité Reference), offset dans la section C = 2 |
| Kind | Reference · classification : marqueur d'emplacement |
| TAG WORD | `0000 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Aucune valeur. Il n'y a pas de valeur (Wikidata `novalue`) |
| Côté Hugo | `reference/slot-marker.md` |

## Disposition {#레이아웃}

```
TAG WORD          0000 0000 0010 0000      WORD 0x0020, 1 WORD
```

- Il n'y a pas de Payload. Il n'y a ni ID de cible ni Quantifier ([marqueur d'emplacement](../slot-marker.md#레이아웃)).
- Pour `0x002L`, une forme avec Payload (L ≥ 1) est Reserved.
- Notation textuelle de `geul show` et `geul add` : `NONE`.

## Sens {#뜻}

| Élément | Aucune valeur |
|---|---|
| De quoi parle-t-il | **Le monde** : il n'y a pas de valeur |
| Logique | `¬∃x. P(s, x)` |
| Hypothèse sur le monde | Monde fermé relativement à (s, P, conditions de qualification) |
| Wikidata | `novalue` |

## Acceptation {#수용}

- Seuls les champs dont la cible CODEC est `0020` l'acceptent. Ce champ reçoit l'affirmation « aucune valeur ». Exemples : Object de [TRIPLE](../edge/0x0AAL-triple.md), Value de [QUALIFIER](../edge/0x0ABL-qualifier.md).
- Il ne peut pas être utilisé dans un joker, dans un champ sans CODEC, à la place d'un enregistrement HEAD ou BODY, à la place d'un Edge Id, ni dans un champ de valeur brute (règle commune des [marqueurs d'emplacement](../slot-marker.md#수용-규칙)).

## Obligations du lecteur {#읽는-쪽의-의무}

- **NO-VALUE est fermé dans les conditions de qualification de cette proposition.** Si un QUALIFIER est attaché, il n'est fermé que dans cette portée. Q30 P1304 NO-VALUE(P580 1811, P582 1816) signifie qu'il n'y avait pas de banque centrale seulement de 1811 à 1816, ce qui ne contredit pas le TRIPLE de valeur de la même propriété (Réserve fédérale, preferred).
- Si, pour le même Subject et le même Predicate, un NO-VALUE et un TRIPLE de valeur coexistent avec le même rank sans que leurs conditions de qualification soient distinguées, il y a contradiction. Le vérificateur émet un avertissement. Il ne rejette pas. C'est un état qui existe aussi dans Wikidata, et le lecteur choisit par rank.
- **Le rank s'applique de la même façon.** Pour choisir la valeur représentative (truthy), un TRIPLE NO-VALUE est aussi candidat.
- **Utilisé comme valeur de QUALIFIER, il change le sens de cette qualification.** Avec `P582 = NONE`, on affirme que ce n'est pas terminé. Si le QUALIFIER P582 est tout simplement absent, on ne sait pas si c'est terminé.
- « Il n'y en a pas » ne peut se dire qu'en l'**écrivant** en NO-VALUE. L'absence d'un TRIPLE dans le document est un non-renseigné (monde ouvert).

## Exemple {#예시}

`0x0020`, 1 WORD. Exemple : « pas d'enfant (P40) » s'écrit `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000` (TRIPLE, l'emplacement Object vaut `0020`).

## Document de Codec {#코덱-문서}

Le document de Codec ne comporte qu'un seul DECLARE (cible `0020`). Sans Payload, il n'y a pas de FIELD. Le décodeur intègre le sens du marqueur et ses règles d'acceptation ([couche 0](../publishing.md#층)). Pour lire le marqueur, on ne consulte pas le document de Codec.

## Pages liées {#관련-페이지}

- [marqueur d'emplacement](../slot-marker.md), [ABSENT](0x000L-absent.md), [UNKNOWN-VALUE](0x001L-unknown-value.md)
- [CODEC](../edge/0x0BEL-codec.md), [document de spécification de Codec](../codec-spec.md), [TRIPLE](../edge/0x0AAL-triple.md), [QUALIFIER](../edge/0x0ABL-qualifier.md)

## Texte source du document de spécification {#규격-문서-원문}

Le document de spécification `0x00000000/codecs/0x00000020/latest.geul` tel que le lit `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000002000000000
BODY
#1 DECLARE 0x0020
#2 BIND #1 "NO-VALUE"
```
