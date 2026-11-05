---
title: "COORDINATE-EARTH (0x064L)"
weight: 100
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH 是以纬度、经度和不确定度表示地球上一点的坐标 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `COORDINATE-EARTH`（规格文档 BIND `COORDINATE-EARTH`） |
| TAG ID | `0x064L` |
| Codec ID | `0x00000640` |
| 规格文档 | `0x00000000/codecs/0x00000640/`（DECLARE 目标 `0640`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 4 |
| Kind | Value · 系列：NUMERIC |
| TAG WORD | `0000 0110 0100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 地球（WGS 84）纬度·经度 binary64，不确定度 binary32 及其单位 Reference（ABSENT = 未知） |
| Hugo 页面 | `value/numeric/coordinate-earth.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序即 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `latitude` | #2 | 原始值 4 WORD | `0630` BINARY-FLOAT |  |
| 2 | `longitude` | #3 | 原始值 4 WORD | `0630` BINARY-FLOAT |  |
| 3 | `uncertainty` | #4 | 原始值 2 WORD | `0630` BINARY-FLOAT |  |
| 4 | `unit` | #12 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference），`0000` ABSENT（可选字段） |  |

COORDINATE-EARTH 是以纬度、经度和不确定度表示地球上一点的坐标 Value。Value 直接码 `0x064L`，系列为 NUMERIC。含义与 [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)（geo URI）的 `geo:纬度,经度;u=不确定度`（坐标系 WGS 84）相同，不是以字符串而是以固定宽度数值承载。不确定度须同时写明单位。地球以外天体的坐标使用 [COORDINATE-GEO](0x065L-coordinate-geo.md)（`0x065L`）。

## 布局 {#레이아웃}

```
TAG WORD          0000 0110 0100 LLLL      Codec 0x064L
Latitude          4 WORD 原始值, IEEE 754 binary64 (度)
Longitude         4 WORD 原始值, IEEE 754 binary64 (度)
Uncertainty       2 WORD 原始值, IEEE 754 binary32 (Unit 单位)
Unit              Reference 记录 1 个, 或占位标记 0x0000 ABSENT
```

## 解释与有效性 {#해석과-유효성}

- Payload 为 Latitude 4 WORD、Longitude 4 WORD、Uncertainty 2 WORD，其后恰好一个 Unit 记录。读完 Unit 后的游标必须与记录末尾一致。
- 坐标系为 WGS 84（RFC 5870 的默认 `crs=wgs84`）。
- Latitude·Longitude 是将 Payload WORD 按 big-endian 顺序连接而成的 IEEE 754 binary64（与 [BINARY-FLOAT](0x063L-binary-float.md) 的 binary64 位排布相同）。单位为度（°）。
  - 必须是有限值。NaN 和 ±Infinity 为 invalid。
  - Latitude 为 `-90 ≤ φ ≤ 90`（北为正），Longitude 为 `-180 ≤ λ ≤ 180`（东为正）。
  - 轴顺序为纬度、经度（与 RFC 5870·ISO 6709 相同）。不是 WKB·GeoJSON 的 x（经度）·y（纬度）顺序。
- Uncertainty 是将 2 WORD 按 big-endian 连接而成的 IEEE 754 binary32（与 BINARY-FLOAT 的 binary32 位排布相同）。含义是实际位置在此半径之内，数值按 Unit 单位读取。
  - 必须是有限的 `+0` 以上的值。负数、`-0`（`8000 0000`）、NaN、±Infinity 为 invalid。
  - `0`（存在 Unit 时）：精确坐标。无论以何种单位书写都相同。
- Unit 是指向 Uncertainty 单位的 Reference。不接受 Value。Quantifier 为 Identified。
  - 建议使用维基数据单位条目 [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)：度 Q28390，角分 Q209426，角秒 Q829073，米 Q11573，毫米 Q174789 等。没有 QID 的单位用其他 Reference（LOCAL、GEUL 等）指向。若有多个 Reference 指向同一单位，则 QID 为规范形式。
  - Unit 为米（Q11573）时，Uncertainty 与 RFC 5870 的 `u` 相同。
- **未知**：在 Unit 位置写 [ABSENT](../slot-marker.md)（`0x0000`），Uncertainty 置为 `+0`（`0000 0000`）。与 RFC 5870 中省略 `u` 的情形相同。ABSENT 而 Uncertainty 不是 `+0` 则为 invalid（将表示固定为唯一一种）。
- 不承载海拔。需要时另定格式。维基数据 altitude 在样本中未被使用（0/23,066），若有值则不转换，而以 UTF8-TEXT 保存原文。
- 地球坐标建议使用本格式。在 COORDINATE-GEO 中写地球（Q2）的坐标也不是 invalid，由比较方将其对齐为相同坐标。
- geul.org 规格文档 `0x00000000/codecs/0x00000640` 在 Latitude·Longitude·Uncertainty 原始值字段上设 [CODEC](../edge/0x0BEL-codec.md) BINARY-FLOAT（`0630`）（4 WORD = binary64，2 WORD = binary32），在 Unit 记录字段上设 CODEC `000F`·`020F`·`040F`（任意 Reference）·`0000`（ABSENT）。

## 长度 {#길이}

- 总计是 TAG 1 WORD + 10 WORD + Unit 记录。

