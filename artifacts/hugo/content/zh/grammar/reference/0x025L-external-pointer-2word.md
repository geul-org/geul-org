---
title: "EXTERNAL-POINTER-2WORD (0x025L~0x029L)"
weight: 37
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-POINTER 是指向由 HEAD 的 IMPORT-DOC 引入的文档中 LOCAL ID 的指示 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-POINTER 是指向由 HEAD 的 IMPORT-DOC 引入的文档中 LOCAL ID 的指示 Reference。

| 项目 | 值 |
|---|---|
| 名称 | `EXTERNAL-POINTER-2WORD`（5Q 分组。各代码的名称见下方成员表） |
| TAG ID | `0x025L~0x029L` |
| 章节 | 1 `0001`（Reference EXTERNAL），章节内偏移 C = 5~9 |
| Kind | Reference · 分类：指示 |
| Hugo 侧 | `reference/external-pointer.md`（该页还一并讲述[EXTERNAL-POINTER-1WORD](0x020L-external-pointer-1word.md)、[EXTERNAL-POINTER-4WORD](0x02AL-external-pointer-4word.md)） |

## 成员 {#구성원}

本页合并讲述一套 5Q 体系的五个代码。量化由章节内偏移 `C % 5` 决定（[Reference](_index.md#quantifier)）。每个代码各有一份 Codec 文档。五份 Codec 文档的字段相同，只有 DECLARE 目标和名称（BIND）不同。

| TAG ID | 名称 | 量化 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x025L` | `EXTERNAL-POINTER-2WORD-IDENTIFIED` | Identified | `0x00000250` | `0x00000000/codecs/0x00000250/` | `0000 0010 0101 LLLL` |
| `0x026L` | `EXTERNAL-POINTER-2WORD-GENERIC` | Generic | `0x00000260` | `0x00000000/codecs/0x00000260/` | `0000 0010 0110 LLLL` |
| `0x027L` | `EXTERNAL-POINTER-2WORD-FREE-CHOICE` | Free-choice | `0x00000270` | `0x00000000/codecs/0x00000270/` | `0000 0010 0111 LLLL` |
| `0x028L` | `EXTERNAL-POINTER-2WORD-UNIVERSAL` | Universal | `0x00000280` | `0x00000000/codecs/0x00000280/` | `0000 0010 1000 LLLL` |
| `0x029L` | `EXTERNAL-POINTER-2WORD-VARIABLE` | Variable | `0x00000290` | `0x00000000/codecs/0x00000290/` | `0000 0010 1001 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `import-id` | #2 | 原始值 2 WORD |  |  |
| 2 | `target-id` | #3 | 剩余原始值（`0xFFFF`） |  |  |

EXTERNAL-POINTER 是指向由 HEAD 的 [IMPORT-DOC](../meta/0x1E4L-import-doc.md) 引入的文档中 LOCAL ID 的指示 Reference。

## 布局 {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x020L~0x02EL (章节 1)
[Length 扩展 TAG]
IMPORT ID         由 Codec 决定的宽度 (1/2/4 WORD)
目标 ID           其余全部。引入文档的 LOCAL ID，最短宽度
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | 名称 | IMPORT ID 宽度 |
|---|---|---|
| `0x020L~0x024L` | EXTERNAL-POINTER-1WORD | 1 WORD |
| `0x025L~0x029L` | EXTERNAL-POINTER-2WORD | 2 WORD |
| `0x02AL~0x02EL` | EXTERNAL-POINTER-4WORD | 4 WORD |

- 宽度由体系编号决定：体系 − 6（章节内偏移 `C` 的 `C / 5`）为 0、1、2 时，分别是 1、2、4 WORD。量化为 `C % 5`。

- 使用能容纳 IMPORT ID 值的最窄 Codec。
- IMPORT ID 是本文档的 `IMPORT-DOC` 所分配的值。EXTERNAL-POINTER 中不写 Issuer。Issuer 和文档 ID 从该 `IMPORT-DOC` 获得。版本也由该 `IMPORT-DOC` 决定（固定或最新）。
- 引入文档中同一个 LOCAL ID，无论在该文档内写作 LOCAL，还是在这里写作 EXTERNAL-POINTER，都是同一对象。
- 为 Variable 时，是引入文档的 LOCAL 变量。

## 有效性 {#유효성}

- 本文档中没有分配该 IMPORT ID 的 `IMPORT-DOC` 时，为 invalid。
- IMPORT ID 能放入更窄的 Codec 却使用了更宽的 Codec，则作为 non-minimal 拒绝。
- 目标 ID 为 `0` 时为 invalid。引入文档本身用 [DOC-POINTER](0x041L-doc-pointer.md) 指向。
- 禁止目标 ID 带有前导 `0x0000` WORD。

## 示例 {#예시}

| 目标 | WORD sequence |
|---|---|
| IMPORT ID 1 的 LOCAL 5 | `0202 0001 0005` |
| IMPORT ID 1 的 LOCAL 65536 | `0203 0001 0001 0000` |
| IMPORT ID 70000 的 LOCAL 5 | `0253 0001 1170 0005` |

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[LOCAL](0x005L-local.md)、[EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)、[DOC-POINTER](0x041L-doc-pointer.md)
- [IMPORT-DOC](../meta/0x1E4L-import-doc.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000250/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000025000000000
BODY
#1 DECLARE 0x0250
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "EXTERNAL-POINTER-2WORD-IDENTIFIED"
#5 BIND #2 "import-id"
#6 BIND #3 "target-id"
```

以上是 `EXTERNAL-POINTER-2WORD-IDENTIFIED`（`0x025L`）的 Codec 文档。其他成员（`EXTERNAL-POINTER-2WORD-GENERIC`、`EXTERNAL-POINTER-2WORD-FREE-CHOICE`、`EXTERNAL-POINTER-2WORD-UNIVERSAL`、`EXTERNAL-POINTER-2WORD-VARIABLE`）的 Codec 文档，只有 DOC-ID 的 Codec ID、DECLARE 目标、`#1` 上绑定的名称（BIND）不同。
