---
title: "DOC-ID"
weight: 19
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DOC-ID 是以指向文档自身的 DOC-POINTER（Issuer、文档 ID、版本 0）声明文档标识符的定义 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

声明本文档的标识符。其他文档要指向本文档及其中的目标，就需要它。

## 布局

```
TAG WORD          0001 1LLL L001 0010      Codec 0x12
[Length 扩展 TAG]
文档              DOC-POINTER Reference 记录。(Issuer, 文档 ID, 版本 0)
```

- Codec：Meta `0x12`，定义类（`001`）
- Payload：一个内置 Reference [DOC-POINTER](/zh/grammar/reference/doc-pointer/)（Issuer、文档 ID、版本 0）
- 数量：至多一个。名称以 `0x` 开头的文档必须有

## 解读与有效性

- Payload 恰好是一个 `DOC-POINTER`（Issuer、文档 ID、版本 `0`）Reference 记录。版本 ID 只用 `0`。版本由版本列表分配，而不是由文档分配。Quantifier 为 `000`。
- 因此指向"本文档"的写法在 DOC-ID、`documents.geul` 的 [BIND](/zh/grammar/edge/bind/) Subject、其他文档的引用中都相同。
- 无论版本如何，同一文档的 `DOC-ID` 都相同。版本 ID 与内容哈希不写在文档里（[版本](/zh/grammar/document/#版本)）。
- 寻址名称由名称索引 `documents.geul` 的叙述性 `BIND` 负责（[公布地址与版本列表](/zh/grammar/publishing/#文档名称)），人可读的标题由叙述性 [LABEL](/zh/grammar/edge/label/) 负责。
- 没有它则为无名文档，只能通过内容哈希指向。其他文档若要用指示 Reference 指向本文档的 LOCAL，就需要它。
- 导入文档的一方要验证所收文档的 `DOC-ID` 是否与所请求的 Issuer 和文档 ID 一致。
- 文档 ID `0x0000000000000000` 是 Issuer 的术语定义索引文档（[Issuer](/zh/grammar/issuer/)）。该文档的名称同样以 `0x` 开头，所以也设置 DOC-ID（`DOC-POINTER`（Issuer、`0`、`0`））。Issuer 本身由 [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/) 代表。
- `.well-known/geul/` 下名称以 `0x` 开头的文档（版本文档 `<版本 ID>.geul`、规范文档）必须有 `DOC-ID`。
- 名称不以 `0x` 开头的文档作为例外不设 `DOC-ID`：版本列表 `versions.geul`（[PUBLICATION](/zh/grammar/edge/publication/)）、文档名称索引 `documents.geul`、Issuer 名称索引 `issuers.geul`（[公布地址与版本列表](/zh/grammar/publishing/)）。内容哈希存储库 `h/` 是上述文档的副本，遵循原件。
- Codec 规范文档是 GEUL Issuer `0x0000` 的文档。文档 ID 是把 Kind·Codec TAG WORD 扩展为 4 WORD 的值（`0x1018` → `0x0000000000001018`）。Reference `0000` 为保留，所以文档 ID 不会是 `0`（[规范文档](/zh/grammar/codec-spec/)）。

## 示例

- Issuer `0x0001`，文档 `0x…0005`：`1C12 03B8 0001 0000 0000 0000 0005 0000 0000`（Meta TAG 1 + Reference TAG 1 + Issuer 1 + 文档 ID 4 + 版本 2 = 9 WORD）
