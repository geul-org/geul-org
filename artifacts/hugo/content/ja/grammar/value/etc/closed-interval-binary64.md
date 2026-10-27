---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 は、binary64 の下限・上限で、有限で空でない閉区間を収める固定 11 WORD の ADHOC Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 は、`(lower, upper)` 順の IEEE 754 binary64 二つの endpoint で閉区間を表す Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0703`、系列 NUMERIC だ。

## レイアウト

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  全体 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## 解釈と有効性

- 二つの endpoint は big-endian WORD 順の binary64 で、両端を含む。
- 有効な endpoint の signed zero の bit pattern はそのまま保存する。ABI padding はない。
- Payload はちょうど 8 WORD で、`lower ≤ upper` でなければならない。
- NaN は比較できないので拒否する。infinity の endpoint も unbounded な区間なので拒否する。
- empty、unbounded、open interval と NaI は、この形式で表現できず、拒否する。

## 標準の根拠と形式の位置づけ

- endpoint の数値形式は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従い、閉じた endpoint pair という意味は、[IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) と simplified flavor の [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734) の interval モデルを参考にする。
- この形式は、有限で空でない閉区間だけを許す単純な GEUL profile だ。decorations、NaI、empty/unbounded interval、IEEE 1788/1788.1 の全演算・interchange モデルを実装も、そのままのシリアライズもしない。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 8 WORD を合わせたちょうど 11 WORD で、直接長さ `LLLL=1010` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 8 WORD でなければ拒否する。

## 例

- endpoint `(1.0, 2.0)` は `[1.0, 2.0]` で有効だ。`(2.0, 1.0)` と `(NaN, 1.0)` は invalid だ。
