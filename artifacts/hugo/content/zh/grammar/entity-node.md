---
title: "实体节点"
weight: 20
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "entity", "SIDX", "quantification"]
summary: "用于识别人物、地点、事物、组织等实体的固定长度4字（64位）Node。3位Mode表达量化/数，6位EntityType分类64种上位类型，48位Attributes编码各类型的语义属性。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**Entity Node** 是 GEUL 流中用于识别实体（人物、地点、事物、组织、概念等）的**固定长度4字（64位）数据包**。

## SIDX 本质

| 特性 | 说明 |
|------|------|
| **Non-unique** | 同一 SIDX 可对应多个实体 |
| **Multi-SIDX** | 一个实体可拥有多个 SIDX（按时点/角色区分） |
| **位 = 语义** | 位的位置本身表示属性 |
| **抽象/具体连续** | 通过 Mode 和 Attributes 填充程度区分 |

**示例：**
- 特朗普（房地产商人）→ SIDX_A
- 特朗普（总统）→ SIDX_B（不同的 SIDX）
- "Human + Male + Korea" → 抽象的"韩国男性"
- "Human + Male + Korea + 1946 + Business + ..." → 几乎锁定特定人物

## 设计原则

**放弃内嵌Q标识符：**
- 将全部位投入纯语义对齐
- 最大化 WMS SIMD 过滤性能
- Q标识符通过[三元组](../triple-edge/)单独关联：`(Entity_SIDX, P-外部ID, "Q12345")`

**无需 Serial 位：**
- WMS 查询分两步：SIMD 范围缩小 → 范围内细节检查
- Serial 是无意义数字，对 SIMD 无贡献
- 将这些位投入语义对齐可在第一步进一步缩小范围

## 位布局（4字 = 64位）

```
1st WORD (16位)
┌─────────┬──────┬────────────┐
│ Prefix  │ Mode │ EntityType │
│  7bit   │ 3bit │   6bit     │
└─────────┴──────┴────────────┘

2nd WORD (16位)
┌─────────────────────────────┐
│     Attributes 高16位        │
└─────────────────────────────┘

3rd WORD (16位)
┌─────────────────────────────┐
│     Attributes 中16位        │
└─────────────────────────────┘

4th WORD (16位)
┌─────────────────────────────┐
│     Attributes 低16位        │
└─────────────────────────────┘
```

| 字段 | 位 | 大小 | 说明 |
|------|------|------|------|
| Prefix | 1-7 | 7 | `0001001` (Entity Node) |
| Mode | 8-10 | 3 | 8种量化/数模式 |
| EntityType | 11-16 | 6 | 64种上位类型 |
| Attributes | 17-64 | **48** | 各类型可变模式 |

## Mode（3位）

Mode 将实体的**量化（Quantification）与数（Number）**统一用3位表达。

| 代码 | 二进制 | 含义 | 示例 |
|------|------|------|------|
| 0 | 000 | **注册实体** | 李白、三星电子、BTS |
| 1 | 001 | 特定单数 | "那个人" |
| 2 | 010 | 特定少数 | "那几个人" |
| 3 | 011 | 特定多数 | "那些人" |
| 4 | 100 | 全称 | "所有~" |
| 5 | 101 | 存在 | "某个~" |
| 6 | 110 | 不特定 | "随便哪个~" |
| 7 | 111 | 总称 | "~一般" |

### 注册实体（Mode=0）

- 与维基数据 Q标识符、WordNet Synset 等外部 ID 映射的实体
- Q标识符本身通过三元组关联：`(Entity_SIDX, P-外部ID, "Q12345")`
- **与数（Number）概念无关**：三星电子是"一个"但说单数不太恰当，BTS 是团体但作为一个实体

### 代词/抽象（Mode=1~7）

- 通过 EntityType + Attributes 指定语义范围
- 位填充越多越具体
- 例：Human(Type) + Male(Attr) + Korea(Attr) = "韩国男性"

## EntityType（6位 = 64种）

基于维基数据 P31（instance of）频率统计分配64种上位类型。细分类通过 Attributes 内的子分类位处理。

| 范围 | 类别 | 类型数 | 代表类型 |
|------|----------|---------|-----------|
| 0x00-0x07 | 生物/人物 | 8 | Human, Taxon, Gene, Protein |
| 0x08-0x0B | 化学/物质 | 4 | Chemical, Compound, Mineral, Drug |
| 0x0C-0x13 | 天体 | 8 | Star, Galaxy, Asteroid, Planet |
| 0x14-0x1B | 地形/自然 | 8 | Mountain, River, Lake, Island |
| 0x1C-0x23 | 地点/行政 | 8 | Settlement, Village, Street, Park |
| 0x24-0x2B | 建筑物 | 8 | Building, Church, School, Bridge |
| 0x2C-0x2F | 组织 | 4 | Organization, Business, PoliticalParty |
| 0x30-0x3B | 创作物 | 12 | Painting, Document, Film, Album |
| 0x3C-0x3F | 事件/其他 | 4 | SportsSeason, Event, Election, Other |

