---
title: "Value — Tensor"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "Tensoren als Issuer-Formate der NUMERIC-Familie (ADHOC `0x0600`~`0x0601`): dichte und gepackte Tensoren mit Elementformat, rank und shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Tensorformate sind Issuer-Formate der NUMERIC-Familie. Sie liegen bei den ADHOC-Formatnummern (`0x0001`) `0x0600`~`0x0601`.

- DESCRIBED-DENSE-TENSOR enthält Elementformat, rank, shape und einen C-contiguous dichten Payload.
- DESCRIBED-PACKED-TENSOR enthält packed-Format, rank, shape und einen innerhalb von Oktetten low-bit-first gepackten Payload.
