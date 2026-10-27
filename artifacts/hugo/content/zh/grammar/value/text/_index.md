---
title: "Value — 文本"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "TEXT 系列（Codec `0x40`~`0x5F`，格式编号 `0x8000`~`0xBFFF`）的格式：UTF-8 文本、带语言的文本、URI、语言码。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT 系列是文本和字符串标识符格式。放在直接码 `0x40`~`0x5F`、Issuer 格式编号 `0x8000`~`0xBFFF` 中。

- 没有语言的字符串是 UTF8-TEXT，名称·标题·句子之类有语言的文本是 UTF8-LANGUAGE-TEXT。
- 语言码（LANGUAGE-SHORT-CODE、LANGUAGE-BCP47-CODE）也属于 TEXT 系列。
- 可变长度字节序列设为偶数·奇数 Codec 对。最低位为 `1` 表示字节数为奇数，最后一个 WORD 的低字节是 `0x00` 填充（[记录与 TAG WORD](/zh/grammar/record/)）。
