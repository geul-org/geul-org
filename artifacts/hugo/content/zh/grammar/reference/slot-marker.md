---
title: "占位标记"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "ABSENT", "UNKNOWN-VALUE", "NO-VALUE"]
summary: "占位标记是放在保留 Reference Codec 0000 中的 1 WORD 记录组。0x0000 ABSENT（未写）、0x0001 UNKNOWN-VALUE（未知）、0x0002 NO-VALUE（无）用来填充记录字段的位置。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

占位标记（slot marker）是填充记录字段位置的 1 WORD 记录。它不指向任何东西。放在保留 Reference Codec `0000` 中。

值的位置上可以出现三种说法。没有写值、有值但不知道是什么、没有值。这三者各不相同。占位标记把这三者拆成相邻的三个 WORD 来书写。

## 布局

```
TAG WORD          0000 0000 0000 0MMM
                  Prefix 000, Kind 00(Reference), LLLL 0000(1 WORD), CCCC 0000, MMM = 标记编号
```

| WORD | 名称 | 含义 | 写法 |
|---|---|---|---|
| `0x0000` | ABSENT | 未写 | `ABSENT` |
| `0x0001` | UNKNOWN-VALUE | 未知：有值。不知道是什么 | `UNKNOWN` |
| `0x0002` | NO-VALUE | 无：没有值 | `NONE` |
| `0x0003`~`0x0007` | 保留 | | |
| CCCC `0000`，LLLL ≥ `0001` | 保留 | 带 Payload 的标记以后再定 | |

- 低 3 位 `MMM` 是**标记编号而不是 Quantifier**。它只是与其他 Reference Codec 的 `QQQ` 同名的位置，含义并不相连（[Reference](/zh/grammar/reference/) Quantifier 的例外）。
- 没有 Payload。也没有目标 ID。
- 没有 codebook 的解码器仅凭 TAG WORD 也能知道它是 Kind Reference、1 WORD，从而跳过。"WORD 值为 `0`~`7` 则是占位标记"只需一次位检查（`w & 0xFFF8 == 0`）即可得知。
- 写法 `ABSENT`·`UNKNOWN`·`NONE` 是 `geul show`·`geul add` 的文本写法。

## 三种区分

| | 未写 (ABSENT) | 未知 (UNKNOWN-VALUE) | 无 (NO-VALUE) |
|---|---|---|---|
| 谈论的是什么 | **文档**：没有填这个位置 | **世界**：有值。不知道是什么 | **世界**：没有值 |
| 逻辑 | 不断言任何事 | `∃x. P(s, x)`，x 未被识别 | `¬∃x. P(s, x)` |
| 世界假设 | 开放世界（无信息） | 存在封闭，身份开放 | 对 (s, P, 限定条件) 封闭的世界 |
| Wikidata | 没有对应的 snak | `somevalue` | `novalue` |
| 用在哪里 | 放有 CODEC 目标 `0000` 的可选字段（SOURCE Origin 等） | 放有 CODEC 目标 `0001` 的字段（TRIPLE Object、QUALIFIER Value、SOURCE Origin） | 放有 CODEC 目标 `0002` 的字段（TRIPLE Object、QUALIFIER Value） |
| "子女（P40）有几个" | 不知道 | 至少 1 个 | 0 个 |
| "有没有终止时点（P582）" | 不知道 → 不知道现在是否仍然有效 | 已结束。不知道何时 | 未结束（断言） |

在命题层面同样成立这种区分。**文档中没有该 TRIPLE** 就是未写。GEUL 文档是开放世界，没有叙述并不意味着没有事实。"没有"只有**写成** NO-VALUE 才能表达。

## 接受规则

