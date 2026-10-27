---
title: "IPV6-ADDRESS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS is a fixed 11 WORD IETF Issuer format that holds the 128 bits of an IPv6 address in order as they are."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS is a fixed-width Value that holds the 128-bit value of an IPv6 address. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, format number `0xC002`, family BINARY. The Payload is exactly 8 WORDs (128 bits).

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  11 WORD in total
Issuer            1 WORD  0x0020 (IETF)
Format number     1 WORD  0xC002
Payload           8 WORD (128 bits)  IPv6 address, high-order bit → low-order bit
```

## Interpretation and Validity

- The eight Payload WORDs are joined from the upper WORD, and the 128 bits of the IPv6 address field are read in order as they are. In each WORD, the octet that comes first is the upper 8 bits.
- The Payload holds only the 128 bits of one address. It does not hold a CIDR prefix length, port, or transport protocol.
- A zone identifier is not in the 128 bits of the address, so it is not put in the Payload. A scoped address that needs a zone is given by external context such as the interface, an Edge, a Reference, or a Profile.
- Every 128-bit pattern can be represented. The operational meaning and usability of unspecified, loopback, multicast, special, and reserved patterns are judged by external context and do not restrict structural validity.
- IPV4-ADDRESS and IPV6-ADDRESS are separate formats. An IPv4-mapped IPv6 address is also preserved as a 128-bit IPv6 value, and is not automatically identified with IPV4-ADDRESS or normalized to it.
- This Value can be used as an identifier component of a Reference, but the scope and reference policy are not in the address bit pattern.

## Standards Basis

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) defines an IPv6 address as a 128-bit identifier and sets the address bit formats, including unicast, anycast, multicast, and IPv4-mapped IPv6. This format preserves those 128 bits without reinterpretation.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) defines the Source Address and Destination Address of an IPv6 packet each as a 128-bit field. The Payload WORDs preserve the order of that address field from the high-order bit to the low-order bit.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) states that the zone of a non-global address is not encoded in the address itself but set by context. So the zone identifier is placed outside the Payload.
- The string notation of RFC 4291 can be used only for explanation and input/output. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) does not set an internal storage format, so its string canonicalization is not used as the canonicalization of this binary record.
- The GEUL TAG, Issuer assignment, direct Length, and 16-bit WORD framing are not part of these RFCs but are rules this format adds.

## Length

- The total is exactly 11 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 8 WORD, using the direct length `LLLL=1010`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 8 WORDs, reject.

## Example

The IPv6 address `2001:db8::1`:

```
0d7c 0020 c002 2001 0db8 0000 0000 0000 0000 0000 0001
```

- The abbreviated notation of the string does not affect the Payload.
