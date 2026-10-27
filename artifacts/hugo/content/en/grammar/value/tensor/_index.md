---
title: "Value — Tensor"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "Tensors among the NUMERIC-family Issuer formats (ADHOC `0x0600`-`0x0601`): dense and packed tensors with element format, rank, and shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The tensor formats are NUMERIC-family Issuer formats. They are placed in ADHOC (`0x0001`) format numbers `0x0600`-`0x0601`.

- DESCRIBED-DENSE-TENSOR holds the element format, rank, shape, and a C-contiguous dense payload.
- DESCRIBED-PACKED-TENSOR holds the packed format, rank, shape, and a low-bit-first packed payload within each octet.
