---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE is a verification Meta that records a signature over the content hash of the document as an algorithm ID, a signer, and a signature."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

A signature over the content hash of the document (like git signed commits and tags).

## Layout

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[Length extension TAG]
Algorithm ID      1 WORD (0x0001 = Ed25519)
Signer            ISSUER-POINTER (Issuer) Reference record
Signature         everything else. The width is set by the algorithm (Ed25519: 32 WORD)
```

- Codec: Meta `0x41`, verification class (`100`)
- Payload: algorithm ID (raw value, 1 WORD) + signer (embedded Reference) + signature (raw value, the rest)
- Count: several allowed

## Interpretation and Validity

- The thing signed is the content hash. The BODY alone is not signed ([Signatures](/grammar/issuer/#signatures)).
- It is a verification class, so it is left out of the content hash. Adding a signature leaves the hash the same.
- Verification is not "check if a signature is present" but "a signature by the designated key must be present".
- The version list document is signed by the publisher.
- The signer is an [ISSUER-POINTER](/grammar/reference/issuer-pointer/) (Issuer) that points to the Issuer itself. Since it is a Reference record that ends at its own Length, the layout is fixed to one even if the signature width differs by algorithm (the rest field of [DECLARE](/grammar/edge/declare/)).
- If the WORD count of the signature differs from the width the algorithm sets, it is invalid.

## Open Questions

- Whether to sign the signing time as well.
