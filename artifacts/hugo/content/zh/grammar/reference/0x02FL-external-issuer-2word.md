---
title: "EXTERNAL-ISSUER-2WORD (0x02FL~0x033L)"
weight: 47
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER 是无需 IMPORT，用一条记录引用 Issuer 所公布文档中 LOCAL ID 的指示声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER 是无需 IMPORT，用一条记录引用 Issuer 所公布文档中 LOCAL ID 的指示声明 Reference。

| 项目 | 值 |
|---|---|
| 名称 | `EXTERNAL-ISSUER-2WORD`（5Q 分组。各代码的名称见下方成员表） |
| TAG ID | `0x02FL~0x033L` |
| 章节 | 1 `0001`（Reference EXTERNAL），章节内偏移 C = 15~19 |
| Kind | Reference · 分类：指示声明 |
| Hugo 侧 | `reference/external-issuer.md`（该页还一并讲述[EXTERNAL-ISSUER-4WORD](0x034L-external-issuer-4word.md)、[EXTERNAL-ISSUER-16WORD](0x039L-external-issuer-16word.md)） |

## 成员 {#구성원}

本页合并讲述一套 5Q 体系的五个代码。量化由章节内偏移 `C % 5` 决定（[Reference](_index.md#quantifier)）。每个代码各有一份 Codec 文档。五份 Codec 文档的字段相同，只有 DECLARE 目标和名称（BIND）不同。

| TAG ID | 名称 | 量化 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x02FL` | `EXTERNAL-ISSUER-2WORD-IDENTIFIED` | Identified | `0x000002F0` | `0x00000000/codecs/0x000002F0/` | `0000 0010 1111 LLLL` |
| `0x030L` | `EXTERNAL-ISSUER-2WORD-GENERIC` | Generic | `0x00000300` | `0x00000000/codecs/0x00000300/` | `0000 0011 0000 LLLL` |
| `0x031L` | `EXTERNAL-ISSUER-2WORD-FREE-CHOICE` | Free-choice | `0x00000310` | `0x00000000/codecs/0x00000310/` | `0000 0011 0001 LLLL` |
| `0x032L` | `EXTERNAL-ISSUER-2WORD-UNIVERSAL` | Universal | `0x00000320` | `0x00000000/codecs/0x00000320/` | `0000 0011 0010 LLLL` |
| `0x033L` | `EXTERNAL-ISSUER-2WORD-VARIABLE` | Variable | `0x00000330` | `0x00000000/codecs/0x00000330/` | `0000 0011 0011 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 原始值 2 WORD |  |  |
| 2 | `doc` | #3 | 原始值 4 WORD |  |  |
| 3 | `target-id` | #4 | 剩余原始值（`0xFFFF`） |  |  |

EXTERNAL-ISSUER 是无需 IMPORT 即可引用 Issuer 所公布文档中 LOCAL ID 的指示声明 Reference。一条记录即含义完整，并跟随最新版本。

## 布局 {#레이아웃}

```
TAG WORD          0000 001C CCCC LLLL      Codec 0x02FL~0x03DL (章节 1)
[Length 扩展 TAG]
Issuer            由 Codec 决定的宽度 (2/4/16 WORD)
文档 ID           4 WORD
目标 ID           其余全部。该文档的 LOCAL ID，最短宽度
```

| Codec (Identified, Generic, Free-choice, Universal, Variable) | 名称 | Issuer 宽度 |
|---|---|---|
| `0x02FL~0x033L` | EXTERNAL-ISSUER-2WORD | 2 WORD（在 geul.org 注册，域名证明） |
| `0x034L~0x038L` | EXTERNAL-ISSUER-4WORD | 4 WORD（在 geul.org 注册，无证明） |
| `0x039L~0x03DL` | EXTERNAL-ISSUER-16WORD | 16 WORD（由公钥计算） |

- 宽度由体系编号决定：体系 − 9（章节内偏移 `C` 的 `C / 5 − 3`）为 0、1、2 时，分别是 2、4、16 WORD。量化为 `C % 5`。
- Issuer ID 是整数值。值相同则为同一个 Issuer。Issuer 用能容纳其值的最短宽度书写，并选择该宽度的 Codec（仅当达到 `2^32` 以上时才用 4 WORD，仅当达到 `2^64` 以上时才用 16 WORD）。更宽的写法为 invalid（[Issuer](../issuer.md)）。
- Issuer 的注册和管理由 geul.org 负责。
- 不写版本，跟随最新版本。要固定版本，请使用 [IMPORT-DOC](../meta/0x1E4L-import-doc.md) 和 [EXTERNAL-POINTER](0x020L-external-pointer-1word.md)。
- 位置按公布地址规则查找（[公布地址与版本列表](../publishing.md)）。
- 该文档中同一个 LOCAL ID，无论在该文档内写作 LOCAL，还是在其他文档中写作 EXTERNAL-ISSUER（或 IMPORT 之后写作 EXTERNAL-POINTER），都是同一对象。
- 只指向文档的 LOCAL。文档本身用 [DOC-POINTER](0x041L-doc-pointer.md)，Issuer 本身用 [ISSUER-POINTER](0x040L-issuer-pointer.md) 指向。所以目标 ID 不是 `0`。文档 ID `0` 是 Issuer 的术语定义索引文档。

## 有效性 {#유효성}

- Issuer 宽度与 Codec 不符，或值能放入更窄的宽度时，为 invalid。
- 目标 ID 为 `0` 时为 invalid。目标 ID `0`（文档本身）由 DOC-POINTER 负责。
- 禁止目标 ID 带有前导 `0x0000` WORD。

## 示例 {#예시}

| 目标 | WORD sequence |
|---|---|
| Issuer `0x00000002`，文档 `0x…0002`，LOCAL 7 | `02F7 0000 0002 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`，文档 `0x…0002`，LOCAL 7 | `02F7 0001 2345 0000 0000 0000 0002 0007` |

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[ISSUER-POINTER](0x040L-issuer-pointer.md)、[EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Issuer 与公布](../issuer.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000002F0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000002F000000000
BODY
#1 DECLARE 0x02F0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0004
#4 FIELD #1 rest
#5 BIND #1 "EXTERNAL-ISSUER-2WORD-IDENTIFIED"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "target-id"
```

以上是 `EXTERNAL-ISSUER-2WORD-IDENTIFIED`（`0x02FL`）的 Codec 文档。其他成员（`EXTERNAL-ISSUER-2WORD-GENERIC`、`EXTERNAL-ISSUER-2WORD-FREE-CHOICE`、`EXTERNAL-ISSUER-2WORD-UNIVERSAL`、`EXTERNAL-ISSUER-2WORD-VARIABLE`）的 Codec 文档，只有 DOC-ID 的 Codec ID、DECLARE 目标、`#1` 上绑定的名称（BIND）不同。
