---
title: "LANGUAGE-SHORT-CODE"
weight: 73
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-SHORT-CODE 是用 1 WORD 承载一个由 GEUL Language Registry 编号的 BCP 47 tag 的 GEUL 语言码 Value（Codec 0x48）。注册表就是该 Codec 规格文档中的 ENUM。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-SHORT-CODE 是 GEUL 压缩语言码，用 1 WORD 承载一个在 GEUL Language Registry 中分配了编号的 BCP 47 tag。Payload 恰好是 1 WORD。

## 布局

- 代码：Value 直接代码 `0x48`。族 TEXT。
- Payload 恰好是 1 WORD 的 unsigned 16 位代码。

```
TAG WORD          0x08C8 (0000 1000 1100 1000)  共 2 WORD
Payload WORD 1st (16 位)           GEUL Language Registry 编号 (uint16)
```

## 解读与有效性

- 把 Payload 的 1 WORD 读作 unsigned 16 位整数。
- 该值是 GEUL Language Registry 分配的一个 tag。注册表的正式表示是该 Codec 的规格文档 `0x0000/0x0000000000000848`。每个代码值在 FIELD `code` 上有一个 [ENUM](/zh/grammar/edge/enum/)，用 [BIND](/zh/grammar/edge/bind/) 绑定到该 ENUM Edge Id 的名称就是规范大小写的 BCP 47 tag。
- 注册表是封闭列表。规格文档中没有 ENUM 的值是 invalid。此 Codec 规则优先于 ENUM 的一般规则（"未声明的代码值不是错误"）。
- 分配对象有以下三类。
  - IANA Language Subtag Registry 中 `Type: language` 的记录，去掉 `Scope: private-use`（`qaa..qtz`）。collection、macrolanguage、special（`mul`·`und`·`zxx`·`mis`）不排除。
  - IANA 整体登记的 tag：grandfathered 与 redundant（`zh-Hans`、`sr-Latn`、`zh-min-nan` 等）。
  - 在公开 CC0 来源中观测到的有效组合 tag（`pt-BR`、`en-GB`、`be-tarask` 等）。只由 language·extlang·script·region·variant subtag 组成。含 extension（`-u-`·`-t-`）或 private-use（`-x-`）的 tag 不收。
- 没有编号的 tag 不能用此格式书写，改用 [LANGUAGE-BCP47-CODE](/zh/grammar/value/text/language-bcp47-code/)（`0x46`·`0x47`）。SHORT-CODE 内没有 escape 路径。
- `0x0000` 与 `0xffff` 永不分配。在此 Value 中两者都是 invalid。两者都不用来表示 `null`·`unknown`·`und`。
- 值的区间是分配惯例。解码器不根据值的范围推断 tag 的种类。值的含义只来自规格文档。

| 区间 | 用途 |
|---|---|
| `0x0000` | 不分配（invalid） |
| `0x0001`–`0x3fff` | 只有一个 language subtag 的 tag |
| `0x4000`–`0x7fff` | 由两个以上 subtag 组成的 tag（IANA 整体 tag、观测到的组合 tag） |
| `0x8000`–`0xfffe` | 溢出区。上面的区块满了就在这里继续分配 |
| `0xffff` | 不分配（invalid） |

- 初版在区块内按 tag 的小写 ASCII 顺序编号。`0x4000` 区块先是 IANA 整体 tag（grandfathered 与 redundant 混合，ASCII 顺序），后是观测到的组合 tag（ASCII 顺序）。IANA 文件的物理顺序和使用频率都不是编号规则。
- 分配只追加（append-only）。新 tag 追加到所属区块末尾，区块满了就追加到溢出区。已给出编号的 tag（不区分大小写）不更改、不删除、不重用。
- 新 tag 通过在规格文档的新版本中追加 ENUM 与 BIND 加入。已有的 ENUM·BIND 不修改。因此任何版本都是前一版本的超集。
- 65,534 个编号全部用完后不再分配。之后的新 tag 用 LANGUAGE-BCP47-CODE 书写。表达力不减，只是没有压缩收益。
- 同一语言：SHORT-CODE `n` 与注册表绑定到 `n` 的 tag 的 LANGUAGE-BCP47-CODE（不区分大小写）是同一种语言。
- 注册表的版次就是规格文档的版本。每个版次把所依据的 IANA registry 文件（File-Date、SHA-256）作为规格文档 HEAD 中的 [SOURCE](/zh/grammar/edge/source/) 记录。需要说明解读某值所用的版次时，一并保留该版本（`0x0000/0x0000000000000848@n`）。
- Codec 规格可以把同样的 1 WORD 代码放进没有 TAG 的原始值字段（原始值字段的 [CODEC](/zh/grammar/codec-spec/#codec)）。那是该 Codec 规格的规则，独立 Value 的 wire form 始终是 TAG 1 WORD + Payload 1 WORD。

## 标准依据

- tag 的含义与 subtag 的有效性遵循 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry) 与 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)。IANA 与 IETF 把其对协议注册表的权利置于 CC0 1.0 之下（[IANA Licensing Terms](https://www.iana.org/help/licensing-terms)）。
- 注册表编号（按 ASCII 顺序 append-only 分配、区块构成、`0x0000`·`0xffff` 不分配、封闭列表）、规格文档的 ENUM 是正式表示、以及与无 TAG 原始值字段 embedding 的区分，是 GEUL 规则。

## 长度

- 总长恰好是 TAG 1 WORD 加 Payload 1 WORD 共 2 WORD，使用直接长度 `LLLL=0001`。没有 Length 扩展 TAG、descriptor、padding。
- Payload 不恰好是 1 WORD 时拒绝。

## 示例

以下是注册表 v2（规格文档 `0x0000/0x0000000000000848` 版本 2，IANA File-Date 2026-09-17）的编号。共分配 8,678 个（language 8,275、grandfathered 26、redundant 67、观测组合 310）。

| tag | 代码 | 全部 WORD |
|---|---|---|
| `en` | `0x0784` | `08C8 0784` |
| `ko` | `0x0d06` | `08C8 0D06` |
| `zh-Hans` | `0x404c` | `08C8 404C` |
| `pt-BR` | `0x4130` | `08C8 4130` |

- 在规格文档中，`en` 是 `ENUM #2 0x0784` 以及绑定到其 Edge Id 的 `BIND "en"`。
- `de-x-formal`（private-use）、`nl-u-sd-bebru`（extension）没有编号，所以用 LANGUAGE-BCP47-CODE 书写。

## 未决问题

- 跨版次解读：遇到比读取方所持版次更新的编号时，是作为 invalid 丢弃，还是保留原值当作"未知代码"。由于 append-only，最新版次总是足够，但离线解码器需要规则。
- 规范形：有编号的 tag 是否应当（SHOULD/MUST）用 SHORT-CODE 书写。若为 MUST，写法唯一，但新版次发布后此前写的文档就不再是规范形。
- 在规格文档中表示 deprecated tag 与 Preferred-Value 的方法（当前版次没有）。
- 追加观测组合 tag 的程序（来源、观测下限）。

## 相关页面

- [LANGUAGE-BCP47-CODE](/zh/grammar/value/text/language-bcp47-code/)、[UTF8-LANGUAGE-TEXT](/zh/grammar/value/text/utf8-language-text/)、[LABEL](/zh/grammar/edge/label/)
- [Codec 规格文档](/zh/grammar/codec-spec/)、[ENUM](/zh/grammar/edge/enum/)、[BIND](/zh/grammar/edge/bind/)、[SOURCE](/zh/grammar/edge/source/)