### 代码表（全部64种）

| 代码 | 类型 | Q-ID | 实体数 |
|------|------|------|--------|
| 0x00 | Human | Q5 | 12.5M |
| 0x01 | Taxon | Q16521 | 3.8M |
| 0x02 | Gene | Q7187 | 1.2M |
| 0x03 | Protein | Q8054 | 1.0M |
| 0x04 | CellLine | Q21014462 | 154K |
| 0x05 | FamilyName | Q101352 | 662K |
| 0x06 | GivenName | Q202444 | 128K |
| 0x07 | FictionalCharacter | Q15632617 | 98K |
| 0x08 | Chemical | Q113145171 | 1.3M |
| 0x09 | Compound | Q11173 | 1.1M |
| 0x0A | Mineral | Q7946 | 62K |
| 0x0B | Drug | Q12140 | 45K |
| 0x0C | Star | Q523 | 3.6M |
| 0x0D | Galaxy | Q318 | 2.1M |
| 0x0E | Asteroid | Q3863 | 249K |
| 0x0F | Quasar | Q83373 | 178K |
| 0x10 | Planet | Q634 | 15K |
| 0x11 | Nebula | Q12057 | 8K |
| 0x12 | StarCluster | Q168845 | 5K |
| 0x13 | Moon | Q2537 | 3K |
| 0x14 | Mountain | Q8502 | 518K |
| 0x15 | Hill | Q54050 | 321K |
| 0x16 | River | Q4022 | 427K |
| 0x17 | Lake | Q23397 | 292K |
| 0x18 | Stream | Q47521 | 194K |
| 0x19 | Island | Q23442 | 153K |
| 0x1A | Bay | Q39594 | 25K |
| 0x1B | Cave | Q35509 | 20K |
| 0x1C | Settlement | Q486972 | 580K |
| 0x1D | Village | Q532 | 245K |
| 0x1E | Hamlet | Q5084 | 148K |
| 0x1F | Street | Q79007 | 711K |
| 0x20 | Cemetery | Q39614 | 298K |
| 0x21 | AdminRegion | Q15284 | 100K |
| 0x22 | Park | Q22698 | 45K |
| 0x23 | ProtectedArea | Q473972 | 35K |
| 0x24 | Building | Q41176 | 292K |
| 0x25 | Church | Q16970 | 286K |
| 0x26 | School | Q9842 | 242K |
| 0x27 | House | Q3947 | 235K |
| 0x28 | Structure | Q811979 | 216K |
| 0x29 | SportsVenue | Q1076486 | 145K |
| 0x2A | Castle | Q23413 | 42K |
| 0x2B | Bridge | Q12280 | 38K |
| 0x2C | Organization | Q43229 | 531K |
| 0x2D | Business | Q4830453 | 242K |
| 0x2E | PoliticalParty | Q7278 | 35K |
| 0x2F | SportsTeam | Q847017 | 95K |
| 0x30 | Painting | Q3305213 | 1.1M |
| 0x31 | Document | Q49848 | 45M |
| 0x32 | LiteraryWork | Q7725634 | 395K |
| 0x33 | Film | Q11424 | 335K |
| 0x34 | Album | Q482994 | 303K |
| 0x35 | MusicalWork | Q105543609 | 195K |
| 0x36 | TVEpisode | Q21191270 | 177K |
| 0x37 | VideoGame | Q7889 | 172K |
| 0x38 | TVSeries | Q5398426 | 85K |
| 0x39 | Patent | Q43305660 | 289K |
| 0x3A | Software | Q7397 | 13K |
| 0x3B | Website | Q35127 | 12K |
| 0x3C | SportsSeason | Q27020041 | 183K |
| 0x3D | Event | Q1656682 | 10K |
| 0x3E | Election | Q40231 | 11K |
| 0x3F | Other | - | 扩展用 |

## Attributes（48位）

每种 EntityType 以不同含义解读的**类型可变模式**。高频属性分配更多位，直接用于 WMS SIMD 过滤。

### Human (0x00) Attributes

