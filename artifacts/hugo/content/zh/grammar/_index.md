---
title: "GEUL 语法"
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "specification"]
summary: "GEUL v1 语法规范。定义 16 位 WORD 之上的记录、四种 Kind 与全部 Codec、文档结构、Issuer 与公布规则。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
showContent: true
---

这是 GEUL v1 语法规范。初次阅读请按以下顺序。

1. [概述](/zh/grammar/overview/) — GEUL 是什么，按什么原则设计
2. [记录与 TAG WORD](/zh/grammar/record/) — 16 位 TAG WORD、Kind、Length、Codec
3. [文档](/zh/grammar/document/) — HEAD 与 BODY、内容哈希、版本与修订
4. [Reference](/zh/grammar/reference/)、[Value](/zh/grammar/value/)、[Edge](/zh/grammar/edge/)、[Meta](/zh/grammar/meta/) — 四种 Kind
5. [Issuer 与公布](/zh/grammar/issuer/) — 发布文档和格式的主体、1 WORD 分配表、公开方式、签名与验证密钥
6. [公布地址与版本列表](/zh/grammar/publishing/) — ID 写法、公布地址、格式指定、名称索引、版本列表、信任层
7. [Codec 规格文档](/zh/grammar/codec-spec/) — 如何把 Codec 布局写成 GEUL 文档
8. [示例：Wikidata 条目](/zh/grammar/example/) — 一套真实文档

本页是所有 Codec 的索引。点击名称可进入该 Codec 的详细文档。没有链接的名称尚无详细文档。表中没有的直接码为保留。

## Kind

TAG WORD 是 `000K KLLL LCCC CCCC`。`KK` 是 Kind，`LLLL` 是 Length，`CCC CCCC` 是 7 位 Codec。但 Reference 是 4 位 Codec 加 3 位 Quantifier。

| 值 | 分类 | 说明 |
|---|---|---|
| `0000 0LLL LCCC CQQQ` | [Reference](/zh/grammar/reference/) | 指向目标的记录。`QQQ` 是 Quantifier |
| `0000 1LLL LCCC CCCC` | [Value](/zh/grammar/value/) | 值记录 |
| `0001 0LLL LCCC CCCC` | [Edge](/zh/grammar/edge/) | 构成记录 |
| `0001 1LLL LCCC CCCC` | [Meta](/zh/grammar/meta/) | 关于文档与记录的记录 |

## Reference

`0000 0LLL LCCC CQQQ` — [Reference](/zh/grammar/reference/)

### Codec (`CCCC`)

| CCCC | 名称 | 分类 | 目标 ID |
|---|---|---|---|
| `0000` | [占位标记](/zh/grammar/reference/slot-marker/) | 保留 | 不指向目标的 1 WORD 标记组。低 3 位是标记编号（见下表） |
| `0001` | [LOCAL](/zh/grammar/reference/local/) | 声明 | 本文档签发的 ID |
| `0010` | [GEUL](/zh/grammar/reference/geul/) | 声明 | geul.org 以 CC0 签发的实体。小编号分配给高频实体 |
| `0011` | [GEUL-SIDX](/zh/grammar/reference/geul-sidx/) | 声明 | GEUL SIDX（Semantic-aligned Index）。在比特中承载语义的标识符 |
| `0100` | [WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/) | 声明 | Wikidata 条目。`Q` 之后的整数 |
| `0101` | [WIKIDATA-PID](/zh/grammar/reference/wikidata-pid/) | 声明 | Wikidata 属性。`P` 之后的整数 |
| `0110` | [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/) | 指示声明 | Issuer 自身。Payload 只有 Issuer（1/2/4/16 WORD），没有目标 ID |
| `0111` | [DOC-POINTER](/zh/grammar/reference/doc-pointer/) | 指示声明 | Issuer 文档的某一版本。Issuer + 文档 ID 4 WORD + 版本 ID 2 WORD，没有目标 ID |
| `1000` | [EXTERNAL-POINTER-1WORD](/zh/grammar/reference/external-pointer/) | 指示 | 以 `IMPORT-DOC` 导入的文档的 LOCAL ID。IMPORT ID 1 WORD |
| `1001` | [EXTERNAL-POINTER-2WORD](/zh/grammar/reference/external-pointer/) | 指示 | 同上。IMPORT ID 2 WORD |
| `1010` | [EXTERNAL-POINTER-4WORD](/zh/grammar/reference/external-pointer/) | 指示 | 同上。IMPORT ID 4 WORD |
| `1011` | [EXTERNAL-POINTER-8WORD](/zh/grammar/reference/external-pointer/) | 指示 | 同上。IMPORT ID 8 WORD |
| `1100` | [EXTERNAL-ISSUER-1WORD](/zh/grammar/reference/external-issuer/) | 指示声明 | 1 WORD Issuer 文档的 LOCAL ID |
| `1101` | [EXTERNAL-ISSUER-2WORD](/zh/grammar/reference/external-issuer/) | 指示声明 | 2 WORD Issuer 文档的 LOCAL ID |
| `1110` | [EXTERNAL-ISSUER-4WORD](/zh/grammar/reference/external-issuer/) | 指示声明 | 4 WORD Issuer 文档的 LOCAL ID |
| `1111` | [EXTERNAL-ISSUER-16WORD](/zh/grammar/reference/external-issuer/) | 指示声明 | 16 WORD Issuer 文档的 LOCAL ID |

### 占位标记 (Codec `0000`)

`0000 0000 0000 0MMM` — [占位标记](/zh/grammar/reference/slot-marker/)。只有当字段的 CODEC 列表恰好包含该 WORD 时，才能出现在该位置。

| WORD | 名称 | 含义 | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](/zh/grammar/reference/slot-marker/) | 未写。省略了可选字段。对世界不作任何断言 | 无 snak |
| `0x0001` | [UNKNOWN-VALUE](/zh/grammar/reference/slot-marker/) | 未知。有值但不知道是什么 | `somevalue` |
| `0x0002` | [NO-VALUE](/zh/grammar/reference/slot-marker/) | 无。没有值 | `novalue` |
| `0x0003`~`0x0007` | Reserved | | |

### Quantifier (`QQQ`)

| QQQ | 名称 | 含义 | 示例 |
|---|---|---|---|
| `000` | Identified | 已识别的个体 | 埃隆·马斯克、大韩民国 |
| `001` | Generic | 关于整个类别的一般性、定义性陈述。允许例外。 | 士兵服从命令 |
| `010` | Free-choice | 满足条件的任意对象 | 任何一个士兵 |
| `011` | Universal | 属于给定范围的所有对象 | 所有士兵 |
| `100` | Variable | 话语变量 | 那个人、这个女人 |
| `101`~`111` | Reserved |  |  |

