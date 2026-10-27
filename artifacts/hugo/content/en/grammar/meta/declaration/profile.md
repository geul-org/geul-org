---
title: "PROFILE"
weight: 18
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "PROFILE is a declaration Meta that declares the profile applied to the document as a name and version text."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Declares the profile applied to the document. The same records are interpreted with the Codec documents the profile sets (for example, `tangeul-1.0` means [TOULMIN](/grammar/edge/toulmin/)).

## Layout

```
TAG WORD          0001 1LLL L001 0001      Codec 0x11
[Length extension TAG]
Payload           UTF8-TEXT Value "<name>-<major>.<minor>"
```

- Codec: Meta `0x11`, declaration class (`001`)
- Payload: embedded Value ([UTF8-TEXT](/grammar/value/text/utf8-text/))
- Count: at most one

## Interpretation and Validity

- A profile with a different major is rejected. A minor difference is allowed (additive changes only).
- Without a profile, the document is read with only the GEUL base grammar and the direct code specifications.

## Example

- `tangeul-1.0`: `0x1B91 0x0B41 7461 6e67 6575 6c2d 312e 3000`

## Open Questions

- The profile name registry (geul.org) and the naming rules.
- Whether to point to a profile by document ID (IMPORT) or to put it as text.
