---
title: "IPV6-ADDRESS"
weight: 1035
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV6-ADDRESS is a fixed-width Value that holds the 128-bit value of an IPv6 address."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV6-ADDRESS is a fixed-width Value that holds the 128-bit value of an IPv6 address. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, codec number `0x0000C002`, family BINARY. The Payload is exactly 8 WORD (128 bits).

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  13 WORD in total
Issuer            2 WORD  0x00000007 (IETF)
Codec number      2 WORD  0x0000C002
Payload           8 WORD (128 bits)  IPv6 address, high-order bit → low-order bit
```

## Interpretation and validity {#해석과-유효성}

- The eight Payload WORD are concatenated from the most significant WORD first, and the 128 bits of the IPv6 address field are read in order. In each WORD, the octet that comes first is the upper 8 bits.
- The Payload holds only the 128 bits of a single address. It does not hold a CIDR prefix length, a port, or a transport protocol.
- A zone identifier is not contained in the 128 bits of the address, so it is not put in the Payload. A scoped address that needs a zone is given through external context such as the interface, or an Edge, Reference, or Profile.
- Every 128-bit pattern can be represented. The operational meaning and usability of unspecified, loopback, multicast, special, and reserved patterns are judged in external context and do not limit structural validity.
- IPV4-ADDRESS and IPV6-ADDRESS are separate formats. An IPv4-mapped IPv6 address is also preserved as a 128-bit IPv6 value, and it is not automatically equated with IPV4-ADDRESS or normalized to it.
- This Value can be used as an identifier component of a Reference, but the scope and reference policy are not contained in the address bit pattern.

## Standards basis {#표준-근거}

- [RFC 4291 — IP Version 6 Addressing Architecture](https://www.rfc-editor.org/rfc/rfc4291.html) defines an IPv6 address as a 128-bit identifier and specifies the address bit format, including unicast, anycast, multicast, and IPv4-mapped IPv6. This format preserves those 128 bits without reinterpretation.
- [RFC 8200 — Internet Protocol, Version 6 (IPv6) Specification](https://www.rfc-editor.org/rfc/rfc8200.html) defines the Source Address and Destination Address of an IPv6 packet each as a 128-bit field. The Payload WORD preserve the order from the high-order bit to the low-order bit of that address field.
- [RFC 4007 — IPv6 Scoped Address Architecture](https://www.rfc-editor.org/rfc/rfc4007.html) states that the zone of a non-global address is not encoded in the address itself but determined by context. Therefore the zone identifier is kept outside the Payload.
- The textual notation of RFC 4291 can be used only for explanation and input/output. [RFC 5952 — A Recommendation for IPv6 Address Text Representation](https://www.rfc-editor.org/rfc/rfc5952.html) does not specify an internal storage format, so its string canonicalization is not used as the canonicalization of this binary record.
- The GEUL TAG, the Issuer assignment, the direct Length, and the 16-bit WORD framing are not part of these RFCs but rules added by this format.

## Length {#길이}

- The total is exactly 13 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 8 WORD, and it uses the direct length `LLLL=1100`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 8 WORD, it is rejected.

## Example {#예시}

The IPv6 address `2001:db8::1`:

```
09DC 0000 0007 0000 C002 2001 0DB8 0000 0000 0000 0000 0000 0001
```

- The abbreviated notation of the string does not affect the Payload.
