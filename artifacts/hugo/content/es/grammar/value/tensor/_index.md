---
title: "Value — tensor"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "Tensores como formatos de Issuer de la familia NUMERIC (ADHOC `0x0600`~`0x0601`): tensores dense y packed con formato de elemento, rank y shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Los formatos de tensor son formatos de Issuer de la familia NUMERIC. Se ubican en ADHOC (`0x0001`), con números de formato `0x0600` a `0x0601`.

- DESCRIBED-DENSE-TENSOR contiene el formato de elemento, el rank, el shape y un payload dense C-contiguous.
- DESCRIBED-PACKED-TENSOR contiene el formato packed, el rank, el shape y un payload packed low-bit-first dentro de cada octet.
