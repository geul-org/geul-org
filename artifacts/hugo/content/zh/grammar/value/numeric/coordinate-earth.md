---
title: "COORDINATE-EARTH"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "COORDINATE-EARTH 是用纬度·经度 binary64、不确定度 binary32、不确定度的单位 Reference 来承载地球（WGS 84）上一个点的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

COORDINATE-EARTH 是用纬度·经度和不确定度表示地球上一个点的坐标 Value。Value 直接码 `0x04`，系列为 NUMERIC。含义与 [RFC 5870](https://www.rfc-editor.org/rfc/rfc5870)（geo URI）的 `geo:纬度,经度;u=不确定度`（坐标系 WGS 84）相同，不是字符串，而是用固定宽度的数值承载。不确定度要同时写明单位。地球之外的天体坐标用 [COORDINATE-GEO](/zh/grammar/value/numeric/coordinate-geo/)（`0x05`）书写。

## 布局

```
TAG WORD          0000 1LLL L000 0100      Codec 0x04
Latitude          4 WORD 原始值，IEEE 754 binary64 (度)
Longitude         4 WORD 原始值，IEEE 754 binary64 (度)
Uncertainty       2 WORD 原始值，IEEE 754 binary32 (Unit 单位)
Unit              Reference 记录 1 个，或占位标记 0x0000 ABSENT
```

## 解读与有效性

- Payload 是 Latitude 4 WORD、Longitude 4 WORD、Uncertainty 2 WORD，之后恰好一条 Unit 记录。读完 Unit 的游标必须与记录末尾吻合。
- 坐标系是 WGS 84（RFC 5870 的默认 `crs=wgs84`）。
- Latitude·Longitude 是把 Payload WORD 按 big-endian 顺序连接而成的 IEEE 754 binary64（与 [BINARY-FLOAT](/zh/grammar/value/numeric/binary-float/) 的 binary64 位布局相同）。单位是度（°）。
  - 必须是有限值。NaN 和 ±Infinity 是 invalid。
  - Latitude 是 `-90 ≤ φ ≤ 90`（北为正），Longitude 是 `-180 ≤ λ ≤ 180`（东为正）。
  - 轴顺序是纬度、经度（与 RFC 5870·ISO 6709 相同）。不是 WKB·GeoJSON 的 x（经度）·y（纬度）顺序。
- Uncertainty 是把 2 WORD 按 big-endian 连接而成的 IEEE 754 binary32（与 BINARY-FLOAT 的 binary32 位布局相同）。表示实际位置在这个半径之内，值按 Unit 单位读取。
  - 必须是有限的 `+0` 以上。负数、`-0`（`8000 0000`）、NaN、±Infinity 是 invalid。
  - `0`（有 Unit 时）：精确坐标。无论用哪个单位书写都相同。
- Unit 是指向 Uncertainty 单位的 Reference。不接受 Value。Quantifier 是 Identified（`000`）。
  - 建议使用 Wikidata 单位条目 [WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/)：度 Q28390、角分 Q209426、角秒 Q829073、米 Q11573、毫米 Q174789 等。没有 QID 的单位，用其他 Reference（LOCAL、GEUL 等）指向。如果指向同一单位的 Reference 有多个，QID 为规范形式。
  - Unit 为米（Q11573）时，Uncertainty 与 RFC 5870 的 `u` 相同。
- **未知**：Unit 位置写 [ABSENT](/zh/grammar/reference/slot-marker/)（`0x0000`），Uncertainty 设为 `+0`（`0000 0000`）。与 RFC 5870 中省略 `u` 的情形相同。ABSENT 而 Uncertainty 不是 `+0` 则 invalid（把表示固定为一种）。
- 不承载海拔。需要时用单独的格式规定。Wikidata altitude 在样本中没有使用（0/23,066），有值时不转换，而把原文以 UTF8-TEXT 保留。
- 地球坐标建议使用本格式。在 COORDINATE-GEO 中写地球（Q2）的坐标也不是 invalid，由比较一方将其对齐为同一坐标。
- geul.org 规格文档 `0x0000/0x0000000000000804` 在 Latitude·Longitude·Uncertainty 原始值字段上放 [CODEC](/zh/grammar/edge/codec/) BINARY-FLOAT（`0803`）（4 WORD = binary64，2 WORD = binary32），在 Unit 记录字段上放 CODEC `0780`（任意 Reference）·`0000`（ABSENT）。

## 长度

- 总计是 TAG 1 WORD + 10 WORD + Unit 记录。

| Unit | 总计 | TAG |
|---|---|---|
| ABSENT（1 WORD） | 12 WORD | `0D84`（`LLLL=1011`） |
| QID 能放入 1 WORD 时（2 WORD，例：度 Q28390） | 13 WORD | `0E04`（`LLLL=1100`） |
| QID 为 2 WORD 时（3 WORD，例：角分 Q209426） | 14 WORD | `0E84`（`LLLL=1101`） |
| Unit 记录 4 WORD 以上 | 15 WORD 以上 | 扩展长度（[记录与 TAG WORD](/zh/grammar/record/)） |

- 不设偶数·奇数 Codec 对。

## 与 Wikidata 的对应

Wikidata globecoordinate：`{"latitude":52.516666666667,"longitude":13.383333333333,"altitude":null,"precision":0.016666666666667,"globe":"http://www.wikidata.org/entity/Q2"}`

| Wikidata | COORDINATE-EARTH |
|---|---|
| globe `…/entity/Q2` | 本格式（地球）。其他天体用 COORDINATE-GEO |
| latitude, longitude | 原样 binary64（Wikidata 的值本来就是 binary64，所以没有损失） |
| precision（度） | Uncertainty 与 Unit。见下面的"精度" |
| precision 为 null 或没有 | Unit = ABSENT，Uncertainty = `+0`（未知） |
| altitude | 舍弃（始终为 null） |

- Wikidata precision 不是测量误差，而是**记录分辨率**（坐标是用几度·分·秒为单位写的）。GEUL Uncertainty 原样转换这个值，不改变它。它不是叠加了测量·坐标系误差的半径。

### 精度

不经换算地转换 precision。在度·角分·角秒中选择第一个能还原原来写法的单位。

| precision 原文（例） | Unit | Uncertainty |
|---|---|---|
| `0.0001`、`0.0000010`、`1`、`10`（10^k 度） | 度 Q28390 | 该值的 binary32 |
| `0.0166667` 这样的短十进制写法 | 度 Q28390 | 该值的 binary32 |
| `0.016666666666667`（1/60°） | 角分 Q209426 | `1` |
| `0.00027777777777778`（1/3600°） | 角秒 Q829073 | `1` |
| `0.000027777777777778`（1/36000° = 0.1″） | 角秒 Q829073 | `0.1` |

- 正向转换：按度、角分（×60）、角秒（×3600）的顺序，把 precision 乘以单位数得到的值取最接近的 binary32 作为 Uncertainty，使用下面的逆向转换能原样还原 precision 原文的第一个单位。
- 逆向转换：把 Uncertainty 最短的十进制写法（用该 binary32 重新读取时最短的数）除以单位数换算为度，并按 Wikibase 在转储中书写的方式（有效数字 14 位，小于 `1e-4` 用指数写法 `1.0e-6`·`2.7777777777778e-5`）书写。已导入的数据库（jsonb）把它保存为小数写法 `0.0000010`·`0.000027777777777778`。
- 如果没有任何单位能还原原文（有效数字 17 位的写法 `0.0002777777777777778`、看起来像计算值的异常值等），则不转换整个坐标，把原文以 UTF8-TEXT 保留。负的 precision 和天体为空的值也一样。
- Wikidata Q1–Q10000 样本（坐标声明 7,026 条，有 precision 的 6,824 条）：还原了原文的 5,933 条（86.9%；度 4,104、角秒 1,370、角分 459）。没能还原的 891 条中，753 条是有效数字 17 位写法的 1/3600·1/60 系列。

## 示例

柏林 52.516666666667, 13.383333333333，precision 1/60°（角分 1）：

```
0E84 404A 4222 2222 2251 402A C444 4444 4389 3F80 0000 0120 0003 3212
```

- TAG `0E84`（14 WORD），Latitude `404A 4222 2222 2251`，Longitude `402A C444 4444 4389`，Uncertainty `3F80 0000`（binary32 1.0），Unit `0120 0003 3212`（WIKIDATA-QID Q209426，角分）。
- 文本写法：`COORDINATE-EARTH(52.516666666667, 13.383333333333, 1, Q209426)`。

不确定度未知的同一个点：`0D84 404A 4222 2222 2251 402A C444 4444 4389 0000 0000 0000`（12 WORD，Unit ABSENT）。

## 标准依据

- 含义：[RFC 5870, A Uniform Resource Identifier for Geographic Locations ('geo' URI)](https://www.rfc-editor.org/rfc/rfc5870) — 纬度·经度顺序、`u` 不确定度（米）、默认坐标系 WGS 84。Unit 为米时，Uncertainty = `u`。
- 数值：[IEEE 754](https://standards.ieee.org/ieee/754/6210/) binary64（纬度·经度）、binary32（不确定度）。
- 轴顺序与范围：ISO 6709（Standard representation of geographic point location by coordinates）。
- 单位：Wikidata 单位条目（QID）。固定宽度布局、Unit 字段和未知的表示是 GEUL 规则。

## 未决问题

1. 海拔。
2. 保留 ISO 6709 字符串原文的格式（COORDINATE-ISO6709），有了用途再定。
3. 无损转换 Wikidata precision 的有效数字 17 位写法（约占样本的 11%）的方法。

## 相关页面

- [Value](/zh/grammar/value/)、[COORDINATE-GEO](/zh/grammar/value/numeric/coordinate-geo/)、[BINARY-FLOAT](/zh/grammar/value/numeric/binary-float/)、[占位标记](/zh/grammar/reference/slot-marker/)
- Issuer 格式 [POINT2-BINARY64](/zh/grammar/value/vector/point2-binary64/) 是把坐标系·单位·轴含义交给外部上下文的通用二维点，而本格式是地球上的地理坐标。
