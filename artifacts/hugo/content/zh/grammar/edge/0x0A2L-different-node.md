---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE 是表示两个 Reference 指示互不相同的 referent 的非同一性陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DIFFERENT-NODE`（规格文档 BIND `DIFFERENT-NODE`） |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| 规格文档 | `0x00000000/codecs/0x00000A20/`（DECLARE 目标 `0A20`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 2 |
| Kind | Edge · 系列：陈述，分组：指示与名称 |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 两个 Reference 指示互不相同对象的非同一性 |
| Hugo 侧 | `edge/different-node.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `object` | #3 | 记录 | 任意记录（占位标记除外） |  |

DIFFERENT-NODE 是表示两个 Reference 指示互不相同的 referent 的非同一性陈述 Edge。Codec `0x0A2L`。

这并不意味着两条 Reference 记录的 byte 编码、Codec、ID 不同。要与 [REFERENCE-NODE](0x0A0L-reference-node.md) 的有向绑定、[SAME-NODE](0x0A1L-same-node.md) 的同一性区分开。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            Reference 记录 1 个
```

## 解释与有效性 {#해석과-유효성}

- Subject 和 Object 各自必须恰好是一条完整的 [Reference](../reference/_index.md) 记录。依靠各记录的 Length 找到边界，是 Value 或 Edge 或不完整则为 invalid。
- Subject 和 Object 指示互不相同的 referent。不能仅凭 Reference 记录的 byte 序列、Codec、ID 的差异就推断 referent 不同。
- 尤其是不同的 [LOCAL](../reference/0x005L-local.md) ID 只是不同的 Reference，并不意味着现实中的 referent 也不同。不仅凭 LOCAL ID 的差异推出 DIFFERENT。
- 非同一性具有对称性、非自反性，不具有传递性。`DIFFERENT(A, B)` 与 `DIFFERENT(B, A)` 是同一关系。但不能由 `DIFFERENT(A, B)` 和 `DIFFERENT(B, C)` 推出 `DIFFERENT(A, C)`。
- wire 上的 Subject/Object 顺序只是为了 framing 的序列化顺序，不产生语义方向。实现必须能够双向遍历。
- 读完两个组成部分后的游标必须与 Edge 末尾恰好吻合。

关系本身是非自反的，但不得把结构上 valid 的 `DIFFERENT(A, A)` 主张，或 SAME 与 DIFFERENT 相冲突的主张，当作 wire 语法错误加以清除。这类主张保留上下文和谱系，在判定层作为矛盾处理。解释或推出 DIFFERENT 时，保留包含该 Edge 的文档的出处、时点、world、policy scope，不忽视这些而扩大为全局结论。

## 长度 {#길이}

```
全部 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 示例（非规范） {#예시-비규범}

Edge Id 为 `000A`，Subject 为 LOCAL 1，Object 为 LOCAL 2。

- Edge 为 TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD，`LLLL=0110`。TAG 为 `0000 1010 0010 0110` = `0A26`。

```
0A26 0051 000A 0051 0001 0051 0002
```

这个示例中 LOCAL ID 的差异只是为了展示编码。只有另有主张称 ID 1 和 ID 2 指示互不相同的 referent 时，才把这个 sequence 做成 DIFFERENT-NODE。

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[REFERENCE-NODE](0x0A0L-reference-node.md)、[SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md)、[LOCAL](../reference/0x005L-local.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000A20/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
