---
title: "子句边"
weight: 40
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "clause", "RST", "discourse"]
summary: "表达谓述、事件、关系之间逻辑和篇章关系的4字固定Edge。基于RST的16种关系类型编码因果、时间、对比、论证关系。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Clause Edge 是表达谓述（[动词边](../verb-edge/)）、事件（[事件6边](../event6-edge/)）、关系（[三元组边](../triple-edge/)）或其他 Clause 之间**逻辑/篇章关系**的 Edge 类型。

基于 RST（Rhetorical Structure Theory）的篇章关系设计。

## 数据包结构（4字，64位）

```
1st WORD (16位):
┌─────────────────────┬────────────┬────────┐
│      Prefix         │  关系类型   │  保留   │
│       10位          │   4位      │  2位   │
└─────────────────────┴────────────┴────────┘
 [1100 000 010]        [RRRR]       [xx]

2nd WORD: Edge TID (16位)
3rd WORD: TID 1 (16位) - 第一个子句
4th WORD: TID 2 (16位) - 第二个子句
```

| 字段 | 位 | 说明 |
|------|------|------|
| Prefix | 10 | `1100 000 010` |
| 关系类型 | 4 | 16种 RST 关系 |
| 保留 | 2 | 未来扩展用 |
| Edge TID | 16 | 此 Edge 的唯一标识符 |
| TID 1 | 16 | 第一个子句引用 |
| TID 2 | 16 | 第二个子句引用 |

## 关系类型（4位 = 16种）

### 因果关系

| 代码 | 类型 | 说明 | 示例 |
|------|------|------|------|
| 0000 | CAUSE | 原因→结果 | "因为下雨所以待在家里" |
| 0001 | RESULT | 结果←原因 | "待在家里，因为下雨了" |
| 0010 | CONDITION | 条件→结论 | "如果下雨就不去" |
| 0011 | PURPOSE | 目的 | "为了活着而吃饭" |

### 时间/顺序关系

| 代码 | 类型 | 说明 | 示例 |
|------|------|------|------|
| 0100 | SEQUENCE | 时间顺序 | "吃完饭就睡了" |
| 0101 | PARALLEL | 同时/并行 | "一边笑一边说" |

### 对比/让步关系

| 代码 | 类型 | 说明 | 示例 |
|------|------|------|------|
| 0110 | CONTRAST | 对比 | "A大而B小" |
| 0111 | CONCESSION | 让步 | "虽然难但做了" |

### 补充/背景关系

| 代码 | 类型 | 说明 | 示例 |
|------|------|------|------|
| 1000 | ELABORATION | 详述 | "具体来说" |
| 1001 | BACKGROUND | 背景信息 | "顺便说一下，当时的情况是" |

### 论证关系

| 代码 | 类型 | 说明 | 示例 |
|------|------|------|------|
| 1010 | EVIDENCE | 提供证据 | "因为......所以" |
| 1011 | EVALUATION | 评价 | "这很好/不好" |

### 其他关系

| 代码 | 类型 | 说明 | 示例 |
|------|------|------|------|
| 1100 | SOLUTIONHOOD | 问题→解决 | "问题是X，解决方案是Y" |
| 1101 | ALTERNATIVE | 选择/替代 | "去或不去" |
| 1110 | MEANS | 手段 | "通过这样做达成了" |
| 1111 | RESERVED | 保留 | 未来扩展用 |

## TID 顺序规则

方向由 TID 顺序决定。

| 关系 | TID 1 | TID 2 |
|------|-------|-------|
| CAUSE | 原因 | 结果 |
| RESULT | 结果 | 原因 |
| CONDITION | 条件 | 结论 |
| PURPOSE | 行为 | 目的 |
| SEQUENCE | 先行 | 后行 |
| EVIDENCE | 证据 | 主张 |
| ELABORATION | 核心 | 补充 |

## Multinuclear vs Nucleus-Satellite

遵循 RST 区分。

### Nucleus-Satellite（非对称）

| 关系 | TID 1 | TID 2 |
|------|-------|-------|
| CAUSE | 原因 (Satellite) | 结果 (Nucleus) |
| CONDITION | 条件 (Satellite) | 结论 (Nucleus) |
| EVIDENCE | 证据 (Satellite) | 主张 (Nucleus) |
| ELABORATION | 核心 (Nucleus) | 补充 (Satellite) |

### Multinuclear（对称）

| 关系 | TID 1 | TID 2 |
|------|-------|-------|
| SEQUENCE | 先行 | 后行 |
| PARALLEL | 第一个 | 第二个 |
| CONTRAST | 第一个 | 第二个 |
| ALTERNATIVE | 第一个 | 第二个 |

对称关系中 TID 顺序不表示语义优先级。

## 示例

### 简单因果："因为下雨所以待在家里"

```
Verb Edge E01: rain(雨) | TID=0x0001
Verb Edge E02: stay(我, 家) | TID=0x0002

Clause Edge:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE + 保留
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - TID 1 (原因: E01)
  4th: [0x0002]                    - TID 2 (结果: E02)
```

### 嵌套 Clause："因为下雨待在了家里，所以就学习了"

```
Verb Edge E01: rain(雨) | TID=0x0001
Verb Edge E02: stay(我, 家) | TID=0x0002
Verb Edge E03: study(我) | TID=0x0003

Clause Edge C01:
  1st: [1100 000 010] [0000] [00]  - Prefix + CAUSE
  2nd: [0x0100]                    - Edge TID
  3rd: [0x0001]                    - E01
  4th: [0x0002]                    - E02

Clause Edge C02:
  1st: [1100 000 010] [0001] [00]  - Prefix + RESULT
  2nd: [0x0101]                    - Edge TID
  3rd: [0x0100]                    - C01 (引用 Clause TID!)
  4th: [0x0003]                    - E03
```

## 设计依据

### 基于 RST 的原因

- 30年以上的研究积累
- 多种语料库验证
- 存在篇章分析工具
- 语言无关性

### 4位（16种）的原因

- 覆盖 RST 核心关系12种以上
- 保留扩展余量
- 3位（8种）不够

### 4字简化的原因

- 方向：由 TID 顺序决定（无需额外位）
- 确信度：作为单独的元数据处理
- 2位保留：供未来扩展
