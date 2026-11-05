---
title: "DOC-ID (0x1C7L)"
weight: 455
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "声明本文档的标识符。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DOC-ID`（规格文档 BIND `DOC-ID`） |
| TAG ID | `0x1C7L` |
| Codec ID | `0x00001C70` |
| 规格文档 | `0x00000000/codecs/0x00001C70/`（DECLARE 对象 `1C70`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 7 |
| Kind | Meta · 类：定义 |
| TAG WORD | `0001 1100 0111 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 本文档的标识符。内置 Reference `DOC-POINTER`（Issuer、文档 ID、版本 0）。Codec 文档用 `CODEC-POINTER`（Issuer、Codec ID、版本 0） |
| Hugo 侧 | `meta/declaration/doc-id.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #2 | 记录 | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |

声明本文档的标识符。其他文档要指向本文档及其中的对象，就需要它。

## 布局 {#레이아웃}

```
TAG WORD          0001 1100 0111 LLLL      Codec 0x1C7L
[Length 扩展 TAG]
文档              DOC-POINTER Reference 记录。(Issuer, 文档 ID, 版本 0)。Codec 文档为 CODEC-POINTER
```

- Codec：Meta `0x1C7L`，定义类
- Payload：一个内置 Reference [DOC-POINTER](../reference/0x041L-doc-pointer.md)（Issuer、文档 ID、版本 0）
- 数量：至多一个。`docs/<文档 ID>/`、`codecs/<Codec ID>/` 下的版本文档必须有

## 解释与有效性 {#해석과-유효성}

- Payload 恰好是一个 `DOC-POINTER`（Issuer、文档 ID、版本 `0`）Reference 记录。版本 ID 只用 `0`。版本不由文档分配，而由版本列表分配。Codec 文档使用 `CODEC-POINTER`（Issuer、Codec ID、版本 `0`）（[CODEC-POINTER](../reference/0x042L-codec-pointer.md)）。
- 因此指向“本文档”的写法，在 DOC-ID、版本列表的 PUBLICATION 记录、其他文档的引用中都相同。
- 无论版本如何，同一文档的 `DOC-ID` 相同。版本 ID 和内容哈希不写入文档（[版本](../document.md#버전)）。
- 不存在文档名称地址（[公布地址与版本列表](../publishing.md#문서-이름)）。供人阅读的标题由陈述 [LABEL](../edge/0x0A4L-label.md) 负责。
- 若没有，则是无名文档，只能通过内容哈希指向。其他文档要用指示 Reference 指向本文档的 LOCAL，就需要它。
- 获取文档的一方要验证所收文档的 `DOC-ID` 与所请求的 Issuer、文档 ID 一致。
- 文档 ID `0x0000000000000000` 是 Issuer 的术语定义索引文档（[Issuer](../issuer.md)）。该文档同样是 `docs/<文档 ID>/` 下的版本文档，因此要放置 DOC-ID（`DOC-POINTER`（Issuer、`0`、`0`））。Issuer 自身由 [ISSUER-POINTER](../reference/0x040L-issuer-pointer.md) 代表。
- `.well-known/geul/` 下 `<Issuer>/docs/<文档 ID>/` 与 `<Issuer>/codecs/<Codec ID>/` 的版本文档 `<版本 ID>.geul`（含规格文档）必须有 `DOC-ID`。
- 列表文档是例外，不放置 `DOC-ID`：版本列表 `versions.geul`（[PUBLICATION](../edge/0x0B8L-publication.md)）和 Issuer 列表 `issuers/` 的版本 `<版本 ID>.geul`（[公布地址与版本列表](../publishing.md#목록-문서)）。这是什么的列表，由记录的 DOC-POINTER 说明。列表文档的版本由其 `versions.geul` 的 PUBLICATION 以 DOC-POINTER（`0x00000000`、保留文档 ID、版本 ID）指向。内容哈希地址 `<Issuer>/hashes/` 是上述文档的副本，因此遵循原件。
- 文档 ID `0xFFFFFFFFFFFFFFFF` 在所有 Issuer 中保留（`0x0000000000000000` 亦然），用于 Issuer `0x00000000` 的 Issuer 列表。其他 Issuer 不使用。列表文档没有 `DOC-ID`，因此该值只出现在 `issuers/versions.geul` 记录的 DOC-POINTER 中。
- Codec 规格文档是 GEUL Issuer `0x00000000` 的 Codec 文档。没有文档 ID，用 `DOC-ID` 放置 CODEC-POINTER（`0x00000000`、Codec ID、`0`）。Codec ID 是把 Kind·Codec TAG WORD 写成 32 位的值（`0x0B80` → `0x00000B80`）（[规格文档](../codec-spec.md)）。

## 示例 {#예시}

- Issuer `0x00000002`，文档 `0x…0005`：`1C79 0418 0000 0002 0000 0000 0000 0005 0000 0000`（Meta TAG 1 + Reference TAG 1 + Issuer 2 + 文档 ID 4 + 版本 2 = 10 WORD）

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001C70/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C7000000000
BODY
#1 DECLARE 0x1C70
#2 FIELD #1 record
#5 CODEC #2 0x0410
#3 BIND #1 "DOC-ID"
#4 BIND #2 "doc"
#6 CODEC #2 0x0420
```
