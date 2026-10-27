---
title: "Meta — Verification"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "The Meta verification class (upper 3 bits `100`, `0x40`-`0x4F`) records the material for judging whether a document can be trusted (public keys, signatures, confidence, verdicts)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The Meta verification class (upper 3 bits `100`, Codec `0x40`-`0x4F`) records the material for judging whether a document can be trusted: the public key of a self-issued Issuer, signatures, confirmation of the right to contribute, confidence, and the judgment result for the whole document.

- The verification class is left out of the content hash calculation. So the content hash does not change whether a signature is placed inside the document or several signatures are added (the same approach as git `gpgsig`).
- The class is known from the upper 3 bits of the Codec, so the hash can be calculated without a codebook.
- Judgments at the level of a node or record are handled by the [TOULMIN](/grammar/edge/toulmin/) Edge `VERDICT` (`0x78`).
