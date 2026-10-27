---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM 是给原始值字段的一个码值赋予含义的叙述 Edge（Codec 0x1D）。名称用 BIND 绑定。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM 是给原始值字段的一个码值赋予含义的叙述 Edge。Codec `0x1D`。

它与 [FIELD](/zh/grammar/edge/field/) 一起是书写 Codec 规格的词汇。布局内置于解码器（[Codec 规格文档](/zh/grammar/codec-spec/)）。

## 布局

```
TAG WORD          0001 0LLL L001 1101
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
字段              指向 FIELD Edge 的 LOCAL Reference 记录
码值              原始值。与该 FIELD 宽度相同的 WORD 数
```

## 解读与有效性

- 字段必须是原始值 FIELD（宽度 `n ≥ 1`）。不给记录字段附加 ENUM。记录的含义由该记录的 Codec 来说明。
- 码值恰好是该 FIELD 的宽度。用 ENUM 记录的 Length 确认边界。
- 一个字段中不对同一码值声明两次。
- 码值的名称用 [BIND](/zh/grammar/edge/bind/) 绑定到 ENUM 的 Edge Id。附加在 DECLARE·FIELD·ENUM·CODEC 上的 UTF8-TEXT 全部用 BIND，不用 LABEL 等其他 Edge 附加。
- 未声明的码值不是错误。查看器照原始值显示。是否封闭允许值是 Codec 规格的事，目前的词汇中没有封闭的标记。

## 长度

```
总计 = 1 + N_len + N_id + N_field + n WORD
```

## 示例（非规范）

在 TOMBSTONE 规格文档的原因类别字段（FIELD #4，原始值 1 WORD）中声明码 `0x0001`。Edge Id 10。名称另用 BIND 绑定。原因类别码表尚未确定，所以码值只是示例。

- TAG 1 + Edge Id 2 + 字段 2 + 码值 1 = 6 WORD，`LLLL = 0101`。

```
129D 0088 000A 0088 0004 0001
```

TRIPLE 规格文档在 Rank 字段（FIELD #5）上放三个 ENUM（`0`·`1`·`2`），分别用 BIND 绑定为 `normal`·`preferred`·`deprecated`（[TRIPLE](/zh/grammar/edge/triple/)）。

## 相关页面

- [DECLARE](/zh/grammar/edge/declare/)、[FIELD](/zh/grammar/edge/field/)、[CODEC](/zh/grammar/edge/codec/)、[BIND](/zh/grammar/edge/bind/)
- [Codec 规格文档](/zh/grammar/codec-spec/)
