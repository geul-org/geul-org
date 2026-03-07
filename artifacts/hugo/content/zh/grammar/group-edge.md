---
title: "分组边"
weight: 90
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "group", "set", "logic"]
summary: "将多个Node以AND、OR、LIST、SET等7种类型组合的可变长度Edge。采用13位Prefix和终止标记(0x0000)方式支持无限数量成员。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Group Edge 是将**多个 Node 组合为一个分组**来表达的 Edge 类型。

## 数据包结构

```
1st WORD (16位)
┌───────────────────────┬───────────┐
│        Prefix         │ GroupType │
│        13位           │   3位     │
└───────────────────────┴───────────┘
  [1100 000 111 000]       [TTT]

2nd WORD: Edge TID (16位)
3rd+ WORD: 成员 TID（可变）
最后 WORD: 终止标记 (0x0000)
```

| 字段 | 位 | 说明 |
|------|------|------|
| Prefix | 13 | `1100 000 111 000` |
| GroupType | 3 | 分组种类（8种） |
| Edge TID | 16 | 此 Edge 的唯一标识符 |
| 成员 TID | 16×N | 分组成员引用 |
| 终止标记 | 16 | `0x0000` |

最少4字（1个成员），一般5~6字（2~3个成员），最大无限制。

## GroupType（3位 = 8种）

| 代码 | 类型 | 含义 | 成员数 |
|------|------|------|---------|
| 000 | **AND** | 逻辑与（conjunction） | 2+ |
| 001 | **OR** | 逻辑或（disjunction） | 2+ |
| 010 | **XOR** | 排他选择 | 2+ |
| 011 | **LIST** | 有序列表 | 1+ |
| 100 | **SET** | 无序集合 | 1+ |
| 101 | **RANGE** | 范围（起始~结束） | 恰好2 |
| 110 | **PAIR** | 有序对 | 恰好2 |
| 111 | 扩展 | 未来扩展 | - |

## GroupType 详述

### AND

所有成员同时参与。例："小明**和**小红**和**小华开了会"

### OR

成员中一个以上适用（inclusive or）。例："请点**咖啡**或者**茶**"

### XOR

成员中恰好一个适用（exclusive or）。例："及格或不及格（二选一）"

### LIST

顺序有意义的列表。用于排名、序列。例："第1名小明，第2名小红，第3名小华"

### SET

顺序无意义的集合。仅成员身份重要。例："出席者：小明、小红、小华"

### RANGE

连续范围，包含中间值。成员恰好2个（起始、结束）。例："从1到10"

### PAIR

简单有序对。成员恰好2个。用于坐标、key-value等。例："坐标 (3, 5)"

### RANGE vs PAIR

| 类型 | 含义 | 中间值 |
|------|------|---------|
| RANGE | 连续范围 | 包含 |
| PAIR | 简单对 | 无 |

`RANGE [1, 5]` → 1, 2, 3, 4, 5（中间值存在）。`PAIR [1, 5]` → (1, 5)（仅两个值）。

## 示例

### "小明和小红见面了"

```
1. Entity Node: 小明 (TID=0x0001)
2. Entity Node: 小红 (TID=0x0002)
3. Group Edge: AND (TID=0x0100)
   1st: [1100 000 111 000] [000] = Prefix + AND
   2nd: [0x0100]                 = Edge TID
   3rd: [0x0001]                 = 小明
   4th: [0x0002]                 = 小红
   5th: [0x0000]                 = 终止

4. Verb Edge: meet
   Subject: 0x0100 (分组引用)

总计: 5字
```

### "坐标 (3, 5)"

```
1. Quantity Node: 3 (TID=0x0001)
2. Quantity Node: 5 (TID=0x0002)
3. Group Edge: PAIR (TID=0x0100)
   1st: [1100 000 111 000] [110] = Prefix + PAIR
   2nd: [0x0100]
   3rd: [0x0001]                 = 第一个 (x)
   4th: [0x0002]                 = 第二个 (y)
   5th: [0x0000]

总计: 5字
```

## 约束条件

| GroupType | 最少 | 最多 |
|-----------|------|------|
| AND / OR / XOR | 2 | 无限 |
| LIST / SET | 1 | 无限 |
| RANGE / PAIR | 2 | 2 |

- 成员 TID 必须引用已声明的 Node/Edge
- 不允许自引用（循环）
- TID=0x0000 作为终止标记保留
