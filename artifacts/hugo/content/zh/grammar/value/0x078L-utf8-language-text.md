---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT 是把一个语言 Value 记录和 UTF-8 文本放进同一个 Value 的带语言文本（Codec 0x078L/0x079L）。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT 是把一个语言 Value 记录和 UTF-8 文本放进同一个 Value 的带语言文本（Codec 0x078L/0x079L）。

| 项目 | 值 |
|---|---|
| 名称 | `UTF8-LANGUAGE-TEXT`（奇偶分组。各代码的名称见下方成员表） |
| TAG ID | `0x078L`·`0x079L` |
| 章节 | 3 `0011`（Value），章节内偏移 C = 24~25 |
| Kind | Value · 系列：TEXT |
| 索引说明 | 带语言文本。语言 Value 记录（LANGUAGE-SHORT-CODE 或 LANGUAGE-BCP47-CODE）与 UTF-8 字节。文本字节的偶数·奇数 |
| Hugo 路径 | `value/text/utf8-language-text.md` |

## 成员 {#구성원}

本页同时处理奇偶一对的两个代码。偶数代码的值字节数为偶数，奇数代码的值字节数为奇数（[记录与 TAG WORD](../record.md#가변-길이-바이트열)）。Codec 文档每个代码一份。两份 Codec 文档的字段相同，只有 DECLARE 对象和名称（BIND）不同。

| TAG ID | 名称 | 字节数 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | 偶数 | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | 奇数 | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | 记录 | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | 剩余原始值（`0xFFFF`） |  |  |

UTF8-LANGUAGE-TEXT 是带语言的文本。它把一个语言 Value 记录和 UTF-8 字节序列放进同一个 Value。

[UTF8-TEXT](0x072L-utf8-text.md) 是无语言标注的字符串（标识符、代码、文件名、原文字节），而本格式是有语言的文本（名称、标题、标语、句子）。两者即使字节相同也是不同的值。"Paris"（字符串）与 "Paris"（法语）并不相同。这与 RDF 区分 `xsd:string` 和 `rdf:langString` 相同。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x078L`（文本为偶数字节）·`0x079L`（文本为奇数字节）。系列 TEXT。

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = 文本为奇数字节)
[Length 扩展 TAG] 总计 15 WORD 以上时
Language          LANGUAGE-SHORT-CODE 或 LANGUAGE-BCP47-CODE Value 记录 1 个 (含 TAG)
Text WORD 1st ... Nth             UTF-8 bytes / 奇数时最后为 0x00
```

## 解释与有效性 {#해석과-유효성}

- Payload 以语言记录开头。将 Payload 第一个 WORD 当作 TAG 读取，其 Length 长度的部分是语言记录，其余是文本字节。语言记录是必需的。没有语言时不用本格式，而用 UTF8-TEXT。
- 语言记录恰好是一个完整的 [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md)（`0x07AL`）或 [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)（`0x076L`·`0x077L`）记录。若是其他 Codec 或不完整，则为 invalid。语言记录的有效性遵循该格式的规则。
- 两种语言格式都可使用。比较是否为同一语言的规则与 [LABEL](../edge/0x0A4L-label.md) 相同。SHORT-CODE 与注册表绑定到该编号的 BCP 47 tag 是同一种语言。
- 不使用 `zxx`（无语言内容）。这类字符串是 UTF8-TEXT。`und`（语言未定）和 `mul`（多种语言）属于有语言的文本，因此可以使用。
- 文本字节遵循与 UTF8-TEXT 相同的规则。必须是 well-formed UTF-8，开头的 U+FEFF 也作为字符允许，不强制规范化，按原文保存。由比较、索引的一方统一为 NFC 后再比较。
- 文本字节数为 `2 × (Payload WORD 数 − 语言记录 WORD 数) − P`。P（Codec 最低位）只表示文本字节的奇偶。为奇数时，最后一个 WORD 的低位 byte 必须为 `00`。
- 空文本（0 byte）在偶数代码中只放语言记录。

## 使用场合 {#쓰는-곳}

- Wikidata monolingualtext 值：`{"text":"Bundesrepublik Deutschland","language":"de"}` 成为这一个格式。它原样放入 [TRIPLE](../edge/0x0AAL-triple.md) 的 Object、[QUALIFIER](../edge/0x0ABL-qualifier.md) 的 Value。属性、rank、qualifier 由 TRIPLE 负责。
- [LABEL](../edge/0x0A4L-label.md)、[ALIAS](../edge/0x0A5L-alias.md) 的 Object。名称和语言都由这一个值承载。
- 法令、论文标题等语言已确定的文本。

## 语言码对应（Wikidata） {#언어-코드-대응-위키데이터}

- Wikidata、Wikimedia 的语言码并不全是 BCP 47（例如 `simple`、`map-bms`）。通过对应表转为 BCP 47 tag。无法转换的码按用途分别处理。
  - 值（monolingualtext）：将 datavalue 原文保存为 UTF8-TEXT。值是命题的一部分，丢弃会改变命题。
  - 标签·描述·别名：跳过并记入报告。这些 Edge 必须有语言才能成立（无语言文本为 invalid），原文保留在源数据中。
- 转换后的 tag 若在 GEUL Language Registry 中有编号，则用 LANGUAGE-SHORT-CODE，没有则用 LANGUAGE-BCP47-CODE。

## 长度 {#길이}

- 总长为 TAG 1 WORD、Length 扩展 TAG（如有）、语言记录、文本 WORD 之和。14 WORD 以下用直接长度，15 WORD 以上用扩展长度（[Length](../record.md)）。
- 语言记录：SHORT-CODE 为 2 WORD，BCP 47 为 `ceil(tag 字节/2) + 1` WORD（`de` 为 2 WORD，`zh-Hant` 为 5 WORD）。

## 示例 {#예시}

语言均为 LANGUAGE-BCP47-CODE 格式的示例。`fr`·`ko`·`de` 在注册表中有编号，也可以用 SHORT-CODE（2 WORD）书写。

| 值 | 文本字节 | 总 WORD |
|---|---|---|
| "Paris" (fr) | 5 (奇数) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (偶数) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- "Paris"：TAG `0795`（Codec `0x079L`，`LLLL=0101`，总计 6 WORD），语言 `0761 6672`（BCP 47 `fr`），文本 `5061 7269 7300`（5 byte，最后为 `00`）。
- 第三个总计 17 WORD，因此使用 Length 扩展（`078E` 的 `LLLL=1110`，扩展 TAG `0011`）。

## 标准依据 {#표준-근거}

- 语言 tag：[RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646)。`zxx`·`und`·`mul` 是 IANA Language Subtag Registry 的 special 码。
- 文本：[RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)。
- 字符串与带语言文本的区分：[RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string)。

## 未决问题 {#열린-문제}

- schema 对 BCP 47 tag 语法的检查。目前只检查是否为 ASCII 且非空。

## 相关页面 {#관련-페이지}

- [Value](_index.md)、[UTF8-TEXT](0x072L-utf8-text.md)、[LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md)、[LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md)、[LABEL](../edge/0x0A4L-label.md)

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000780/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

以上是 `UTF8-LANGUAGE-TEXT-EVEN`（`0x078L`）的 Codec 文档。其他成员（`UTF8-LANGUAGE-TEXT-ODD`）的 Codec 文档只在 DOC-ID 的 Codec ID、DECLARE 对象、`#1` 绑定的名称（BIND）上不同。
