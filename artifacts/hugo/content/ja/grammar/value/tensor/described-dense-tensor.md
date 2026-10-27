---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR は、element format・rank・shape の descriptor の後ろに C-contiguous row-major の要素を収める ADHOC Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR は、shape と element format を Payload descriptor に書き、C-contiguous row-major の payload を保存するテンソル Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0600`、系列 NUMERIC だ。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 残り      [dense payload]
```

## 解釈

- rank は descriptor の 4bit 値なので、構造的に `0..15` だけを表現する。各 dimension は非負の big-endian uint32 だ。
- ONNX の論理 tensor 規則のとおり、rank 0 の shape `[]` は要素 1 個の scalar で、dimension のうち一つでも 0 なら要素数は 0 だ。それ以外の要素数は、すべての dimension の積だ。
- payload は descriptor の element format で読み、C-contiguous row-major の順だ。計算した論理要素数は、descriptor の後ろの payload の要素数と同じでなければならない。

## 有効性

- 対応する version と element format が決まれば、その要素幅で payload の境界を復元し、overflow なしで計算した shape の積と合うかを検証する。
- descriptor、すべての dimension、payload は、レコードの Length の中に完全に収まらなければならず、任意の ABI padding はない。

## 標準の根拠と形式の位置づけ

- shape が非負の dimension の一覧で、値の数が dimension の積と同じという規則、rank 0 の scalar と zero dimension の意味は、[ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html) に従う。C-contiguous row-major の論理順序は、[Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html) の順序に合わせる。
- 4bit の rank、uint32 の dimension、version/element-format field、GEUL TAG/Length、big-endian WORD payload は、GEUL 固有の descriptor だ。[Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html)、ONNX TensorProto、[DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html) の wire・memory serialization ではない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 1 WORD、形式番号 1 WORD、Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](/ja/grammar/record/))。
- descriptor は 1 WORD、shape は `2 × rank` WORD で、残りが payload だ。

## 例

- rank が 2 の profile なら、descriptor の後ろの 4 WORD が二つの uint32 dimension で、その後ろ全体が row-major payload だ。実際に許容されるかと要素数の検証には、確定した version・format profile が必要だ。

## 未解決の問題

- version と element-format registry の値、そして表現可能な rank `0..15` のうち対応する profile の範囲は、まだ決めていない。
