---
title: "IEEE-DECIMAL32-BID"
weight: 1027
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-BIDは、IEEE 754 decimal32 BID interchange encoding を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-BIDは、IEEE 754 decimal32 BID interchange encoding を表す Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x0000000D` IEEE、Codec 番号 `0x00002003`、系列 DECIMAL である。BID のビットパターンをそのまま保存し、DPD と区別する。

## レイアウト {#레이아웃}

```
TAG WORD          0x09D6  全体 7 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec 番号        2 WORD  0x00002003
Payload           2 WORD (32ビット)  IEEE decimal32 BID Interchange
```

## 解釈 {#해석}

- 2つの Payload WORD を上位 WORD から連結した、IEEE 754 decimal32 BID interchange のビット列として読む。
- ビットパターンを保存し、DPD または SIGNED-DECIMAL の形式として任意に再解釈しない。
- 特殊値や payload を任意に正規化しない。

## 有効性と長さ {#유효성과-길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 2 WORD を合わせた正確に7 WORD であり、直接長 `LLLL=0110` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に2 WORD でなければ拒否する。
- ビット列の意味上の有効性は IEEE BID interchange の規則に従う。

## 例 {#예시}

| 構造 | 判定 |
|---|---|
| `09D6 0000 000D 0000 2003` + 2 WORD BID ビット列 | 正規の長さ構造 |
| `09D6 0000 000D 0000 2003` + 4 WORD | invalid: Payload 幅の不一致 |
| 同じ32ビットに Codec 番号 `0x00002000` | DPD 形式であり、この型ではない |

## 標準上の根拠 {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): decimal32 interchange format の binary coefficient encoding(BID)を適用する。IEEE が許容する DPD の代替へ数値変換せず、選んだ32ビットの encoding を保存し、GEUL の TAG と WORD の big-endian framing だけを加える。
