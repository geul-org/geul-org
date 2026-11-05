---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE 是声明一个 Codec 的 Payload 构成的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DECLARE`（规格文档 BIND `DECLARE`） |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| 规格文档 | `0x00000000/codecs/0x00000BB0/`（DECLARE 目标 `0BB0`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 27 |
| Kind | Edge · 系列：陈述，分组：其他 |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 声明一个 Codec 的 Payload 构成。目标 Kind·Codec |
| Hugo 侧 | `edge/declare.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | 原始值 1 WORD |  |  |
| 2 | `issuer` | #3 | 剩余原始值（`0xFFFF`） |  |  |

DECLARE 是声明一个 Codec 的 Payload 构成的陈述 Edge。Codec `0x0BBL`。

它与 [FIELD](0x0BCL-field.md)（`0x0BCL`）、[ENUM](0x0BDL-enum.md)（`0x0BDL`）、[CODEC](0x0BEL-codec.md)（`0x0BEL`）一起，是编写 Codec 规格所用的词汇（[Codec 规格文档](../codec-spec.md)）。这四个 Edge 的布局内置于解码器。用这套词汇写成的各 Codec 规格文档是一般文档。一份规格同时用于验证、分解、显示（查看器）。查看器不为每个 Codec 另设代码，而是按规格绘制。

## 布局 {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
目标              1 WORD。只使用被声明 Codec 的 TAG WORD 中的 Codec 位置（章节和 C）(LLLL = 0)
[Issuer·Codec 编号] 声明 Issuer Codec 时。Issuer 和 Codec 编号共 2 WORD。与 Codec 扩展 TAG 布局相同，三种 Kind 相同
                  ISSUER 码自身的规格文档（GEUL Issuer）只放目标
