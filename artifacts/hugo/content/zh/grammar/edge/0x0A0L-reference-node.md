---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE 是把一个 Reference 连接到一条 Object 记录，从而定义或绑定该 Reference 是什么的有向陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `REFERENCE-NODE`（规格文档 BIND `REFERENCE-NODE`） |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| 规格文档 | `0x00000000/codecs/0x00000A00/`（DECLARE 目标 `0A00`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 0 |
| Kind | Edge · 系列：陈述，分组：指示与名称 |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | Reference 形式的 Subject 指示 Object 的有向绑定 |
| Hugo 侧 | `edge/reference-node.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `object` | #3 | 记录 | `000F` 章节 0 全部（通配符，Reference），`020F` 章节 1 全部（通配符，Reference），`040F` 章节 2 全部（通配符，Reference），`060F` 章节 3 全部（通配符，Value），`080F` 章节 4 全部（通配符，Value） |  |

REFERENCE-NODE 是把一个 Reference 连接到一条 Object 记录，从而定义或绑定该 Reference 是什么的有向陈述 Edge。Codec `0x0A0L`。

Subject 指示 Object。这种绑定不是主张语义同一性的 [SAME-NODE](0x0A1L-same-node.md)，也不意味着两条记录的 byte 相同。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            Reference 或 Value 记录 1 个
```

## 解释与有效性 {#해석과-유효성}

- Subject 必须恰好是一条完整的 [Reference](../reference/_index.md) 记录。依靠 Subject 自身的 Length 找到边界，不是 Reference 或不完整则为 invalid。
- Object 必须恰好是一条完整的 Reference 或 Value 记录。依靠 Object 自身的 Length 找到边界，是 Edge、Meta 或不完整则为 invalid。
- Object 为 Reference 时，沿 REFERENCE-NODE 绑定追溯的 Reference 链不得循环，LOCAL 必须最终得到解析。解析循环和悬空（dangling）LOCAL 为 invalid。
- 同一文档中，一个 LOCAL ID 被绑定到相互冲突的 Object 则为 invalid。LOCAL 的范围、ID、最小宽度和合并规则遵循 [LOCAL](../reference/0x005L-local.md)。
- 并非所有 Reference 都必须用 REFERENCE-NODE 绑定。
- 代表性用法是 `LOCAL → UTF8-LANGUAGE-TEXT`。当 [LABEL](0x0A4L-label.md) 的 Object 放的是 LOCAL 时，用同一文档中的这个绑定解析出文本。

不得把 Subject 指示 Object 的方向反过来解释。SAME 与 DIFFERENT 的含义和细则由各自的格式另行规定。

## 长度 {#길이}

```
全部 = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` 是 Length 扩展 TAG WORD 数，`N_id` 是 Edge Id LOCAL 记录的 WORD 数，`N_subject`、`N_object` 是各记录的总 WORD 数。读完 Subject 和 Object 后的游标必须与 Edge 末尾恰好吻合。

## 示例（非规范） {#예시-비규범}

Edge Id 为 `0008`，Subject 为 LOCAL 1，Object 为 `Donald Trump`（en）的 [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)。

- Edge Id 是 `0051 0008`，共 2 WORD。
- Subject 是 `0051 0001`，共 2 WORD。
- Object 为语言 `0761 656E`（BCP47 `en`）+ 文本 12 byte（偶数），即 `UTF8-LANGUAGE-TEXT-EVEN`（`0x078L`），总共 9 WORD。TAG 为 `0788`。
- Edge 为 TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD，`LLLL=1101`。TAG 为 `0A0D`。

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[SAME-NODE](0x0A1L-same-node.md)、[DIFFERENT-NODE](0x0A2L-different-node.md)、[LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md)、[LOCAL](../reference/0x005L-local.md)、[UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000A00/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
