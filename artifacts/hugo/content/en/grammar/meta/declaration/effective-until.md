---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL is a declaration Meta that declares the end of the period of validity of this version (a temporary law) as a date or timestamp Value."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declares the end of the period of validity of this version (a temporary law). From that time on, this version is not in force.

## Layout

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length extension TAG]
Payload           one TIME Value
```

- Codec: Meta `0x14`, declaration class (`001`)
- Payload: embedded Value ([GREGORIAN-DATE](/grammar/value/time/gregorian-date/) or [POSIX-TIMESTAMP-SECONDS](/grammar/value/time/posix-timestamp-seconds/))
- Count: at most one

## Interpretation and Validity

- If absent, the version is valid until the next version takes effect.
- After the period of validity has passed, no edition is in force. An older edition does not come back to life.