```

- 字段列表不放在 DECLARE 中。每个 [FIELD](0x0BCL-field.md) 指向自己的 DECLARE，这些 FIELD 在文档内的顺序就是 Payload 字段顺序。

## 解释规则 {#해석-규칙}

这是依据 Codec 规格读取并表示记录的规则。

- 原始值字段按 FIELD 声明的固定 WORD 数读取。有一个字段可以是剩余原始值（宽度 `0xFFFF`），读取的是剩余 WORD 减去其后固定字段宽度之后的部分。剩余字段之后只放固定宽度的原始值。
- 记录字段以 TAG WORD 开头，按该 TAG 的 Length 读取。
- 原始值字段是 n WORD 大端无符号整数。表示为 `0x` + 宽度×4 位 hex，若有相同值的 ENUM，则同时表示其 BIND 名称。
- 记录字段的含义由该记录的 Codec 规格决定。符号、小数、日期这类需要解释的值，不作为原始值而作为 Value 记录放置。

除此之外没有其他边界规则。可变原始值有两个以上、可变原始值之后出现记录或可变字段、原始值宽度随其他字段值或文档状态而变化的 Codec，不能用这套词汇声明。这类布局把可变部分包成记录，只保留一个（例：SIGNATURE 的签名者是 Reference 记录）。

## 有效性 {#유효성}

- 目标的 Kind 是 Reference、Value、Edge、Meta 之一。GEUL 直接码的规格文档每个码一份。Reference 的 5Q 体系也按量化码分别声明（LOCAL Identified `0050`、Generic `0060` …）。指针（`0x040L`、`0x041L`、`0x042L`）、占位标记、ISSUER 码也是各自的码本身。由 ISSUER 码之后的 Issuer·Codec 编号确定的 Issuer Codec，由该 Issuer 的文档定义。
- [占位标记](../slot-marker.md)（Reference `0x000L~0x002L`）也是 DECLARE 的目标。没有 Payload，所以不设 FIELD，只放 DECLARE。标记的含义和接受规则内置于解码器（第 0 层）。尚未确定布局的 Codec（SUPERSEDE-CHAIN、VERDICT、EVIDENCE 等）也只放 DECLARE。
- Edge 的 Edge Id 不用 FIELD 声明。它是所有 Edge 的第一个元素，因而是隐含的（[Edge](_index.md)）。EDGE-ISSUER 的 Edge Id 是 Issuer·Codec 编号之后的第一个元素（[EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)）。
- DECLARE 的字段是指向它的那些 FIELD，可以是 0 个。一个 FIELD 只属于一个 DECLARE。即使字段形状相同，每个 DECLARE 也要另放 FIELD。
- DECLARE 中除了目标（以及 Issuer 格式目标的 Issuer·Codec 编号）之外什么都没有。
- 依次读完各字段后的游标必须与记录末尾恰好吻合。多出或不足，该记录即违反规格。
- 同一文档中不对同一目标声明两次。
- 尾部字段不同的变体不用分支表示。每个 Codec 另放 DECLARE。

## 规格文档 {#규격-문서}

- 直接码的规格文档是 GEUL Issuer `0x00000000` 的 Codec 文档。Codec ID 是目标 TAG WORD（L=0）写成 32 位的值（`0x0B80` → `0x00000B80`），在 `<Issuer>/codecs/<Codec ID>/` 以版本 ID 和 `versions.geul` 公布（[Codec 规格文档](../codec-spec.md)）。
- Issuer Codec 的 Codec 文档放在该 Issuer 的 `<Issuer>/codecs/<Codec 编号>/` 中。Codec 编号与 Kind 无关，在该 Issuer 内不得重复。解释器若发现记录的 Kind 与 DECLARE 目标的 Kind 不同，则视为错误（[公布地址与版本列表](../publishing.md#id-표기)）。
- 一份规格文档只有一个 DECLARE，其目标必须与 Codec ID 的 TAG WORD 相同。`DOC-ID` 是 [CODEC-POINTER](../reference/0x042L-codec-pointer.md)（`0x00000000`，该 Codec ID，`0`）。

## 名称 {#이름}

- Codec 名称用 [BIND](0x0A3L-bind.md) 绑定到 DECLARE 的 Edge Id（例：`PUBLICATION`）。附在 DECLARE·FIELD·ENUM·CODEC 上的 UTF8-TEXT 全都用 BIND，不用 LABEL 等其他 Edge 附加。
- 字段名称和 enum 名称也以同样方式绑定到 FIELD·ENUM。

## 示例 {#예시}

PUBLICATION（Edge `0x0B8L`）的规格文档 `0x00000000/codecs/0x00000B80/`：Edge Id 之后是 DOC-POINTER 记录，内容哈希 16 WORD。

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, 记录           (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (Codec 版本列表)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, 原始值 16 WORD (BIND "hash")
```

- DECLARE：TAG 1 + Edge Id 2 + 目标 1 = 4 WORD，`LLLL = 0011`。
- FIELD：TAG 1 + Edge Id 2 + DECLARE 2 + 宽度 1 = 6 WORD（`LLLL = 0101`）。所接受的 Kind·Codec 另用 [CODEC](0x0BEL-codec.md) 放置（`0410` = DOC-POINTER，`0420` = CODEC-POINTER）。
- 可选字段用 CODEC 目标 `0000` 声明。省略的位置写 ABSENT（`0x0000`）（[CODEC](0x0BEL-codec.md) 可选字段）。
- 字段顺序就是 FIELD #2、#4 在文档中的排列顺序。Edge Id 不必连续（LOCAL AUTO INCREMENT 只是建议）。

## 未决问题 {#열린-문제}

- 重复。像 `CALL` 的"参数 × 参数个数"那样，由前面的原始值决定个数的构成。目前无法声明。
- 带有子格式（Codec 专属 TAG）的 Codec（WORLD 等）的声明方法。
- `SPEC-VERSION` 指的是直接码规格文档们的哪一组版本。

## 相关页面 {#관련-페이지}

- [FIELD](0x0BCL-field.md)、[ENUM](0x0BDL-enum.md)、[CODEC](0x0BEL-codec.md)、[BIND](0x0A3L-bind.md)
- [Edge](_index.md)、[Codec 规格文档](../codec-spec.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000BB0/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
