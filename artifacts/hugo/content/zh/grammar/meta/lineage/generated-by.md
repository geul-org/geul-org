---
title: "GENERATED-BY"
weight: 51
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "GENERATED-BY 是记录生成文档的主体（人、模型、规则引擎）及其版本的谱系 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录生成文档的主体。人、模型、规则引擎均可。

## 布局

```
TAG WORD          0001 1LLL L011 0010      Codec 0x32
[Length 扩展 TAG]
生成主体          Reference (人, 模型, 规则引擎)
版本              UTF8-TEXT Value，或省略标记 0x0000 (可选字段)
```

- Codec：Meta `0x32`，谱系类（`011`）
- Payload：内置 Reference + 版本文本（可选）
- 数量：可有多个

## 解读与有效性

- 若是模型，则一并记录模型版本。
- 不知道版本或不放版本时，省略该位置，写 ABSENT（`0x0000`）（[CODEC](/zh/grammar/edge/codec/) 可选字段）。geul.org 规范 `0x1832` 是 agent（无 CODEC）与 version（`0840`·`0841`·`0000`）两个记录字段。
- 程序的源码版本（提交）用 [TRANSFORMED-BY](/zh/grammar/meta/lineage/transformed-by/) 的格式（摘要，必填）更准确。GENERATED-BY 的版本以文本记录模型名称·版本这类不是提交 ID 的内容。
- geul.org 公布的文档中不放置指向自然人的 Reference（[Issuer 与公布](/zh/grammar/issuer/#geulorg-公布)）。指向组织·Issuer。例外是允许用 [WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/) 指向自然人。
