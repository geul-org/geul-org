---
title: "Value — Binary"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "The formats of the BINARY family (Codec `0x60`-`0x7B`, format numbers `0xC000`-`0xFFFF`): UUID, digests, CRC, network addresses, opaque bytes, and bit vectors."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The BINARY family is the byte sequence formats. They are placed in direct codes `0x60`-`0x7B` and Issuer format numbers `0xC000`-`0xFFFF`.

- UUID, SHA-256, and SHA-1 are direct codes. The other digests, CRC32C, IPv4, IPv6, and MAC addresses, opaque bytes, and bit vectors are Issuer formats.
- Fixed-size values (UUID, digests, addresses) have a set size, so no even-odd pairs are placed.
- Public media such as images and video are placed as BINARY formats of the IANA Issuer (`0x0021`). The format numbers are assigned as even-odd pairs, and the Payload is a byte sequence. The Length upper bound is 2^32−1 WORD. For large values, referencing them by URI and SHA-256 is recommended over embedding them directly.
- A work inside a byte sequence follows its original license. The source and license are recorded in Meta.
