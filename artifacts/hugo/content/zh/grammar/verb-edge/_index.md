---
title: "动词边"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "verb", "huffman", "WordNet"]
summary: "将13,767个WordNet动词按10个Primitive → 68个Sub-primitive分类，通过Huffman编码生成16位码本。Tiny(2字)/Short(3字)/Full(5字)三种数据包实现平均2.16字的压缩。"
author: "박준우"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

Verb Edge 是 GEUL 流中表达谓述/动作的 Edge 类型。将13,767个 WordNet 动词按10个 Primitive → 68个 Sub-primitive 分类，通过 **Sub-primitive 级别 Huffman 编码**生成16位码本。

## 子文档

| 文档 | 说明 |
|------|------|
| [参与者角色](./semantic-role/) | 16种 Semantic Role（4位编码） |
| [语义限定符](./qualifier/) | 证据性、语气、时态、体貌等14种限定符 |

## 动词层次结构

```
10 Primitive (最高语义范畴)
 ├── BE          ├── PERCEIVE    ├── FEEL
 ├── THINK       ├── CHANGE      ├── CAUSE
 ├── MOVE        ├── COMMUNICATE ├── TRANSFER
 └── SOCIAL
  → 68 Sub-primitive (中间分类)
    → 559 Root Verb (根动词)
      → 13,767 Leaf Verb (WordNet 全部动词)
```

- Primitive（大分类）仅负责**概念分组**，无位分配
- Sub-primitive（小分类）68个分配**基于频率的可变长度编码**
- 高频动词群使用更短的编码（4位 ~ 8位）

## Verb Edge 数据包类型

Tiny/Short/Full 三种数据包类型在最后一个字共享相同的 **16位动词主体**。

| | Tiny | Short | Full |
|--|------|-------|------|
| 字 | 2 (32bit) | 3 (48bit) | 5 (80bit) |
| 参与者 | 16模式 | 512模式 | 19bit 标志 |
| 限定符 | 7模式 | 3,640模式 | 27bit |
| 动词主体 | 16bit | 16bit | 16bit |
| 预期比例 | 90% | 7% | 3% |

**平均数据包大小：** 0.9×2 + 0.07×3 + 0.03×5 = **2.16字**

### Tiny Verb Edge（2字）

```
1st WORD:  [Prefix 5bit] [Target×模式 11bit]
2nd WORD:  [动词主体 16bit]
```

- Target×模式：18 Target × 113 模式 = 2,034 组合
- 参与者16模式 × 限定符7模式 = 112 + 保留1 = 113
- 覆盖率 ~90%

### Short Verb Edge（3字）

```
1st WORD:  [Prefix 6bit] [Type 1bit=0] [参与者模式 9bit]
2nd WORD:  [Target×限定符模式 16bit]
3rd WORD:  [动词主体 16bit]
```

### Full Verb Edge（5字）

```
1st WORD:  [Prefix 6bit] [Type 1bit=1] [Target参与者 5bit] [参与者标志 4bit]
2nd+3rd:   [参与者标志 15bit] [限定符 17bit]
4th WORD:  [限定符 10bit] [保留 6bit]
5th WORD:  [动词主体 16bit]
```

## 16位动词主体

```
┌─────────────────────────┬────────────────────────────┐
│   sub_primitive code    │     树内 DFS index         │
│   (4-8位, Huffman)       │     (8-12位)              │
└─────────────────────────┴────────────────────────────┘
```

- **sub_primitive code：** 4~8位可变（Huffman 编码）
- **DFS index：** 在该 sub_primitive 内识别具体动词

### 编码长度分布

| 编码长度 | 个数 | 动词总数 | 比例 |
|-----------|------|-------------|------|
| 4位 | 4个 | 6,388 | 46.4% |
| 5位 | 4个 | 2,479 | 18.0% |
| 6位 | 8个 | 2,321 | 16.9% |
| 7位 | 16个 | 1,786 | 13.0% |
| 8位 | 36个 | 813 | 5.9% |

### DFS index 位数计算

| sub_primitive 动词数 | 所需位数 |
|----------------------|-----------|
| 1~256 | 8位 |
| 257~512 | 9位 |
| 513~1024 | 10位 |
| 1025~2048 | 11位 |
| 2049~4096 | 12位 |

例：CHANGE-TRANSFORM = `0000`（4位）+ 3,063个动词（12位）= 16位。

### 平均编码长度

```
平均 = Σ(编码长度 × 动词数) / 总动词数 ≈ 5.14位
```

| 方式 | 平均位数 |
|------|-----------|
| 固定7位（68个） | 7.00 |
| Huffman 编码 | 5.14 |
| **节省** | **1.86位 (27%)** |

## Primitive 大分类（10个）

| Primitive | 含义 | Sub-primitive 数 | 动词数 |
|-----------|------|------------------|---------|
| BE | 状态/存在 | 8 | 899 |
| PERCEIVE | 感知/认知 | 4 | 218 |
| FEEL | 情感 | 6 | 204 |
| THINK | 思考 | 6 | 769 |
| CHANGE | 变化 | 8 | 3,358 |
| CAUSE | 引起/行为 | 14 | 3,739 |
| MOVE | 移动 | 6 | 2,182 |
| COMMUNICATE | 交流 | 6 | 586 |
| TRANSFER | 转移 | 4 | 530 |
| SOCIAL | 社会行为 | 6 | 387 |

## 最高频 Sub-primitive（4位编码）

| Sub-primitive | 编码 | 动词数 | 比例 | 示例 |
|---------------|------|---------|------|------|
| CHANGE-TRANSFORM | `0000` | 3,063 | 22.2% | "变化"、"变成" |
| CAUSE-USE | `0001` | 1,358 | 9.9% | "使用"、"利用" |
| MOVE-DISPLACE | `0010` | 1,025 | 7.4% | "搬动" |
| MOVE-GO | `0011` | 942 | 6.8% | "去" |

前4个 Sub-primitive 占全部动词的46.4%。

## 设计哲学

### 选择 Huffman 编码的原因

- CHANGE-TRANSFORM（22.2%）具有压倒性高频率
- 相比固定位分配**平均位数减少27%**
- 前4个 sub_primitive 占全部的46.4%

### 移除 Primitive 位的原因

- 原方案：Primitive 3位 + Sub_primitive 4位 = 7位固定
- 变更：Sub_primitive 直接编码 = 4~8位可变
- 高频动词**最多节省4位**

### 保留语义分组

Primitive 分类为人类可读性和 LLM 学习时的语义聚类提示而保留。
