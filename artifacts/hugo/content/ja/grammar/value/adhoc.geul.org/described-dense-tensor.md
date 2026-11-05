---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSORは、shape と element format を Payload の descriptor に記し、C-contiguous row-major の payload を格納するテンソル Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSORは、shape と element format を Payload の descriptor に記し、C-contiguous row-major の payload を格納するテンソル Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000600`、系列 NUMERIC である。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 拡張 TAG] 全体 15 WORD 以上のとき
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 残り      [dense payload]
```

## 解釈 {#해석}

- rank は descriptor の4bit の値なので、構造上 `0..15` だけを表現できる。各 dimension は非負の big-endian uint32 である。
- ONNX の論理 tensor 規則と同じく、rank 0 の shape `[]` は要素1個の scalar であり、dimension のどれか1つでも0なら要素数は0である。それ以外の要素数はすべての dimension の積である。
- payload は descriptor の element format で読み、C-contiguous row-major の順序である。計算した論理要素数は、descriptor に続く payload の要素数と等しくなければならない。

## 有効性 {#유효성}

- 対応する version と element format が定まれば、その要素幅で payload の境界を復元し、overflow なしで計算した shape の積と合うことを検証する。
- descriptor、すべての dimension、payload はレコードの Length に完全に収まらなければならず、任意の ABI padding はない。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- shape が非負の dimension の並びであり、値の数が dimension の積と等しいという規則、および rank 0 の scalar と zero dimension の意味は [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html) に従う。C-contiguous row-major の論理順序は [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html) の順序に合わせる。
- 4bit の rank、uint32 の dimension、version/element-format field、GEUL の TAG/Length、big-endian WORD の payload は GEUL 固有の descriptor である。[Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html)、ONNX TensorProto、[DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html) の wire・memory serialization ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 2 WORD、Codec 番号 2 WORD、Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` の拡張長を用い、拡張 TAG も全体の数に入る([レコードと TAG WORD](../../record.md))。
- descriptor は1 WORD、shape は `2 × rank` WORD であり、残りが payload である。

## 例 {#예시}

- rank が2の profile なら、descriptor に続く4 WORD が2つの uint32 dimension であり、その後ろ全体が row-major の payload である。実際に許容されるか否かと要素数の検証には、確定した version・format の profile が必要である。

## 未解決の問題 {#열린-문제}

- version と element-format の registry の値、および表現可能な rank `0..15` のうち対応する profile の範囲は、まだ定めていない。
