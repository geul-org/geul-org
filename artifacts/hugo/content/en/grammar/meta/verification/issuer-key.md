---
title: "ISSUER-KEY"
weight: 65
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "ISSUER-KEY is a verification Meta that declares the signature algorithm ID and public key of a self-issued (16 WORD) Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declares the public key of a self-issued (16 WORD) Issuer. Issuer ID = SHA-256("GEUL-ISSUER-v1" ‖ algorithm ID ‖ public key) ([16 WORD Issuer](/grammar/issuer/#16-word-issuer)).

## Layout

```
TAG WORD          0001 1LLL L100 0000      Codec 0x40
[Length extension TAG]
Algorithm ID      1 WORD (0x0001 = Ed25519)
Public key        width set by the algorithm (Ed25519: 16 WORD)
```

- Codec: Meta `0x40`, verification class (`100`)
- Payload: raw value (algorithm ID + public key)
- Count: several allowed (key rotation)

## Interpretation and Validity

- It is a verification class, so it is left out of the content hash.
- 1, 2, and 4 WORD Issuers use keys registered with geul.org, so it is not needed.
