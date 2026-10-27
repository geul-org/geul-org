---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD est un Edge de description (Codec 0x1C) qui déclare un champ du Payload d'un Codec. Il indique le DECLARE d'appartenance et la largeur (enregistrement, valeur brute de n WORD, reste en valeur brute)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD est un Edge de description qui déclare un champ du Payload d'un Codec. Codec `0x1C`.

Un FIELD désigne son [DECLARE](/fr/grammar/edge/declare/). Les FIELD qui désignent un même DECLARE composent le Payload dans l'ordre du document. Sa disposition est intégrée au décodeur ([Documents de spécification de Codec](/fr/grammar/codec-spec/)).

## Disposition

```
TAG WORD          0001 0LLL L001 1100
Edge Id           enregistrement Reference LOCAL
DECLARE           enregistrement Reference LOCAL. Edge DECLARE auquel ce champ appartient
Largeur           1 WORD. 0 = enregistrement, n (1~65534) = valeur brute de n WORD, 0xFFFF = reste en valeur brute
```

## Interprétation et validité

- DECLARE désigne un Edge DECLARE du même document. Un FIELD n'appartient qu'à un seul DECLARE. L'ordre n'est pas écrit à part : c'est l'ordre dans lequel les enregistrements FIELD figurent dans le document.
- Le document de spécification de FIELD déclare DECLARE comme un champ de largeur `0` (enregistrement), CODEC `0008` (LOCAL). Dans le graphe du visualiseur, il est donc dessiné comme un lien FIELD → DECLARE.
- Une largeur `0` est un champ d'enregistrement. Il commence par un TAG WORD et se lit sur la Length de ce TAG (règle d'interprétation de [DECLARE](/fr/grammar/edge/declare/)).
- Une largeur `n` (1~65534) est un champ en valeur brute. Toujours exactement n WORD.
- Une largeur `0xFFFF` est le reste en valeur brute. On n'en met qu'un par DECLARE, et il peut être au début, au milieu ou à la fin. Sa largeur est le nombre de WORD restants fixé par la Length du TAG de l'enregistrement englobant, moins les largeurs des champs suivants. Les champs qui suivent le reste doivent donc tous être des valeurs brutes de largeur fixe (il faut lire un enregistrement depuis le début pour en connaître la fin). Il peut faire 0 WORD. On n'y attache pas d'ENUM.
- Le Kind·Codec que reçoit un champ se désigne par [CODEC](/fr/grammar/edge/codec/). Un champ d'enregistrement sans CODEC reçoit n'importe quel enregistrement, et avec CODEC doit être l'un d'eux. Si l'on place un CODEC sur un champ en valeur brute, cette valeur brute est interprétée comme cette Value privée de son TAG.
- Le nom d'un champ se lie à l'Edge Id du FIELD par [BIND](/fr/grammar/edge/bind/) (par ex. `doc`, `hash`). Tout UTF8-TEXT attaché à DECLARE, FIELD, ENUM et CODEC passe par BIND, et non par un autre Edge comme LABEL.
- Le sens des valeurs de code d'un champ en valeur brute s'attache par [ENUM](/fr/grammar/edge/enum/).
- Un champ qui désigne un autre nœud du graphe n'est pas marqué à part. Si un champ d'enregistrement est une Reference, c'est le lien.

## Longueur

```
Total = 1 + 2 + 2 + 1 WORD   (quand Edge Id et DECLARE sont des LOCAL ID de 1 WORD)
```

## Exemple (non normatif)

- Champ d'enregistrement : Edge Id 7, DECLARE #1, largeur `0`. TAG 1 + Edge Id 2 + DECLARE 2 + largeur 1 = 6 WORD. Pour n'accepter que LOCAL, voir l'exemple de [CODEC](/fr/grammar/edge/codec/).

```
129C 0088 0007 0088 0001 0000
```

- Pour un champ en valeur brute comme un hachage du contenu, voir l'exemple de [DECLARE](/fr/grammar/edge/declare/).

## Pages liées

- [DECLARE](/fr/grammar/edge/declare/), [ENUM](/fr/grammar/edge/enum/), [CODEC](/fr/grammar/edge/codec/), [BIND](/fr/grammar/edge/bind/)
- [Documents de spécification de Codec](/fr/grammar/codec-spec/)
