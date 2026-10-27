---
title: "RATIONAL-I64"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "RATIONAL-I64 は、int64 の分子と正の int64 の分母による既約分数で有理数を収める固定 11 WORD の ADHOC Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RATIONAL-I64 は、big-endian int64 の numerator と int64 の denominator による既約分数で有理数を表す Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0702`、系列 NUMERIC だ。

## レイアウト

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  全体 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0702
Payload           [numerator int64: 4 WORD][denominator int64: 4 WORD]
```

## 解釈と有効性

- 各 int64 は、上位 WORD から連ねた固定幅の2の補数整数で、値は `numerator / denominator` だ。
- ABI padding はない。
- Payload はちょうど 8 WORD で、denominator は正でなければならない。
- `gcd(|numerator|, denominator) = 1` の既約形だけを許す。0 は `0/1` としてのみ書く。

## 形式の位置づけ

- 二つの int64、正の denominator、最大公約数 1、`0/1` の canonicalization は、外部の wire 標準を採用したものではなく、GEUL 固有の形式だ。
- 各 int64 の2の補数の解釈、成分の順序、big-endian WORD framing を含め、このページが表現を完全に定義する。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD、Payload 8 WORD を合わせたちょうど 11 WORD で、直接長さ `LLLL=1010` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 8 WORD でなければ拒否する。

## 例

- numerator `1`、denominator `2` は有効な `1/2` だ。`2/4`、`0/2`、denominator `-2` は invalid だ。
