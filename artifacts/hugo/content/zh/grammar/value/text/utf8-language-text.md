---
title: "UTF8-LANGUAGE-TEXT"
weight: 75
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT 是把一条语言 Value 记录和 UTF-8 文本放入一个 Value 的带语言文本（Codec 0x4A/0x4B）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT 是带语言的文本。把一条语言 Value 记录和 UTF-8 字节序列放入一个 Value。

[UTF8-TEXT](/zh/grammar/value/text/utf8-text/) 是没有语言的字符串（标识符、代码、文件名、原文字节），本格式是有语言的文本（名称、标题、标语、句子）。二者即使字节相同也是不同的值。"Paris"（字符串）与 "Paris"（法语）并不相同。这与 RDF 区分 `xsd:string` 和 `rdf:langString` 相同。

## 布局

- 码：Value 直接码 `0x4A`（文本为偶数字节）·`0x4B`（文本为奇数字节）。系列 TEXT。

```
TAG WORD          0000 1LLL L100 101P      Codec 0x4A/0x4B (P = 文本为奇数字节)
[Length 扩展 TAG] 总计 15 WORD 以上时
Language          LANGUAGE-SHORT-CODE 或 LANGUAGE-BCP47-CODE Value 记录 1 个 (含 TAG)
Text WORD 1st ... Nth             UTF-8 bytes / 奇数则末尾为 0x00
```

## 解读与有效性

- Payload 以语言记录开头。把 Payload 的第一个 WORD 读作 TAG，其 Length 范围是语言记录，其余是文本字节。语言记录是必需的。没有语言就不用本格式，而用 UTF8-TEXT。
- 语言记录恰好是一条完整的 [LANGUAGE-SHORT-CODE](/zh/grammar/value/text/language-short-code/)（`0x48`）或 [LANGUAGE-BCP47-CODE](/zh/grammar/value/text/language-bcp47-code/)（`0x46`·`0x47`）记录。其他 Codec 或不完整则 invalid。语言记录的有效性遵循该格式的规则。
- 两种语言格式都可以使用。比较是否同一语言的规则与 [LABEL](/zh/grammar/edge/label/) 相同。SHORT-CODE 与注册表绑定到该编号的 BCP 47 tag 是同一种语言。
- 不使用 `zxx`（无语言内容）。这样的字符串是 UTF8-TEXT。`und`（语言未定）和 `mul`（多种语言）是有语言的文本，所以可以使用。
- 文本字节遵循与 UTF8-TEXT 相同的规则。必须是 well-formed UTF-8，禁止开头的 BOM，不强制规范化，原样保留原文。由比较·索引的一方对齐为 NFC 后比较。
- 文本字节数是 `2 × (Payload WORD 数 − 语言记录 WORD 数) − P`。P（Codec 最低位）只表示文本字节的奇偶。为奇数时，最后一个 WORD 的低 byte 必须是 `00`。
- 空文本（0 byte）在偶数码上只放语言记录。

## 使用位置

- Wikidata monolingualtext 值：`{"text":"Bundesrepublik Deutschland","language":"de"}` 成为一个本格式的 Value。原样放入 [TRIPLE](/zh/grammar/edge/triple/) 的 Object、[QUALIFIER](/zh/grammar/edge/qualifier/) 的 Value。属性·rank·qualifier 由 TRIPLE 负责。
- [LABEL](/zh/grammar/edge/label/)·[ALIAS](/zh/grammar/edge/alias/) 的 Object。名称和语言由这一个值承载。
- 法令·论文标题这样语言已定的文本。

## 语言码对应（Wikidata）

- Wikidata·Wikimedia 的语言码并不全是 BCP 47（例：`simple`、`map-bms`）。通过对应表转换为 BCP 47 tag。无法转换的码根据用途分别处理。
  - 值（monolingualtext）：把 datavalue 原文以 UTF8-TEXT 保留。值是命题的一部分，丢弃则命题会改变。
  - 标签·说明·别名：跳过并记入报告。这些 Edge 必须有语言才成立（没有语言的文本 invalid），原文保留在来源数据中。
- 对应后的 tag 若在 GEUL Language Registry 中有编号，用 LANGUAGE-SHORT-CODE 书写，否则用 LANGUAGE-BCP47-CODE。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、语言记录、文本 WORD 之和。14 WORD 以下用直接长度，15 WORD 以上用扩展长度（[Length](/zh/grammar/record/)）。
- 语言记录为 SHORT-CODE 时是 2 WORD，为 BCP 47 时是 `ceil(tag 字节/2) + 1` WORD（`de` 2 WORD，`zh-Hant` 5 WORD）。

## 示例

语言都是 LANGUAGE-BCP47-CODE 格式的示例。`fr`·`ko`·`de` 有注册表编号，也可以写成 SHORT-CODE（2 WORD）。

| 值 | 文本字节 | 总计 WORD |
|---|---|---|
| "Paris" (fr) | 5（奇数） | `0ACB 08C6 6672 5061 7269 7300` |
| "" (ko) | 0 | `094A 08C6 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26（偶数） | `0F4A 0011 08C6 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris"：TAG `0ACB`（Codec `0x4B`，`LLLL=0101`，总计 6 WORD），语言 `08C6 6672`（BCP 47 `fr`），文本 `5061 7269 7300`（5 byte，末尾 `00`）。
- 第三个总计 17 WORD，所以使用 Length 扩展（`0F4A` 的 `LLLL=1110`，扩展 TAG `0011`）。

## 标准依据

- 语言 tag：[RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646)。`zxx`·`und`·`mul` 是 IANA Language Subtag Registry 的 special 码。
- 文本：[RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)。
- 字符串与带语言文本的区分：[RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string)。

## 未决问题

- schema 的 BCP 47 tag 语法检查。目前只检查是 ASCII 且非空。

## 相关页面

- [Value](/zh/grammar/value/)、[UTF8-TEXT](/zh/grammar/value/text/utf8-text/)、[LANGUAGE-SHORT-CODE](/zh/grammar/value/text/language-short-code/)、[LANGUAGE-BCP47-CODE](/zh/grammar/value/text/language-bcp47-code/)、[LABEL](/zh/grammar/edge/label/)
