---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE 是声明单个 Codec 的 Payload 构成的叙述 Edge（Codec 0x1B）。与 FIELD·ENUM·CODEC 一起是书写 Codec 规格文档的词汇。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE 是声明单个 Codec 的 Payload 构成的叙述 Edge。Codec `0x1B`。

它与 [FIELD](/zh/grammar/edge/field/)（`0x1C`）、[ENUM](/zh/grammar/edge/enum/)（`0x1D`）、[CODEC](/zh/grammar/edge/codec/)（`0x1E`）一起，是书写 Codec 规格的词汇（[Codec 规格文档](/zh/grammar/codec-spec/)）。四个 Edge 的布局内置于解码器。用该词汇写成的各个 Codec 规格文档是一般文档。凭一份规格就同时完成验证、分解、显示（查看器）。查看器不为每个 Codec 单设代码，而是按规格绘制。

## 布局

```
TAG WORD          0001 0LLL L001 1011
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
目标              1 WORD。取所声明 Codec 的 TAG WORD 中只有 Kind·Codec 的位置 (LLLL = 0)
[Issuer·格式编号] 目标是 Issuer 格式时。与 Codec 扩展 TAG 布局相同
```

- DECLARE 中不放字段列表。每个 [FIELD](/zh/grammar/edge/field/) 指向自己的 DECLARE，这些 FIELD 在文档内的顺序就是 Payload 字段顺序。

## 解读规则

这是按 Codec 规格读取和表示记录的规则。

- 原始值字段按 FIELD 声明的固定 WORD 数读取。可以有一个字段是其余原始值（宽度 `0xFFFF`），读取的量是剩余 WORD 减去其后固定字段的宽度。其余字段之后只放固定宽度的原始值。
- 记录字段以 TAG WORD 开头，按该 TAG 的 Length 读取。
- 原始值字段是 n WORD 大端序无符号整数。写法是 `0x` + 宽度×4 位 hex，如果有相同值的 ENUM，则一并写出其 BIND 名称。
- 记录字段的含义由该记录的 Codec 规格决定。需要解读的值（符号·小数·日期等）不用原始值，而用 Value 记录。

没有其他边界规则。有两个以上可变原始值、可变原始值之后还有记录·可变字段、或原始值宽度随其他字段值或文档状态而变化的 Codec，无法用这套词汇声明。这样的布局要把可变部分用记录包起来，只留下一个（例：SIGNATURE 的签名者是 Reference 记录）。

## 有效性

- 目标的 Kind 是 Reference、Value、Edge、Meta 之一。Reference 的 Codec 在 `CCCC` 位置，Quantifier 设为 0。
- [占位标记](/zh/grammar/reference/slot-marker/)（Reference Codec `0000`）不能成为 DECLARE 的目标。它内置于解码器（0 层）。
- Edge 的 Edge Id 不用 FIELD 声明。它是所有 Edge 的第一个元素，是隐含的（[Edge](/zh/grammar/edge/)）。
- DECLARE 的字段是指向它的 FIELD 们，可以是 0 个。一个 FIELD 只属于一个 DECLARE。即使是相同形状的字段，每个 DECLARE 也要单独放 FIELD。
- DECLARE 中除目标（以及 Issuer 格式目标的 Issuer·格式编号）外什么都没有。
- 依次读完字段后的游标必须与记录末尾恰好吻合。多了或少了，该记录就违反规格。
- 一个文档中不对同一目标声明两次。
- 尾部字段不同的变体不作为分支使用。每个 Codec 单独放 DECLARE。

## 规格文档

- 直接码的规格文档是 GEUL Issuer `0x0000` 的一般文档。文档 ID 是目标 TAG WORD 扩展为 4 WORD 的值（`0x1018` → `0x0000000000001018`），与其他 Issuer 文档一样（版本 ID、`versions.geul`）公布（[Codec 规格文档](/zh/grammar/codec-spec/)）。
- 一个规格文档只有一个 DECLARE，其目标必须与文档 ID 的 TAG WORD 相同。`DOC-ID` 是 DOC-POINTER（`0x0000`、该文档 ID、`0`）。

## 名称

- Codec 名称用 [BIND](/zh/grammar/edge/bind/) 绑定到 DECLARE 的 Edge Id（例：`PUBLICATION`）。附加在 DECLARE·FIELD·ENUM·CODEC 上的 UTF8-TEXT 全部用 BIND，不用 LABEL 等其他 Edge 附加。
- 字段名称和 enum 名称也以同样方式绑定到 FIELD·ENUM。

## 示例

PUBLICATION（Edge `0x18`）的规格文档 `geul.org/publication`：Edge Id 之后是 DOC-POINTER 记录，内容哈希 16 WORD。

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, 记录           (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, 原始值 16 WORD (BIND "hash")
```

- DECLARE：TAG 1 + Edge Id 2 + 目标 1 = 4 WORD，`LLLL = 0011`。
- FIELD：TAG 1 + Edge Id 2 + DECLARE 2 + 宽度 1 = 6 WORD（`LLLL = 0101`）。所接受的 Kind·Codec 用 [CODEC](/zh/grammar/edge/codec/) 另行放置（`0038` = DOC-POINTER）。
- 可选字段用 CODEC 目标 `0000` 声明。省略的位置写 ABSENT（`0x0000`）（[CODEC](/zh/grammar/edge/codec/) 可选字段）。
- 字段顺序是 FIELD #2、#4 在文档中的排列顺序。Edge Id 不必连续（LOCAL AUTO INCREMENT 是建议）。

## 未决问题

- 重复。像 `CALL` 的"参数 × 参数个数"这样由前面的原始值决定个数的构成。目前无法声明。
- 具有子格式（Codec 专属 TAG）的 Codec（WORLD 等）的声明方法。
- 查找 Issuer 格式规格文档的方法（Issuer·格式编号 → 规格文档地址）。
- `SPEC-VERSION` 指的是直接码规格文档的哪个版本组合。

## 相关页面

- [FIELD](/zh/grammar/edge/field/)、[ENUM](/zh/grammar/edge/enum/)、[CODEC](/zh/grammar/edge/codec/)、[BIND](/zh/grammar/edge/bind/)
- [Edge](/zh/grammar/edge/)、[Codec 规格文档](/zh/grammar/codec-spec/)
