---
title: "Value — テンソル"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "NUMERIC 系列の Issuer 形式(ADHOC `0x0600`~`0x0601`)のテンソル: 要素形式・rank・shape を付けた dense・packed テンソル。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

テンソル形式は、NUMERIC 系列の Issuer 形式だ。ADHOC(`0x0001`)の形式番号 `0x0600`~`0x0601` に置く。

- DESCRIBED-DENSE-TENSOR は、要素形式・rank・shape と C-contiguous の dense payload を収める。
- DESCRIBED-PACKED-TENSOR は、packed 形式・rank・shape と octet 内 low-bit-first の packed payload を収める。
