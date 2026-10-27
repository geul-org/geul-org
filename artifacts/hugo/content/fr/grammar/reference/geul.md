---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL est une Reference de déclaration qui désigne une cible par un ID d'entité émis en CC0 par geul.org."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL est une Reference de déclaration qui désigne une entité émise en CC0 par geul.org. C'est un ID séquentiel dont le numéro ne porte pas de sens. L'identifiant dont les bits portent du sens relève d'un Codec distinct, [GEUL-SIDX](/fr/grammar/reference/geul-sidx/) (`0011`).

## Disposition

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[TAG d'extension de Length]
GEUL ID           unsigned big-endian sur la largeur la plus courte
```

- Les petits numéros sont attribués aux entités très fréquentes. Un ID qui tient dans 1 WORD fait 2 WORD au total.
- L'attribution des ID et le registre sont gérés par geul.org. On ne met dans le registre que ce qui provient de sources CC0.
- Si c'est Variable, c'est une variable anonyme de cette espèce ([Reference](/fr/grammar/reference/), Variable).

## Exemple

| GEUL ID | Suite de WORD |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## Problèmes ouverts

- Règle d'attribution des GEUL ID et format de publication du registre.

## Pages liées

- [Reference](/fr/grammar/reference/), [GEUL-SIDX](/fr/grammar/reference/geul-sidx/)
