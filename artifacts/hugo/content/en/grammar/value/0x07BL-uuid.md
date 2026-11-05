---
title: "UUID (0x07BL)"
weight: 123
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "UUID is a fixed-width Value that holds the 128-bit value of an RFC 9562 UUID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `UUID` (spec document BIND `UUID`) |
| TAG ID | `0x07BL` |
| Codec ID | `0x000007B0` |
| Spec document | `0x00000000/codecs/0x000007B0/` (DECLARE target `07B0`) |
| Section | 3 `0011` (Value), offset within section C = 27 |
| Kind | Value · family: BINARY |
| TAG WORD | `0000 0111 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | RFC 9562 UUID 128 bits in a fixed Payload of 8 WORDs |
| Hugo path | `value/binary/uuid.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `uuid` | #2 | raw 8 WORDs |  |  |

UUID is a fixed-width Value that holds the 128-bit value of an RFC 9562 UUID. It is the Value direct code `0x07BL`, family BINARY. The Payload is exactly 8 WORDs (16 octets, 128 bits).

## Layout {#레이아웃}

```
TAG WORD          0x07B8 (0000 0111 1011 1000)  9 WORDs in total
Payload           8 WORDs (128 bits)  UUID octet 0 → octet 15
```

## Interpretation and validity {#해석과-유효성}

- The canonical UUID octets of RFC 9562, from octet 0 to octet 15, are grouped two octets at a time in order. The earlier octet is the upper 8 bits of the WORD. The UUID's fields, version bits, and variant bits are not rearranged or re-encoded.
- The `8-4-4-4-12` hex-and-dash string is only an input/output representation. Case and dashes do not enter the Payload; only the 16 octets that result from parsing are stored.
- This UUID Value preserves the 128-bit pattern without loss. Under RFC 9562 variant `10xx`, versions 1, 3, 4, 5, 6, and 7 have a standard layout, and version 8 is a custom UUID format. Version 2 is reserved for DCE Security and the RFC does not define its layout; version 0 is unused, and versions 9–15 are reserved for future definition. Other variants are also reserved for compatibility or future definition.
- The Nil UUID is the special value of 128 bits all zero, and the Max UUID is 128 bits all one. 128-bit patterns that include reserved or unused versions/variants are not structurally excluded either; the meaning and interoperability of such a pattern are judged by the applicable standard and external context.
- UUID identity is judged by whether the 128-bit values of the Payload are equal. The fact that the values are equal does not guarantee the authentication, ownership, current existence, resolvability, or access rights of the target.
- When storing a Microsoft COM GUID, do not copy the mixed-endian memory or serialized representation as is. First convert it to 16 octets in the RFC 9562 canonical field/octet order.
- If the Payload is not exactly 8 WORDs, it is rejected.

## Standards basis {#표준-근거}

- [RFC 9562 — Universally Unique IDentifiers (UUIDs)](https://www.rfc-editor.org/rfc/rfc9562.html) defines a UUID as 16 octets (128 bits), and has fields encoded most-significant-byte-first so that the binary format joins them in big-endian field order. The variant is in the upper bits of octet 8 and the version in the upper 4 bits of octet 6; this format preserves those positions as is.
- RFC 9562 Sections 4.1–5.10 distinguish the variant, versions 1–8, Nil, Max, and reserved ranges. RFC 9562 obsoletes RFC 4122, so the current normative reference for this format is RFC 9562.
- The hex-and-dash ABNF of RFC 9562 is a text representation, and it also states the COM GUID little-endian caveat separately. GEUL puts only the canonical 16 octets of the RFC UUID in the Payload.
- The GEUL TAG, direct Length, and 16-bit WORD framing are not part of RFC 9562 but rules this format adds.

## Length {#길이}

- The total is exactly 9 WORDs, the TAG 1 WORD plus the Payload 8 WORDs, and uses the direct length `LLLL=1000`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 8 WORDs, it is rejected.

## Example {#예시}

The UUIDv7 test vector `017f22e2-79b0-7cc3-98c4-dc0c0c07398f` from RFC 9562 Appendix A.6:

```
07B8 017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F
```

- TAG `07B8`, Payload `017F 22E2 79B0 7CC3 98C4 DC0C 0C07 398F`.

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x000007B0/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007B000000000
BODY
#1 DECLARE 0x07B0
#2 FIELD #1 0x0008
#3 BIND #1 "UUID"
#4 BIND #2 "uuid"
```
