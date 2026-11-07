---
title: "代码索引"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "本页是所有 Codec 的索引。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

本页是所有 Codec 的索引。点击名称可进入该 Codec 的详细文档。表中没有的直接码为 Reserved。

## Kind {#kind}

TAG WORD 是 `000K KKKC CCCC LLLL`。高 4 位 `KKKK` 是章节，`C` 是章节内的 5 位偏移，`LLLL` 是 Length。章节与 `C` 合起来的 9 位就是 Codec 位置。TAG ID 写作 `0x000L`。前三位是这 9 位（`w >> 4`），`L` 是 Length 位（[记录与 TAG WORD](record.md)）。

| 章节 | TAG ID | 分类 | 说明 |
|---|---|---|---|
| 0~2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | 指向对象的记录 |
| 3·4 | `0x060L~0x09FL` | [Value](value/_index.md) | 值记录 |
| 5~13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | 组合记录 |
| 14·15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | 关于文档和记录的记录 |

- 章节为 `S = w >> 9`（4 位），每个章节有 32 个格位。
- Kind 由章节区间唯一判定：`w < 0x0600` 为 Reference，`w < 0x0A00` 为 Value，`w < 0x1C00` 为 Edge，其余为 Meta。没有例外。
- Reference、Value、Edge 区域的最后三个格位是 ISSUER（`..DL` 2 WORD，`..EL` 4 WORD，`..FL` 16 WORD）。Meta 没有 ISSUER。

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | 名称 | 分类 | 对象 ID |
|---|---|---|---|
| `0x000L~0x002L` | [占位标记](slot-marker.md) | 占位标记 | 不指向对象的 1 WORD 标记分组（见下表） |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | 声明 | 本文档发布的 ID |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | 声明 | geul.org 以 CC0 发布的实体。把较小的编号分配给高频实体 |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | 声明 | GEUL SIDX（Semantic-aligned Index）。比特中蕴含语义的标识符 |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | 声明 | Wikidata 条目。`Q` 之后的整数 |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | 声明 | Wikidata 属性。`P` 之后的整数 |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | 指示 | 经 `IMPORT-DOC` 导入的文档的 LOCAL ID。IMPORT ID 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | 指示 | 同上。IMPORT ID 2 WORD |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | 指示 | 同上。IMPORT ID 4 WORD |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | 指示声明 | 2 WORD Issuer 文档的 LOCAL ID |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | 指示声明 | 4 WORD Issuer 文档的 LOCAL ID |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | 指示声明 | 16 WORD Issuer 文档的 LOCAL ID |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | 指示声明 | Issuer 本身。Payload 只有 Issuer（2/4/16 WORD），没有对象 ID |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | 指示声明 | Issuer 文档的一个版本。Issuer + 文档 ID 4 WORD + 版本 ID 2 WORD，没有对象 ID |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | 指示声明 | Issuer Codec 的一个版本。Issuer + Codec ID 2 WORD + 版本 ID 2 WORD，没有对象 ID |
| `0x043L` | [TOKEN-0](reference/0x043L-token.md) | 声明 | GEUL 词元词表的条目（词元 ID 0~65,535）。Payload 1 WORD，总计 2 WORD |
| `0x044L` | [TOKEN-1](reference/0x043L-token.md) | 声明 | 同上。词元 ID 65,536~131,071（65,536 + Payload） |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | Issuer 格式 | Issuer 2 WORD 与 Codec 编号 2 WORD。分类和对象由 Issuer 文档规定 |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | Issuer 格式 | Issuer 4 WORD 与 Codec 编号 2 WORD。同上 |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | Issuer 格式 | Issuer 16 WORD 与 Codec 编号 2 WORD。同上 |

- Reference 有三个章节。章节 0 实体 `0x000L~0x01FL`（占位标记，5Q 体系），章节 1 EXTERNAL `0x020L~0x03FL`，章节 2 其他 `0x040L~0x05FL`（指针，REFERENCE-ISSUER）。Reserved 是 `0x003L~0x004L`、`0x01EL~0x01FL`、`0x03EL~0x03FL`、`0x045L~0x05CL`。
- 5 格分组（从 LOCAL 到 EXTERNAL-ISSUER-16WORD）按下面的 Quantifier 顺序各占一格。例：WIKIDATA-QID Identified `0x014L`，Generic `0x015L`。

