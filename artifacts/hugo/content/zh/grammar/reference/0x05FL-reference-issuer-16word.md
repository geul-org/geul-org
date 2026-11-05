---
title: "REFERENCE-ISSUER-16WORD (0x05FL)"
weight: 95
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-16WORD 是由 Issuer 定义的 Reference 格式。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-16WORD 是由 Issuer 定义的 Reference 格式。它是 Reference 区段末尾三格之一，Issuer 宽度为 16 WORD。三种 Kind 的 ISSUER 布局相同（[记录与 TAG WORD](../record.md#issuer-형식-레코드)）。

| 项目 | 值 |
|---|---|
| 名称 | `REFERENCE-ISSUER-16WORD`（规格文档 BIND `REFERENCE-ISSUER-16WORD`） |
| TAG ID | `0x05FL` |
| Codec ID | `0x000005F0` |
| 规格文档 | `0x00000000/codecs/0x000005F0/`（DECLARE 目标 `05F0`） |
| 章节 | 2 `0010`（Reference 其他），章节内偏移 C = 31 |
| Kind | Reference · 分类：Issuer 格式 |
| TAG WORD | `0000 0101 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | Issuer 16 WORD 加 Codec 编号 2 WORD。格式由 Issuer 的 Codec 文档决定 |
| Hugo 侧 | `reference/reference-issuer.md` |

## 布局 {#레이아웃}

```
TAG WORD          0000 0101 1111 LLLL      Codec 0x05FL
[Length 扩展 TAG]
Issuer            16 WORD
Codec 编号        2 WORD。由 Issuer 定义
Payload           由 Issuer 发行的 Codec 文档决定
```

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 原始值 16 WORD |  |  |
| 2 | `codec` | #3 | 原始值 2 WORD |  |  |
| 3 | `payload` | #4 | 剩余原始值（`0xFFFF`） |  |  |

`payload` 的构成由该 Issuer 的 Codec 文档决定。

## 解释与有效性 {#해석과-유효성}

- GEUL 只通过 Length 知道 Payload 的边界。不了解格式的解码器知道 Kind、Length、Issuer、Codec 编号，并按 Length 跳过。
- Codec 编号的含义、量化、指向什么，由 Issuer 发行的 Codec 文档决定。目标 ID 最短宽度、量化读取等 Reference 公共规则不适用（[REFERENCE-ISSUER](_index.md#해석과-유효성)）。
- Issuer 用能容纳其值的最短宽度书写（[Issuer 与公布](../issuer.md#issuer-등급)）。Issuer 值的高 12 WORD 为 0 则为 invalid。该值用更窄宽度的代码书写。
- Codec 编号为 2 WORD。由 Issuer 不论 Kind，在自己的 `codecs/` 内以互不重复的方式分配。编号不够时，再申请一个 Issuer。
- Codec 文档放在该 Issuer 的 `<Issuer>/codecs/<Codec 编号>/` 之下（[公布地址与版本列表](../publishing.md#id-표기)）。
- Issuer 格式的许可证由该 Issuer 决定（[Issuer 与公布](../issuer.md#라이선스)）。

## 相关页面 {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer)、[REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)、[REFERENCE-ISSUER-4WORD](0x05EL-reference-issuer-4word.md)
- [记录与 TAG WORD](../record.md#issuer-형식-레코드)、[Issuer 与公布](../issuer.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000005F0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005F000000000
BODY
#1 DECLARE 0x05F0
#2 FIELD #1 0x0010
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-16WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
