---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE 是声明两个 Reference 指示同一 referent 的无向同一性陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `SAME-NODE`（规格文档 BIND `SAME-NODE`） |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| 规格文档 | `0x00000000/codecs/0x00000A10/`（DECLARE 目标 `0A10`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 1 |
| Kind | Edge · 系列：陈述，分组：指示与名称 |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 两个 Reference 指示相同对象的同一性 |
| Hugo 侧 | `edge/same-node.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `object` | #3 | 记录 | 任意记录（占位标记除外） |  |

SAME-NODE 是声明两个 Reference 指示同一 referent 的无向同一性陈述 Edge。Codec `0x0A1L`。

这并不意味着两条 Reference 记录的 byte 编码、Codec、ID 相同。[REFERENCE-NODE](0x0A0L-reference-node.md) 是 `Reference → 记录` 的有向绑定，与之不同，SAME-NODE 表示两个 Reference 之间的同一性（referential identity）。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            Reference 记录 1 个
```

## 解释与有效性 {#해석과-유효성}

- Subject 和 Object 按此顺序序列化，各自必须恰好是一条完整的 [Reference](../reference/_index.md) 记录。依靠各记录的 Length 找到边界。
- Subject 或 Object 是 Value、Edge 或不完整的记录则为 invalid。
- SAME-NODE 关系具有自反性、对称性、传递性。wire 上的 Subject/Object 顺序只是为了 framing，不产生语义方向。实现必须能够双向遍历该关系。
- 不同的 [LOCAL](../reference/0x005L-local.md) ID 只是不同的 Reference，并不能证明 referent 相同或不同。两个 Reference 指示同一 referent，须用 SAME-NODE 表明。
- 解释和推理必须保留包含该 Edge 的文档以及判定图的出处、时点、world、policy scope。不把 SAME-NODE 用作与上下文无关的全局合并依据。
- 即使有 SAME-NODE，也不删除或覆盖原来的 Reference 记录或谱系。
- 同一对上同时存在 SAME-NODE 和 [DIFFERENT-NODE](0x0A2L-different-node.md)，wire 也不因此 invalid。保留各主张的上下文，作为冲突进行评估。
- 把 Variable Reference 与 Identified Reference 用 SAME-NODE 连接，以解析变量（[Reference](../reference/_index.md) Variable）。

## 长度 {#길이}

```
全部 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 示例（非规范） {#예시-비규범}

Edge Id 为 `0009`，Subject 为 LOCAL 1，Object 为 LOCAL 2。

- Edge 为 TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD，`LLLL=0110`。TAG 为 `0000 1010 0001 0110` = `0A16`。

```
0A16 0051 0009 0051 0001 0051 0002
```

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[REFERENCE-NODE](0x0A0L-reference-node.md)、[DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md)、[LOCAL](../reference/0x005L-local.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000A10/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
