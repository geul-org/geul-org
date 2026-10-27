---
title: "Value — Time"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "The date and time formats of the TIME family (Codec `0x20`-`0x3F`, format numbers `0x4000`-`0x7FFF`): Gregorian dates, timestamps, durations, EDTF, and GEDCOM dates."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The TIME family is the date and time formats. They are placed in direct codes `0x20`-`0x3F` and Issuer format numbers `0x4000`-`0x7FFF`.

| Precision | Format |
|---|---|
| Date (Gregorian calendar) | GREGORIAN-DATE |
| Year/month, uncertain, intervals | EDTF |
| Original notation of other calendars (Julian and so on) | GEDCOM-DATE |
| Time of day | POSIX, TAI, GPS timestamps |
| Duration | DURATION-SECONDS, DURATION-NANOSECONDS |

- A date that can be written as GREGORIAN-DATE is not written as EDTF.
- The nanosecond timestamps and the TAI and GPS formats are formats under the Issuers of the respective standards bodies (IEEE, BIPM, GPS).
