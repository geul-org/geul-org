---
title: "VALUE-ISSUER-2WORD (0x09DL)"
weight: 157
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-2WORD 是由 Issuer 定义的 Value 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-2WORD 是由 Issuer 定义的 Value 格式。它是 Value 区末尾三格之一，Issuer 宽度为 2 WORD。三种 Kind 的 ISSUER 布局相同（[记录与 TAG WORD](../record.md#issuer-형식-레코드)）。

| 项目 | 值 |
|---|---|
| 名称 | `VALUE-ISSUER-2WORD`（规格文档 BIND `VALUE-ISSUER-2WORD`） |
| TAG ID | `0x09DL` |
| Codec ID | `0x000009D0` |
| 规格文档 | `0x00000000/codecs/0x000009D0/`（DECLARE 对象 `09D0`） |
| 章节 | 4 `0100`（Value），章节内偏移 C = 29 |
| Kind | Value · 分类：Issuer 格式 |
| TAG WORD | `0000 1001 1101 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | Issuer 2 WORD 与 Codec 编号 2 WORD。格式由 Issuer 的 Codec 文档决定 |
| Hugo 路径 | `value/_index.md` |

## 布局 {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 扩展 TAG]
Issuer            2 WORD
Codec 编号        2 WORD。由 Issuer 定义
Payload           由 Issuer 发布的 Codec 文档决定
```

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 原始值 2 WORD |  |  |
| 2 | `codec` | #3 | 原始值 2 WORD |  |  |
| 3 | `payload` | #4 | 剩余原始值（`0xFFFF`） |  |  |

`payload` 的构成由该 Issuer 的 Codec 文档决定。

## 解释与有效性 {#해석과-유효성}

- GEUL 仅凭 Length 知道 Payload 边界。不了解格式的解码器可以读到 Kind、Length、Issuer、Codec 编号，并按 Length 跳过。
- Payload 的解释由 Issuer 的 Codec 文档决定。目前已登记的 Issuer 格式 Value 见 [Codec 索引](../codec-index.md#value-issuer-형식)。
- Issuer 以能容纳其值的最短宽度书写（[Issuer 与公布](../issuer.md#issuer-등급)）。Issuer 2 WORD 可以书写所有值。
- Codec 编号为 2 WORD。由 Issuer 在自己的 `codecs/` 内不重复地分配，与 Kind 无关。编号不足时再申请一个 Issuer。
- Codec 文档放在该 Issuer 的 `<Issuer>/codecs/<Codec 编号>/` 之下（[公布地址与版本列表](../publishing.md#id-표기)）。
- Issuer 格式的许可证由该 Issuer 决定（[Issuer 与公布](../issuer.md#라이선스)）。

## 相关页面 {#관련-페이지}

- [Value — Issuer 格式](_index.md#issuer-형식)、[VALUE-ISSUER-4WORD](0x09EL-value-issuer-4word.md)、[VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [记录与 TAG WORD](../record.md#issuer-형식-레코드)、[Issuer 与公布](../issuer.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000009D0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009D000000000
BODY
#1 DECLARE 0x09D0
#2 FIELD #1 0x0002
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-2WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
