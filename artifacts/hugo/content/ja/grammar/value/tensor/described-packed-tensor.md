---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR は、packed format・rank・shape の descriptor の後ろに sub-WORD 要素を low-bit-first で詰めた ADHOC Issuer 形式だ。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR は、shape と packed format を Payload descriptor に書き、WORD より小さい要素を packed で保存するテンソル Value だ。Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0601`、系列 NUMERIC だ。

## レイアウト

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 残り      [packed payload octet stream, low-bit-first]
```

## 解釈

- rank は descriptor の 4bit 値なので、構造的に `0..15` だけを表現する。各 dimension は非負の big-endian uint32 だ。論理順序は C-contiguous row-major だ。
- ONNX の論理 tensor 規則のとおり、rank 0 の shape `[]` は要素 1 個の scalar で、dimension のうち一つでも 0 なら要素数は 0 だ。それ以外の要素数は、すべての dimension の積だ。
- packed-format は、int2/int4、FP4/FP6、特定の FP8 variant のように、要素の encoding と bit 幅を固定する。
- payload octet sequence を `p[0], p[1], ...` とし、little-bit-endian 整数 `P = Σ(p[j] << (8j))` と見ると、幅 `w` の論理要素 `i` は `(P >> (i × w)) & ((1 << w) - 1)` だ。つまり最初の要素から最も低いビットに入れる。
- WORD には、`p[0]` を最初の WORD の上位 octet、`p[1]` を下位 octet の順に載せる。最後に使う octet の未使用の上位 tail bit は 0 でなければならず、payload の octet 数が奇数なら、最後の WORD の未使用の下位 octet 全体が `00` でなければならない。

## 有効性

- 対応する format の bit 幅を適用したとき、overflow なしで計算した shape の dimension の積と payload の要素数が合わなければならない。
- 必要な payload bit の後ろの high tail bit や octet padding が一つでも 1 なら拒否する。descriptor、shape、payload は、レコードの Length の中に完全に収まらなければならない。

## 標準の根拠と形式の位置づけ

- shape、rank 0 の scalar、zero dimension の論理的な意味は、[ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html) に従う。sub-byte 要素を低い bit から置く規則は、公式の [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) の int2/int4 packing と、[DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) の little bit-endian packing に従う。
- 4bit の rank、uint32 の dimension、version/packed-format field、octet を big-endian WORD に束ねる方式、GEUL TAG/Length は、GEUL 固有の descriptor だ。ONNX、[Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html)、DLPack 自体の wire・memory serialization ではない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 1 WORD、形式番号 1 WORD、Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に入る([レコードと TAG WORD](/ja/grammar/record/))。
- descriptor は 1 WORD、shape は `2 × rank` WORD で、残りが packed payload だ。
- 論理要素数が `N`、要素幅が `w` なら、payload の octet 数は `ceil(N × w / 8)`、payload の WORD 数は `ceil(payload の octet 数 / 2)` だ。

## 例

- rank が 2 の profile なら、descriptor の後ろの 4 WORD が shape で、その後ろが low-bit-first の payload octet sequence だ。要素幅と実際に許容されるかは、確定した format profile で判断する。
- 4bit 要素 `[1, 2, 3]` の payload octet sequence は `21 03` で、payload WORD は `2103` だ。最初の要素が最初の octet の低い nibble にあり、最後の octet の未使用の高い nibble は 0 だ。

## 未解決の問題

- version と packed-format registry の値、そして表現可能な rank `0..15` のうち対応する profile の範囲は、まだ決めていない。
