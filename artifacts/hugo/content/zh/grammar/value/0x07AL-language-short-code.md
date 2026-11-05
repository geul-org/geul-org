---
title: "LANGUAGE-SHORT-CODE (0x07AL)"
weight: 122
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE 是以 1 WORD 承载 GEUL Language Registry 中已分配编号的一个 BCP 47 tag 的 GEUL 压缩语言码。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `LANGUAGE-SHORT-CODE`（规格文档 BIND `LANGUAGE-SHORT-CODE`） |
| TAG ID | `0x07AL` |
| Codec ID | `0x000007A0` |
| 规格文档 | `0x00000000/codecs/0x000007A0/`（DECLARE 对象 `07A0`） |
| 章节 | 3 `0011`（Value），章节内偏移 C = 26 |
| Kind | Value · 系列：TEXT |
| TAG WORD | `0000 0111 1010 LLLL`（`000K KKKC CCCC LLLL`） |
| 索引说明 | 以 GEUL Language Registry 编号书写的 BCP 47 tag（Payload 1 WORD） |
| Hugo 路径 | `value/text/language-short-code.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | 原始值 1 WORD |  | ENUM 8678 个。例：`0x0001` aa, `0x0002` aaa, `0x0003` aab, `0x0004` aac, `0x0005` aad … |

LANGUAGE-SHORT-CODE 是以 1 WORD 承载 GEUL Language Registry 中已分配编号的一个 BCP 47 tag 的 GEUL 压缩语言码。Payload 恰好为 1 WORD。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x07AL`。系列 TEXT。
- Payload 恰好是 1 WORD 的 unsigned 16 位代码。

```
TAG WORD          0x07A1 (0000 0111 1010 0001)  总计 2 WORD
Payload WORD 1st (16位)             GEUL Language Registry 编号 (uint16)
```

## 解释与有效性 {#해석과-유효성}

- 将 Payload 1 WORD 读作 unsigned 16 位整数。
- 该值是 GEUL Language Registry 所分配的一个 tag。注册表的正式表示是此 Codec 的规格文档 `0x00000000/codecs/0x000007A0`。每个代码值在 FIELD `code` 中都有一个 [ENUM](../edge/0x0BDL-enum.md)，通过 [BIND](../edge/0x0A3L-bind.md) 绑定到该 ENUM Edge Id 的名称，就是规范大小写的 BCP 47 tag。
- 注册表是封闭列表。规格文档中没有 ENUM 的值为 invalid。此 Codec 规则优先于 ENUM 的一般规则（“未声明的代码值不是错误”）。
- 分配对象有以下三类。
  - IANA Language Subtag Registry 的 `Type: language` 记录中，去掉 `Scope: private-use`（`qaa..qtz`）的部分。collection、macrolanguage、special（`mul`·`und`·`zxx`·`mis`）不去掉。
  - IANA 整体登记的 tag：grandfathered 和 redundant（`zh-Hans`、`sr-Latn`、`zh-min-nan` 等）。
  - 在公开的 CC0 来源中观察到的有效组合 tag（`pt-BR`、`en-GB`、`be-tarask` 等）。只由 language、extlang、script、region、variant subtag 构成的 tag。含 extension（`-u-`·`-t-`）和 private-use（`-x-`）的 tag 不接收。
- 没有编号的 tag 不能用此格式书写。用 [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)（`0x076L`·`0x077L`）书写。SHORT-CODE 内部没有 escape 路径。
- `0x0000` 和 `0xFFFF` 永久不分配。在此 Value 中两者均为 invalid。两者都不用作 `null`·`unknown`·`und` 的含义。
- 值的区间是分配惯例。解码器不根据值的范围推测 tag 的种类。值的含义只来自规格文档。

| 区间 | 用途 |
|---|---|
| `0x0000` | 未分配（invalid） |
| `0x0001`–`0x3FFF` | 只有一个 language subtag 的 tag |
| `0x4000`–`0x7FFF` | 含两个以上 subtag 的 tag（IANA 整体 tag、观察到的组合 tag） |
| `0x8000`–`0xFFFE` | 溢出。上述区块已满时在此接续分配 |
| `0xFFFF` | 未分配（invalid） |

