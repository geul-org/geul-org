---
title: "MAC-48-ADDRESS"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "MAC-48-ADDRESS is a fixed 6 WORD IEEE Issuer format that holds a 48-bit IEEE 802 MAC address in octet order as it is."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

MAC-48-ADDRESS is a fixed-width Value that holds the value of a 48-bit IEEE 802 MAC address. It is Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, format number `0xC000`, family BINARY. The Payload is exactly 3 WORDs (6 octets, 48 bits).

## Layout

```
TAG WORD          0x0AFC (0000 1010 1111 1100)  6 WORD in total
Issuer            1 WORD  0x0040 (IEEE)
Format number     1 WORD  0xC000
Payload           3 WORD  octet 0 → 1 │ octet 2 → 3 │ octet 4 → 5
```

## Interpretation and Validity

- The six octets of the 48-bit MAC address are kept in the octet order of the notation string and of LAN transmission. Octets 0-1, 2-3, and 4-5 are each grouped into a WORD from the upper octet to the lower octet.
- On IEEE 802 media, the least-significant bit of each octet is transmitted first, but the bits within an octet are not reversed for that reason. I/G and U/L remain in the least-significant bit of octet 0 and the next bit.
- I/G=0 is an individual address and is used as unicast at the destination; I/G=1 is a group address and is used as multicast or broadcast. U/L=0 is a universally administered address, and U/L=1 is a locally administered address.
- No pattern is excluded structurally because of the I/G or U/L value. It can represent universally and locally administered, and individual and group addresses, and locally administered, randomized, spoofed, and virtual MAC addresses can also be represented as 48-bit values.
- This value preserves only the 48 bits of an observed or presented address. It does not guarantee the permanent address of a particular device, global uniqueness, device or user authentication, ownership, or persistent association with the same device.
- This format handles only IEEE 802 MAC addresses of exactly 48 bits. It does not hold EUI-64 or other 64-bit MAC addresses. The IEEE RA describes the historical term `MAC-48` as obsolete, but not every 48-bit MAC address can be called EUI-48, so this format is not automatically identified with EUI-48.
- If the Payload is not exactly 3 WORDs, reject.

## Standards Basis

- The IEEE Registration Authority's [Standard Group MAC Addresses](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/macgrp.pdf) notates a 48-bit LAN MAC address as six octets in transmission order, and explains that each octet is transmitted starting from its least-significant bit and that I/G and U/L are the two least-significant bits of the first octet. This format preserves the octet and bit positions as they are.
- The IEEE Registration Authority's [Guidelines for Use of EUI, OUI, and CID](https://standards.ieee.org/wp-content/uploads/import/documents/tutorials/eui.pdf) defines I/G=0/1 as individual/group and U/L=0/1 as universal/local administration, and explains that a local address is not globally unique. It also explains the historical relationship and difference between the terms `MAC-48` and EUI-48.
- [IEEE SA — MAC Addresses](https://standards.ieee.org/products-programs/regauth/mac/) explains that EUI-48 and EUI-64 can be used as MAC addresses and so on. This does not mean that an EUI-64 is put in this 48-bit record.
- [RFC 9724 — State of Affairs for Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9724.html) and [RFC 9797 — Randomized and Changing MAC Addresses](https://www.rfc-editor.org/rfc/rfc9797.html) record that real devices randomly generate and change locally administered MAC addresses. So a permanent device identity is not inferred from a MAC value alone.
- The GEUL TAG, Issuer assignment, direct Length, and 16-bit WORD framing are not part of IEEE 802 or the materials above but are rules this format adds.

## Length

- The total is exactly 6 WORDs: the TAG 1 WORD, Issuer 1 WORD, format number 1 WORD, and Payload 3 WORD, using the direct length `LLLL=0101`. There is no Length extension TAG, descriptor, or padding.
- If the Payload is not exactly 3 WORDs, reject.

## Example

A locally administered individual (unicast) address `02:00:5e:10:00:00` (first octet `0x02` has I/G=0, U/L=1):

```
0afc 0040 c000 0200 5e10 0000
```
