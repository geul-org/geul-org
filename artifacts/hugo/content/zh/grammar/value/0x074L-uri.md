---
title: "URI (0x074L·0x075L)"
weight: 116
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI 是承载符合 RFC 3986 URI（含 scheme 的绝对 URI）语法的 ASCII 字节序列的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI 是承载符合 RFC 3986 URI（含 scheme 的绝对 URI）语法的 ASCII 字节序列的 Value。使用偶数·奇数字节代码对 0x074L/0x075L。

| 项目 | 值 |
|---|---|
| 名称 | `URI`（奇偶分组。各代码的名称见下方成员表） |
| TAG ID | `0x074L`·`0x075L` |
| 章节 | 3 `0011`（Value），章节内偏移 C = 20~21 |
| Kind | Value · 系列：TEXT |
| 索引说明 | RFC 3986 `URI` production 的 ASCII 字节序列。偶数·奇数字节 |
| Hugo 路径 | `value/text/uri.md` |

## 成员 {#구성원}

本页同时处理奇偶一对的两个代码。偶数代码的值字节数为偶数，奇数代码的值字节数为奇数（[记录与 TAG WORD](../record.md#가변-길이-바이트열)）。Codec 文档每个代码一份。两份 Codec 文档的字段相同，只有 DECLARE 对象和名称（BIND）不同。

| TAG ID | 名称 | 字节数 | Codec ID | 规格文档 | TAG WORD |
|---|---|---|---|---|---|
| `0x074L` | `URI-EVEN` | 偶数 | `0x00000740` | `0x00000000/codecs/0x00000740/` | `0000 0111 0100 LLLL` |
| `0x075L` | `URI-ODD` | 奇数 | `0x00000750` | `0x00000000/codecs/0x00000750/` | `0000 0111 0101 LLLL` |

## 字段（规格文档） {#필드-규격-문서}

FIELD 在文档中的顺序就是 Payload 字段的顺序（[Codec 规格文档](../codec-spec.md)）。

| 顺序 | 字段（BIND） | FIELD | 宽度 | 接收格式（CODEC） | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | 剩余原始值（`0xFFFF`） |  |  |

URI 是承载符合 RFC 3986 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` 语法的 ASCII 字节序列的 Value。因为包含 scheme，解释时不需要 base URI。

## 布局 {#레이아웃}

- 代码：Value 直接码 `0x074L`（偶数字节）·`0x075L`（奇数字节）。系列 TEXT。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。即 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](_index.md)）。

```
TAG WORD          0000 0111 010P LLLL      Codec 0x074L/0x075L
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## 解释与有效性 {#해석과-유효성}

- 字节序列必须符合 RFC 3986 的 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` 语法。可以包含 query 和 fragment。
- URI 语法的 terminal 是 US-ASCII 字符。允许的 ASCII 字符原样存储，对 octet 做 percent-encoding 时使用 `pct-encoded = "%" HEXDIG HEXDIG` 形式。不得将非 ASCII 字符作为 literal byte 直接放入。
- 必须包含 `scheme` 和 `:`。相对引用使用 [URI-RELATIVE-REF](ietf.geul.org/uri-relative-ref.md)（IETF Codec 编号 `0x00008000`·`0x00008001`）。
- RFC 3986 的 URI production 不允许空字符串。0 byte 记录无效。
- WORD 内高位 byte 在前。字节数为奇数（奇数代码）时，最后一个 WORD 中未使用的低位 byte 必须为 `00`。
- Payload WORD 数为 `ceil(字节数/2)`。若为奇数代码而最后一个 WORD 的低位 byte 不是 `00`，则拒绝。

## 标准依据 {#표준-근거}

- `URI`、URI 字符与 percent-encoding 语法遵循 [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)。
- 奇偶代码对、zero padding、GEUL TAG/Length 与 16 位 WORD 排布是该格式的 framing 规则。

## 长度 {#길이}

- 总长为 TAG 1 WORD、Length 扩展 TAG（如有）与 Payload 的 WORD 数之和。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](../record.md)）。

## 示例 {#예시}

- `https://example.com/` 为 ASCII 20 byte（偶数），因此是 `URI-EVEN`（`0x074L`）。
- Payload 为 `6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F` 共 10 WORD。
- TAG 1 WORD 加 Payload 10 WORD，总计 11 WORD，因此 `LLLL=1010`。整体为 `074A 6874 7470 733A 2F2F 6578 616D 706C 652E 636F 6D2F`。

## GEUL Archive URI {#geul-archive-uri}

`archive.geul.org` 是为在 GEUL 中引用外部二进制、文档等大型内容而设想的不可变内容存储库，目前尚未运营。推荐的地址格式为 `https://archive.geul.org/sha256/{digest}`。相同的字节序列必须对应相同的 URI，发布之后不得更改同一 URI 的字节。

URI Value 只表示外部内容的位置或地址字符串，不保证对象本身的同一性或不可变性。超出内联 Value 最大范围的二进制和文本可以通过 archive URI 引用。存储对象的元数据必须记录以下项目。

- 原始 URI 与收集时间
- SHA-256 与 Byte Length
- MIME type
- license identifier 与 version
- 作者、出处与声明
- 许可证依据 URI，必要时附收集时的依据副本

能否收集，不以能否免费访问为准，而以是否明确确认了再分发权限为准。必须遵守署名、非商业、禁止修改、相同方式共享等适用的许可证条件。文档和内容应记录 Creative Commons 之类的明确许可证，软件则尽可能使用 SPDX License ID。

即使因权利问题或更正而停止提供，也不得在原有 URI 中放入不同的字节。该 URI 应返回载有停止原因和时间的 tombstone，并保存原始 digest 与审计记录。但若法律义务禁止保存审计记录，则以该义务为先。

archive URI 同时提供访问位置和内容 digest。这一 content-address 与不可变性规则是 GEUL Archive profile 的策略，URI Value 的通用语法不依赖于 `archive.geul.org`。

## 规格文档原文 {#규격-문서-원문}

这是用 `geul show` 读取规格文档 `0x00000000/codecs/0x00000740/latest.geul` 的样子（十六进制为大写）。

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000074000000000
BODY
#1 DECLARE 0x0740
#2 FIELD #1 rest
#3 BIND #1 "URI-EVEN"
#4 BIND #2 "bytes"
```

以上是 `URI-EVEN`（`0x074L`）的 Codec 文档。其他成员（`URI-ODD`）的 Codec 文档只在 DOC-ID 的 Codec ID、DECLARE 对象、`#1` 绑定的名称（BIND）上不同。
