---
title: "DENSE-U16-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U16-VECTOR は、big-endian uint16 要素を descriptor なしで連ねて収める一次元ベクトル Value だ(ADHOC Issuer 形式 0x0501)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U16-VECTOR は、big-endian uint16 要素を descriptor なしで連ねて保存する、同質の一次元 Value だ。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x0501`。系列 NUMERIC。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 拡張 TAG] 全体が 15 WORD 以上のとき
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x0501
Payload: [uint16 1st: 1 WORD] ... [uint16 Nth: 1 WORD]
```

## 解釈規則

- 各 WORD を独立した unsigned 16ビット整数として読む。要素数は Payload WORD 数だ。
- 要素の間と末尾に ABI padding はない。

## 有効性

- Payload は 1 WORD 以上でなければならない。descriptor のないこの形式は、空の vector を許さない。
- Payload のサイズは、要素幅 1 WORD の整数倍でなければならない。

## 標準の根拠と形式の位置づけ

- unsigned integer dtype の unsigned 解釈と 16ビット幅は、[ONNX IR の tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) および [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) の産業 dtype に合わせる。
- descriptor のない一次元の連続列、GEUL TAG/Length と big-endian WORD の配置は、GEUL 固有の形式だ。DLPack は dtype を native-endian と仮定するので、この Payload は DLPack や ONNX の wire serialization ではない。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG(あれば)、Issuer 1 WORD、形式番号 1 WORD と Payload を合わせた WORD 数だ。14 WORD 以下は直接長さ、15 WORD 以上は `1110`・`1111` の拡張長さを使い、拡張 TAG も全体の数に含める([Length](/ja/grammar/record/))。

## 例

- Payload `0000 ffff` は要素 `[0, 65535]` で、直接長さ `LLLL=0100` の全体 5 WORD レコードだ。
