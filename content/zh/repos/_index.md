---
title: "代码仓库"
date: 2026-02-28T12:00:00+09:00
summary: "构成GEUL项目的GitHub仓库列表。语言设计、编码管线、搜索引擎与网站。"
image: "/images/og-default.webp"
---

GEUL项目由四个仓库组成。

设计语言（geul），将世界的实体编码为64位（geul-sidx），在该索引上进行搜索（silk），并解释为什么这一切是必要的（geul-org）。

---

## geul

面向AI的语义对齐人工语言与二进制流格式。

为人类与AI之间的无歧义沟通而设计的2字节（65,536种）语言体系。每条陈述都附带来源、时间戳和置信度，每个实体都有唯一标识符。流格式以16位为单位，在10位前缀体系下定义了10种数据包类型（Verb Edge、Entity Node、Triple Edge等）。

| | |
|---|---|
| GitHub | [park-jun-woo/geul](https://github.com/park-jun-woo/geul) |
| 语言 | Go, Python |
| 许可证 | MIT |

---

## geul-sidx

SIDX（语义对齐索引）码本构建器与编码管线。

将1.088亿个Wikidata实体编码为64位结构化标识符。定义63种实体类型，设计每种类型的48位属性模式，构建码本，并验证编码结果（VALID）。是SILK所使用的索引和码本的生产者。

| | |
|---|---|
| GitHub | [park-jun-woo/geul-sidx](https://github.com/park-jun-woo/geul-sidx) |
| 语言 | Python |
| 许可证 | MIT |

---

## silk

SILK（Symbolic Index for LLM Knowledge）——神经符号搜索架构。

用64位整数进行搜索。不需要向量数据库、ANN图或嵌入模型。一行NumPy位与运算即可搜索1亿条记录，核心主张是：仅用Python就能超越优化过的C++/Rust向量搜索。提供结合码本查找与LLM辅助的混合查询管线。

| | |
|---|---|
| GitHub | [park-jun-woo/silk](https://github.com/park-jun-woo/silk) |
| 语言 | Python |
| 许可证 | MIT |

---

## geul-org

本网站的源代码。

使用Hugo静态网站生成器，支持12种语言。通过S3 + CloudFront部署，使用CloudFront Function处理语言检测和简洁URL。

| | |
|---|---|
| GitHub | [park-jun-woo/geul-org](https://github.com/park-jun-woo/geul-org) |
| 语言 | Hugo (Go Templates), CSS |
| 许可证 | MIT |