- 占位标记只有在该字段的 [CODEC](/zh/grammar/edge/codec/) 列表中**同一个 WORD 作为精确目标存在时**才有效。目标 `0000` 表示"可选字段"，`0001` 表示"接受未知"，`0002` 表示"接受无"。
- 通配符（`0780`、`0781`、`0F80` 等）不接受标记。Reference 通配符也与 Codec `0000` 不重叠。
- 没有 CODEC 的记录字段（"任意记录"）也不接受标记。
- 在 HEAD·BODY 的记录位置、Edge Id 位置上的标记 invalid。
- 原始值字段不能使用标记。原始值没有 TAG，没有可放入 1 WORD 标记的位置。
- 只有标记目标的 CODEC 列表（始终是标记）invalid。
- 标记的含义（有什么、没有什么）由接受该标记的 Edge 规格决定。与"量化和否定不由 Reference 而由 Edge 决定"的原则相同。
- 占位标记没有 Codec 规格文档。它属于 [0 层](/zh/grammar/publishing/#层)（解码器内置）。DECLARE 的 Reference 目标把 Quantifier 位置设为 0，所以无法为 `0x0001`·`0x0002` 制作规格文档，而且三者都没有 Payload，内置也没有成本。

## 读取方的义务

1. **UNKNOWN-VALUE 不是值而是存在断言。** 它与其他任何值既不相等也不不等（比较结果未定）。两个 UNKNOWN-VALUE 之间也不视为相同的值。每次出现都是独立的存在量化（与 Wikidata 的空白节点相同）。
   - 因此字节相同的两个 TRIPLE（`P40 Q… UNKNOWN` ×2）不是重复。可能有两个子女，也可能只有一个。含 UNKNOWN-VALUE 的 TRIPLE 不做重复合并。
   - 之后弄清身份时，发布修改了该 TRIPLE 的新版本。UNKNOWN-VALUE 无法被指向。需要共指时使用 LOCAL Variable（[Reference](/zh/grammar/reference/) Variable）。
2. **NO-VALUE 在该命题的限定条件内封闭。** 附有 QUALIFIER 时，只在该范围内封闭。Q30 P1304 NO-VALUE（P580 1811、P582 1816）表示只在 1811~1816 年没有中央银行，与同一属性的值 TRIPLE（联邦储备系统，preferred）并不矛盾。
   - 如果同一 Subject·Predicate 上，NO-VALUE 与值 TRIPLE 以相同 rank、限定条件无法区分地共存，就是矛盾。检查器会发出警告。但不拒绝。这在 Wikidata 中也存在，由读取方按 rank 选取。
3. **rank 同样适用。** 选取代表值（truthy）时，UNKNOWN-VALUE·NO-VALUE TRIPLE 也在候选之列。有 preferred 时只保留 preferred。
4. **当用作 QUALIFIER 的值时，会改变该限定的含义。** `P582 = UNKNOWN` 表示已结束，时点未知。不把它读作仍然有效的命题。`P582 = NONE` 则断言未结束。完全没有 P582 QUALIFIER，则不知道是否已结束。
5. **ABSENT 对世界不作任何陈述。** 不把它读作 UNKNOWN-VALUE 或 NO-VALUE。反过来，禁止转换器把没能转换的值（来源中存在的值）写成 UNKNOWN-VALUE。因为来源中是知道该值的。来源没有说明的位置（例：没有描述来源的出处的 [SOURCE](/zh/grammar/edge/source/) Origin），转换器也写成 ABSENT。UNKNOWN-VALUE 是"有"的断言，只有来源这样说时才使用。

## 与其他"无"的区别

- 把 [LOCAL](/zh/grammar/reference/local/) `0` 用作"无"的 Codec 规则（[TOULMIN](/zh/grammar/edge/toulmin/) REF 等）是该 Codec 内部的约定。与占位标记不同。
- 不把 Identified LOCAL 用作 null·sentinel。要写未知·缺失，就在接受标记的字段上使用标记。

## 示例

Q30（美国）–Q34266（俄罗斯帝国）边界，终止时点未知。Edge Id 仅用于说明。

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

Q30 的中央银行，1811~1816 年间不存在。

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

- 标记位置是 1 WORD。TRIPLE 变为 9 WORD（`140A`），QUALIFIER 变为 8 WORD（`138B`）。
- 简单形式的"没有子女（P40）"是 `140A 0088 <Edge Id> 00A8 0028 <Subject> 0002 0000`。

## 相关页面

- [Reference](/zh/grammar/reference/)、[CODEC](/zh/grammar/edge/codec/)、[Codec 规格文档](/zh/grammar/codec-spec/)
- [TRIPLE](/zh/grammar/edge/triple/)、[QUALIFIER](/zh/grammar/edge/qualifier/)、[TOULMIN](/zh/grammar/edge/toulmin/)
