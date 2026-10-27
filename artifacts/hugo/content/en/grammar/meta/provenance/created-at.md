---
title: "CREATED-AT"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "CREATED-AT is a provenance Meta that records the time the document was written as a TIME Value (git author date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the time the document was written (git author date).

## Layout

```
TAG WORD          0001 1LLL L010 0010      Codec 0x22
[Length extension TAG]
Payload           one TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, and so on)
```

- Codec: Meta `0x22`, provenance class (`010`)
- Payload: embedded Value (TIME family: [GREGORIAN-DATE](/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/grammar/value/time/posix-timestamp-seconds/), and so on)
- Count: at most one

## Interpretation and Validity

- The form is chosen from the TIME family of Values. When precision is needed, use a nanosecond format defined by the Issuer (for example, [POSIX-TIMESTAMP-NANOSECONDS](/grammar/value/time/posix-timestamp-nanoseconds/)).
