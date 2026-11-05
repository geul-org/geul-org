---
title: "DOC-POINTER (0x041L)"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER 是指向 Issuer 所公布文档某一版本的指示声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DOC-POINTER`（规格文档 BIND `DOC-POINTER`） |
| TAG ID | `0x041L` |
| Codec ID | `0x00000410` |
| 规格文档 | `0x00000000/codecs/0x00000410/`（DECLARE 目标 `0410`） |
| 章节 | 2 `0010`（Reference 其他），章节内偏移 C = 1 |
| Kind | Reference · 分类：指示声明 |
| TAG WORD | `0000 0100 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Hugo 侧 | `reference/doc-pointer.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | 剩余原始值（`0xFFFF`） |  |  |
| 2 | `doc` | #3 | 原始值 4 WORD |  |  |
| 3 | `version` | #4 | 原始值 2 WORD |  |  |

DOC-POINTER 是指向 Issuer 所公布文档某一版本的指示声明 Reference。它是文档的公布·deprecate·删除、引用版本、以及关于文档的陈述的对象。

## 布局 {#레이아웃}

```
TAG WORD          0000 0100 0001 LLLL      Codec 0x041L
[Length 扩展 TAG]
Issuer            2/4/16 WORD
文档 ID           4 WORD
版本 ID           2 WORD
```

## 解释与有效性 {#해석과-유효성}

- Issuer 宽度是 Payload 减去文档 ID 和版本 ID 共 6 WORD 后剩余的部分。Codec 不拆分宽度。宽度不是 2、4、16 WORD，或 Issuer 值能放入更窄的宽度时，为 invalid（Issuer 规范形式）。
- 版本 ID 不能省略。若允许省略，就无法仅凭 Payload 长度确定 Issuer 宽度（Issuer 4 WORD·无版本与 Issuer 2 WORD·有版本同为 8 WORD）。
- 版本 ID `0` 是最新版本。绑定到解释时刻的现行版本。其他值固定在该版本（[PUBLICATION](../edge/0x0B8L-publication.md)）。
- 文档 ID `0` 是 Issuer 的术语定义索引文档。Issuer 本身用 [ISSUER-POINTER](0x040L-issuer-pointer.md) 指向。
- 所有 Issuer 都保留文档 ID `0x0000000000000000` 和 `0xFFFFFFFFFFFFFFFF`（[Issuer 与公布](../issuer.md#용어-정의-문서)）。`0xFFFFFFFFFFFFFFFF` 用于 Issuer `0x00000000` 的 Issuer 列表 `issuers/`，其他 Issuer 不使用。`issuers/versions.geul` 的 PUBLICATION·DEPRECATION·TOMBSTONE 用这个值指向列表版本（[公布地址与版本列表](../publishing.md#목록-문서)）。
- 只占 Codec `0x041L` 一格。没有量化（Identified）。
- 指向 Issuer 文档的形式只有 DOC-POINTER 一种。用 `EXTERNAL-ISSUER-*`（Issuer、文档 ID、目标 ID `0`）或 `EXTERNAL-POINTER-*`（IMPORT ID、目标 ID `0`）指向文档为 invalid。
- 使用处：Meta [DOC-ID](../meta/0x1C7L-doc-id.md)·[IMPORT-DOC](../meta/0x1E4L-import-doc.md)，版本列表的 PUBLICATION·DEPRECATION·TOMBSTONE。
- Codec 文档没有文档 ID。Codec 文档及其版本用 [CODEC-POINTER](0x042L-codec-pointer.md) 指向。

## 示例 {#예시}

GEUL Issuer `0x00000000` 的文档 `0xFFFF000000000001`。

| 版本 | WORD sequence |
|---|---|
| 1 | `0418 0000 0000 FFFF 0000 0000 0001 0000 0001` |
| 最新 (`0`) | `0418 0000 0000 FFFF 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 2 + 文档 ID 4 + 版本 ID 2 = 9 WORD，`LLLL=1000`。TAG 为 `0000 0100 0001 1000` = `0418`。

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[ISSUER-POINTER](0x040L-issuer-pointer.md)、[EXTERNAL-ISSUER](0x02FL-external-issuer-2word.md)、[PUBLICATION](../edge/0x0B8L-publication.md)
- [Issuer 与公布](../issuer.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000410/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000041000000000
BODY
#1 DECLARE 0x0410
#2 FIELD #1 rest
#3 FIELD #1 0x0004
#4 FIELD #1 0x0002
#5 BIND #1 "DOC-POINTER"
#6 BIND #2 "issuer"
#7 BIND #3 "doc"
#8 BIND #4 "version"
```
