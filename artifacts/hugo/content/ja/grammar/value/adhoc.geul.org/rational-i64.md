---
title: "RATIONAL-I64"
weight: 1020
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64は、big-endian の int64 numerator と int64 denominator の既約分数で有理数を表す Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64は、big-endian の int64 numerator と int64 denominator の既約分数で有理数を表す Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000702`、系列 NUMERIC である。

## レイアウト {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  全体 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## 解釈と有効性 {#해석과-유효성}

- 各 int64 は上位 WORD から連結した固定幅の2の補数整数であり、値は `numerator / denominator` である。
- ABI padding はない。
- Payload は正確に8 WORD であり、denominator は正でなければならない。
- `gcd(|numerator|, denominator) = 1` の既約形だけを許す。0は `0/1` とのみ書く。

## 形式上の位置づけ {#형식-지위}

- 2つの int64、正の denominator、最大公約数1、`0/1` の canonicalization は、外部の wire 標準を採用したものではなく GEUL 固有の形式である。
- 各 int64 の2の補数による解釈、成分の順序、big-endian WORD framing を含め、このページが表現を完全に定義する。

## 長さ {#길이}

- 全体は TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD、Payload 8 WORD を合わせた正確に13 WORD であり、直接長 `LLLL=1100` を用いる。Length 拡張 TAG、descriptor、padding はない。
- Payload が正確に8 WORD でなければ拒否する。

## 例 {#예시}

- numerator `1`、denominator `2` は有効な `1/2` である。`2/4`、`0/2`、denominator `-2` は invalid である。
