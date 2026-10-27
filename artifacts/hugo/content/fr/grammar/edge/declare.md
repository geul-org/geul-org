---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE est un Edge de description (Codec 0x1B) qui déclare la composition du Payload d'un Codec. Avec FIELD, ENUM et CODEC, c'est le vocabulaire pour écrire les documents de spécification de Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE est un Edge de description qui déclare la composition du Payload d'un Codec. Codec `0x1B`.

Avec [FIELD](/fr/grammar/edge/field/) (`0x1C`), [ENUM](/fr/grammar/edge/enum/) (`0x1D`) et [CODEC](/fr/grammar/edge/codec/) (`0x1E`), c'est le vocabulaire pour écrire les spécifications de Codec ([Documents de spécification de Codec](/fr/grammar/codec-spec/)). La disposition de ces quatre Edge est intégrée au décodeur. Chaque document de spécification de Codec écrit avec ce vocabulaire est un document ordinaire. Une seule spécification sert à valider, décomposer et afficher (visualiseur). Le visualiseur ne contient pas de code par Codec, il dessine selon la spécification.

## Disposition

```
TAG WORD          0001 0LLL L001 1011
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Cible             1 WORD. Seuls les emplacements Kind·Codec du TAG WORD du Codec déclaré (LLLL = 0)
[Issuer·numéro de format] quand la cible est un format d'Issuer. Même disposition que le TAG d'extension de Codec
```

- La liste des champs ne se place pas dans DECLARE. Chaque [FIELD](/fr/grammar/edge/field/) désigne son DECLARE, et l'ordre dans le document de ces FIELD est l'ordre des champs du Payload.

## Règles d'interprétation

Ce sont les règles pour lire et noter un enregistrement avec la spécification de Codec.

- Un champ en valeur brute se lit sur le nombre fixe de WORD que déclare le FIELD. Un champ peut être le reste en valeur brute (largeur `0xFFFF`) : on lit alors les WORD restants moins les largeurs des champs fixes qui suivent. Après le reste, on ne place que des valeurs brutes de largeur fixe.
- Un champ d'enregistrement commence par un TAG WORD et se lit sur la Length de ce TAG.
- Un champ en valeur brute est un entier non signé big-endian de n WORD. La notation est `0x` + largeur×4 chiffres hex, et s'il existe un ENUM de même valeur, on note aussi son nom BIND.
- Le sens d'un champ d'enregistrement est fixé par la spécification de Codec de cet enregistrement. Les valeurs qui demandent interprétation (signe, décimales, dates) ne sont pas des valeurs brutes mais des enregistrements Value.

Il n'y a pas d'autre règle de limite. On ne peut pas déclarer avec ce vocabulaire un Codec qui a plus d'une valeur brute variable, qui place un enregistrement ou un champ variable après une valeur brute variable, ou dont la largeur d'une valeur brute dépend de la valeur d'un autre champ ou de l'état du document. Une telle disposition enveloppe la partie variable dans un enregistrement pour n'en garder qu'une (par ex. le signataire de SIGNATURE est un enregistrement Reference).

## Validité

- Le Kind de la cible est l'un de Reference, Value, Edge, Meta. Le Codec de Reference occupe l'emplacement `CCCC` et le Quantifier est laissé à 0.
- Les [marqueurs d'emplacement](/fr/grammar/reference/slot-marker/) (Codec de Reference `0000`) ne peuvent pas être la cible d'un DECLARE. Ils sont intégrés au décodeur (couche 0).
- L'Edge Id d'un Edge ne se déclare pas par FIELD. Premier élément de tout Edge, il est implicite ([Edge](/fr/grammar/edge/)).
- Les champs d'un DECLARE sont les FIELD qui le désignent, il peut y en avoir 0. Un FIELD n'appartient qu'à un seul DECLARE. Même pour des champs de même forme, on place des FIELD distincts par DECLARE.
- DECLARE ne contient que la cible (et, pour une cible de format d'Issuer, l'Issuer et le numéro de format).
- Le curseur après lecture successive des champs doit coïncider exactement avec la fin de l'enregistrement. S'il reste ou manque quelque chose, cet enregistrement viole la spécification.
- On ne déclare pas deux fois la même cible dans un document.
- Les variantes à champs de queue différents ne s'emploient pas comme branches. On place un DECLARE distinct par Codec.

## Document de spécification

- Le document de spécification d'un code direct est un document ordinaire de l'Issuer GEUL `0x0000`. L'ID de document est le TAG WORD cible étendu à 4 WORD (`0x1018` → `0x0000000000001018`), et il est publié de la même manière que les documents des autres Issuer (ID de version, `versions.geul`) ([Documents de spécification de Codec](/fr/grammar/codec-spec/)).
- Un document de spécification ne contient qu'un DECLARE, dont la cible doit être égale au TAG WORD de l'ID de document. Son `DOC-ID` est un DOC-POINTER (`0x0000`, l'ID de ce document, `0`).

## Nom

- Le nom d'un Codec se lie à l'Edge Id du DECLARE par [BIND](/fr/grammar/edge/bind/) (par ex. `PUBLICATION`). Tout UTF8-TEXT attaché à DECLARE, FIELD, ENUM et CODEC passe par BIND, et non par un autre Edge comme LABEL.
- Les noms de champs et d'enum se lient de la même manière à FIELD et ENUM.

## Exemple

Document de spécification de PUBLICATION (Edge `0x18`) `geul.org/publication` : après l'Edge Id, un enregistrement DOC-POINTER, puis un hachage du contenu de 16 WORD.

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, enregistrement (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, valeur brute de 16 WORD   (BIND "hash")
```

- DECLARE : TAG 1 + Edge Id 2 + cible 1 = 4 WORD, `LLLL = 0011`.
- FIELD : TAG 1 + Edge Id 2 + DECLARE 2 + largeur 1 = 6 WORD (`LLLL = 0101`). Le Kind·Codec admis se place à part par [CODEC](/fr/grammar/edge/codec/) (`0038` = DOC-POINTER).
- Un champ facultatif se déclare par la cible CODEC `0000`. À la place omise, on écrit ABSENT (`0x0000`) (champ facultatif de [CODEC](/fr/grammar/edge/codec/)).
- L'ordre des champs est l'ordre dans lequel FIELD #2 et #4 figurent dans le document. Les Edge Id n'ont pas à se suivre (l'AUTO INCREMENT des LOCAL est une recommandation).

## Problèmes ouverts

- Répétition. Composition où une valeur brute précédente fixe le nombre, comme « argument × nombre d'arguments » de `CALL`. Impossible à déclarer pour l'instant.
- Comment déclarer un Codec ayant des sous-formats (TAG propres au Codec), comme WORLD.
- Comment trouver le document de spécification d'un format d'Issuer (Issuer·numéro de format → adresse du document de spécification).
- À quel lot de versions des documents de spécification des codes directs correspond `SPEC-VERSION`.

## Pages liées

- [FIELD](/fr/grammar/edge/field/), [ENUM](/fr/grammar/edge/enum/), [CODEC](/fr/grammar/edge/codec/), [BIND](/fr/grammar/edge/bind/)
- [Edge](/fr/grammar/edge/), [Documents de spécification de Codec](/fr/grammar/codec-spec/)
