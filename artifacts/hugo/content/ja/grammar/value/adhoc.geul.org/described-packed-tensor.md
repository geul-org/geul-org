---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSORは、shape と packed format を Payload の descriptor に記し、WORD より小さい要素を packed で格納するテンソル Value である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSORは、shape と packed format を Payload の descriptor に記し、WORD より小さい要素を packed で格納するテンソル Value である。Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x00000601`、系列 NUMERIC である。

## レイアウト {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 拡張 TAG] 全体 15 WORD 以上のとき
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x00000601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload 残り      [packed payload octet stream, low-bit-first]
```

## 解釈 {#해석}

- rank は descriptor の4bit の値なので、構造上 `0..15` だけを表現できる。各 dimension は非負の big-endian uint32 である。論理順序は C-contiguous row-major である。
- ONNX の論理 tensor 規則と同じく、rank 0 の shape `[]` は要素1個の scalar であり、dimension のどれか1つでも0なら要素数は0である。それ以外の要素数はすべての dimension の積である。
- packed-format は、int2/int4、FP4/FP6、特定の FP8 variant のように、要素の encoding と bit 幅を固定する。
- payload の octet sequence を `p[0], p[1], ...` とし、little-bit-endian の整数 `P = Σ(p[j] << (8j))` とみなすと、幅 `w` の論理要素 `i` は `(P >> (i × w)) & ((1 << w) - 1)` である。すなわち、最初の要素から最下位 bit に入れる。
- WORD には、`p[0]` を最初の WORD の上位 octet、`p[1]` を下位 octet の順に載せる。最後に使う octet の未使用の上位 tail bit は0でなければならず、payload の octet 数が奇数なら、最後の WORD の未使用の下位 octet 全体が `00` でなければならない。

## 有効性 {#유효성}

- 対応する format の bit 幅を適用したとき、overflow なしで計算した shape の dimension の積と payload の要素数が合わなければならない。
- 必要な payload bit の後ろの high tail bit や octet padding が1つでも1なら拒否する。descriptor、shape、payload はレコードの Length に完全に収まっていなければならない。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- shape、rank 0 の scalar、zero dimension の論理的な意味は [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html) に従う。sub-byte 要素を低い bit から置く規則は、公式の [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) の int2/int4 packing と [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) の little bit-endian packing に従う。
- 4bit の rank、uint32 の dimension、version/packed-format field、octet を big-endian WORD にまとめる方式、GEUL の TAG/Length は GEUL 固有の descriptor である。ONNX、[Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html)、DLPack 自体の wire・memory serialization ではない。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 2 WORD、Codec 番号 2 WORD、Payload を合わせた WORD 数である。14 WORD 以下は直接長、15 WORD 以上は `1110`・`1111` の拡張長を用い、拡張 TAG も全体の数に入る([レコードと TAG WORD](../../record.md))。
- descriptor は1 WORD、shape は `2 × rank` WORD であり、残りが packed payload である。
- 論理要素数が `N`、要素幅が `w` なら、payload の octet 数は `ceil(N × w / 8)`、payload の WORD 数は `ceil(payload の octet 数 / 2)` である。

## 例 {#예시}

- rank が2の profile なら、descriptor に続く4 WORD が shape であり、その後ろが low-bit-first の payload octet sequence である。要素幅と実際に許容されるか否かは、確定した format の profile で判断する。
- 4bit 要素 `[1, 2, 3]` の payload octet sequence は `21 03` であり、payload WORD は `2103` である。最初の要素は最初の octet の下位 nibble にあり、最後の octet の未使用の上位 nibble は0である。

## 未解決の問題 {#열린-문제}

- version と packed-format の registry の値、および表現可能な rank `0..15` のうち対応する profile の範囲は、まだ定めていない。
