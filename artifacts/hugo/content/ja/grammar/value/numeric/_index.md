---
title: "Value — 数"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "NUMERIC 系列(Codec `0x00`~`0x0F`)の基本的な数の形式: BOOL、整数、IEEE 754 浮動小数点、地球・天体の座標、単位付きの QUANTITY。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NUMERIC 系列の基本的な数の形式だ。直接コード `0x00`~`0x0F`(Codec 上位3ビット `000`)、Issuer 形式番号 `0x0000`~`0x1FFF` に置く。

- BOOL、符号付き・符号なしの整数、IEEE 754 binary 浮動小数点、地球(WGS 84)・天体の座標、量・単位・境界を束ねた QUANTITY がある。
- 整数は、値が収まる最小の WORD で書く。
- 小さなスカラーの Issuer 形式(BFLOAT16、FP8、FP4)は、形式番号だけが割り当てられていて、詳細規格がない([Value](/ja/grammar/value/#未解決の問題)の未解決の問題)。
- ベクトル、テンソル、複素数、分数、区間も NUMERIC 系列だが、Issuer 形式なので [vector](/ja/grammar/value/vector/)、[tensor](/ja/grammar/value/tensor/)、[etc](/ja/grammar/value/etc/) のまとまりに置く。
