---
title: "LANGUAGE-BCP47-CODE"
weight: 71
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE 是以 ASCII 字节序列承载完整 BCP 47 language tag 的 Value。使用偶数·奇数字节码对 0x46/0x47。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE 是承载完整 BCP 47 language tag 的 Value。在需要精确写出 script、region、variant 的语言时使用。

## 布局

- 码：Value 直接码 `0x46`（偶数字节）·`0x47`（奇数字节）。系列 TEXT。
- 字节数由 Codec 的最低位和 Payload WORD 数决定。是 `2 × Payload WORD 数 − 最低位`，不设 Byte Count（[Value](/zh/grammar/value/)）。
- Payload 不是 UTF-8 文本，而是 BCP 47 tag 的 ASCII 字节序列。

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x46/0x47
[Length 扩展 TAG] 总计 15 WORD 以上时
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## 解读与有效性

- 字节序列必须是 RFC 5646 的 well-formed BCP 47 language tag。不允许空字符串。
- Payload 只使用 ASCII 字符、数字、连字符 `-`。分隔符必须是 ASCII `-`，不允许 `_`、空格、非 ASCII 字符。
- BCP 47 tag 的比较不区分大小写。GEUL canonical profile 把分隔符一律写成 `-`，language/extlang/variant/extension/private-use subtag 序列化为小写，script 为 Titlecase，region 为大写。
- 仅仅 well-formed 还不够。registered subtag 和 grandfathered tag 的有效性，以特定的 IANA Language Subtag Registry snapshot 为基准判定，并且必须同时保留该 snapshot 日期或 registry version。
- private-use tag 和 private-use subtag，只要按 RFC 5646 语法是 well-formed 就允许。但其含义取决于当事方约定，不由 IANA registry 定义，所以不保证公共互操作。
- 在同一 snapshot 中，如果 deprecated subtag 或 grandfathered tag 有 Preferred-Value，则 canonical GEUL form 用 canonical casing 写该替换值。保持 deprecated 写法的 tag 虽然可以作为输入解读，但不是 canonical 存储形式。
- BCP 47 是 ASCII profile，所以不适用 UTF-8 NFC 之类的 Unicode normalization 要求。
- WORD 内高字节在前。字节数为奇数（奇数码）时，最后一个 WORD 中未使用的低字节必须是 `00`。
- Payload WORD 数是 `ceil(字节数/2)`。奇数码而最后一个 WORD 的低字节不是 `00` 则拒绝。

## 标准依据

- language tag 语法、不区分大小写的解读、deprecated/Preferred-Value 概念，遵循 [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646)。
- 判定 tag 有效性的 registry 是 [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry)。
- 奇偶码对、zero padding、canonical casing 存储策略和 Length 计算是 GEUL 分帧规则。

## 长度

- 总计是 TAG 1 WORD、Length 扩展 TAG（如有）和 Payload 之和的 WORD 数。14 WORD 以下用直接长度，15 WORD 以上用 `1110`·`1111` 扩展长度，扩展 TAG 也计入总数（[Length](/zh/grammar/record/)）。

## 与 LANGUAGE-SHORT-CODE 的关系

- 在 GEUL Language Registry 中有编号的 tag 可以用 [LANGUAGE-SHORT-CODE](/zh/grammar/value/text/language-short-code/) 以 1 WORD 书写。
- 注册表中没有编号的 tag（包括含 extension·private-use 的 tag）用 LANGUAGE-BCP47-CODE 书写。需要保留完整 tag 原文时也用 LANGUAGE-BCP47-CODE。
- SHORT-CODE `n` 与注册表绑定到 `n` 的 tag 的 LANGUAGE-BCP47-CODE（不区分大小写）是同一种语言。

## 示例

- `ko-KR` 是 ASCII 5 byte（奇数），所以是 `LANGUAGE-BCP47-CODE-ODD`（`0x47`），Payload 是 `6b6f 2d4b 5200`。
- TAG 1 WORD、Payload 3 WORD，总计 4 WORD，`LLLL=0011`。完整记录是 `09C7 6b6f 2d4b 5200`。
