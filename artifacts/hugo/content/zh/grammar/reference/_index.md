---
title: "Reference"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference 是指向目标的记录。用 4 位 Codec 确定标识体系（LOCAL、Wikidata、外部文档等），用 3 位 Quantifier 确定量化（已识别、泛指、全称、变量等）。保留 Codec 0000 是占位标记组。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference 是指向目标的记录。目标可以是实体、概念、文档或另一个 Edge。用 ID 而不是名称来指向。

## 布局

```
TAG WORD          0000 0LLL LCCC CQQQ
[Length 扩展 TAG]
[IMPORT ID]       EXTERNAL-POINTER 时 (1/2/4/8 WORD)
[Issuer]          EXTERNAL-ISSUER 时 (1/2/4/16 WORD)
[文档 ID]         EXTERNAL-ISSUER 时 (4 WORD)
目标 ID           其余全部
```

- `LLLL` 是包含 TAG WORD 在内的总 WORD 数 − 1（[记录与 TAG WORD](/zh/grammar/record/)）。
- Codec 是 `CCCC` 4 位，Quantifier 是 `QQQ` 3 位。TAG WORD 的低 7 位是 `CCCC << 3 | QQQ`。
- 目标 ID 是无符号大端序整数，用**最短宽度**书写。宽度是 Length 减去前面字段后的剩余部分。
- 目标 ID `0` 写成 `0x0000` 1 WORD。除此之外不在前面加 `0x0000` WORD。
- 整数值相同则 ID 相同。宽度不是 ID 的一部分。
- 所有 Codec 都使用最短宽度。Codec 不固定目标 ID 的宽度。
- [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/) 和 [DOC-POINTER](/zh/grammar/reference/doc-pointer/) 不遵循此布局。它们没有目标 ID，只放 Issuer（以及文档 ID·版本 ID）。

## Codec (`CCCC`)

| CCCC | 名称 | 分类 | 目标 |
|---|---|---|---|
| `0000` | [占位标记](/zh/grammar/reference/slot-marker/) | 保留 | 不指向目标。只使用低 3 位为标记编号的 1 WORD 标记：`0x0000` ABSENT（未写）、`0x0001` UNKNOWN-VALUE（未知）、`0x0002` NO-VALUE（无） |
| `0001` | [LOCAL](/zh/grammar/reference/local/) | 声明 | 本文档签发的 ID |
| `0010` | [GEUL](/zh/grammar/reference/geul/) | 声明 | geul.org 签发的实体 |
| `0011` | [GEUL-SIDX](/zh/grammar/reference/geul-sidx/) | 声明 | 在比特中承载语义的语义对齐标识符 |
| `0100` | [WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/) | 声明 | Wikidata 条目。`Q` 之后的整数 |
| `0101` | [WIKIDATA-PID](/zh/grammar/reference/wikidata-pid/) | 声明 | Wikidata 属性。`P` 之后的整数 |
| `0110` | [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/) | 指示声明 | Issuer 自身 |
| `0111` | [DOC-POINTER](/zh/grammar/reference/doc-pointer/) | 指示声明 | Issuer 公布的文档的某一版本 |
| `1000`~`1011` | [EXTERNAL-POINTER-1/2/4/8WORD](/zh/grammar/reference/external-pointer/) | 指示 | 通过 IMPORT 导入的文档的 LOCAL ID |
| `1100`~`1111` | [EXTERNAL-ISSUER-1/2/4/16WORD](/zh/grammar/reference/external-issuer/) | 指示声明 | Issuer 公布的文档的 LOCAL ID |

- **声明**用签发主体所定的 ID 直接识别目标。
- **指示**指向通过 IMPORT ID 导入的文档中的 LOCAL。低 2 位是 IMPORT ID 的宽度（`00`=1、`01`=2、`10`=4、`11`=8 WORD）。
- **指示声明**无需 IMPORT，用一条记录指向其他文档及其中的目标。
- 最高位为 `0` 时直接识别目标（本文档的 LOCAL、签发 ID、Issuer·文档本身），为 `1` 时指向其他文档的 LOCAL。
- Codec `0000` 为保留，不用作指向目标的 Reference。例外只有一组：WORD `0x0000`~`0x0007`（Codec `0000`，1 WORD）是[占位标记](/zh/grammar/reference/slot-marker/)。目前使用其中三个（`0x0000` ABSENT、`0x0001` UNKNOWN-VALUE、`0x0002` NO-VALUE）。标记只在把该 WORD 精确作为 CODEC 目标的记录字段位置上有效。通配符和没有 CODEC 的字段不接受，在 HEAD·BODY 的记录位置以及 Edge Id 位置上 invalid。`0x0003`~`0x0007` 以及带 Payload 的 Codec `0000` 为保留。
- 非 CC0 的标识体系（WordNet 等）不设为 Reference Codec。Reference 也没有 ISSUER 码，因此没有可以改放为 Issuer 格式的位置。

### 常用 TAG

