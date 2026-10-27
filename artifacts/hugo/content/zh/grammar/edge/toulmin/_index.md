---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TOULMIN Edge（Codec 0x60~0x7B）用图尔敏论证模型书写判定·执行图。本页规定 TOULMIN 文档规则、公共字段、码表、数值规则和自我修订的固定核心。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TOULMIN 系列 Edge（Codec 高 2 位 `11`，直接码 `0x60`~`0x7B`）用图尔敏论证模型书写判定·执行图。主张·反驳·例外的声明、攻击·排除关系、执行连接、判定结果全都是 Edge。一个 TANGEUL 文档（toulmin 引擎的规则语言）就是一个 GEUL 文档。文件扩展名与其他文档相同，是 `.geul`。

本页没有规定的内容，遵循 [Edge](/zh/grammar/edge/) 和[记录与 TAG WORD](/zh/grammar/record/)的通用规则。

## 元认知与自我修订

TOULMIN 之所以是 GEUL Codec，是为了让 GEUL 对自己进行元认知。判定·执行规则也必须用 GEUL 叙述，TOULMIN 才能以这些规则为对象进行自我修改。因此 TOULMIN 不是应用 Profile，而是 GEUL 运行的核心，放在 Edge 直接码空间（`0x60`~`0x7B`）中。

