---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT is a provenance Meta that records the time the document was recorded as a TIME Value (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the time the document was recorded (git commit date).

## Layout

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[Length extension TAG]
Payload           one TIME Value (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, and so on)
```

- Codec: Meta `0x25`, provenance class (`010`)
- Payload: embedded Value (TIME family: [GREGORIAN-DATE](/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/grammar/value/time/posix-timestamp-seconds/), and so on)
- Count: at most one

## Interpretation and Validity

- The form is chosen from the TIME family of Values. When precision is needed, use a nanosecond format defined by the Issuer (for example, [POSIX-TIMESTAMP-NANOSECONDS](/grammar/value/time/posix-timestamp-nanoseconds/)).
- The version list document ([PUBLICATION](/grammar/edge/publication/)) uses this value as the time of publication, deprecation, and deletion.

## Open Questions

- Provenance Meta goes into the content hash. Whether to allow the hash to differ when the same content is recorded at a different time.
