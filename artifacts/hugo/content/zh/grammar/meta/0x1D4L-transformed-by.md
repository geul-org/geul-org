---
title: "TRANSFORMED-BY (0x1D4L)"
weight: 468
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "记录从其他表示转换为本文档的方法（例：Wikidata 转换器、自然语言编码器）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `TRANSFORMED-BY`（规格文档 BIND `TRANSFORMED-BY`） |
| TAG ID | `0x1D4L` |
| Codec ID | `0x00001D40` |
| 规格文档 | `0x00000000/codecs/0x00001D40/`（DECLARE 对象 `1D40`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 20 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 0100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 转换方法。工具、规则、版本 |
| Hugo 侧 | `meta/lineage/transformed-by.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `tool` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `version` | #3 | 记录 | `07C0` SHA-256-DIGEST, `07D0` SHA1-DIGEST |  |

记录从其他表示转换为本文档的方法（例：Wikidata 转换器、自然语言编码器）。Tool 表示用什么转换的，Version 表示用该工具的哪一版源码转换的。两者齐备，才能从同一输入重新生成同一文档。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 0100 LLLL      Codec 0x1D4L
[Length 扩展 TAG]
Tool              1 个 Reference 记录（转换工具、规则）
Version           1 个 Value 记录（SHA-256-DIGEST 或 SHA1-DIGEST）
```

- Codec：Meta `0x1D4L`，谱系类
- Payload：内置 Reference（工具）+ 内置 Value（源码版本摘要）
- 数量：可有多个（每个工具一个）

## 解释与有效性 {#해석과-유효성}

- Tool 恰好是一个完整的 Reference 记录。任何指向工具的 Reference 都可以使用。
  - geul.org 工具文档中的工具：[EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md)（`0x00000000`，文档 ID `0x0001xxxx xxxxxxxx`，其 LOCAL）。一个工具对应一个文档（[Issuer](../issuer.md) 术语定义文档）。
  - 若 Codec 是 GEUL 文档，则用 [CODEC-POINTER](../reference/0x042L-codec-pointer.md) 指向该 Codec 文档。
- Version 恰好是一个完整的 Value 记录，是 Tool 源码的版本管理对象 ID。若是 git，则为提交对象 ID 的完整值。
  - git 仓库的对象格式为 SHA-256 时用 [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)（`0x07CL`，16 WORD），为 SHA-1 时用 [SHA1-DIGEST](../value/0x07DL-sha1-digest.md)（`0x07DL`，10 WORD）。仓库格式用 `git rev-parse --show-object-format` 确认。
  - 不使用缩写 ID（`2bd496f` 等）。摘要 Value 不允许截断的值。
  - 不用 hex 文本（UTF8-TEXT）书写。同一个值在 SHA-1 下占 22 WORD（二进制为 11），在 SHA-256 下占 34 WORD（二进制为 18）。
- Version 是必需的。不知道源码版本的工具记录，不能成为复现的依据。若是版本管理之外的工具，则使用发布物的 SHA-256（SHA-256-DIGEST）。
- Version 指向已提交的源码。用含有未提交更改的工作树生成的文档，不写该提交 ID（建议工具拒绝运行）。
- 若工具依赖仓库之外的代码（例：用 Go `replace` 指向的本地库），则该代码也要另用 TRANSFORMED-BY 记录。仅凭工具的提交 ID 无法确定那部分代码。
- 只是把来源无损搬运的工具（例：把转储原样装入数据库的工具）不决定文档内容，因此不记录。非无损的装载会改变文档，因此作为工具记录。
- geul.org 规格文档（`0x1D40`）用 Tool（宽度 0，可为任意 Reference，故无 CODEC）与 Version（宽度 0，[CODEC](../edge/0x0BEL-codec.md) `07C0`·`07D0`）两个记录字段来记述。

## 长度 {#길이}

```
总计 = 1 + N_len + N_tool + N_version WORD
```

- 读完最后一个记录后，游标必须恰好与 Meta 的末尾一致。
- 若 Tool 为 EXTERNAL-ISSUER-2WORD（8 WORD）且 Version 为 SHA1-DIGEST（11 WORD），则总计 1 + 1 + 8 + 11 = 21 WORD，使用扩展长度。若为 SHA-256-DIGEST（18 WORD），则为 28 WORD。

## 示例 {#예시}

非规范示例。工具是 geul.org 工具文档 `0x0001000000000001` 的 LOCAL 2（`02F7 0000 0000 0001 0000 0000 0001 0002`），源码是提交 `ddc0719974a32aaa7b422ee84221a9721085ce4c`（SHA-1）。

```
1D4E 0015
02F7 0000 0000 0001 0000 0000 0001 0002
07DA DDC0 7199 74A3 2AAA 7B42 2EE8 4221 A972 1085 CE4C
```

## 未决问题 {#열린-문제}

- 是否也把 [GENERATED-BY](0x1D3L-generated-by.md) 的版本改为同样的方式（必需的摘要或其他格式）。模型版本不是提交 ID。

## 相关页面 {#관련-페이지}

- [Meta](_index.md), [GENERATED-BY](0x1D3L-generated-by.md), [DERIVED-FROM](0x1D2L-derived-from.md)
- [EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [DOC-POINTER](../reference/0x041L-doc-pointer.md), [SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md), [SHA1-DIGEST](../value/0x07DL-sha1-digest.md), [CODEC](../edge/0x0BEL-codec.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001D40/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D4000000000
BODY
#1 DECLARE 0x1D40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "TRANSFORMED-BY"
#5 BIND #2 "tool"
#6 BIND #3 "version"
#7 CODEC #3 0x07C0
#8 CODEC #3 0x07D0
```
