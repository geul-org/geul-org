---
title: "CODEC-POINTER (0x042L)"
weight: 66
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "CODEC-POINTER 是指向 Issuer 所公布 Codec 文档某一版本的指示声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC-POINTER 是指向 Issuer 所公布 Codec 文档某一版本的指示声明 Reference。Codec 文档没有文档 ID，而是用 CODEC-POINTER 指向自己及其版本。

| 项目 | 值 |
|---|---|
| 名称 | `CODEC-POINTER`（规格文档 BIND `CODEC-POINTER`） |
| TAG ID | `0x042L` |
| Codec ID | `0x00000420` |
| 规格文档 | `0x00000000/codecs/0x00000420/`（DECLARE 目标 `0420`） |
| 章节 | 2 `0010`（Reference 其他），章节内偏移 C = 2 |
| Kind | Reference · 分类：指示声明 |
| TAG WORD | `0000 0100 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | Issuer Codec 的某一版本。Issuer + Codec ID 2 WORD + 版本 ID 2 WORD，没有目标 ID |
| Hugo 侧 | `reference/codec-pointer.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 剩余原始值（`0xFFFF`） |  |  |
| 2 | `codec` | #3 | 原始值 2 WORD |  |  |
| 3 | `version` | #4 | 原始值 2 WORD |  |  |

## 布局 {#레이아웃}

```
TAG WORD          0000 0100 0010 LLLL      Codec 0x042L
[Length 扩展 TAG]
Issuer            2/4/16 WORD
Codec ID          2 WORD
版本 ID           2 WORD
```

## 解释与有效性 {#해석과-유효성}

- Issuer 宽度是 Payload 减去 Codec ID 和版本 ID 共 4 WORD 后剩余的部分。Payload 为 6、8、20 WORD 之一，其他长度为 invalid。Issuer 值能放入更窄的宽度时，为 invalid（Issuer 规范形式）。
- Issuer 为 16 WORD 时总长为 21 WORD，因此附加 1 个 WORD 的 Length 扩展。
- Codec ID 为 32 位。GEUL 直接码的 Codec ID，是把其 TAG WORD（L=0）写成 32 位的值（TRIPLE `0x0AAL` → `0x00000AA0`）。Issuer Codec 的 Codec ID 是记录的 Codec 编号，由 Issuer 不论 Kind，在自己的 `codecs/` 内以互不重复的方式决定（[公布地址与版本列表](../publishing.md#id-표기)）。
- 版本 ID `0` 是最新版本。其他值固定在该版本。
- 只占 Codec `0x042L` 一格。没有量化（Identified）。因为是章节 2，不按量化·体系来读。
- 使用处：Codec 文档的 Meta [DOC-ID](../meta/0x1C7L-doc-id.md)、Codec 版本列表的 [PUBLICATION](../edge/0x0B8L-publication.md)·DEPRECATION·TOMBSTONE、引入 Codec 文档的 [IMPORT-DOC](../meta/0x1E4L-import-doc.md)。在这些位置代替 DOC-POINTER。
- 公布地址为 `/.well-known/geul/<Issuer>/codecs/<Codec ID>/<版本 ID>.geul`（[公布地址与版本列表](../publishing.md#공표-주소)）。

## 示例 {#예시}

GEUL Issuer `0x00000000` 的 TRIPLE Codec（Codec ID `0x00000AA0`）。

| 版本 | WORD sequence |
|---|---|
| 1 | `0426 0000 0000 0000 0AA0 0000 0001` |
| 最新 (`0`) | `0426 0000 0000 0000 0AA0 0000 0000` |

- TAG 1 + Issuer 2 + Codec ID 2 + 版本 ID 2 = 7 WORD，`LLLL=0110`。TAG 为 `0000 0100 0010 0110` = `0426`。

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[ISSUER-POINTER](0x040L-issuer-pointer.md)、[Codec 规格文档](../codec-spec.md)
- [公布地址与版本列表](../publishing.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000420/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000042000000000
BODY
#1 DECLARE 0x0420
#2 FIELD #1 rest
#3 FIELD #1 0x0002
#4 FIELD #1 0x0002
#5 BIND #1 "CODEC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "version"
```
