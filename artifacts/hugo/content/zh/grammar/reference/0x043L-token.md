---
title: "TOKEN-0·TOKEN-1 (0x043L·0x044L)"
weight: 67
date: 2026-11-07T12:00:00+09:00
lastmod: 2026-11-07T20:00:00+09:00
tags: ["grammar", "reference"]
summary: "TOKEN 是指向 GEUL 词元词表中某一条目的 2 WORD Reference。把连续的 TOKEN 记录的字节连起来，就得到原来的文本。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | TOKEN-0 | TOKEN-1 |
|---|---|---|
| 名称 | `TOKEN-0`（规格文档 BIND `TOKEN-0`） | `TOKEN-1`（规格文档 BIND `TOKEN-1`） |
| TAG ID | `0x043L` | `0x044L` |
| Codec ID | `0x00000430` | `0x00000440` |
| 规格文档 | `0x00000000/codecs/0x00000430/`（DECLARE 目标 `0430`） | `0x00000000/codecs/0x00000440/`（DECLARE 目标 `0440`） |
| 章节 | 2 `0010`（Reference 其他），章节内偏移 C = 3 | 2 `0010`，C = 4 |
| Kind | Reference · 分类：声明 | Reference · 分类：声明 |
| TAG WORD | `0000 0100 0011 LLLL` | `0000 0100 0100 LLLL` |
| 词元 ID | `0`~`65,535` | `65,536`~`131,071` |
| Hugo 侧 | `reference/token.md` | `reference/token.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `token-id` | #2 | 原始值 1 WORD |  | ENUM 60,536 个（词元 ID `0x0000`~`0xEC77`）。例：`0x0000` `<0x00>`, `0x021B` 가, `0x2DE5` ` the`, `0xE75E` 한국 … |

TOKEN 是指向 GEUL 词元词表中某一条目的 Reference。词表是以韩语和英语为对象训练的 BPE（Byte Pair Encoding）词表，一个条目就是一个字节序列。把连续的 TOKEN 记录的字节序列按顺序连起来，就得到原文本的字节。

- 词表在 65,536 条以内时只用 TOKEN-0。超过时，溢出的条目放在 TOKEN-1。即使不使用 TOKEN-1，第一个 Codec 的名称也是 TOKEN-0。
- 一个词元写成一条记录。因为大小固定为 2 WORD，词元序列的第 k 条记录位于距起点 4k 字节处。

## 布局 {#레이아웃}

```
TAG WORD          0x0431 (0000 0100 0011 0001)  TOKEN-0, 总计 2 WORD
Payload WORD 1st (16 位)           词元 ID (uint16)

