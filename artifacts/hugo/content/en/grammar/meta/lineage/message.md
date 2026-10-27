---
title: "MESSAGE"
weight: 57
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "MESSAGE is a lineage Meta that records the reason for a change as text with a language (git commit message)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the reason for the change (git commit message).

## Layout

```
TAG WORD          0001 1LLL L011 1000      Codec 0x38
[Length extension TAG]
Message           one UTF8-LANGUAGE-TEXT Value
```

- Codec: Meta `0x38`, lineage class (`011`)
- Payload: embedded Value ([UTF8-LANGUAGE-TEXT](/grammar/value/text/utf8-language-text/))
- Count: at most one per language

## Interpretation and Validity

- The message and its language are held in one UTF8-LANGUAGE-TEXT. There is one MESSAGE per language.
- A geul.org specification document writes it with [CODEC](/grammar/edge/codec/) `084A` and `084B`.
