---
title: "Edge"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "Edge 是把其他记录作为组成部分绑在一起进行陈述的记录。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Edge 是把其他记录作为组成部分绑在一起进行陈述的记录。"Q42 是人"、"Q42 的英文名是 Douglas Adams"这样的陈述就是一个 Edge。

## 布局 {#레이아웃}

```
TAG WORD          000K KKKC CCCC LLLL      章节 5~13 (0x0A0L~0x1BFL)
[Length 扩展 TAG]
[Codec 扩展 TAG]  Issuer 格式时
Edge Id           LOCAL Reference 记录
组成部分          按 Codec 规定的顺序
```

- `LLLL` 是包含 TAG WORD 在内的全部 WORD 数 − 1。解码器不必知道 Codec，仅凭 Length 就能跳到下一条记录。
- **第一个组成部分始终是 Edge Id（LOCAL Reference）。** 它是 LOCAL Reference（`0051` + ID，Identified `0x005L`），因此不知道 Codec 也能读出 Edge Id。
- 各组成部分依靠自己的 Length 找到边界。读完最后一个组成部分的位置必须与 Edge 的末尾恰好吻合。
- 组成部分的构成（Payload）由各 Edge Codec 文档规定。
- 有子格式的 Codec（WORLD、TIMELINE、SCENE）用每个 Codec 专属的 1 个 TAG WORD 指定子格式。
- Edge 记录之间的顺序没有意义（Codec 另有规定的除外。例：[TOULMIN](../toulmin/_index.md) 文档）。
- 指向其他 Edge 时使用 Edge Id。本文档的 Edge 用 LOCAL 指向，其他文档的 Edge 用指示 Reference（`EXTERNAL-POINTER-*`、`EXTERNAL-ISSUER-*`）指向。

## 系列 {#계열}

Edge 区域是 `0x0A0L~0x1BFL`。直接码的系列是 `(码 − 0xA0) >> 5`（码是 TAG ID 的前三位）。系列每 32 格一个，等于章节 `w >> 9` 减去 5 的值。Edge 是章节 5~13。

| 章节 | 系列 | 直接码 | 作用 |
|---|---|---|---|
| 5 | 陈述 | `0x0A0L~0x0BFL` | 构成关于世界和事件的内容 |
| 6 | 依据 | `0x0C0L~0x0DFL` | 记录和文档来自何处（[SOURCE](0x0C0L-source.md)） |
| 7 | 执行 | `0x0E0L~0x0FFL` | 可执行的程序结构（AST） |
| 8 | [TOULMIN](../toulmin/_index.md) | `0x100L~0x11BL` | 论证图：主张、反驳、例外，攻击关系，执行，判定结果 |
| 9 | [TOULMIN](../toulmin/_index.md) 格式 | `0x120L~0x134L` | TOULMIN 文档的原文、分段、辅助节点及关系 |

- 已分配的直接码就是这五个系列。`0x11CL~0x11FL` 是 Reserved，`0x135L~0x1BCL` 是 Reserved（章节 10~12 整个章节都是 Reserved）。
- `0x1BDL~0x1BFL`（章节 13 末尾三格）是 EDGE-ISSUER（见下文 Issuer 格式 Edge）。Issuer 格式没有系列规则。

## 陈述 Edge {#서술-edge}

