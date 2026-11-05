---
title: "DENSE-U32-VECTOR"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U32-VECTORは、big-endian uint32 要素を descriptor なしで連続して格納する同質の1次元 Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U32-VECTORは、big-endian uint32 要素を descriptor なしで連続して格納する同質の1次元 Value である。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000503`。系列 NUMERIC。

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 拡張 TAG] 全体 15 WORD 以上のとき
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000503
Payload: [uint32 1st: 2 WORD] ... [uint32 Nth: 2 WORD]
```

## 解釈規則 {#해석-규칙}

- 連続する2 WORD を上位 WORD から結合して unsigned 32ビット整数として読む。
- 要素数は Payload の WORD 数の1/2であり、ABI padding はない。

## 有効性 {#유효성}

- Payload は2 WORD 以上で、2 WORD の整数倍でなければならない。descriptor を持たないこの形式は空の vector を許さない。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- unsigned integer dtype の unsigned 解釈と32ビット幅は [ONNX IR の tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) および [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) の産業 dtype に合わせる。
- descriptor のない1次元連続列、GEUL の TAG/Length、big-endian WORD の配置は GEUL 固有の形式である。DLPack は dtype を native-endian と仮定するので、この Payload は DLPack や ONNX の wire serialization ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 2 WORD、Codec 番号 2 WORD と Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` の拡張長を用い、拡張 TAG も全体の数に含める([Length](../../record.md))。

## 例 {#예시}

- Payload `0000 0000 FFFF FFFF` は要素 `[0, 4294967295]` であり、全体9 WORD のレコードである。
