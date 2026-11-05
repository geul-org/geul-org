---
title: "LOCAL (0x005L~0x009L)"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL 是用本文档签发的 ID 指向对象的声明 Reference。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `LOCAL`（5Q 分组。各代码的名称见下方成员表） |
| TAG ID | `0x005L~0x009L` |
| 章节 | 0 `0000`（Reference 实体），章节内偏移 C = 5~9 |
| Kind | Reference · 分类：声明 |
| Hugo 侧 | `reference/local.md` |

## 成员 {#구성원}

本页合并讲述一套 5Q 体系的五个代码。量化由章节内偏移 `C % 5` 决定（[Reference](_index.md#quantifier)）。每个代码各有一份 Codec 文档。五份 Codec 文档的字段相同，只有 DECLARE 目标和名称（BIND）不同。

| TAG ID | 名称 | 量化 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x005L` | `LOCAL-IDENTIFIED` | Identified | `0x00000050` | `0x00000000/codecs/0x00000050/` | `0000 0000 0101 LLLL` |
| `0x006L` | `LOCAL-GENERIC` | Generic | `0x00000060` | `0x00000000/codecs/0x00000060/` | `0000 0000 0110 LLLL` |
| `0x007L` | `LOCAL-FREE-CHOICE` | Free-choice | `0x00000070` | `0x00000000/codecs/0x00000070/` | `0000 0000 0111 LLLL` |
| `0x008L` | `LOCAL-UNIVERSAL` | Universal | `0x00000080` | `0x00000000/codecs/0x00000080/` | `0000 0000 1000 LLLL` |
| `0x009L` | `LOCAL-VARIABLE` | Variable | `0x00000090` | `0x00000000/codecs/0x00000090/` | `0000 0000 1001 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `local-id` | #2 | 剩余原始值（`0xFFFF`） |  |  |

LOCAL 是用本文档签发的 ID 指向对象的声明 Reference。不需要外部 Issuer，即可引用文档内的对象。若要从文档外指向，则在文档中设置 Meta [DOC-ID](../meta/0x1C7L-doc-id.md)，由其他文档用指示 Reference 指向。

## 布局 {#레이아웃}

```
TAG WORD          0000 0000 0101 LLLL      Codec 0x005L~0x009L (Identified 0x005L)
[Length 扩展 TAG]
LOCAL ID          最短宽度的 unsigned big-endian
```

| LOCAL ID | 总长 | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0051` |
| `65536..2^32-1` | 3 WORD | `0x0052` |
| `2^32..2^48-1` | 4 WORD | `0x0053` |
| `2^48..2^64-1` | 5 WORD | `0x0054` |

- Codec 为 `0x005L`（Identified）、`0x006L`（Generic）、`0x007L`（Free-choice）、`0x008L`（Universal）、`0x009L`（Variable）。Identified 的 TAG WORD 为 `0000 0000 0101 LLLL`。
- 遵循 Reference 的公共规则：目标 ID 用最短的 WORD 数书写。

## Edge Id {#edge-id}

- Edge Payload 的第一个元素 LOCAL 就是该 Edge 的 Edge Id 声明（[Edge](../edge/_index.md)）。声明 Edge Id 的 LOCAL 只使用 Identified（`0x005L`）。
- Edge Payload 其他位置的 LOCAL 是提及。本文档的对象每次被提及都写作 LOCAL。没有专门指向本文档对象的指示代码。

## 标识符分配 {#식별자-할당}

- ID 是整数，由编码器分配。数字的大小和分配顺序除同一性外没有任何含义。
- **UNIQUE（必须）。** 在一份文档中，一个 LOCAL ID 只指向一个对象。每份文档中 Edge Id 只声明一次（HEAD Edge 和 BODY Edge 共用一个编号空间）。声明同一 Edge Id 的 Edge 有两个以上则为 invalid。
- **AUTO INCREMENT（建议）。** 新 ID 取该文档中迄今分配的 ID 最大值 + 1，并随文档顺序递增。跨版本也一样（比已删除的 ID 更大的值来创建新 ID）。这只是建议，不是有效性条件，不递增的文档也是 valid。解码器不依赖 ID 的大小或连续性。
- 不分配 ID `0`。它不指向任何对象，也不用作 Edge Id。对象 ID 从 `1` 开始分配。
- 文档无论在该文档内还是文档外，都只用一个 [DOC-POINTER](0x041L-doc-pointer.md) 指向（指向自身时用自己 `DOC-ID` 的 DOC-POINTER）。文档上也可以附加 `BIND`、`LABEL`、判定 Edge。
- Issuer 自身用 [ISSUER-POINTER](0x040L-issuer-pointer.md) 指向。文档 ID `0` 是 Issuer 的术语定义索引文档。
- 对组成要素位置的 `0` 赋予含义的 Codec（[TOULMIN](../toulmin/_index.md) REF·执行 Edge 的“无”、HEAD [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) Target 的“整个文档”）遵循该 Codec 的规则。这是与[占位标记](../slot-marker.md)不同的、该 Codec 内部的约定。
- 一旦分配的 ID，在同一文档中不再重用。
- 始终使用能表示该值的最小宽度。

## 同一性与范围 {#동일성과-범위}

- 同一文档中，LOCAL ID 的整数值相同则为同一对象。编码宽度不属于同一性的一部分。
- Identified LOCAL 表示已识别的对象。不用于匿名、未指定、null、sentinel 用途。“有值但不知道”（UNKNOWN-VALUE）或“没有值”（NO-VALUE）这类说法，要在接受该标记的字段中用[占位标记](../slot-marker.md)书写。
- 不同的 LOCAL ID 只是不同的 Reference，并不表示现实中的对象也彼此不同。
- LOCAL 的同一性不扩展到文档之外。其他文档中相同的数字与之无关。
- Variable（`0x009L`）LOCAL 是有名字的话语变量（[Reference](_index.md) Variable）。

## 合并 {#병합}

将多份文档合并为一份时，为每份原始文档建立 `old ID → new ID` 对应表，把所有 LOCAL ID 重新分配为新文档的 ID，并替换全部引用。

- 在同一份原始文档中相同的 ID，合并后也必须相同。
- 不同原始文档中相同的数字互不相关，不会自动合并为同一个 Reference。
- 只要有一个 LOCAL 未能替换，就拒绝合并。

## 有效性 {#유효성}

以下编码或分配为 invalid。

- 带有前导 `0x0000` WORD 的 non-minimal 编码（值 0 的 `0x0000` 1 WORD 除外）
- Edge Id 声明位置的 Codec 不是 Identified（`0x005L`），或 ID 为 `0`
- 同一文档中把一个 ID 重叠分配给不同对象
- 同一文档中两次以上声明同一 Edge Id

## 示例 {#예시}

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0051 0001` |
| 65535 | `0051 FFFF` |
| 65536 | `0052 0001 0000` |
| 4294967295 | `0052 FFFF FFFF` |
| 1, Variable | `0091 0001` |

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[DOC-POINTER](0x041L-doc-pointer.md)、[ISSUER-POINTER](0x040L-issuer-pointer.md)、[EXTERNAL-POINTER](0x020L-external-pointer-1word.md)
- [Edge](../edge/_index.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000050/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000005000000000
BODY
#1 DECLARE 0x0050
#2 FIELD #1 rest
#3 BIND #1 "LOCAL-IDENTIFIED"
#4 BIND #2 "local-id"
```

以上是 `LOCAL-IDENTIFIED`（`0x005L`）的 Codec 文档。其他成员（`LOCAL-GENERIC`、`LOCAL-FREE-CHOICE`、`LOCAL-UNIVERSAL`、`LOCAL-VARIABLE`）的 Codec 文档，只有 DOC-ID 的 Codec ID、DECLARE 目标、`#1` 上绑定的名称（BIND）不同。
