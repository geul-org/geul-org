---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK 是书写 TOULMIN 节点之间关系（攻击、排除、执行、判定连接、定义、名称）的布局。由 src·dst REF 与 flag WORD、可选置信度门槛、可选攻击力度、SPAN 构成。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK 是在 TOULMIN 图中书写节点之间关系的布局。关系的种类由 Codec（或 GEUL ISSUER 格式编号）决定。

## Codec

| Codec | 名称 | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | 规则 → 规则。按攻击力度逐步削弱判定 |
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
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         运算符 1 WORD(高 2 位) + UNSIGNED-DECIMAL Value(百分比)
[F_FORCE]        SIGNED-DECIMAL Value. 攻击力度（0~1）。仅限 ATTACKS
SPAN             SOURCE 所定宽度 × 2
```

| flag | 含义 |
|---|---|
| b0 F_ONCE | 只执行一次（UNDO 的 `once`） |
| b1 F_GATE | 有置信度门槛字段 |
| b2 F_STRIKE | 用删除线划掉的关系 |
| b3 F_ORDERED | 属于 `1.` 有序列表 |
| b4 F_FORCE | 有攻击力度字段。仅限 ATTACKS |

| 门槛运算符 | 含义 |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- 条件字段按 flag 顺序（F_GATE、F_FORCE）放置。flag 关闭的字段不占位置。

## 攻击力度

攻击力度（Force）表示一条 ATTACKS 边攻击目标的力度。范围为 0~1，没有 F_FORCE 时为 1。

- 判定时，攻击者判定值 v 的贡献 `(v+1)/2` 乘以力度 F。反驳（COUNTER）攻击进入分母项 `F·(v+1)/2`，例外（EXCEPT）攻击进入门槛 `Π(1 − F·(v+1)/2)`。F 为 0 时该攻击不影响判定。
- 值遵循 [TOULMIN](/zh/grammar/edge/toulmin/#数值) 数值规则。编码器去掉系数末尾的 0（0.5 为 `C=5, E=−1`，1.0 为 `C=1, E=0`）。解码器接受最多 4 位小数。
- 不写力度的表面（`don't X when Y`，韩语 `` `Y` 면 `X` 는 무효다``）关闭 F_FORCE。
- 写出力度的表面（韩语 `` `Y` 면 `X` 를 0.5의 세기로 공격한다``）打开 F_FORCE 并存入该值。即使像 `1.0의 세기로` 那样写出 1，也打开 F_FORCE 并存入 1。这样原文表面能原样还原。
- 攻击力度与节点的强度（Strict、Defeasible、Defeater）是不同的轴。强度属于节点，攻击力度属于 ATTACKS 边。

### 示例

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``。Edge Id 5，攻击者 Y 为 Edge Id 3，目标 X 为 Edge Id 2，SPAN 宽度 1 WORD。

```
16E8                  TAG WORD: Edge，共 14 WORD，Codec 0x68（ATTACKS）
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, 攻击者)
0088 0002             dst     LOCAL 2 (X, 目标)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    起始字节 0x40，字节数 0x1A
```

不写力度的同一条边 flags 为 `0000`，没有 F_FORCE 字段。TAG WORD 为 `14E8`（共 10 WORD）。

## 解读与有效性

- REF 是本文档记录的 Edge Id（[TOULMIN](/zh/grammar/edge/toulmin/#公共字段)公共字段）。
- dst 的形态由 Codec 决定。DO·DO-ONCE·UNDO 是 FuncRef（REF(ALIAS，没有则为 0) + VerbCode 1 WORD，[NODE](/zh/grammar/edge/toulmin/node/#字段)），LABEL·IMPORTED-FROM 是 TEXT 记录的 REF，其余是节点的 REF。
- `do … once` 由 DO-ONCE Codec 表示。DO-ONCE 的 flags 中不使用 F_ONCE（开启则拒绝）。UNDO 的 `once` 用 F_ONCE 来写。
- 门槛运算符是运算符 WORD 的高 2 位，其余 14 位为 0。百分比是 `E=0` 的 UNSIGNED-DECIMAL Value，范围 0~100。
- flags 的 b5~b15 为保留，必须为 0。否则拒绝。
- F_FORCE 只用于 ATTACKS。在其他 Codec（SUPERSEDES、执行·判定连接、ISSUER 格式关系）中打开则拒绝。
- 攻击力度不是 SIGNED-DECIMAL Value、超出 0~1，或无法用 4 位小数精确表示时拒绝。
- SUPERSEDES 的链 `A > B > C` 每对写一个 SUPERSEDES。

## 相关页面

- [TOULMIN](/zh/grammar/edge/toulmin/)、[NODE](/zh/grammar/edge/toulmin/node/)、[SOURCE 与分区](/zh/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/zh/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/zh/grammar/value/decimal/signed-decimal/)