### 占位标记（`0x000L~0x002L`） {#자리-표지-0x000l0x002l}

`0x0000`、`0x0010`、`0x0020` — [占位标记](slot-marker.md)。仅当字段的 CODEC 列表恰好列出该 WORD 时，才可出现在该位置。

| WORD | 名称 | 含义 | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | 未填写。省略了可选字段。对世界不作任何断言 | 无 snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | 未知。有值但不知道是什么 | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | 无。没有值 | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | 名称 | 含义 | 示例 |
|---|---|---|---|
| `0` | Identified | 已识别的个体 | 埃隆·马斯克、大韩民国 |
| `1` | Generic | 关于整个种类的一般性、定义性陈述。允许例外。 | 士兵服从命令 |
| `2` | Free-choice | 满足条件的任意对象 | 任何一个士兵 |
| `3` | Universal | 属于给定范围的所有对象 | 所有士兵 |
| `4` | Variable | 话语变量 | 那个人、这个女人 |

- 量化由章节内偏移 `C` 读出。章节 0 中 `5 <= C < 30` 时，量化为 `C % 5`，体系为 `C / 5`（1~5）。章节 1 中 `C < 30` 时，量化为 `C % 5`，体系为 `6 + C / 5`（6~11）。标记（章节 0，`C < 3`）和章节 2（指针，REFERENCE-ISSUER）不使用。
- ISSUER-POINTER、DOC-POINTER、CODEC-POINTER 是没有量化的单格。REFERENCE-ISSUER 的量化由 Issuer 发布的 Codec 文档规定。

## Issuer {#issuer}

Issuer 是定义文档和格式的主体 — [Issuer 与公布](issuer.md)

| 位置 | 含义 |
|---|---|
| Reference·Value·Edge 的 ISSUER 代码（各区域末尾三格） | 该 Issuer 定义的格式 |
| Meta `DOC-ID` | 发布本文档的 Issuer |
| Meta `IMPORT-DOC` | 发布被导入文档的 Issuer |
| Reference `EXTERNAL-ISSUER-*`·`DOC-POINTER`·`CODEC-POINTER` | 发布所指文档、Codec 的 Issuer（2/4/16 WORD） |
| Reference `ISSUER-POINTER` | 所指的 Issuer 本身（2/4/16 WORD） |

