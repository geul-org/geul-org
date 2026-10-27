---
title: "DEFAULT-LANGUAGE"
weight: 23
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "DEFAULT-LANGUAGE is a declaration Meta that declares the default language of the document text as a language Value."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declares the default language of the document text. Text with no language written is in this language.

## Layout

```
TAG WORD          0001 1LLL L001 0110      Codec 0x16
[Length extension TAG]
Payload           one language Value
```

- Codec: Meta `0x16`, declaration class (`001`)
- Payload: embedded Value ([LANGUAGE-BCP47-CODE](/grammar/value/text/language-bcp47-code/) or [LANGUAGE-SHORT-CODE](/grammar/value/text/language-short-code/))
- Count: at most one

## Interpretation and Validity

- A TANGEUL document writes the locale it was written in (for example, `en`, `ko`).

## Example

- `en`: `0x1916 0x08C6 0x656E`
