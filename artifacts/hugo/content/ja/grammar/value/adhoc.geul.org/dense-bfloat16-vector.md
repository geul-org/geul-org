---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTORは、bfloat16 の16ビット要素の bit pattern を descriptor なしで連続して格納する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTORは、bfloat16 の16ビット要素の bit pattern を descriptor なしで連続して格納する。binary16 とは別の形式である。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000507`。系列 NUMERIC。

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 拡張 TAG] 全体 15 WORD 以上のとき
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## 解釈規則 {#해석-규칙}

- 要素数は Payload の WORD 数である。NaN payload と signed zero を含む bit pattern をそのまま保存する。
- 要素の間と末尾に ABI padding はない。

## 有効性 {#유효성}

- Payload は1 WORD 以上でなければならない。descriptor を持たないこの形式は空の vector を許さない。
- Payload のサイズは要素幅1 WORD の整数倍でなければならない。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- bfloat16 という独立した16ビット dtype と、binary16 との区別は、[ONNX IR の tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) および [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html) に合わせる。
- descriptor のない1次元の bit-pattern 連続列、GEUL の TAG/Length、16ビット big-endian WORD の配置は GEUL 固有の形式である。DLPack は native-endian を仮定するので、この Payload は DLPack、Arrow、ONNX の wire serialization ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 2 WORD、Codec 番号 2 WORD と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` の拡張長を用い、拡張 TAG も全体の数に含める([Length](../../record.md))。

## 例 {#예시}

- Payload `3F80 8000` は BF16 の `1.0` と `-0` であり、全体7 WORD のレコードである。
