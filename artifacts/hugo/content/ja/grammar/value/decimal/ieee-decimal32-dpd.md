---
title: "IEEE-DECIMAL32-DPD"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "IEEE-DECIMAL32-DPD は、IEEE 754 decimal32 DPD interchange ビット列をそのまま収める固定 5 WORD の Value だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IEEE-DECIMAL32-DPD は、IEEE 754 decimal32 DPD interchange encoding を表す Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0040` IEEE、形式番号 `0x2000`、系列 DECIMAL だ。DPD のビットパターンをそのまま保存し、BID と区別する。

## レイアウト

```
TAG WORD          0x0A7C  全体 5 WORD
Issuer            1 WORD  0x0040 (IEEE)
形式番号          1 WORD  0x2000
Payload           2 WORD (32ビット)  IEEE decimal32 DPD Interchange
```

## 解釈

- 二つの Payload WORD を上位 WORD から連ねた IEEE 754 decimal32 DPD interchange ビット列として読む。
- ビットパターンを保存し、BID または exact decimal 形式として勝手に再解釈しない。
- 特殊値や payload を勝手に正規化しない。

## 有効性と長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 2 WORD を合わせたちょうど 5 WORD で、直接長さ `LLLL=0100` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 2 WORD でなければ拒否する。
- ビット列の意味上の有効性は、IEEE DPD interchange の規則に従う。

## 例

| 構造 | 判定 |
|---|---|
| `0A7C 0040 2000` + 2 WORD DPD ビット列 | 正規の長さ構造 |
| `0A7C 0040 2000` + 4 WORD | invalid: Payload 幅の不一致 |
| 同じ 32ビットに形式番号 `0x2003` | BID 形式であり、この型ではない |

## 標準の根拠

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): decimal32 interchange format の decimal coefficient encoding(DPD)を適用する。IEEE が許す BID の代替へ数値変換せず、選ばれた 32ビットの encoding を保存し、GEUL TAG と WORD big-endian framing だけを加える。
