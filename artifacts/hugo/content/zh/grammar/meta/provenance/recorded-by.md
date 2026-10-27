---
title: "RECORDED-BY"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-BY 是以 Reference 记录将文档记录下来之主体的出处 Meta（git committer）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录将文档记录下来的主体（git committer）。

## 布局

```
TAG WORD          0001 1LLL L010 0100      Codec 0x24
[Length 扩展 TAG]
Payload           一个 Reference 记录 (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL 等)
```

- Codec：Meta `0x24`，出处类（`010`）
- Payload：内置 Reference
- 数量：至多一个

## 解读与有效性

- Reference 不限 Codec。人、组织、模型、规则引擎均可（[EXTERNAL-ISSUER](/zh/grammar/reference/external-issuer/)、[GEUL](/zh/grammar/reference/geul/)、[WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/)、[LOCAL](/zh/grammar/reference/local/) 等）。
- geul.org 公布的文档中不放置指向自然人的 Reference（[Issuer 与公布](/zh/grammar/issuer/#geulorg-公布)）。指向组织·Issuer。例外是允许用 [WIKIDATA-QID](/zh/grammar/reference/wikidata-qid/) 指向自然人。
- 若为 LOCAL，则在 BODY 中叙述该目标。