```
┌──────────┬────────┬────────┬──────┬────────┬────────┬─────────┬──────────┬────────────┬──────────┐
│ 子分类   │ 职业   │ 国籍   │ 时代 │ 年代   │ 性别   │ 知名度  │ 语言     │ 出生地区   │ 活动领域 │
│  5bit    │  6bit  │  8bit  │ 4bit │  4bit  │  2bit  │  3bit   │  6bit    │   6bit     │   4bit   │
└──────────┴────────┴────────┴──────┴────────┴────────┴─────────┴──────────┴────────────┴──────────┘
offset:  0        5       11      19     23      27      29        32         38          44
```

### Star (0x0C) Attributes

```
┌────────────┬────────────┬──────────┬──────────┬────────┬────────┬──────────┬──────────┬────────┬────────┐
│ 星座       │ 光谱型     │ 光度等级 │ 视星等   │ 赤经   │ 赤纬   │ 标志位   │ 视向速度 │ 红移   │ 视差   │
│   7bit     │    4bit    │   3bit   │  4bit    │  4bit  │  4bit  │   6bit   │   5bit   │  5bit  │  4bit  │
└────────────┴────────────┴──────────┴──────────┴────────┴────────┴──────────┴──────────┴────────┴────────┘
```

**标志位定义：**
- bit0: IR（红外源）
- bit1: Radio（射电源）
- bit2: X-ray（X射线源）
- bit3: Binary（双星）
- bit4: Variable（变星）
- bit5: HighPM（高自行）

## 运算

### Entity 生成

```python
def make_entity(
    mode: int,           # 3位
    entity_type: int,    # 6位
    attrs: int           # 48位
) -> bytes:
    PREFIX = 0b0001001   # 7位 (Entity Node)

    word1 = (PREFIX << 9) | (mode << 6) | entity_type
    word2 = (attrs >> 32) & 0xFFFF
    word3 = (attrs >> 16) & 0xFFFF
    word4 = attrs & 0xFFFF

    return (
        word1.to_bytes(2, 'big') +
        word2.to_bytes(2, 'big') +
        word3.to_bytes(2, 'big') +
        word4.to_bytes(2, 'big')
    )
```

### Entity 解析

```python
def parse_entity(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')
    word2 = int.from_bytes(data[2:4], 'big')
    word3 = int.from_bytes(data[4:6], 'big')
    word4 = int.from_bytes(data[6:8], 'big')

    prefix = (word1 >> 9) & 0x7F
    mode = (word1 >> 6) & 0x7
    entity_type = word1 & 0x3F
    attrs = (word2 << 32) | (word3 << 16) | word4

    return {
        'prefix': prefix,
        'mode': mode,
        'entity_type': entity_type,
        'attrs': attrs
    }
```

## 示例

### 注册实体：李白

```python
# 李白 (Q9694)
li_bai = make_entity(
    mode=0,              # 注册实体
    entity_type=0x00,    # Human
    attrs=(
        (0x06 << 43) |   # 子分类: Military
        (0x01 << 37) |   # 职业: Poet
        (0x52 << 29) |   # 国籍: China
        (0x3 << 25) |    # 时代: Tang Dynasty
        (0x0 << 21) |    # 年代: 700s
        (0x01 << 19) |   # 性别: Male
        (0x7 << 16)      # 知名度: 1000+
    )
)
# Q标识符关联: Triple(li_bai_SIDX, P-外部ID, "Q9694")
```

### 抽象："所有中国男性"

```python
all_chinese_men = make_entity(
    mode=4,              # 全称（所有）
    entity_type=0x00,    # Human
    attrs=(
        (0x52 << 29) |   # 国籍: China
        (0x01 << 19)     # 性别: Male
    )
)
```

## 下位类型映射

维基数据中许多类型是64种 EntityType 的下位类型。编码器根据 P31 值路由到合适的上位类型。

| 下位类型 (P31) | 上位类型 | 实体数 |
|-----------------|-----------|--------|
| Q13442814 (scholarly article) | Document (0x31) | 45.2M |
| Q67206691 (infrared source) | Star (0x0C) | 2.6M |
| Q13100073 (village of China) | Village (0x1D) | 592K |

## 覆盖率

| 项目 | 数值 |
|------|------|
| 维基数据全部实体 | 117,419,925 |
| Wikimedia 内部（排除） | 8,565,353 (7.3%) |
| SIDX 目标 | 108,854,572 (92.7%) |
| 64种类型直接覆盖 | 36,295,074 (33.3%) |
| 下位类型吸收 | 71,842,429 (66.0%) |
| Other 兜底 | 717,069 (0.7%) |
| **最终覆盖率** | **100%** |
| **冲突率** | **< 0.01%** |

## Q标识符关联

Entity Node 不内嵌 Q标识符，而是通过[三元组边](../triple-edge/)单独关联。

```
Subject:  Entity_SIDX (64位)
Property: P-外部ID (例: P-Wikidata)
Object:   "Q12345" (字符串或整数)
```
