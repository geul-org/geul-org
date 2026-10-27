---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX est une Reference de déclaration qui désigne une cible par un GEUL SIDX (Semantic-aligned Index), dont les bits mêmes portent du sens."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-SIDX est une Reference de déclaration qui désigne une cible par un GEUL SIDX (Semantic-aligned Index). Le SIDX est un identifiant dont les bits mêmes portent du sens (genre, attributs).

## Disposition

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[TAG d'extension de Length]
SIDX              tout le reste
```

- Le Quantifier est le même que pour les autres Codec de déclaration. Si c'est Variable, c'est une variable anonyme de cette espèce ([Reference](/fr/grammar/reference/), Variable). La quantification ne passe que par `QQQ`. On ne met pas de quantification dans la valeur du SIDX.
- Le document de spécification déclare le SIDX comme un seul champ en valeur brute de largeur « reste ». On le changera quand la règle de largeur sera fixée.

## Exemple

| SIDX | Suite de WORD |
|---|---|
| (non normatif) 64 bits `0x1234 5678 9abc def0`, Identified | `0218 1234 5678 9abc def0` |

## Politique d'attribution

- Son rôle diffère de [GEUL](/fr/grammar/reference/geul/). GEUL est un ID d'identité attribué en gros dans l'ordre (auto increment), tandis que GEUL-SIDX est une adresse sémantique qui donne des valeurs proches aux cibles de sens proche.
- Le degré de proximité se fixe par des statistiques accumulées sur les données d'usage. Avant que les statistiques soient réunies, on emploie les ID GEUL ; après attribution d'un SIDX, on relie par [SAME-NODE](/fr/grammar/edge/same-node/) le GEUL et le GEUL-SIDX de la même cible.

## Problèmes ouverts

- **Largeur.** À fixer d'après les statistiques. On étudie 4 WORD (64 bits), 16 WORD, etc. Le SIDX portant du sens dans ses bits de poids fort, on ne peut pas reprendre telle quelle la règle de la « largeur la plus courte » des autres Codec de déclaration (interdiction du WORD `0x0000` de tête). Ce sera donc une largeur fixe (ou fixe par sous-format). D'ici là, le document de spécification déclare le SIDX comme valeur brute de largeur « reste ».
- **Stabilité de l'attribution.** Dans Reference, une même valeur entière est la même cible et un ID attribué n'est pas réutilisé. Pour ne pas déplacer un SIDX déjà attribué quand les statistiques changent, il faut une attribution en ajout seul (attribution clairsemée qui laisse des places proches en sens). Si les déplacements sont fréquents, on décidera s'il faut définir le SIDX non comme un identifiant permanent mais comme un index lié à une édition du registre.
- **Unicité.** Si le SIDX est généré à partir du sens de ses bits, des collisions peuvent survenir, ce qui n'est pas compatible avec la prémisse « même valeur entière, même cible ». À l'attribution, on résout les collisions pour garantir l'unicité.
- Livre de codes et format de publication du registre.

## Pages liées

- [Reference](/fr/grammar/reference/), [GEUL](/fr/grammar/reference/geul/)
