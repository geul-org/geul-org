---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 est une Value qui représente un intervalle fermé par deux endpoints IEEE 754 binary64, dans l'ordre (lower, upper)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---


CLOSED-INTERVAL-BINARY64 est une Value qui représente un intervalle fermé par deux endpoints IEEE 754 binary64, dans l'ordre `(lower, upper)`. Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, numéro de Codec `0x00000703`, famille NUMERIC.

## Disposition {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD au total
Issuer            2 WORD  0x00000002 (ADHOC)
Numéro de Codec   2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interprétation et validité {#해석과-유효성}

- Les deux endpoints sont des binary64 en ordre de WORD big-endian, et les deux bornes sont incluses.
- Le bit pattern du signed zero d'un endpoint valide est conservé tel quel. Il n'y a pas de padding ABI.
- Le Payload fait exactement 8 WORD et `lower ≤ upper` doit être vrai.
- NaN n'étant pas comparable, il est rejeté. Un endpoint infini est aussi rejeté, car l'intervalle serait non borné.
- Les intervalles vides, non bornés, ouverts et NaI ne peuvent pas être représentés par ce format et sont rejetés.

## Référence normative et statut du format {#표준-근거와-형식-지위}

- Le format numérique des endpoints suit [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), et le sens de paire d'endpoints fermés s'inspire du modèle d'intervalle d'[IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) et de son flavor simplifié [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Ce format est un profil GEUL simple qui n'admet que les intervalles fermés finis et non vides. Il n'implémente ni ne sérialise tel quel les decorations, NaI, les intervalles vides ou non bornés, ni le modèle complet d'opérations et d'interchange d'IEEE 1788/1788.1.

## Length {#길이}

- Le total est de 13 WORD exactement : TAG 1 WORD, Issuer 2 WORD, numéro de Codec 2 WORD et Payload 8 WORD ; on utilise la longueur directe `LLLL=1100`. Il n'y a ni TAG d'extension de Length, ni descriptor, ni padding.
- Si le Payload ne fait pas exactement 8 WORD, on rejette.

## Exemple {#예시}

- Les endpoints `(1.0, 2.0)` donnent `[1.0, 2.0]`, valide. `(2.0, 1.0)` et `(NaN, 1.0)` sont invalid.
