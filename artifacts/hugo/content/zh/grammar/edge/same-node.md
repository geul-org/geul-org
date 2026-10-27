---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE 是声明两个 Reference 指示同一目标的无向同一性叙述 Edge（Codec 0x01）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE 是声明两个 Reference 指示同一个 referent 的无向同一性叙述 Edge。Codec `0x01`。

这并不意味着两个 Reference 记录的 byte 编码、Codec、ID 相同。[REFERENCE-NODE](/zh/grammar/edge/reference-node/) 是 `Reference → 记录` 的有向绑定，与之不同，SAME-NODE 表示两个 Reference 之间的同一性（referential identity）。

## 布局

```
TAG WORD          0001 0LLL L000 0001
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            Reference 记录 1 个
```

## 解读与有效性

- Subject 和 Object 按此顺序序列化，各自必须恰好是一个完整的 [Reference](/zh/grammar/reference/) 记录。靠各记录的 Length 找到边界。
- Subject 或 Object 是 Value、Edge 或不完整的记录，则 invalid。
- SAME-NODE 关系具有自反性·对称性·传递性。wire 中 Subject/Object 的顺序是为分帧而设，不产生语义方向。实现必须能够双向检索这个关系。
- 不同的 [LOCAL](/zh/grammar/reference/local/) ID 只是不同的 Reference，并不是 referent 相同或不同的证据。两个 Reference 指示同一个 referent，要用 SAME-NODE 说明。
- 解读和推理必须保留包含该 Edge 的文档以及判定图的来源、时点、world、policy scope。不把 SAME-NODE 用作与上下文无关的全局合并依据。
- 即使有 SAME-NODE，也不删除或覆盖原来的 Reference 记录或谱系。
- 同一对上同时存在 SAME-NODE 和 [DIFFERENT-NODE](/zh/grammar/edge/different-node/)，wire 也不是 invalid。保留各主张的上下文，作为冲突来评估。
- 用 SAME-NODE 把 Variable Reference 与 Identified Reference 连接，以消解变量（[Reference](/zh/grammar/reference/) Variable）。

## 长度

```
总计 = 1 + N_len + N_id + N_subject + N_object WORD
```

## 示例（非规范）

Edge Id `0009`，Subject 是 LOCAL 1，Object 是 LOCAL 2。

- Edge 是 TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD，`LLLL=0110`。TAG 是 `0001 0 0110 0000001` = `1301`。

```
1301 0088 0009 0088 0001 0088 0002
```

## 相关页面

- [Edge](/zh/grammar/edge/)、[REFERENCE-NODE](/zh/grammar/edge/reference-node/)、[DIFFERENT-NODE](/zh/grammar/edge/different-node/)
- [Reference](/zh/grammar/reference/)、[LOCAL](/zh/grammar/reference/local/)
