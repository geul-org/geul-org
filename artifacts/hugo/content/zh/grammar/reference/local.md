---
title: "LOCAL"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "LOCAL 是用本文档签发的 ID 指向目标的声明 Reference。Edge Id 也是 LOCAL。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LOCAL 是用本文档签发的 ID 指向目标的声明 Reference。不需要外部 Issuer 就能引用文档内的目标，在文档外没有意义。要从文档外指向，需要在文档中放置 Meta [DOC-ID](/zh/grammar/meta/declaration/doc-id/)，由其他文档用指示 Reference 指向。

## 布局

```
TAG WORD          0000 0LLL L000 1QQQ      CCCC = 0001
[Length 扩展 TAG]
LOCAL ID          最短宽度的 unsigned big-endian
```

| LOCAL ID | 总计 | TAG WORD (Identified) |
|---|---|---|
| `0..65535` | 2 WORD | `0x0088` |
| `65536..2^32-1` | 3 WORD | `0x0108` |
| `2^32..2^48-1` | 4 WORD | `0x0188` |
| `2^48..2^64-1` | 5 WORD | `0x0208` |

- TAG WORD 是 `0000 0 LLLL 0001 QQQ`。为 Identified（`000`）时，低 7 位是 `0x08`。
- 遵循 Reference 通用规则，目标 ID 用最少的 WORD 数书写。

## Edge Id

- 作为 Edge Payload 第一个元素的 LOCAL，就是该 Edge 的 Edge Id 声明（[Edge](/zh/grammar/edge/)）。声明 Edge Id 的 LOCAL 的 Quantifier 只用 `000`。
- Edge Payload 其他位置上的 LOCAL 是提及。本文档的目标每次提及都用 LOCAL 书写。没有专门指向本文档目标的指示码。

## 标识符分配

- ID 是整数，由编码器分配。数字的大小和分配顺序除了同一性之外没有任何含义。
- **UNIQUE（必需）。** 在一个文档中，一个 LOCAL ID 只指向一个目标。Edge Id 在每个文档中只声明一次（HEAD Edge 和 BODY Edge 共用一个编号空间）。声明同一个 Edge Id 的 Edge 有两个以上则 invalid。
- **AUTO INCREMENT（建议）。** 新 ID 取该文档迄今分配的 ID 最大值 + 1，并按文档顺序递增。跨版本也一样（比已删除的 ID 更大的值来新建）。只是建议，不是有效性条件，不递增的文档也 valid。解码器不依赖 ID 的大小或连续性。
- 不分配 ID `0`。它不指向任何目标，也不用作 Edge Id。目标 ID 从 `1` 开始分配。
- 无论在该文档内还是文档外，文档都只用一个 [DOC-POINTER](/zh/grammar/reference/doc-pointer/) 来指向（自身就是自己 `DOC-ID` 的 DOC-POINTER）。文档上也可以附加 `BIND`·`LABEL`·判定 Edge。
- Issuer 自身用 [ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/) 指向。文档 ID `0` 是 Issuer 的术语定义索引文档。
- 给构成要素位置上的 `0` 赋予含义的 Codec（[TOULMIN](/zh/grammar/edge/toulmin/) REF·执行 Edge 的"无"、HEAD [SOURCE](/zh/grammar/edge/source/#整个文档的来源) Target 的"整个文档"）遵循该 Codec 的规则。这与[占位标记](/zh/grammar/reference/slot-marker/)不同，是该 Codec 内部的约定。
- 一旦分配的 ID 在同一文档中不再重复使用。
- 始终使用能表示该值的最小宽度。

## 同一性与范围

- 在同一文档中，LOCAL ID 的整数值相同则为同一个目标。编码宽度不是同一性的一部分。
- Identified LOCAL 表示已识别的目标。不用于匿名·未指定·null·sentinel 用途。"有值但不知道"（UNKNOWN-VALUE）或"没有值"（NO-VALUE）这类话，要在接受该标记的字段上用[占位标记](/zh/grammar/reference/slot-marker/)书写。
- 不同的 LOCAL ID 只是不同的 Reference，并不意味着现实中的目标也不同。
- 不把 LOCAL 的同一性扩展到文档之外。其他文档中的相同数字无关。
- Variable（`100`）LOCAL 是有名的话语变量（[Reference](/zh/grammar/reference/) Variable）。

## 合并

将多个文档合并为一个时，为每个原文档建立 `old ID → new ID` 对应表，把所有 LOCAL ID 重新分配为新文档的 ID，并替换所有引用。

- 在同一个原文档中相同的 ID，合并后也必须相同。
- 不同原文档中的相同数字无关，不会自动合并为同一个 Reference。
- 只要有一个 LOCAL 无法替换，就拒绝合并。

## 有效性

以下编码或分配 invalid。

- 带前导 `0x0000` WORD 的 non-minimal 编码（值 0 的 `0x0000` 1 WORD 除外）
- Edge Id 声明位置的 Quantifier 不是 `000`，或 ID 为 `0` 的情况
- 在同一文档中把一个 ID 重叠分配给不同的目标
- 在同一文档中两次以上声明同一个 Edge Id

## 示例

| LOCAL ID | WORD sequence |
|---:|---|
| 1 | `0088 0001` |
| 65535 | `0088 ffff` |
| 65536 | `0108 0001 0000` |
| 4294967295 | `0108 ffff ffff` |
| 1，Variable | `008C 0001` |

## 相关页面

- [Reference](/zh/grammar/reference/)、[DOC-POINTER](/zh/grammar/reference/doc-pointer/)、[ISSUER-POINTER](/zh/grammar/reference/issuer-pointer/)、[EXTERNAL-POINTER](/zh/grammar/reference/external-pointer/)
- [Edge](/zh/grammar/edge/)
