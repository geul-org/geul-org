---
title: "IEEE-DECIMAL128-BID"
weight: 1025
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL128-BIDは、IEEE 754 decimal128 BID interchange encoding を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL128-BIDは、IEEE 754 decimal128 BID interchange encoding を表す Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x0000000D` IEEE、Codec 番号 `0x00002005`、系列 DECIMAL である。BID のビットパターンをそのまま保存し、DPD と区別する。

## レイアウト {#레이아웃}

```
TAG WORD          0x09DC  全体 13 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec 番号        2 WORD  0x00002005
Payload           8 WORD (128ビット)  IEEE decimal128 BID Interchange
```

## 解釈 {#해석}

- 8つの Payload WORD を上位 WORD から連結した、IEEE 754 decimal128 BID interchange のビット列として読む。
- ビットパターンを保存し、DPD または exact decimal の形式として任意に再解釈しない。
- 特殊値や payload を任意に正規化しない。

## 有効性と長さ {#유효성과-길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 8 WORD を合わせた正確に13 WORD であり、直接長 `LLLL=1100` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に8 WORD でなければ拒否する。
- ビット列の意味上の有効性は IEEE BID interchange の規則に従う。

## 例 {#예시}

| 構造 | 判定 |
|---|---|
| `09DC 0000 000D 0000 2005` + 8 WORD BID ビット列 | 正規 |
| 全体が13 WORD(`LLLL=1100`)でない | invalid: 固定の Payload 幅と不一致 |

## 標準上の根拠 {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): decimal128 interchange format の binary coefficient encoding(BID)を適用する。IEEE が許容する DPD の代替へ数値変換せず、選んだ128ビットの encoding を保存し、GEUL の TAG と WORD の big-endian framing だけを加える。