TAG WORD          0x0441 (0000 0100 0100 0001)  TOKEN-1, 总计 2 WORD
Payload WORD 1st (16 位)           词元 ID − 65,536 (uint16)
```

- 代码：Reference 直接代码 `0x043L`·`0x044L`（章节 2）。
- Payload 是目标 ID。按 [Reference 通用布局](_index.md)，它是以最短宽度书写的无符号大端整数，但目标 ID 始终是 `0`~`65,535`，所以 Payload 始终是 1 WORD（`0` 为 `0x0000`）。
- 没有量化（量化只在 5Q 体系中读取）。

## 解释与有效性 {#해석과-유효성}

- 各 Codec 的目标 ID 就是 Payload 值。整个词表中的词元 ID，TOKEN-0 为目标 ID，TOKEN-1 为 65,536 + 目标 ID。
- 词元的正式表示是其 Codec 的规格文档。每个词元 ID 在 FIELD `token-id` 上有一个 [ENUM](../edge/0x0BDL-enum.md)，通过 [BIND](../edge/0x0A3L-bind.md) 绑定到该 ENUM Edge Id 的名称就是词元的字节序列。TOKEN-1 的 ENUM 代码值是 Payload 值（词元 ID − 65,536）。
- 词表是封闭列表。规格文档中没有 ENUM 的词元 ID 为 invalid。此 Codec 规则优先于 ENUM 的一般规则（“未声明的代码值不是错误”）。
- **字节词元：** 词元 ID `0`~`255` 是单个字节。词元 ID 就是字节值。词表中没有的字，例如韩语和英语之外的字符，把其 UTF-8 字节写成字节词元。字节词元的 BIND 名称是机器名称 `<0x00>`~`<0xFF>`，其含义由本规则规定。
- **其他词元：** 字节序列是合法的 UTF-8，BIND 名称就是该字节序列本身。
- **解码：** 从头依次读 TOKEN 记录序列，把各词元的字节序列连起来。由连续的字节词元组成的 UTF-8 字符也通过这种连接还原。结果与编码前的文本逐字节相同。
- **编码：** 把文本分成词元序列的方法（切分规则和合并顺序）属于词表版本。同一文本，词表版本不同，词元序列可能不同。解码结果与版本无关，始终相同。
- **版本：** 词表版本就是规格文档的版本。每个版本把词表文件和训练记录的哈希，写成规格文档 HEAD 的 [SOURCE](../edge/0x0C0L-source.md)。需要说明生成词元序列所用的版本时，一并保留该版本（[CODEC-POINTER](0x042L-codec-pointer.md)（`0x00000000`、`0x00000430`、版本 ID `n`））。
- **只追加：** 新版本只在末尾追加 ENUM 和 BIND。一旦给出的词元 ID 的字节序列不会改动，不会删除，也不会重写。因此任何版本都是前一版本的超集，用前一版本生成的词元序列用后一版本解码也完全相同。若从头重新训练词表而使含义改变，则不使用本 Codec，而是另取新的 Codec 编号。
- 词元是 Reference，所以可以成为 [BIND](../edge/0x0A3L-bind.md)、[LABEL](../edge/0x0A4L-label.md)、[TRIPLE](../edge/0x0AAL-triple.md) 的主语（例如词元的出现频率、语言）。

## 长度 {#길이}

- 总长为 TAG 1 WORD 与 Payload 1 WORD 之和，恰好 2 WORD，使用直接长度 `LLLL=0001`。没有 Length 扩展 TAG、Codec 扩展 TAG、Codec 专用 TAG。
- Payload 不是恰好 1 WORD 时拒绝。

## 示例 {#예시}

这是词表第 1 版（规格文档 `0x00000000/codecs/0x00000430` 版本 1）的编号。共分配 60,536 个词元：字节 256、基本字符 283（空格·换行·制表符、ASCII、韩文字母、符号）、韩文音节 11,172（`0x021B` 가 ~ `0x2DBE` 힣）、合并词元 48,825。`0xEC78`~`0xFFFF` 留空，供日后追加。

| 词元（字节序列） | 词元 ID | 完整 WORD |
|---|---|---|
| 字节 `0xE3` | `0x00E3` | `0431 00E3` |
| `가` | `0x021B` | `0431 021B` |
| ` the` （前面带空格） | `0x2DE5` | `0431 2DE5` |
| ` GEUL` （前面带空格） | `0x377F` | `0431 377F` |
| `한국어` | `0xD0B8` | `0431 D0B8` |

- 在规格文档中，` the` 是 `ENUM #2 0x2DE5` 以及绑定在其 Edge Id 上的 `BIND " the"`。
- 空格附着在后面的单词上。所以 ` the` 与 `the`（`0x328D`）是不同的词元。

## 未决问题 {#열린-문제}

- 把词元序列放进文档的格式。尚未确定哪个 Edge 或 Value 字段接收 TOKEN 记录序列。
- 编码规范形式。如何在规格文档中写出切分规则和合并顺序，是否把同一文本的词元序列定为唯一一个。
- 版本之间的解释。读取方遇到比自己所持版本更新的词元 ID 时，是作为 invalid 丢弃，还是保留原值并当作“未知词元”处理。

## 相关页面 {#관련-페이지}

- [Reference](_index.md)、[CODEC-POINTER](0x042L-codec-pointer.md)
- [Codec 规格文档](../codec-spec.md)、[ENUM](../edge/0x0BDL-enum.md)、[BIND](../edge/0x0A3L-bind.md)、[SOURCE](../edge/0x0C0L-source.md)
- 同类注册表：[LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000430/latest.geul` 的样子（十六进制为大写）。 HEAD 中的两个 SOURCE 分别是词表文件和训练记录的 SHA-256。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000043000000000
#121077 SOURCE #0 ABSENT
#121078 QUALIFIER P4092 #121077 SHA-256-DIGEST(0xE4DEEA8BA9FE74BEAAD836FEBE06CF4DAC32B30D1E9A85308D0A6E0A9CB6A417)
#121079 SOURCE #0 ABSENT
#121080 QUALIFIER P4092 #121079 SHA-256-DIGEST(0x5B2C82701BCFFD3589DC9640B398B3F07F0AC7F18E483486AF5221C3D30D4D9C)
BODY
#1 DECLARE 0x0430
#2 FIELD #1 0x0001
#3 BIND #1 "TOKEN-0"
#4 BIND #2 "token-id"
#5 ENUM #2 0x0000
#6 BIND #5 "<0x00>"
#7 ENUM #2 0x0001
#8 BIND #7 "<0x01>"
… （省略 ENUM·BIND 121,064 行）
#121073 ENUM #2 0xEC76
#121074 BIND #121073 "etap"
#121075 ENUM #2 0xEC77
#121076 BIND #121075 " Aman"
```
