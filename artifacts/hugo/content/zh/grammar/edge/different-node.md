---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE 是两个 Reference 指示不同目标的非同一性叙述 Edge（Codec 0x02）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE 是两个 Reference 指示不同 referent 的非同一性叙述 Edge。Codec `0x02`。

这并不意味着两个 Reference 记录的 byte 编码、Codec、ID 不同。要与 [REFERENCE-NODE](/zh/grammar/edge/reference-node/) 的有向绑定、[SAME-NODE](/zh/grammar/edge/same-node/) 的同一性区分开。

## 布局

```
TAG WORD          0001 0LLL L000 0010
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            Reference 记录 1 个
```

## 解读与有效性

- Subject 和 Object 各自必须恰好是一个完整的 [Reference](/zh/grammar/reference/) 记录。靠各记录的 Length 找到边界，是 Value 或 Edge，或者不完整，则 invalid。
- Subject 和 Object 指示彼此不同的 referent。不能仅凭 Reference 记录的 byte 序列、Codec、ID 的差异就推断 referent 不同。
- 特别是，不同的 [LOCAL](/zh/grammar/reference/local/) ID 只是不同的 Reference，并不意味着现实中的 referent 也不同。不能仅凭 LOCAL ID 的差异推出 DIFFERENT。
- 非同一性具有对称性、非自反性，没有传递性。`DIFFERENT(A, B)` 与 `DIFFERENT(B, A)` 是同一个关系。但不能由 `DIFFERENT(A, B)` 和 `DIFFERENT(B, C)` 推出 `DIFFERENT(A, C)`。
- wire 中 Subject/Object 的顺序只是为分帧而定的序列化顺序，不产生语义方向。实现必须能够双向检索。
- 读完两个构成要素后的游标必须与 Edge 末尾恰好吻合。

关系本身是非自反的，但在结构上 valid 的 `DIFFERENT(A, A)` 主张，或 SAME 与 DIFFERENT 冲突的主张，不得作为 wire 语法错误而抹去。这样的主张保留上下文与谱系，在判定层作为矛盾处理。在解读或推出 DIFFERENT 时，要保留包含该 Edge 的文档的来源、时点、world、policy scope，不得无视这些而扩大为全局结论。

## 长度

```
总计 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 示例（非规范）

Edge Id `000a`，Subject 是 LOCAL 1，Object 是 LOCAL 2。

- Edge 是 TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD，`LLLL=0110`。TAG 是 `0001 0 0110 0000010` = `1302`。

```
1302 0088 000a 0088 0001 0088 0002
```

此示例中 LOCAL ID 的差异只是为了展示编码。只有另有"ID 1 和 ID 2 指示不同 referent"的主张时，才把这个 sequence 做成 DIFFERENT-NODE。

## 相关页面

- [Edge](/zh/grammar/edge/)、[REFERENCE-NODE](/zh/grammar/edge/reference-node/)、[SAME-NODE](/zh/grammar/edge/same-node/)
- [Reference](/zh/grammar/reference/)、[LOCAL](/zh/grammar/reference/local/)
