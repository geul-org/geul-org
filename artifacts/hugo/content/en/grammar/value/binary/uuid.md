---
title: "UUID"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID is a fixed 9 WORD Value that holds the 128-bit value of an RFC 9562 UUID as the canonical 16 octets."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UUID is a fixed-width Value that holds the 128-bit value of an RFC 9562 UUID. It is Value direct code `0x60`, family BINARY. The Payload is exactly 8 WORDs (16 octets, 128 bits).

## Layout

```
TAG WORD          0x0C60 (0000 1100 0110 0000)  9 WORD in total
Payload           8 WORD (128 bits)  UUID octet 0 → octet 15
```

## Interpretation and Validity

- The canonical UUID octet 0 through octet 15 of RFC 9562 are grouped two octets at a time in order. The octet that comes first is the upper 8 bits of the WORD. The fields, version bits, and variant bits of the UUID are not rearranged or re-encoded.
- The `8-4-4-4-12` hex-and-dash string is only an input/output representation. Upper or lower case and dashes do not go into the Payload; only the 16 octets that result from parsing are stored.
- This UUID Value preserves the 128-bit pattern without loss. In RFC 9562 variant `10xx`, versions 1, 3, 4, 5, 6, and 7 are standard layouts and version 8 is a custom UUID format. Version 2 is reserved for DCE Security and the RFC does not set its layout, version 0 is unused, and versions 9-15 are reserved for future definition. Other variants are also reserved for compatibility or future definition.
- The Nil UUID is the special value with all 128 bits zero, and the Max UUID the one with all 128 bits one. 128-bit patterns, including reserved and unused versions and variants, are not excluded structurally, and the meaning and interoperability of those patterns are judged by the applicable standard and external context.
- UUID identity is judged by whether the 128-bit values of the Payload are equal. That the values are equal does not guarantee the authentication, ownership, current existence, resolvability, or access rights of the target.
- When storing a Microsoft COM GUID, do not copy the mixed-endian memory or serialization representation as it is. First convert it to the 16 octets in the RFC 9562 canonical field/octet order.
- If the Payload is not exactly 8 WORDs, reject.

## Standards Basis

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) defines a UUID as 16 octets (128 bits) and encodes the fields most-significant-byte-first so that they connect in big-endian field order in the binary format. The variant is in the upper bits of octet 8 and the version in the upper 4 bits of octet 6, and this format preserves those positions as they are.
- RFC 9562 Sections 4.1-5.10 distinguish the variant, versions 1-8, Nil, Max, and the reserved ranges. RFC 9562 replaces RFC 4122, so the current normative text for this format is RFC 9562.
- The hex-and-dash ABNF of RFC 9562 is a text representation, and it also states the COM GUID little-endian caveat separately. GEUL puts only the canonical 16 octets of the RFC UUID in the Payload.
- The GEUL TAG, direct Length, and 16-bit WORD framing are not part of RFC 9562 but are rules this format adds.

## Length

- The total is exactly 9 WORDs, the TAG 1 WORD plus the Payload 8 WORD, using the direct length `LLLL=1000`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 8 WORDs, reject.

## Example

The UUIDv7 test vector `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` of RFC 9562 Appendix A.6:

```
0c60 017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f
```

- TAG `0c60`, Payload `017f 22e2 79b0 7cc3 98c4 dc0c 0c07 398f`.
