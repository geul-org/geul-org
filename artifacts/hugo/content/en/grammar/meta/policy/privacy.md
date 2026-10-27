---
title: "PRIVACY"
weight: 83
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "PRIVACY is a policy Meta that records the privacy level of the document in 1 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the privacy level of the document.

## Layout

```
TAG WORD          0001 1LLL L101 0010      Codec 0x52
[Length extension TAG]
Level             1 WORD
```

- Codec: Meta `0x52`, policy class (`101`)
- Payload: raw value (level, 1 WORD)
- Count: at most one

## Interpretation and Validity

- It does not change interpretation. It sets handling only.

## Open Questions

- The level code table (correspondence to the classification in the Personal Information Protection Act).
