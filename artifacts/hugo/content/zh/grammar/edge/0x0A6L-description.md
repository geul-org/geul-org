---
title: "DESCRIPTION (0x0A6L)"
weight: 166
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION 是把 Subject 对象的某一语言说明作为 Object 连接起来的陈述 Edge。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| 项目 | 值 |
|---|---|
| 名称 | `DESCRIPTION`（规格文档 BIND `DESCRIPTION`） |
| TAG ID | `0x0A6L` |
| Codec ID | `0x00000A60` |
| 规格文档 | `0x00000000/codecs/0x00000A60/`（DECLARE 目标 `0A60`） |
| 章节 | 5 `0101`（Edge 陈述），章节内偏移 C = 6 |
| Kind | Edge · 系列：陈述，分组：指示与名称 |
| TAG WORD | `0000 1010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| 索引说明 | 连接 Subject 的语言说明（description）。布局与 LABEL 相同 |
| Hugo 侧 | `edge/description.md` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档内的顺序就是 Payload 字段顺序（[Codec 规格文档](../codec-spec.md)）。Edge 的 Edge Id 不用 FIELD 声明。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接受的格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | 记录 | 任意记录（占位标记除外） |  |
| 2 | `object` | #3 | 记录 | `0780` UTF8-LANGUAGE-TEXT，`0790` UTF8-LANGUAGE-TEXT，`0050` LOCAL |  |

DESCRIPTION 是把 Subject 对象的某一语言说明作为 Object 连接起来的陈述 Edge。Codec `0x0A6L`。

说明是用来区分对象的简短语句（维基数据 description，例："德国的首都和最大城市"）。它不是对象的定义或主张。关于对象的命题用 [TRIPLE](0x0AAL-triple.md) 书写。布局与 [LABEL](0x0A4L-label.md) 相同。说明及其语言装在一个 Object，即 [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) 里。没有原始值字段。

## 布局 {#레이아웃}

```
TAG WORD          0000 1010 0110 LLLL
[Length 扩展 TAG]
Edge Id           LOCAL Reference 记录
Subject           Reference 记录 1 个
Object            UTF8-LANGUAGE-TEXT Value 或 LOCAL Reference 记录 1 个
```

## 解释与有效性 {#해석과-유효성}

- Subject 和 Object 的规则与 [LABEL](0x0A4L-label.md) 相同。Subject 是恰好一条完整的 Reference 记录。Object 是恰好一条完整的 UTF8-LANGUAGE-TEXT（`0x078L`·`0x079L`）记录，或是通过同一文档的 [REFERENCE-NODE](0x0A0L-reference-node.md) 绑定解析为 UTF8-LANGUAGE-TEXT 的 LOCAL Reference。
- 没有语言的文本（UTF8-TEXT）不能成为 DESCRIPTION。说明每种语言一个，有语言这条规则才成立。多种语言通用的说明用语言 `mul` 书写。
- 同一 Subject、同一语言的 DESCRIPTION 至多一个。
- 说明用于与同名的其他对象相区分。同一语言中 LABEL 与 DESCRIPTION 的组合最好不在两个对象上重复，但规格不检查这一点（维基数据也只是建议，并不强制）。
- geul.org 规格文档用 [CODEC](0x0BEL-codec.md) 限制 Object（`0780`·`0790`·`0050`，与 LABEL 相同）。

## 长度 {#길이}

```
全部 = 1 + N_len + N_id + N_subject + N_object WORD
```

- Object 的语言记录和文本字节数由 Object 记录负责。读完最后一条记录后的游标必须与 Edge 末尾恰好吻合。
- 说明比 label 长，Object 和 Edge 都容易超过 15 WORD。此时使用 Length 扩展（[记录](../record.md)）。

## 示例（非规范） {#예시-비규범}

Edge Id `0009`，Subject Q64（`0141 0040`），Object `capital and largest city of Germany`（en）。语言是 LANGUAGE-BCP47-CODE 格式的示例（`en` 有注册表编号 `0x0784`，也可以用 SHORT-CODE）。

- Object 为语言 `0761 656E`（BCP47 `en`，2 WORD）+ 文本 35 byte（奇数，18 WORD），即 `0x079L`，TAG 1 + 扩展 TAG 1 + 20 = 22 WORD，`079E 0016 …`。
- Edge 为 TAG 1 + 扩展 TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD，所以 `LLLL=1110`，TAG `0A6E`，扩展 TAG `001C`。

```
0A6E 001C 0051 0009 0141 0040
079E 0016 0761 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## 与维基数据的对应 {#위키데이터-대응}

- 条目的 `descriptions`（每种语言一个）→ 每种语言一个 DESCRIPTION。语言码按与 LABEL 相同的语言码对应表转换。

## 未决问题 {#열린-문제}

- 是否存在应当允许没有语言的 UTF8-TEXT 说明的情形（目前不允许）。

## 相关页面 {#관련-페이지}

- [Edge](_index.md)、[LABEL](0x0A4L-label.md)、[ALIAS](0x0A5L-alias.md)、[CODEC](0x0BEL-codec.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)、[LOCAL](../reference/0x005L-local.md)、[REFERENCE-NODE](0x0A0L-reference-node.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000A60/latest.geul` 的结果（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A6000000000
BODY
#1 DECLARE 0x0A60
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DESCRIPTION"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