| 记录 | WORD |
|---|---|
| LOCAL 1 | `0088 0001` |
| LOCAL 65536 | `0108 0001 0000` |
| Wikidata Q5（人） | `00A0 0005` |
| Wikidata Q691283 | `0120 000a 8c53` |
| Wikidata P31 (instance of) | `00A8 001f` |
| 占位标记 ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0001` / `0002` |

## LOCAL

LOCAL 是本文档签发的 ID。只在文档内有意义。

- **唯一。** 在一个文档中，一个 LOCAL ID 只指向一个目标。
- **不分配 0。** 目标 ID 从 1 开始分配。
- **建议递增分配**（auto increment）。ID 的大小没有意义。
- 跨版本指向同一目标。已删除的 ID 不再使用（[文档](/zh/grammar/document/)修订）。
- 要让文档外部能够指向，文档必须有 `DOC-ID`。
- 不同的 LOCAL ID 并不表示现实中是不同的目标。相同则用 `SAME-NODE`，不同则用 `DIFFERENT-NODE` Edge 连接。

### Edge Id

每个 Edge 都把 LOCAL Reference 放在 Payload 的第一个元素。该 LOCAL ID 就是 **Edge Id**。

- 即使不知道 codebook 也能读出 Edge Id。
- Edge Id 位置上的 LOCAL 是声明，Edge 其他位置上的 LOCAL 是提及。
- 声明 Edge Id 的 LOCAL 的 Quantifier 只用 `000`。
- 其他 Edge 用 Edge Id 指向。本文档的 Edge 用 LOCAL 指向，其他文档的 Edge 用指示 Reference 指向。

## 指向其他文档

| 指向什么 | 方法 |
|---|---|
| Issuer 自身 | `ISSUER-POINTER`（Issuer） |
| 文档的某一版本 | `DOC-POINTER`（Issuer、文档 ID 4 WORD、版本 ID 2 WORD）。版本 `0` 为最新 |
| 公布文档中的目标（最新） | `EXTERNAL-ISSUER-*`（Issuer、文档 ID、LOCAL ID） |
| 导入文档中的目标（固定版本） | 用 Meta `IMPORT-DOC` 分配 IMPORT ID，再用 `EXTERNAL-POINTER-*`（IMPORT ID、LOCAL ID） |

- 无论在该文档内还是文档外，文档本身都只用一个 DOC-POINTER 来指向。自身就是自己 `DOC-ID` 的 DOC-POINTER。
- EXTERNAL-ISSUER 跟随最新版本。要固定版本就使用 IMPORT。
- Issuer 用能容纳该值的最短宽度（1/2/4/16 WORD）书写，并选择与该宽度匹配的 Codec。
- 各 Issuer 的文档 ID `0` 保留为该 Issuer 定义的术语（工具、角色等）的索引文档。建议所有 Issuer 设置索引文档，但不是必需的（[Issuer 与公布](/zh/grammar/issuer/#术语定义文档)）。

例：Issuer `0x0001` 的文档 `0x0000000000000002` 中的 LOCAL 7

```
0360 0001 0000 0000 0000 0002 0007
```

## Quantifier (`QQQ`)

| QQQ | 名称 | 含义 | 例 |
|---|---|---|---|
| `000` | Identified | 已识别的个体 | 埃隆·马斯克、大韩民国 |
| `001` | Generic | 关于整个类别的一般性陈述。允许例外 | 士兵服从命令 |
| `010` | Free-choice | 满足条件的任意对象 | 任何一个士兵 |
| `011` | Universal | 范围内的所有对象 | 所有士兵 |
| `100` | Variable | 话语变量 | 那个人、这个女人 |
| `101`~`111` | 保留 | | |

- **例外：在 Codec `0000`（占位标记）中，低 3 位不是 Quantifier，而是标记编号。** 标记编号与 Quantifier 的含义没有关联（`0x0001` UNKNOWN-VALUE 不是 Generic）。本表的 Quantifier 只适用于 Codec `0001`~`1111`。
- Generic 不同于 Universal，并不意味着无例外地适用于所有个别对象。像"士兵是什么"这样的定义性表达可以用 Generic。需要严格的概念·分类定义时，用单独的关系具体化。
- 量化的适用范围与否定，不由 Reference 决定，而由使用它的 Edge 决定。
- **Variable** 是话语中已知类别但尚未识别的对象。
  - 有名变量在 LOCAL 上附加 Variable。相同的 LOCAL ID 即为同一个变量。类别用 Edge 连接。
  - 匿名变量在指向类别的声明 Codec（GEUL、WIKIDATA-*）上附加 Variable（例：Wikidata"总统" + Variable）。不追踪共指，也无法再次指向。匿名变量之间不视为同一个变量。
  - 之后确认了目标时，用 `SAME-NODE` 把变量与该目标连接。所有指向同一变量的表达会一并解读为该目标。
  - 即使是不同的变量，也不意味着实际目标不同。相同则用 `SAME-NODE`，不同则用 `DIFFERENT-NODE` 连接。
  - 变量只在该文档内有效，不用作永久标识符。
  - 外部指示 Codec（EXTERNAL-POINTER-*、EXTERNAL-ISSUER-*）的 Variable 是所指向文档的 LOCAL 变量。
  - 例：在"总统发表了演讲"中，如果人物未确定，就使用"总统"Variable。要再次提及，则设置 LOCAL Variable，并用 Edge 连接类别"总统"。之后确认为奥巴马时，用 `SAME-NODE` 把该变量与奥巴马 Identified 连接。所有指向同一变量的表达一并解读为奥巴马。
- 例：把 Wikidata Q5（人）用作 Generic 是 `00A1 0005`（"人是……"）。
