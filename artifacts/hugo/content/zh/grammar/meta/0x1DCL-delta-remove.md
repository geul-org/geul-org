---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "在 diff（DELTA-BASE）中，记录要从基准快照的 BODY 中去掉的记录的 LOCAL ID（Edge Id）（\"删除第X条\"）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DELTA-REMOVE`（规格文档 BIND `DELTA-REMOVE`） |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| 规格文档 | `0x00000000/codecs/0x00001DC0/`（DECLARE 对象 `1DC0`） |
| 章节 | 14 `1110`（Meta），章节内偏移 C = 28 |
| Kind | Meta · 类：谱系 |
| TAG WORD | `0001 1101 1100 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | diff 中要从基准 BODY 去掉的 LOCAL ID（Edge Id）列表 |
| Hugo 侧 | `meta/lineage/delta-remove.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | 剩余原始值（`0xFFFF`） |  |  |

在 diff（[DELTA-BASE](0x1DBL-delta-base.md)）中，记录要从基准快照的 BODY 中去掉的记录的 LOCAL ID（Edge Id）（“删除第X条”）。

## 布局 {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[Length 扩展 TAG]
待删除的 LOCAL ID  LOCAL Reference 记录 × 1 个以上
```

- Codec：Meta `0x1DCL`，谱系类
- Payload：一个以上的 [LOCAL](../reference/0x005L-local.md) Reference 记录
- 数量：至多一个

## 解释与有效性 {#해석과-유효성}

- 只放在有 `DELTA-BASE` 的文档中。
- 每个 LOCAL ID 必须是基准快照 BODY 中存在的 Edge Id。没有则为 invalid。同一 ID 出现两次则为 invalid。
- 在同一 diff 的 BODY 中再次放置相同的 Edge Id 则为 invalid（不能同时删除和修订）。
- 已删除的 LOCAL ID 在之后的版本中不再分配给其他对象（[修订](../document.md#개정)）。
- diff BODY 中没有某记录，意思是“未变”。因此删除只用这个 Meta 来表达。
- 不记录 HEAD Edge（针对整个文档的 [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) 及其 QUALIFIER）。HEAD 整体替换为 diff 的 HEAD（[diff 存储](../document.md#diff-저장)）。

## 示例 {#예시}

删除 LOCAL `#7` 和 `#12`：

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4`（Meta `0x1DCL`，`LLLL=0100`，5 WORD），LOCAL Reference `0051 0007`、`0051 000C`。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00001DC0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
