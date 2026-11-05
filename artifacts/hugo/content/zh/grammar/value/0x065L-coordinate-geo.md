---
title: "COORDINATE-GEO (0x065L)"
weight: 101
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-GEO 是以纬度、经度和不确定度表示指定天体（行星、卫星、小行星等）上一点的坐标 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `COORDINATE-GEO`（规格文档 BIND `COORDINATE-GEO`） |
| TAG ID | `0x065L` |
| Codec ID | `0x00000650` |
| 规格文档 | `0x00000000/codecs/0x00000650/`（DECLARE 目标 `0650`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 5 |
| Kind | Value · 系列：NUMERIC |
| TAG WORD | `0000 0110 0101 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 天体 Reference 与纬度·经度 binary64，不确定度 binary32 及其单位 Reference |
| Hugo 页面 | `value/numeric/coordinate-geo.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `globe` | #2 | 记录 | `0050` LOCAL, `00A0` GEUL, `00F0` GEUL-SIDX, `0140` WIKIDATA-QID, `0200` EXTERNAL-POINTER-1WORD, `0250` EXTERNAL-POINTER-2WORD, `02A0` EXTERNAL-POINTER-4WORD, `02F0` EXTERNAL-ISSUER-2WORD, `0340` EXTERNAL-ISSUER-4WORD, `0390` EXTERNAL-ISSUER-16WORD |  |
| 2 | `latitude` | #3 | 原始值 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `longitude` | #4 | 原始值 4 WORD | `0630` BINARY-FLOAT |  |
| 4 | `uncertainty` | #5 | 原始值 2 WORD | `0630` BINARY-FLOAT |  |
| 5 | `unit` | #26 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference），`0000` ABSENT（可选字段） |  |

COORDINATE-GEO 是以纬度、经度和不确定度表示指定天体（行星、卫星、小行星等）上一点的坐标 Value。Value 直接码 `0x065L`，系列为 NUMERIC。它是在 [COORDINATE-EARTH](0x064L-coordinate-earth.md)（`0x064L`）之前加上天体（Globe）Reference 的格式，纬度·经度·不确定度·单位的规则与 COORDINATE-EARTH 相同。

## 布局 {#레이아웃}

```
TAG WORD          0000 0110 0101 LLLL      Codec 0x065L
[Length 扩展 TAG] 总计 15 WORD 以上时
Globe             Reference 记录 1 个 (指向天体的 Reference, Quantifier Identified)
Latitude          4 WORD 原始值, IEEE 754 binary64 (度)
Longitude         4 WORD 原始值, IEEE 754 binary64 (度)
Uncertainty       2 WORD 原始值, IEEE 754 binary32 (Unit 单位)
Unit              Reference 记录 1 个, 或占位标记 0x0000 ABSENT
```

## 解释与有效性 {#해석과-유효성}

