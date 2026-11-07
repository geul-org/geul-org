---
title: "Reference"
weight: 90
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "LOCAL", "quantifier"]
summary: "Reference 是指向对象的记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Reference 是指向对象的记录。对象可以是实体、概念、文档或其他 Edge。它通过 ID 而不是名称来指向。

## 布局 {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      章节 0~2 (0x000L~0x05FL)
[Length 扩展 TAG]
[IMPORT ID]       EXTERNAL-POINTER 时 (1/2/4 WORD)
[Issuer]          EXTERNAL-ISSUER 时 (2/4/16 WORD)
[文档 ID]         EXTERNAL-ISSUER 时 (4 WORD)
目标 ID           其余全部
```

- `LLLL` 是包含 TAG WORD 在内的总 WORD 数 − 1（[记录与 TAG WORD](../record.md)）。
- Reference 是章节 0~2（`w < 0x0600`）共 96 格。章节 0 实体 `0x000L~0x01FL`，章节 1 EXTERNAL `0x020L~0x03FL`，章节 2 其他 `0x040L~0x05FL`。
- Codec 以代码表的形式书写（见下表）。5Q 体系中，一个代码同时包含标识体系和量化。REFERENCE-ISSUER 的量化由 Issuer 文档决定。
- 目标 ID 是无符号大端整数，用**最短宽度**书写。宽度是 Length 减去前面字段后剩余的部分。
- 目标 ID `0` 写作 `0x0000` 1 WORD。除此之外，前面不加 `0x0000` WORD。
- 整数值相同则为同一个 ID。宽度不是 ID 的一部分。
- 所有 Codec 都使用最短宽度。Codec 不固定目标 ID 的宽度。
- [ISSUER-POINTER](0x040L-issuer-pointer.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[CODEC-POINTER](0x042L-codec-pointer.md) 不遵循此布局。它们没有目标 ID，只有 Issuer（以及文档 ID·Codec ID·版本 ID）。
- [REFERENCE-ISSUER](#reference-issuer) 也不遵循此布局。它是 TAG、Issuer、Codec 编号 2 WORD、Payload。Payload 由 Issuer 发行的 Codec 文档决定。

## Codec {#codec}

| TAG ID | 名称 | 分类 | 目标 |
|---|---|---|---|
| `0x000L~0x002L` | [占位标记](../slot-marker.md) | 占位标记 | 不指向对象。只使用 1 WORD 标记：`0x0000` ABSENT（未填写）、`0x0010` UNKNOWN-VALUE（未知）、`0x0020` NO-VALUE（无） |
| `0x005L~0x009L` | [LOCAL](0x005L-local.md) | 声明 | 本文档签发的 ID |
| `0x00AL~0x00EL` | [GEUL](0x00AL-geul.md) | 声明 | geul.org 签发的实体 |
| `0x00FL~0x013L` | [GEUL-SIDX](0x00FL-geul-sidx.md) | 声明 | 在比特中承载含义的语义对齐标识符 |
| `0x014L~0x018L` | [WIKIDATA-QID](0x014L-wikidata-qid.md) | 声明 | Wikidata 项目。`Q` 之后的整数 |
| `0x019L~0x01DL` | [WIKIDATA-PID](0x019L-wikidata-pid.md) | 声明 | Wikidata 属性。`P` 之后的整数 |
| `0x020L~0x02EL` | [EXTERNAL-POINTER-1/2/4WORD](0x020L-external-pointer-1word.md) | 指示 | 由 IMPORT 引入的文档中的 LOCAL ID |
| `0x02FL~0x03DL` | [EXTERNAL-ISSUER-2/4/16WORD](0x02FL-external-issuer-2word.md) | 指示声明 | Issuer 所公布文档中的 LOCAL ID |
| `0x040L` | [ISSUER-POINTER](0x040L-issuer-pointer.md) | 指示声明 | Issuer 自身 |
| `0x041L` | [DOC-POINTER](0x041L-doc-pointer.md) | 指示声明 | Issuer 所公布文档的某一版本 |
| `0x042L` | [CODEC-POINTER](0x042L-codec-pointer.md) | 指示声明 | Issuer 所公布 Codec 的某一版本 |
| `0x043L~0x044L` | [TOKEN-0·TOKEN-1](0x043L-token.md) | 声明 | GEUL 词元词表的条目。词元 ID 1 WORD，总计 2 WORD |
| `0x05DL~0x05FL` | [REFERENCE-ISSUER-2/4/16WORD](#reference-issuer) | Issuer 格式 | 由 Issuer 定义。分类和目标 ID 格由 Issuer 文档决定 |

- Reserved 为 `0x003L~0x004L`、`0x01EL~0x01FL`（章节 0）、`0x03EL~0x03FL`（章节 1）、`0x045L~0x05CL`（章节 2，新标识体系的位置）。
- 体系编号由章节内偏移 `C` 读取。在章节 0 中，`5 <= C < 30` 时为体系 `C / 5`（1~5）；在章节 1 中，`C < 30` 时为体系 `6 + C / 5`（6~11）。

| 体系 | 名称 | Identified | Generic | Free-choice | Universal | Variable |
|---:|---|---|---|---|---|---|
| 1 | LOCAL | `0x005L` | `0x006L` | `0x007L` | `0x008L` | `0x009L` |
| 2 | GEUL | `0x00AL` | `0x00BL` | `0x00CL` | `0x00DL` | `0x00EL` |
| 3 | GEUL-SIDX | `0x00FL` | `0x010L` | `0x011L` | `0x012L` | `0x013L` |
| 4 | WIKIDATA-QID | `0x014L` | `0x015L` | `0x016L` | `0x017L` | `0x018L` |
| 5 | WIKIDATA-PID | `0x019L` | `0x01AL` | `0x01BL` | `0x01CL` | `0x01DL` |
| 6 | EXTERNAL-POINTER-1WORD | `0x020L` | `0x021L` | `0x022L` | `0x023L` | `0x024L` |
| 7 | EXTERNAL-POINTER-2WORD | `0x025L` | `0x026L` | `0x027L` | `0x028L` | `0x029L` |
| 8 | EXTERNAL-POINTER-4WORD | `0x02AL` | `0x02BL` | `0x02CL` | `0x02DL` | `0x02EL` |
| 9 | EXTERNAL-ISSUER-2WORD | `0x02FL` | `0x030L` | `0x031L` | `0x032L` | `0x033L` |
| 10 | EXTERNAL-ISSUER-4WORD | `0x034L` | `0x035L` | `0x036L` | `0x037L` | `0x038L` |
| 11 | EXTERNAL-ISSUER-16WORD | `0x039L` | `0x03AL` | `0x03BL` | `0x03CL` | `0x03DL` |

- **声明**通过签发主体确定的 ID 直接标识对象。
- **指示**指向通过 IMPORT ID 引入的文档内的 LOCAL。IMPORT ID 的宽度由体系决定：体系 − 6 为 0、1、2 时，分别是 1、2、4 WORD。
- **指示声明**无需 IMPORT，用一条记录指向其他文档及其中的对象。EXTERNAL-ISSUER 的 Issuer 宽度为：体系 − 9 为 0、1、2 时，分别是 2、4、16 WORD。
- `0x020L~0x03DL`（章节 1，体系 6~11）指向其他文档的 LOCAL。其他声明体系直接标识对象（本文档的 LOCAL、签发的 ID）。指针（章节 2，`0x040L~0x042L`）指向 Issuer·文档·Codec 本身。REFERENCE-ISSUER 不在此区分之内。
- `0x000L~0x002L` 是分配给占位标记的代码，不用作指向对象的 Reference。WORD `0x0000`、`0x0010`、`0x0020`（L 0，1 WORD）是[占位标记](../slot-marker.md)（`0x0000` ABSENT、`0x0010` UNKNOWN-VALUE、`0x0020` NO-VALUE）。标记只在把该 WORD 明确设为 CODEC 目标的记录字段位置上有效。通配符和没有 CODEC 的字段不接受它，在 HEAD·BODY 记录位置和 Edge Id 位置上为 invalid。C 为 0~2 且带有 Payload 的 TAG 形式（L ≥ 1）为 Reserved。
- 只有 geul.org 提供的直接码和公布物是 CC0。不把非 CC0 的标识体系（WordNet 等）设为直接码。Issuer 格式的许可证由该 Issuer 决定。

### 常用 TAG {#자주-쓰는-tag}

| 记录 | WORD |
|---|---|
| LOCAL 1 | `0051 0001` |
| LOCAL 65536 | `0052 0001 0000` |
| Wikidata Q5（人） | `0141 0005` |
| Wikidata Q691283 | `0142 000A 8C53` |
| Wikidata P31 (instance of) | `0191 001F` |
| 占位标记 ABSENT / UNKNOWN-VALUE / NO-VALUE | `0000` / `0010` / `0020` |

## LOCAL {#local}

LOCAL 是本文档签发的 ID。

- **唯一。** 在一份文档中，一个 LOCAL ID 只指向一个对象。
- **不分配 0。** 对象 ID 从 1 开始分配。
- **建议递增分配**（auto increment）。ID 的大小没有含义。
- 跨版本指向同一对象。已删除的 ID 不再重用（[文档](../document.md)修订）。
- 要从文档外指向它，文档中必须有 `DOC-ID`。
- 不同的 LOCAL ID 并不表示它们在现实中是不同的对象。相同则用 `SAME-NODE`，不同则用 `DIFFERENT-NODE` Edge 连接。

### Edge Id {#edge-id}

每个 Edge 都把 LOCAL Reference 作为 Payload 的第一个元素。该 LOCAL ID 就是 **Edge Id**。

- 即使不了解码本，也能读取 Edge Id。
- Edge Id 位置的 LOCAL 是声明，Edge 其他位置的 LOCAL 是提及。
- 声明 Edge Id 的 LOCAL 只使用 Identified（`0x005L`）。
- 其他 Edge 通过 Edge Id 指向。本文档的 Edge 用 LOCAL 指向，其他文档的 Edge 用指示 Reference 指向。

## 指向其他文档 {#다른-문서-가리키기}

| 指向什么 | 如何指向 |
|---|---|
| Issuer 自身 | `ISSUER-POINTER`（Issuer） |
| 文档的某一版本 | `DOC-POINTER`（Issuer、文档 ID 4 WORD、版本 ID 2 WORD）。版本 `0` 为最新 |
| Codec 的某一版本 | `CODEC-POINTER`（Issuer、Codec ID 2 WORD、版本 ID 2 WORD）。版本 `0` 为最新 |
| 公布文档内的对象（最新） | `EXTERNAL-ISSUER-*`（Issuer、文档 ID、LOCAL ID） |
| 引入文档内的对象（固定版本） | 用 Meta `IMPORT-DOC` 分配 IMPORT ID，再用 `EXTERNAL-POINTER-*`（IMPORT ID、LOCAL ID） |

- 文档本身无论在该文档内还是文档外，都只用一个 DOC-POINTER 指向。指向自身时，用自己 `DOC-ID` 的 DOC-POINTER。Codec 文档是例外，用 CODEC-POINTER 指向（`DOC-ID` 也是 CODEC-POINTER）。
- EXTERNAL-ISSUER 跟随最新版本。要固定版本，请使用 IMPORT。
- Issuer 用能容纳其值的最短宽度（2/4/16 WORD）书写，并选择与该宽度相符的 Codec。EXTERNAL-ISSUER 和 REFERENCE-ISSUER 相同。
- 每个 Issuer 的文档 ID `0` 保留为该 Issuer 所定义术语（工具、角色等）的索引文档。建议所有 Issuer 都提供索引文档，但不是必须的（[Issuer 与公布](../issuer.md#용어-정의-문서)）。

例：Issuer `0x00000002` 的文档 `0x0000000000000002` 内的 LOCAL 7

```
02F7 0000 0002 0000 0000 0000 0002 0007
```

## Quantifier {#quantifier}

| `C % 5` | 名称 | 含义 | 例 |
|---|---|---|---|
| `0` | Identified | 已识别的个体 | 埃隆·马斯克、大韩民国 |
| `1` | Generic | 关于整个类别的一般性陈述。允许例外 | 士兵服从命令 |
| `2` | Free-choice | 满足条件的任意对象 | 随便哪个士兵 |
| `3` | Universal | 范围内的所有对象 | 所有士兵 |
| `4` | Variable | 话语变量 | 那个人、这个女人 |

- **量化只在 5Q 体系（体系 1~11）中读取。** 用章节内偏移 `C`，章节 0 在 `5 <= C < 30`、章节 1 在 `C < 30` 时，量化为 `C % 5`。由于一个章节是 32 格，把 9 位的 Codec 位置（`w >> 4`）除以 5 会使章节 1 错位。标记（章节 0，`C < 3`）和章节 2（指针、REFERENCE-ISSUER）没有量化。标记 `0x0010` UNKNOWN-VALUE 不是 Generic。REFERENCE-ISSUER 的量化由 Issuer 发行的 Codec 文档决定。
- Generic 与 Universal 不同，并不表示无例外地适用于所有个别对象。像 `士兵是什么` 这样的定义性表达可以使用 Generic。需要严格的概念·分类定义时，用另外的关系具体化。
- 量化的适用范围和否定由使用它的 Edge 决定，而不是由 Reference 决定。
- **Variable** 是话语中已知类别但尚未被识别的对象。
  - 有名字的变量，在 LOCAL 上附加 Variable。LOCAL ID 相同则为同一个变量。类别用 Edge 连接。
  - 匿名变量，在指向类别的声明 Codec（GEUL、WIKIDATA-*）上附加 Variable（例：Wikidata“总统”+ Variable）。不追踪共指，也不能再次指向。匿名变量之间不视为同一个变量。
  - 之后确认了对象，就把变量与该对象用 `SAME-NODE` 连接。指向同一变量的所有表达会一并解释为该对象。
  - 即使是不同的变量，也不表示实际对象不同。相同则用 `SAME-NODE`，不同则用 `DIFFERENT-NODE` 连接。
  - 外部指示 Codec（EXTERNAL-POINTER-*、EXTERNAL-ISSUER-*）的 Variable 是所指文档的 LOCAL 变量。
  - 例：在 `总统发表了演讲` 中，若人物尚未确定，则使用“总统”Variable。要再次提及，就设置 LOCAL Variable，并用 Edge 连接类别“总统”。之后确认为奥巴马，就把该变量与奥巴马 Identified 用 `SAME-NODE` 连接。指向同一变量的所有表达会一并解释为奥巴马。
- 例：把 Wikidata Q5（人）用作 Generic，则是 `0151 0005`（“人是……”）。

## REFERENCE-ISSUER {#reference-issuer}

REFERENCE-ISSUER 是由 Issuer 定义的 Reference 格式。它是 Reference 区段末尾三格。布局与 Value·Edge 的 ISSUER 相同（[记录与 TAG WORD](../record.md#issuer-형식-레코드)）。

### 布局 {#레이아웃-1}

```
TAG WORD          0000 0101 11WW LLLL      Codec 0x05DL / 0x05EL / 0x05FL (WW = Issuer 宽度: 01 2, 10 4, 11 16 WORD)
[Length 扩展 TAG]
Issuer            2/4/16 WORD (由 Codec 决定宽度)
Codec 编号        2 WORD。由 Issuer 定义
Payload           由 Issuer 发行的 Codec 文档决定
```

| Codec | 名称 | Issuer 宽度 |
|---|---|---|
| `0x05DL` | [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md) | 2 WORD |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md) | 4 WORD |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md) | 16 WORD |

- 每个代码都有一页：[REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)、[REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)、[REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md)。
- GEUL Issuer 的 Codec 文档每个代码一份，设三个 FIELD：Issuer（2·4·16 WORD）、Codec 编号（2 WORD）、Payload（由 Issuer Codec 决定）。

### 解释与有效性 {#해석과-유효성}

- GEUL 只通过 Length 知道 Payload 的边界。没有码本就不解释 Payload。
- Codec 编号的含义和量化由 Issuer 决定。指向什么，也由 Issuer 发行的 Codec 文档决定。
- Reference 的公共规则不适用：目标 ID 最短宽度、目标 ID `0` 的 1 WORD 写法、Quantifier、章节内偏移的量化·体系读取、声明·指示分类、所指对象。
- Codec 编号 2 WORD 与 Value·Edge ISSUER 相同。编号不够时，再申请一个 Issuer。
- 不了解格式的解码器知道 Kind、Length、Issuer、Codec 编号，并按 Length 跳过。
- Issuer 格式的许可证由该 Issuer 决定（[Issuer 与公布](../issuer.md#라이선스)）。

### 相关页面 {#관련-페이지}

- [记录与 TAG WORD](../record.md)、[Issuer 与公布](../issuer.md)
