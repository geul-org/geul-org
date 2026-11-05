---
title: "POINT3-BINARY64"
weight: 1018
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64は、(x, y, z) の順に並ぶ IEEE 754 binary64 の3成分からなる3次元の点である。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64は、`(x, y, z)` の順に並ぶ IEEE 754 binary64 の3成分からなる3次元の点である。

## レイアウト {#레이아웃}

- コード: Value `VALUE-ISSUER-2WORD`(`0x09DL`)、Issuer `0x00000002` ADHOC、Codec 番号 `0x0000050B`。系列 NUMERIC。

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0012 (全体 18 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Codec 番号        2 WORD  0x0000050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## 解釈規則 {#해석-규칙}

- 各成分は上位 WORD から読み、NaN payload と signed zero の bit pattern を保存する。
- CRS、軸の意味・順序および単位は外部の文脈である。ABI padding はない。

## 有効性 {#유효성}

- Payload は正確に12 WORD であり、4 WORD ずつの各区間は binary64 interchange bits である。

## 標準上の根拠と形式上の位置づけ {#표준-근거와-형식-지위}

- 点の `x, y, z` の座標順は OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) の Point/WKB axis order を参考にし、各成分は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従う。
- この Payload は WKB の type/byte-order header や GeoPackage header を含まない GEUL compact profile であり、OGC WKB wire format ではない。CRS、軸の意味および単位は外部の文脈である。

## 長さ {#길이}

- 全体は TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 2 WORD、Codec 番号 2 WORD と Payload 12 WORD を合わせた正確に18 WORD であり、`LLLL=1110` を用いる。descriptor と padding はない。
- Payload が正確に12 WORD でなければ拒否する。

## 例 {#예시}

- Payload の3つの binary64 が `1.0, 2.0, 3.0` なら、点 `(1.0, 2.0, 3.0)` である。
