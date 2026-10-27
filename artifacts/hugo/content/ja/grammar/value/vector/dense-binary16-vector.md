---
title: "DENSE-BINARY16-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR は、binary16 要素を descriptor なしで連ねて収める一次元ベクトル Value だ(ADHOC Issuer 形式 0x0506)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR は、IEEE 754 binary16 interchange bit pattern を descriptor なしで連ねて保存する。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0506`。系列 NUMERIC。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## 解釈規則

- 要素数は Payload WORD 数だ。NaN payload と signed zero を含む bit pattern をそのまま保存する。
- 要素の間と末尾に ABI padding はない。

## 有効性

- Payload は 1 WORD 以上でなければならない。descriptor のないこの形式は、空の vector を許さない。
- Payload のサイズは、要素幅 1 WORD の整数倍でなければならない。

## 標準の根拠と形式の位置づけ

- binary16 要素の interchange format は、[IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/) に従う。
- descriptor のない一次元の連続列、GEUL TAG/Length と 16ビット big-endian WORD の配置は、GEUL 固有の形式だ。[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) は native-endian を仮定するので、この Payload は DLPack、Arrow、ONNX の wire serialization ではない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 1 WORD、形式番号 1 WORD と Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に含める([Length](/ja/grammar/record/))。

## 例

- Payload `3c00 8000` は binary16 の `1.0` と `-0` で、全体 5 WORD レコードだ。
