---
title: "代码仓库"
date: 2026-02-28T12:00:00+09:00
summary: "构成GEUL项目的GitHub仓库列表。语言规范、文法码本、搜索、DSL与网站。"
image: "/images/og-default.webp"
---

所有仓库均位于[geul-org](https://github.com/geul-org) GitHub组织下。

---

## 语言

### geul

面向AI的语义对齐人工语言与二进制流格式。

为人类与AI之间的无歧义沟通而设计的2字节（65,536种）语言体系。每条陈述都附带来源、时间戳和置信度，每个实体都有唯一标识符。流格式以16位为单位，在10位前缀体系下定义了10种数据包类型（Verb Edge、Entity Node、Triple Edge等）。

| | |
|---|---|
| GitHub | [geul-org/geul](https://github.com/geul-org/geul) |
| 语言 | Go, Python |
| 许可证 | MIT |

---

## 文法

### geul-verb

动词SIDX 16位码本（基于WordNet）。

将WordNet动词同义词集映射为16位代码，用于GEUL Verb Edge数据包。提供流格式所使用的动词词汇。

| | |
|---|---|
| GitHub | [geul-org/geul-verb](https://github.com/geul-org/geul-verb) |
| 语言 | Python |
| 许可证 | MIT |

### geul-entity

实体SIDX 48位码本（基于Wikidata）。

将Wikidata实体编码为48位结构化标识符。定义实体类型，设计每种类型的属性模式，并构建SILK所使用的码本。

| | |
|---|---|
| GitHub | [geul-org/geul-entity](https://github.com/geul-org/geul-entity) |
| 语言 | Python |
| 许可证 | MIT |

### geul-quantities

数量节点码本。

定义GEUL Quantity Node数据包中使用的数量值编码方案——带单位的数字、范围和精度。

| | |
|---|---|
| GitHub | [geul-org/geul-quantities](https://github.com/geul-org/geul-quantities) |
| 语言 | Python |
| 许可证 | MIT |

### geul-ast

AST边码本。

定义抽象语法树边的编码方案，使GEUL流格式内的结构化代码表示成为可能。

| | |
|---|---|
| GitHub | [geul-org/geul-ast](https://github.com/geul-org/geul-ast) |
| 语言 | Python |
| 许可证 | MIT |

---

## 搜索

### silk

SILK（Symbolic Index for LLM Knowledge）——神经符号搜索架构。

用64位整数进行搜索。不需要向量数据库、ANN图或嵌入模型。一行NumPy位与运算即可搜索1亿条记录，核心主张是：仅用Python就能超越优化过的C++/Rust向量搜索。提供结合码本查找与LLM辅助的混合查询管线。

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| 语言 | Python |
| 许可证 | MIT |

---

## DSL

### ssac

Service Sequences as Code——从Go注释中解析声明式服务逻辑，通过CLI生成Go实现代码。

在Go源文件中以结构化注释定义服务流程。CLI读取这些声明并生成相应的实现代码，消除样板代码，同时保持逻辑的可读性和版本控制。

| | |
|---|---|
| GitHub | [geul-org/ssac](https://github.com/geul-org/ssac) |
| 语言 | Go |
| 许可证 | MIT |

### stml

SSOT Template Markup Language——用HTML5 data-*属性声明式绑定UI与API，对OpenAPI进行符号验证，并生成React代码。

用HTML5 data属性将UI模板绑定到API模式。构建时对OpenAPI规范进行符号验证，然后生成类型安全的React组件。从模式到界面的单一事实来源。

| | |
|---|---|
| GitHub | [geul-org/stml](https://github.com/geul-org/stml) |
| 语言 | TypeScript |
| 许可证 | MIT |

---

## 网站

### geul-org

本网站的源代码。

使用Hugo静态网站生成器，支持12种语言。通过S3 + CloudFront部署，使用CloudFront Function处理语言检测和简洁URL。

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| 语言 | Hugo (Go Templates), CSS |
| 许可证 | MIT |
