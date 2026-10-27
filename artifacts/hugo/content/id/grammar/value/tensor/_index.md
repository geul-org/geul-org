---
title: "Value — Tensor"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "Tensor format Issuer keluarga NUMERIC (ADHOC `0x0600`~`0x0601`): tensor dense·packed dengan format elemen·rank·shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Format tensor adalah format Issuer keluarga NUMERIC. Ditaruh pada nomor format `0x0600`~`0x0601` ADHOC (`0x0001`).

- DESCRIBED-DENSE-TENSOR memuat format elemen·rank·shape dan payload dense C-contiguous.
- DESCRIBED-PACKED-TENSOR memuat format packed·rank·shape dan payload packed low-bit-first dalam octet.
