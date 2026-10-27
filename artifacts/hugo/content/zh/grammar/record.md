---
title: "记录与 TAG WORD"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "所有记录都以 16 位 TAG WORD 开头。由 3 位 Prefix、2 位 Kind、4 位 Length、7 位 Codec 决定记录的种类和长度。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 数据是记录的序列。每条记录都以一个 TAG WORD 开头。

## 记录布局

```
TAG WORD (16 位)
┌──────────┬─────────┬──────────┬─────────────────────┐
│  Prefix  │  Kind   │  Length  │        Codec        │
│   3bit   │  2bit   │   4bit   │        7bit         │
│   000    │   KK    │   LLLL   │       CCCCCCC       │
└──────────┴─────────┴──────────┴─────────────────────┘
[Length 扩展 TAG]
[Codec 扩展 TAG]
[Codec 专属 TAG]
Payload
```

- TAG WORD 是 `000K KLLL LCCC CCCC`。
- 扩展 TAG 只能按上面的顺序放置。Length 扩展 TAG 总是紧跟在 TAG WORD 之后。
- Codec 专属 TAG 和 Payload 的构成由各 Codec 规格规定。Codec 专属 TAG 的长度不写在 TAG WORD 里。因为解读 Payload 本来就需要 codebook。
- 有子格式的 Codec 用 1 WORD 的 Codec 专属 TAG 指定子格式（Edge WORLD 等）。

## 字节序

- 规范序列化为大端序。
- 位字段从最高位开始排列。
- WORD 内先写高字节，由多个 WORD 组成的值先写高位 WORD。
- 内存中的表示由实现自由决定。

## Kind (2 位)

| 值 | Kind | TAG WORD | 定义 |
|---|---|---|---|
| `00` | Reference | `0000 0LLL LCCC CQQQ` | 指向目标。由 Codec 和目标 ID 识别目标 |
| `01` | Value | `0000 1LLL LCCC CCCC` | 承载值本身。由 Codec 决定 Payload 的解读 |
| `10` | Edge | `0001 0LLL LCCC CCCC` | 把其他记录作为构成要素组合起来。由 Codec 决定构成要素的角色和顺序 |
| `11` | Meta | `0001 1LLL LCCC CCCC` | 谈论文档与记录 |

- Kind 是 Codec 的不变属性。一旦分配了 Codec，就不会改变其 Kind。
- Value 和 Edge 是同样的"Codec + Payload"形式。只有 Edge 把其他记录作为构成要素。
- Reference 把 7 位 Codec 拆成 4 位 Codec 和 3 位 Quantifier 使用（[Reference](/zh/grammar/reference/)）。

## Length (4 位)

Length 是记录所占的**总 WORD 数**。包括 TAG WORD、扩展 TAG、Payload 以及最后一个 WORD 的填充。

| 值 | 含义 |
|---|---|
| `0000`~`1101` | 1~14 WORD（值 + 1） |
| `1110` | 扩展长度 1：后面 1 WORD 为总 WORD 数（15~65,535） |
| `1111` | 扩展长度 2：后面 2 WORD 为总 WORD 数（65,536~2³²−1） |

- 1~14 WORD 必须用直接长度书写。更宽的写法不是规范形式。
- 扩展长度的总 WORD 数也包括 Length 扩展 TAG 自身。
- 不存在超过 2³²−1 WORD 的记录。
- 1 WORD 记录是没有 Payload 的单个 TAG WORD。仅在 Codec 规格允许时使用（例：Meta `BODY`、`END`、空字节序列、占位标记）。
- 即使没有 codebook，也可以用 `下一条记录位置 = 当前记录起点 + Length` 跳过记录。

## Codec (7 位)

| 值 | 名称 | 含义 |
|---|---|---|
| `0x00`~`0x7B` | 直接码 | 仅凭 TAG WORD 即可确定 Codec |
| `0x7C` | ISSUER-1WORD | Codec 扩展 TAG 中放 Issuer 1 WORD 和格式编号 1 WORD |
| `0x7D` | ISSUER-2WORD | Codec 扩展 TAG 中放 Issuer 2 WORD 和格式编号 1 WORD |
| `0x7E` | ISSUER-4WORD | Codec 扩展 TAG 中放 Issuer 4 WORD 和格式编号 1 WORD |
| `0x7F` | ISSUER-16WORD | Codec 扩展 TAG 中放 Issuer 16 WORD 和格式编号 1 WORD |

