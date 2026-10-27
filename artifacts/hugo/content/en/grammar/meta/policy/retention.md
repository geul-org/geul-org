---
title: "RETENTION"
weight: 84
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "RETENTION is a policy Meta that records the retention period of the document as an expiry time or a duration Value."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the retention period of the document.

## Layout

```
TAG WORD          0001 1LLL L101 0011      Codec 0x53
[Length extension TAG]
Payload           an expiry time (GREGORIAN-DATE and so on) or a duration (DURATION-SECONDS)
```

- Codec: Meta `0x53`, policy class (`101`)
- Payload: embedded Value (TIME family: [GREGORIAN-DATE](/grammar/value/time/gregorian-date/) and so on, or [DURATION-SECONDS](/grammar/value/time/duration-seconds/))
- Count: at most one

## Interpretation and Validity

- A duration is counted from [RECORDED-AT](/grammar/meta/provenance/recorded-at/).
