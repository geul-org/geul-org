---
title: "Value — Tensor"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "Tensores como formatos Issuer da família NUMERIC (ADHOC `0x0600`~`0x0601`): tensores dense e packed com formato do elemento, rank e shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Os formatos de tensor são formatos Issuer da família NUMERIC. Ficam no ADHOC (`0x0001`), nos números de formato `0x0600`~`0x0601`.

- DESCRIBED-DENSE-TENSOR contém o formato do elemento, o rank, o shape e um payload dense C-contiguous.
- DESCRIBED-PACKED-TENSOR contém o formato packed, o rank, o shape e um payload packed low-bit-first dentro do octeto.
