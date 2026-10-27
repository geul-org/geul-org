---
title: "Value — тензоры"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "Тензоры как форматы Issuer семейства NUMERIC (ADHOC `0x0600`–`0x0601`): плотные и упакованные тензоры с форматом элемента, rank и shape."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Тензорные форматы — это форматы Issuer семейства NUMERIC. Они размещены под ADHOC (`0x0001`) с номерами форматов `0x0600`–`0x0601`.

- DESCRIBED-DENSE-TENSOR содержит формат элемента, rank, shape и плотный C-contiguous Payload.
- DESCRIBED-PACKED-TENSOR содержит packed-формат, rank, shape и Payload, упакованный внутри octet по принципу low-bit-first.
