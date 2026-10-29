---
title: "URI"
weight: 69
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI 是承载 RFC 3986 URI（含 scheme 的绝对 URI）语法的 ASCII 字节序列的 Value。使用偶数·奇数字节码对 0x44/0x45。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI 是承载 RFC 3986 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` 语法的 ASCII 字节序列的 Value。因为包含 scheme，所以解读时不需要 base URI。

## 布局

- 码：Value 直接码 `0x44`（偶数字节）·`0x45`（奇数字节）。系列 TEXT。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。是 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](/zh/grammar/value/)）。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x44/0x45
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          URI bytes / final zero padding
```

## 解读与有效性

- 字节序列必须符合 RFC 3986 的 `URI = scheme ":" hier-part [ "?" query ] [ "#" fragment ]` 语法。可以包含 query 和 fragment。
- URI 语法的 terminal 是 US-ASCII 字符。允许的 ASCII 字符原样存放，对 octet 做 percent-encoding 时使用 `pct-encoded = "%" HEXDIG HEXDIG` 形式。不得把非 ASCII 字符作为 literal byte 直接放入。
- 必须包含 `scheme` 和 `:`。相对引用使用 [URI-RELATIVE-REF](/zh/grammar/value/text/uri-relative-ref/)（IETF 格式编号 `0x8000`·`0x8001`）。
- RFC 3986 的 URI production 不允许空字符串。0 byte 记录无效。
- WORD 内高 byte 在前。字节数为奇数（奇数码）时，最后一个 WORD 中未使用的低 byte 必须是 `00`。
- Payload WORD 数是 `ceil(字节数/2)`。奇数码而最后一个 WORD 的低 byte 不是 `00` 则拒绝。

## 标准依据

- `URI`、URI 字符和 percent-encoding 语法遵循 [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)。
- 奇偶码对、zero padding、GEUL TAG/Length 与 16 位 WORD 布局是本格式的 framing 规则。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）和 Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](/zh/grammar/record/)）。

## 示例

- `https://example.com/` 是 ASCII 20 byte（偶数），所以是 `URI-EVEN`（`0x44`）。
- Payload 是 `6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f` 共 10 WORD。
- TAG 1 WORD 加 Payload 10 WORD，总计 11 WORD，所以 `LLLL=1010`。完整记录是 `0D44 6874 7470 733a 2f2f 6578 616d 706c 652e 636f 6d2f`。

## GEUL Archive URI

`archive.geul.org` 是构想中的不可变内容存储库，供 GEUL 引用外部二进制·文档之类的大型内容，目前尚未运营。建议的地址格式是 `https://archive.geul.org/sha256/{digest}`。相同的字节序列必须有相同的 URI，发布之后不得更改同一 URI 的字节。

URI Value 只表示外部内容的位置或地址字符串，并不保证对象本身的同一性或不可变性。超出内联 Value 最大范围的二进制和文本，可以用 archive URI 来引用。存储对象的元数据必须记录以下项目。

- 原始 URI 和收集时刻
- SHA-256 和 Byte Length
- MIME type
- license identifier 和 version
- 作者、出处和声明
- 许可证依据 URI，以及必要时收集当时的依据副本

能否收集，不是看是否可以免费访问，而是看是否明确确认了再分发权限。必须遵守署名、非商业、禁止修改、相同方式共享等适用的许可证条件。文档和内容要记录 Creative Commons 之类的明确许可证，软件尽可能使用 SPDX License ID。

即使因权利问题或更正而停止提供，也不得在既有 URI 中放入不同的字节。该 URI 要返回含有停止原因和时刻的 tombstone，并保留原始 digest 和审计记录。但如果法律义务禁止保留审计记录，则以该义务为先。

archive URI 同时提供访问位置和内容 digest。这种 content-address 和不可变性规则是 GEUL Archive profile 的策略，URI Value 的一般语法不依赖于 `archive.geul.org`。
