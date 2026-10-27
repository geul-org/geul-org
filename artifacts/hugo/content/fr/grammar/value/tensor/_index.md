---
title: "Value — Tenseurs"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "Tenseurs en formats d'Issuer de la famille NUMERIC (ADHOC `0x0600`~`0x0601`) : tenseurs dense et packed munis de format d'élément, rank et shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Les formats de tenseurs sont des formats d'Issuer de la famille NUMERIC. Ils se placent sous ADHOC (`0x0001`), numéros de format `0x0600`~`0x0601`.

- DESCRIBED-DENSE-TENSOR contient le format d'élément, le rank, le shape et un Payload dense C-contiguous.
- DESCRIBED-PACKED-TENSOR contient le format packed, le rank, le shape et un Payload packed low-bit-first dans l'octet.
