---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 は、(x, y) 順の IEEE 754 binary64 二つの成分による2次元の点の Value だ(ADHOC Issuer 形式 0x050A)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 は、`(x, y)` 順の IEEE 754 binary64 二つの成分による2次元の点だ。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x050A`。系列 NUMERIC。

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  全体 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## 解釈規則

- 各成分は上位 WORD から読み、NaN payload と signed zero の bit pattern を保存する。
- CRS、軸の意味・順序と単位は外部の文脈だ。ABI padding はない。

## 有効性

- Payload はちょうど 8 WORD で、各 4 WORD の区間は binary64 interchange bits だ。

## 標準の根拠と形式の位置づけ

- 点の `x, y` 座標の順序は、OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) の Point/WKB axis order を参考にし、各成分は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従う。
- この Payload は、WKB type/byte-order header や GeoPackage header を収めない GEUL compact profile で、OGC WKB wire format ではない。CRS、軸の意味と単位は外部の文脈だ。

## 長さ

- 全体は、TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD と Payload 8 WORD を合わせたちょうど 11 WORD で、直接長さ `LLLL=1010` を使う。Length 拡張 TAG、descriptor、padding はない。
- Payload がちょうど 8 WORD でなければ拒否する。

## 例

- Payload `3ff0 0000 0000 0000 4000 0000 0000 0000` は `(1.0, 2.0)` だ。
