---
title: "URI-RELATIVE-REF"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF 是承载 RFC 3986 relative-ref 语法的 ASCII 字节序列的 Value。使用 IETF Issuer 的格式编号 0x8000/0x8001。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF 是承载 RFC 3986 `relative-ref` 语法的 ASCII 字节序列的 Value。base URI 以及 resolve 之后的结果不放入 Payload。

## 布局

- 码：Value `ISSUER-1WORD`（`0x7C`），Issuer `0x0020` IETF，格式编号 `0x8000`（偶数字节）·`0x8001`（奇数字节）。系列 TEXT。
- 字节数由格式编号的最低位和 Payload WORD 数决定。是 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](/zh/grammar/value/)）。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            1 WORD  0x0020 (IETF)
格式编号          1 WORD  0x8000/0x8001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## 解读与有效性

- 字节序列必须符合 RFC 3986 的 `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` 语法。
- URI 语法的 terminal 是 US-ASCII 字符。允许的 ASCII 字符原样存放，对 octet 做 percent-encoding 时使用 `pct-encoded = "%" HEXDIG HEXDIG` 形式。不得把非 ASCII 字符作为 literal byte 直接放入。
- `relative-part` 可以是 `path-empty`，所以空字节序列在语法上也是有效的 `relative-ref`。
- base URI、resolution context 以及 resolve 结果属于本格式之外的上下文。
- WORD 内高 byte 在前。字节数为奇数（奇数码）时，最后一个 WORD 中未使用的低 byte 必须是 `00`。
- Payload WORD 数是 `ceil(字节数/2)`。奇数码而最后一个 WORD 的低 byte 不是 `00` 则拒绝。

## 标准依据

- `relative-ref`、URI 字符和 percent-encoding 语法遵循 [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)。
- 奇偶码对、zero padding、GEUL TAG/Length 与 16 位 WORD 布局是本格式的 framing 规则。base URI 和引用解析结果虽然属于 RFC 的上下文，但不放入 Payload。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 1 WORD、格式编号 1 WORD 与 Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](/zh/grammar/record/)）。
- 0 byte 是空的 `relative-ref`，在语义上被允许，且没有 Payload WORD。其物理布局见下面的未决问题。

## 示例

- `a/b?x=1` 是 7 byte（奇数），所以格式编号为 `0x8001`，Payload 为 `612f 623f 783d 3100`。总计 7 WORD，所以 `LLLL=0110`。完整记录是 `0B7C 0020 8001 612f 623f 783d 3100`。

## 未决问题

- 空的 `relative-ref`（0 byte）的物理布局。没有 Payload 的记录与"最小 Payload 1 WORD"规则不符，所以尚未确定。
