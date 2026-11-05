---
title: "REFERENCE-NODE (0x0A0L)"
weight: 160
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE is a directional statement Edge that connects one Reference to one Object record, defining or binding what that Reference is."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `REFERENCE-NODE` (specification document BIND `REFERENCE-NODE`) |
| TAG ID | `0x0A0L` |
| Codec ID | `0x00000A00` |
| Specification document | `0x00000000/codecs/0x00000A00/` (DECLARE target `0A00`) |
| Section | 5 `0101` (Edge statement), offset within section C = 0 |
| Kind | Edge · family: statement, group: pointing and names |
| TAG WORD | `0000 1010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | A directional binding in which Subject, a Reference, points to Object |
| Hugo side | `edge/reference-node.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | Any record (excluding slot markers) |  |
| 2 | `object` | #3 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference), `060F` all of section 3 (wildcard, Value), `080F` all of section 4 (wildcard, Value) |  |

REFERENCE-NODE is a directional statement Edge that connects one Reference to one Object record, defining or binding what that Reference is. Codec `0x0A0L`.

Subject points to Object. This binding is not [SAME-NODE](0x0A1L-same-node.md), which asserts semantic identity, nor does it mean that the bytes of the two records are equal.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0000 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Subject           1 Reference record
Object            1 Reference or Value record
```

## Interpretation and validity {#해석과-유효성}

- Subject must be exactly one complete [Reference](../reference/_index.md) record. Its boundary is found by Subject's own Length; if it is not a Reference or is incomplete, it is invalid.
- Object must be exactly one complete Reference or Value record. Its boundary is found by Object's own Length; if it is an Edge or Meta, or is incomplete, it is invalid.
- If Object is a Reference, the Reference chain followed through REFERENCE-NODE bindings must not be cyclic, and a LOCAL must ultimately resolve. A resolution cycle and a dangling LOCAL are invalid.
- If one LOCAL ID in the same document is bound to conflicting Objects, it is invalid. The scope, ID, minimum width, and merge rules of LOCAL follow [LOCAL](../reference/0x005L-local.md).
- Not every Reference needs to be bound by REFERENCE-NODE.
- The representative use is `LOCAL → UTF8-LANGUAGE-TEXT`. When a LOCAL is placed in the Object of [LABEL](0x0A4L-label.md), the text is resolved by this binding in the same document.

The direction in which Subject points to Object must not be interpreted in reverse. The meaning and detailed rules of SAME and DIFFERENT are set by each of those forms separately.

## Length {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` is the number of Length extension TAG WORDs, `N_id` is the number of WORDs of the Edge Id LOCAL record, and `N_subject` and `N_object` are the total WORD counts of each record. The cursor after reading both Subject and Object must coincide exactly with the end of the Edge.

## Example (non-normative) {#예시-비규범}

Edge Id `0008`, Subject is LOCAL 1, and Object is the [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md) of `Donald Trump` (en).

- The Edge Id is `0051 0008`, 2 WORDs.
- Subject is `0051 0001`, 2 WORDs.
- Object is language `0761 656E` (BCP47 `en`) + 12 bytes of text (even), so it is `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), 9 WORDs in total. The TAG is `0788`.
- The Edge is TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORDs, `LLLL=1101`. The TAG is `0A0D`.

```
0A0D 0051 0008 0051 0001 0788 0761 656E 446F 6E61 6C64 2054 7275 6D70
```

## Related pages {#관련-페이지}

- [Edge](_index.md), [SAME-NODE](0x0A1L-same-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md), [LABEL](0x0A4L-label.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md), [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000A00/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A0000000000
BODY
#1 DECLARE 0x0A00
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "REFERENCE-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x000F
#9 CODEC #3 0x020F
#10 CODEC #3 0x040F
#8 CODEC #3 0x060F
#11 CODEC #3 0x080F
```
