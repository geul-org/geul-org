---
title: "CONSENT"
weight: 85
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "CONSENT is a policy Meta that records the scope and basis of consent as a Reference or text."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the scope and basis of consent.

## Layout

```
TAG WORD          0001 1LLL L101 0100      Codec 0x54
[Length extension TAG]
Payload           a Reference to the basis of consent, or text
```

- Codec: Meta `0x54`, policy class (`101`)
- Payload: embedded Reference or Value
- Count: several allowed

## Open Questions

- The structure for expressing scope (purpose, period, provision to third parties).
