---
title: "Value — 数值"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "NUMERIC 系列（Codec `0x00`~`0x0F`）的基本数值格式：BOOL、整数、IEEE 754 浮点数、地球·天体坐标、带单位的 QUANTITY、保留写法的分数 FRACTION。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NUMERIC 系列的基本数值格式。放在直接码 `0x00`~`0x0F`（Codec 高 3 位 `000`）、Issuer 格式编号 `0x0000`~`0x1FFF` 中。

- 有 BOOL、有符号·无符号整数、IEEE 754 binary 浮点数、地球（WGS 84）·天体坐标、把数量·单位·边界合在一起的 QUANTITY、按原文写法原样的分数 FRACTION。
- 整数用能容纳该值的最小 WORD 书写。
- 小标量 Issuer 格式（BFLOAT16、FP8、FP4）只分配了格式编号，没有详细规格（[Value](/zh/grammar/value/#未决问题)未决问题）。
- 向量、张量、复数、既约分数（RATIONAL-I64）、区间也属于 NUMERIC 系列，但因为是 Issuer 格式，所以放在 [vector](/zh/grammar/value/vector/)、[tensor](/zh/grammar/value/tensor/)、[etc](/zh/grammar/value/etc/) 分组中。
