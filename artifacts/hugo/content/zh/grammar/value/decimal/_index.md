---
title: "Value — 十进制数"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "DECIMAL 系列（Codec `0x10`~`0x1F`，格式编号 `0x2000`~`0x3FFF`）的精确十进制数格式：SIGNED·UNSIGNED-DECIMAL 与 IEEE 754 decimal32/64/128。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECIMAL 系列是精确的十进制数格式。放在直接码 `0x10`~`0x1F`（Codec 高 3 位 `001`）、Issuer 格式编号 `0x2000`~`0x3FFF` 中。

- 直接码 SIGNED-DECIMAL·UNSIGNED-DECIMAL 写成 `C × 10^E`，并原样保留原来写法的位数。`1.20`（`C=120, E=−2`）与 `1.2`（`C=12, E=−1`）是不同的记录。值等价性与 quantum 保留是 [SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/#未决问题)的未决问题。
- IEEE 754 decimal32/64/128 的 DPD·BID 编码是 IEEE Issuer（`0x0040`）的格式。
