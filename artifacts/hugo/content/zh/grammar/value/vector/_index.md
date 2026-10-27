---
title: "Value — 向量"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "NUMERIC 系列 Issuer 格式（ADHOC `0x05xx`、KHRONOS）的向量：整数·实数稠密向量、二维·三维点、边界框、RGBA8·BGRA8 像素。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

向量格式是 NUMERIC 系列的 Issuer 格式。整数·实数稠密向量与点·边界框放在 ADHOC（`0x0001`）格式编号 `0x0500`~`0x050C` 中，像素格式放在 KHRONOS（`0x0041`）之下。

- 稠密向量的元素按 big-endian 连续存放。
- 因为是 Issuer 格式，Codec 扩展 TAG 中带有 Issuer 和格式编号 2 WORD。
