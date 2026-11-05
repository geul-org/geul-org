---
title: "PROFILE (0x1C6L)"
weight: 454
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "Declares the profile applied to the document."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `PROFILE` (spec document BIND `PROFILE`) |
| TAG ID | `0x1C6L` |
| Codec ID | `0x00001C60` |
| Spec document | `0x00000000/codecs/0x00001C60/` (DECLARE target `1C60`) |
| Section | 14 `1110` (Meta), offset within section C = 6 |
| Kind | Meta · class: declaration |
| TAG WORD | `0001 1100 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Applied profile |
| Hugo side | `meta/declaration/profile.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs within the document is the order of Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `profile` | #2 | record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD |  |

Declares the profile applied to the document. The same records are interpreted with the Codec documents the profile specifies (for example, `tangeul-1.0` means [TOULMIN](../toulmin/_index.md)).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0110 LLLL      Codec 0x1C6L
[Length extension TAG]
Payload           UTF8-TEXT Value "<name>-<major>.<minor>"
```

- Codec: Meta `0x1C6L`, declaration class
- Payload: embedded Value ([UTF8-TEXT](../value/0x072L-utf8-text.md))
- Count: at most one

## Interpretation and validity {#해석과-유효성}

- A profile with a different major is rejected. A minor difference is allowed (additive changes only).
- Without a profile, the document is read with the GEUL base grammar and the direct-code specification alone.

## Example {#예시}

- `tangeul-1.0`: `0x1C67 0x0736 7461 6E67 6575 6C2D 312E 3000`

## Open issues {#열린-문제}

- A profile name registry (geul.org) and naming rules.
- Whether to refer to a profile by document ID (IMPORT) or hold it as text.

## Spec document source {#규격-문서-원문}

The spec document `0x00000000/codecs/0x00001C60/latest.geul` as read with `geul show` (hex in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C6000000000
BODY
#1 DECLARE 0x1C60
#2 FIELD #1 record
#3 BIND #1 "PROFILE"
#4 BIND #2 "profile"
#5 CODEC #2 0x0720
#6 CODEC #2 0x0730
```
