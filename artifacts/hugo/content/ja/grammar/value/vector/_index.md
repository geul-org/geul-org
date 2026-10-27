---
title: "Value — ベクトル"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "NUMERIC 系列の Issuer 形式(ADHOC `0x05xx`、KHRONOS)のベクトル: 整数・実数の密ベクトル、2・3次元の点、バウンディングボックス、RGBA8・BGRA8 ピクセル。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ベクトル形式は、NUMERIC 系列の Issuer 形式だ。整数・実数の密ベクトルと点・バウンディングボックスは ADHOC(`0x0001`)の形式番号 `0x0500`~`0x050C`、ピクセル形式は KHRONOS(`0x0041`)の下に置く。

- 密ベクトルの要素は、big-endian で連続して保存する。
- Issuer 形式なので、Codec 拡張 TAG に Issuer と形式番号の 2 WORD が付く。
