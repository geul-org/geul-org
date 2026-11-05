---
title: "DELTA-BASE (0x1DBL)"
weight: 475
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "表明该版本文件不是快照，而是相对于同一文档基准版本的 diff 的标记（git packfile 的 delta）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DELTA-BASE`（规格文档 BIND `DELTA-BASE`） |
| TAG ID | `0x1DBL` |
| Codec ID | `0x00001DB0` |
| 规格文档 | `0x00000000/codecs/0x00001DB0/`（DECLARE 对象 `1DB0`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 27 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 1011 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 该版本文件是相对于同一文档基准版本（2 WORD 版本 ID）的 diff（git packfile delta） |
| Hugo 侧 | `meta/lineage/delta-base.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `version` | #2 | 原始值 2 WORD | `0620` UNSIGNED-INTEGER |  |

这是表明该版本文件不是快照，而是相对于同一文档基准版本的 **diff** 的标记（git packfile 的 delta）。版本本身仍定义为快照。内容哈希、版本列表、签名全部以应用 diff 后还原出的快照为准（[diff 存储](../document.md#diff-저장)）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 1011 LLLL      Codec 0x1DBL
版本 ID           2 WORD unsigned（同一文档的基准版本）
```

- Codec：Meta `0x1DBL`，谱系类
- Payload：2 WORD 版本 ID（原始值）
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 只用于有 [DOC-ID](0x1C7L-doc-id.md) 的文档。不放置 `DOC-ID` 的版本列表 `versions.geul`、列表文档（`issuers/` 的版本）和无名文档不设 diff。
- 基准版本是同一 `DOC-ID` 的已公布版本，且先于本版本。`0`（无版本）为 invalid。
- 还原出的快照的内容哈希必须与版本列表（[PUBLICATION](../edge/0x0B8L-publication.md)）中本版本的哈希相同。不同则该 diff 为 invalid。因此不在 diff 内另行记录结果哈希。
- 只有 BODY 的所有记录都是 Edge（带 Edge Id 的记录）的文档才能设为 diff。因为 diff 的单位是 LOCAL ID（Edge Id）。
- 快照还原规则遵循 [diff 存储](../document.md#diff-저장)。删除由 [DELTA-REMOVE](0x1DCL-delta-remove.md) 负责。
- 不另设新增、修订标记。diff BODY 的 Edge Id 在基准中已有则是修订，没有则是新增。新增从版本列表的 [NEXT-LOCAL-ID](0x1DDL-next-local-id.md) 开始取号。重新使用已删除的 LOCAL ID 则为 invalid（[修订](../document.md#개정)）。

## 示例 {#예시}

相对于基准版本 3 的 diff：

```
1DB2 0000 0003
```

- TAG `1DB2`（Meta `0x1DBL`，`LLLL=0010`，3 WORD），版本 ID `0000 0003`。

## 未决问题 {#열린-문제}

1. 快照间隔：每隔多少个版本放一次完整快照（diff 链长度与还原成本）。
2. 是否将基准版本限定为上一版本。
3. diff 文件的存放位置：是否放在版本文件的位置（`<版本 ID>.geul`），以及与内容哈希地址 `<Issuer>/hashes/` 的关系（`hashes/` 按快照的内容哈希查找）。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001DB0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DB000000000
BODY
#1 DECLARE 0x1DB0
#2 FIELD #1 0x0002
#3 BIND #1 "DELTA-BASE"
#4 BIND #2 "version"
#5 CODEC #2 0x0620
```
