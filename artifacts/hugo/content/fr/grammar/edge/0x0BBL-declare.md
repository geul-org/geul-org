---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE est un Edge d'énoncé qui déclare la composition du Payload d'un Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Élément | Valeur |
|---|---|
| Nom | `DECLARE` (BIND du document de spécification `DECLARE`) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| Document de spécification | `0x00000000/codecs/0x00000BB0/` (cible de DECLARE `0BB0`) |
| Section | 5 `0101` (Edge d'énoncé), offset dans la section C = 27 |
| Kind | Edge · famille : énoncé, groupe : divers |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Description d'index | Déclaration de la composition du Payload d'un Codec. Kind et Codec cibles |
| Côté Hugo | `edge/declare.md` |

## Champs (document de spécification) {#필드-규격-문서}

L'ordre des FIELD dans le document est l'ordre des champs du Payload ([document de spécification de Codec](../codec-spec.md)). L'Edge Id d'un Edge n'est pas déclaré par FIELD.

| Ordre | Champ (BIND) | FIELD | Largeur | Format accepté (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | valeur brute 1 WORD |  |  |
| 2 | `issuer` | #3 | valeur brute restante (`0xFFFF`) |  |  |

DECLARE est un Edge d'énoncé qui déclare la composition du Payload d'un Codec. Codec `0x0BBL`.

Avec [FIELD](0x0BCL-field.md) (`0x0BCL`), [ENUM](0x0BDL-enum.md) (`0x0BDL`) et [CODEC](0x0BEL-codec.md) (`0x0BEL`), c'est le vocabulaire pour écrire une spécification de Codec ([document de spécification de Codec](../codec-spec.md)). La disposition de ces quatre Edge est intégrée au décodeur. Chaque document de spécification de Codec écrit avec ce vocabulaire est un document ordinaire. Une seule spécification sert à la fois à la validation, à la décomposition et à l'affichage (visionneuse). La visionneuse n'a pas de code par Codec : elle dessine d'après la spécification.

## Disposition {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
cible             1 WORD. N'utilise que l'emplacement du Codec (section et C) du TAG WORD du Codec déclaré (LLLL = 0)
[Issuer·n° codec] Quand on déclare un codec d'Issuer. 2 WORD : Issuer et numéro de codec. Même disposition que le TAG d'extension de Codec, les trois Kind étant identiques
                  La spécification du code ISSUER lui-même (Issuer GEUL) ne contient que la cible
```

- La liste des champs ne figure pas dans DECLARE. Chaque [FIELD](0x0BCL-field.md) désigne son DECLARE, et l'ordre de ces FIELD dans le document est l'ordre des champs du Payload.

## Règles d'interprétation {#해석-규칙}

Règles pour lire et noter un enregistrement d'après la spécification d'un Codec.

- Un champ de valeur brute se lit sur le nombre fixe de WORD que FIELD a déclaré. Un champ peut être une valeur brute restante (largeur `0xFFFF`) ; on lit alors les WORD restants moins la largeur des champs fixes qui suivent. Après le champ restant, on ne place que des valeurs brutes de largeur fixe.
- Un champ d'enregistrement commence par un TAG WORD et se lit sur la Length de ce TAG.
- Un champ de valeur brute est un entier non signé big-endian de n WORD. La notation est `0x` + largeur×4 chiffres hexadécimaux, et s'il existe un ENUM de la même valeur, on note aussi son nom BIND.
- Le sens d'un champ d'enregistrement est fixé par la spécification du Codec de cet enregistrement. Une valeur qui demande une interprétation, comme le signe, la décimale ou la date, se place non en valeur brute mais en enregistrement Value.

Il n'y a pas d'autre règle de limite. On ne peut pas déclarer avec ce vocabulaire un Codec qui a deux valeurs brutes variables ou plus, ou dont un enregistrement ou un champ variable suit une valeur brute variable, ou dont la largeur d'une valeur brute dépend de la valeur d'un autre champ ou de l'état du document. Une telle disposition enveloppe la partie variable dans un enregistrement pour n'en laisser qu'une (par ex. le signataire de SIGNATURE est un enregistrement Reference).

## Validité {#유효성}

- Le Kind de la cible est l'un de Reference, Value, Edge, Meta. Le document de spécification d'un code direct GEUL est unique pour chaque code. Le système 5Q de Reference est lui aussi déclaré séparément pour chaque code de quantification (LOCAL Identified `0050`, Generic `0060`, …). Les pointeurs (`0x040L`, `0x041L`, `0x042L`), les marqueurs d'emplacement et le code ISSUER sont eux aussi ce code même. Un codec d'Issuer, fixé par l'Issuer et le numéro de codec qui suivent le code ISSUER, est défini par le document de cet Issuer.
- Un [marqueur d'emplacement](../slot-marker.md) (Reference `0x000L~0x002L`) est aussi une cible de DECLARE. Comme il n'a pas de Payload, on ne place que DECLARE, sans FIELD. Le sens et la règle d'acceptation du marqueur sont intégrés au décodeur (couche 0). Un Codec dont la disposition n'est pas encore fixée (SUPERSEDE-CHAIN, VERDICT, EVIDENCE, etc.) ne reçoit lui aussi que DECLARE.
- L'Edge Id d'un Edge n'est pas déclaré par FIELD. Premier élément de tous les Edge, il est implicite ([Edge](_index.md)). Pour EDGE-ISSUER, c'est le premier élément après l'Issuer et le numéro de codec ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- Les champs d'un DECLARE sont les FIELD qui le désignent, et il peut y en avoir 0. Un FIELD n'appartient qu'à un seul DECLARE. Même pour des champs de même forme, on place un FIELD distinct pour chaque DECLARE.
- DECLARE ne contient rien d'autre que la cible (et, pour une cible au format Issuer, l'Issuer et le numéro de codec).
- Le curseur, une fois les champs lus dans l'ordre, doit coïncider exactement avec la fin de l'enregistrement. Un reste ou un manque est une violation de la spécification.
- Dans un document, on ne déclare pas deux fois la même cible.
- On n'utilise pas en branchement des variantes dont les champs de queue diffèrent. On place un DECLARE distinct pour chaque Codec.

## Document de spécification {#규격-문서}

- Le document de spécification d'un code direct est un document de codec de l'Issuer GEUL `0x00000000`. Le Codec ID est la valeur du TAG WORD cible (L=0) écrite sur 32 bits (`0x0B80` → `0x00000B80`), publiée sous `<Issuer>/codecs/<Codec ID>/` avec ID de version et `versions.geul` ([document de spécification de Codec](../codec-spec.md)).
- Le document de codec d'un codec d'Issuer se place sous `<Issuer>/codecs/<numéro de codec>/` de cet Issuer. Le numéro de codec n'est pas dupliqué dans cet Issuer, quel que soit le Kind. L'interpréteur considère comme une erreur le cas où le Kind de l'enregistrement diffère du Kind de la cible de DECLARE ([adresse de publication et liste des versions](../publishing.md#id-표기)).
- Un document de spécification n'a qu'un DECLARE, et sa cible doit être égale au TAG WORD du Codec ID. Le `DOC-ID` est un [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, ce Codec ID, `0`).

## Nom {#이름}

- Le nom d'un Codec se lie à l'Edge Id de DECLARE par [BIND](0x0A3L-bind.md) (par ex. `PUBLICATION`). Tout UTF8-TEXT attaché à DECLARE, FIELD, ENUM et CODEC passe par BIND, et non par un autre Edge comme LABEL.
- Le nom d'un champ et le nom d'un enum se lient de la même façon à FIELD et à ENUM.

## Exemple {#예시}

Document de spécification `0x00000000/codecs/0x00000B80/` de PUBLICATION (Edge `0x0B8L`) : après l'Edge Id, un enregistrement DOC-POINTER, puis un hachage du contenu de 16 WORD.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, enregistrement (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (liste des versions d'un codec)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, valeur brute 16 WORD   (BIND "hash")
```

- DECLARE : TAG 1 + Edge Id 2 + cible 1 = 4 WORD, `LLLL = 0011`.
- FIELD : TAG 1 + Edge Id 2 + DECLARE 2 + largeur 1 = 6 WORD (`LLLL = 0101`). Les Kind et Codec acceptés se placent à part par [CODEC](0x0BEL-codec.md) (`0410` = DOC-POINTER, `0420` = CODEC-POINTER).
- Un champ facultatif se déclare avec la cible CODEC `0000`. À la place omise, on écrit ABSENT (`0x0000`) ([CODEC](0x0BEL-codec.md), champ facultatif).
- L'ordre des champs est l'ordre dans lequel FIELD #2 et #4 sont placés dans le document. Les Edge Id n'ont pas à être consécutifs (LOCAL AUTO INCREMENT est une recommandation).

## Problèmes ouverts {#열린-문제}

- Répétition. Une composition où une valeur brute précédente fixe le nombre, comme « arguments × nombre d'arguments » de `CALL`. Pour l'instant, on ne peut pas la déclarer.
- Comment déclarer un Codec ayant des sous-formats (TAG propre au Codec), comme WORLD.
- Quel lot de versions des documents de spécification de codes directs `SPEC-VERSION` désigne.

## Pages liées {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Edge](_index.md), [document de spécification de Codec](../codec-spec.md)

## Texte source du document de spécification {#규격-문서-원문}

Voici le document de spécification `0x00000000/codecs/0x00000BB0/latest.geul` tel que lu par `geul show` (hexadécimal en majuscules).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
