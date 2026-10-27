---
title: "Value — 時間"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TIME 系列(Codec `0x20`~`0x3F`、形式番号 `0x4000`~`0x7FFF`)の日付・時刻の形式: グレゴリオ暦の日付、タイムスタンプ、経過時間、EDTF、GEDCOM 日付。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TIME 系列は、日付と時刻の形式だ。直接コード `0x20`~`0x3F`、Issuer 形式番号 `0x4000`~`0x7FFF` に置く。

| 精度 | 形式 |
|---|---|
| 日付(グレゴリオ暦) | GREGORIAN-DATE |
| 年・月、不確実、区間 | EDTF |
| 他の暦の原表記(ユリウス暦など) | GEDCOM-DATE |
| 時刻 | POSIX・TAI・GPS タイムスタンプ |
| 経過時間 | DURATION-SECONDS、DURATION-NANOSECONDS |

- GREGORIAN-DATE で書ける日付は、EDTF で書かない。
- ナノ秒タイムスタンプと TAI・GPS 形式は、各標準団体の Issuer(IEEE、BIPM、GPS)の下の形式だ。
