---
title: "COORDINATE-GEO"
weight: 6
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO 是用天体 Reference、纬度·经度 binary64、不确定度 binary32 及其单位 Reference 来承载行星·卫星等天体上一个点的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-GEO 是用纬度·经度和不确定度表示指定天体（行星、卫星、小行星等）上一个点的坐标 Value。Value 直接码 `0x05`，系列为 NUMERIC。它是在 [COORDINATE-EARTH](/zh/grammar/value/numeric/coordinate-earth/)（`0x04`）前面加上天体（Globe）Reference 的格式，纬度·经度·不确定度·单位的规则与 COORDINATE-EARTH 相同。

## 布局

```
TAG WORD          0000 1LLL L000 0101      Codec 0x05
[Length 扩展 TAG] 总计 15 WORD 以上时
Globe             Reference 记录 1 个 (指向天体的 Reference，Quantifier Identified)
Latitude          4 WORD 原始值，IEEE 754 binary64 (度)
Longitude         4 WORD 原始值，IEEE 754 binary64 (度)
Uncertainty       2 WORD 原始值，IEEE 754 binary32 (Unit 单位)
Unit              Reference 记录 1 个，或占位标记 0x0000 ABSENT
```

## 解读与有效性

- Payload 以 Globe 记录开头。Globe 恰好是一条完整的 Reference 记录，Quantifier 是 Identified（`000`）。可以使用任何指向天体的 Reference：[WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/)（有名称的天体）、[GEUL](/zh/grammar/reference/geul/)、同一文档的 [LOCAL](/zh/grammar/reference/local/)（在文档内定义的天体）、其他文档的天体（[EXTERNAL-POINTER](/zh/grammar/reference/external-pointer/)·[EXTERNAL-ISSUER](/zh/grammar/reference/external-issuer/)）等。天体无穷无尽，有 QID 的天体只是其中一部分。
- Globe 之后是 10 WORD（Latitude 4、Longitude 4、Uncertainty 2）和一条 Unit 记录。读完 Unit 的游标必须与记录末尾吻合。
- Latitude 是 `-90 ≤ φ ≤ 90`，Longitude 是 `-180 ≤ λ ≤ 360`。`(180, 360]` 是为了原样承载经度按 0~360° 计数的天体坐标系的值而允许的。其他规则（binary64、有限值、轴顺序、Uncertainty·Unit 的含义、未知的表示）与 COORDINATE-EARTH 相同。
- 坐标系按各天体遵循该天体的惯例（行星中心纬度、东经或西经 0~360° 等）。各天体的坐标系用单独的 GEUL 文档规定。
- 距离单位（米等）的 Uncertainty 是天体表面上的距离。角度单位（度·角分·角秒）与天体大小无关，是纬度·经度的角度半径。
- 地球（Q2）坐标建议使用 COORDINATE-EARTH。在本格式中写地球也不是 invalid，由比较一方将其对齐为同一坐标。
- geul.org 规格文档 `0x0000/0x0000000000000805` 在 Latitude·Longitude·Uncertainty 原始值字段上放 [CODEC](/zh/grammar/edge/codec/) BINARY-FLOAT（`0803`），在 Unit 记录字段上放 CODEC `0780`（任意 Reference）·`0000`（ABSENT）。

## 长度

- 总计是 TAG 1 WORD + (Length 扩展 TAG) + Globe 记录 + 10 WORD + Unit 记录。
- Globe 为 2 WORD（QID 能放入 1 WORD 时）且 Unit 为 ABSENT 时，是 14 WORD，`LLLL=1101`，TAG `0E85`。Unit 是 Reference（2 WORD 以上）时超过 15 WORD，使用扩展长度：TAG `0F05`，下一个 WORD 是总 WORD 数（[记录与 TAG WORD](/zh/grammar/record/)）。

## 与 Wikidata 的对应

- globe 不是地球（Q2）的 globecoordinate 用本格式书写。Globe = WIKIDATA-QID（globe 条目）。纬度·经度、precision → Uncertainty·Unit 的对应与 COORDINATE-EARTH 相同（precision 是以度为单位的记录分辨率，与天体大小无关，原样转换）。
- Wikidata 样本（坐标声明约 2.4 万条）中地球之外的天体：火星（Q111）、谷神星（Q596）、月球（Q405）、水星（Q308）、金星（Q313）等 23 条。globe 为空的 41 条不转换，把原文以 UTF8-TEXT 保留。

## 示例

火星（Q111）4.5, 137.4，不确定度未知：

```
0E85 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `0E85`（Codec `0x05`，`LLLL=1101`，14 WORD），Globe `00A0 006F`（WIKIDATA-QID Q111），Latitude `4012 0000 0000 0000`，Longitude `4061 2CCC CCCC CCCD`，Uncertainty `0000 0000`（+0），Unit `0000`（ABSENT，未知）。
- 文本写法：`COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`。

同一个点，precision 0.1°（Unit 度 Q28390）：

```
0F05 0010 00A0 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 00A0 6EE6
```

- TAG `0F05`（`LLLL=1110`，扩展长度），总计 `0010`（16 WORD），Uncertainty `3DCC CCCD`（binary32 0.1），Unit `00A0 6EE6`（Q28390）。

## 标准依据

- 含义：[RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) 的纬度·经度·`u`（Unit 为米时）。RFC 5870 的 `crs` 中登记的坐标系只有 `wgs84`，所以地球之外的天体用 GEUL Globe Reference 指定。
- 数值：[IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64（纬度·经度）、binary32（不确定度）。

## 未决问题

1. 各天体的坐标系文档：每个天体的纬度定义（行星中心·行星面）和经度方向·范围。

## 相关页面

- [Value](/zh/grammar/value/)、[COORDINATE-EARTH](/zh/grammar/value/numeric/coordinate-earth/)、[WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/)、[GEUL](/zh/grammar/reference/geul/)、[LOCAL](/zh/grammar/reference/local/)
