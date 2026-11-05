---
title: "URI-RELATIVE-REF"
weight: 1036
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "URI-RELATIVE-REF 是承载 RFC 3986 relative-ref 语法的 ASCII 字节序列的 Value。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

URI-RELATIVE-REF 是承载 RFC 3986 `relative-ref` 语法的 ASCII 字节序列的 Value。base URI 与 resolve 后的结果不放入 Payload。

## 布局 {#레이아웃}

- 码：Value `VALUE-ISSUER-2WORD`（`0x09DL`），Issuer `0x00000007` IETF，Codec 编号 `0x00008000`（偶数字节）·`0x00008001`（奇数字节）。系列 TEXT。
- 字节数由 Codec 编号的最低位与 Payload WORD 数决定。为 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](../_index.md)）。

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[Length 扩展 TAG] 总计 15 WORD 以上时
Issuer            2 WORD  0x00000007 (IETF)
Codec 编号        2 WORD  0x00008000/0x00008001
Payload WORD 1st ... Nth          relative-ref bytes / final zero padding
```

## 解释与有效性 {#해석과-유효성}

- 字节序列必须符合 RFC 3986 的 `relative-ref = relative-part [ "?" query ] [ "#" fragment ]` 语法。
- URI 语法的 terminal 是 US-ASCII 字符。允许的 ASCII 字符原样存储，对 octet 做 percent-encoding 时使用 `pct-encoded = "%" HEXDIG HEXDIG` 形式。不得将非 ASCII 字符作为 literal byte 直接放入。
- `relative-part` 可以是 `path-empty`，所以空字节序列在语法上也是有效的 `relative-ref`。
- base URI、resolution context 与 resolve 结果属于此格式之外的上下文。
- 在 WORD 内，高位 byte 在前。字节数为奇数（奇数码）时，最后一个 WORD 中未使用的低位 byte 必须为 `00`。
- Payload WORD 数为 `ceil(字节数/2)`。若是奇数码但最后一个 WORD 的低位 byte 不是 `00`，则拒绝。

## 标准依据 {#표준-근거}

- `relative-ref`、URI 字符与 percent-encoding 语法遵循 [RFC 3986, Uniform Resource Identifier (URI): Generic Syntax](https://www.rfc-editor.org/rfc/rfc3986)。
- 奇偶码对、zero padding、GEUL TAG/Length 以及 16 位 WORD 排布是此格式的 framing 规则。base URI 与引用解析结果属于 RFC 的上下文，但不放入 Payload。

## 长度 {#길이}

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）、Issuer 2 WORD、Codec 编号 2 WORD 与 Payload 的 WORD 数之和。14 WORD 以下使用直接长度，15 WORD 以上使用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](../../record.md)）。
- 0 byte 是空的 `relative-ref`，在语义上允许，且没有 Payload WORD。其物理布局见下面的未决问题。

## 示例 {#예시}

- `a/b?x=1` 为 7 byte（奇数），所以 Codec 编号为 `0x00008001`，Payload 为 `612F 623F 783D 3100`。总计 9 WORD，所以 `LLLL=1000`。整体为 `09D8 0000 0007 0000 8001 612F 623F 783D 3100`。

## 未决问题 {#열린-문제}

- 空 `relative-ref`（0 byte）的物理布局。没有 Payload 的记录与“Payload 最少 1 WORD”规则不符，尚未确定。
