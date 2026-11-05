---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE est un Edge d'énoncé de non-identité : deux Reference désignent des referent différents."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DIFFERENT-NODE` (BIND du document de spécification `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| Document de spécification | `0x00000000/codecs/0x00000A20/` (cible de DECLARE `0A20`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 2 |
| Kind | Edge · famille : énoncé, groupe : désignation et nom |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Non-identité : deux Reference désignent des objets différents |
| Côté Hugo | `edge/different-node.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |
| 2 | `object` | #3 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |

DIFFERENT-NODE est un Edge d'énoncé de non-identité : deux Reference désignent des referent différents. Codec `0x0A2L`.

Cela ne signifie pas que l'encodage en octets, le Codec ou l'ID des deux enregistrements Reference sont différents. À distinguer de la liaison orientée de [REFERENCE-NODE](0x0A0L-reference-node.md) et de l'identité de [SAME-NODE](0x0A1L-same-node.md).

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 enregistrement Reference
```

## Interprétation et validité {#해석과-유효성}

- Subject et Object doivent chacun être exactement un enregistrement [Reference](../reference/_index.md) complet. Les limites se trouvent par la Length de chaque enregistrement ; s'il est une Value ou un Edge, ou incomplet, il est invalid.
- Subject et Object désignent des referent différents. On n'infère pas que les referent sont différents d'après la seule différence de suite d'octets, de Codec ou d'ID des enregistrements Reference.
- En particulier, des ID [LOCAL](../reference/0x005L-local.md) différents ne sont que des Reference différentes ; cela ne signifie pas que les referent réels sont différents. On ne tire pas DIFFERENT de la seule différence d'ID LOCAL.
- La non-identité est symétrique, irréflexive et non transitive. `DIFFERENT(A, B)` est la même relation que `DIFFERENT(B, A)`. En revanche, de `DIFFERENT(A, B)` et `DIFFERENT(B, C)`, on n'infère pas `DIFFERENT(A, C)`.
- L'ordre Subject/Object sur le wire n'est qu'un ordre de sérialisation pour le framing et ne crée pas de direction de sens. Une implémentation doit pouvoir parcourir la relation dans les deux sens.
- Le curseur, une fois les deux composants lus, doit coïncider exactement avec la fin de l'Edge.

La relation est irréflexive, mais on ne doit pas effacer comme erreur de grammaire du wire une affirmation `DIFFERENT(A, A)` structurellement valid, ni une affirmation où SAME et DIFFERENT s'opposent. De telles affirmations préservent leur contexte et leur lignée et sont traitées comme des contradictions dans la couche de verdict. Lorsqu'on interprète ou déduit DIFFERENT, on préserve l'origine, l'instant, le world et la portée de policy du document qui contient cet Edge, et l'on ne l'élargit pas à une conclusion globale qui les ignorerait.

## Longueur {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Exemple (non normatif) {#예시-비규범}

L'Edge Id est `000A`, Subject est LOCAL 1, Object est LOCAL 2.

- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. Le TAG est `0000 1010 0010 0110` = `0A26`.

```
0A26 0051 000A 0051 0001 0051 0002
```

La différence d'ID LOCAL dans cet exemple sert seulement à montrer l'encodage. On ne fait de cette séquence un DIFFERENT-NODE que lorsqu'il existe une affirmation distincte selon laquelle l'ID 1 et l'ID 2 désignent des referent différents.

## Pages liées {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000A20/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
