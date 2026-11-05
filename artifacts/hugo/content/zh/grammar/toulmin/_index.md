---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "用图尔敏论证模型写入判定·执行图。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

用图尔敏论证模型写入判定·执行图。这是 GEUL 用 GEUL 描述自身规则并自我修订的核心系列。

| 分组 | Codec |
|---|---|
| 声明 | [CASE-DECLARE](0x100L-case-declare.md)(案件), [PREDICATE-DECLARE](0x101L-predicate-declare.md)(谓词), [SPEC-DECLARE](0x102L-spec-declare.md)(判断标准), [RULE-DECLARE](0x103L-rule-declare.md)(主张), [COUNTER-DECLARE](0x104L-counter-declare.md)(反驳), [EXCEPT-DECLARE](0x105L-except-declare.md)(例外) — [NODE](#node) |
| 关系 | [ATTACKS](0x108L-attacks.md)(攻击), [SUPERSEDES](0x109L-supersedes.md)(排除) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md)(优先级链，布局未定) |
| 执行 | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| 结果 | [VERDICT](0x118L-verdict.md)(判定结果：Pass·Review·Fail), [EVIDENCE](0x119L-evidence.md)(判定的证据) — 布局未定 |

- 原文·分段·辅助节点与关系是 TOULMIN 形式系列的直接码 `0x120L~0x134L`（[SOURCE 与分段](#source와-구획)、[TOULMIN](#toulmin-형식)）。
- 判定结果放在与判定对象不同的文档中。结果文档导入对象文档并指向它。因此即使做出判定，对象文档的内容哈希也不会改变。

TOULMIN 系列 Edge（直接码 `0x100L~0x11BL`，辅助记录属于 TOULMIN 形式系列 `0x120L~0x134L`）用图尔敏论证模型写入判定·执行图。主张·反驳·例外的声明、攻击·排除关系、执行连接、判定结果全都是 Edge。一个 TANGEUL 文档（toulmin 引擎的规则语言）成为一个 GEUL 文档。文件扩展名与其他文档相同，为 `.geul`。

本文档未规定的内容遵循 [Edge](../edge/_index.md) 的公共规则和[记录与 TAG WORD](../record.md)。

## 元认知与自我修订 {#메타-인지와-자기-개정}

TOULMIN 之所以是 GEUL Codec，是为了让 GEUL 对自身进行元认知。判定·执行规则也必须用 GEUL 描述，TOULMIN 才能以这些规则为对象进行自我修订。因此 TOULMIN 不是应用 Profile，而是 GEUL 运作的核心，置于 Edge 直接码空间（`0x100L~0x11BL`）。

- 自我描述使自我改进成为可能，但也承担循环错误的风险。如果规则自己判定自己的修订，放宽判断标准的修订也可能通过（通过率上升而实际准确率下降）。
- 循环作为风险接受，但用结构切断。
  - **固定核心**：判定的语义（Pass·Review·Fail，攻击·排除·优先级，以及下文[在未知之上做判定](#미상-위에서-판정하기)的三值求值与 U → Review）固定在本规范中。不能用 TOULMIN 文档更改。与内置于解码器的规则（[公布地址与版本列表](../publishing.md#층)的第 0 层）处于同一位置。
  - **版本分离**：规则文档 v(n) 的修订，用 v(n−1) 规则和外部检查来判定。规则不判定自身。判定结果放在与对象不同的文档中（对象的内容哈希不变）。
  - **不可变历史**：修订作为新版本累积（`PARENT`、内容哈希、签名）。旧版本保留，因此可以事后找出循环错误并回退。自我修订的安全网是 GEUL 的版本模型（[文档](../document.md#개정)）。
  - **外部基准**：另设一组修订路径无法触及的测试案例。修订是否采纳，以这一组的结果确认。
- 证伪测试：故意植入一条错误规则。如果系统修正了它且外部基准得分上升，则自我改进有效。如果只有通过率上升而外部基准得分下降，则是循环错误。

## 编码 {#코드}

TOULMIN 记录使用三种布局之一。布局由 Codec 决定。

| 布局 | 用途 | 页面 |
|---|---|---|
| NODE | 案件·规则·定义·入口等图节点 | [NODE](#node) |
| LINK | 节点之间的关系（攻击、排除、执行、定义） | [LINK](#link) |
| EXPR | 条件式（谓词） | [EXPR](0x101L-predicate-declare.md) |

原文与分段记录（SOURCE、TEXT、SECTION、CASE-BEGIN·CASE-END、PROSE）由 [SOURCE 与分段](#source와-구획)规定。

### 直接码 {#직접-코드}

| Codec | 名称 | 布局 | TANGEUL | 含义 |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | 案件声明。承载节点与关系的判定图 |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | Rules 的条件式 | 谓词声明。判定式 |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | Definitions 条目 | 判断标准声明（Backing）。role 位表示定义种类 |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, Rules 的规则名 | 主张声明（Warrant）。可被攻击 |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | 反驳声明。带着自己的结论发起攻击。默认 Level 为 Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | 例外声明。不带自己的结论发起攻击。默认 Level 为 Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | 攻击关系。攻击者的判定按攻击强度（0~1，默认 1）逐步削减对象的判定 |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | 排除关系。攻击者为 Active 时，在汇总中确定性地剔除对象。链（`A > B > C`）每一对写一条 |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | 优先级链 `A > B > C`。逐对 SUPERSEDES 的缩写。只分配了代码，尚无布局 |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | 执行组合。节点为 Active 时执行下级案件（DAG） |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | 节点为 Active 时执行的动作 |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | 即使重试也只执行一次的动作 |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | DO 的补偿动作（saga）。后续步骤失败时按逆序执行 |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | 只做判定、无副作用的连接 |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | 外部入口。执行或判定案件 |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | 无需外部调用的事件·周期入口 |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | 节点·记录的判定结果。结果（Pass、Review、Fail）、判定值、Activated、Excluded、Level。只分配了代码，尚无布局 |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | 判定的证据。位置、期望值、实际值（Fact）。只分配了代码，尚无布局 |
| `0x11CL~0x11FL` | Reserved | | | |

- 表中没有的直接码（`0x106L`·`0x107L`、`0x10BL`~`0x10FL`、`0x117L`、`0x11AL`·`0x11BL`）为 Reserved。
- 分组为：`0x100L~0x107L` 声明，`0x108L~0x10FL` 关系，`0x110L~0x117L` 执行，`0x118L~0x11FL` 结果（`0x11CL~0x11FL` 为 Reserved）。
- 整个文档的判定由 Meta [VERDICT](../meta/0x1E9L-verdict.md)（`0x1E9L`）负责，节点·记录的判定由 TOULMIN `VERDICT`（Edge `0x118L`）负责。两者的 Kind 不同，是各自独立的 Codec。

### TOULMIN 形式 {#toulmin-형식}

原文·分段·辅助节点与关系置于 Edge TOULMIN 形式系列直接码 `0x120L~0x134L`。没有 Issuer 和 Codec 编号栏，TAG 之后直接是 Payload。

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE)。其他代码位置相同
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
组成部分           由形式规定的布局
```

| Codec | 名称 | 布局 | 含义 |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN 宽度 WORD, UTF8 Value | 撰写原文 |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value | 名称·字符串 |
| `0x122L` | [SECTION](0x122L-section.md) | ID, 章节代码 1 WORD | 章节开始 |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF(案件) | 案件范围开始 |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF(案件) | 案件范围结束 |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | 叙述段落 |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | 函数引用 |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | 有序执行分组 |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | 案件 → 字段 |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | 定义条目 → 值·类型 |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | 定义条目 → 字段 |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | 入口 → 案件，执行 |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | 入口 → 案件，判定 |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | 触发器 → 案件 |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | 触发器 → 案件（`every … until`） |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | 节点 → 全局标识符 |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | 别名 → 路径（TEXT） |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | 节点 → TEXT，名称标记 |

## 文档 {#문서}

一个 `.geul` 文件就是一个 DOC。DOC 之外不放其他字节。

```
DOC-1WORD/2WORD/4WORD     总长度
  SPEC-VERSION            0x0001 (v1, 无内置 Value 的整数)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>"。当前为 "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value。撰写区域设置("en", "ko")
BODY
  SOURCE                  撰写原文。BODY 的第一条记录
  语句记录 …               文档声明顺序
END
```

- HEAD：[SPEC-VERSION](../meta/0x1C5L-spec-version.md)、[PROFILE](../meta/0x1C6L-profile.md)，可选 [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md)。
- SPEC-VERSION 不同或 PROFILE 的 major 不同时，解码器拒绝。minor 不同时仍可读取。
- BODY 的第一条记录是 SOURCE。所有 SPAN 都是此原文内的范围。
- 语句记录的顺序与文档声明顺序相同。执行顺序（`do`·`run` 触发，`undo` 逆序补偿）依赖此顺序。TOULMIN 文档中 Edge 的顺序有意义（[Edge 布局](../edge/_index.md#레이아웃)顺序规则的例外）。
- BODY 的所有记录都是 Edge。不设独立的 Value 记录。值内置于 Edge Payload 中。
- 案件的身份与导入使用 Meta [DOC-ID](../meta/0x1C7L-doc-id.md)·[IMPORT-DOC](../meta/0x1E4L-import-doc.md)（TANGEUL 的 Subject·See）。

## 公共字段 {#공통-필드}

| 字段 | 宽度 | 说明 |
|---|---|---|
| ID | LOCAL Reference 记录 | 记录的 Edge Id。所有记录 Payload 的第一个元素 |
| REF | LOCAL Reference 记录 | 指向本文档其他记录的 Edge Id。`0` 表示没有 |
| SPAN | 由 SOURCE 决定的宽度 × 2 | 撰写原文内的范围。起始字节、字节数 |

- ID 和 REF 是内置的 [LOCAL](../reference/0x005L-local.md) Reference 记录（`0000 0000 0101 LLLL` + 最短宽度的 ID）。宽度由该记录的 Length 决定，不以文档为单位声明。
- REF `0`（LOCAL `0`）表示"没有"。这是把 LOCAL `0` 用作"没有"的 Codec 规则（[LOCAL](../reference/0x005L-local.md)）。
- Edge Id 从 1 开始分配，在文档内不重复。`0` 是 REF 的"没有"，因此不用作 Edge Id。
- 节点会被其他记录前向引用，因此按文档声明顺序先取得编号。其余记录（SOURCE、TEXT、LINK、FUNC、分段记录）由编码器从节点之后的编号开始分配。
- 解码器只检查 Edge Id 不为 0 且无重复。分配顺序不用于解释。
- 节点和关系通过 Edge Id 指向。
- 内置 Value 就是包含 TAG WORD 的 Value 记录本身。长度由其 TAG 决定。

## 数值 {#수치}

- 判定值（−1~1）、Qualifier（0~1）、攻击强度（0~1）是 [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md) Value。不另设定点数格式。
- 编码器去掉系数末尾的 0。0.8 为 `C=8, E=−1`。解码器接受到小数点后 4 位。
- 置信度门（例：`at least 75%`）用比较运算符 1 WORD 和百分比 [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) Value（`E=0`）写入（[LINK](#link) F_GATE）。
- 攻击强度是 ATTACKS 的 F_FORCE 字段（[LINK](#공격-세기)）。超出范围则拒绝。

## 节点声明的轴 {#노드-선언의-축}

- 节点声明（RULE·COUNTER·EXCEPT-DECLARE）具有角色（主张·反驳·例外）、Qualifier（0~1）、Level（Unset、Fail、Review）。角色由 Codec 和 NODE 头部的 role 承载，Qualifier 由 F_QUAL 承载，Level 由头部的 level 承载（[NODE](#node)）。
- 刚度（Strict、Defeasible、Defeater）是与角色无关的另一个轴。刚度的布局尚未确定。
- 攻击强度（Force）不是节点的值，而是 ATTACKS 边的值（[LINK](#공격-세기) F_FORCE）。与刚度是不同的轴。

## 在未知之上做判定 {#미상-위에서-판정하기}

当判定图接收 GEUL 事实作为输入时，[占位标记](../slot-marker.md)的三个概念（未写出、未知、无）按不同方式求值。[EXPR](0x101L-predicate-declare.md) 比较运算符的求值如下。

| 输入 | `is empty` | `is not empty` | `equals` / `is in` / 大小比较 |
|---|---|---|---|
| 值 v | 假 | 真 | 按 v 求值 |
| NO-VALUE (无) | **真** | 假 | 假 |
| UNKNOWN-VALUE (未知) | 假 | **真** | **未定(U)** |
| ABSENT (未写出) / 无陈述 | U (开放世界) | U | U |

- 逻辑使用 Kleene 强三值。`NOT U = U`，`假 AND U = 假`，`真 OR U = 真`。其余组合的 U 仍为 U。
- `EXISTS any` 在元素中有一个为真时为真。没有真而有 U 时为 U，全部为假时为假。
- **谓词为 U 时，该节点的判定不是 Pass·Fail，而是 Review。** 不知道就交给人（或下一阶段）。
- 要把 ABSENT 看作 empty 而非 U，输入一侧必须**声明**封闭世界（作为判断标准 SPEC 注入，例："此案件的输入是完整的"）。没有声明则为 U。
- 此表和 U → Review 的对应是判定的语义，属于**固定核心**。不能用 TOULMIN 文档更改。
- 例："只统计现在仍有效的国境"（`P582 is empty`）规则：P582 = UNKNOWN-VALUE 时为假而排除，P582 = NO-VALUE 时为真而纳入，没有 P582 时为 U，因此交给 Review。

## 判定结果 {#판정-결과}

- 判定结果（`VERDICT`、`EVIDENCE`）放在与判定对象不同的文档中。结果文档用 [IMPORT-DOC](../meta/0x1E4L-import-doc.md) 导入对象文档，并用 [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) 指向它。因此即使做出判定，对象文档的内容哈希也不会改变。
- 整个文档的判定是 Meta `VERDICT`，节点·记录的判定是 TOULMIN `VERDICT`。
- 选择修订适用版本的规则（过渡规定、行为时法与新法的选择）以及解释例·判例，也用作判定规则（[文档](../document.md#개정)）。

## 未决问题 {#열린-문제}

- SUPERSEDE-CHAIN（`0x10AL`）、VERDICT（`0x118L`）、EVIDENCE（`0x119L`）的布局。以目前每一对写一条 SUPERSEDES 的方式是否足以表达链。
- 节点刚度（Strict、Defeasible、Defeater）的布局。
- 写了攻击强度 1 的 ATTACKS 与没写的 ATTACKS，判定相同但字节不同。判定是否相同，必须比较解释后的值而不是字节。
- EXPR 中的节点数、标签数、标签索引为 1 WORD，子节点数为 13 位。上限是固定的。
- PROVENANCE（规则出处·前提）布局。
- 反引号名称是否用陈述 [LABEL](../edge/0x0A4L-label.md)·[BIND](../edge/0x0A3L-bind.md)，而不是 TEXT + LABEL（`0x134L`）。
- Claim 的 predicate·mode 代码值和 FuncRef 的 VerbCode 代码值表。
- 封闭世界声明（把 ABSENT 读作 empty）是以判断标准（SPEC）为单位，还是以案件为单位。
- TOULMIN Codec 的 [Codec 规格文档](../codec-spec.md)。NODE·LINK 的条件字段以及由 SOURCE 决定的 SPAN 宽度，属于无法用 FIELD 声明的布局。

## 相关页面 {#관련-페이지}

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE 与分段](#source와-구획)
- [文档](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE 是用于写入 TOULMIN 判定·执行图节点的布局。节点种类由 Codec 决定，头部 1 WORD 决定角色、Level、Claim 形态和条件字段。

### Codec {#codec}

| Codec | 名称 | TANGEUL | 节点 |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | 案件 |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | Definitions 条目（`means`, `has`） | 判断标准（Backing）。role 表示定义种类 |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | 主张（Warrant） |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | 反驳（Rebuttal） |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | 例外（Defeater） |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | 外部入口 |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | 事件·周期入口 |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | 文档命名空间 |
| `0x127L` | [FUNC](0x127L-func.md) | 函数引用 | 外部函数（例：`bank.withdraw`） |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | 必填字段 |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | 导入的包别名 |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` 有序列表 | 有序执行分组 |

`0x126L~0x12AL` 是 Edge TOULMIN 形式系列的直接码（[TOULMIN](#toulmin-형식)）。

### 布局 {#레이아웃}

```
ID               LOCAL Reference 记录 (Edge Id)
头部 1 WORD      role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | object 种类 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 没有则为 0) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value。Qualifier
[F_CHECK]        REF(案件)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value。判定值初始值
[F_WITH]         个数(UNSIGNED-INTEGER Value) + REF(TEXT) × 个数
[F_GROUNDS]      个数(UNSIGNED-INTEGER Value) + REF(TEXT) × 个数
SPAN             由 SOURCE 决定的宽度 × 2 (起始字节, 字节数)
```

#### 头部 WORD {#헤더-word}

| 位 | 字段 | 值 |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | 有依据列表 |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | object 种类 | Claim object 的形态。0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | 见下表 |

| 位 | flag | 含义 |
|---|---|---|
| b0 | F_FUNC | 有 FuncRef 字段 |
| b1 | F_QUAL | 有 Qualifier 字段 |
| b2 | F_CHECK | 有 `checking` 对象案件字段 |
| b3 | F_CLAIM | 有 Claim 字段 |
| b4 | F_VERDICT | 有判定值初始值字段 |
| b5 | F_STRIKE | 以删除线划掉的声明。没有字段 |
| b6 | F_WITH | 有基准列表字段 |

- 条件字段按 flag 顺序（F_FUNC、F_QUAL、F_CHECK、F_CLAIM、F_VERDICT、F_WITH、F_GROUNDS）排列。flag 关闭的字段不占位置。
- flag 已开启但没有字段时拒绝。依次读完字段后的位置，在 SPAN 之后必须与记录末尾恰好吻合。

### 字段 {#필드}

| 字段 | 说明 |
|---|---|
| FuncRef | 函数位。REF 是导入该函数的 ALIAS 记录，若是本文档的函数则为 `0`。VerbCode 是 1 WORD 代码，尚未分配（允许 `0x0000`）。函数的原文写法另用 TEXT + [LABEL](#link) 书写 |
| Qualifier | 节点的置信度（0~1） |
| 案件 | F_CHECK：此节点只做判定的案件（`checking c`） |
| Claim | 节点承载的命题。subject REF、predicate 1 WORD、object、mode 1 WORD。object 的形态由头部的 object 种类决定 |
| 判定值 | 判定值的初始值（−1~1） |
| F_WITH | 声明时点的判断标准（`기준으로 하는`，"以……为基准的"）。TEXT 记录 REF 列表 |
| F_GROUNDS | 求值时点解析的外部事实名称（`근거로 하는`，"以……为依据的"）。TEXT 记录 REF 列表 |
| SPAN | 此声明出自的原文范围 |

- 判定值·Qualifier 的写法遵循 [TOULMIN](#수치) 数值规则。
- 列表的个数是内置的 [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) Value 记录。
- 陈述 Claim 的基本形态是 subject·predicate 为 `0`，object 为 SPAN（object 种类 2）。固定于原文写法。

### 解释与有效性 {#해석과-유효성}

- role 在 RULE·COUNTER·EXCEPT-DECLARE 中必须与 Codec 一致（0 general, 1 counter, 2 except）。在 SPEC-DECLARE 中是定义种类。在其他 Codec 中为 0。
- level 为 0（Unset）时使用引擎的默认值：COUNTER-DECLARE 为 Fail，EXCEPT-DECLARE 为 Review。
- TANGEUL `tangl:규칙` 的宿主函数规则（`쓰는 규칙이다`，"使用的规则"）写成案件之外的 RULE-DECLARE NODE。函数为 F_FUNC，基准为 F_WITH，依据为 F_GROUNDS。只有条件式规则才在前面放 [PREDICATE-DECLARE](0x101L-predicate-declare.md)。
- Reserved 位（13–12）必须为 0。Reserved 位开启或 role 与 Codec 不符时拒绝。

### 相关页面 {#관련-페이지-1}

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [SOURCE 与分段](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK 是用于写入 TOULMIN 图中节点之间关系的布局。关系的种类由 Codec 决定。

### Codec {#codec-1}

| Codec | 名称 | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | 规则 → 规则。按攻击强度逐步削减判定 |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | 规则 → 规则。为 Active 时在汇总中剔除对象 |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | 规则 → 案件 |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | 规则 → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | 规则 → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | 规则 → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | 规则 → 案件。无副作用的判定 |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | 案件 → 字段 |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | 定义条目 → 值·类型 |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | 定义条目 → 字段 |
| `0x12EL` | [RUNS](0x12EL-runs.md) | 入口 `run c` | 入口 → 案件（执行） |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | 入口 `check c` | 入口 → 案件（判定） |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | 触发器 `run c` | 触发器 → 案件 |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | 触发器 → 案件 |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | 节点 → 全局标识符 |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | 别名 → 路径（TEXT） |
| `0x134L` | [LABEL](0x134L-label.md) | 反引号名称 | 节点 → TEXT。名称标记 |

### 布局 {#레이아웃-1}

```
ID               LOCAL Reference 记录 (Edge Id)
src              REF
dst              REF。DO·DO-ONCE·UNDO 为 FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         运算符 1 WORD(高 2 位) + UNSIGNED-DECIMAL Value(百分比)
[F_FORCE]        SIGNED-DECIMAL Value。攻击强度(0~1)。仅 ATTACKS
SPAN             由 SOURCE 决定的宽度 × 2
```

| flag | 含义 |
|---|---|
| b0 F_ONCE | 只执行一次（UNDO 的 `once`） |
| b1 F_GATE | 有置信度门字段 |
| b2 F_STRIKE | 以删除线划掉的关系 |
| b3 F_ORDERED | 属于 `1.` 有序列表 |
| b4 F_FORCE | 有攻击强度字段。仅 ATTACKS |

| 门运算符 | 含义 |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- 条件字段按 flag 顺序（F_GATE、F_FORCE）排列。flag 关闭的字段不占位置。

### 攻击强度 {#공격-세기}

攻击强度（F_FORCE）仅由 [ATTACKS](0x108L-attacks.md#공격-세기) 使用。判定式、写法、示例见该页。

### 解释与有效性 {#해석과-유효성-1}

- REF 是本文档记录的 Edge Id（[TOULMIN](#공통-필드) 公共字段）。
- dst 的形态由 Codec 决定。DO·DO-ONCE·UNDO 为 FuncRef（REF(ALIAS，没有则为 0) + VerbCode 1 WORD，[NODE](#필드)），LABEL·IMPORTED-FROM 为 TEXT 记录的 REF，其余为节点的 REF。
- `do … once` 由 DO-ONCE Codec 表示。DO-ONCE 的 flags 不使用 F_ONCE（若已开启则拒绝）。UNDO 的 `once` 用 F_ONCE 表示。
- 门运算符是运算符 WORD 的高 2 位，其余 14 位为 0。百分比是 `E=0` 的 UNSIGNED-DECIMAL Value，范围 0~100。
- flags 的 b5~b15 为 Reserved，必须为 0。否则拒绝。
- F_FORCE 仅在 ATTACKS 中使用。在其他 Codec（SUPERSEDES、执行·判定连接、TOULMIN 形式关系）中开启则拒绝。
- 攻击强度不是 SIGNED-DECIMAL Value、超出 0~1 范围或无法用小数点后 4 位精确表示时，拒绝。
- SUPERSEDES 的链 `A > B > C` 每一对写一条 SUPERSEDES。

### 相关页面 {#관련-페이지-2}

- [TOULMIN](_index.md), [NODE](#node), [SOURCE 与分段](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## SOURCE 与分段 {#source와-구획}

写入 TOULMIN 文档原文与分段的记录。全部是 Edge TOULMIN 形式系列直接码 `0x120L~0x125L`（[TOULMIN](#toulmin-형식)）。没有 Issuer 和 Codec 编号栏，TAG 之后是 Payload。

### 形式 {#형식}

| Codec | 名称 | 布局 |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN 宽度 WORD, UTF8 Value |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value |
| `0x122L` | [SECTION](0x122L-section.md) | ID, 章节代码 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF(案件) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF(案件) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID 是 Edge Id，REF 是本文档记录的 Edge Id（[TOULMIN](#공통-필드) 公共字段）。
- UTF8 Value 是 [UTF8-TEXT](../value/0x072L-utf8-text.md) Value 记录。原样存放字节。

### 各形式的页面 {#형식별-쪽}

布局、章节代码表、解释在每种形式各自的页面中。

- [SOURCE](0x120L-source.md)：撰写原文。BODY 的第一条记录，决定 SPAN 宽度
- [TEXT](0x121L-text.md)：名称·字符串
- [SECTION](0x122L-section.md)：章节开始与章节代码
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md)：案件范围
- [PROSE](0x125L-prose.md)：叙述段落

### 相关页面 {#관련-페이지-3}

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