- Payload 以 Globe 记录开头。Globe 恰好是一个完整的 Reference 记录，Quantifier 为 Identified。任何指向天体的 Reference 都可使用：[WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)（有名称的天体）、[GEUL](../reference/0x00AL-geul.md)、同一文档的 [LOCAL](../reference/0x005L-local.md)（在文档内定义的天体）、其他文档的天体（[EXTERNAL-POINTER](../reference/0x020L-external-pointer-1word.md)·[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)）等。天体不计其数，有 QID 的天体只是其中一部分。
- Globe 之后是 10 WORD（Latitude 4、Longitude 4、Uncertainty 2）和一个 Unit 记录。读完 Unit 后的游标必须与记录末尾一致。
- Latitude 为 `-90 ≤ φ ≤ 90`，Longitude 为 `-360 ≤ λ ≤ 360`。为了不加改动地承载以 0~360° 计经度的天体坐标系（东经·西经）的值，以及朝相反方向书写的负值，允许的范围比地球更宽。该范围与维基数据 globecoordinate 数据模型（Wikibase `LatLongValue`）相同。`λ` 与 `λ ± 360` 是同一条子午线，GEUL 不做规范化。其余规则（binary64、有限值、轴顺序、Uncertainty·Unit 的含义、未知的表示）与 COORDINATE-EARTH 相同。
- 坐标系依各天体而定，遵循该天体的惯例（行星中心纬度，东经或西经 0~360° 等）。各天体的坐标系另以单独的 GEUL 文档规定。
- 以距离单位（米等）表示的 Uncertainty 是天体表面上的距离。以角度单位（度·角分·角秒）表示的则是与天体大小无关的纬度·经度角度半径。
- 地球（Q2）坐标建议使用 COORDINATE-EARTH。在本格式中写地球也不是 invalid，由比较方将其对齐为相同坐标。
- geul.org 规格文档 `0x00000000/codecs/0x00000650` 在 Latitude·Longitude·Uncertainty 原始值字段上设 [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT（`0630`），在 Unit 记录字段上设 CODEC `000F`·`020F`·`040F`（任意 Reference）·`0000`（ABSENT）。

## 长度 {#길이}

- 总计是 TAG 1 WORD + （Length 扩展 TAG）+ Globe 记录 + 10 WORD + Unit 记录。
- Globe 为 2 WORD（QID 可放入 1 WORD 时）且 Unit 为 ABSENT 时，为 14 WORD，`LLLL=1101`，TAG `065D`。Unit 为 Reference（2 WORD 以上）时超过 15 WORD，使用扩展长度：TAG `065E`，下一个 WORD 为总 WORD 数（[记录与 TAG WORD](../record.md)）。

## 与维基数据的对应 {#위키데이터-대응}

- globe 不是地球（Q2）的 globecoordinate 用本格式书写。Globe = WIKIDATA-QID（globe 条目）。纬度·经度，precision → Uncertainty·Unit 的对应与 COORDINATE-EARTH 相同（precision 是以度为单位的记录分辨率，与天体大小无关，原样搬运）。
- 维基数据样本（坐标声明约 2.4 万条）中的地球以外天体：火星（Q111）、谷神星（Q596）、月球（Q405）、水星（Q308）、金星（Q313）等 23 条。globe 为空的 41 条不转换，而以 UTF8-TEXT 保存原文。

## 示例 {#예시}

火星（Q111）4.5, 137.4，不确定度未知：

```
065D 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 0000 0000 0000
```

- TAG `065D`（Codec `0x065L`，`LLLL=1101`，14 WORD），Globe `0141 006F`（WIKIDATA-QID Q111），Latitude `4012 0000 0000 0000`，Longitude `4061 2CCC CCCC CCCD`，Uncertainty `0000 0000`（+0），Unit `0000`（ABSENT，未知）。
- 文本写法：`COORDINATE-GEO(Q111, 4.5, 137.4, 0, ABSENT)`。

同一点，precision 0.1°（Unit 度 Q28390）：

```
065E 0010 0141 006F 4012 0000 0000 0000 4061 2CCC CCCC CCCD 3DCC CCCD 0141 6EE6
```

- TAG `065E`（`LLLL=1110`，扩展长度），总计 `0010`（16 WORD），Uncertainty `3DCC CCCD`（binary32 0.1），Unit `0141 6EE6`（Q28390）。

## 标准依据 {#표준-근거}

- 含义：[RFC 5870](https://www.rfc-editor.org/rfc/rfc5870) 的纬度·经度·`u`（Unit 为米时）。RFC 5870 的 `crs` 中登记的坐标系只有 `wgs84`，因此地球以外的天体用 GEUL Globe Reference 指定。
- 数值：[IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64（纬度·经度），binary32（不确定度）。
- 经度范围：维基数据 globecoordinate 数据模型 [DataValues Geo `LatLongValue`](https://github.com/DataValues/Geo) 的 `-360 ≤ λ ≤ 360`。

## 未决问题 {#열린-문제}

1. 各天体的坐标系文档：每个天体的纬度定义（行星中心·行星面）以及经度方向·范围。

## 相关页面 {#관련-페이지}

- [Value](_index.md)、[COORDINATE-EARTH](0x064L-coordinate-earth.md)、[WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)、[GEUL](../reference/0x00AL-geul.md)、[LOCAL](../reference/0x005L-local.md)

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000650/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000065000000000
BODY
#1 DECLARE 0x0650
#2 FIELD #1 record
#3 FIELD #1 0x0004
#4 FIELD #1 0x0004
#5 FIELD #1 0x0002
#6 BIND #1 "COORDINATE-GEO"
#7 BIND #2 "globe"
#8 BIND #3 "latitude"
#9 BIND #4 "longitude"
#10 BIND #5 "uncertainty"
#11 CODEC #3 0x0630
#12 CODEC #4 0x0630
#13 CODEC #2 0x0050
#14 CODEC #2 0x00A0
#15 CODEC #2 0x00F0
#16 CODEC #2 0x0140
#17 CODEC #2 0x0200
#18 CODEC #2 0x0250
#19 CODEC #2 0x02A0
#22 CODEC #2 0x02F0
#23 CODEC #2 0x0340
#24 CODEC #2 0x0390
#25 CODEC #5 0x0630
#26 FIELD #1 record
#27 BIND #26 "unit"
#28 CODEC #26 0x000F
#30 CODEC #26 0x020F
#31 CODEC #26 0x040F
#29 CODEC #26 0x0000
```
