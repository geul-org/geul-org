---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 は、(minX, minY, maxX, maxY) 順の IEEE 754 binary64 四つの成分による2次元バウンディングボックスの Value だ(ADHOC Issuer 形式 0x050C)。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 は、`(minX, minY, maxX, maxY)` 順の IEEE 754 binary64 四つの成分による2次元バウンディングボックスだ。

## レイアウト

- コード: Value `ISSUER-1WORD`(`0x7C`)、Issuer `0x0001` ADHOC、形式番号 `0x050C`。系列 NUMERIC。

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 拡張 TAG   1 WORD  0x0014 (全体 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
形式番号          1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## 解釈規則

- 各成分は binary64 で、上位 WORD から読む。signed zero の bit pattern を保存する。
- CRS、軸の意味・順序と単位は外部の文脈だ。ABI padding はない。

## 有効性

- Payload はちょうど 16 WORD でなければならず、`minX ≤ maxX`、`minY ≤ maxY` でなければならない。
- NaN は比較できないので、どの成分にあっても拒否する。

## 標準の根拠と形式の位置づけ

- 最小・最大座標の意味は、OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) の bounding envelope を参考にし、各成分は [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/) に従う。
- GeoPackage envelope の2次元配列の順序は `[minx, maxx, miny, maxy]` だ。この形式の `(minX, minY, maxX, maxY)` の順序は、その wire order ではなく GEUL が定めた compact tuple で、WKB/GeoPackage header も収めない。CRS、軸の意味と単位は外部の文脈だ。

## 長さ

- 全体は、TAG 1 WORD、Length 拡張 TAG 1 WORD、Issuer 1 WORD、形式番号 1 WORD と Payload 16 WORD を合わせたちょうど 20 WORD で、`LLLL=1110` を使う。descriptor と padding はない。
- Payload がちょうど 16 WORD でなければ拒否する。

## 例

- 成分が `(0.0, 1.0, 2.0, 3.0)` なら有効で、`(2.0, 1.0, 0.0, 3.0)` なら invalid だ。
