---
title: "Value — טנסור"
weight: 70
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "טנסורים בפורמטי Issuer של משפחת NUMERIC (ADHOC ‏`0x0600`~`0x0601`): טנסורים dense ו-packed עם פורמט אלמנט, rank ו-shape."
author: "ג'ונו פארק"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

פורמטי טנסור הם פורמטי Issuer של משפחת NUMERIC. הם מוצבים ב-ADHOC (`0x0001`) במספרי פורמט `0x0600`~`0x0601`.

- DESCRIBED-DENSE-TENSOR מכיל פורמט אלמנט, rank, shape ו-payload dense מסוג C-contiguous.
- DESCRIBED-PACKED-TENSOR מכיל פורמט packed, rank, shape ו-payload packed מסוג low-bit-first בתוך octet.