| Issuer 宽度 | 发放 |
|---|---|
| 2 WORD | 在 geul.org 注册。经过域名所有权证明（例：company.com）的 Issuer。geul.org 分配给标准制定机构和主要机构的编号也是这个宽度（[2 WORD 分配表](issuer.md#2-word-배정표)）。 |
| 4 WORD | 在 geul.org 注册。未经所有权证明而注册的 Issuer |
| 16 WORD | 自行发放。无需注册，由公钥计算得出。遵循下面的生成规则。 |

### 16 WORD Issuer 签名算法 {#16-word-issuer-서명-알고리즘}

| 签名算法 ID | 算法 |
|---|---|
| `0x0001` | Ed25519 |
| 其他 | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

直接码的系列为 `(代码 − 0xA0) >> 5`（代码是 TAG ID 的前三位）。每个系列 32 格，等于章节 `w >> 9` 减去 5 的值。已分配的直接码为下面五个系列。`0x135L~0x1BCL` 是 Reserved（章节 10~12 整个章节都是 Reserved）。Issuer 格式没有系列规则。

| 章节 | 系列 | 直接码 |
|---|---|---|
| 5 | 陈述 | `0x0A0L~0x0BFL` |
| 6 | 依据 | `0x0C0L~0x0DFL` |
| 7 | 执行 | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | [TOULMIN](toulmin/_index.md) 格式 | `0x120L~0x134L` |

- `0x11CL~0x11FL` 是 Reserved。
- `0x1BDL~0x1BFL`（章节 13 的末尾三格）是 EDGE-ISSUER（见下面的 Edge ISSUER 格式）。

### 陈述（`0x0A0L~0x0BFL`） {#서술-0x0a0l0x0bfl}

| Codec | 名称 | 子格式 | 说明 |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | 作为 Reference 的 Subject 指示 Object 的有向绑定 |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | 两个 Reference 指示同一对象的同一性 |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | 两个 Reference 指示不同对象的非同一性 |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | 把机器匹配用的名称（`UTF8-TEXT-*`）绑定到 Subject。在范围内唯一且必须精确匹配，没有语言 |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | 连接 Subject 的语言名称（label）。Object 是 UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | 连接 Subject 的其他名称（别名）。布局与 LABEL 相同 |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | 连接 Subject 的语言说明（description）。布局与 LABEL 相同 |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | 动词陈述缩略 |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | 动词陈述 |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | 按 Predicate、Subject、Object 顺序的命题与 rank。Object 是值或 UNKNOWN-VALUE·NO-VALUE 标记。含义是汇集所有指向该 Edge Id 的 QUALIFIER |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | 限定另一个 Edge 命题的一个条件。Property、Target（Edge Id）、Value（值或 UNKNOWN-VALUE·NO-VALUE 标记）。是命题的一部分 |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | 有 | 用于表达世界观的结构 |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | 有 | 表达世界与事件顺序的结构 |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | 有 | 用于描述情景特征的场景结构 |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | 文档公布。DOC-POINTER、内容哈希 |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | 对已公布版本的 deprecate。DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | 已公布版本的删除（墓碑）。DOC-POINTER、原因类别 |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | 一个 Codec 的 Payload 构成声明。目标 Kind·Codec |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | 一个 Payload 字段。所属 DECLARE，宽度：记录（TAG 的 Length）或原始值 n WORD |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | 原始值字段的一个码值。字段、码值 |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | 字段接受的一个 Kind·Codec。字段、目标 WORD（`000K KKKC CCCC LLLL`，LLLL 0000 精确·1111 通配符（该章节 32 格全部），占位标记只能用精确目标 `0000`·`0010`·`0020`）。记录字段可有多个（封闭列表），原始值字段只有一个（无 TAG 的该 Value） |
| `0x0BFL` | Reserved |  |  |

| TAG ID | 分组 |
|---|---|
| `0x0A0L~0x0A7L` | 指示与名称 |
| `0x0A8L~0x0AFL` | 命题 |
| `0x0B0L~0x0B7L` | 结构 |
| `0x0B8L~0x0BFL` | 其他 |

### 依据（`0x0C0L~0x0DFL`） {#근거-0x0c0l0x0dfl}

| Codec | 名称 | 子格式 | 说明 |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | 把一条记录或整个文档连到其来源。Target（BODY Edge Id，在 HEAD 中 `0` = 整个文档）、Origin（Reference，ABSENT 或 UNKNOWN-VALUE）。来源的性质用以来源为 Subject 的 TRIPLE 表达，引用的性质（查阅日期、位置、原文哈希）用附在 SOURCE 上的 QUALIFIER 表达。整个文档的 SOURCE 及其 QUALIFIER 放在 HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- 原文范围、创建主体、可信度、各条文施行期间、旧记录用 QUALIFIER 书写，最初进入的版本由版本历史计算得出（[SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)）。

### 执行（`0x0E0L~0x0FFL`） {#실행-0x0e0l0x0ffl}

| Codec | 名称 | 说明 |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | 函数声明。符号、形参符号列表、返回类型、函数体（BLOCK） |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | 类型声明。符号与构成（字段符号列表、枚举值、别名目标） |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | 常量表达式。一个内嵌 Value |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | 一元表达式。运算符 1 WORD、操作数 |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | 二元表达式。运算符 1 WORD、左、右 |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | 调用。目标函数、实参数、实参 × 实参数 |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | 成员访问。目标、字段符号 |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | 索引访问。目标、索引 |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | 复合值构造（列表、记录）。类型、元素数、元素 × 元素数 |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | 条件表达式。条件、为真时的值、为假时的值 |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | 有序语句组。语句数、语句 × 语句数 |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | 赋值。目标（符号、MEMBER、INDEX）、值 |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | 条件分支。条件、真 BLOCK、假（BLOCK·IF，没有则为 0） |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | 多路分支。目标、分支数、（值, BLOCK）× 分支数、默认 BLOCK（没有则为 0） |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | 条件循环。条件、循环体 BLOCK |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | 遍历循环。元素符号、目标、循环体 BLOCK |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | 循环控制。种类 1 WORD（break、continue）、目标循环 |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | 返回。值（没有则为 0） |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | 抛出错误。错误值 |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | 错误处理。主体 BLOCK、错误符号、处理 BLOCK、收尾 BLOCK（没有则为 0） |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | 分组 |
|---|---|
| `0x0E0L~0x0E7L` | 声明 |
| `0x0E8L~0x0EFL` | 表达式 |
| `0x0F0L~0x0F7L` | 语句 |
| `0x0F8L~0x0FFL` | 错误 |

### TOULMIN（`0x100L~0x11BL`） {#toulmin-0x100l0x11bl}

详见：[TOULMIN](toulmin/_index.md)

| Codec | 名称 | 说明 |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | 案件声明。容纳节点和关系的判定图 |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | 谓词声明。判定函数·表达式、判断标准（Spec）、事实契约（Ground） |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | 判断标准声明。常量·列表（Backing） |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | 主张声明。在案件内把谓词设为一般规则（Warrant）。可被攻击。 |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | 反驳声明。带有自己的结论进行攻击。默认 Level 为 Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | 例外声明。不带自己的结论进行攻击。默认 Level 为 Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | 攻击关系。攻击者的判定逐步削减目标的判定。 |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | 排除关系。攻击者为 Active 时，把目标从汇总中确定性地剔除。 |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | 优先级链 `A > B > C`。成对 SUPERSEDES 的缩写。布局未定 |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | 执行组合。节点为 Active 时执行下级案件（DAG）。 |
| `0x111L` | [DO](toulmin/0x111L-do.md) | 节点为 Active 时执行的动作 |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | 即使重试也只执行一次的动作 |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | DO 的补偿动作（saga）。后续步骤失败时按逆序执行。 |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | 无副作用、只做判定的连接 |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | 外部入口点。执行或判定案件 |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | 无外部调用的事件·周期入口点 |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | 节点·记录的判定结果。结果（Pass、Review、Fail）、判定值、Activated、Excluded、Level。布局未定。整个文档的判定为 Meta [VERDICT](meta/0x1E9L-verdict.md)（`0x1E9L`） |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | 判定的证据。位置、期望值、实际值（Fact）。布局未定 |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | 分组 |
|---|---|
| `0x100L~0x107L` | 声明 |
| `0x108L~0x10FL` | 关系 |
| `0x110L~0x117L` | 执行 |
| `0x118L~0x11FL` | 结果（`0x11CL~0x11FL` 为 Reserved） |

### TOULMIN 格式（`0x120L~0x134L`） {#toulmin-형식-0x120l0x134l}

[TOULMIN](toulmin/_index.md) 文档的原文、划分和辅助节点与关系。

| Codec | 名称 | 说明 |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | 撰写的原文。SPAN 宽度与 UTF8 Value |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | 名称·字符串 |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | 章节开始。章节代码 |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | 案件范围开始 |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | 案件范围结束 |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | 叙述段落（SPAN） |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE。`this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE。函数引用 |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE。`is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE。`see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE。有序执行分组 |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK。案件 → 字段 |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK。定义项 → 值·类型 |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK。定义项 → 字段 |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK。入口点 → 案件，执行 |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK。入口点 → 案件，判定 |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK。触发器 → 案件 |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK。触发器 → 案件（`every … until`） |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK。节点 → 全局标识符 |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK。别名 → 路径（TEXT） |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK。节点 → TEXT，名称标注 |

- `0x135L~0x1BCL` 是 Reserved。

### Edge ISSUER 格式 {#edge-issuer-형식}

`0x1BDL`~`0x1BFL`（[EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md)、[-4WORD](edge/0x1BEL-edge-issuer-4word.md)、[-16WORD](edge/0x1BFL-edge-issuer-16word.md)）之后的 Codec 扩展 TAG 中放置 Issuer 与 Codec 编号 2 WORD。目前没有登载的 Edge ISSUER 格式。

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

Value 编号不代表系列。直接码在 `0x060L~0x081L` 内不留 Reserved。`0x082L~0x09CL` 是 Reserved，`0x09DL~0x09FL` 是 VALUE-ISSUER。系列名称（NUMERIC、DECIMAL、TIME、TEXT、BINARY）是主题分组。偶数·奇数对从偶数代码开始。

| 系列 | 直接码 |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`、`0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### 直接码 {#직접-코드}

| Codec | 名称 | 系列 | 说明 |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | 固定 1 WORD 的 false 或 true |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | 最小 WORD 二进制补码有符号整数 |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | 最小 WORD big-endian unsigned magnitude 整数 |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | Payload 1/2/4/8 WORD 的 IEEE 754 binary16/32/64/128 scalar |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | 地球（WGS 84）纬度·经度 binary64，不确定度 binary32 及其单位 Reference（ABSENT = 未知） |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | 天体 Reference 与纬度·经度 binary64，不确定度 binary32 及其单位 Reference |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | 数值 Value amount（整数·BINARY-FLOAT·十进制数·分数）、单位 Reference、下限·上限。单位·边界可省略（ABSENT `0x0000`） |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | 保留原文写法的分数：整数·十进制数分子，无符号整数·十进制数分母。不约分 |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | signed exponent `E` 与最小 WORD 二进制补码 coefficient `C` 的 `C×10^E` |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | signed exponent `E` 与最小 WORD unsigned coefficient `C` 的 `C×10^E` |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | 以 proleptic Gregorian `1970-01-01` 为基准的 signed 天数 |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | 民用日午夜之后的 unsigned nanosecond 计数 |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | 自 Unix/POSIX epoch 起的 signed 秒计数 |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | 无 epoch 的 signed SI-second 经过时间 |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | EDTF（ISO 8601-2）日期字符串。偶数·奇数字节。可用 GREGORIAN-DATE 表示的日期不使用 |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | GEDCOM 7 日期值字符串。保留其他历法（儒略历等）的原始写法。偶数·奇数字节 |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | 不暗示规范化的 valid UTF-8 字节序列。偶数字节 |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | 同上。奇数字节 |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | RFC 3986 `URI` production ASCII 字节序列。偶数字节 |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | 同上。奇数字节 |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | canonical casing 的完整 BCP 47 language tag ASCII 字节序列。偶数字节 |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | 同上。奇数字节 |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | 带语言的文本。语言 Value 记录（LANGUAGE-SHORT-CODE 或 LANGUAGE-BCP47-CODE）与 UTF-8 字节。文本字节的偶数·奇数 |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | 以 GEUL Language Registry 编号书写的 BCP 47 tag（Payload 1 WORD） |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | 固定 Payload 8 WORD 的 RFC 9562 UUID 128bit |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | 固定 Payload 16 WORD 的 SHA-256 结果 |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | 固定 Payload 10 WORD 的 SHA-1 结果。仅用于 git 对象 ID 之类的标识用途 |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | 含义·格式不明的字节序列。偶数字节 |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | 同上。奇数字节 |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | bit-count 之后以 MSB-first 存储的 N bit |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | 无 epoch 的 signed nanosecond 经过时间 |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md)、[-4WORD](value/0x09EL-value-issuer-4word.md)、[-16WORD](value/0x09FL-value-issuer-16word.md) |  | Issuer 定义的格式。见下面的 Value ISSUER 格式 |

### Value ISSUER 格式 {#value-issuer-형식}

`0x09DL`~`0x09FL`（[VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md)、[-4WORD](value/0x09EL-value-issuer-4word.md)、[-16WORD](value/0x09FL-value-issuer-16word.md)）之后的 Codec 扩展 TAG 中放置 Issuer 与 Codec 编号 2 WORD。Codec 文档放在该 Issuer 的 `codecs/` 之下，以记录的 Codec 编号命名。例：IETF CRC32C 位于 `0x00000007/codecs/0x0000C000/`（[公布地址与版本列表](publishing.md)）。

| Issuer | Codec 编号 | 名称 | 说明 |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | 固定 Payload 1 WORD 的 BF16 interchange bits |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | 连续 big-endian int16 vector |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | 连续 big-endian uint16 vector |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | 连续 big-endian int32 vector |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | 连续 big-endian uint32 vector |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | 连续 big-endian int64 vector |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | 连续 big-endian uint64 vector |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | 连续 IEEE 754 binary16 vector |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | 连续 BF16 vector |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | 连续 IEEE 754 binary32 vector |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | 连续 IEEE 754 binary64 vector |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | 按 `(x,y)` 顺序的 IEEE binary64 二维 vector |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | 按 `(x,y,z)` 顺序的 IEEE binary64 三维 vector |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | 按 `(minX,minY,maxX,maxY)` 顺序的 IEEE binary64 vector |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format·rank·shape 与 C-contiguous dense payload |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format·rank·shape 与 octet 内 low-bit-first packed payload |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | 按 `(real, imag)` 顺序的两个 binary32 |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | 按 `(real, imag)` 顺序的两个 binary64 |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | 规范化的 int64 numerator 与正 int64 denominator |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | `lower ≤ upper` 的 binary64 闭区间 |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | 按 `(x,y,z,w)` 顺序的四个 binary32 |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | 固定 Payload 16 WORD 的默认 BLAKE3 结果 |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | RFC 3986 relative-ref ASCII 字节序列。偶数字节 |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | 同上。奇数字节 |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | 固定 Payload 2 WORD 的 Castagnoli CRC-32C 结果 |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | 固定 Payload 2 WORD 的 IPv4 地址 32bit |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | 固定 Payload 8 WORD 的 IPv6 地址 128bit |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | 固定 Payload 2 WORD 的 IEEE 754 decimal32 DPD |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | 固定 Payload 4 WORD 的 IEEE 754 decimal64 DPD |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | 固定 Payload 8 WORD 的 IEEE 754 decimal128 DPD |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | 固定 Payload 2 WORD 的 IEEE 754 decimal32 BID |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | 固定 Payload 4 WORD 的 IEEE 754 decimal64 BID |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | 固定 Payload 8 WORD 的 IEEE 754 decimal128 BID |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | 自 Unix/POSIX epoch 起的 signed nanosecond 计数 |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | 固定 Payload 3 WORD 的 IEEE 802 MAC 地址 48bit |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | 按 R, G, B, A 顺序的固定 4×UNORM8 packed vector |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | 按 B, G, R, A 顺序的固定 4×UNORM8 packed vector |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | Payload 高位 octet 的 ONNX E4M3FN scalar |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | Payload 高位 octet 的 ONNX E4M3FNUZ scalar |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | Payload 高位 octet 的 ONNX E5M2 scalar |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | Payload 高位 octet 的 ONNX E5M2FNUZ scalar |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | Payload 高位 octet 的 unsigned exponent-only E8M0FNU scalar |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | Payload 高位 nibble 的 ONNX/DLPack E2M1FN scalar |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | 自 `1970-01-01T00:00:00 TAI` 起的 signed SI-second 计数 |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | 自同一 TAI epoch 起的 signed nanosecond 计数 |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | 固定 Payload 32 WORD 的 SHA-512 结果 |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | 固定 Payload 16 WORD 的 SHA3-256 结果 |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | 自 GPS epoch 起的 signed second 计数 |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | 自 GPS epoch 起的 signed nanosecond 计数 |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

Meta 编号不以比特表示类。类通过下面的区间表得知。验证类是章节 15 中 `C >= 5`，即 `w >= 0x1E50` 的记录，无需 Codec 手册即可得知。Meta 没有 ISSUER 代码。

| 类 | 直接码 | 涉及内容 |
|---|---|---|
| [结构](meta/_index.md#구조) | `0x1C0L~0x1C4L` | 文档的边界与长度 |
| [定义](meta/_index.md#정의) | `0x1C5L~0x1CAL` | 解释声明 |
| [出处](meta/_index.md#출처) | `0x1CBL~0x1D0L` | 谁、何时、何地 |
| [谱系](meta/_index.md#계보) | `0x1D1L~0x1DDL` | 从什么、如何产生 |
| [策略](meta/_index.md#정책) | `0x1DEL~0x1E3L` | 如何处理 |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | 通过 IMPORT ID 导入外部文档（`IMPORT-DOC`） |
| [验证](meta/_index.md#검증) | `0x1E5L~0x1E9L` | 是否可信 |
| Reserved（验证专用） | `0x1EAL~0x1FFL` |  |

- 编号从 `0x1C0L` 起连续，没有 Reserved。验证之外的新 Meta 不能插入到验证之前。后面的 Reserved `0x1EAL~0x1FFL` 为验证专用。把验证之外的 Meta 放在这里，会被排除在内容哈希之外。

### 结构（`0x1C0L~0x1C4L`） {#구조-0x1c0l0x1c4l}

| Codec | 名称 | 说明 |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | 总长度以 Payload 1 WORD 指定的文档开始 |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | 总长度以 Payload 2 WORD 指定的文档开始 |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | 总长度以 Payload 4 WORD 指定的文档开始 |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD。结束文档的 HEAD 并开始 BODY。 |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD。关闭文档。 |

### 定义（`0x1C5L~0x1CAL`） {#정의-0x1c5l0x1cal}

| Codec | 名称 | 说明 |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | 所遵循的 GEUL 规范版次。Payload 本身就是最短宽度的 unsigned 整数。v1 是 `0x0001`（记录 `0x1C51 0x0001`） |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | 适用的配置文件 |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | 本文档的标识符。内嵌 Reference `DOC-POINTER`（Issuer、文档 ID、版本 0）。Codec 文档为 `CODEC-POINTER`（Issuer、Codec ID、版本 0） |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | 本版本的施行日。GREGORIAN-DATE 或 POSIX-TIMESTAMP Value。没有则为公布时刻 |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | 本版本的有效期终点（限时法）。没有则持续到下一版本施行为止 |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | 默认语言 |

### 出处（`0x1CBL~0x1D0L`） {#출처-0x1cbl0x1d0l}

| Codec | 名称 | 说明 |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | 作者。Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | 共同作者。Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | 创作时刻。TIME Value (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | 修改时刻。TIME Value |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | 记录主体。Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | 记录时刻。TIME Value (git commit date) |

- 原始资料及其范围·获取时刻·哈希不写在 Meta 中，而是用 HEAD 的依据 Edge [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처)（Target `0`）及其 QUALIFIER 书写。

### 谱系（`0x1D1L~0x1DDL`） {#계보-0x1d1l0x1ddl}

| Codec | 名称 | 说明 |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | 上一版本的内容哈希 (git parent)。没有则为最初版本，有多个则为合并 (git merge commit)。 |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | 派生自其他谱系的记录·资料。要固定到外部资料的特定版本时，在 HEAD 的 [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처)上附加原文哈希 QUALIFIER (P4092)（git submodule）。 |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | 生成主体。人、模型、规则引擎 |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | 转换方法。工具·规则·版本 |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | 引入其他谱系变更的原版本的内容哈希 (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | 被撤销变更的目标版本的内容哈希 (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | 被改写的目标版本的内容哈希 (git amend·rebase)。不删除原版本。 |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | 被合并为一个的原版本们的内容哈希 (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | 变更原因。UTF8-LANGUAGE-TEXT Value，每种语言一个 (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | 附加在版本上的不可变名称。TEXT Value 与内容哈希 (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | 本版本文件是相对于同一文档基准版本（2 WORD 版本 ID）的 diff (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | diff 中要从基准 BODY 删除的 LOCAL ID（Edge Id）列表 |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | 下一个要分配的 LOCAL ID (auto increment)。放在版本列表 `versions.geul` 的 HEAD 中 |

### 策略（`0x1DEL~0x1E3L`） {#정책-0x1del0x1e3l}

| Codec | 名称 | 说明 |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | 许可证。Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | 公开范围 |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | 个人信息等级 |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | 保存期限 |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | 同意范围与依据 |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | 使用限制 |

### IMPORT（`0x1E4L`） {#import-0x1e4l}

| Codec | 名称 | 说明 |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | 通过 IMPORT ID 导入外部文档。内嵌 Reference `DOC-POINTER`（Codec 文档为 `CODEC-POINTER`）+ IMPORT ID |

### 验证（`0x1E5L~0x1E9L`） {#검증-0x1e5l0x1e9l}

| Codec | 名称 | 说明 |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | 自行发放的 Issuer 的签名算法 ID 与公钥声明 |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | 对目标的签名。对文档的签名是对内容哈希签名 (git 签名提交·标签) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | 贡献权利确认。Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | 可信度 |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | 整个文档的判定结果。Pass、Review、Fail。节点·记录级别为 [TOULMIN](toulmin/_index.md) `VERDICT`（Edge `0x118L`） |

## 全部分配表 {#전체-배정표}

已分配 227 格，md 176 个。5Q 体系和奇偶对的每个成员各占一行，md 是分组首个 md。

| TAG ID | Codec ID | 名称 | Kind | 章节 | md | 分组 |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x043L` | `0x00000430` | TOKEN-0 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | 成对 `TOKEN-0`·`TOKEN-1` |
| `0x044L` | `0x00000440` | TOKEN-1 | Reference | 2 | [0x043L-token.md](reference/0x043L-token.md) | 成对 `TOKEN-0`·`TOKEN-1` |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | 奇偶 `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | 奇偶 `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | 奇偶 `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | 奇偶 `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | 奇偶 `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | 奇偶 `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | 奇偶 `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | 奇偶 `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | 奇偶 `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | 奇偶 `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | 奇偶 `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | 奇偶 `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | 奇偶 `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | 奇偶 `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
