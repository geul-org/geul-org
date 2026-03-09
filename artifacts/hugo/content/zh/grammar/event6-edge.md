---
title: "事件6边"
weight: 50
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "event6", "5W1H"]
summary: "一次性表达六何原则（Who, What, Whom, When, Where, Why）的可变长度事件Edge。通过Presence位掩码实现3~8字的可变结构。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Event6 Edge 是一次性表达**六何原则**（Who, What, Whom, When, Where, Why）的事件 Edge 类型。

## 六何原则要素

| 要素 | 英文 | 位 | 含义 | TID 引用对象 |
|------|------|------|------|---------------|
| Who | Agent | 0 | 行为者 | [实体节点](../entity-node/) |
| What | Action | 1 | 行为/动作 | [动词边](../verb-edge/) |
| Whom | Patient | 2 | 对象/受动者 | [实体节点](../entity-node/) |
| When | Time | 3 | 时间 | Quantity/Entity |
| Where | Location | 4 | 地点 | [实体节点](../entity-node/) |
| Why | Reason | 5 | 原因/目的 | [子句边](../clause-edge/)/Entity |

## 数据包结构

```
1st WORD (16位)
┌────────────────────┬────────────────────┐
│      Prefix        │     Presence       │
│      10bit         │       6bit         │
└────────────────────┴────────────────────┘

2nd WORD (16位)
┌────────────────────────────────────────────┐
│                Edge TID                    │
└────────────────────────────────────────────┘

3rd+ WORD: 要素 TID（按 Presence 顺序排列）
```

### Presence 位掩码（6位）

| 位 | 要素 | 存在时 |
|------|------|--------|
| 0 | Who | 包含该 TID |
| 1 | What | 包含该 TID |
| 2 | Whom | 包含该 TID |
| 3 | When | 包含该 TID |
| 4 | Where | 包含该 TID |
| 5 | Why | 包含该 TID |

总字数 = 2（头部 + Edge TID）+ popcount(Presence)。范围为3~8字（48~128位）。

## 各模式结构

### 最小模式（3字）

```
例: "下雨了" (仅 What)

1st: [Prefix] + [000010]      - 仅 What 存在
2nd: [Edge TID]
3rd: [What TID]               - "rain" Verb Edge
```

### 核心模式（5字）

Who + What + Whom。最常见的组合。

```
例: "小明打了小红"

1st: [Prefix] + [000111]      - Who, What, Whom
2nd: [Edge TID]
3rd: [Who TID]                - 小明
4th: [What TID]               - "hit" Verb Edge
5th: [Whom TID]               - 小红
```

### 标准模式（6字）

```
例: "小明昨天见了小红"

1st: [Prefix] + [001111]      - Who, What, Whom, When
2nd: [Edge TID]
3rd: [Who TID]                - 小明
4th: [What TID]               - "meet" Verb Edge
5th: [Whom TID]               - 小红
6th: [When TID]               - 昨天
```

### 完全模式（8字）

```
例: "小明因为爱情昨天在学校把礼物给了小红"

1st: [Prefix] + [111111]      - 全部
2nd: [Edge TID]
3rd: [Who TID]                - 小明
4th: [What TID]               - "give" Verb Edge
5th: [Whom TID]               - 小红
6th: [When TID]               - 昨天
7th: [Where TID]              - 学校
8th: [Why TID]                - 爱情（原因）
```

## 要素详述

### What（行为）

What 引用[动词边](../verb-edge/) TID。该 Verb Edge 中包含时态、体貌等限定符信息。

### Why（原因）

简单原因用 Entity TID（"爱情"）表达，复杂原因用[子句边](../clause-edge/) TID（"因为下雨"）表达。

## Event6 vs Verb Edge 对比

| | Verb Edge | Event6 Edge |
|--|-----------|-------------|
| **焦点** | 谓述/动作 | 完整事件 |
| **参与者** | Participant 结构 | 六何原则 TID |
| **时空** | 另行表达 | When/Where 内置 |
| **原因** | 另行用 Clause | Why 内置 |
| **字数** | 2~5 | 3~8 |
| **用途** | 谓述表达 | 事件存储 |

**选择指南：** 谓述/句子分析用 Verb Edge，事件/记录存储用 Event6 Edge，简单事实用[三元组边](../triple-edge/)。

## 示例

### "Apple收购了Tesla"

```
Who:  Apple (Q312)     → Entity TID 0x0001
What: acquire          → Verb Edge TID 0x0100
Whom: Tesla (Q478214)  → Entity TID 0x0002

Event6 Edge:
  1st: [1100 000 011] + [000111]  - Prefix + Who,What,Whom
  2nd: [TID: 0x0200]              - Edge TID
  3rd: [TID: 0x0001]              - Apple (Who)
  4th: [TID: 0x0100]              - acquire (What)
  5th: [TID: 0x0002]              - Tesla (Whom)

总计: 5字
```

### "李舜臣于1598年在露梁海战中战死"

```
Who:   李舜臣           → Entity TID 0x0010
What:  die (战死)       → Verb Edge TID 0x0101
When:  1598            → Entity TID 0x0011
Where: 露梁海战         → Entity TID 0x0012

Event6 Edge:
  1st: [1100 000 011] + [011011]  - Who,What,When,Where
  2nd: [TID: 0x0202]
  3rd: [TID: 0x0010]              - 李舜臣
  4th: [TID: 0x0101]              - die
  5th: [TID: 0x0011]              - 1598
  6th: [TID: 0x0012]              - 露梁海战

总计: 6字
```

## 解析

```python
def parse_event6(data: bytes) -> dict:
    word1 = int.from_bytes(data[0:2], 'big')

    prefix = word1 >> 6
    assert prefix == 0b1100000011, "Not Event6 Edge"

    presence = word1 & 0x3F
    edge_tid = int.from_bytes(data[2:4], 'big')

    elements = {}
    element_names = ['who', 'what', 'whom', 'when', 'where', 'why']
    offset = 4

    for i, name in enumerate(element_names):
        if presence & (1 << i):
            tid = int.from_bytes(data[offset:offset+2], 'big')
            elements[name] = tid
            offset += 2

    return {
        'presence': presence,
        'edge_tid': edge_tid,
        'elements': elements,
        'words': 2 + bin(presence).count('1')
    }
```
