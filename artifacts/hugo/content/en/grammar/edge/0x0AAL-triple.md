---
title: "TRIPLE (0x0AAL)"
weight: 170
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "TRIPLE is a statement Edge that holds one proposition (Predicate, Subject, Object) and its rank."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `TRIPLE` (specification document BIND `TRIPLE`) |
| TAG ID | `0x0AAL` |
| Codec ID | `0x00000AA0` |
| Specification document | `0x00000000/codecs/0x00000AA0/` (DECLARE target `0AA0`) |
| Section | 5 `0101` (Edge statement), offset within section C = 10 |
| Kind | Edge · family: statement, group: proposition |
| TAG WORD | `0000 1010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | A proposition in the order Predicate, Subject, Object, with a rank. Object is a value or an UNKNOWN-VALUE / NO-VALUE marker. Its meaning is the collection of all QUALIFIERs that point to its Edge Id |
| Hugo side | `edge/triple.md` |

## Fields (specification document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec specification document](../codec-spec.md)). The Edge Id of an Edge is not declared as a FIELD.

| Order | Field (BIND) | FIELD | Width | Accepted form (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `predicate` | #2 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference) |  |
| 2 | `subject` | #3 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference) |  |
| 3 | `object` | #4 | record | `000F` all of section 0 (wildcard, Reference), `020F` all of section 1 (wildcard, Reference), `040F` all of section 2 (wildcard, Reference), `060F` all of section 3 (wildcard, Value), `080F` all of section 4 (wildcard, Value), `0010` UNKNOWN-VALUE, `0020` NO-VALUE |  |
| 4 | `rank` | #5 | raw value, 1 WORD | `0620` UNSIGNED-INTEGER | `0x0000` normal, `0x0001` preferred, `0x0002` deprecated |

TRIPLE is a statement Edge that holds one proposition (Predicate, Subject, Object) and its rank. Codec `0x0AAL`.

A condition qualifying the proposition (start and end time, scope of application, etc.) is attached with a [QUALIFIER](0x0ABL-qualifier.md) pointing to the TRIPLE's Edge Id. Provenance (Wikidata references) is attached with the evidence Edge [SOURCE](0x0C0L-source.md) pointing to the TRIPLE's Edge Id.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 1010 LLLL
[Length extension TAG]
Edge Id           LOCAL Reference record
Predicate         Reference record (WIKIDATA-PID, etc.)
Subject           Reference record
Object            Reference or Value record, or slot marker 0x0010 UNKNOWN-VALUE / 0x0020 NO-VALUE
Rank              1 WORD (ENUM)
```

## Rank {#rank}

| Code | Name | Meaning |
|---|---|---|
| `0` | normal | Default |
| `1` | preferred | Current value, the most authoritative value |
| `2` | deprecated | A value judged wrong or outdated but kept as a record |

- Same as the Wikidata statement rank. The representative value (Wikidata truthy) among the same Subject and Predicate is preferred if any exists, otherwise normal.
- A source that assigns no rank uses `0` (normal).
- Any other code is invalid.

## Interpretation and validity {#해석과-유효성}

- Predicate and Subject are each exactly one complete Reference record.
- Object is exactly one complete Reference or Value record, or one WORD of [slot marker](../slot-marker.md) `0x0010` (UNKNOWN-VALUE) or `0x0020` (NO-VALUE). ABSENT (`0x0000`) is not accepted. Object is not an optional field.
- After Object is read, exactly 1 WORD (Rank) must remain.
- The geul.org specification document places [CODEC](0x0BEL-codec.md) UNSIGNED-INTEGER (`0620`) and [ENUM](0x0BDL-enum.md) 0, 1, 2 on the Rank raw-value field. On the Object field it places CODEC `000F`, `020F`, `040F` (any Reference), `060F`, `080F` (any Value), `0010` (UNKNOWN-VALUE), and `0020` (NO-VALUE). On the Predicate and Subject fields it places CODEC `000F`, `020F`, `040F` (any Reference). Being wildcards, they do not accept slot markers.
- **The meaning of a TRIPLE is the collection of all QUALIFIERs in the same document that point to its Edge Id.** The reader collects the QUALIFIERs before interpreting the TRIPLE. A TRIPLE read without its QUALIFIERs may be a proposition missing its qualification (e.g. "head of government" with the time qualification missing).

## Unknown and none {#알-수-없음과-없음}

A slot marker in the Object slot is not a value but an assertion about the proposition.