| Codec | 名称 | 组成部分 |
|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](0x0A0L-reference-node.md) | Subject（Reference）指示 Object 的有向绑定 |
| `0x0A1L` | [SAME-NODE](0x0A1L-same-node.md) | 两个 Reference 指示同一对象 |
| `0x0A2L` | [DIFFERENT-NODE](0x0A2L-different-node.md) | 两个 Reference 指示不同对象 |
| `0x0A3L` | [BIND](0x0A3L-bind.md) | 把机器用名称（UTF8-TEXT）绑定到 Subject |
| `0x0A4L` | [LABEL](0x0A4L-label.md) | Subject 的各语言名称（UTF8-LANGUAGE-TEXT） |
| `0x0A5L` | [ALIAS](0x0A5L-alias.md) | Subject 的其他名称。布局与 LABEL 相同 |
| `0x0A6L` | [DESCRIPTION](0x0A6L-description.md) | Subject 的各语言说明。布局与 LABEL 相同 |
| `0x0A8L`/`0x0A9L` | [VERB-SHORT](0x0A8L-verb-short.md) / [VERB](0x0A9L-verb.md) | 动词陈述 |
| `0x0AAL` | [TRIPLE](0x0AAL-triple.md) | 一个命题（Predicate、Subject、Object）和 rank |
| `0x0ABL` | [QUALIFIER](0x0ABL-qualifier.md) | 限定其他 Edge 命题的一个条件 |
| `0x0B0L~0x0B2L` | [WORLD](0x0B0L-world.md) / [TIMELINE](0x0B1L-timeline.md) / [SCENE](0x0B2L-scene.md) | 世界观、事件顺序、场景结构 |
| `0x0B8L~0x0BAL` | [PUBLICATION](0x0B8L-publication.md) / [DEPRECATION](0x0B9L-deprecation.md) / [TOMBSTONE](0x0BAL-tombstone.md) | 文档版本的公布、废弃建议、删除（[公布地址与版本列表](../publishing.md#버전-목록)） |
| `0x0BBL~0x0BEL` | [DECLARE](0x0BBL-declare.md) / [FIELD](0x0BCL-field.md) / [ENUM](0x0BDL-enum.md) / [CODEC](0x0BEL-codec.md) | 编写 Codec 规格所用的词汇（[Codec 规格文档](../codec-spec.md)） |

- `-SHORT` 与一般形式按偶数、奇数成对设置（VERB-SHORT `0x0A8L`/VERB `0x0A9L`）。LABEL 把语言作为 Object（UTF8-LANGUAGE-TEXT）内部的语言记录来接收，所以只使用 `0x0A4L` 一个。
- PUBLICATION、DEPRECATION、TOMBSTONE 由版本列表文档使用。由于必须无需 codebook 就能读取版本列表，它们内置于解码器（[公布地址与版本列表](../publishing.md#층)的第 0 层）。
- DECLARE、FIELD、ENUM、CODEC 是编写 Codec 规格所用的词汇。由于必须无需 codebook 就能读取规格文档，其布局内置于解码器（第 0 层）。用这套词汇写成的各 Codec 规格文档是一般文档。

### TRIPLE {#triple}

详见：[TRIPLE](0x0AAL-triple.md)

```
TAG WORD          0000 1010 1010 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference
Predicate         Reference (维基数据属性等)
Subject           Reference
Object            Reference 或 Value
Rank              1 WORD
```

| Rank | 名称 | 含义 |
|---|---|---|
| `0` | normal | 默认 |
| `1` | preferred | 当前值，最具权威的值 |
| `2` | deprecated | 被判定为错误或过时但仍作为记录保留的值 |

- Rank 与维基数据 statement rank 相同。不单独标注 rank 的来源使用 `0`。
- **TRIPLE 的含义是指向其 Edge Id 的所有 QUALIFIER 汇集在一起的结果。** 读取方在解释 TRIPLE 之前先收集 QUALIFIER。

例：Q42 — P31（instance of）— Q5（人），normal，Edge Id 2

```
0AA9  0051 0002  0191 001F  0141 002A  0141 0005  0000
TAG   #2         P31        Q42        Q5         normal
```

### QUALIFIER {#qualifier}

详见：[QUALIFIER](0x0ABL-qualifier.md)

```
TAG WORD          0000 1010 1011 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference
Property          Reference
Target            LOCAL Reference (被限定 Edge 的 Edge Id)
Value             Reference 或 Value
```

- QUALIFIER 是命题的一部分。它不是关于命题的单独主张，而是限定命题成立的条件（起止时间、适用范围等）。
- 关于命题的单独主张（谁提出的等）用 TRIPLE 书写。
- Target 是同一文档中的 Edge。同一 Target 的 QUALIFIER 顺序就是文档内的顺序。

例：Q42 — P69（educated at）— Q691283，开始（P580）1971

```
0AAA 0051 0003 0191 0045 0141 002A 0142 000A 8C53 0000   TRIPLE    #3 P69 Q42 Q691283 normal
0AB9 0051 0004 0191 0244 0051 0003 06E2 3139 3731        QUALIFIER #4 P580 #3 EDTF "1971"
```

### LABEL, ALIAS, DESCRIPTION {#label-alias-description}

详见：[LABEL](0x0A4L-label.md)、[ALIAS](0x0A5L-alias.md)、[DESCRIPTION](0x0A6L-description.md)

```
TAG WORD          0000 1010 0100 LLLL   (LABEL)
[Length 扩展 TAG]
Edge Id           LOCAL Reference
Subject           Reference
Object            UTF8-LANGUAGE-TEXT
```

- 名称和语言放在一个 Object（UTF8-LANGUAGE-TEXT）里。
- 同一 Subject、同一语言的 LABEL 至多一个。其他名称用 ALIAS 书写。
- 没有语言的机器用名称用 BIND 书写。LABEL 必须有语言。

### BIND {#bind}

详见：[BIND](0x0A3L-bind.md)

- 把机器对接用的名称（UTF8-TEXT）绑定到 Subject。没有语言，也不做规范化。字节相同才是同一名称。
- 名称的范围是包含该 BIND 的文档。同一文档中不把同一名称绑定到不同的 Subject。
- 其他记录不通过名称，而是通过 LOCAL ID 来指向。名称用于与外部（宿主函数、地址输入、人）对接。

### SAME-NODE, DIFFERENT-NODE, REFERENCE-NODE {#same-node-different-node-reference-node}

详见：[SAME-NODE](0x0A1L-same-node.md)、[DIFFERENT-NODE](0x0A2L-different-node.md)、[REFERENCE-NODE](0x0A0L-reference-node.md)

- SAME-NODE 是两个 Reference 指向同一对象的同一性。它具有自反性、对称性、传递性。
- DIFFERENT-NODE 是两个 Reference 为不同对象的非同一性。
- REFERENCE-NODE 是用 Object 定义 Subject（Reference）是什么的有向绑定。它不是同一性主张。例：定义 LOCAL 节点所指向的 URI。

## 依据 Edge {#근거-edge}

为 BODY 中的单个记录或整个文档（HEAD）附加依据。依据系列的直接码只有 [SOURCE](0x0C0L-source.md)（`0x0C0L`）一个。

| Codec | 名称 | 组成部分 |
|---|---|---|
| `0x0C0L` | [SOURCE](0x0C0L-source.md) | Target（被附加依据的 BODY Edge 的 Edge Id，在 HEAD 中 `0` = 整个文档），Origin（来源 Reference，ABSENT 或 UNKNOWN-VALUE） |
| `0x0C1L~0x0DFL` | Reserved | |

- 来源本身的性质（URL、标题、作者、发行日期 …）用以来源为 Subject 的 TRIPLE 书写，引用的性质（查阅日期、来源内的位置 …）用以 SOURCE 的 Edge Id 为 Target 的 QUALIFIER 书写。
- 整个文档的来源在 HEAD 中用 Target 为 `0` 的 SOURCE 书写，以它为 Target 的 QUALIFIER 也放在 HEAD 中。HEAD 中只能出现这两种 Edge，Edge Id 由 HEAD 和 BODY 共用一个编号空间（[整个文档的出处](0x0C0L-source.md#문서-전체의-출처)）。
- 其他依据（原文范围、制作主体、可信度、各条文的施行期间、旧记录）用 QUALIFIER 书写，最初进入的版本由版本历史计算得出（[SOURCE](0x0C0L-source.md#다른-근거의-표현)）。
- 记录级别的判定结果由 TOULMIN `VERDICT` 负责。

### SOURCE {#source}

详见：[SOURCE](0x0C0L-source.md)

```
TAG WORD          0000 1100 0000 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference
Target            LOCAL Reference (被附加依据的 BODY Edge 的 Edge Id，在 HEAD 中为 0 = 整个文档)
Origin            Reference 或占位标记 0x0000 ABSENT、0x0010 UNKNOWN-VALUE
```

例：Q42 P19 TRIPLE `#178` 的出处是不列颠百科全书（Q5375741），其中的标识符 P1417

```
SOURCE     #1347  #178   Q5375741
QUALIFIER  #1348  P1417  #1347  "biography/Douglas-Adams"
```

## 执行 Edge {#실행-edge}

不绑定特定编程语言的程序结构。组成部分用本文档的 LOCAL ID 指向。

| 分组 | Codec |
|---|---|
| 声明 | [FUNCTION-DECLARE](0x0E1L-function-declare.md)、[TYPE-DECLARE](0x0E2L-type-declare.md) |
| 表达式 | [CONST](0x0E8L-const.md)、[UNARY](0x0E9L-unary.md)、[BINARY](0x0EAL-binary.md)、[CALL](0x0EBL-call.md)、[MEMBER](0x0ECL-member.md)、[INDEX](0x0EDL-index.md)、[CONSTRUCT](0x0EEL-construct.md)、[CONDITIONAL](0x0EFL-conditional.md) |
| 语句 | [BLOCK](0x0F0L-block.md)、[ASSIGN](0x0F1L-assign.md)、[IF](0x0F2L-if.md)、[SWITCH](0x0F3L-switch.md)、[WHILE](0x0F4L-while.md)、[FOREACH](0x0F5L-foreach.md)、[JUMP](0x0F6L-jump.md)、[RETURN](0x0F7L-return.md) |
| 错误 | [RAISE](0x0F8L-raise.md)、[TRY](0x0F9L-try.md) |

- 这不是原样容纳外部语言代码的格式。外部语言的代码以 Issuer 格式放置。
- 组成部分用本文档的 LOCAL ID（REF）指向。表达式位置放表达式 Edge 或符号。REF `0` 表示无。
- 表达式产生值，语句不产生值。表达式可以放在 BLOCK 的语句位置（值被丢弃）。
- C 式 `for` 写成 BLOCK（初始化、WHILE），`else if` 写成假分支位置的 IF。
- 符号是 LOCAL ID，名称用 BIND 绑定。其他记录不通过名称，而是通过 LOCAL ID 指向符号。名称相同但 LOCAL ID 不同则是不同的符号。
- 符号是什么（变量、参数、函数、类型）由指向该符号的记录决定。文档内没有定义的符号由外部（宿主）提供，若是 CALL 的目标则为宿主函数。

未决问题：运算符码、类型表示、各 Codec 的 Payload 布局。

## TOULMIN Edge {#toulmin-edge}

用图尔敏论证模型书写判定与执行图。直接码为 `0x100L~0x11BL`，辅助记录为 TOULMIN 格式系列 `0x120L~0x134L`。详见：[TOULMIN](../toulmin/_index.md)

## Issuer 格式 Edge {#issuer-형식-edge}

Issuer 可以定义并使用自己的 Edge 格式（[EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)、[4WORD](0x1BEL-edge-issuer-4word.md)、[16WORD](0x1BFL-edge-issuer-16word.md)，Codec `0x1BDL`~`0x1BFL`）。这是 Edge 区域末尾的三格。Codec 扩展 TAG 中放 Issuer 和 Codec 编号共 2 WORD。Edge Id 是其后 Payload 的第一个元素（TAG、Issuer、Codec 编号、Edge Id、其余 Payload）。Codec 编号由 Issuer 决定，没有系列规则。与 Kind 无关，在该 Issuer 的 `codecs/` 内不得重复。Codec 文档放在该 Issuer 的 `codecs/` 之下，以记录的 Codec 编号命名（[公布地址与版本列表](../publishing.md)）。

- 目前没有登记的 Edge ISSUER 格式。
