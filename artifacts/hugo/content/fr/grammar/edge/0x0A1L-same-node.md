---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE est un Edge d'énoncé d'identité, sans orientation, qui déclare que deux Reference désignent le même referent."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `SAME-NODE` (BIND du document de spécification `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| Document de spécification | `0x00000000/codecs/0x00000A10/` (cible de DECLARE `0A10`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 1 |
| Kind | Edge · famille : énoncé, groupe : désignation et nom |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Identité : deux Reference désignent le même objet |
| Côté Hugo | `edge/same-node.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |
| 2 | `object` | #3 | enregistrement | tout enregistrement (marqueurs d'emplacement exclus) |  |

SAME-NODE est un Edge d'énoncé d'identité, sans orientation, qui déclare que deux Reference désignent le même referent. Codec `0x0A1L`.

Cela ne signifie pas que l'encodage en octets, le Codec ou l'ID des deux enregistrements Reference sont identiques. Alors que [REFERENCE-NODE](0x0A0L-reference-node.md) est une liaison orientée `Reference → enregistrement`, SAME-NODE exprime l'identité (referential identity) entre deux Reference.

## Disposition {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Subject           1 enregistrement Reference
Object            1 enregistrement Reference
```

## Interprétation et validité {#해석과-유효성}

- Subject et Object se sérialisent dans cet ordre, et chacun doit être exactement un enregistrement [Reference](../reference/_index.md) complet. Les limites se trouvent par la Length de chaque enregistrement.
- Si Subject ou Object est une Value, un Edge ou un enregistrement incomplet, c'est invalid.
- La relation SAME-NODE est réflexive, symétrique et transitive. L'ordre Subject/Object sur le wire sert au framing et ne crée pas de direction de sens. Une implémentation doit pouvoir parcourir cette relation dans les deux sens.
- Des ID [LOCAL](../reference/0x005L-local.md) différents ne sont que des Reference différentes ; ce n'est pas une preuve que les referent sont identiques ou différents. Que deux Reference désignent le même referent s'établit par SAME-NODE.
- L'interprétation et l'inférence doivent préserver l'origine, l'instant, le world et la portée de policy du document qui contient cet Edge et du graphe de verdict. On n'utilise pas SAME-NODE comme fondement d'une fusion globale indépendante du contexte.
- La présence de SAME-NODE n'efface ni n'écrase les enregistrements Reference d'origine ni leur lignée.
- Qu'un même couple ait à la fois SAME-NODE et [DIFFERENT-NODE](0x0A2L-different-node.md) ne rend pas le wire invalid. On préserve le contexte de chaque affirmation et on l'évalue comme un conflit.
- On résout une variable en reliant une Reference Variable à une Reference Identified par SAME-NODE (Variable de [Reference](../reference/_index.md)).

## Longueur {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Exemple (non normatif) {#예시-비규범}

L'Edge Id est `0009`, Subject est LOCAL 1, Object est LOCAL 2.

- L'Edge fait TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. Le TAG est `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## Pages liées {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000A10/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
