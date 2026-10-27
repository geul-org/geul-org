---
title: "Value — Nombres"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "Formats numériques de base de la famille NUMERIC (Codec `0x00`~`0x0F`) : BOOL, entiers, virgule flottante IEEE 754, coordonnées terrestres et célestes, QUANTITY avec unité et FRACTION, qui conserve sa notation."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Formats numériques de base de la famille NUMERIC. Ils se placent dans les codes directs `0x00`~`0x0F` (3 bits de poids fort du Codec `000`) et les numéros de format d'Issuer `0x0000`~`0x1FFF`.

- Il y a BOOL, les entiers signés et non signés, la virgule flottante binary IEEE 754, les coordonnées terrestres (WGS 84) et célestes, QUANTITY qui réunit quantité, unité et bornes, et FRACTION, la fraction telle qu'elle est écrite.
- Les entiers s'écrivent sur le nombre minimal de WORD qui contienne la valeur.
- Les formats d'Issuer de petits scalaires (BFLOAT16, FP8, FP4) n'ont que des numéros de format attribués et pas de spécification détaillée (problèmes ouverts de [Value](/fr/grammar/value/#problèmes-ouverts)).
- Les vecteurs, tenseurs, complexes, fractions irréductibles (RATIONAL-I64) et intervalles sont aussi de la famille NUMERIC, mais comme ce sont des formats d'Issuer, ils se trouvent dans les groupes [vector](/fr/grammar/value/vector/), [tensor](/fr/grammar/value/tensor/) et [etc](/fr/grammar/value/etc/).
