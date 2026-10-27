---
title: "LICENSE"
weight: 81
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "LICENSE is a policy Meta that records the license of this document and of the works inside its byte sequences."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Records the license of this document and of the works inside its byte sequences.

## Layout

```
TAG WORD          0001 1LLL L101 0000      Codec 0x50
[Length extension TAG]
Payload           a Reference to the license, or an SPDX identifier as UTF8-TEXT, or a URI Value
```

- Codec: Meta `0x50`, policy class (`101`)
- Payload: embedded Reference or Value ([UTF8-TEXT](/grammar/value/text/utf8-text/), [URI](/grammar/value/text/uri/))
- Count: at most one

## Interpretation and Validity

- Documents published on geul.org are CC0. For private publication, the Issuer decides ([Issuer](/grammar/issuer/)).
- Record the original license of the source work.

## Open Questions

- Whether to hold the SPDX identifier as text or as a GEUL entity Reference.
