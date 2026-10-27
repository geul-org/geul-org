---
title: "TRANSFORMED-BY"
weight: 52
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "TRANSFORMED-BY 是记录从其他表示转换为本文档的工具及其源码版本（提交摘要）的谱系 Meta。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

记录从其他表示转换为本文档的方法（例：Wikidata 转换器、自然语言编码器）。Tool 是用什么转换的，Version 是用该工具的哪份源码转换的。两者齐备，才能从同样的输入重新生成同样的文档。

## 布局

```
TAG WORD          0001 1LLL L011 0011      Codec 0x33
[Length 扩展 TAG]
Tool              Reference 记录 1 个 (转换工具·规则)
Version           Value 记录 1 个 (SHA-256-DIGEST 或 SHA1-DIGEST)
```

- Codec：Meta `0x33`，谱系类（`011`）
- Payload：内置 Reference（工具）+ 内置 Value（源码版本摘要）
- 数量：可有多个（每个工具一个）

## 解读与有效性

- Tool 恰好是一个完整的 Reference 记录。任何指向工具的 Reference 都可使用。
  - geul.org 工具文档中的工具：[EXTERNAL-ISSUER](/zh/grammar/reference/external-issuer/)（`0x0000`，文档 ID `0x0001xxxx xxxxxxxx`，及其 LOCAL）。一个工具对应一个文档（[Issuer](/zh/grammar/issuer/) 术语定义文档）。
  - 若 Codec 是 GEUL 文档，则用 [DOC-POINTER](/zh/grammar/reference/doc-pointer/) 指向该文档。
- Version 恰好是一个完整的 Value 记录，是 Tool 源码的版本管理对象 ID。若是 git，则是完整的提交对象 ID。
  - git 仓库的对象格式为 SHA-256 时用 [SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)（`0x61`，16 WORD），为 SHA-1 时用 [SHA1-DIGEST](/zh/grammar/value/binary/sha1-digest/)（`0x62`，10 WORD）。仓库格式用 `git rev-parse --show-object-format` 确认。
  - 不使用缩写 ID（`2bd496f` 等）。摘要 Value 不允许截断值。
  - 不用 hex 文本（UTF8-TEXT）书写。同一个值在 SHA-1 下是 22 WORD（二进制 11），在 SHA-256 下是 34 WORD（二进制 18）。
- Version 必填。不知道源码版本的工具记录无法作为复现的依据。若工具在版本管理之外，则使用发布物的 SHA-256（SHA-256-DIGEST）。
- Version 指向已提交的源码。用含有未提交变更的工作树生成的文档，不使用该提交 ID（建议工具拒绝运行）。
- 若工具依赖仓库之外的代码（例：用 Go `replace` 指向的本地库），则该代码也要用 TRANSFORMED-BY 另行记录。仅凭工具的提交 ID 无法确定那段代码。
- 仅把来源无损搬入的工具（例：把 dump 原样装载进 DB 的工具）不决定文档内容，所以不记录。非无损的装载会改变文档，因此要作为工具记录。
- geul.org 规范文档（`0x1833`）以 Tool（宽度 0，任意 Reference，故无 CODEC）与 Version（宽度 0，[CODEC](/zh/grammar/edge/codec/) `0861`·`0862`）两个记录字段来记录。

## 长度

```
总计 = 1 + N_len + N_tool + N_version WORD
```

- 读完最后一条记录后的游标必须与 Meta 末尾恰好吻合。
- Tool 为 EXTERNAL-ISSUER-1WORD（7 WORD）、Version 为 SHA1-DIGEST（11 WORD）时，总计 1 + 1 + 7 + 11 = 20 WORD，使用扩展长度。若为 SHA-256-DIGEST（18 WORD）则为 27 WORD。

## 示例

非规范示例。工具是 geul.org 工具文档 `0x0001000000000001` 的 LOCAL 2（`0360 0000 0001 0000 0000 0001 0002`），源码是提交 `ddc0719974a32aaa7b422ee84221a9721085ce4c`（SHA-1）。

```
1F33 0014
0360 0000 0001 0000 0000 0001 0002
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## 未决问题

- [GENERATED-BY](/zh/grammar/meta/lineage/generated-by/) 的版本是否也改用同样的方式（必填摘要或其他格式）。模型版本不是提交 ID。

## 相关页面

- [Meta](/zh/grammar/meta/)、[GENERATED-BY](/zh/grammar/meta/lineage/generated-by/)、[DERIVED-FROM](/zh/grammar/meta/lineage/derived-from/)
- [EXTERNAL-ISSUER](/zh/grammar/reference/external-issuer/)、[DOC-POINTER](/zh/grammar/reference/doc-pointer/)、[SHA-256-DIGEST](/zh/grammar/value/binary/sha-256-digest/)、[SHA1-DIGEST](/zh/grammar/value/binary/sha1-digest/)、[CODEC](/zh/grammar/edge/codec/)
