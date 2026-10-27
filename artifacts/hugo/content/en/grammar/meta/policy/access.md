---
title: "ACCESS"
weight: 82
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "ACCESS is a policy Meta that records the scope of disclosure of the document (public, internal, confidential) as a 1 WORD level."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the scope of disclosure of the document.

## Layout

```
TAG WORD          0001 1LLL L101 0001      Codec 0x51
[Length extension TAG]
Level             1 WORD (0 public, 1 internal, 2 confidential, others reserved)
```

- Codec: Meta `0x51`, policy class (`101`)
- Payload: raw value (level, 1 WORD)
- Count: at most one

## Interpretation and Validity

- A confidential document is not published ([Issuer](/grammar/issuer/)).
- It does not change interpretation. It sets handling only.

## Open Questions

- The level code table.
