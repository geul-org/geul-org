---
title: "参与者角色"
weight: 10
date: 2026-03-01T12:00:00+09:00
lastmod: 2026-03-01T12:00:00+09:00
tags: ["grammar", "participant", "semantic-role"]
summary: "定义事件内部语义角色的16个Participant。通过4位编码表达从Agent、Theme、Recipient等核心角色到Cause、Purpose等附加角色。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/1/about"
image: "/images/og-default.webp"
---

**参与者（Participant）**是在谓述中明确事件参与实体的**语义角色**的 Edge。

```
Event Node (动词)
    ├─ PARTICIPANT Edge (role=Agent) ──→ Entity Node
    ├─ PARTICIPANT Edge (role=Theme) ──→ Entity Node
    └─ PARTICIPANT Edge (role=Instrument) ──→ Entity Node
```

## 设计原则

### 分离原则

| 区分 | 所属 | 示例 |
|------|------|------|
| **参与者** | Event 层级 | Agent, Theme, Recipient |
| **语用信息** | Context/Claim 层级 | Speaker, Listener, Evidentiality |

Speaker（说话人）、Listener（听话人）、Source（信息来源）不属于参与者，而是在**[语义限定符](../qualifier/)**或 Context/Claim 中处理。

### 编码

- **4位**（0x0~0xF），最多16种语义角色
- 可通过 SIMD 位运算进行模式匹配

## 语义角色列表（16种）

### 核心参与者（Core Participants）

| ID | 代码 | 角色 | 定义 | 示例 |
|----|------|------|------|------|
| 0x0 | **AGT** | Agent（施事者） | 有意执行行为的主体 | "**小明**踢了球" |
| 0x1 | **EXP** | Experiencer（感受者） | 经历情感/认知/感知的主体 | "**小红**很伤心" |
| 0x2 | **THM** | Theme（对象） | 被移动或被描述状态的对象 | "小明踢了**球**" |
| 0x3 | **PAT** | Patient（受影响者） | 因行为而状态改变的对象 | "**玻璃**碎了" |
| 0x4 | **RCP** | Recipient（接受者） | 接收某物的对象 | "给了**小红**一本书" |
| 0x5 | **BNF** | Beneficiary（受益者） | 从行为中获益的对象 | "**为孩子**做的" |

### 工具/方式（Instruments & Means）

| ID | 代码 | 角色 | 定义 | 示例 |
|----|------|------|------|------|
| 0x6 | **INS** | Instrument（工具） | 执行行为所使用的工具 | "用**锤子**钉钉子" |
| 0x7 | **MNR** | Manner（方式） | 行为执行的方式 | "**快速地**跑了" |

### 空间/移动（Spatial）

| ID | 代码 | 角色 | 定义 | 示例 |
|----|------|------|------|------|
| 0x8 | **LOC** | Location（地点） | 事件发生的位置 | "在**北京**生活" |
| 0x9 | **SRC** | Source（出发点） | 移动的起点 | "从**家里**出发" |
| 0xA | **DST** | Destination（目的地） | 移动的终点 | "去了**学校**" |
| 0xB | **PTH** | Path（路径） | 移动的途经地 | "**经过公园**走了" |

### 原因/目的（Causal）

| ID | 代码 | 角色 | 定义 | 示例 |
|----|------|------|------|------|
| 0xC | **CAU** | Cause（原因） | 事件的原因 | "**因为下雨**取消了" |
| 0xD | **PRP** | Purpose（目的） | 行为的目的 | "**去锻炼**了" |

### 其他（Others）

| ID | 代码 | 角色 | 定义 | 示例 |
|----|------|------|------|------|
| 0xE | **COM** | Comitative（伴随） | 共同参与的对象 | "**和朋友**一起去了" |
| 0xF | **ATR** | Attribute（属性） | 状态/属性描述 | "天空**很蓝**" |

## Participant Edge 结构

```
PARTICIPANT Edge {
    source:     Event SIDX       // 动词节点
    target:     Entity SIDX      // 实体节点
    role:       4-bit            // 语义角色 (0x0~0xF)
    gram_role:  2-bit (optional) // 语法角色 (主语/宾语/补语)
    focus:      4-bit (optional) // 强调度 (0~15 → 0.0~1.0)
    quant_ref:  TID (optional)   // 限定符引用
}
```

| 字段 | 位 | 说明 |
|------|------|------|
| role | 4 | 语义角色（必需） |
| gram_role | 2 | 0=未指定, 1=主语, 2=宾语, 3=补语 |
| focus | 4 | 信息重要度（0=背景, 15=核心强调） |
| quant_ref | 16 | "所有"、"大部分"等限定符 TID |

## Theme vs Patient

| 角色 | 状态变化 | 示例 |
|------|----------|------|
| Theme | 无（移动/描述） | "**扔**了球"（球无变化） |
| Patient | 有（受影响） | "**打碎**了玻璃"（玻璃状态改变） |

实际应用中可统一为 Theme，需要时通过动词语义区分。

## 示例

### 简单句："小明把书给了小红"

```
Event: give.v.01
├─ PARTICIPANT (AGT) → 小明
├─ PARTICIPANT (THM) → 书
└─ PARTICIPANT (RCP) → 小红
```

### 复合句："因为下雨，和朋友一起从家里快速跑到了学校"

```
Event: run.v.01
├─ PARTICIPANT (AGT) → [说话人]
├─ PARTICIPANT (CAU) → 雨
├─ PARTICIPANT (COM) → 朋友
├─ PARTICIPANT (SRC) → 家
├─ PARTICIPANT (DST) → 学校
└─ PARTICIPANT (MNR) → 快速
```

### 状态描述："天空非常蓝"

```
Event: be.v.01
├─ PARTICIPANT (THM) → 天空
└─ PARTICIPANT (ATR) → 蓝 (focus=15)
```

## 主动/被动归一化

| 表面形式 | Agent | Theme |
|--------|-------|-------|
| "Apple收购了Tesla" | Apple | Tesla |
| "Tesla被Apple收购了" | Apple | Tesla |

在解析阶段进行归一化，以相同模式处理。
