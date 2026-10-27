---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM is a declaration Meta that declares the date this version takes effect as a date or timestamp Value."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declares the date this version takes effect. The date in force differs from the publication time ([Revisions](/grammar/document/#revisions)).

## Layout

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length extension TAG]
Payload           one TIME Value
```

- Codec: Meta `0x13`, declaration class (`001`)
- Payload: embedded Value ([GREGORIAN-DATE](/grammar/value/time/gregorian-date/) or [POSIX-TIMESTAMP-SECONDS](/grammar/value/time/posix-timestamp-seconds/))
- Count: at most one

## Interpretation and Validity

- If absent, the version takes effect from the publication time.
- If [EFFECTIVE-UNTIL](/grammar/meta/declaration/effective-until/) is present, this must be earlier than it.
- If the date in force differs article by article, write it separately on that article's Edge with QUALIFIER P580 (start) and P582 (end) ([SOURCE](/grammar/edge/source/#expressing-other-evidence)).
- This value is read when interpreting a document as of a specific point in time.

## Example

- In force from 1970-01-02: `0x1993 0x0920 0x0000 0x0001`
