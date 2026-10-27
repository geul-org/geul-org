---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM is a description Edge that attaches a meaning to one code value of a raw-value field (Codec 0x1D). The name is bound with BIND."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM is a description Edge that attaches a meaning to one code value of a raw-value field. Codec `0x1D`.

Together with [FIELD](/grammar/edge/field/), it is the vocabulary for writing Codec specifications. The layout is built into the decoder ([Codec specification document](/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1101
[Length extension TAG]
Edge Id           LOCAL Reference record
Field             LOCAL Reference record that points to a FIELD Edge
Code value        raw value. The same WORD count as the width of that FIELD
```

## Interpretation and Validity

- The field must be a raw-value FIELD (width `n ≥ 1`). ENUM is not attached to a record field. The meaning of a record is stated by that record's Codec.
- The code value is exactly the width of that FIELD. The boundary is checked by the Length of the ENUM record.
- The same code value is not declared twice in one field.
- The name of a code value is bound to the ENUM Edge Id with [BIND](/grammar/edge/bind/). All UTF8-TEXT attached to DECLARE, FIELD, ENUM, and CODEC is done with BIND, not with another Edge such as LABEL.
- An undeclared code value is not an error. The viewer shows the raw value as it is. Whether to close the allowed values is up to the Codec specification, and the current vocabulary has no marker for closing.

## Length

```
total = 1 + N_len + N_id + N_field + n WORDs
```

## Example (non-normative)

In the TOMBSTONE specification document, declare the code `0x0001` for the reason category field (FIELD #4, raw value 1 WORD). Edge Id 10. The name is bound separately with BIND. The reason category code table is not yet decided, so the code value is an example.

- TAG 1 + Edge Id 2 + field 2 + code value 1 = 6 WORDs, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

The TRIPLE specification document places three ENUMs (`0`, `1`, `2`) on the Rank field (FIELD #5) and binds them to `normal`, `preferred`, and `deprecated` with BIND ([TRIPLE](/grammar/edge/triple/)).

## Related Pages

- [DECLARE](/grammar/edge/declare/), [FIELD](/grammar/edge/field/), [CODEC](/grammar/edge/codec/), [BIND](/grammar/edge/bind/)
- [Codec specification document](/grammar/codec-spec/)
