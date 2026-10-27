---
title: "Value — 텐서"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "NUMERIC 계열 Issuer 형식(ADHOC `0x0600`~`0x0601`)의 텐서: 원소 형식·rank·shape를 붙인 dense·packed 텐서."
author: "박준우"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

텐서 형식은 NUMERIC 계열의 Issuer 형식이다. ADHOC(`0x0001`) 형식 번호 `0x0600`~`0x0601`에 둔다.

- DESCRIBED-DENSE-TENSOR는 원소 형식·rank·shape와 C-contiguous dense payload를 담는다.
- DESCRIBED-PACKED-TENSOR는 packed 형식·rank·shape와 octet 안 low-bit-first packed payload를 담는다.
