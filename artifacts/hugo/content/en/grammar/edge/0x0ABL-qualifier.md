---
title: "QUALIFIER (0x0ABL)"
weight: 171
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER is a statement Edge that attaches one condition qualifying the proposition held by another Edge (mainly a TRIPLE)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `QUALIFIER` (specification document BIND `QUALIFIER`) |
| TAG ID | `0x0ABL` |
| Codec ID | `0x00000AB0` |
| Specification document | `0x00000000/codecs/0x00000AB0/` (DECLARE target `0AB0`) |
| Section | 5 `0101` (Edge statement), offset within section C = 11 |
| Kind | Edge · family: statement, group: proposition |
| TAG WORD | `0000 1010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | One condition qualifying another Edge's proposition. Property, Target (Edge Id), Value (a value or an UNKNOWN-VALUE / NO-VALUE marker). It is part of the proposition |
| Hugo side | `edge/qualifier.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `property` | #2 | record | Any record (excluding slot markers) |  |
| 2 | `target` | #3 | record | `0050` LOCAL |  |
| 3 | `value` | #4 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference), `060F` all of section 3 (wildcard, Value), `080F` all of section 4 (wildcard, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |

QUALIFIER is a statement Edge that attaches one condition qualifying the proposition held by another Edge (mainly a [TRIPLE](0x0AAL-triple.md)). Codec `0x0ABL`.

It corresponds to one Wikidata qualifier (snak): one property and one value.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1011 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Property          Reference record (WIKIDATA-PID, etc.)
Target            LOCAL Reference record (Edge Id of the Edge being qualified)
Value             Reference or Value record, or slot marker 0x0010 UNKNOWN-VALUE / 0x0020 NO-VALUE
```

- The order of components is the same as TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). A decoder reads along the same path. The roles are set by the Codec.

## Interpretation and validity {#해석과-유효성}

- Property and Target are each exactly one complete Reference record, and Target is a LOCAL Reference. The geul.org specification document places [CODEC](0x0BEL-codec.md) LOCAL (`0050`) on Target. Value is exactly one complete Reference or Value record, or one WORD of [slot marker](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) or `0x0020` (NO-VALUE). The specification document places CODEC `000F`, `020F`, `040F` (any Reference), `060F`, `080F` (any Value), `0010`, `0020` on Value. ABSENT (`0x0000`) is not accepted. Property and Target do not accept slot markers. The cursor after reading Value must coincide with the end of the Edge.
- Target is an Edge Id within the same document. A QUALIFIER is placed in the same document as the Edge it qualifies.
- If Target is the HEAD [SOURCE](0x0C0L-source.md#문서-전체의-출처) (the origin of the whole document), the QUALIFIER is also placed in HEAD, after that SOURCE. Every other QUALIFIER is placed in BODY. A QUALIFIER in BODY whose Target is the HEAD SOURCE is invalid.
- Target may be an Edge other than a TRIPLE. A QUALIFIER attached to a [SOURCE](0x0C0L-source.md) qualifies the act of citation (access date, location within the origin, etc.). The meaning of a SOURCE is also the collection of all QUALIFIERs that point to it.
- **A QUALIFIER is part of the proposition.** It is not a separate claim about the proposition; it qualifies the conditions under which the proposition holds. The meaning of the target TRIPLE is the collection of all QUALIFIERs that point to it.
  - The provenance of a proposition is written as [SOURCE](0x0C0L-source.md). Properties of the origin node (title, author, etc.) are written as a TRIPLE whose Subject is the origin.
- There may be several QUALIFIERs with the same Property on the same Target. The order of QUALIFIERs with the same Target is their order in the document (an exception where Edge order carries meaning).

## Unknown and none {#알-수-없음과-없음}

When the Value of a QUALIFIER is a slot marker, the meaning of that qualification changes. Take end time (P582) as an example.

| Attached to the target TRIPLE | Meaning | Is the proposition still valid now |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | It ended in 1974 | No |
| `QUALIFIER P582 #n UNKNOWN` | It ended. It is not known when (Wikidata `somevalue`) | No |
| `QUALIFIER P582 #n NONE` | It is asserted that it has not ended (Wikidata `novalue`) | Yes |
| no P582 QUALIFIER | It is not known whether it ended (open world) | Unknown |

- Dropping the `somevalue` and `novalue` of a Wikidata qualifier broadens the proposition. A border TRIPLE whose end-time somevalue is dropped reads as "a border that is still valid". So they are carried over as markers.
- UNKNOWN-VALUEs are not regarded as the same value. The comparison result is undetermined.

## Examples (non-normative) {#예시-비규범}

Q42 P69 (educated at) Q691283 (St John's College), 1971-1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORDs. Value is the [EDTF](../value/0x06EL-edtf.md) `"1971"`.

```
0AB9 0051 000A 0191 0244 0051 0009 06E2 3139 3731
```

The border (P47) between Q30 (United States) and Q34266 (Russian Empire), with an unknown end time. Edge Ids `2060` and `3160`.

```
0AA9 0051 080C 0191 002F 0141 001E 0141 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
0AB7 0051 0C58 0191 0246 0051 080C 0010                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `0AB7` = `000 0101 01011 0111` (section 5): Edge, Codec `0x0ABL`, 8 WORDs. TAG 1 + Edge Id 2 + Property P582 (`0191 0246`) 2 + Target #2060 (`0051 080C`) 2 + marker 1.

A period is attached to the NO-VALUE TRIPLE `#3161` for Q30's central bank (P1304). It was absent only in 1811-1816.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000           #3161 TRIPLE P1304 Q30 NONE normal
0AB9 0051 0C5A 0191 0244 0051 0C59 06E2 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
0AB9 0051 0C5B 0191 0246 0051 0C59 06E2 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Related pages {#관련-페이지}

- [Edge](_index.md), [TRIPLE](0x0AAL-triple.md), [SOURCE](0x0C0L-source.md), [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [EDTF](../value/0x06EL-edtf.md), [slot marker](../slot-marker.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000AB0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AB000000000
BODY
#1 DECLARE 0x0AB0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 BIND #1 "QUALIFIER"
#6 BIND #2 "property"
#7 BIND #3 "target"
#8 BIND #4 "value"
#9 CODEC #3 0x0050
#10 CODEC #4 0x000F
#14 CODEC #4 0x020F
#15 CODEC #4 0x040F
#11 CODEC #4 0x060F
#16 CODEC #4 0x080F
#12 CODEC #4 0x0010
#13 CODEC #4 0x0020
```