- 初版在区块内按 tag 的小写 ASCII 顺序给号。`0x4000` 区块先是 IANA 整体 tag（grandfathered 与 redundant 混合的 ASCII 顺序），其后是观察到的组合 tag（ASCII 顺序）。IANA 文件的物理顺序和使用频率不是编号规则。
- 分配只追加（append-only）。新 tag 追加在区块末尾，区块已满则追加到溢出区间。已给出编号的 tag（忽略大小写）不更改，不删除，也不复用。
- 新 tag 通过在规格文档的新版本中追加 ENUM 和 BIND 加入。不修改既有 ENUM·BIND。因此任何版本都是前一版本的超集。
- 65,534 个全部分配完后不再分配。其后的新 tag 用 LANGUAGE-BCP47-CODE 书写。表达力不减，只是没有压缩收益。
- 同一语言：SHORT-CODE `n` 与注册表绑定到 `n` 的 tag 的 LANGUAGE-BCP47-CODE（忽略大小写）是同一种语言。
- 注册表版本就是规格文档的版本。每一版都把作为依据的 IANA registry 文件（File-Date、SHA-256）写成规格文档 HEAD 的 [SOURCE](../edge/0x0C0L-source.md)。需要说明解释该值所用的版本时，一并保留该版本（[CODEC-POINTER](../reference/0x042L-codec-pointer.md)（`0x00000000`、`0x000007A0`、版本 ID `n`））。
- Codec 规格可以把同一个 1 WORD 代码作为无 TAG 的原始值字段承载（原始值字段的 [CODEC](../codec-spec.md#codec)）。这是该 Codec 规格的规则，独立 Value 的 wire form 始终是 TAG 1 WORD + Payload 1 WORD。

## 标准依据 {#표준-근거}

- tag 的含义和 subtag 的有效性遵循 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) 和 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)。IANA·IETF 对协议注册表的权利以 CC0 1.0 释出（[IANA Licensing Terms](https://www.iana.org/help/licensing-terms)）。
- 注册表编号（ASCII 顺序 append-only 分配、区块构成、`0x0000`·`0xFFFF` 不分配、封闭列表）、规格文档 ENUM 为正式表示这一点，以及与无 TAG 原始值字段 embedding 的区分，都是 GEUL 规则。

## 长度 {#길이}

- 总长为 TAG 1 WORD 与 Payload 1 WORD 之和，恰好 2 WORD，使用直接长度 `LLLL=0001`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不是恰好 1 WORD 时拒绝。

## 示例 {#예시}

这是注册表 v2（规格文档 `0x00000000/codecs/0x000007A0` 版本 2，IANA File-Date 2026-09-17）的编号。共分配 8,678 个（language 8,275、grandfathered 26、redundant 67、观察到的组合 310）。

| tag | 代码 | 总 WORD |
|---|---|---|
| `en` | `0x0784` | `07A1 0784` |
| `ko` | `0x0D06` | `07A1 0D06` |
| `zh-Hans` | `0x404C` | `07A1 404C` |
| `pt-BR` | `0x4130` | `07A1 4130` |

- 在规格文档中，`en` 是 `ENUM #2 0x0784` 以及绑定到该 Edge Id 的 `BIND "en"`。
- `de-x-formal`（private-use）、`nl-u-sd-bebru`（extension）没有编号，因此用 LANGUAGE-BCP47-CODE 书写。

## 未决问题 {#열린-문제}

- 版本间解释：遇到比读取方所持版本更新的编号时，是作为 invalid 丢弃，还是保留原值并作为“未知代码”处理。因为是 append-only，最新版一份总是足够，但需要为离线解码器制定规则。
- 规范形式：有编号的 tag 是否必须（SHOULD/MUST）用 SHORT-CODE 书写。若为 MUST，写法唯一确定，但新版本发布后，先前写成的文档就不再是规范形式。
- 在规格文档中表示 deprecated tag 与 Preferred-Value 的方法（当前版本中没有）。
- 追加观察到的组合 tag 的流程（来源、观察下限）。

## 相关页面 {#관련-페이지}

- [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)、[UTF8-LANGUAGE-TEXT](0x078L-utf8-language-text.md)、[LABEL](../edge/0x0A4L-label.md)
- [Codec 规格文档](../codec-spec.md)、[ENUM](../edge/0x0BDL-enum.md)、[BIND](../edge/0x0A3L-bind.md)、[SOURCE](../edge/0x0C0L-source.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x000007A0/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007A000000000
#17368 SOURCE #0 #17362
#17369 QUALIFIER P577 #17368 GREGORIAN-DATE(2026-09-17)
#17370 QUALIFIER P813 #17368 GREGORIAN-DATE(2026-10-29)
#17371 QUALIFIER P4092 #17368 SHA-256-DIGEST(0x755FAD43283BE7B41EBE3C89AD054B6EAF928F404F9C0EDB74799E0EAB74BEB1)
#17372 SOURCE #0 Q2013
#17373 QUALIFIER P813 #17372 GREGORIAN-DATE(2026-10-29)
BODY
#1 DECLARE 0x07A0
#2 FIELD #1 0x0001
#3 BIND #1 "LANGUAGE-SHORT-CODE"
#4 BIND #2 "code"
#5 ENUM #2 0x0001
#6 BIND #5 "aa"
#7 ENUM #2 0x0002
#8 BIND #7 "aaa"
#9 ENUM #2 0x0003
#10 BIND #9 "aab"
#11 ENUM #2 0x0004
#12 BIND #11 "aac"
#13 ENUM #2 0x0005
#14 BIND #13 "aad"
… (省略 ENUM·BIND 17346 行)
#17361 REFERENCE-NODE #17362 <https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry>
#17363 TRIPLE P275 #17362 Q6938433 normal
#17364 REFERENCE-NODE #17365 <https://www.iana.org/help/licensing-terms>
#17366 SOURCE #17363 #17365
#17367 QUALIFIER P813 #17366 GREGORIAN-DATE(2026-10-29)
```
