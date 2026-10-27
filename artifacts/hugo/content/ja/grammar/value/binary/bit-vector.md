---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR は、32bit のビット数 N の後ろに N bit を MSB-first で収める GEUL Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR は、長さを明示した raw bit sequence だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0000` GEUL、形式番号 `0xC002`、系列 BINARY だ。最初の 2 Payload WORD は unsigned 32bit の bit count `N` で、その後ろに `ceil(N/16)` WORD が来る。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Issuer            1 WORD  0x0000 (GEUL)
形式番号          1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (上位 16bit │ 下位 16bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## 解釈と有効性

- `N` は、最初の 2 Payload WORD を big-endian unsigned 32bit 整数として読んだ値だ。
- payload bit は、各 WORD の最上位ビットから順に詰める。
- payload WORD 数はちょうど `ceil(N/16)` で、最後の WORD で使わない下位 bit はすべて 0 でなければならない。
- `N=0` なら payload WORD はない。二つの count WORD がすでに Payload をなすので、Payload は最小 1 WORD という規則と衝突しない。

## 形式の位置づけ

- unsigned 32bit の bit count、MSB-first の配置、最後の WORD の zero padding は、外部の産業標準を引用したものではなく、GEUL 固有の framing だ。
- GEUL TAG、Length、16bit WORD の規則を含め、このページが表現を定義する。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 1 WORD、形式番号 1 WORD、Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](/ja/grammar/record/))。

## 例

- 空の bit vector は count `0000 0000`、payload なし、全体 5 WORD、`LLLL=0100` だ。
- bit sequence `101` は count `0000 0003`、payload `a000`、全体 6 WORD、`LLLL=0101` だ。
