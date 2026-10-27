---
title: "QUALIFIER"
weight: 12
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "QUALIFIER is a description Edge that attaches one condition qualifying the proposition of another Edge (mainly a TRIPLE) (Codec 0x0B). Its Value can be unknown (UNKNOWN-VALUE) or none (NO-VALUE) instead of a value."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUALIFIER is a description Edge that attaches one condition qualifying the proposition held by another Edge (mainly a [TRIPLE](/grammar/edge/triple/)). Codec `0x0B`.

It is the same as one Wikidata qualifier (snak): one property and one value.

## Layout

```
TAG WORD          0001 0LLL L000 1011
[Length extension TAG]
Edge Id           LOCAL Reference record
Property          Reference record (WIKIDATA-PID and so on)
Target            LOCAL Reference record (the Edge Id of the Edge being qualified)
Value             Reference or Value record, or the slot marker 0x0001 UNKNOWN-VALUE or 0x0002 NO-VALUE
```

- The component order is the same as TRIPLE (Property ↔ Predicate, Target ↔ Subject, Value ↔ Object). A decoder reads along the same path. The roles are set by the Codec.

## Interpretation and Validity

- Property and Target are each exactly one complete Reference record, and Target is a LOCAL Reference. A geul.org specification document places [CODEC](/grammar/edge/codec/) LOCAL (`0008`) on Target. Value is exactly one complete Reference or Value record, or a 1 WORD [slot marker](/grammar/reference/slot-marker/) `0x0001` (UNKNOWN-VALUE) or `0x0002` (NO-VALUE). The specification document places CODEC `0780`, `0F80`, `0001`, and `0002` on Value. ABSENT (`0x0000`) is not accepted. Property and Target do not accept slot markers. The cursor after reading Value must match the end of the Edge.
- Target is an Edge Id inside the same document. A QUALIFIER is placed in the same document as the Edge it qualifies.
- If Target is a HEAD [SOURCE](/grammar/edge/source/#source-of-the-whole-document) (the source of the whole document), the QUALIFIER is also placed in the HEAD, after that SOURCE. Other QUALIFIERs are placed in the BODY. A QUALIFIER whose Target is a HEAD SOURCE found in the BODY is invalid.
- Target can be an Edge other than a TRIPLE. A QUALIFIER attached to a [SOURCE](/grammar/edge/source/) qualifies the act of citation (retrieval date, position within the source, and so on). The meaning of a SOURCE is also everything gathered from the QUALIFIERs that point to it.
- **A QUALIFIER is part of the proposition.** It is not a separate claim about the proposition; it qualifies the conditions under which the proposition is true. The meaning of the target TRIPLE is everything gathered from the QUALIFIERs that point to it.
  - The source of a proposition is written with [SOURCE](/grammar/edge/source/). The properties of a source node (title, author, and so on) are written as a TRIPLE with the source as Subject.
- There can be several QUALIFIERs of the same Property on the same Target. The order of QUALIFIERs with the same Target is the order in the document (an exception where Edge order carries meaning).

## Unknown and None

If the Value of a QUALIFIER is a slot marker, the meaning of that qualification changes. Take the end time (P582) as an example.

| Attached to the target TRIPLE | Meaning | Is the proposition still valid? |
|---|---|---|
| `QUALIFIER P582 #n EDTF("1974")` | It ended in 1974 | No |
| `QUALIFIER P582 #n UNKNOWN` | It ended. When is unknown (Wikidata `somevalue`) | No |
| `QUALIFIER P582 #n NONE` | Asserts that it has not ended (Wikidata `novalue`) | Yes |
| No P582 QUALIFIER | Unknown whether it ended (open world) | Unknown |

- Dropping the `somevalue` or `novalue` of a Wikidata qualifier widens the proposition. A border TRIPLE whose end-time somevalue was dropped would be read as "a border that is still valid". So they are carried over as markers.
- Two UNKNOWN-VALUEs are not treated as the same value. The comparison result is undetermined.

## Examples (non-normative)

Q42 P69 (educated at) Q691283 (St John's College), 1971 to 1974.

```
TRIPLE     #9   P69   Q42  Q691283  rank 0
QUALIFIER  #10  P580  #9   EDTF "1971"
QUALIFIER  #11  P582  #9   EDTF "1974"
```

- `#10`: TAG 1 + Edge Id 2 + Property 2 + Target 2 + Value 3 = 10 WORDs. Value is [EDTF](/grammar/value/time/edtf/) `"1971"`.

```
148B 0088 000A 00A8 0244 0088 0009 0924 3139 3731
```

The border (P47) between Q30 (United States) and Q34266 (Russian Empire), end time unknown. Edge Ids `2060` and `3160`.

```
148A 0088 080C 00A8 002F 00A0 001E 00A0 85DA 0000      #2060 TRIPLE P47 Q30 Q34266 normal
138B 0088 0C58 00A8 0246 0088 080C 0001                #3160 QUALIFIER P582 #2060 UNKNOWN
```

- `138B` = `000 10 0111 0001011`: Edge, 8 WORDs, Codec `0x0B`. TAG 1 + Edge Id 2 + Property P582 (`00A8 0246`) 2 + Target #2060 (`0088 080C`) 2 + marker 1.

Attach a period to the Q30 central bank (P1304) NO-VALUE TRIPLE `#3161`. There was none only in 1811 to 1816.

```
140A 0088 0C59 00A8 0518 00A0 001E 0002 0000           #3161 TRIPLE P1304 Q30 NONE normal
148B 0088 0C5A 00A8 0244 0088 0C59 0924 3138 3131      #3162 QUALIFIER P580 #3161 EDTF("1811")
148B 0088 0C5B 00A8 0246 0088 0C59 0924 3138 3136      #3163 QUALIFIER P582 #3161 EDTF("1816")
```

## Related Pages

- [Edge](/grammar/edge/), [TRIPLE](/grammar/edge/triple/), [SOURCE](/grammar/edge/source/), [WIKIDATA-PID](/grammar/reference/wikidata-pid/), [EDTF](/grammar/value/time/edtf/), [Slot marker](/grammar/reference/slot-marker/)
