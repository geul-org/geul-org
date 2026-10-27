---
title: "Value — 10進数"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "DECIMAL 系列(Codec `0x10`~`0x1F`、形式番号 `0x2000`~`0x3FFF`)の正確な10進数形式: SIGNED・UNSIGNED-DECIMAL と IEEE 754 decimal32/64/128。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECIMAL 系列は、正確な10進数の形式だ。直接コード `0x10`~`0x1F`(Codec 上位3ビット `001`)、Issuer 形式番号 `0x2000`~`0x3FFF` に置く。

- 直接コードの SIGNED-DECIMAL・UNSIGNED-DECIMAL は `C × 10^E` で書き、元の表記の桁数をそのまま収める。`1.20`(`C=120, E=−2`)と `1.2`(`C=12, E=−1`)は別のレコードだ。値の同値性と quantum の保存は、[SIGNED-DECIMAL](/ja/grammar/value/decimal/signed-decimal/#未解決の問題)の未解決の問題だ。
- IEEE 754 decimal32/64/128 の DPD・BID エンコードは、IEEE Issuer(`0x0040`)の形式だ。
