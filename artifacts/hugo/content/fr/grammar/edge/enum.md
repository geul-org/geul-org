---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM est un Edge de description (Codec 0x1D) qui donne un sens à une valeur de code d'un champ en valeur brute. Les noms se lient par BIND."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM est un Edge de description qui donne un sens à une valeur de code d'un champ en valeur brute. Codec `0x1D`.

Avec [FIELD](/fr/grammar/edge/field/), c'est le vocabulaire pour écrire les spécifications de Codec. Sa disposition est intégrée au décodeur ([Documents de spécification de Codec](/fr/grammar/codec-spec/)).

## Disposition

```
TAG WORD          0001 0LLL L001 1101
[TAG d'extension de Length]
Edge Id           enregistrement Reference LOCAL
Champ             enregistrement Reference LOCAL désignant un Edge FIELD
Valeur de code    valeur brute. Autant de WORD que la largeur de ce FIELD
```

## Interprétation et validité

- Le champ doit être un FIELD en valeur brute (largeur `n ≥ 1`). On n'attache pas d'ENUM à un champ d'enregistrement. Le sens d'un enregistrement est dit par le Codec de cet enregistrement.
- La valeur de code a exactement la largeur du FIELD. On vérifie les limites par la Length de l'enregistrement ENUM.
- On ne déclare pas deux fois la même valeur de code pour un champ.
- Le nom d'une valeur de code se lie à l'Edge Id de l'ENUM par [BIND](/fr/grammar/edge/bind/). Tout UTF8-TEXT attaché à DECLARE, FIELD, ENUM et CODEC passe par BIND, et non par un autre Edge comme LABEL.
- Une valeur de code non déclarée n'est pas une erreur. Le visualiseur l'affiche telle quelle en valeur brute. Fermer ou non les valeurs admises relève de la spécification du Codec, et le vocabulaire actuel n'a pas de marque de fermeture.

## Longueur

```
Total = 1 + N_len + N_id + N_field + n WORD
```

## Exemple (non normatif)

On déclare le code `0x0001` pour le champ de catégorie de motif (FIELD #4, valeur brute de 1 WORD) du document de spécification de TOMBSTONE. Edge Id 10. Le nom se lie séparément par BIND. La table des codes de catégorie de motif n'étant pas encore fixée, la valeur de code est un exemple.

- TAG 1 + Edge Id 2 + champ 2 + valeur de code 1 = 6 WORD, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

Le document de spécification de TRIPLE place trois ENUM (`0`, `1`, `2`) sur le champ Rank (FIELD #5) et les lie par BIND à `normal`, `preferred`, `deprecated` ([TRIPLE](/fr/grammar/edge/triple/)).

## Pages liées

- [DECLARE](/fr/grammar/edge/declare/), [FIELD](/fr/grammar/edge/field/), [CODEC](/fr/grammar/edge/codec/), [BIND](/fr/grammar/edge/bind/)
- [Documents de spécification de Codec](/fr/grammar/codec-spec/)