- Codec 编号空间对每种 Kind 各自独立。编号相同但 Kind 不同，则是不同的 Codec。
- 不是直接码的 Codec 是 `(Issuer, 格式编号)` 对。格式编号由该 Issuer 定义（[Issuer 与公布](/zh/grammar/issuer/)）。扩展格式放在制定该格式的组织的 Issuer 之下。
- 已有直接码的 Codec 不再作为 Issuer 格式另行登记。
- Issuer 格式只存在于 Value 和 Edge。Reference 使用 4 位 Codec，Meta 是只由 GEUL 定义的通用规范。
- Codec 和格式编号的高位表示系列（Value·Edge）或类（Meta）。没有 codebook 也能知道系列。
- 直接码无法收回。只有已确认使用频率的格式才放入直接码。

## Issuer 格式记录

```
TAG WORD          Codec = 0x7C~0x7F
[Length 扩展 TAG]
Issuer            1/2/4/16 WORD (宽度由 Codec 决定)
格式编号          1 WORD。高位为系列
Payload           格式规定的值
```

- 不认识该格式的解码器只知道格式编号的系列，并跳过 Payload。

## 可变长度字节序列

文本、URI、语言标签、不明字节序列这类长度以字节为单位的值，把 Codec（或格式编号）分配为**偶数·奇数对**。

- Codec 的最低位为 `0` 表示字节数为偶数，为 `1` 表示字节数为奇数。
- 字节数 = `2 × Payload WORD 数 − 最低位`。没有 Byte Count 字段。
- 为奇数时，最后一个 WORD 的低字节是 `0x00` 填充。不是 `0x00` 则拒绝。
- 空字节序列是偶数 Codec 的 1 WORD 记录（仅 TAG WORD）。
- UUID·摘要·地址等大小固定的值不设对。

## 示例：读取 TAG WORD

来读一下 `148A`。

```
0x148A = 0001 0100 1000 1010
         000 | 10 | 1001 | 0001010
Prefix 000, Kind 10(Edge), Length 1001(10 WORD), Codec 0x0A(TRIPLE)
```

这条记录是 10 WORD 的 Edge，Codec 为 TRIPLE。即使没有 codebook，也能知道下一条记录在 10 WORD 之后。

## 占位标记

TAG WORD `0x0000`~`0x0007` 是保留 Reference Codec `0000` 的 1 WORD 记录。它不指向目标，只填充记录字段的位置（[占位标记](/zh/grammar/reference/slot-marker/)）。

```
0x0000~0x0007 = 0000 0000 0000 0MMM
                Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = 标记编号
```

| WORD | 名称 | 含义 | 谈论的是什么 | 逻辑 | 世界假设 | Wikidata |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | 未写 | 文档：没有填这个位置 | 无断言 | 开放世界 | 无 snak |
| `0x0001` | UNKNOWN-VALUE | 未知 | 世界：有值。不知道是什么 | `∃x. P(s, x)` | 存在封闭，身份开放 | `somevalue` |
| `0x0002` | NO-VALUE | 无 | 世界：没有值 | `¬∃x. P(s, x)` | 对 (s, P, 限定条件) 封闭 | `novalue` |
| `0x0003`~`0x0007` | 保留 | | | | | |

- 例：子女（P40）为 ABSENT 表示不知道有几个，为 UNKNOWN-VALUE 表示至少 1 个，为 NO-VALUE 表示 0 个。终止时点（P582）为 ABSENT 表示不知道现在是否仍然有效，为 UNKNOWN-VALUE 表示已结束但不知道何时，为 NO-VALUE 表示未结束。
- 低 3 位 `MMM` 不是 Quantifier，而是标记编号（[Reference](/zh/grammar/reference/) Quantifier 的例外）。
- 只有当字段的 CODEC 列表恰好包含该 WORD 时，标记才有效。在通配符、没有 CODEC 的字段、HEAD·BODY 的记录位置、Edge Id 位置上均为 invalid（[CODEC](/zh/grammar/edge/codec/)）。
- 读取方的义务：
  1. UNKNOWN-VALUE 不是值而是存在断言。它与任何值既不相等也不不等，两个 UNKNOWN-VALUE 之间也不视为相同的值。含 UNKNOWN-VALUE 的 TRIPLE 不做重复合并。
  2. NO-VALUE 在该命题的限定条件内封闭。如果它与同一 Subject·Predicate·rank 下限定条件无法区分的值 TRIPLE 同时存在，就是矛盾，检查器会发出警告（但不拒绝）。
  3. rank 同样适用。选取代表值（truthy）时，两种标记的 TRIPLE 也是候选。
  4. 当用作 QUALIFIER 的值时，会改变该限定的含义（`P582 = UNKNOWN`：已结束，时点不明。`P582 = NONE`：未结束）。
  5. ABSENT 对世界不作任何陈述。不要把没能转换的值写成 UNKNOWN-VALUE。

## 规范形式

相同的内容必须得到相同的字节。这样内容哈希和签名才能唯一确定。

- 长度使用最短写法（1~14 WORD 用直接长度）。
- 整数使用最短宽度。遵循各 Codec 规格规定的规范形式。
- 不是规范形式的记录予以拒绝。
