---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 は、(x, y, z) 順の IEEE 754 binary64 三つの成分による3次元の点の Value だ(ADHOC Issuer 形式 0x050B)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 は、`(x, y, z)` 順の IEEE 754 binary64 三つの成分による3次元の点だ。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x050B`。系列 NUMERIC。

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0010 (全体 16 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## 解釈規則

- 各成分は上位 WORD から読み、NaN payload と signed zero の bit pattern を保存する。
- CRS、軸の意味・順序と単位は外部の文脈だ。ABI padding はない。

## 有効性

- Payload はちょうど 12 WORD で、各 4 WORD の区間は binary64 interchange bits だ。

## 標準の根拠と形式の位置づけ

- 点の `x, y, z` 座標の順序は、OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) の Point/WKB axis order を参考にし、各成分は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従う。
- この Payload は、WKB type/byte-order header や GeoPackage header を収めない GEUL compact profile で、OGC WKB wire format ではない。CRS、軸の意味と単位は外部の文脈だ。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD と Payload 12 WORD を合わせたちょうど 16 WORD で、`LLLL=1110` を使う。descriptor と padding はない。
- Payload がちょうど 12 WORD でなければ拒否する。

## 例

- Payload の三つの binary64 が `1.0, 2.0, 3.0` なら、点 `(1.0, 2.0, 3.0)` だ。
