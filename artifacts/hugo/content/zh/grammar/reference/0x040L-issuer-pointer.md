---
title: "ISSUER-POINTER (0x040L)"
weight: 64
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER 是指向 Issuer 自身的指示声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `ISSUER-POINTER`（规格文档 BIND `ISSUER-POINTER`） |
| TAG ID | `0x040L` |
| Codec ID | `0x00000400` |
| 规格文档 | `0x00000000/codecs/0x00000400/`（DECLARE 目标 `0400`） |
| 章节 | 2 `0010`（Reference 其他），章节内偏移 C = 0 |
| Kind | Reference · 分类：指示声明 |
| TAG WORD | `0000 0100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo 侧 | `reference/issuer-pointer.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 剩余原始值（`0xFFFF`） |  |  |

ISSUER-POINTER 是指向 Issuer 自身的指示声明 Reference。它是 Issuer 名称 `BIND`、`LABEL`、判定 Edge 的对象。

## 布局 {#레이아웃}

```
TAG WORD          0000 0100 0000 LLLL      Codec 0x040L
[Length 扩展 TAG]
Issuer            2/4/16 WORD
```

- Issuer 宽度就是整个 Payload。Codec 不拆分宽度。宽度不是 2、4、16 WORD，或 Issuer 值能放入更窄的宽度时，为 invalid（Issuer 规范形式）。
- Issuer 为 16 WORD 时总长为 17 WORD，因此附加 1 个 WORD 的 Length 扩展。
- 只占 Codec `0x040L` 一格。没有量化（Identified）。
- Issuer 值遵循 [Issuer](../issuer.md) 的分配。
- 用途：Issuer 列表 `issuers/` 的 BIND Subject（[公布地址与版本列表](../publishing.md#issuer-목록)）、Issuer 显示名称 LABEL、对 Issuer 的判定、签名者等以 Issuer 自身为对象的位置。
- 指向 Issuer 自身的形式只有 ISSUER-POINTER 一种。用 `EXTERNAL-ISSUER-*` 并以文档 ID `0`、目标 ID `0` 来指向 Issuer 为 invalid。

## 示例 {#예시}

| Issuer | WORD sequence |
|---|---|
| GEUL `0x00000000` | `0402 0000 0000` |
| IEEE `0x0000000D` | `0402 0000 000D` |

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)、[Issuer 与公布](../issuer.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000400/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000040000000000
BODY
#1 DECLARE 0x0400
#2 FIELD #1 rest
#3 BIND #1 "ISSUER-POINTER"
#4 BIND #2 "issuer"
```
