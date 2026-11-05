---
title: "CODEC (0x0BEL)"
weight: 190
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC is a statement Edge that specifies one Kind and Codec accepted by a FIELD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `CODEC` (specification document BIND `CODEC`) |
| TAG ID | `0x0BEL` |
| Codec ID | `0x00000BE0` |
| Specification document | `0x00000000/codecs/0x00000BE0/` (DECLARE target `0BE0`) |
| Section | 5 `0101` (Edge statement), offset within section C = 30 |
| Kind | Edge · family: statement, group: other |
| TAG WORD | `0000 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | One Kind and Codec accepted by a field. Field, target WORD (`000K KKKC CCCC LLLL`; LLLL 0000 exact, 1111 wildcard (all 32 slots of that section); slot markers only as the exact targets `0000`, `0010`, `0020`). A record field takes several (a closed list), a raw-value field takes one (that Value without its TAG) |
| Hugo side | `edge/codec.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | record | `0050` LOCAL |  |
| 2 | `target` | #4 | raw value, 1 WORD |  |  |

CODEC is a statement Edge that specifies one Kind and Codec accepted by one [FIELD](0x0BCL-field.md). Codec `0x0BEL`.

Just as [ENUM](0x0BDL-enum.md) attaches a meaning to one code value of a raw-value field, CODEC attaches one form to a field. Since each Edge carries one, several can be specified. The layout is built into the decoder ([Codec specification document](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1110 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Field             LOCAL Reference record pointing to a FIELD Edge
Target            1 WORD. 000K KKKC CCCC LLLL (LLLL = 0000 exact, 1111 wildcard)
```

## Target WORD {#대상-word}

- The Codec slot of a TAG WORD (section `KKKK` and `CCCCC`) is kept as is. The upper 3 bits are 0. `LLLL` is `0000` (exact) or `1111` (wildcard); any other value is invalid.
- An exact target (`LLLL = 0000`) written as 32 bits is the codec ID of that Codec (e.g. LOCAL `0x0050` → `0x00000050`, COORDINATE-EARTH `0x0640`, UTF8-LANGUAGE-TEXT `0x0780`). So the target points directly to the specification document of that Codec ([Codec specification document](../codec-spec.md)).
- An even-odd code pair (text, byte string) is also specified by exact codes. To accept both even and odd, place both. There is no rule that interprets a pair together (there are adjacent codes that are not pairs, like NUMERIC `0x064L`/`0x065L`).

### Wildcard (`LLLL = 1111`) {#와일드카드-llll--1111}

- If `LLLL = 1111`, the whole section `KKKK` (32 slots) of the target WORD is accepted, regardless of the `C` value. Within the same section, the meaning is the same for any `C`. Only whether the section of the target and the section of the record are the same is checked. It does not accept beyond the section.
- If `LLLL = 1111`, the first slot of the section (`C = 0`) is recommended. This is a recommendation, not enforced. Another `C` of the same section is also valid.
- If a Kind spans several sections, list a CODEC for each section.

| Target | Meaning |
|---|---|
| `000F`, `020F`, `040F` | Any Reference (sections 0-2, including REFERENCE-ISSUER) |
| `060F`, `080F` | Any Value (sections 3 and 4, including VALUE-ISSUER) |
| `0A0F`, `0C0F`, `0E0F`, `100F`, `120F`, `140F`, `160F`, `180F`, `1A0F` | Any Edge (sections 5-13, including EDGE-ISSUER) |
| `1C0F`, `1E0F` | Any Meta (sections 14 and 15) |

- Reference slot markers (`0x000L~0x002L`) do not match `LLLL = 1111` (`000F` does not accept ABSENT, UNKNOWN-VALUE, or NO-VALUE). Meanwhile, even a section whose first slot is assigned, like Value `0x060L` (BOOL) or Edge `0x0A0L` (REFERENCE-NODE), is included by `LLLL = 1111` (to accept only BOOL, use `0600` with `LLLL = 0000`).
- A target with `LLLL = 1111` does not point to a specification document.
- Quantifier-agnostic groups or bundles are written only by listing CODECs (`LLLL = 0000`). Example: WIKIDATA-QID with any quantifier is five codes: `0140`, `0150`, `0160`, `0170`, `0180`.
- The codes of the Reference 5Q scheme contain the quantifier. A target specifies the quantifier exactly. To accept several Quantifiers, place several CODECs. The quantifier of REFERENCE-ISSUER is set by the Issuer's document.

### Slot markers (targets `0000`, `0010`, `0020`) {#자리-표지-대상-0000-0010-0020}

[Slot markers](../slot-marker.md) are a group of 1-WORD records assigned to the first three slots `0x000L~0x002L` of Reference section 0. They have no quantifier.

| Target | Marker | Meaning |
|---|---|---|
| `0000` | ABSENT | Not written. That field is an optional field |
| `0010` | UNKNOWN-VALUE | Unknown. Accepts the assertion that a value exists |
| `0020` | NO-VALUE | None. Accepts the assertion that no value exists |

- **Acceptance rule:** A marker is valid only when the same WORD is present as an exact target in the CODEC list of that field. A record field with a wildcard or with no CODEC ("any record") does not accept markers. A marker in a HEAD or BODY record slot or in an Edge Id slot is invalid.
- A list with only marker targets (always a marker) is invalid (a generalization of the rule for a list with only `0000`). Use it together with an `LLLL = 1111` target or an exact target (`000F`, `020F`, `040F` + `0000` = any Reference or omitted).
- Marker targets cannot be placed on a raw-value field. A raw value has no TAG and its width is fixed, so there is no room for a 1-WORD marker.
- The meaning of a marker is set by the Codec specification that accepts it.

### Optional field (target `0000`) {#선택-필드-대상-0000}

- If target `0000` is placed in the CODEC list of a record field, that field is an **optional field**. When omitted, the 1 WORD `0x0000` is written in that slot. This 1-WORD record is the slot marker ABSENT (not written).
- `0x0000` is Reference, Codec `0x000L` (Reserved), `LLLL = 0000` (1 WORD in total). It does not collide with other records, and a decoder that does not know the specification also skips it as a 1-WORD record.
- An optional field also always occupies its slot. When omitted, `0x0000` must be written and the slot is not left empty (the same even for a trailing field). So a record has only one notation, and decomposition is determined by position alone. There are no constraints on the position and number of optional fields or on whether the list overlaps with other fields.
- ABSENT is valid only in an optional-field slot. `0x0000` in a HEAD or BODY record slot, a required-field slot, or an Edge Id slot is invalid.
- Omission is "not written", not "no value". Nothing is asserted about the world. "There is no value" is written as NO-VALUE (`0020`). What an omission means (e.g. if a TAG has no target, this version) is set by the specification of each form.

## Interpretation and validity {#해석과-유효성}

- The field is a FIELD Edge in the same document. The same target is not placed twice on one field.
- **Record field (width 0)**: With no CODEC, it accepts any record other than slot markers. With one or more, it is a closed list. The record in that field must have a Kind and Codec (including the Quantifier for Reference) in the list; otherwise that record does not follow the specification. This differs from ENUM being an open list.
- **Raw-value field (width n ≥ 1, or remaining `0xFFFF`)**: CODEC places only one exact target (no wildcard). That raw value is the Payload of that Value without its TAG. Kind and Codec come from the CODEC, and Length comes from the FIELD width. For even-odd codes, the specified code sets the parity of the byte count. If the raw value does not follow the rules of that Value (including length), that record does not follow the specification.
- A slot marker is checked only against the exact targets of the list. If `0x0000` appears in an optional-field (target `0000`) slot, it is an omission. Any other record is checked against the list minus the marker targets.
- CODEC and ENUM can be placed together on a raw-value field. CODEC is the form and ENUM is the name of the code value (e.g. rank as UNSIGNED-INTEGER with 0, 1, 2 as ENUM).
- A name can be attached to the Edge Id of a CODEC with BIND, but it is not required.
- A "Reference or Value" field is written with five CODECs (`000F`, `020F`, `040F`, `060F`, `080F`).

## Length {#길이}

```
total = 1 + N_len + N_id + N_field + 1 WORD   (6 WORDs if Edge Id and field are LOCAL 1-WORD IDs)
```

## Example {#예시}

In the LABEL specification document `0x00000000/codecs/0x00000A40/`, the Object field (FIELD #3) accepts UTF8-LANGUAGE-TEXT (even and odd) and LOCAL. Edge Ids 7-9.

```
0BE5 0051 0007 0051 0003 0780
0BE5 0051 0008 0051 0003 0790
0BE5 0051 0009 0051 0003 0050
```

- TAG `0BE5` (Edge, Codec `0x0BEL`, `LLLL = 0101`, 6 WORDs), Edge Id `0051 0007`, field `0051 0003`, target `0780`.

## Related pages {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [DECLARE](0x0BBL-declare.md), [BIND](0x0A3L-bind.md)
- [Codec specification document](../codec-spec.md), [LABEL](0x0A4L-label.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000BE0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BE000000000
BODY
#1 DECLARE 0x0BE0
#2 FIELD #1 record
#3 CODEC #2 0x0050
#4 FIELD #1 0x0001
#5 BIND #1 "CODEC"
#6 BIND #2 "field"
#7 BIND #4 "target"
```
