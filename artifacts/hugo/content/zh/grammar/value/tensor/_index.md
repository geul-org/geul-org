---
title: "Value — 张量"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "NUMERIC 系列 Issuer 格式（ADHOC `0x0600`~`0x0601`）的张量：附有元素格式·rank·shape 的 dense·packed 张量。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

张量格式是 NUMERIC 系列的 Issuer 格式。放在 ADHOC（`0x0001`）格式编号 `0x0600`~`0x0601` 中。

- DESCRIBED-DENSE-TENSOR 承载元素格式·rank·shape 和 C-contiguous dense payload。
- DESCRIBED-PACKED-TENSOR 承载 packed 格式·rank·shape 和 octet 内 low-bit-first packed payload。
