---
title: "CODEC"
weight: 31
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC is a description Edge that specifies one Kind and Codec accepted by a FIELD (Codec 0x1E). Wildcards and slot markers (0x0000 not written, 0x0001 unknown, 0x0002 none) are also declared with it."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CODEC is a description Edge that specifies one Kind and Codec accepted by one [FIELD](/grammar/edge/field/). Codec `0x1E`.

Just as [ENUM](/grammar/edge/enum/) attaches a meaning to one code value of a raw-value field, CODEC attaches one format to a field. It is one per Edge, so several can be specified. The layout is built into the decoder ([Codec specification document](/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1110
[Length extension TAG]
Edge Id           LOCAL Reference record
Field             LOCAL Reference record that points to a FIELD Edge
Target            1 WORD. 000K KLLL LCCC CCCC (LLLL = 0000 exact, 1111 wildcard)
```

## Target WORD

- The Kind (`KK`) and Codec (`CCCCCCC`) positions of the TAG WORD are kept as they are. The upper 3 bits are 0. `LLLL` is `0000` (exact) or `1111` (wildcard); any other value is invalid.
- An exact target (`LLLL = 0000`) is the same value as the Codec specification document ID (for example, LOCAL `0x0008`, COORDINATE-EARTH `0x0804`, UTF8-LANGUAGE-TEXT `0x084A`). So the target points straight to that Codec's specification document.
- An odd-even code pair (text, byte string) is also specified with exact codes. To accept both even and odd, place both. There is no rule that interprets a pair together (there are adjacent codes that are not pairs, like NUMERIC `0x04`/`0x05`).

### Wildcards (`LLLL = 1111`)

- Kind must be the same, and **a Codec bit group that is 0 matches anything**. In a Reference, `CCCC` (Codec) and `QQQ` (Quantifier) are separate groups; in the other Kinds, all 7 bits are one group.

| Target | Meaning |
|---|---|
| `0780` | Any Reference |
| `07A0` | WIKIDATA-QID, any Quantifier |
| `0781` | Any Reference Codec, Quantifier Generic (`001`) |
| `0F80` | Any Value |
| `1780`, `1F80` | Any Edge, any Meta |

- A wildcard with nothing to match is invalid. For Value, Edge, and Meta the Codec must be 0, and for Reference one of `CCCC` or `QQQ` must be 0. Reference `CCCC = 0000` (slot markers) is a reserved Codec, so it **does not match any wildcard** (`0780` does not accept ABSENT, UNKNOWN-VALUE, or NO-VALUE). On the other hand, for Kinds where Codec 0 is assigned, like Value `0x00` (BOOL) and Edge `0x00` (REFERENCE-NODE), the wildcard includes it (to accept only BOOL, use `LLLL = 0000`).
- A wildcard does not point to a specification document.
- There is no expression that fixes only one non-zero group and also fixes the zero group, such as "any Reference but only Identified". Such a list enumerates the exact targets.
- The 7-bit Codec of a Reference contains the Quantifier (`QQQ`). A target specifies the Quantifier exactly. To accept several Quantifiers, place several CODECs.

### Slot Markers (targets `0000`-`0002`)

A [slot marker](/grammar/reference/slot-marker/) is a set of 1 WORD records in the reserved Reference Codec `0000`. The lower 3 bits are the marker number (not a Quantifier).

| Target | Marker | Meaning |
|---|---|---|
| `0000` | ABSENT | Not written. The field is an optional field |
| `0001` | UNKNOWN-VALUE | Unknown. Accepts the assertion that a value exists |
| `0002` | NO-VALUE | None. Accepts the assertion that there is no value |
| `0003`-`0007` | Reserved | |

- **Acceptance rule:** a marker is valid only when the same WORD is in the field's CODEC list as an exact target. A wildcard and a record field with no CODEC ("any record") do not accept markers. A marker in a HEAD or BODY record position or an Edge Id position is invalid.
- A list with only marker targets (always a marker) is invalid (a generalization of the rule for a list with only `0000`). Use it together with a wildcard or an exact target (`0780` + `0000` = any Reference or omitted).
- A marker target cannot be placed in a raw-value field. A raw value has no TAG and a fixed width, so there is no room for a 1 WORD marker.
- What a marker means is set by the Codec specification that accepts it.

### Optional Fields (target `0000`)

- If target `0000` is placed in the CODEC list of a record field, the field is an **optional field**. When omitted, the 1 WORD `0x0000` is written in that position. This 1 WORD record is the slot marker ABSENT (not written).
- `0x0000` is Reference Codec `0000` (reserved), marker number `000`, `LLLL = 0000` (1 WORD in total). It does not overlap other records, and a decoder that does not know the specification also skips it as a 1 WORD record.
- An optional field still always takes its position. When omitted, `0x0000` must be written and the position is not left empty (the same even for a trailing field). So a record has only one notation, and decomposition is decided by position alone. There is no restriction on the position and count of optional fields, or on whether lists overlap with other fields.
- ABSENT is valid only in an optional field position. A `0x0000` in a HEAD or BODY record position, a required field position, or an Edge Id position is invalid.
- Omission is "not written", not "no value". It asserts nothing about the world. "There is no value" is written with NO-VALUE (`0002`). What omission means (for example, if TAG has no target, it is this version) is set by each format's specification.

## Interpretation and Validity

- The field is a FIELD Edge in the same document. The same target is not placed twice on one field.
- **Record field (width 0)**: without a CODEC, it accepts any record except slot markers. With one or more, it is a closed list. The record in that field must have a Kind and Codec (for a Reference, including the Quantifier) that is in the list; otherwise that record does not follow the specification. This differs from ENUM, which is an open list.
- **Raw-value field (width n ≥ 1, or the rest `0xFFFF`)**: CODEC places only one exact target (no wildcards). That raw value is the Payload of that Value, without the TAG. The Kind and Codec come from CODEC, and the Length from the FIELD width. For an odd-even code, the specified code sets whether the byte count is odd or even. If the raw value does not follow the rules of that Value (including length), the record does not follow the specification.
- A slot marker is matched only against the exact targets of the list. If `0x0000` comes in an optional field (target `0000`) position, it is omission. Other records are matched against the list minus the marker targets.
- A raw-value field can have both CODEC and ENUM. CODEC is the format and ENUM is the name of a code value (for example, rank as UNSIGNED-INTEGER with 0, 1, 2 given ENUMs).
- The Edge Id of a CODEC can be given a name with BIND, but this is not required.
- A "Reference or Value" field is written with 2 CODECs (`0780`, `0F80`).

## Length

```
total = 1 + N_len + N_id + N_field + 1 WORDs   (6 WORDs if the Edge Id and field are LOCAL 1 WORD IDs)
```

## Example

In the LABEL specification document `geul.org/label`, the Object field (FIELD #3) accepts UTF8-LANGUAGE-TEXT (even and odd) and LOCAL. Edge Ids 7 to 9.

```
129E 0088 0007 0088 0003 084A
129E 0088 0008 0088 0003 084B
129E 0088 0009 0088 0003 0008
```

- TAG `129E` (Edge, Codec `0x1E`, `LLLL = 0101`, 6 WORDs), Edge Id `0088 0007`, field `0088 0003`, target `084A`.

## Related Pages

- [FIELD](/grammar/edge/field/), [ENUM](/grammar/edge/enum/), [DECLARE](/grammar/edge/declare/), [BIND](/grammar/edge/bind/)
- [Codec specification document](/grammar/codec-spec/), [LABEL](/grammar/edge/label/)
