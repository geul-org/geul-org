---
title: "Value — 时间"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TIME 系列（Codec `0x20`~`0x3F`，格式编号 `0x4000`~`0x7FFF`）的日期·时刻格式：格里高利历日期、时间戳、经过时间、EDTF、GEDCOM 日期。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TIME 系列是日期和时刻格式。放在直接码 `0x20`~`0x3F`、Issuer 格式编号 `0x4000`~`0x7FFF` 中。

| 精度 | 格式 |
|---|---|
| 日期（格里高利历） | GREGORIAN-DATE |
| 年·月、不确定、区间 | EDTF |
| 其他历法的原始写法（儒略历等） | GEDCOM-DATE |
| 时刻 | POSIX·TAI·GPS 时间戳 |
| 经过时间 | DURATION-SECONDS、DURATION-NANOSECONDS |

- 能用 GREGORIAN-DATE 表示的日期，不用 EDTF 书写。
- 纳秒时间戳以及 TAI·GPS 格式，是各标准组织 Issuer（IEEE、BIPM、GPS）之下的格式。
