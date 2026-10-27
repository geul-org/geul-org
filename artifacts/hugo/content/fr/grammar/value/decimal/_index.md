---
title: "Value — Décimaux"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "Formats décimaux exacts de la famille DECIMAL (Codec `0x10`~`0x1F`, numéros de format `0x2000`~`0x3FFF`) : SIGNED et UNSIGNED-DECIMAL, et IEEE 754 decimal32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

La famille DECIMAL regroupe les formats décimaux exacts. Elle se place dans les codes directs `0x10`~`0x1F` (3 bits de poids fort du Codec `001`) et les numéros de format d'Issuer `0x2000`~`0x3FFF`.

- Les codes directs SIGNED-DECIMAL et UNSIGNED-DECIMAL s'écrivent `C × 10^E` et conservent tel quel le nombre de chiffres de la notation d'origine. `1.20` (`C=120, E=−2`) et `1.2` (`C=12, E=−1`) sont des enregistrements différents. L'égalité de valeur et la conservation du quantum sont un problème ouvert de [SIGNED-DECIMAL](/fr/grammar/value/decimal/signed-decimal/#problèmes-ouverts).
- Les encodages DPD et BID de IEEE 754 decimal32/64/128 sont des formats de l'Issuer IEEE (`0x0040`).
