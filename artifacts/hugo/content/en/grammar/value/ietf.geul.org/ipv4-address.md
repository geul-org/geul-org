---
title: "IPV4-ADDRESS"
weight: 1034
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS is a fixed-width Value that holds the 32-bit value of an IPv4 address."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS is a fixed-width Value that holds the 32-bit value of an IPv4 address. It is Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000007` IETF, codec number `0x0000C001`, family BINARY. The Payload is exactly 2 WORD (32 bits).

## Layout {#레이아웃}

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  7 WORD in total
Issuer            2 WORD  0x00000007 (IETF)
Codec number      2 WORD  0x0000C001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretation and validity {#해석과-유효성}

- The address octets are kept in network byte order. In each WORD, the octet that comes first is the upper 8 bits and the next octet is the lower 8 bits.
- The Payload holds only the 32 bits of a single address. It does not hold a CIDR prefix length, a port, or a transport protocol.
- Every 32-bit pattern can be represented. The operational meaning and usability of patterns such as unspecified, special, reserved, and multicast are judged in external context and do not limit structural validity.
- IPV4-ADDRESS and IPV6-ADDRESS are separate formats. An IPv4-mapped IPv6 address is not automatically converted to this format or normalized to the same value.
- This Value can be used as an identifier component of a Reference, but the reference policy and lifetime are not contained in the address bit pattern.
- If the Payload is not exactly 2 WORD, it is rejected.

## Standards basis {#표준-근거}

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) defines an IPv4 address as a fixed length of 4 octets (32 bits) and defines the Source Address and Destination Address each as a 32-bit field. The octet transmission order and the most-significant-bit-first rule of each octet in Appendix B are preserved in the Payload.
- The GEUL TAG, the Issuer assignment, the 16-bit WORD grouping, and the Length are not part of RFC 791 but framing rules added by this format.

## Length {#길이}

- The total is exactly 7 WORD: TAG 1 WORD, Issuer 2 WORD, codec number 2 WORD, and Payload 2 WORD, and it uses the direct length `LLLL=0110`. There is no Length extension TAG, no descriptor, and no padding.
- If the Payload is not exactly 2 WORD, it is rejected.

## Example {#예시}

The IPv4 address `1.2.3.4`:

```
09D6 0000 0007 0000 C001 0102 0304
```
