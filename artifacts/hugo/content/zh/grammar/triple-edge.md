---
title: "三元组边"
weight: 30
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "triple", "property"]
summary: "以(Subject, Property, Object)形式表达关系与属性的Edge类型。基本模式4字与扩展模式5字的双重结构，对Top 63高频属性进行优化。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Triple Edge 是以 `(Subject, Property, Object)` 形式表达**关系/属性**的 Edge 类型。

## 双模式设计

- **基本模式（4字）：** PropCode 0~62（Top 63 属性）
- **扩展模式（5字）：** PropCode=63时覆盖全部 P-ID（语义对齐16位）

## 基本模式（4字 = 64位）

```
1st WORD (16位)
┌────────────────────┬────────────────────┐
│      Prefix        │     PropCode       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD: Edge TID (16位)
3rd WORD: Subject TID (16位)
4th WORD: Object TID (16位)
```

| 字段 | 位 | 说明 |
|------|------|------|
| Prefix | 10 | `1100 000 001` |
| PropCode | 6 | 0~62: Top 63 属性, 63: 扩展模式 |
| Edge TID | 16 | 此 Edge 的 TID |
| Subject TID | 16 | 主语 Entity/Node TID |
| Object TID | 16 | 宾语 Entity/Node/Quantity TID |

## 扩展模式（5字 = 80位）

PropCode 为63时，第3字追加16位 P-ID。

```
1st WORD: [Prefix 10bit] + [PropCode=63 6bit]
2nd WORD: Edge TID (16位)
3rd WORD: P-ID 语义对齐 (16位)
4th WORD: Subject TID (16位)
5th WORD: Object TID (16位)
```

## Top 63 属性（PropCode 0~62）

基于维基数据使用频率选定的属性。

### 分类/类型（Code 0~7）

| Code | P-ID | 属性名 | 说明 |
|------|------|--------|------|
| 0 | P31 | instance of | ~的实例 |
| 1 | P279 | subclass of | ~的子类 |
| 2 | P361 | part of | ~的部分 |
| 3 | P527 | has part | 包含~ |
| 4 | P1552 | has quality | 属性/特性 |
| 5 | P460 | same as | 相同 |
| 6 | P1889 | different from | 不同 |
| 7 | P156 | followed by | 后续 |

### 空间/位置（Code 8~15）

| Code | P-ID | 属性名 | 说明 |
|------|------|--------|------|
| 8 | P17 | country | 国家 |
| 9 | P131 | located in | 位置（行政区） |
| 10 | P276 | location | 位置（地点） |
| 11 | P625 | coordinate | 坐标 |
| 12 | P30 | continent | 大洲 |
| 13 | P36 | capital | 首都 |
| 14 | P150 | contains | 包含（地区） |
| 15 | P206 | located next to | 相邻水域 |

### 时间（Code 16~23）

| Code | P-ID | 属性名 | 说明 |
|------|------|--------|------|
| 16 | P569 | date of birth | 出生日期 |
| 17 | P570 | date of death | 逝世日期 |
| 18 | P571 | inception | 成立日期 |
| 19 | P576 | dissolved | 解散日期 |
| 20 | P577 | publication date | 发布日期 |
| 21 | P580 | start time | 开始时间 |
| 22 | P582 | end time | 结束时间 |
| 23 | P585 | point in time | 时间点 |

### 人物基本（Code 24~31）

| Code | P-ID | 属性名 | 说明 |
|------|------|--------|------|
| 24 | P19 | place of birth | 出生地 |
| 25 | P20 | place of death | 逝世地 |
| 26 | P21 | sex or gender | 性别 |
| 27 | P27 | citizenship | 国籍 |
| 28 | P735 | given name | 名 |
| 29 | P734 | family name | 姓 |
| 30 | P1559 | name in native language | 本名 |
| 31 | P742 | pseudonym | 笔名/艺名 |

### 关系/隶属（Code 32~39）

| Code | P-ID | 属性名 | 说明 |
|------|------|--------|------|
| 32 | P22 | father | 父亲 |
| 33 | P25 | mother | 母亲 |
| 34 | P26 | spouse | 配偶 |
| 35 | P40 | child | 子女 |
| 36 | P3373 | sibling | 兄弟姐妹 |
| 37 | P463 | member of | 所属 |
| 38 | P108 | employer | 雇主 |
| 39 | P1027 | conferred by | 授予机构 |

