---
title: "DOC"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD·DOC-2WORD·DOC-4WORD 是通过指定文档总 WORD 数来开启文档的结构 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

开启文档的记录。在 Payload 中指定文档的总 WORD 数。本页一并介绍 `DOC-1WORD`（`0x00`）、`DOC-2WORD`（`0x01`）、`DOC-4WORD`（`0x02`）。

## 布局

```
TAG WORD          0001 1LLL L000 0000      Codec 0x00
[Length 扩展 TAG]
Payload           总 WORD 数。宽度由 Codec 决定：DOC-1WORD 1，DOC-2WORD 2，DOC-4WORD 4
```

- Codec：Meta `0x00`~`0x02`，结构类（`000`）
- Payload：原始值（文档总 WORD 数，unsigned）
- 数量：每个文档一个，位于最前

## 解读与有效性

- 长度从开启记录的起点算到 [END](/zh/grammar/meta/structure/end/) 的终点。
- 使用能容纳该值的最窄宽度。用更宽的宽度编码属于非规范编码，予以拒绝。
- 长度必须等于整个输入。一个文档就是一个输入。
- 解码器可凭此长度跳过整个文档。不存在不知道长度就开启的 Codec。
- 计算内容哈希时，去掉验证类 Meta 后按相应长度和对应宽度重写（[内容哈希](/zh/grammar/document/#内容哈希)）。

## 示例

- `0x1880 0x0017`：DOC-1WORD，总计 23 WORD
