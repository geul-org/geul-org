---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX 是用在比特本身承载语义的 GEUL SIDX（Semantic-aligned Index）指向目标的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-SIDX 是用 GEUL SIDX（Semantic-aligned Index）指向目标的声明 Reference。SIDX 是在比特本身承载语义（种类、属性）的标识符。

## 布局

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[Length 扩展 TAG]
SIDX              其余全部
```

- Quantifier 与其他声明 Codec 相同。如果是 Variable，则是该种类的匿名变量（[Reference](/zh/grammar/reference/) Variable）。量化只用 `QQQ` 来做。SIDX 值中不放量化。
- 规格文档把 SIDX 声明为一个其余宽度的原始值字段。宽度规则确定后再改。

## 示例

| SIDX | WORD sequence |
|---|---|
| （非规范）64 位 `0x1234 5678 9abc def0`，Identified | `0218 1234 5678 9abc def0` |

## 分配方针

- 与 [GEUL](/zh/grammar/reference/geul/) 的角色不同。GEUL 是大体按顺序（auto increment）分配的身份 ID，GEUL-SIDX 是给语义相近的目标分配相近的值的语义地址。
- 相近程度通过积累使用数据，由统计来确定。在统计积累之前使用 GEUL ID，分配 SIDX 之后，用 [SAME-NODE](/zh/grammar/edge/same-node/) 连接同一目标的 GEUL 和 GEUL-SIDX。

## 未决问题

- **宽度。** 看统计后确定。正在研究 4 WORD（64 位）和 16 WORD 等。SIDX 的高位承载语义，所以不能原样使用其他声明 Codec 的"最短宽度"规则（禁止前导 `0x0000`）。因此将是固定宽度（或按子格式的固定宽度）。在确定之前，规格文档把 SIDX 声明为其余宽度的原始值。
- **分配的稳定性。** Reference 的整数值相同则目标相同，且不重复使用已分配的 ID。要做到即使统计变化也不移动已分配的 SIDX，需要 append-only 分配（预留语义相近位置的稀疏分配）。如果需要经常移动，则决定是否把 SIDX 定义为绑定到注册表版本的索引，而不是永久标识符。
- **唯一性。** 如果 SIDX 由比特语义生成而可能冲突，就与"整数值相同则目标相同"的前提不符。分配时消除冲突以保证唯一性。
- codebook 与注册表的公开格式。

## 相关页面

- [Reference](/zh/grammar/reference/)、[GEUL](/zh/grammar/reference/geul/)
