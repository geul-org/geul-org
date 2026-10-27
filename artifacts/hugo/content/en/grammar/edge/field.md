---
title: "FIELD"
weight: 29
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD is a description Edge that declares one field of a Codec Payload (Codec 0x1C). It writes the DECLARE it belongs to and the width (record, raw value of n WORDs, rest raw value)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FIELD is a description Edge that declares one field of a Codec Payload. Codec `0x1C`.

A FIELD points to its own [DECLARE](/grammar/edge/declare/). The FIELDs that point to one DECLARE compose the Payload in their order in the document. The layout is built into the decoder ([Codec specification document](/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1100
Edge Id           LOCAL Reference record
DECLARE           LOCAL Reference record. The DECLARE Edge this field belongs to
Width             1 WORD. 0 = record, n (1-65534) = raw value of n WORDs, 0xFFFF = rest raw value
```

## Interpretation and Validity

- DECLARE points to a DECLARE Edge in the same document. One FIELD belongs to only one DECLARE. The order is not written separately; it is the order in which the FIELD records lie in the document.
- The FIELD specification document declares DECLARE as a field of width `0` (record) with CODEC `0008` (LOCAL). So in the viewer graph it is drawn as a FIELD → DECLARE link.
- Width `0` is a record field. It starts with a TAG WORD and is read for the Length of that TAG (the interpretation rules of [DECLARE](/grammar/edge/declare/)).
- Width `n` (1-65534) is a raw-value field. It is always exactly n WORDs.
- Width `0xFFFF` is a rest raw value. Only one is placed in a DECLARE, and it can be at the front, middle, or end. Its width is the remaining WORDs set by the TAG Length of the enclosing record, minus the widths of the fields after it. So every field after a rest field must be a fixed-width raw value (a record can be read only from the front to know its end). It can be 0 WORDs. ENUM is not attached to it.
- The Kind and Codec a field accepts are specified with [CODEC](/grammar/edge/codec/). A record field accepts any record if there is no CODEC, and if there is one, the record must be one of them. If one CODEC is placed on a raw-value field, that raw value is interpreted as that Value without the TAG.
- The field name is bound to the FIELD Edge Id with [BIND](/grammar/edge/bind/) (for example, `doc`, `hash`). All UTF8-TEXT attached to DECLARE, FIELD, ENUM, and CODEC is done with BIND, not with another Edge such as LABEL.
- The meaning of the code values of a raw-value field is attached with [ENUM](/grammar/edge/enum/).
- A field that points to another node in the graph is not marked separately. If a record field is a Reference, that is the link.

## Length

```
total = 1 + 2 + 2 + 1 WORDs   (when the Edge Id and DECLARE are LOCAL 1 WORD IDs)
```

## Example (non-normative)

- A record field: Edge Id 7, DECLARE #1, width `0`. TAG 1 + Edge Id 2 + DECLARE 2 + width 1 = 6 WORDs. To make it accept only LOCAL, see the [CODEC](/grammar/edge/codec/) example.

```
129C 0088 0007 0088 0001 0000
```

- For a raw-value field such as a content hash, see the [DECLARE](/grammar/edge/declare/) example.

## Related Pages

- [DECLARE](/grammar/edge/declare/), [ENUM](/grammar/edge/enum/), [CODEC](/grammar/edge/codec/), [BIND](/grammar/edge/bind/)
- [Codec specification document](/grammar/codec-spec/)
