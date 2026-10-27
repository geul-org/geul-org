---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 est un format d'Issuer ADHOC fixe de 11 WORD qui contient un intervalle fermé fini et non vide par des bornes inférieure et supérieure binary64."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 est une Value qui représente un intervalle fermé par deux endpoint IEEE 754 binary64 dans l'ordre `(lower, upper)`. C'est une Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, numéro de format `0x0703`, famille NUMERIC.

## Disposition

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD au total
Issuer            1 WORD  0x0001 (ADHOC)
Numéro de format  1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interprétation et validité

- Les deux endpoint sont des binary64 en ordre big-endian des WORD et incluent les deux extrémités.
- Le motif de bits du zéro signé d'un endpoint valide est conservé tel quel. Il n'y a pas de remplissage ABI.
- Le Payload fait exactement 8 WORD et l'on doit avoir `lower ≤ upper`.
- Un NaN n'étant pas comparable, on le rejette. Un endpoint infini donne un intervalle non borné, donc on le rejette aussi.
- Les intervalles vides, non bornés, ouverts et NaI ne peuvent pas s'exprimer avec ce format et sont rejetés.

## Fondement normatif et statut du format

- Le format numérique des endpoint suit [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), et le sens de paire d'endpoint fermée se réfère au modèle d'intervalle d'[IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) et de sa simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Ce format est un profil GEUL simple qui n'admet que les intervalles fermés finis et non vides. Il n'implémente ni ne sérialise tel quel les decorations, NaI, intervalles vides ou non bornés, ni le modèle complet d'opérations et d'interchange d'IEEE 1788/1788.1.

## Longueur

- Le total est exactement de 11 WORD, soit le TAG de 1 WORD, l'Issuer de 1 WORD, le numéro de format de 1 WORD et le Payload de 8 WORD, avec la longueur directe `LLLL=1010`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni remplissage.
- Si le Payload n'est pas exactement de 8 WORD, on rejette.

## Exemple

- Les endpoint `(1.0, 2.0)` donnent `[1.0, 2.0]`, valide. `(2.0, 1.0)` et `(NaN, 1.0)` sont invalid.
