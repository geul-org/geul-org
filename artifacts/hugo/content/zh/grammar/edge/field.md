---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD 是声明 Codec Payload 的一个字段的叙述 Edge（Codec 0x1C）。写明所属 DECLARE 和宽度（记录、原始值 n WORD、其余原始值）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD 是声明 Codec Payload 的一个字段的叙述 Edge。Codec `0x1C`。

FIELD 指向自己的 [DECLARE](/zh/grammar/edge/declare/)。指向同一个 DECLARE 的 FIELD 们按文档内顺序构成 Payload。布局内置于解码器（[Codec 规格文档](/zh/grammar/codec-spec/)）。

## 布局

```
TAG WORD          0001 0LLL L001 1100
Edge Id           LOCAL Reference 记录
DECLARE           LOCAL Reference 记录。该字段所属的 DECLARE Edge
宽度              1 WORD。0 = 记录, n (1~65534) = 原始值 n WORD, 0xFFFF = 其余原始值
```

## 解读与有效性

- DECLARE 指向同一文档的 DECLARE Edge。一个 FIELD 只属于一个 DECLARE。不单独写顺序，顺序就是 FIELD 记录在文档中的排列顺序。
- FIELD 规格文档把 DECLARE 声明为宽度 `0`（记录）、CODEC `0008`（LOCAL）的字段。因此在查看器图中绘制为 FIELD → DECLARE 的连接。
- 宽度 `0` 是记录字段。以 TAG WORD 开头，按该 TAG 的 Length 读取（[DECLARE](/zh/grammar/edge/declare/) 解读规则）。
- 宽度 `n`（1~65534）是原始值字段。始终恰好是 n WORD。
- 宽度 `0xFFFF` 是其余原始值。一个 DECLARE 中只放一个，前、中、后任意位置均可。宽度是外层记录的 TAG Length 所定的剩余 WORD 减去后面各字段宽度的值。因此其余字段之后的字段必须全是固定宽度的原始值（记录必须从前往后读才能知道结尾）。可以是 0 WORD。不附加 ENUM。
- 字段所接受的 Kind·Codec 用 [CODEC](/zh/grammar/edge/codec/) 指定。记录字段没有 CODEC 时接受任意记录，有则必须是其中之一。在原始值字段上放一个 CODEC，就把该原始值解读为去掉 TAG 的那个 Value。
- 字段名称用 [BIND](/zh/grammar/edge/bind/) 绑定到 FIELD 的 Edge Id（例：`doc`、`hash`）。附加在 DECLARE·FIELD·ENUM·CODEC 上的 UTF8-TEXT 全部用 BIND，不用 LABEL 等其他 Edge 附加。
- 原始值字段的码值含义用 [ENUM](/zh/grammar/edge/enum/) 附加。
- 图中指向其他节点的字段不另作标记。记录字段是 Reference，它就是连接。

## 长度

```
总计 = 1 + 2 + 2 + 1 WORD   (Edge Id·DECLARE 是 LOCAL 1 WORD ID 时)
```

## 示例（非规范）

- 记录字段：Edge Id 7，DECLARE #1，宽度 `0`。TAG 1 + Edge Id 2 + DECLARE 2 + 宽度 1 = 6 WORD。要只接受 LOCAL，请见 [CODEC](/zh/grammar/edge/codec/) 示例。

```
129C 0088 0007 0088 0001 0000
```

- 像内容哈希这样的原始值字段，请见 [DECLARE](/zh/grammar/edge/declare/) 示例。

## 相关页面

- [DECLARE](/zh/grammar/edge/declare/)、[ENUM](/zh/grammar/edge/enum/)、[CODEC](/zh/grammar/edge/codec/)、[BIND](/zh/grammar/edge/bind/)
- [Codec 规格文档](/zh/grammar/codec-spec/)
