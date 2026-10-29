---
title: "代码仓库"
date: 2026-02-28T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
summary: "GEUL的公开GitHub仓库列表。Go库与geul CLI、维基数据导入与转换、检索引擎SILK、v1之前的码本、网站。"
image: "/images/og-default.webp"
---

GEUL的公开仓库位于[geul-org](https://github.com/geul-org) GitHub组织下。文法规范以本站的[GEUL文法](/zh/grammar/)为准。

GEUL文档是16位WORD的序列。数据的单位是以一个TAG WORD开头的记录，记录装在一个文档中。文档由Issuer发布，每个版本由内容哈希固定。下面的仓库是编写、读取、转换和检索这些文档的工具。

---

## 库

### gogeul

GEUL Go库与`geul`命令行工具。

编写、读取、检查并发布GEUL文档（`.geul`）。以包的形式提供格式检查、借助Codec规格文档解码记录、版本差异、IMPORT依赖解析以及TOULMIN Codec。`geul` CLI涵盖文档编辑（`new`、`add`）、发布（`publish`）、浏览（`ls`、`log`、`show`、`diff`、`check`）、浏览器查看器（`serve`、`build`）和pack归档（`pack build`、`pack unpack`）。pack归档可以用zstd压缩存储记录。

| | |
|---|---|
| GitHub | [geul-org/gogeul](https://github.com/geul-org/gogeul) |
| 语言 | Go |
| 许可证 | CC0 |

---

## 维基数据

### wikigeul

维基数据 → GEUL转换（旧名gogeulwiki）。

读取由wikipg导入PostgreSQL的维基数据转储，为每个条目和属性发布一个GEUL文档，以所有语言收录标签、描述、别名、带限定符和参考来源的陈述以及站点链接。所有文档都在Issuer `wikidata.geul.org`（`0x00010000`）下发布。

| | |
|---|---|
| GitHub | [geul-org/wikigeul](https://github.com/geul-org/wikigeul) |
| 语言 | Go |
| 许可证 | CC0 |

### wikipg

将维基数据JSON转储无损导入PostgreSQL。

按转储顺序存储实体、标签、描述、别名、陈述、限定符、参考来源、站点链接和Lexeme，并原样保留转储的每一行。转储本身（文件、URL、大小、校验和、导入器提交）也会被记录。wikipg不依赖GEUL。

| | |
|---|---|
| GitHub | [geul-org/wikipg](https://github.com/geul-org/wikipg) |
| 语言 | Go |
| 许可证 | CC0 |

---

## 检索

### silk

[SILK](/zh/projects/silk/) — GEUL专用的索引与检索引擎。

为GEUL pack归档中的记录建立分区排序索引，无需解码全部文档即可回答"哪些文档陈述了某人的职业（P106）是物理学家（Q169470）？"这样的查询。它不依赖码本，仅凭TAG WORD划分记录及其字段。目前处于早期开发阶段，正在验证检索算法，首个版本发布前格式可能变化。

| | |
|---|---|
| GitHub | [geul-org/silk](https://github.com/geul-org/silk) |
| 语言 | Go |
| 许可证 | CC0 |

---

## 码本（v1之前）

下面两个仓库设计于现行v1文法之前，部分内容与现行文法不一致。

### sidx

SIDX（Semantic-aligned Index）分配研究。

研究如何根据维基数据使用统计分配SIDX——一种为语义相近的实体赋予相近编号的语义地址。其中包含旧的Entity 48位属性模式、编码脚本和码本，目前尚未产出SIDX分配结果。SIDX的规范定义是文法中的[GEUL-SIDX](/zh/grammar/reference/geul-sidx/)。

| | |
|---|---|
| GitHub | [geul-org/sidx](https://github.com/geul-org/sidx) |
| 语言 | Python |
| 许可证 | CC0 |

### wordnet-verb

基于WordNet 3.0的动词16位码本临时版。

为WordNet 3.0的13,767个动词synset各分配一个16位代码，语义相近的动词获得相近的代码。这是将被不使用WordNet的码本取代的临时版，代码如何装入GEUL记录尚未确定。

其中含有WordNet派生内容，因此**不是CC0产出物。** WordNet派生部分遵循WordNet 3.0 License，只有代码与分类等GEUL项目自有部分为CC0。

| | |
|---|---|
| GitHub | [geul-org/wordnet-verb](https://github.com/geul-org/wordnet-verb) |
| 语言 | Python |
| 许可证 | WordNet 3.0 License（派生部分）· CC0（自有部分） |

---

## 网站

### geul-org

本网站geul.org的源代码。

Hugo静态站点，支持12种语言，通过S3 + CloudFront部署。

| | |
|---|---|
| GitHub | [geul-org/geul-org](https://github.com/geul-org/geul-org) |
| 语言 | Hugo |
| 许可证 | CC0 |

---

## 相关仓库

geul-org组织之外的仓库。

### toulmin

基于图尔敏论证模型的规则引擎（TypeScript、Python、Go、C）。

规则是函数，例外是图中的攻击关系。GEUL文法的[TOULMIN](/zh/grammar/edge/toulmin/) Edge（直接代码`0x60`~`0x7B`）将这些判定与执行图写成GEUL文档。

| | |
|---|---|
| GitHub | [park-jun-woo/toulmin](https://github.com/park-jun-woo/toulmin) |
| 许可证 | MIT |