- 在 Codec `0000`（占位标记）中，低 3 位不是 Quantifier，而是标记编号。

## Issuer

Issuer 是定义文档和格式的主体 — [Issuer 与公布](/zh/grammar/issuer/)

| 位置 | 含义 |
|---|---|
| Value·Edge ISSUER 码（`0x7C`~`0x7F`） | 该 Issuer 定义的格式 |
| Meta `DOC-ID` | 发布本文档的 Issuer |
| Meta `IMPORT-DOC` | 发布被导入文档的 Issuer |
| Reference `EXTERNAL-ISSUER-*`·`DOC-POINTER` | 发布所指向文档的 Issuer（1/2/4/16 WORD） |
| Reference `ISSUER-POINTER` | 所指向的 Issuer 自身（1/2/4/16 WORD） |

| Issuer 宽度 | 签发 |
|---|---|
| 1 WORD | geul.org 分配给标准制定组织和主要机构（[1 WORD 分配表](/zh/grammar/issuer/#1-word-分配表)）。 |
| 2 WORD | 在 geul.org 注册。经过域名所有权证明（例：company.com）的 Issuer |
| 4 WORD | 在 geul.org 注册。未经所有权证明而注册的 Issuer |
| 16 WORD | 自行签发。无需注册，由公钥计算得出。遵循下面的生成规则。 |

### 16 WORD Issuer 签名算法

| 签名算法 ID | 算法 |
|---|---|
| `0x0001` | Ed25519 |
| 其他 | 保留 |

## Edge

`0001 0LLL LCCC CCCC` — [Edge](/zh/grammar/edge/)

Codec 的高 2 位是系列。直接码（7 位）和 ISSUER 格式编号（16 位）都遵循同一规则。

| 高 2 位 | 系列 | 直接码 | 格式编号 |
|---|---|---|---|
| `00` | 叙述 | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | 依据 | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | 执行 | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [TOULMIN](/zh/grammar/edge/toulmin/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### 叙述 (`00`)

| CCCCC | Codec | 名称 | 子格式 | 说明 |
|---|---|---|---|---|
| `00000` | `0x00` | [REFERENCE-NODE](/zh/grammar/edge/reference-node/) |  | 作为 Reference 的 Subject 指示 Object 的有向绑定 |
| `00001` | `0x01` | [SAME-NODE](/zh/grammar/edge/same-node/) |  | 两个 Reference 指示同一对象的同一性 |
| `00010` | `0x02` | [DIFFERENT-NODE](/zh/grammar/edge/different-node/) |  | 两个 Reference 指示不同对象的非同一性 |
| `00011` | `0x03` | [BIND](/zh/grammar/edge/bind/) |  | 给 Subject 绑定机器匹配用的名称（`UTF8-TEXT-*`）。在范围内唯一且必须精确匹配，没有语言 |
| `00100` | `0x04` | [LABEL](/zh/grammar/edge/label/) |  | 连接 Subject 的语言名称（label）。Object 是 UTF8-LANGUAGE-TEXT |
| `00101` | `0x05` | [ALIAS](/zh/grammar/edge/alias/) |  | 连接 Subject 的其他名称（别名）。布局与 LABEL 相同 |
| `00110` | `0x06` | [DESCRIPTION](/zh/grammar/edge/description/) |  | 连接 Subject 的语言说明（description）。布局与 LABEL 相同 |
| `00111` | `0x07` | Reserved |  |  |
| `01000` | `0x08` | VERB-SHORT |  | 动词叙述缩写 |
| `01001` | `0x09` | VERB |  | 动词叙述 |
| `01010` | `0x0A` | [TRIPLE](/zh/grammar/edge/triple/) |  | 按 Predicate、Subject、Object 顺序的命题与 rank。Object 是值或 UNKNOWN-VALUE·NO-VALUE 标记。含义是指向该 Edge Id 的所有 QUALIFIER 的总和 |
| `01011` | `0x0B` | [QUALIFIER](/zh/grammar/edge/qualifier/) |  | 限定另一个 Edge 命题的一个条件。Property、Target（Edge Id）、Value（值或 UNKNOWN-VALUE·NO-VALUE 标记）。是命题的一部分 |
| `01100`~`01111` | `0x0C`~`0x0F` | Reserved |  |  |
| `10000` | `0x10` | WORLD | 有 | 用于表达世界观的结构 |
| `10001` | `0x11` | TIMELINE | 有 | 表达世界与事件顺序的结构 |
| `10010` | `0x12` | SCENE | 有 | 用于叙述情节特性的场景结构 |
| `10011`~`10111` | `0x13`~`0x17` | Reserved |  |  |
| `11000` | `0x18` | [PUBLICATION](/zh/grammar/edge/publication/) |  | 文档公布。DOC-POINTER、内容哈希 |
| `11001` | `0x19` | DEPRECATION |  | 已公布版本的 deprecate。DOC-POINTER |
| `11010` | `0x1A` | TOMBSTONE |  | 已公布版本的删除（墓碑）。DOC-POINTER、原因类别 |
| `11011` | `0x1B` | [DECLARE](/zh/grammar/edge/declare/) |  | 单个 Codec 的 Payload 构成声明。目标 Kind·Codec |
| `11100` | `0x1C` | [FIELD](/zh/grammar/edge/field/) |  | 一个 Payload 字段。所属 DECLARE，宽度：记录（TAG 的 Length）或原始值 n WORD |
| `11101` | `0x1D` | [ENUM](/zh/grammar/edge/enum/) |  | 原始值字段的一个码值。字段、码值 |
| `11110` | `0x1E` | [CODEC](/zh/grammar/edge/codec/) |  | 字段接受的一个 Kind·Codec。字段、目标 WORD（`000K KLLL LCCC CCCC`，LLLL 0000 精确·1111 通配，占位标记只能以精确目标 `0000`~`0002` 指定）。记录字段可有多个（封闭列表），原始值字段只有一个（没有 TAG 的那个 Value） |
| `11111` | `0x1F` | Reserved |  |  |

| CCCCC 高 2 位 | 分组 |
|---|---|
| `00` | 指示与名称 |
| `01` | 命题 |
| `10` | 结构 |
| `11` | 其他 |

### 依据 (`01`)

| Codec | 名称 | 子格式 | 说明 |
|---|---|---|---|
| `0x20` | [SOURCE](/zh/grammar/edge/source/) |  | 把一条记录或整个文档连接到其来源。Target（BODY Edge Id，在 HEAD 中 `0` = 整个文档）、Origin（Reference，ABSENT 或 UNKNOWN-VALUE）。来源的性质用以来源为 Subject 的 TRIPLE，引用的性质（查阅日、位置、原文哈希）用附在 SOURCE 上的 QUALIFIER。整个文档的 SOURCE 及其 QUALIFIER 放在 HEAD 中 |
| `0x21`~`0x3F` | Reserved |  |  |

- 原文范围、制作主体、可信度、各条款的施行期间、旧记录用 QUALIFIER 来写，最初进入的版本由版本历史计算（[SOURCE](/zh/grammar/edge/source/#其他依据的表示)）。

### 执行 (`10`)

| CCCCC | Codec | 名称 | 说明 |
|---|---|---|---|
| `00000` | `0x40` | Reserved |  |
| `00001` | `0x41` | FUNCTION-DECLARE | 函数声明。符号、参数符号列表、返回类型、函数体（BLOCK） |
| `00010` | `0x42` | TYPE-DECLARE | 类型声明。符号与构成（字段符号列表、枚举值、别名目标） |
| `00011`~`00111` | `0x43`~`0x47` | Reserved |  |
| `01000` | `0x48` | CONST | 常量表达式。一个内置 Value |
| `01001` | `0x49` | UNARY | 一元表达式。运算符 1 WORD、操作数 |
| `01010` | `0x4A` | BINARY | 二元表达式。运算符 1 WORD、左、右 |
| `01011` | `0x4B` | CALL | 调用。目标函数、参数个数、参数 × 参数个数 |
| `01100` | `0x4C` | MEMBER | 成员访问。目标、字段符号 |
| `01101` | `0x4D` | INDEX | 索引访问。目标、索引 |
| `01110` | `0x4E` | CONSTRUCT | 复合值构造（列表、记录）。类型、元素个数、元素 × 元素个数 |
| `01111` | `0x4F` | CONDITIONAL | 条件表达式。条件、为真时的值、为假时的值 |
| `10000` | `0x50` | BLOCK | 有序语句组。语句数、语句 × 语句数 |
| `10001` | `0x51` | ASSIGN | 赋值。目标（符号、MEMBER、INDEX）、值 |
| `10010` | `0x52` | IF | 条件分支。条件、真 BLOCK、假（BLOCK·IF，没有则为 0） |
| `10011` | `0x53` | SWITCH | 多路分支。目标、分支数、（值, BLOCK）× 分支数、默认 BLOCK（没有则为 0） |
| `10100` | `0x54` | WHILE | 条件循环。条件、函数体 BLOCK |
| `10101` | `0x55` | FOREACH | 遍历循环。元素符号、目标、函数体 BLOCK |
| `10110` | `0x56` | JUMP | 循环控制。种类 1 WORD（break、continue）、目标循环 |
| `10111` | `0x57` | RETURN | 返回。值（没有则为 0） |
| `11000` | `0x58` | RAISE | 抛出错误。错误值 |
| `11001` | `0x59` | TRY | 错误处理。函数体 BLOCK、错误符号、处理 BLOCK、收尾 BLOCK（没有则为 0） |
| `11010`~`11111` | `0x5A`~`0x5F` | Reserved |  |

| CCCCC 高 2 位 | 分组 |
|---|---|
| `00` | 声明 |
| `01` | 表达式 |
| `10` | 语句 |
| `11` | 错误 |

### TOULMIN (`11`)

详见：[TOULMIN](/zh/grammar/edge/toulmin/)

| CCCCC | Codec | 名称 | 说明 |
|---|---|---|---|
| `00000` | `0x60` | [CASE-DECLARE](/zh/grammar/edge/toulmin/node/) | 案件声明。容纳节点与关系的判定图 |
| `00001` | `0x61` | [PREDICATE-DECLARE](/zh/grammar/edge/toulmin/expr/) | 谓词声明。判定函数·表达式、判断标准（Spec）、事实契约（Ground） |
| `00010` | `0x62` | [SPEC-DECLARE](/zh/grammar/edge/toulmin/node/) | 判断标准声明。常量·列表（Backing） |
| `00011` | `0x63` | [RULE-DECLARE](/zh/grammar/edge/toulmin/node/) | 主张声明。在案件中把谓词设为一般规则（Warrant）。可被攻击。 |
| `00100` | `0x64` | [COUNTER-DECLARE](/zh/grammar/edge/toulmin/node/) | 反驳声明。带着自己的结论进行攻击。默认 Level 为 Fail |
| `00101` | `0x65` | [EXCEPT-DECLARE](/zh/grammar/edge/toulmin/node/) | 例外声明。不带自己的结论进行攻击。默认 Level 为 Review |
| `00110`~`00111` | `0x66`~`0x67` | Reserved |  |
| `01000` | `0x68` | [ATTACKS](/zh/grammar/edge/toulmin/link/) | 攻击关系。攻击者的判定逐步削弱目标的判定。 |
| `01001` | `0x69` | [SUPERSEDES](/zh/grammar/edge/toulmin/link/) | 排除关系。攻击者为 Active 时，决定性地把目标从汇总中剔除。 |
| `01010` | `0x6A` | SUPERSEDE-CHAIN | 优先级链 `A > B > C`。成对 SUPERSEDES 的缩写。布局未定 |
| `01011`~`01111` | `0x6B`~`0x6F` | Reserved |  |
| `10000` | `0x70` | [RUN](/zh/grammar/edge/toulmin/link/) | 执行组合。节点为 Active 时执行下级案件（DAG）。 |
| `10001` | `0x71` | [DO](/zh/grammar/edge/toulmin/link/) | 节点为 Active 时执行的动作 |
| `10010` | `0x72` | [DO-ONCE](/zh/grammar/edge/toulmin/link/) | 即使重试也只执行一次的动作 |
| `10011` | `0x73` | [UNDO](/zh/grammar/edge/toulmin/link/) | DO 的补偿动作（saga）。后续步骤失败时按相反顺序执行。 |
| `10100` | `0x74` | [CHECKING](/zh/grammar/edge/toulmin/link/) | 只做判定、没有副作用的连接 |
| `10101` | `0x75` | [ENTRY](/zh/grammar/edge/toulmin/node/) | 外部入口。执行或判定案件 |
| `10110` | `0x76` | [TRIGGER](/zh/grammar/edge/toulmin/node/) | 没有外部调用的事件·周期入口 |
| `10111` | `0x77` | Reserved |  |
| `11000` | `0x78` | VERDICT | 节点·记录的判定结果。结果（Pass、Review、Fail）、判定值、Activated、Excluded、Level。布局未定。整个文档的判定是 Meta [VERDICT](/zh/grammar/meta/verification/verdict/)（`0x44`） |
| `11001` | `0x79` | EVIDENCE | 判定的证据。位置、期望值、实际值（Fact）。布局未定 |
| `11010`~`11011` | `0x7A`~`0x7B` | Reserved |  |
| `111xx` | `0x7C`~`0x7F` | ISSUER-* | Issuer 定义的格式 |

| CCCCC 高 2 位 | 分组 |
|---|---|
| `00` | 声明 |
| `01` | 关系 |
| `10` | 执行 |
| `11` | 结果（`0x7C`~`0x7F` 为 ISSUER） |

### Edge ISSUER 格式

`0x7C`~`0x7F`（ISSUER-1/2/4/16WORD）之后的 Codec 扩展 TAG 中放 Issuer 和格式编号。格式编号的高 2 位是系列。格式编号空间与 Value 分开。

| Issuer | 格式编号 | 名称 | 系列 | 说明 |
|---|---|---|---|---|
| `0x0000` GEUL | `0xC000` | [SOURCE](/zh/grammar/edge/toulmin/source/) | TOULMIN | 创作原文。SPAN 宽度与 UTF8 Value |
| `0x0000` GEUL | `0xC001` | [TEXT](/zh/grammar/edge/toulmin/source/) | TOULMIN | 名称·字符串 |
| `0x0000` GEUL | `0xC002` | [SECTION](/zh/grammar/edge/toulmin/source/) | TOULMIN | 章节开始。章节码 |
| `0x0000` GEUL | `0xC003` | [CASE-BEGIN](/zh/grammar/edge/toulmin/source/) | TOULMIN | 案件范围开始 |
| `0x0000` GEUL | `0xC004` | [CASE-END](/zh/grammar/edge/toulmin/source/) | TOULMIN | 案件范围结束 |
| `0x0000` GEUL | `0xC005` | [PROSE](/zh/grammar/edge/toulmin/source/) | TOULMIN | 叙述段落（SPAN） |
| `0x0000` GEUL | `0xC010` | [NAMESPACE](/zh/grammar/edge/toulmin/node/) | TOULMIN | NODE。`this document is` |
| `0x0000` GEUL | `0xC011` | [FUNC](/zh/grammar/edge/toulmin/node/) | TOULMIN | NODE。函数引用 |
| `0x0000` GEUL | `0xC012` | [FIELD](/zh/grammar/edge/toulmin/node/) | TOULMIN | NODE。`is required` |
| `0x0000` GEUL | `0xC013` | [ALIAS](/zh/grammar/edge/toulmin/node/) | TOULMIN | NODE。`see … from` |
| `0x0000` GEUL | `0xC014` | [GROUP](/zh/grammar/edge/toulmin/node/) | TOULMIN | NODE。有序执行组 |
| `0x0000` GEUL | `0xC020` | [REQUIRES](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。案件 → 字段 |
| `0x0000` GEUL | `0xC021` | [MEANS](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。定义项 → 值·类型 |
| `0x0000` GEUL | `0xC022` | [HAS](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。定义项 → 字段 |
| `0x0000` GEUL | `0xC023` | [RUNS](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。入口 → 案件，执行 |
| `0x0000` GEUL | `0xC024` | [EVALUATES](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。入口 → 案件，判定 |
| `0x0000` GEUL | `0xC025` | [TRIGGERS](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。触发器 → 案件 |
| `0x0000` GEUL | `0xC026` | [UNTIL](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。触发器 → 案件（`every … until`） |
| `0x0000` GEUL | `0xC027` | [SAME-AS](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。节点 → 全局标识符 |
| `0x0000` GEUL | `0xC028` | [IMPORTED-FROM](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。别名 → 路径（TEXT） |
| `0x0000` GEUL | `0xC029` | [LABEL](/zh/grammar/edge/toulmin/link/) | TOULMIN | LINK。节点 → TEXT，名称标注 |

## Value

`0000 1LLL LCCC CCCC` — [Value](/zh/grammar/value/)

Codec 的高 2 位是系列。NUMERIC/DECIMAL 再用高 3 位的第 3 位区分（`000` NUMERIC，`001` DECIMAL）。

| 高 2 位 | 系列 | 直接码 | 格式编号 |
|---|---|---|---|
| `00` | [NUMERIC](/zh/grammar/value/numeric/)/[DECIMAL](/zh/grammar/value/decimal/) | `0x00`~`0x1F` | `0x0000`~`0x3FFF` |
| `01` | [TIME](/zh/grammar/value/time/) | `0x20`~`0x3F` | `0x4000`~`0x7FFF` |
| `10` | [TEXT](/zh/grammar/value/text/) | `0x40`~`0x5F` | `0x8000`~`0xBFFF` |
| `11` | [BINARY](/zh/grammar/value/binary/) | `0x60`~`0x7B` | `0xC000`~`0xFFFF` |

### 直接码

| Codec | 名称 | 系列 | 说明 |
|---|---|---|---|
| `0x00` | [BOOL](/zh/grammar/value/numeric/bool/) | NUMERIC | 固定 1 WORD 的 false 或 true |
| `0x01` | [SIGNED-INTEGER](/zh/grammar/value/numeric/signed-integer/) | NUMERIC | 最小 WORD 二进制补码有符号整数 |
| `0x02` | [UNSIGNED-INTEGER](/zh/grammar/value/numeric/unsigned-integer/) | NUMERIC | 最小 WORD big-endian unsigned magnitude 整数 |
| `0x03` | [BINARY-FLOAT](/zh/grammar/value/numeric/binary-float/) | NUMERIC | Payload 1/2/4/8 WORD 的 IEEE 754 binary16/32/64/128 scalar |
| `0x04` | [COORDINATE-EARTH](/zh/grammar/value/numeric/coordinate-earth/) | NUMERIC | 地球（WGS 84）纬度·经度 binary64，不确定度 binary32 及其单位 Reference（ABSENT = 未知） |
| `0x05` | [COORDINATE-GEO](/zh/grammar/value/numeric/coordinate-geo/) | NUMERIC | 天体 Reference 与纬度·经度 binary64，不确定度 binary32 及其单位 Reference |
| `0x06` | [QUANTITY](/zh/grammar/value/numeric/quantity/) | NUMERIC | 数值 Value amount（整数·BINARY-FLOAT·十进制数·分数）、单位 Reference、下限·上限。单位·边界可省略（ABSENT `0x0000`） |
| `0x07` | [FRACTION](/zh/grammar/value/numeric/fraction/) | NUMERIC | 保留原文写法的分数：整数·十进制数分子，无符号整数·十进制数分母。不约分 |
| `0x08`~`0x0F` | Reserved | NUMERIC |  |
| `0x10` | [SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/) | DECIMAL | signed exponent `E` 与最小 WORD 二进制补码 coefficient `C` 的 `C×10^E` |
| `0x11` | [UNSIGNED-DECIMAL](/zh/grammar/value/decimal/unsigned-decimal/) | DECIMAL | signed exponent `E` 与最小 WORD unsigned coefficient `C` 的 `C×10^E` |
| `0x12`~`0x1F` | Reserved | DECIMAL |  |
| `0x20` | [GREGORIAN-DATE](/zh/grammar/value/time/gregorian-date/) | TIME | 以 proleptic Gregorian `1970-01-01` 为基准的 signed 天数 |
| `0x21` | [CIVIL-TIME-NANOSECONDS](/zh/grammar/value/time/civil-time-nanoseconds/) | TIME | 民用日午夜之后的 unsigned nanosecond 计数 |
| `0x22` | [POSIX-TIMESTAMP-SECONDS](/zh/grammar/value/time/posix-timestamp-seconds/) | TIME | 自 Unix/POSIX epoch 起的 signed 秒计数 |
| `0x23` | [DURATION-SECONDS](/zh/grammar/value/time/duration-seconds/) | TIME | 没有 epoch 的 signed SI-second 经过时间 |
| `0x24`/`0x25` | [EDTF](/zh/grammar/value/time/edtf/) | TIME | EDTF（ISO 8601-2）日期字符串。偶数·奇数字节。能用 GREGORIAN-DATE 表示的日期不使用 |
| `0x26`/`0x27` | [GEDCOM-DATE](/zh/grammar/value/time/gedcom-date/) | TIME | GEDCOM 7 日期值字符串。保留其他历法（儒略历等）的原始写法。偶数·奇数字节 |
| `0x28`~`0x3F` | Reserved | TIME |  |
| `0x40` | [UTF8-TEXT-EVEN](/zh/grammar/value/text/utf8-text/) | TEXT | 不暗示规范化的 valid UTF-8 字节序列。偶数字节 |
| `0x41` | [UTF8-TEXT-ODD](/zh/grammar/value/text/utf8-text/) | TEXT | 同上。奇数字节 |
| `0x42`/`0x43` | Reserved | TEXT |  |
| `0x44` | [URI-EVEN](/zh/grammar/value/text/uri/) | TEXT | RFC 3986 `URI` production 的 ASCII 字节序列。偶数字节 |
| `0x45` | [URI-ODD](/zh/grammar/value/text/uri/) | TEXT | 同上。奇数字节 |
| `0x46` | [LANGUAGE-BCP47-CODE-EVEN](/zh/grammar/value/text/language-bcp47-code/) | TEXT | canonical casing 的完整 BCP 47 language tag ASCII 字节序列。偶数字节 |
| `0x47` | [LANGUAGE-BCP47-CODE-ODD](/zh/grammar/value/text/language-bcp47-code/) | TEXT | 同上。奇数字节 |
| `0x48` | [LANGUAGE-SHORT-CODE](/zh/grammar/value/text/language-short-code/) | TEXT | 以 GEUL Language Registry 编号书写的 BCP 47 tag（Payload 1 WORD） |
| `0x49` | Reserved | TEXT |  |
| `0x4A`/`0x4B` | [UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/) | TEXT | 带语言的文本。语言 Value 记录（LANGUAGE-SHORT-CODE 或 LANGUAGE-BCP47-CODE）与 UTF-8 字节。文本字节的偶数·奇数 |
| `0x4C`~`0x5F` | Reserved | TEXT |  |
| `0x60` | [UUID](/zh/grammar/value/binary/uuid/) | BINARY | 固定 Payload 8 WORD 的 RFC 9562 UUID 128bit |
| `0x61` | [SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/) | BINARY | 固定 Payload 16 WORD 的 SHA-256 结果 |
| `0x62` | [SHA1-DIGEST](/zh/grammar/value/binary/sha1-digest/) | BINARY | 固定 Payload 10 WORD 的 SHA-1 结果。仅用于 git 对象 ID 之类的标识用途 |
| `0x63`~`0x7B` | Reserved | BINARY |  |
| `0x7C`~`0x7F` | ISSUER-* |  | Issuer 定义的格式。见下面的 Value ISSUER 格式 |

### Value ISSUER 格式

`0x7C`~`0x7F`（ISSUER-1/2/4/16WORD）之后的 Codec 扩展 TAG 中放 Issuer 和格式编号。格式编号的高 2 位是系列。

| Issuer | 格式编号 | 名称 | 系列 | 说明 |
|---|---|---|---|---|
| `0x0000` GEUL | `0x4000` | [DURATION-NANOSECONDS](/zh/grammar/value/time/duration-nanoseconds/) | TIME | 没有 epoch 的 signed nanosecond 经过时间 |
| `0x0000` GEUL | `0xC000` | [OPAQUE-BYTES-EVEN](/zh/grammar/value/binary/opaque-bytes/) | BINARY | 含义·格式不明的字节序列。偶数字节 |
| `0x0000` GEUL | `0xC001` | [OPAQUE-BYTES-ODD](/zh/grammar/value/binary/opaque-bytes/) | BINARY | 同上。奇数字节 |
| `0x0000` GEUL | `0xC002` | [BIT-VECTOR](/zh/grammar/value/binary/bit-vector/) | BINARY | bit-count 之后以 MSB-first 存储的 N bit |
| `0x0001` ADHOC | `0x0000` | BFLOAT16 | NUMERIC | 固定 Payload 1 WORD 的 BF16 interchange bits |
| `0x0001` ADHOC | `0x0500` | [DENSE-I16-VECTOR](/zh/grammar/value/vector/dense-i16-vector/) | NUMERIC | 连续 big-endian int16 vector |
| `0x0001` ADHOC | `0x0501` | [DENSE-U16-VECTOR](/zh/grammar/value/vector/dense-u16-vector/) | NUMERIC | 连续 big-endian uint16 vector |
| `0x0001` ADHOC | `0x0502` | [DENSE-I32-VECTOR](/zh/grammar/value/vector/dense-i32-vector/) | NUMERIC | 连续 big-endian int32 vector |
| `0x0001` ADHOC | `0x0503` | [DENSE-U32-VECTOR](/zh/grammar/value/vector/dense-u32-vector/) | NUMERIC | 连续 big-endian uint32 vector |
| `0x0001` ADHOC | `0x0504` | [DENSE-I64-VECTOR](/zh/grammar/value/vector/dense-i64-vector/) | NUMERIC | 连续 big-endian int64 vector |
| `0x0001` ADHOC | `0x0505` | [DENSE-U64-VECTOR](/zh/grammar/value/vector/dense-u64-vector/) | NUMERIC | 连续 big-endian uint64 vector |
| `0x0001` ADHOC | `0x0506` | [DENSE-BINARY16-VECTOR](/zh/grammar/value/vector/dense-binary16-vector/) | NUMERIC | 连续 IEEE 754 binary16 vector |
| `0x0001` ADHOC | `0x0507` | [DENSE-BFLOAT16-VECTOR](/zh/grammar/value/vector/dense-bfloat16-vector/) | NUMERIC | 连续 BF16 vector |
| `0x0001` ADHOC | `0x0508` | [DENSE-BINARY32-VECTOR](/zh/grammar/value/vector/dense-binary32-vector/) | NUMERIC | 连续 IEEE 754 binary32 vector |
| `0x0001` ADHOC | `0x0509` | [DENSE-BINARY64-VECTOR](/zh/grammar/value/vector/dense-binary64-vector/) | NUMERIC | 连续 IEEE 754 binary64 vector |
| `0x0001` ADHOC | `0x050A` | [POINT2-BINARY64](/zh/grammar/value/vector/point2-binary64/) | NUMERIC | 按 `(x,y)` 顺序的 IEEE binary64 二维 vector |
| `0x0001` ADHOC | `0x050B` | [POINT3-BINARY64](/zh/grammar/value/vector/point3-binary64/) | NUMERIC | 按 `(x,y,z)` 顺序的 IEEE binary64 三维 vector |
| `0x0001` ADHOC | `0x050C` | [BBOX2-BINARY64](/zh/grammar/value/vector/bbox2-binary64/) | NUMERIC | 按 `(minX,minY,maxX,maxY)` 顺序的 IEEE binary64 vector |
| `0x0001` ADHOC | `0x0600` | [DESCRIBED-DENSE-TENSOR](/zh/grammar/value/tensor/described-dense-tensor/) | NUMERIC | element-format·rank·shape 与 C-contiguous dense payload |
| `0x0001` ADHOC | `0x0601` | [DESCRIBED-PACKED-TENSOR](/zh/grammar/value/tensor/described-packed-tensor/) | NUMERIC | packed-format·rank·shape 与 octet 内 low-bit-first packed payload |
| `0x0001` ADHOC | `0x0700` | [COMPLEX64](/zh/grammar/value/etc/complex64/) | NUMERIC | 按 `(real, imag)` 顺序的两个 binary32 |
| `0x0001` ADHOC | `0x0701` | [COMPLEX128](/zh/grammar/value/etc/complex128/) | NUMERIC | 按 `(real, imag)` 顺序的两个 binary64 |
| `0x0001` ADHOC | `0x0702` | [RATIONAL-I64](/zh/grammar/value/etc/rational-i64/) | NUMERIC | 规范化的 int64 numerator 与正 int64 denominator |
| `0x0001` ADHOC | `0x0703` | [CLOSED-INTERVAL-BINARY64](/zh/grammar/value/etc/closed-interval-binary64/) | NUMERIC | `lower ≤ upper` 的 binary64 闭区间 |
| `0x0001` ADHOC | `0x0704` | [QUATERNION-BINARY32](/zh/grammar/value/etc/quaternion-binary32/) | NUMERIC | 按 `(x,y,z,w)` 顺序的四个 binary32 |
| `0x0001` ADHOC | `0xC000` | [BLAKE3-256-DIGEST](/zh/grammar/value/binary/blake3-256-digest/) | BINARY | 固定 Payload 16 WORD 的默认 BLAKE3 结果 |
| `0x0020` IETF | `0x8000` | [URI-RELATIVE-REF-EVEN](/zh/grammar/value/text/uri-relative-ref/) | TEXT | RFC 3986 relative-ref ASCII 字节序列。偶数字节 |
| `0x0020` IETF | `0x8001` | [URI-RELATIVE-REF-ODD](/zh/grammar/value/text/uri-relative-ref/) | TEXT | 同上。奇数字节 |
| `0x0020` IETF | `0xC000` | [CRC32C](/zh/grammar/value/binary/crc32c/) | BINARY | 固定 Payload 2 WORD 的 Castagnoli CRC-32C 结果 |
| `0x0020` IETF | `0xC001` | [IPV4-ADDRESS](/zh/grammar/value/binary/ipv4-address/) | BINARY | 固定 Payload 2 WORD 的 IPv4 地址 32bit |
| `0x0020` IETF | `0xC002` | [IPV6-ADDRESS](/zh/grammar/value/binary/ipv6-address/) | BINARY | 固定 Payload 8 WORD 的 IPv6 地址 128bit |
| `0x0040` IEEE | `0x2000` | [IEEE-DECIMAL32-DPD](/zh/grammar/value/decimal/ieee-decimal32-dpd/) | DECIMAL | 固定 Payload 2 WORD 的 IEEE 754 decimal32 DPD |
| `0x0040` IEEE | `0x2001` | [IEEE-DECIMAL64-DPD](/zh/grammar/value/decimal/ieee-decimal64-dpd/) | DECIMAL | 固定 Payload 4 WORD 的 IEEE 754 decimal64 DPD |
| `0x0040` IEEE | `0x2002` | [IEEE-DECIMAL128-DPD](/zh/grammar/value/decimal/ieee-decimal128-dpd/) | DECIMAL | 固定 Payload 8 WORD 的 IEEE 754 decimal128 DPD |
| `0x0040` IEEE | `0x2003` | [IEEE-DECIMAL32-BID](/zh/grammar/value/decimal/ieee-decimal32-bid/) | DECIMAL | 固定 Payload 2 WORD 的 IEEE 754 decimal32 BID |
| `0x0040` IEEE | `0x2004` | [IEEE-DECIMAL64-BID](/zh/grammar/value/decimal/ieee-decimal64-bid/) | DECIMAL | 固定 Payload 4 WORD 的 IEEE 754 decimal64 BID |
| `0x0040` IEEE | `0x2005` | [IEEE-DECIMAL128-BID](/zh/grammar/value/decimal/ieee-decimal128-bid/) | DECIMAL | 固定 Payload 8 WORD 的 IEEE 754 decimal128 BID |
| `0x0040` IEEE | `0x4000` | [POSIX-TIMESTAMP-NANOSECONDS](/zh/grammar/value/time/posix-timestamp-nanoseconds/) | TIME | 自 Unix/POSIX epoch 起的 signed nanosecond 计数 |
| `0x0040` IEEE | `0xC000` | [MAC-48-ADDRESS](/zh/grammar/value/binary/mac-48-address/) | BINARY | 固定 Payload 3 WORD 的 IEEE 802 MAC 地址 48bit |
| `0x0041` KHRONOS | `0x0000` | [RGBA8-UNORM](/zh/grammar/value/vector/rgba8-unorm/) | NUMERIC | 按 R, G, B, A 顺序的固定 4×UNORM8 packed vector |
| `0x0041` KHRONOS | `0x0001` | [BGRA8-UNORM](/zh/grammar/value/vector/bgra8-unorm/) | NUMERIC | 按 B, G, R, A 顺序的固定 4×UNORM8 packed vector |
| `0x0043` ONNX | `0x0000` | FP8-E4M3FN | NUMERIC | Payload 高位 octet 的 ONNX E4M3FN scalar |
| `0x0043` ONNX | `0x0001` | FP8-E4M3FNUZ | NUMERIC | Payload 高位 octet 的 ONNX E4M3FNUZ scalar |
| `0x0043` ONNX | `0x0002` | FP8-E5M2 | NUMERIC | Payload 高位 octet 的 ONNX E5M2 scalar |
| `0x0043` ONNX | `0x0003` | FP8-E5M2FNUZ | NUMERIC | Payload 高位 octet 的 ONNX E5M2FNUZ scalar |
| `0x0044` OCP | `0x0000` | FP8-E8M0FNU | NUMERIC | Payload 高位 octet 的 unsigned exponent-only E8M0FNU scalar |
| `0x0044` OCP | `0x0001` | FP4-E2M1FN | NUMERIC | Payload 高位 nibble 的 ONNX/DLPack E2M1FN scalar |
| `0x0060` BIPM | `0x4000` | [TAI-TIMESTAMP-SECONDS](/zh/grammar/value/time/tai-timestamp-seconds/) | TIME | 自 `1970-01-01T00:00:00 TAI` 起的 signed SI-second 计数 |
| `0x0060` BIPM | `0x4001` | [TAI-TIMESTAMP-NANOSECONDS](/zh/grammar/value/time/tai-timestamp-nanoseconds/) | TIME | 自同一 TAI epoch 起的 signed nanosecond 计数 |
| `0x0062` NIST | `0xC000` | [SHA-512-DIGEST](/zh/grammar/value/binary/sha-512-digest/) | BINARY | 固定 Payload 32 WORD 的 SHA-512 结果 |
| `0x0062` NIST | `0xC001` | [SHA3-256-DIGEST](/zh/grammar/value/binary/sha3-256-digest/) | BINARY | 固定 Payload 16 WORD 的 SHA3-256 结果 |
| `0x0063` GPS | `0x4000` | [GPS-TIMESTAMP-SECONDS](/zh/grammar/value/time/gps-timestamp-seconds/) | TIME | 自 GPS epoch 起的 signed second 计数 |
| `0x0063` GPS | `0x4001` | [GPS-TIMESTAMP-NANOSECONDS](/zh/grammar/value/time/gps-timestamp-nanoseconds/) | TIME | 自 GPS epoch 起的 signed nanosecond 计数 |

## Meta

`0001 1LLL LCCC CCCC` — [Meta](/zh/grammar/meta/)

Codec 的高 3 位是类。Meta 没有 ISSUER 码。

| 高 3 位 | 类 | 直接码 | 涉及内容 |
|---|---|---|---|
| `000` | [结构](/zh/grammar/meta/structure/) | `0x00`~`0x0F` | 文档的边界与长度 |
| `001` | [定义](/zh/grammar/meta/declaration/) | `0x10`~`0x1F` | 解读声明 |
| `010` | [出处](/zh/grammar/meta/provenance/) | `0x20`~`0x2F` | 谁、何时、在哪里 |
| `011` | [谱系](/zh/grammar/meta/lineage/) | `0x30`~`0x3F` | 从什么、如何而来 |
| `100` | [验证](/zh/grammar/meta/verification/) | `0x40`~`0x4F` | 是否可信 |
| `101` | [策略](/zh/grammar/meta/policy/) | `0x50`~`0x5F` | 如何处理 |
| `110` | [IMPORT](/zh/grammar/meta/import/) | `0x60`~`0x6F` | 以 IMPORT ID 导入外部文档（`IMPORT-DOC`） |
| `111` | Reserved | `0x70`~`0x7F` |  |

### 结构 (`000`)

| Codec | 名称 | 说明 |
|---|---|---|
| `0x00` | [DOC-1WORD](/zh/grammar/meta/structure/doc/) | 在 Payload 1 WORD 中指定总长度的文档开始 |
| `0x01` | [DOC-2WORD](/zh/grammar/meta/structure/doc/) | 在 Payload 2 WORD 中指定总长度的文档开始 |
| `0x02` | [DOC-4WORD](/zh/grammar/meta/structure/doc/) | 在 Payload 4 WORD 中指定总长度的文档开始 |
| `0x03`~`0x0D` | Reserved |  |
| `0x0E` | [BODY](/zh/grammar/meta/structure/body/) | 1 WORD。结束文档的 HEAD 并开始 BODY。 |
| `0x0F` | [END](/zh/grammar/meta/structure/end/) | 1 WORD。关闭文档。 |

### 定义 (`001`)

| Codec | 名称 | 说明 |
|---|---|---|
| `0x10` | [SPEC-VERSION](/zh/grammar/meta/declaration/spec-version/) | 所遵循的 GEUL 规范版次。Payload 本身就是最短宽度的 unsigned 整数。v1 是 `0x0001`（记录 `0x1890 0x0001`） |
| `0x11` | [PROFILE](/zh/grammar/meta/declaration/profile/) | 适用 Profile |
| `0x12` | [DOC-ID](/zh/grammar/meta/declaration/doc-id/) | 本文档的标识符。内置 Reference `DOC-POINTER`（Issuer、文档 ID、版本 0） |
| `0x13` | [EFFECTIVE-FROM](/zh/grammar/meta/declaration/effective-from/) | 本版本的施行日。GREGORIAN-DATE 或 POSIX-TIMESTAMP Value。没有则为公布时刻 |
| `0x14` | [EFFECTIVE-UNTIL](/zh/grammar/meta/declaration/effective-until/) | 本版本有效期的终点（有期限法规）。没有则持续到下一版本施行 |
| `0x15` | Reserved |  |
| `0x16` | [DEFAULT-LANGUAGE](/zh/grammar/meta/declaration/default-language/) | 默认语言 |
| `0x17`~`0x1F` | Reserved |  |

### 出处 (`010`)

| Codec | 名称 | 说明 |
|---|---|---|
| `0x20` | [AUTHOR](/zh/grammar/meta/provenance/author/) | 作者。Reference（git author） |
| `0x21` | [CO-AUTHOR](/zh/grammar/meta/provenance/co-author/) | 共同作者。Reference（git `Co-authored-by`） |
| `0x22` | [CREATED-AT](/zh/grammar/meta/provenance/created-at/) | 创作时刻。TIME Value（git author date） |
| `0x23` | [MODIFIED-AT](/zh/grammar/meta/provenance/modified-at/) | 修改时刻。TIME Value |
| `0x24` | [RECORDED-BY](/zh/grammar/meta/provenance/recorded-by/) | 记录主体。Reference（git committer） |
| `0x25` | [RECORDED-AT](/zh/grammar/meta/provenance/recorded-at/) | 记录时刻。TIME Value（git commit date） |
| `0x26`~`0x2F` | Reserved |  |

- 来源资料及其范围·获取时刻·哈希不用 Meta，而用 HEAD 中的依据 Edge [SOURCE](/zh/grammar/edge/source/#整个文档的来源)（Target `0`）及其 QUALIFIER 来写。

### 谱系 (`011`)

| Codec | 名称 | 说明 |
|---|---|---|
| `0x30` | [PARENT](/zh/grammar/meta/lineage/parent/) | 上一版本的内容哈希（git parent）。没有则为最初版本，有多个则为合并（git merge commit）。 |
| `0x31` | [DERIVED-FROM](/zh/grammar/meta/lineage/derived-from/) | 派生自其他谱系的记录·资料。要固定到外部资料的特定版本时，在 HEAD 的 [SOURCE](/zh/grammar/edge/source/#整个文档的来源) 上附加原文哈希 QUALIFIER（P4092）（git submodule）。 |
| `0x32` | [GENERATED-BY](/zh/grammar/meta/lineage/generated-by/) | 生成主体。人、模型、规则引擎 |
| `0x33` | [TRANSFORMED-BY](/zh/grammar/meta/lineage/transformed-by/) | 转换方法。工具·规则·版本 |
| `0x34` | [CHERRY-PICKED-FROM](/zh/grammar/meta/lineage/cherry-picked-from/) | 从其他谱系挑选变更的原版本的内容哈希（git cherry-pick `-x`） |
| `0x35` | [REVERTS](/zh/grammar/meta/lineage/reverts/) | 被撤销变更的目标版本的内容哈希（git revert） |
| `0x36` | [REPLACES](/zh/grammar/meta/lineage/replaces/) | 被改写的目标版本的内容哈希（git amend·rebase）。不删除原版本。 |
| `0x37` | [SQUASHED-FROM](/zh/grammar/meta/lineage/squashed-from/) | 合并为一个的原版本们的内容哈希（git squash） |
| `0x38` | [MESSAGE](/zh/grammar/meta/lineage/message/) | 变更原因。UTF8-LANGUAGE-TEXT Value，每种语言一条（git commit message） |
| `0x39` | [TAG](/zh/grammar/meta/lineage/tag/) | 附在版本上的不可变名称。TEXT Value 与内容哈希（git annotated tag） |
| `0x3A` | [DELTA-BASE](/zh/grammar/meta/lineage/delta-base/) | 该版本文件是相对同一文档基准版本（2 WORD 版本 ID）的 diff（git packfile delta） |
| `0x3B` | [DELTA-REMOVE](/zh/grammar/meta/lineage/delta-remove/) | 要从 diff 中的基准 BODY 去除的 LOCAL ID（Edge Id）列表 |
| `0x3C` | [NEXT-LOCAL-ID](/zh/grammar/meta/lineage/next-local-id/) | 下一个要分配的 LOCAL ID（auto increment）。放在版本列表 `versions.geul` 的 HEAD 中 |
| `0x3D`~`0x3F` | Reserved |  |

### 验证 (`100`)

| Codec | 名称 | 说明 |
|---|---|---|
| `0x40` | [ISSUER-KEY](/zh/grammar/meta/verification/issuer-key/) | 自行签发的 Issuer 的签名算法 ID 与公钥声明 |
| `0x41` | [SIGNATURE](/zh/grammar/meta/verification/signature/) | 对目标的签名。对文档的签名是对内容哈希签名（git 签名提交·标签） |
| `0x42` | [SIGNED-OFF](/zh/grammar/meta/verification/signed-off/) | 贡献权利确认。Reference（git `Signed-off-by`，DCO） |
| `0x43` | [CONFIDENCE](/zh/grammar/meta/verification/confidence/) | 可信度 |
| `0x44` | [VERDICT](/zh/grammar/meta/verification/verdict/) | 整个文档的判定结果。Pass、Review、Fail。节点·记录级别为 [TOULMIN](/zh/grammar/edge/toulmin/) `VERDICT`（Edge `0x78`） |
| `0x45`~`0x4F` | Reserved |  |

### 策略 (`101`)

| Codec | 名称 | 说明 |
|---|---|---|
| `0x50` | [LICENSE](/zh/grammar/meta/policy/license/) | 许可证。Reference |
| `0x51` | [ACCESS](/zh/grammar/meta/policy/access/) | 公开范围 |
| `0x52` | [PRIVACY](/zh/grammar/meta/policy/privacy/) | 个人信息等级 |
| `0x53` | [RETENTION](/zh/grammar/meta/policy/retention/) | 保存期限 |
| `0x54` | [CONSENT](/zh/grammar/meta/policy/consent/) | 同意范围与依据 |
| `0x55` | [USAGE](/zh/grammar/meta/policy/usage/) | 使用限制 |
| `0x56`~`0x5F` | Reserved |  |

### IMPORT (`110`)

| Codec | 名称 | 说明 |
|---|---|---|
| `0x60` | [IMPORT-DOC](/zh/grammar/meta/import/import-doc/) | 以 IMPORT ID 导入外部文档。内置 Reference `DOC-POINTER` + IMPORT ID |
| `0x61`~`0x6F` | Reserved |  |
