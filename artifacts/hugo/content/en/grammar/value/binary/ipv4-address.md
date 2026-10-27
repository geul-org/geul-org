---
title: "IPV4-ADDRESS"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "IPV4-ADDRESS is a fixed 5 WORD IETF Issuer format that holds the 32 bits of an IPv4 address in network byte order as they are."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

IPV4-ADDRESS is a fixed-width Value that holds the 32-bit value of an IPv4 address. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0020` IETF, format number `0xC001`, family BINARY. The Payload is exactly 2 WORDs (32 bits).

## Layout

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  5 WORD in total
Issuer            1 WORD  0x0020 (IETF)
Format number     1 WORD  0xC001
Payload           2 WORD  address octet 1–2 │ address octet 3–4
```

## Interpretation and Validity

- The address octets are kept in network byte order as they are. In each WORD, the octet that comes first is the upper 8 bits and the next octet is the lower 8 bits.
- The Payload holds only the 32 bits of one address. It does not hold a CIDR prefix length, port, or transport protocol.
- Every 32-bit pattern can be represented. The operational meaning and usability of patterns such as unspecified, special, reserved, and multicast are judged by external context and do not restrict structural validity.
- IPV4-ADDRESS and IPV6-ADDRESS are separate formats. An IPv4-mapped IPv6 address is not automatically converted to this format or normalized to the same value.
- This Value can be used as an identifier component of a Reference, but the reference policy and lifetime are not in the address bit pattern.
- If the Payload is not exactly 2 WORDs, reject.

## Standards Basis

- [RFC 791 — Internet Protocol](https://www.rfc-editor.org/rfc/rfc791.html) defines an IPv4 address as a fixed length of 4 octets (32 bits), and defines the Source Address and Destination Address each as a 32-bit field. The octet transmission order of Appendix B and the most-significant-bit-first rule of each octet are preserved in the Payload.
- The GEUL TAG, Issuer assignment, 16-bit WORD grouping, and Length are not part of RFC 791 but are framing rules this format adds.

## Length

- The total is exactly 5 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 2 WORD, using the direct length `LLLL=0100`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 2 WORDs, reject.

## Example

The IPv4 address `1.2.3.4`:

```
0a7c 0020 c001 0102 0304
```