| Unit | 总计 | TAG |
|---|---|---|
| ABSENT（1 WORD） | 12 WORD | `064B`（`LLLL=1011`） |
| QID 可放入 1 WORD 时（2 WORD，例：度 Q28390） | 13 WORD | `064C`（`LLLL=1100`） |
| QID 为 2 WORD 时（3 WORD，例：角分 Q209426） | 14 WORD | `064D`（`LLLL=1101`） |
| Unit 记录 4 WORD 以上 | 15 WORD 以上 | 扩展长度（[记录与 TAG WORD](../record.md)） |

- 不设偶·奇 Codec 对。

## 与维基数据的对应 {#위키데이터-대응}

维基数据 globecoordinate：`{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| 维基数据 | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | 本格式（地球）。其他天体用 COORDINATE-GEO |
| latitude, longitude | 原样 binary64（维基数据的值本来就是 binary64，无损失） |
| precision（度） | Uncertainty 与 Unit。见下面的"精度" |
| precision 为 null 或缺失 | Unit = ABSENT，Uncertainty = `+0`（未知） |
| altitude | 舍弃（始终为 null） |

- 维基数据 precision 不是测量误差，而是**记录分辨率**（坐标以多少度·分·秒为单位书写）。GEUL Uncertainty 不改变该值，原样搬运。它不是再加上测量·坐标系误差的半径。

### 精度 {#정밀도}

precision 不经换算直接搬运。在度·角分·角秒中选取能还原原始写法的第一个单位。

| precision 原文（例） | Unit | Uncertainty |
|---|---|---|
| `0.0001`, `0.0000010`, `1`, `10`（10^k 度） | 度 Q28390 | 该值的 binary32 |
| `0.0166667` 之类较短的十进制写法 | 度 Q28390 | 该值的 binary32 |
| `0.016666666666667`（1/60°） | 角分 Q209426 | `1` |
| `0.00027777777777778`（1/3600°） | 角秒 Q829073 | `1` |
| `0.000027777777777778`（1/36000° = 0.1″） | 角秒 Q829073 | `0.1` |

- 正变换：按度、角分（×60）、角秒（×3600）的顺序，取与 precision 乘以单位数之积最接近的 binary32 作为 Uncertainty，并使用下面的逆变换能原样还原 precision 原文的第一个单位。
- 逆变换：将 Uncertainty 的最短十进制写法（能被该 binary32 重新读回的最短数）除以单位数换算为度，并按 Wikibase 在转储中的写法（有效数字 14 位，小于 `1e-4` 用指数写法 `1.0e-6`·`2.7777777777778e-5`）书写。载入的 DB（jsonb）将其以小数写法 `0.0000010`·`0.000027777777777778` 保存。
- 若任何单位都无法还原原文（有效数字 17 位的写法 `0.0002777777777777778`、看起来像计算值的异常值等），则不转换整个坐标，而以 UTF8-TEXT 保存原文。负的 precision 和天体为空的值也相同。
- 维基数据 Q1–Q10000 样本（坐标声明 7,026 条，有 precision 的 6,824 条）：还原出原文的 5,933 条（86.9%；度 4,104，角秒 1,370，角分 459）。未能还原的 891 条中，753 条是有效数字 17 位写法的 1/3600·1/60 系列。

## 示例 {#예시}

柏林 52.516666666667, 13.383333333333，precision 1/60°（角分 1）：

```
064D 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0142 0003 3212
```

- TAG `064D`（14 WORD），Latitude `404A 4222 2222 2251`，Longitude `402A C444 4444 4389`，Uncertainty `3F80 0000`（binary32 1.0），Unit `0142 0003 3212`（WIKIDATA-QID Q209426，角分）。
- 文本写法：`COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`。

不确定度未知的同一点：`064B 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000`（12 WORD，Unit ABSENT）。

## 标准依据 {#표준-근거}

- 含义：[RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — 纬度·经度顺序，`u` 不确定度（米），默认坐标系 WGS 84。Unit 为米时 Uncertainty = `u`。
- 数值：[IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64（纬度·经度），binary32（不确定度）。
- 轴顺序与范围：ISO 6709（Standard representation of geographic point location by coordinates）。
- 单位：维基数据单位条目（QID）。固定宽度排布、Unit 字段和未知的表示是 GEUL 规则。

## 未决问题 {#열린-문제}

1. 海拔。
2. 保存 ISO 6709 字符串原文的格式（COORDINATE-ISO6709）待出现用途时再定。
3. 如何无损搬运维基数据 precision 的有效数字 17 位写法（约占样本的 11%）。

## 相关页面 {#관련-페이지}

- [Value](_index.md)、[COORDINATE-GEO](0x065L-coordinate-geo.md)、[BINARY-FLOAT](0x063L-binary-float.md)、[占位标记](../slot-marker.md)
- Issuer 格式 [POINT2-BINARY64](adhoc.geul.org/point2-binary64.md) 是把坐标系·单位·轴含义交给外部上下文的通用二维点，本格式则是地球上的地理坐标。

## 规格文档原文 {#규격-문서-원문}

用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000640/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000064000000000
BODY
#1 DECLARE 0x0640
#2 FIELD #1 0x0004
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "COORDINATE-EARTH"
#6 BIND #2 "latitude"
#7 BIND #3 "longitude"
#8 BIND #4 "uncertainty"
#9 CODEC #2 0x0630
#10 CODEC #3 0x0630
#11 CODEC #4 0x0630
#12 FIELD #1 record
#13 BIND #12 "unit"
#14 CODEC #12 0x000F
#16 CODEC #12 0x020F
#17 CODEC #12 0x040F
#15 CODEC #12 0x0000
```