| Object | Meaning | Logic |
|---|---|---|
| value v | One of the Predicate values of Subject is v | `P(s, v)` |
| UNKNOWN-VALUE (`0x0010`) | A value exists. It is not known what it is (Wikidata `somevalue`) | `∃x. P(s, x)` |
| NO-VALUE (`0x0020`) | There is no value (Wikidata `novalue`) | `¬∃x. P(s, x)` |
| no TRIPLE | Nothing is asserted (open world) | |

- **Read within the qualifying conditions.** The scope of `∃` and `¬∃` is set by the QUALIFIERs that point to that TRIPLE. When a QUALIFIER is attached, it is closed only within that scope. "There was no central bank in 1811-1816" is written by attaching P580 and P582 QUALIFIERs to a NO-VALUE TRIPLE. It does not contradict value TRIPLEs of the same Predicate for other periods.
- **Rank applies equally.** When choosing the representative value (truthy), UNKNOWN-VALUE and NO-VALUE TRIPLEs are also candidates. If a preferred one exists, only preferred ones remain.
- **UNKNOWN-VALUEs are not equal to each other.** An UNKNOWN-VALUE is neither equal to nor different from any value (the comparison result is undetermined), and two UNKNOWN-VALUEs are also not regarded as the same value. Each occurrence is an independent existential quantification. So two byte-identical UNKNOWN-VALUE TRIPLEs are not duplicates and are not merged (there may be two children or one).
- If a NO-VALUE TRIPLE and a value (or UNKNOWN-VALUE) TRIPLE coexist for the same Subject, Predicate, and rank without distinguishable qualifying conditions, it is a contradiction. A validator warns. It does not reject (this state also exists in Wikidata).
- A value that could not be carried over (the source has a value) is not written as UNKNOWN-VALUE.

## Examples (non-normative) {#예시-비규범}

Q42 (Douglas Adams) P31 (instance of) Q5 (human), normal. Edge Id `0005`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 2 + Rank 1 = 10 WORDs, `LLLL=1001`. The TAG is `0000 1010 1010 1001` = `0AA9`.

```
0AA9 0051 0005 0191 001F 0141 002A 0141 0005 0000
```

Q30 (United States) P1304 (central bank) NO-VALUE, normal. There was no central bank in 1811-1816 (the P580 and P582 QUALIFIERs are in the [QUALIFIER](0x0ABL-qualifier.md) example). Edge Id `3161`.

- TAG 1 + Edge Id 2 + Predicate 2 + Subject 2 + Object 1 + Rank 1 = 9 WORDs, `LLLL=1000`. The TAG is `0000 1010 1010 1000` = `0AA8`.

```
0AA8 0051 0C59 0191 0518 0141 001E 0020 0000      #3161 TRIPLE P1304 Q30 NONE normal
```

- "No children (P40)" is `0AA8 0051 <Edge Id> 0191 0028 <Subject> 0020 0000`.

## Open problems {#열린-문제}

- scope (the context of a claim: world, viewpoint): to be decided when a use arises.
- An abbreviated form folding TRIPLE and QUALIFIER into one record: after repeated-field declaration exists (an open problem of [DECLARE](0x0BBL-declare.md)).

## Related pages {#관련-페이지}

- [Edge](_index.md), [QUALIFIER](0x0ABL-qualifier.md), [SOURCE](0x0C0L-source.md), [LABEL](0x0A4L-label.md), [ALIAS](0x0A5L-alias.md), [slot marker](../slot-marker.md)
- [WIKIDATA-PID](../reference/0x019L-wikidata-pid.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md)

## Specification document source {#규격-문서-원문}

This is the specification document `0x00000000/codecs/0x00000AA0/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000AA000000000
BODY
#1 DECLARE 0x0AA0
#2 FIELD #1 record
#3 FIELD #1 record
#4 FIELD #1 record
#5 FIELD #1 0x0001
#6 ENUM #5 0x0000
#7 ENUM #5 0x0001
#8 ENUM #5 0x0002
#9 BIND #1 "TRIPLE"
#10 BIND #2 "predicate"
#11 BIND #3 "subject"
#12 BIND #4 "object"
#13 BIND #5 "rank"
#14 BIND #6 "normal"
#15 BIND #7 "preferred"
#16 BIND #8 "deprecated"
#17 CODEC #5 0x0620
#18 CODEC #4 0x000F
#22 CODEC #4 0x020F
#23 CODEC #4 0x040F
#19 CODEC #4 0x060F
#24 CODEC #4 0x080F
#20 CODEC #4 0x0010
#21 CODEC #4 0x0020
#25 CODEC #2 0x000F
#26 CODEC #2 0x020F
#27 CODEC #2 0x040F
#28 CODEC #3 0x000F
#29 CODEC #3 0x020F
#30 CODEC #3 0x040F
```