- 自我叙述使自我改进成为可能，但也要承担循环错误的风险。如果规则自己判定自我修订，那么放宽判定标准的修订也可能通过（通过率上升，实际准确率下降）。
- 循环风险接受下来，但用结构来切断。
  - **固定核心**：判定的含义（Pass·Review·Fail、攻击·排除·优先级、下面[在未知之上判定](#在未知之上判定)的三值评估与 U → Review）固定在本规范中。不能用 TOULMIN 文档更改。与内置于解码器的规则（[公布地址与版本列表](/zh/grammar/publishing/#层)的 0 层）处于同一位置。
  - **版本分离**：规则文档 v(n) 的修订，由 v(n−1) 规则和外部检查来判定。规则不判定自己。判定结果放在与对象不同的文档中（对象的内容哈希不会改变）。
  - **不可变历史**：修订作为新版本累积（`PARENT`、内容哈希、签名）。旧版本保留，所以可以事后发现循环错误并回滚。自我修订的安全网是 GEUL 的版本模型（[文档](/zh/grammar/document/#修订)）。
  - **外部标准**：另设修订路径无法触碰的一组测试用例。修订是否采纳，用这组用例的结果确认。
- 证伪测试：故意植入一条错误规则。如果系统修正了它，且外部标准得分上升，则自我改进在起作用。如果只是通过率上升而外部标准得分下降，就是循环错误。

## 码

TOULMIN 记录使用三种布局之一。布局由 Codec（或格式编号）决定。

| 布局 | 用途 | 页面 |
|---|---|---|
| NODE | 案件·规则·定义·入口之类的图节点 | [NODE](/zh/grammar/edge/toulmin/node/) |
| LINK | 节点之间的关系（攻击、排除、执行、定义） | [LINK](/zh/grammar/edge/toulmin/link/) |
| EXPR | 条件表达式（谓词） | [EXPR](/zh/grammar/edge/toulmin/expr/) |

原文与分区记录（SOURCE、TEXT、SECTION、CASE-BEGIN·CASE-END、PROSE）由 [SOURCE 与分区](/zh/grammar/edge/toulmin/source/)规定。

### 直接码

| Codec | 名称 | 布局 | TANGEUL | 含义 |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/zh/grammar/edge/toulmin/node/) | NODE | `in case of` | 案件声明。容纳节点与关系的判定图 |
| `0x61` | [PREDICATE-DECLARE](/zh/grammar/edge/toulmin/expr/) | EXPR | Rules 的条件表达式 | 谓词声明。判定表达式 |
| `0x62` | [SPEC-DECLARE](/zh/grammar/edge/toulmin/node/) | NODE | Definitions 项 | 判断标准声明（Backing）。role 位是定义种类 |
| `0x63` | [RULE-DECLARE](/zh/grammar/edge/toulmin/node/) | NODE | general rule，Rules 的规则名称 | 主张声明（Warrant）。可被攻击 |
| `0x64` | [COUNTER-DECLARE](/zh/grammar/edge/toulmin/node/) | NODE | counter rule | 反驳声明。带着自己的结论进行攻击。默认 Level 为 Fail |
| `0x65` | [EXCEPT-DECLARE](/zh/grammar/edge/toulmin/node/) | NODE | except rule | 例外声明。不带自己的结论进行攻击。默认 Level 为 Review |
| `0x68` | [ATTACKS](/zh/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | 攻击关系。攻击者的判定逐步削弱目标的判定 |
| `0x69` | [SUPERSEDES](/zh/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | 排除关系。攻击者为 Active 时，决定性地把目标从汇总中剔除。链（`A > B > C`）每对写一个 |
| `0x6A` | SUPERSEDE-CHAIN | — | | 优先级链 `A > B > C`。成对 SUPERSEDES 的缩写。只分配了码，布局尚无 |
| `0x70` | [RUN](/zh/grammar/edge/toulmin/link/) | LINK | `run c when n` | 执行组合。节点为 Active 时执行下级案件（DAG） |
| `0x71` | [DO](/zh/grammar/edge/toulmin/link/) | LINK | `do fn when n` | 节点为 Active 时执行的动作 |
| `0x72` | [DO-ONCE](/zh/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | 即使重试也只执行一次的动作 |
| `0x73` | [UNDO](/zh/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | DO 的补偿动作（saga）。后续步骤失败时按相反顺序执行 |
| `0x74` | [CHECKING](/zh/grammar/edge/toulmin/link/) | LINK | `checking c` | 只做判定、没有副作用的连接 |
| `0x75` | [ENTRY](/zh/grammar/edge/toulmin/node/) | NODE | `provides x` | 外部入口。执行或判定案件 |
| `0x76` | [TRIGGER](/zh/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | 没有外部调用的事件·周期入口 |
| `0x78` | VERDICT | — | | 节点·记录的判定结果。结果（Pass、Review、Fail）、判定值、Activated、Excluded、Level。只分配了码，布局尚无 |
| `0x79` | EVIDENCE | — | | 判定的证据。位置、期望值、实际值（Fact）。只分配了码，布局尚无 |
| `0x7C`~`0x7F` | ISSUER-* | | | Issuer 定义的格式。见下面的 ISSUER 格式 |

- 表中没有的直接码（`0x66`·`0x67`、`0x6B`~`0x6F`、`0x77`、`0x7A`·`0x7B`）为保留。
- Codec 低 5 位的高 2 位是分组：`00` 声明，`01` 关系，`10` 执行，`11` 结果（`0x7C`~`0x7F` 为 ISSUER）。
- 整个文档的判定由 Meta [VERDICT](/zh/grammar/meta/verification/verdict/)（`0x44`）负责，节点·记录的判定由 TOULMIN `VERDICT`（Edge `0x78`）负责。二者是 Kind 不同的两个独立 Codec。

### ISSUER 格式

直接码不够用的 TOULMIN 记录，作为 `ISSUER-1WORD`（`0x7C`）、Issuer `0x0000`（GEUL）之下的格式编号放置。格式编号属于 TOULMIN 系列（`0xC000`~`0xFFFF`，高 2 位 `11`）。

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[Length 扩展 TAG]
Issuer            0x0000
格式编号          0xC000~0xC029
Edge Id           LOCAL Reference 记录
构成要素          格式规定的布局
```

| 格式编号 | 名称 | 布局 | 含义 |
|---|---|---|---|
| `0xC000` | [SOURCE](/zh/grammar/edge/toulmin/source/) | ID, SPAN 宽度 WORD, UTF8 Value | 创作原文 |
| `0xC001` | [TEXT](/zh/grammar/edge/toulmin/source/) | ID, UTF8 Value | 名称·字符串 |
| `0xC002` | [SECTION](/zh/grammar/edge/toulmin/source/) | ID, 章节码 1 WORD | 章节开始 |
| `0xC003` | [CASE-BEGIN](/zh/grammar/edge/toulmin/source/) | ID, REF(案件) | 案件范围开始 |
| `0xC004` | [CASE-END](/zh/grammar/edge/toulmin/source/) | ID, REF(案件) | 案件范围结束 |
| `0xC005` | [PROSE](/zh/grammar/edge/toulmin/source/) | ID, SPAN | 叙述段落 |
| `0xC010` | [NAMESPACE](/zh/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/zh/grammar/edge/toulmin/node/) | NODE | 函数引用 |
| `0xC012` | [FIELD](/zh/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/zh/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/zh/grammar/edge/toulmin/node/) | NODE | 有序执行组 |
| `0xC020` | [REQUIRES](/zh/grammar/edge/toulmin/link/) | LINK | 案件 → 字段 |
| `0xC021` | [MEANS](/zh/grammar/edge/toulmin/link/) | LINK | 定义项 → 值·类型 |
| `0xC022` | [HAS](/zh/grammar/edge/toulmin/link/) | LINK | 定义项 → 字段 |
| `0xC023` | [RUNS](/zh/grammar/edge/toulmin/link/) | LINK | 入口 → 案件，执行 |
| `0xC024` | [EVALUATES](/zh/grammar/edge/toulmin/link/) | LINK | 入口 → 案件，判定 |
| `0xC025` | [TRIGGERS](/zh/grammar/edge/toulmin/link/) | LINK | 触发器 → 案件 |
| `0xC026` | [UNTIL](/zh/grammar/edge/toulmin/link/) | LINK | 触发器 → 案件（`every … until`） |
| `0xC027` | [SAME-AS](/zh/grammar/edge/toulmin/link/) | LINK | 节点 → 全局标识符 |
| `0xC028` | [IMPORTED-FROM](/zh/grammar/edge/toulmin/link/) | LINK | 别名 → 路径（TEXT） |
| `0xC029` | [LABEL](/zh/grammar/edge/toulmin/link/) | LINK | 节点 → TEXT，名称标注 |

- 格式编号空间对每种 Kind 各自独立。Value 的 GEUL 格式 `0xC000`（OPAQUE-BYTES-EVEN）与 Edge 的 `0xC000`（SOURCE）是不同的格式。
- 格式编号只追加。已分配的编号不再用于其他格式。

## 文档

一个 `.geul` 文件就是一个 DOC。DOC 之外不放其他字节。

```
DOC-1WORD/2WORD/4WORD     总长度
  SPEC-VERSION            0x0001 (v1, 没有内置 Value 的整数)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>"。当前 "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value。创作语言环境("en", "ko")
BODY
  SOURCE                  创作原文。BODY 的第一条记录
  语句记录 …               文档声明顺序
END
```

- HEAD：[SPEC-VERSION](/zh/grammar/meta/declaration/spec-version/)、[PROFILE](/zh/grammar/meta/declaration/profile/)，可选 [DEFAULT-LANGUAGE](/zh/grammar/meta/declaration/default-language/)。
- 解码器在 SPEC-VERSION 不同或 PROFILE 的 major 不同时拒绝。minor 不同也读取。
- BODY 的第一条记录是 SOURCE。所有 SPAN 都是这份原文中的范围。
- 语句记录的顺序与文档声明顺序相同。执行顺序（`do`·`run` 触发、`undo` 反向补偿）依赖这个顺序。TOULMIN 文档的 Edge 顺序有意义（[Edge](/zh/grammar/edge/) 顺序规则的例外）。
- BODY 的所有记录都是 Edge。不放独立的 Value 记录。值内置于 Edge Payload。
- 案件的身份与导入使用 Meta [DOC-ID](/zh/grammar/meta/declaration/doc-id/)·[IMPORT-DOC](/zh/grammar/meta/import/import-doc/)（TANGEUL 的 Subject·See）。

## 公共字段

| 字段 | 宽度 | 说明 |
|---|---|---|
| ID | LOCAL Reference 记录 | 记录的 Edge Id。所有记录 Payload 的第一个元素 |
| REF | LOCAL Reference 记录 | 指向本文档其他记录的 Edge Id。`0` 表示无 |
| SPAN | SOURCE 所定宽度 × 2 | 创作原文内的范围。起始字节、字节数 |

- ID 和 REF 是内置的 [LOCAL](/zh/grammar/reference/local/) Reference 记录（`0000 0LLL L000 1000` + 最短宽度的 ID）。宽度由该记录的 Length 决定，不按文档声明。
- REF `0`（LOCAL `0`）是"无"。这是把 LOCAL `0` 用作无的 Codec 规则（[LOCAL](/zh/grammar/reference/local/)）。
- Edge Id 从 1 开始分配，在文档内不重复。`0` 是 REF 的"无"，所以不用作 Edge Id。
- 节点会被其他记录前向引用，所以按文档声明顺序最先获得编号。其他记录（SOURCE、TEXT、LINK、FUNC、分区记录）从节点之后的编号开始由编码器分配。
- 解码器只确认 Edge Id 不为 0 且没有重复。分配顺序不用于解读。
- 节点和关系用 Edge Id 指向。
- 内置 Value 就是包含 TAG WORD 的 Value 记录本身。长度由其 TAG 决定。

## 数值

- 判定值（−1~1）和 Qualifier（0~1）是 [SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/) Value。不另设定点格式。
- 编码器去掉系数末尾的 0。0.8 是 `C=8, E=−1`。解码器接受到小数点后 4 位。
- 置信度门槛（例：`at least 75%`）用比较运算符 1 WORD 和百分比 [UNSIGNED-DECIMAL](/zh/grammar/value/decimal/unsigned-decimal/) Value（`E=0`）书写（[LINK](/zh/grammar/edge/toulmin/link/) F_GATE）。

## 节点声明的轴

- 节点声明（RULE·COUNTER·EXCEPT-DECLARE）具有角色（主张·反驳·例外）、Qualifier（0~1）、Level（Unset、Fail、Review）。角色由 Codec 和 NODE 头的 role 承载，Qualifier 由 F_QUAL 承载，Level 由头的 level 承载（[NODE](/zh/grammar/edge/toulmin/node/)）。
- 强度（Strict、Defeasible、Defeater）是与角色分开的另一条轴。强度的布置尚未确定。

## 在未知之上判定

判定图以 GEUL 事实为输入时，[占位标记](/zh/grammar/reference/slot-marker/)的三个概念（未写、未知、无）要分别评估。[EXPR](/zh/grammar/edge/toulmin/expr/) 比较运算符的评估如下。

| 输入 | `is empty` | `is not empty` | `equals` / `is in` / 大小比较 |
|---|---|---|---|
| 值 v | 假 | 真 | 以 v 评估 |
| NO-VALUE（无） | **真** | 假 | 假 |
| UNKNOWN-VALUE（未知） | 假 | **真** | **未定（U）** |
| ABSENT（未写）/ 没有叙述 | U（开放世界） | U | U |

- 逻辑使用 Kleene 强三值。`NOT U = U`，`假 AND U = 假`，`真 OR U = 真`。其余组合中的 U 仍为 U。
- `EXISTS any` 只要有一个元素为真就为真。没有真但有 U 则为 U，全部为假则为假。
- **谓词为 U 时，该节点的判定不是 Pass·Fail，而是 Review。** 不知道就交给人（或下一阶段）。
- 要把 ABSENT 视为 empty 而不是 U，输入一方必须**声明**封闭世界（以判断标准 SPEC 注入，例："本案件的输入是完整的"）。没有声明则为 U。
- 此表以及 U → Review 的对应是判定的含义，所以是**固定核心**。不能用 TOULMIN 文档更改。
- 例："只数现在仍有效的边界"（`P582 is empty`）规则，P582 = UNKNOWN-VALUE 时为假所以排除，P582 = NO-VALUE 时为真所以包含，没有 P582 时为 U，因此送入 Review。

## 判定结果

- 判定结果（`VERDICT`、`EVIDENCE`）放在与判定对象不同的文档中。结果文档用 [IMPORT-DOC](/zh/grammar/meta/import/import-doc/) 导入对象文档，并用 [EXTERNAL-POINTER-*](/zh/grammar/reference/external-pointer/) 指向。因此判定不会改变对象文档的内容哈希。
- 整个文档的判定是 Meta `VERDICT`，节点·记录的判定是 TOULMIN `VERDICT`。
- 选择修订适用版本的规则（过渡规定、行为时法与新法的选择）以及解释例·判例，也写成判定规则（[文档](/zh/grammar/document/#修订)）。

## 未决问题

- SUPERSEDE-CHAIN（`0x6A`）、VERDICT（`0x78`）、EVIDENCE（`0x79`）的布局。以目前逐对书写 SUPERSEDES 的方式，链是否足够。
- 节点强度（Strict、Defeasible、Defeater）的布置。
- EXPR 内的节点数、标签数、标签索引是 1 WORD，子节点数是 13 位。上限是固定的。
- PROVENANCE（规则出处·前提）布局。
- 反引号名称是否不用 TEXT + LABEL（`0xC029`），而用叙述 [LABEL](/zh/grammar/edge/label/)·[BIND](/zh/grammar/edge/bind/)。
- Claim 的 predicate·mode 码值与 FuncRef 的 VerbCode 码值表。
- 封闭世界声明（把 ABSENT 读作 empty）是用判断标准（SPEC）还是以案件为单位。
- TOULMIN Codec 的 [Codec 规格文档](/zh/grammar/codec-spec/)。NODE·LINK 的条件字段以及 SOURCE 所定的 SPAN 宽度，是无法用 FIELD 声明的布局。

## 相关页面

- [NODE](/zh/grammar/edge/toulmin/node/)、[LINK](/zh/grammar/edge/toulmin/link/)、[EXPR](/zh/grammar/edge/toulmin/expr/)、[SOURCE 与分区](/zh/grammar/edge/toulmin/source/)
- [Edge](/zh/grammar/edge/)、[文档](/zh/grammar/document/)、[PROFILE](/zh/grammar/meta/declaration/profile/)
