---
title: "记录的结构"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "record", "TAG"]
summary: "GEUL 数据是记录的序列。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL 数据是记录的序列。每个记录都以一个 TAG WORD 开头。

## 记录布局 {#레코드-레이아웃}

```
TAG WORD (16位)
┌──────────┬──────────┬──────────┬──────────┐
│  Prefix  │   Kind   │  Class   │  Length  │
│   3bit   │   4bit   │   5bit   │   4bit   │
│   000    │   KKKK   │  CCCCC   │   LLLL   │
└──────────┴──────────┴──────────┴──────────┘
[Length 扩展 TAG]
[Codec 扩展 TAG]
[Codec 专属 TAG]
Payload
```

- TAG WORD 为 `000K KKKC CCCC LLLL`。高 4 位 `KKKK` 是章节 `S = w >> 9`，一个章节有 32 格。`C` 是章节内的 5 位偏移 `(w >> 4) & 0x1F`。
- TAG ID 写作 `0x000L`。前三位是章节与 `C` 合在一起的 9 位 Codec 位置（`w >> 4`），`L` 是 Length 位置。实际的 WORD 值在 L 位置写数字（例：TRIPLE 为 `0x0AAL`，10 WORD TRIPLE 的 TAG WORD 为 `0x0AA9`）。
- 扩展 TAG 只按上述顺序放置。Length 扩展 TAG 总是紧跟在 TAG WORD 之后。
- Codec 专属 TAG 和 Payload 的构成由各 Codec 规格规定。Codec 专属 TAG 的长度不写在 TAG WORD 中。因为解释 Payload 无论如何都需要 codebook。
- 有子格式的 Codec 用 1 WORD 的 Codec 专属 TAG 指定子格式（Edge WORLD 等）。

## 字节顺序 {#바이트-순서}

- 规范序列化为大端序。
- 位字段从最高位开始排布。
- 在 WORD 内先写高位字节，由多个 WORD 构成的值先写高位 WORD。
- 内存中的表示由实现自由决定。

## Kind（章节区间） {#kind-섹션-구간}

| 章节 | Kind | TAG ID | 定义 |
|---|---|---|---|
| 0~2 | Reference | `0x000L~0x05FL` | 指向对象。用 Codec 和对象 ID 标识对象 |
| 3·4 | Value | `0x060L~0x09FL` | 直接承载值本身。Codec 决定 Payload 的解释 |
| 5~13 | Edge | `0x0A0L~0x1BFL` | 将其他记录作为构成要素绑定在一起。Codec 决定构成要素的角色和顺序 |
| 14·15 | Meta | `0x1C0L~0x1FFL` | 谈论文档和记录 |

- Kind 由章节区间唯一判定：`w < 0x0600` Reference，`w < 0x0A00` Value，`w < 0x1C00` Edge，其余为 Meta。没有例外。

- Kind 是 Codec 的不可变属性。Codec 一经分配，其 Kind 不再变动。
- Value 和 Edge 是相同的“Codec + Payload”格式。只有 Edge 把其他记录作为构成要素。
- Reference 将占位标记、指针、5Q 体系、REFERENCE-ISSUER 分在码表中。量化在体系码中。REFERENCE-ISSUER 的量化由 Issuer 文档规定（[Reference](reference/_index.md)）。

## Length（4 位） {#length-4비트}

Length 是记录占用的**整体 WORD 数**。包含 TAG WORD、扩展 TAG、Payload 和最后一个 WORD 的填充。

| 值 | 含义 |
|---|---|
| `0000`~`1101` | 1~14 WORD（值 + 1） |
| `1110` | 扩展长度 1：后面 1 WORD 为整体 WORD 数（15~65,535） |
| `1111` | 扩展长度 2：后面 2 WORD 为整体 WORD 数（65,536~2³²−1） |

