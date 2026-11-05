---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "以 IMPORT ID 引入外部文档。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `IMPORT-DOC`（规格文档 BIND `IMPORT-DOC`） |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| 规格文档 | `0x00000000/codecs/0x00001E40/`（DECLARE 对象 `1E40`） |
| 章节 | 15 `1111`（Meta），章节内偏移 C = 4 |
| Kind | Meta · 类：IMPORT |
| TAG WORD | `0001 1110 0100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 以 IMPORT ID 引入外部文档。内置 Reference `DOC-POINTER`（Codec 文档为 `CODEC-POINTER`）+ IMPORT ID |
| Hugo 侧 | `meta/import/import-doc.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | 记录 | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | 剩余原始值（`0xFFFF`） |  |  |

以 IMPORT ID 引入外部文档。要引入的文档由 [DOC-POINTER](../reference/0x041L-doc-pointer.md) 指向，Issuer 宽度也由 DOC-POINTER 携带。

## 布局 {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[Length 扩展 TAG]
文档              DOC-POINTER Reference 记录 (Issuer, 文档 ID, 版本 ID。版本 0 表示最新)。Codec 文档为 CODEC-POINTER
IMPORT ID         其余全部。最短宽度的 unsigned
```

- Codec：Meta `0x1E4L`，IMPORT 类
- Payload：内置 Reference `DOC-POINTER`（Issuer、文档 ID、版本 ID）+ IMPORT ID 原始值
- 数量：可有多个（每个 IMPORT ID 一个）

## 解释与有效性 {#해석과-유효성}

- 文档恰好是一个 DOC-POINTER 记录。引入 Codec 文档时，则是 [CODEC-POINTER](../reference/0x042L-codec-pointer.md)（Issuer、Codec ID、版本 ID）记录。它以自身的 Length 结束，其余部分是 IMPORT ID。
- IMPORT ID 为 1 WORD 以上，取最短宽度。IMPORT ID 的宽度在这里由记录长度决定，在 [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) 中由 Codec 决定。
- 同一文档中不会两次分配相同的 IMPORT ID。
- 写了版本 ID 则绑定到该版本；为 `0` 则绑定到解释时点的最新版本（或指定时点正在施行的版本）（[修订](../document.md#개정)）。
- BODY 中的 [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) 指向通过 IMPORT ID 引入的文档的 LOCAL。被引入的文档本身用 DOC-POINTER 指向。
- 不引入被引入文档的 HEAD。该文档的对象按该文档自身的声明来解释。
- 不能凭 IMPORT ID 跨文档检索。装载多个文档的存储库要把 IMPORT ID 展开为完整路径（Issuer、文档 ID、版本 ID、LOCAL ID）后存储。

## 示例 {#예시}

- IMPORT ID 1，Issuer `0x00000002`，文档 `0x…0002`，最新：`1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001`（Meta TAG 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD）

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001E40/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
