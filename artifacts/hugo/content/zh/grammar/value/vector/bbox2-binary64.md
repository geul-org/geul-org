---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 是由 (minX, minY, maxX, maxY) 顺序的 IEEE 754 binary64 四个分量构成的二维边界框 Value（ADHOC Issuer 格式 0x050C）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 是由 `(minX, minY, maxX, maxY)` 顺序的 IEEE 754 binary64 四个分量构成的二维边界框。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0001` ADHOC，格式编号 `0x050C`。系列 NUMERIC。

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length 扩展 TAG   1 WORD  0x0014 (总计 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
格式编号          1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## 解读规则

- 每个分量是 binary64，从高位 WORD 起读取。保留 signed zero bit pattern。
- CRS、轴的含义·顺序和单位属于外部上下文。没有 ABI padding。

## 有效性

- Payload 必须恰好是 16 WORD，且必须 `minX ≤ maxX`、`minY ≤ maxY`。
- NaN 无法比较，所以任何分量中出现都予以拒绝。

## 标准依据与格式地位

- 最小·最大坐标的含义参考 OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) 的 bounding envelope，每个分量遵循 [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/)。
- GeoPackage envelope 的 2D 数组顺序是 `[minx, maxx, miny, maxy]`。本格式的 `(minX, minY, maxX, maxY)` 顺序不是那种 wire order，而是 GEUL 规定的 compact tuple，也不承载 WKB/GeoPackage header。CRS、轴的含义和单位属于外部上下文。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG 1 WORD、Issuer 1 WORD、格式编号 1 WORD 与 Payload 16 WORD 之和，恰好 20 WORD，使用 `LLLL=1110`。没有 descriptor 和 padding。
- Payload 不是恰好 16 WORD 则拒绝。

## 示例

- 分量为 `(0.0, 1.0, 2.0, 3.0)` 则有效，为 `(2.0, 1.0, 0.0, 3.0)` 则 invalid。
