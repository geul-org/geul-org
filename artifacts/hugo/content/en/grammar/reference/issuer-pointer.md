---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER is a pointer-declaration Reference that points to an Issuer itself. Its Payload is just one Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER is a pointer-declaration Reference that points to an Issuer itself. It can be the target of an Issuer name `BIND`, a `LABEL`, or a judgment Edge.

## Layout

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length extension TAG]
Issuer            1/2/4/16 WORD
```

- The Issuer width is the whole Payload. The Codec does not divide the width. If the width is not 1, 2, 4, or 16 WORDs, or if the Issuer value fits in a narrower width, it is invalid (Issuer canonical form).
- If the Issuer is 16 WORDs, the total is 17 WORDs, so 1 WORD of Length extension is added.
- Only Quantifier `000` (Identified) is used. Any other value is invalid.
- The Issuer value follows the assignment in [Issuer](/grammar/issuer/).
- Uses: the BIND Subject of the Issuer name index `issuers.geul` ([Publication Addresses and Version Lists](/grammar/publishing/#issuer-names)), the LABEL for an Issuer display name, judgments about an Issuer, signers, and other places where the Issuer itself is the target.
- The only form that points to an Issuer itself is ISSUER-POINTER. Pointing to an Issuer by using `EXTERNAL-ISSUER-*` with document ID `0` and target ID `0` is invalid.

## Examples

| Issuer | WORD sequence |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## Related Pages

- [Reference](/grammar/reference/), [DOC-POINTER](/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/grammar/reference/external-issuer/), [Issuer and Publication](/grammar/issuer/)
