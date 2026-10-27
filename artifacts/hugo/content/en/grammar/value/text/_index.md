---
title: "Value — Text"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "The formats of the TEXT family (Codec `0x40`-`0x5F`, format numbers `0x8000`-`0xBFFF`): UTF-8 text, text with a language, URI, and language codes."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The TEXT family is the formats for text and string identifiers. They are placed in direct codes `0x40`-`0x5F` and Issuer format numbers `0x8000`-`0xBFFF`.

- A string with no language is UTF8-TEXT, and text with a language, such as names, titles, and sentences, is UTF8-LANGUAGE-TEXT.
- Language codes (LANGUAGE-SHORT-CODE, LANGUAGE-BCP47-CODE) are also TEXT family.
- Variable-length byte sequences are placed as even-odd Codec pairs. If the lowest bit is `1`, the byte count is odd and the lower byte of the last WORD is `0x00` padding ([Records and the TAG WORD](/grammar/record/)).
