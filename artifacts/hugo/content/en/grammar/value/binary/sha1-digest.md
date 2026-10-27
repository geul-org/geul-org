---
title: "SHA1-DIGEST"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "SHA1-DIGEST is a fixed 11 WORD Value that holds the whole 160 bits of a SHA-1 result, used only for identification such as git object IDs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SHA1-DIGEST is a fixed-width Value that holds the whole SHA-1 result. It is Value direct code `0x62`, family BINARY. The Payload is exactly 10 WORDs (160 bits), and truncation is not allowed.

**Use it for identification only.** The collision resistance of SHA-1 is broken (SHAttered, 2017). For integrity and signatures, use [SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/). This format exists to hold an identifier already fixed as SHA-1 as it is, typically the object ID (commit ID) of a SHA-1 git repository. For example, the Version (commit ID) of [TRANSFORMED-BY](/grammar/meta/lineage/transformed-by/) is held in 11 WORDs instead of hex text (22 WORDs).

## Layout

```
TAG WORD          0x0D62 (0000 1101 0110 0010)  LLLL=1010
Payload           10 WORD  SHA-1 Digest
```

## Interpretation and Validity

- The 20 Payload octets are read in the SHA-1 output order as they are. Within each WORD, the upper octet comes first (the same framing as SHA-256-DIGEST).
- A representation whose Payload is not 10 WORDs, or in which the result was arbitrarily truncated (a git abbreviated ID and so on), is rejected. There is no descriptor or padding.
- A git object ID is the value git computed, as it is. Git's SHA-1 is a variant with collision detection (SHA-1DC), but for inputs that are not collision attacks the result is the same as SHA-1.

## Standards Basis

- The SHA-1 algorithm and the 160-bit result follow NIST [FIPS 180-4, Secure Hash Standard (SHS)](https://csrc.nist.gov/pubs/fips/180-4/final).
- The GEUL TAG and 16-bit WORD framing are rules this format adds.

## Length

- The total is exactly 11 WORDs, the TAG 1 WORD plus the Payload 10 WORD, using `LLLL=1010`. There is no Length extension.

## Example

The git commit `ddc0719974a32aaa7b422ee84221a9721085ce4c`:

```
0D62 ddc0 7199 74a3 2aaa 7b42 2ee8 4221 a972 1085 ce4c
```

## Related Pages

- [Value](/grammar/value/), [SHA-256-DIGEST](/grammar/value/binary/sha-256-digest/), [TRANSFORMED-BY](/grammar/meta/lineage/transformed-by/)
