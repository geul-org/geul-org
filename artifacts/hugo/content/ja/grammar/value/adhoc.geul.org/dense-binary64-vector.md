---
title: "DENSE-BINARY64-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTORは、IEEE 754 binary64 の interchange bit pattern を descriptor なしで連続して格納する。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTORは、IEEE 754 binary64 の interchange bit pattern を descriptor なしで連続して格納する。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000509`。系列 NUMERIC。

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 拡張 TAG] 全体 15 WORD 以上のとき
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## 解釈規則 {#해석-규칙}

- 連続する4 WORD が1要素であり、上位 WORD から読む。NaN payload と signed zero を含む bit pattern をそのまま保存する。
- 要素数は Payload の WORD 数の1/4であり、ABI padding はない。

## 有効性 {#유효성}

- Payload は4 WORD 以上で、4 WORD の整数倍でなければならない。descriptor を持たないこの形式は空の vector を許さない。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- binary64 要素の interchange format は [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/) に従う。
- descriptor のない1次元連続列、GEUL の TAG/Length、16ビット big-endian WORD の配置は GEUL 固有の形式である。[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) は native-endian を仮定するので、この Payload は DLPack、Arrow、ONNX の wire serialization ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 2 WORD、Codec 番号 2 WORD と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` の拡張長を用い、拡張 TAG も全体の数に含める([Length](../../record.md))。

## 例 {#예시}

- Payload `3FF0 0000 0000 0000` は binary64 の `[1.0]` であり、全体9 WORD のレコードである。
