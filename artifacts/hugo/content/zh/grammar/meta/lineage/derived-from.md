---
title: "DERIVED-FROM"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DERIVED-FROM 是记录本文档所派生自的其他谱系文档·资料的谱系 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录本文档派生自其他谱系的文档·资料。

## 布局

```
TAG WORD          0001 1LLL L011 0001      Codec 0x31
[Length 扩展 TAG]
Payload           Reference，或 SHA-256-DIGEST（内容哈希），或 URI Value
```

- Codec：Meta `0x31`，谱系类（`011`）
- Payload：内置 Reference 或 Value
- 数量：可有多个

## 解读与有效性

- 若派生自 GEUL 文档，则放其内容哈希（[SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)）；若是外部资料，则放 [URI](/zh/grammar/value/text/uri/)。若要用哈希固定外部资料的版本，则在 HEAD 的 [SOURCE](/zh/grammar/edge/source/#整个文档的来源) 上附加原文哈希 QUALIFIER（P4092）。
- 记录级别的来源由依据 Edge [SOURCE](/zh/grammar/edge/source/) 负责，移动·拆分·合并之前的旧记录由目标 Edge 的 QUALIFIER P1365（值为旧 Edge Id）负责。