- 1~14 WORD 必须使用直接长度书写。更宽的写法不是规范形式。
- 扩展长度的整体 WORD 数也包含 Length 扩展 TAG 自身。
- 没有超过 2³²−1 WORD 的记录。
- 1 WORD 记录是没有 Payload 的单个 TAG WORD。只在 Codec 规格允许时使用（例：Meta `BODY`、`END`、空字节序列、占位标记）。
- 即使没有 codebook，也可以用 `下一个记录位置 = 当前记录起始 + Length` 跳过记录。

## Codec（章节与 C，9 位） {#codec-섹션과-c-9비트}

| TAG ID | 名称 | 含义 |
|---|---|---|
| 各 Kind 区域的前部 | 直接码 | 仅凭 TAG WORD 即可确定 Codec |
| `0x05DL`、`0x09DL`、`0x1BDL` | REFERENCE-ISSUER-2WORD、VALUE-ISSUER-2WORD、EDGE-ISSUER-2WORD | Codec 扩展 TAG 中含 Issuer 2 WORD 和 Codec 编号 2 WORD |
| `0x05EL`、`0x09EL`、`0x1BEL` | REFERENCE-ISSUER-4WORD、VALUE-ISSUER-4WORD、EDGE-ISSUER-4WORD | Codec 扩展 TAG 中含 Issuer 4 WORD 和 Codec 编号 2 WORD |
| `0x05FL`、`0x09FL`、`0x1BFL` | REFERENCE-ISSUER-16WORD、VALUE-ISSUER-16WORD、EDGE-ISSUER-16WORD | Codec 扩展 TAG 中含 Issuer 16 WORD 和 Codec 编号 2 WORD |

