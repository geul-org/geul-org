---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION is a declaration Meta that declares the GEUL spec version the document follows as one integer. GEUL v1 is 0x0001."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declares the GEUL spec version the document follows. This value decides how the remaining records are read.

## Layout

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[Length extension TAG]
Payload           spec version. v1 = 0x0001
```

- Codec: Meta `0x10`, declaration class (`001`)
- Payload: raw value (an unsigned integer in the shortest width)
- Count: at most one

## Interpretation and Validity

- It does not depend on Value codes. So that a decoder of any version can read it, it holds just an integer with no embedded Value.
- If the version is unknown, the decoder rejects or warns.
- If absent, the decoder reads it as the version it knows. A published document writes it.

## Example

- `0x1890 0x0001`: GEUL v1

## Open Questions

- Correspondence with the codebook document version ([specification documents](/grammar/codec-spec/)).
