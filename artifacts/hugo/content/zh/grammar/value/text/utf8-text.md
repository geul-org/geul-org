---
title: "UTF8-TEXT"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-30T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT 是承载没有语言的 UTF-8 字符串的 Value。使用偶数·奇数字节码对 0x40/0x41。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT 是承载 RFC 3629 valid UTF-8 字节序列的 Value。用于标识符、代码、文件名之类没有语言的字符串。

## 布局

- 码：Value 直接码 `0x40`（偶数字节）·`0x41`（奇数字节）。系列 TEXT。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。是 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](/zh/grammar/value/)）。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x40/0x41
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## 解读与有效性

- 字节序列必须是符合 RFC 3629 语法的 well-formed shortest-form UTF-8。解码结果只包含 `U+0000..U+10FFFF` 范围的 Unicode scalar value，不包含 surrogate 范围 `U+D800..U+DFFF`。
- Payload 开头的 U+FEFF（UTF-8 字节序列 `EF BB BF`）与其他位置的 U+FEFF 一样视为字符并允许。不适用 RFC 3629 所述的开头 U+FEFF signature（BOM）处理：既不去除，也不解释为 signature，原样保留原文。
- 不强制 Unicode normalization。原样保留解码出的原文 scalar sequence。
- 把有效的 UTF-8 字节序列不经转换地放入 Payload。WORD 内高 byte 在前。字节数为奇数（奇数码）时，最后一个 WORD 中未使用的低 byte 必须是 `00`。
- Payload WORD 数是 `ceil(字节数/2)`。奇数码而最后一个 WORD 的低 byte 不是 `00` 则拒绝。

## 标准依据

- UTF-8 的 scalar 范围与 well-formed 字节序列遵循 [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629)。
- 奇偶码对、zero padding、GEUL TAG/Length 与 16 位 WORD 布局是本格式的 canonical framing 规则。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）和 Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](/zh/grammar/record/)）。
- 0 byte 字符串写成偶数码的 1 WORD 记录（仅 TAG WORD）（[Value](/zh/grammar/value/)）。

## 示例

- `A`（`41`）是 1 byte（奇数），所以是 `UTF8-TEXT-ODD`（`0x41`），Payload `4100`，总计 2 WORD，`LLLL=0001`。完整记录是 `08C1 4100`。
- 空字符串是 `0840`（`UTF8-TEXT-EVEN`，仅 TAG WORD）1 WORD。