- **各 Kind 区域的末三格是 ISSUER。** Issuer 宽度由 C 的低 2 位决定（`01` 2 WORD，`10` 4 WORD，`11` 16 WORD）。Meta 没有 Issuer 格式。
- 直接码的 `C` 在每个章节中各自独立。即使 `C` 值相同，章节不同就是不同的 Codec。直接码的 Codec ID 是完整的 TAG WORD（L=0），因此包含 Kind。
- Issuer Codec 编号与 Kind 无关，每个 Issuer 是一个空间。由 Issuer 在自己的 `codecs/` 内分配不重复的编号（[公布地址与版本列表](publishing.md#id-표기)）。
- 不是直接码的 Codec 是 `(Issuer, Codec 编号)` 对。Codec 编号由该 Issuer 定义（[Issuer 与公布](issuer.md)）。扩展格式放在制定该格式的机构的 Issuer 之下。
- 已有直接码的 Codec 不再单独以 Issuer 格式登记。
- Issuer 格式存在于 Reference、Value、Edge。Meta 是仅由 GEUL 定义的通用规格。
- Edge 直接码的章节（`w >> 9`）就是系列。Value 直接码和 Meta 不用位来表示系列·类。Codec 编号的含义由 Issuer 决定。
- 直接码无法回收。只有确认了使用频率的格式才放入直接码。

## Issuer 格式记录 {#issuer-형식-레코드}

```
TAG WORD          ISSUER 码 (各 Kind 区域的末三格)
[Length 扩展 TAG]
Issuer            2/4/16 WORD (宽度由 Codec 决定)
Codec 编号        2 WORD. 由 Issuer 定义
Payload           由 Issuer 发行的 Codec 文档决定
```

- 三个 Kind 的布局相同。编号不够时，再申请一个 Issuer。
- Edge（EDGE-ISSUER）的 Payload 与其他 Edge 一样以 Edge Id 开头。因此顺序是 TAG、Issuer、Codec 编号、Edge Id、其余 Payload。
- 不了解该格式的解码器，读到 Issuer 和 Codec 编号为止，用 Length 跳过。

## 可变长度字节序列 {#가변-길이-바이트열}

文本、URI、语言标签、未知字节序列等长度以字节为单位的值，将 Codec（或 Codec 编号）分配为**偶数·奇数对**。

- Codec 的最低位（直接码为 C 的最低位）为 `0` 则字节数为偶数，为 `1` 则为奇数。
- 字节数 = `2 × Payload WORD 数 − 最低位`。没有 Byte Count 字段。
- 为奇数时，最后一个 WORD 的低字节是 `0x00` 填充。不是 `0x00` 则拒绝。
- 空字节序列是偶数 Codec 的 1 WORD 记录（仅 TAG WORD）。
- UUID·摘要·地址等大小固定的值不设对。

## 例：读取 TAG WORD {#예-tag-word-읽기}

我们来读 `0AA9`。

```
0x0AA9 = 0000 1010 1010 1001
         000 | 0101 | 01010 | 1001
Prefix 000, 章节 0101(5, Edge), C 01010, Codec 0x0AAL(TRIPLE), Length 1001(10 WORD)
```

该记录是 10 WORD 的 Edge，Codec 是 TRIPLE。即使没有 codebook，也知道下一个记录在 10 WORD 之后。

## 占位标记 {#자리-표지}

TAG WORD `0x0000`、`0x0010`、`0x0020` 是 Reference 占位标记的 1 WORD 记录。它们不指向对象，只填充记录字段的位置（[占位标记](slot-marker.md)）。

```
0x0000, 0x0010, 0x0020 = 0000 0000 00CC 0000
                         Prefix 000, 章节 0(Reference), C 0~2, LLLL 0000(1 WORD)
```

| WORD | 名称 | 含义 | 谈论的是什么 | 逻辑 | 世界假设 | 维基数据 |
|---|---|---|---|---|---|---|
| `0x0000` | ABSENT | 未填写 | 文档：未填充这个位置 | 无断言 | 开放世界 | 无 snak |
| `0x0010` | UNKNOWN-VALUE | 未知 | 世界：有值，但不知道是什么 | `∃x. P(s, x)` | 存在是封闭的，身份是开放的 | `somevalue` |
| `0x0020` | NO-VALUE | 无 | 世界：没有值 | `¬∃x. P(s, x)` | 对 (s, P, 限定条件) 封闭 | `novalue` |

- 例：子女（P40）为 ABSENT 则不知道有几个，为 UNKNOWN-VALUE 则至少 1 个，为 NO-VALUE 则是 0 个。终止时间（P582）为 ABSENT 则不知道现在是否仍有效，为 UNKNOWN-VALUE 则已结束但不知何时，为 NO-VALUE 则尚未结束。
- 只有字段的 CODEC 列表精确包含该 WORD 时，标记才有效。在通配符、没有 CODEC 的字段、HEAD·BODY 记录位置、Edge Id 位置，标记无效（[CODEC](edge/0x0BEL-codec.md)）。
- 读取方的义务：
  1. UNKNOWN-VALUE 不是值，而是存在断言。它与任何值既不相同也不相异，两个 UNKNOWN-VALUE 之间也不视为相同的值。含 UNKNOWN-VALUE 的 TRIPLE 不做重复合并。
  2. NO-VALUE 在该命题的限定条件内封闭。如果与同一 Subject·Predicate·rank 下限定条件无法区分的值 TRIPLE 并存，则是矛盾，检查器会发出警告（不拒绝）。
  3. rank 同样适用。选取代表值（truthy）时，带这两种标记的 TRIPLE 也是候选。
  4. 作为 QUALIFIER 值使用时，会改变该限定的含义（`P582 = UNKNOWN`：已结束，时间不明。`P582 = NONE`：尚未结束）。
  5. ABSENT 对世界不作任何陈述。无法转换的值不用 UNKNOWN-VALUE 表示。

## 规范形式 {#정규형}

相同的内容必须是相同的字节。这样内容哈希和签名才能唯一确定。

- 长度使用最短写法（1~14 WORD 为直接长度）。
- 整数用最窄宽度书写。遵循各 Codec 规格规定的规范形式。
- 拒绝不是规范形式的记录。
- 例外：[CODEC](edge/0x0BEL-codec.md) 目标 WORD 的 `L=1111` 与 `C` 值无关，只看章节 `KKKK`。建议使用章节第一格（`C = 0`），即使是同一章节的其他 `C` 也不拒绝。
