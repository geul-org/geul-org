---
title: "Value — テキスト"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "TEXT 系列(Codec `0x40`~`0x5F`、形式番号 `0x8000`~`0xBFFF`)の形式: UTF-8 テキスト、言語付きテキスト、URI、言語コード。"
author: "朴俊宇"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TEXT 系列は、テキストと文字列識別子の形式だ。直接コード `0x40`~`0x5F`、Issuer 形式番号 `0x8000`~`0xBFFF` に置く。

- 言語のない文字列は UTF8-TEXT、名前・タイトル・文のように言語のあるテキストは UTF8-LANGUAGE-TEXT だ。
- 言語コード(LANGUAGE-SHORT-CODE、LANGUAGE-BCP47-CODE)も TEXT 系列だ。
- 可変長のバイト列は、偶数・奇数の Codec ペアで置く。最下位ビットが `1` ならバイト数が奇数で、最後の WORD の下位バイトは `0x00` のパディングだ([レコードと TAG WORD](/ja/grammar/record/))。
