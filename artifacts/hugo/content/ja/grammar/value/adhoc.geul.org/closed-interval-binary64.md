---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64は、(lower, upper) の順に並ぶ IEEE 754 binary64 の2つの endpoint で閉区間を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64は、`(lower, upper)` の順に並ぶ IEEE 754 binary64 の2つの endpoint で閉区間を表す Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000703`、系列 NUMERIC である。

## レイアウト {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  全体 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## 解釈と有効性 {#해석과-유효성}

- 2つの endpoint は big-endian WORD 順の binary64 であり、両端を含む。
- 有効な endpoint の signed zero の bit pattern はそのまま保存する。ABI padding はない。
- Payload は正確に8 WORD であり、`lower ≤ upper` でなければならない。
- NaN は比較できないので拒否する。infinity の endpoint も unbounded な区間になるので拒否する。
- empty、unbounded、open interval および NaI はこの形式で表現できないので拒否する。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- endpoint の数値形式は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従い、閉じた endpoint pair という意味は [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) と simplified flavor である [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734) の interval モデルを参考にする。
- この形式は、有限で空でない閉区間だけを許す単純な GEUL profile である。decorations、NaI、empty/unbounded interval、および IEEE 1788/1788.1 の全演算・interchange モデルは実装せず、そのままシリアライズもしない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 8 WORD を合わせた正確に13 WORD であり、直接長 `LLLL=1100` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に8 WORD でなければ拒否する。

## 例 {#예시}

- endpoint `(1.0, 2.0)` は `[1.0, 2.0]` であり有効である。`(2.0, 1.0)` と `(NaN, 1.0)` は invalid である。
