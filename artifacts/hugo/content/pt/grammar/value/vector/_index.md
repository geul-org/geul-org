---
title: "Value — Vetor"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "Vetores como formatos Issuer da família NUMERIC (ADHOC `0x05xx`, KHRONOS): vetores densos de inteiros e reais, pontos de 2 e 3 dimensões, caixa delimitadora e pixels RGBA8 e BGRA8."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Os formatos de vetor são formatos Issuer da família NUMERIC. Os vetores densos de inteiros e reais, os pontos e a caixa delimitadora ficam no ADHOC (`0x0001`), com os números de formato `0x0500`~`0x050C`, e os formatos de pixel ficam sob o KHRONOS (`0x0041`).

- Os elementos de um vetor denso guardam-se de forma contígua em big-endian.
- Por serem formatos Issuer, a TAG estendida de Codec leva 2 WORD, do Issuer e do número de formato.
