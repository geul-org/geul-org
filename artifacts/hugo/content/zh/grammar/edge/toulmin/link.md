---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK 是书写 TOULMIN 节点之间关系（攻击、排除、执行、判定连接、定义、名称）的布局。由 src·dst REF 与 flag WORD、可选置信度门槛、SPAN 构成。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK 是在 TOULMIN 图中书写节点之间关系的布局。关系的种类由 Codec（或 GEUL ISSUER 格式编号）决定。

## Codec

| Codec | 名称 | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | 规则 → 规则。逐步削弱判定 |
| `0x69` | SUPERSEDES | `X supersedes Y` | 规则 → 规则。为 Active 时把目标从汇总中剔除 |
| `0x70` | RUN | `run c when n` | 规则 → 案件 |
| `0x71` | DO | `do fn when n` | 规则 → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | 规则 → FuncRef |
| `0x73` | UNDO | `undo fn when n` | 规则 → FuncRef |
| `0x74` | CHECKING | `checking c` | 规则 → 案件。没有副作用的判定 |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | 案件 → 字段 |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | 定义项 → 值·类型 |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | 定义项 → 字段 |
| ISSUER `0x0000`/`0xC023` | RUNS | 入口 `run c` | 入口 → 案件（执行） |
| ISSUER `0x0000`/`0xC024` | EVALUATES | 入口 `check c` | 入口 → 案件（判定） |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | 触发器 `run c` | 触发器 → 案件 |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | 触发器 → 案件 |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | 节点 → 全局标识符 |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | 别名 → 路径（TEXT） |
| ISSUER `0x0000`/`0xC029` | LABEL | 反引号名称 | 节点 → TEXT。名称标注 |

## 布局

```
ID               LOCAL Reference 记录 (Edge Id)
src              REF
dst              REF。DO·DO-ONCE·UNDO 为 FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         运算符 1 WORD(高 2 位) + UNSIGNED-DECIMAL Value(百分比)
SPAN             SOURCE 所定宽度 × 2
```

| flag | 含义 |
|---|---|
| b0 F_ONCE | 只执行一次（UNDO 的 `once`） |
| b1 F_GATE | 有置信度门槛字段 |
| b2 F_STRIKE | 用删除线划掉的关系 |
| b3 F_ORDERED | 属于 `1.` 有序列表 |

| 门槛运算符 | 含义 |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## 解读与有效性

- REF 是本文档记录的 Edge Id（[TOULMIN](/zh/grammar/edge/toulmin/#公共字段)公共字段）。
- dst 的形态由 Codec 决定。DO·DO-ONCE·UNDO 是 FuncRef（REF(ALIAS，没有则为 0) + VerbCode 1 WORD，[NODE](/zh/grammar/edge/toulmin/node/#字段)），LABEL·IMPORTED-FROM 是 TEXT 记录的 REF，其余是节点的 REF。
- `do … once` 由 DO-ONCE Codec 表示。DO-ONCE 的 flags 中不使用 F_ONCE（开启则拒绝）。UNDO 的 `once` 用 F_ONCE 来写。
- 门槛运算符是运算符 WORD 的高 2 位，其余 14 位为 0。百分比是 `E=0` 的 UNSIGNED-DECIMAL Value，范围 0~100。
- flags 的 b4~b15 为保留，必须为 0。否则拒绝。
- SUPERSEDES 的链 `A > B > C` 每对写一个 SUPERSEDES。

## 相关页面

- [TOULMIN](/zh/grammar/edge/toulmin/)、[NODE](/zh/grammar/edge/toulmin/node/)、[SOURCE 与分区](/zh/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/zh/grammar/value/decimal/unsigned-decimal/)
