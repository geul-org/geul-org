---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC 是以 DOC-POINTER 指向外部文档并分配 IMPORT ID 的 IMPORT Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

以 IMPORT ID 导入外部文档。要导入的文档由 [DOC-POINTER](/zh/grammar/reference/doc-pointer/) 指向，Issuer 宽度也由 DOC-POINTER 携带。

## 布局

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length 扩展 TAG]
文档              DOC-POINTER Reference 记录 (Issuer, 文档 ID, 版本 ID。版本为 0 则为最新)
IMPORT ID         其余全部。最短宽度的 unsigned
```

- Codec：Meta `0x60`，IMPORT 类（`110`）
- Payload：内置 Reference `DOC-POINTER`（Issuer、文档 ID、版本 ID）+ IMPORT ID 原始值
- 数量：可有多个（每个 IMPORT ID 一个）

## 解读与有效性

- 文档部分恰好是一个 DOC-POINTER 记录。它以自身 Length 结束，其余是 IMPORT ID。
- IMPORT ID 至少 1 WORD，取最短宽度。IMPORT ID 的宽度在此由记录长度决定，在 [EXTERNAL-POINTER-*](/zh/grammar/reference/external-pointer/) 中由 Codec 决定。IMPORT ID 只在该文档内有效。
- 同一文档中不要两次分配相同的 IMPORT ID。
- 写明版本 ID 则绑定到该版本，为 `0` 则绑定到解读时刻的最新版本（或所指定时点施行中的版本）（[修订](/zh/grammar/document/#修订)）。
- BODY 中的 [EXTERNAL-POINTER-*](/zh/grammar/reference/external-pointer/) 通过 IMPORT ID 指向被导入文档的 LOCAL。被导入文档本身用 DOC-POINTER 指向。
- 不导入被导入文档的 HEAD。该文档的目标按该文档自身的声明解读。
- 无法凭 IMPORT ID 跨文档检索。装载多个文档的仓库要把 IMPORT ID 展开为完整路径（Issuer、文档 ID、版本 ID、LOCAL ID）后存储。

## 示例

- IMPORT ID 1，Issuer `0x0001`，文档 `0x…0002`，最新：`1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001`（Meta TAG 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD）