### 职业/活动（Code 40~47）

| Code | P-ID | 属性名 | 说明 |
|------|------|--------|------|
| 40 | P106 | occupation | 职业 |
| 41 | P39 | position held | 职位 |
| 42 | P69 | educated at | 学历 |
| 43 | P101 | field of work | 领域 |
| 44 | P1344 | participant in | 参加（事件） |
| 45 | P166 | award received | 获奖 |
| 46 | P800 | notable work | 代表作 |
| 47 | P1412 | languages spoken | 使用语言 |

### 媒体/标识（Code 48~55）

| Code | P-ID | 属性名 | 说明 |
|------|------|--------|------|
| 48 | P18 | image | 图像 |
| 49 | P154 | logo | 标志 |
| 50 | P41 | flag image | 国旗/旗帜 |
| 51 | P373 | Commons category | 维基媒体 |
| 52 | P856 | official website | 官方网站 |
| 53 | P214 | VIAF ID | VIAF |
| 54 | P227 | GND ID | GND |
| 55 | P213 | ISNI | ISNI |

### 作品/创作（Code 56~62）

| Code | P-ID | 属性名 | 说明 |
|------|------|--------|------|
| 56 | P50 | author | 作者 |
| 57 | P57 | director | 导演 |
| 58 | P86 | composer | 作曲家 |
| 59 | P175 | performer | 演奏者/歌手 |
| 60 | P136 | genre | 类型 |
| 61 | P364 | original language | 原语言 |
| 62 | P123 | publisher | 出版社 |

Code 63 作为**扩展模式标记**保留。

## PropCode 总览

```
┌─────────────────────────────────────────────┐
│  0~7:   分类/类型 (P31, P279, ...)          │
│  8~15:  空间/位置 (P17, P131, ...)          │
│  16~23: 时间 (P569, P570, ...)              │
│  24~31: 人物基本 (P19, P20, ...)            │
│  32~39: 关系/隶属 (P22, P25, ...)           │
│  40~47: 职业/活动 (P106, P39, ...)          │
│  48~55: 媒体/标识 (P18, P856, ...)          │
│  56~62: 作品/创作 (P50, P57, ...)           │
├─────────────────────────────────────────────┤
│  63: 扩展模式标记                            │
└─────────────────────────────────────────────┘
```

## 示例

### 基本模式："Apple是一家公司"

```
P31 (instance of) → PropCode = 0

Triple Edge:
  1st: [1100 000 001] + [000000]  - Prefix + PropCode 0
  2nd: [TID: 0x0101]              - Edge TID
  3rd: [TID: 0x0010]              - Apple (Subject)
  4th: [TID: 0x0020]              - 公司 (Object)

总计: 4字
```

### 扩展模式："埃菲尔铁塔的高度是330m"

```
P2048 (height) → 不在 Top 63 中 → 扩展模式

Triple Edge:
  1st: [1100 000 001] + [111111]  - Prefix + Ext(63)
  2nd: [TID: 0x0102]              - Edge TID
  3rd: [0xA800]                   - P2048 语义对齐
  4th: [TID: 0x0030]              - 埃菲尔铁塔 (Subject)
  5th: [TID: 0x0050]              - 330m Quantity (Object)

总计: 5字
```

## 解析

```python
def parse_triple_edge(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000001, "Not Triple Edge"

    prop_code = word1 & 0x3F

    if prop_code < 63:
        # 基本模式 (4字)
        return {
            'mode': 'basic',
            'prop_code': prop_code,
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[4:6], 'big'),
            'object_tid': int.from_bytes(data[6:8], 'big'),
            'words': 4
        }
    else:
        # 扩展模式 (5字)
        return {
            'mode': 'extended',
            'p_id': int.from_bytes(data[4:6], 'big'),
            'edge_tid': int.from_bytes(data[2:4], 'big'),
            'subject_tid': int.from_bytes(data[6:8], 'big'),
            'object_tid': int.from_bytes(data[8:10], 'big'),
            'words': 5
        }
```
