---
title: "Value — Números"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "Formatos numéricos básicos da família NUMERIC (Codec `0x00`~`0x0F`): BOOL, inteiros, ponto flutuante IEEE 754, coordenadas da Terra e de corpos celestes, QUANTITY com unidade e FRACTION, a fração que preserva a notação."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

São os formatos numéricos básicos da família NUMERIC. Ficam nos códigos diretos `0x00`~`0x0F` (3 bits superiores do Codec `000`) e nos números de formato Issuer `0x0000`~`0x1FFF`.

- Há BOOL, inteiros com e sem sinal, ponto flutuante binary IEEE 754, coordenadas da Terra (WGS 84) e de corpos celestes, QUANTITY, que reúne quantidade, unidade e limites, e FRACTION, a fração tal como escrita no original.
- Os inteiros são escritos no mínimo de WORDs em que o valor cabe.
- Os formatos Issuer de escalares pequenos (BFLOAT16, FP8, FP4) só têm número de formato atribuído e não têm especificação detalhada (questões em aberto de [Value](/pt/grammar/value/#questões-em-aberto)).
- Vetores, tensores, números complexos, frações irredutíveis (RATIONAL-I64) e intervalos também são da família NUMERIC, mas, por serem formatos Issuer, ficam nos conjuntos [vector](/pt/grammar/value/vector/), [tensor](/pt/grammar/value/tensor/) e [etc](/pt/grammar/value/etc/).
