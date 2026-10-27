---
title: "TAG"
weight: 58
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TAG 是记录附在版本上的不可变名称的谱系 Meta（git annotated tag）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录附在版本上的不可变名称（git annotated tag）。

## 布局

```
TAG WORD          0001 1LLL L011 1001      Codec 0x39
[Length 扩展 TAG]
名称              UTF8-TEXT-* Value
目标              SHA-256-DIGEST Value，或省略标记 0x0000 (可选字段)。省略则为本版本
```

- Codec：Meta `0x39`，谱系类（`011`）
- Payload：内置 Value（文本 + 可选的内容哈希）
- 数量：可有多个

## 解读与有效性

- 名称是 [UTF8-TEXT](/zh/grammar/value/text/utf8-text/)，目标是 [SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)。
- 省略目标（ABSENT `0x0000`，[CODEC](/zh/grammar/edge/codec/) 可选字段）则是附在本文档自身上的名称。自身的内容哈希无法写在自身之内。geul.org 规范 `0x1839` 是 name（`0840`·`0841`）与 target（`0861`·`0000`）两个记录字段。
- 同一名称不再用于其他版本。

## 示例

- 名称 `v1`，本版本：`19B9 08C0 7631 0000`

## 未决问题

- 既已有版本 ID（序号），是否仍需要 TAG；以及它与文档名称（`BIND`）的职责划分。
