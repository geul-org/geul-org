---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE 是书写 TOULMIN 图节点（案件、规则、定义、入口、触发器、函数、字段、别名、分组）的布局。1 WORD 头的 flag 决定其后的条件字段。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE 是书写 TOULMIN 判定·执行图节点的布局。节点种类由 Codec（或 GEUL ISSUER 格式编号）决定，1 WORD 的头决定角色·Level·Claim 形态和条件字段。

## Codec

| Codec | 名称 | TANGEUL | 节点 |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | 案件 |
| `0x62` | SPEC-DECLARE | Definitions 项（`means`、`has`） | 判断标准（Backing）。role 是定义种类 |
| `0x63` | RULE-DECLARE | general rule | 主张（Warrant） |
| `0x64` | COUNTER-DECLARE | counter rule | 反驳（Rebuttal） |
| `0x65` | EXCEPT-DECLARE | except rule | 例外（Defeater） |
| `0x75` | ENTRY | `provides x` | 外部入口 |
| `0x76` | TRIGGER | `on`, `every`, `until` | 事件·周期入口 |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | 文档命名空间 |
| ISSUER `0x0000`/`0xC011` | FUNC | 函数引用 | 外部函数（例：`bank.withdraw`） |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | 必需字段 |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | 被导入包的别名 |
| ISSUER `0x0000`/`0xC014` | GROUP | `1.` 有序列表 | 有序执行组 |

ISSUER 格式在 `ISSUER-1WORD`（`0x7C`）之后的 Codec 扩展 TAG 中放 Issuer `0x0000` 和格式编号（[TOULMIN](/zh/grammar/edge/toulmin/)）。

## 布局

```
ID               LOCAL Reference 记录 (Edge Id)
头 1 WORD        role 2b | 保留 2b | F_GROUNDS 1b | level 2b | object 种类 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 没有则为 0) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value。Qualifier
[F_CHECK]        REF(案件)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value。判定值初始值
[F_WITH]         个数(UNSIGNED-INTEGER Value) + REF(TEXT) × 个数
[F_GROUNDS]      个数(UNSIGNED-INTEGER Value) + REF(TEXT) × 个数
SPAN             SOURCE 所定宽度 × 2 (起始字节, 字节数)
```

### 头 WORD

| 位 | 字段 | 值 |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | 保留 | 0 |
| 11 | F_GROUNDS | 有依据列表 |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 保留) |
| 8–7 | object 种类 | Claim object 的形态。0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | 见下表 |

| 位 | flag | 含义 |
|---|---|---|
| b0 | F_FUNC | 有 FuncRef 字段 |
| b1 | F_QUAL | 有 Qualifier 字段 |
| b2 | F_CHECK | 有 `checking` 目标案件字段 |
| b3 | F_CLAIM | 有 Claim 字段 |
| b4 | F_VERDICT | 有判定值初始值字段 |
| b5 | F_STRIKE | 用删除线划掉的声明。没有字段 |
| b6 | F_WITH | 有标准列表字段 |

- 条件字段按 flag 顺序（F_FUNC、F_QUAL、F_CHECK、F_CLAIM、F_VERDICT、F_WITH、F_GROUNDS）放置。flag 关闭的字段不占位置。
- flag 开启却没有字段则拒绝。依次读完字段后的位置，必须在 SPAN 之后与记录末尾恰好吻合。

## 字段

| 字段 | 说明 |
|---|---|
| FuncRef | 函数位置。REF 是导入该函数的 ALIAS 记录，如果是本文档的函数则为 `0`。VerbCode 是 1 WORD 的码，尚未分配（允许 `0x0000`）。函数的原文写法另用 TEXT + [LABEL](/zh/grammar/edge/toulmin/link/) 来写 |
| Qualifier | 节点的置信度（0~1） |
| 案件 | F_CHECK：该节点只做判定的案件（`checking c`） |
| Claim | 节点所含的命题。subject REF、predicate 1 WORD、object、mode 1 WORD。object 的形态由头中的 object 种类决定 |
| 判定值 | 判定值的初始值（−1~1） |
| F_WITH | 声明时点的判定标准（`기준으로 하는`，“基于……标准”）。TEXT 记录 REF 列表 |
| F_GROUNDS | 评估时点解析的外部事实名称（`근거로 하는`，“以……为依据”）。TEXT 记录 REF 列表 |
| SPAN | 该声明出自原文的范围 |

- 判定值·Qualifier 的写法遵循 [TOULMIN](/zh/grammar/edge/toulmin/#数值) 数值规则。
- 列表的个数是内置的 [UNSIGNED-INTEGER](/zh/grammar/value/numeric/unsigned-integer/) Value 记录。
- 叙述 Claim 的基本形态是 subject·predicate 为 `0`，object 为 SPAN（object 种类 2）。固定在原文写法上。

## 解读与有效性

- role 在 RULE·COUNTER·EXCEPT-DECLARE 中必须与 Codec 相同（0 general，1 counter，2 except）。在 SPEC-DECLARE 中是定义种类。在其他 Codec 中为 0。
- level 为 0（Unset）时使用引擎默认值：COUNTER-DECLARE 为 Fail，EXCEPT-DECLARE 为 Review。
- TANGEUL `tangl:규칙`（“规则”）的宿主函数规则（`쓰는 규칙이다`，“是使用……的规则”）作为案件之外的 RULE-DECLARE NODE 来写。函数是 F_FUNC，标准是 F_WITH，依据是 F_GROUNDS。只有条件表达式规则才在前面放 [PREDICATE-DECLARE](/zh/grammar/edge/toulmin/expr/)。
- 保留位（13–12）必须为 0。保留位开启或 role 与 Codec 不符则拒绝。

## 相关页面

- [TOULMIN](/zh/grammar/edge/toulmin/)、[LINK](/zh/grammar/edge/toulmin/link/)、[EXPR](/zh/grammar/edge/toulmin/expr/)、[SOURCE 与分区](/zh/grammar/edge/toulmin/source/)
- [LOCAL](/zh/grammar/reference/local/)、[SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/)
