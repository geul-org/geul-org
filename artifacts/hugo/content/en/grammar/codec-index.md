---
title: "Codec Index"
weight: 60
date: 2026-11-05T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar"]
summary: "This page is an index of all Codecs."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

This page is an index of all Codecs. Click a name to go to the detailed document for that Codec. Direct codes not in the tables are Reserved.

## Kind {#kind}

A TAG WORD is `000K KKKC CCCC LLLL`. The upper 4 bits `KKKK` are the section, `C` is the 5-bit offset within the section, and `LLLL` is the Length. The 9 bits of section and `C` together form the Codec slot. A TAG ID is written `0x000L`. The first three digits are these 9 bits (`w >> 4`) and `L` is the Length digit ([Records and the TAG WORD](record.md)).

| Section | TAG ID | Category | Description |
|---|---|---|---|
| 0-2 | `0x000L~0x05FL` | [Reference](reference/_index.md) | Records that point to a target |
| 3, 4 | `0x060L~0x09FL` | [Value](value/_index.md) | Value records |
| 5-13 | `0x0A0L~0x1BFL` | [Edge](edge/_index.md) | Composition records |
| 14, 15 | `0x1C0L~0x1FFL` | [Meta](meta/_index.md) | Records about documents and records |

- The section is `S = w >> 9` (4 bits), and one section has 32 slots.
- Kind is decided by a single section range: `w < 0x0600` Reference, `w < 0x0A00` Value, `w < 0x1C00` Edge, the rest Meta. There are no exceptions.
- The last three slots of the Reference, Value, and Edge zones are ISSUER (`..DL` 2 WORDs, `..EL` 4 WORDs, `..FL` 16 WORDs). Meta has no ISSUER.

## Reference {#reference}

`0x000L~0x05FL` — [Reference](reference/_index.md)

### Codec {#codec}

| TAG ID | Name | Category | Target ID |
|---|---|---|---|
| `0x000L~0x002L` | [Slot Markers](slot-marker.md) | Slot marker | A group of 1-WORD markers that point to no target (table below) |
| `0x005L~0x009L` | [LOCAL](reference/0x005L-local.md) | Declaration | An ID issued by this document |
| `0x00AL~0x00EL` | [GEUL](reference/0x00AL-geul.md) | Declaration | Entities issued by geul.org under CC0. Small numbers are assigned to high-frequency entities |
| `0x00FL~0x013L` | [GEUL-SIDX](reference/0x00FL-geul-sidx.md) | Declaration | GEUL SIDX (Semantic-aligned Index). An identifier that carries meaning in its bits |
| `0x014L~0x018L` | [WIKIDATA-QID](reference/0x014L-wikidata-qid.md) | Declaration | A Wikidata item. The integer after `Q` |
| `0x019L~0x01DL` | [WIKIDATA-PID](reference/0x019L-wikidata-pid.md) | Declaration | A Wikidata property. The integer after `P` |
| `0x020L~0x024L` | [EXTERNAL-POINTER-1WORD](reference/0x020L-external-pointer-1word.md) | Pointer | A LOCAL ID of a document brought in by `IMPORT-DOC`. IMPORT ID of 1 WORD |
| `0x025L~0x029L` | [EXTERNAL-POINTER-2WORD](reference/0x025L-external-pointer-2word.md) | Pointer | Same as above. IMPORT ID of 2 WORDs |
| `0x02AL~0x02EL` | [EXTERNAL-POINTER-4WORD](reference/0x02AL-external-pointer-4word.md) | Pointer | Same as above. IMPORT ID of 4 WORDs |
| `0x02FL~0x033L` | [EXTERNAL-ISSUER-2WORD](reference/0x02FL-external-issuer-2word.md) | Pointer-declaration | A LOCAL ID of a 2-WORD Issuer document |
| `0x034L~0x038L` | [EXTERNAL-ISSUER-4WORD](reference/0x034L-external-issuer-4word.md) | Pointer-declaration | A LOCAL ID of a 4-WORD Issuer document |
| `0x039L~0x03DL` | [EXTERNAL-ISSUER-16WORD](reference/0x039L-external-issuer-16word.md) | Pointer-declaration | A LOCAL ID of a 16-WORD Issuer document |
| `0x040L` | [ISSUER-POINTER](reference/0x040L-issuer-pointer.md) | Pointer-declaration | The Issuer itself. The Payload is only the Issuer (2/4/16 WORDs) and there is no target ID |
| `0x041L` | [DOC-POINTER](reference/0x041L-doc-pointer.md) | Pointer-declaration | One version of an Issuer document. Issuer + 4-WORD document ID + 2-WORD version ID, no target ID |
| `0x042L` | [CODEC-POINTER](reference/0x042L-codec-pointer.md) | Pointer-declaration | One version of an Issuer codec. Issuer + 2-WORD codec ID + 2-WORD version ID, no target ID |
| `0x05DL` | [REFERENCE-ISSUER-2WORD](reference/0x05DL-reference-issuer-2word.md) | Issuer format | 2-WORD Issuer and 2-WORD codec number. The category and target are decided by the Issuer document |
| `0x05EL` | [REFERENCE-ISSUER-4WORD](reference/0x05EL-reference-issuer-4word.md) | Issuer format | 4-WORD Issuer and 2-WORD codec number. Same as above |
| `0x05FL` | [REFERENCE-ISSUER-16WORD](reference/0x05FL-reference-issuer-16word.md) | Issuer format | 16-WORD Issuer and 2-WORD codec number. Same as above |

- Reference has three sections. Section 0 is entities `0x000L~0x01FL` (slot markers, the 5Q scheme), section 1 is EXTERNAL `0x020L~0x03FL`, and section 2 is the rest `0x040L~0x05FL` (pointers, REFERENCE-ISSUER). Reserved are `0x003L~0x004L`, `0x01EL~0x01FL`, `0x03EL~0x03FL`, and `0x043L~0x05CL`.
- A group of 5 slots (from LOCAL to EXTERNAL-ISSUER-16WORD) has one slot each in the Quantifier order below. Example: WIKIDATA-QID Identified `0x014L`, Generic `0x015L`.

### Slot Markers (`0x000L~0x002L`) {#자리-표지-0x000l0x002l}

`0x0000`, `0x0010`, `0x0020` — [Slot Markers](slot-marker.md). They appear in a slot only when the field's CODEC list names that WORD exactly.

| WORD | Name | Meaning | Wikidata |
|---|---|---|---|
| `0x0000` | [ABSENT](reference/0x000L-absent.md) | Not stated. An optional field was omitted. Nothing is asserted about the world | no snak |
| `0x0010` | [UNKNOWN-VALUE](reference/0x001L-unknown-value.md) | Unknown. A value exists but it is not known what it is | `somevalue` |
| `0x0020` | [NO-VALUE](reference/0x002L-no-value.md) | None. There is no value | `novalue` |

### Quantifier {#quantifier}

| `C % 5` | Name | Meaning | Example |
|---|---|---|---|
| `0` | Identified | An identified entity | Elon Musk, South Korea |
| `1` | Generic | A general or definitional statement about a whole kind. Exceptions are allowed. | Soldiers obey orders |
| `2` | Free-choice | Any target that satisfies a condition | Any soldier |
| `3` | Universal | Every target within a given range | All soldiers |
| `4` | Variable | A discourse variable | that person, this woman |

- Quantification is read from the offset `C` within the section. In section 0, if `5 <= C < 30`, the quantifier is `C % 5` and the scheme is `C / 5` (1-5). In section 1, if `C < 30`, the quantifier is `C % 5` and the scheme is `6 + C / 5` (6-11). It is not used for markers (section 0, `C < 3`) or section 2 (pointers, REFERENCE-ISSUER).
- ISSUER-POINTER, DOC-POINTER, and CODEC-POINTER are single slots with no quantifier. The quantifier of REFERENCE-ISSUER is decided by the Codec document the Issuer published.

## Issuer {#issuer}

An Issuer is the party that defines documents and formats — [Issuer and Publication](issuer.md)

| Place | Meaning |
|---|---|
| Reference, Value, and Edge ISSUER codes (last three slots of each zone) | Formats defined by that Issuer |
| Meta `DOC-ID` | The Issuer that issued this document |
| Meta `IMPORT-DOC` | The Issuer that issued the imported document |
| Reference `EXTERNAL-ISSUER-*`, `DOC-POINTER`, `CODEC-POINTER` | The Issuer that issued the pointed-to document or codec (2/4/16 WORDs) |
| Reference `ISSUER-POINTER` | The pointed-to Issuer itself (2/4/16 WORDs) |

| Issuer width | Issuance |
|---|---|
| 2 WORD | Registered with geul.org. An Issuer that has passed domain ownership proof (for example company.com). Numbers geul.org assigns to standards bodies and major institutions are also this width ([2-WORD assignment table](issuer.md#2-word-배정표)). |
| 4 WORD | Registered with geul.org. An Issuer registered without ownership proof |
| 16 WORD | Self-issued. Computed from a public key without registration. Follows the generation rule below. |

### 16-WORD Issuer Signature Algorithm {#16-word-issuer-서명-알고리즘}

| Signature algorithm ID | Algorithm |
|---|---|
| `0x0001` | Ed25519 |
| Others | Reserved |

## Edge {#edge}

`0x0A0L~0x1BFL` — [Edge](edge/_index.md)

The family of a direct code is `(code − 0xA0) >> 5` (the code is the first three digits of the TAG ID). A family is 32 slots and equals the section `w >> 9` minus 5. The assigned direct codes are the five families below. `0x135L~0x1BCL` is Reserved (sections 10-12 are Reserved in their entirety). The Issuer format has no family rule.

| Section | Family | Direct codes |
|---|---|---|
| 5 | Statement | `0x0A0L~0x0BFL` |
| 6 | Evidence | `0x0C0L~0x0DFL` |
| 7 | Execution | `0x0E0L~0x0FFL` |
| 8 | [TOULMIN](toulmin/_index.md) | `0x100L~0x11BL` |
| 9 | [TOULMIN](toulmin/_index.md) format | `0x120L~0x134L` |

- `0x11CL~0x11FL` is Reserved.
- `0x1BDL~0x1BFL` (the last three slots of section 13) are EDGE-ISSUER (see Edge ISSUER format below).

### Statement (`0x0A0L~0x0BFL`) {#서술-0x0a0l0x0bfl}

| Codec | Name | Subformat | Description |
|---|---|---|---|
| `0x0A0L` | [REFERENCE-NODE](edge/0x0A0L-reference-node.md) |  | A directed binding in which a Reference Subject points to an Object |
| `0x0A1L` | [SAME-NODE](edge/0x0A1L-same-node.md) |  | Identity: two References point to the same target |
| `0x0A2L` | [DIFFERENT-NODE](edge/0x0A2L-different-node.md) |  | Non-identity: two References point to different targets |
| `0x0A3L` | [BIND](edge/0x0A3L-bind.md) |  | Binds to the Subject a name that machines match (`UTF8-TEXT-*`). It must be unique within its scope and match exactly, and has no language |
| `0x0A4L` | [LABEL](edge/0x0A4L-label.md) |  | Attaches a language label to the Subject. The Object is UTF8-LANGUAGE-TEXT |
| `0x0A5L` | [ALIAS](edge/0x0A5L-alias.md) |  | Attaches another name (alias) to the Subject. The layout is the same as LABEL |
| `0x0A6L` | [DESCRIPTION](edge/0x0A6L-description.md) |  | Attaches a language description to the Subject. The layout is the same as LABEL |
| `0x0A7L` | Reserved |  |  |
| `0x0A8L` | [VERB-SHORT](edge/0x0A8L-verb-short.md) |  | Abbreviated verb statement |
| `0x0A9L` | [VERB](edge/0x0A9L-verb.md) |  | Verb statement |
| `0x0AAL` | [TRIPLE](edge/0x0AAL-triple.md) |  | A proposition in the order Predicate, Subject, Object, with a rank. The Object is a value or an UNKNOWN-VALUE or NO-VALUE marker. Its meaning is the sum of all QUALIFIERs that point to its Edge Id |
| `0x0ABL` | [QUALIFIER](edge/0x0ABL-qualifier.md) |  | One condition that qualifies the proposition of another Edge. Property, Target (Edge Id), Value (a value or an UNKNOWN-VALUE or NO-VALUE marker). It is part of the proposition |
| `0x0ACL~0x0AFL` | Reserved |  |  |
| `0x0B0L` | [WORLD](edge/0x0B0L-world.md) | Yes | A structure for expressing worldviews |
| `0x0B1L` | [TIMELINE](edge/0x0B1L-timeline.md) | Yes | A structure for expressing the order of worlds and events |
| `0x0B2L` | [SCENE](edge/0x0B2L-scene.md) | Yes | A scene structure for describing scenario characteristics |
| `0x0B3L~0x0B7L` | Reserved |  |  |
| `0x0B8L` | [PUBLICATION](edge/0x0B8L-publication.md) |  | Document publication. DOC-POINTER, content hash |
| `0x0B9L` | [DEPRECATION](edge/0x0B9L-deprecation.md) |  | Deprecation of a published version. DOC-POINTER |
| `0x0BAL` | [TOMBSTONE](edge/0x0BAL-tombstone.md) |  | Deletion (tombstone) of a published version. DOC-POINTER, reason category |
| `0x0BBL` | [DECLARE](edge/0x0BBL-declare.md) |  | Declares the Payload composition of one Codec. Target Kind and Codec |
| `0x0BCL` | [FIELD](edge/0x0BCL-field.md) |  | One Payload field. The DECLARE it belongs to; width: a record (the TAG's Length) or n raw WORDs |
| `0x0BDL` | [ENUM](edge/0x0BDL-enum.md) |  | One code value of a raw-value field. Field, code value |
| `0x0BEL` | [CODEC](edge/0x0BEL-codec.md) |  | One Kind and Codec that a field accepts. Field, target WORD (`000K KKKC CCCC LLLL`; LLLL 0000 exact, 1111 wildcard (all 32 slots of that section); slot markers only as the exact targets `0000`, `0010`, `0020`). A record field has several (a closed list); a raw-value field has one (that Value without a TAG) |
| `0x0BFL` | Reserved |  |  |

| TAG ID | Group |
|---|---|
| `0x0A0L~0x0A7L` | Pointers and names |
| `0x0A8L~0x0AFL` | Propositions |
| `0x0B0L~0x0B7L` | Structure |
| `0x0B8L~0x0BFL` | Other |

### Evidence (`0x0C0L~0x0DFL`) {#근거-0x0c0l0x0dfl}

| Codec | Name | Subformat | Description |
|---|---|---|---|
| `0x0C0L` | [SOURCE](edge/0x0C0L-source.md) |  | Connects one record, or the whole document, to its source. Target (BODY Edge Id; in HEAD, `0` = the whole document), Origin (Reference, ABSENT or UNKNOWN-VALUE). The nature of the source is a TRIPLE with the source as Subject; the nature of the citation (retrieval date, location, source-text hash) is a QUALIFIER attached to the SOURCE. The SOURCE for the whole document and its QUALIFIER go in the HEAD |
| `0x0C1L~0x0DFL` | Reserved |  |  |

- The source-text range, the producing party, confidence, per-article effective periods, and old records are written as QUALIFIERs, and the version in which something first entered is computed from the version history ([SOURCE](edge/0x0C0L-source.md#다른-근거의-표현)).

### Execution (`0x0E0L~0x0FFL`) {#실행-0x0e0l0x0ffl}

| Codec | Name | Description |
|---|---|---|
| `0x0E0L` | Reserved |  |
| `0x0E1L` | [FUNCTION-DECLARE](edge/0x0E1L-function-declare.md) | Function declaration. Symbol, parameter symbol list, return type, body (BLOCK) |
| `0x0E2L` | [TYPE-DECLARE](edge/0x0E2L-type-declare.md) | Type declaration. Symbol and composition (field symbol list, enumeration values, alias target) |
| `0x0E3L~0x0E7L` | Reserved |  |
| `0x0E8L` | [CONST](edge/0x0E8L-const.md) | Constant expression. One built-in Value |
| `0x0E9L` | [UNARY](edge/0x0E9L-unary.md) | Unary expression. 1-WORD operator, operand |
| `0x0EAL` | [BINARY](edge/0x0EAL-binary.md) | Binary expression. 1-WORD operator, left, right |
| `0x0EBL` | [CALL](edge/0x0EBL-call.md) | Call. Target function, argument count, argument × argument count |
| `0x0ECL` | [MEMBER](edge/0x0ECL-member.md) | Member access. Target, field symbol |
| `0x0EDL` | [INDEX](edge/0x0EDL-index.md) | Index access. Target, index |
| `0x0EEL` | [CONSTRUCT](edge/0x0EEL-construct.md) | Compound value construction (list, record). Type, element count, element × element count |
| `0x0EFL` | [CONDITIONAL](edge/0x0EFL-conditional.md) | Conditional expression. Condition, value if true, value if false |
| `0x0F0L` | [BLOCK](edge/0x0F0L-block.md) | Ordered group of statements. Statement count, statement × statement count |
| `0x0F1L` | [ASSIGN](edge/0x0F1L-assign.md) | Assignment. Target (symbol, MEMBER, INDEX), value |
| `0x0F2L` | [IF](edge/0x0F2L-if.md) | Conditional branch. Condition, true BLOCK, false (BLOCK or IF; 0 if none) |
| `0x0F3L` | [SWITCH](edge/0x0F3L-switch.md) | Multi-way branch. Target, case count, (value, BLOCK) × case count, default BLOCK (0 if none) |
| `0x0F4L` | [WHILE](edge/0x0F4L-while.md) | Conditional loop. Condition, body BLOCK |
| `0x0F5L` | [FOREACH](edge/0x0F5L-foreach.md) | Iteration loop. Element symbol, target, body BLOCK |
| `0x0F6L` | [JUMP](edge/0x0F6L-jump.md) | Loop control. 1-WORD kind (break, continue), target loop |
| `0x0F7L` | [RETURN](edge/0x0F7L-return.md) | Return. Value (0 if none) |
| `0x0F8L` | [RAISE](edge/0x0F8L-raise.md) | Raise an error. Error value |
| `0x0F9L` | [TRY](edge/0x0F9L-try.md) | Error handling. Body BLOCK, error symbol, handler BLOCK, finally BLOCK (0 if none) |
| `0x0FAL~0x0FFL` | Reserved |  |

| TAG ID | Group |
|---|---|
| `0x0E0L~0x0E7L` | Declarations |
| `0x0E8L~0x0EFL` | Expressions |
| `0x0F0L~0x0F7L` | Statements |
| `0x0F8L~0x0FFL` | Errors |

### TOULMIN (`0x100L~0x11BL`) {#toulmin-0x100l0x11bl}

Details: [TOULMIN](toulmin/_index.md)

| Codec | Name | Description |
|---|---|---|
| `0x100L` | [CASE-DECLARE](toulmin/0x100L-case-declare.md) | Case declaration. A judgment graph holding nodes and relations |
| `0x101L` | [PREDICATE-DECLARE](toulmin/0x101L-predicate-declare.md) | Predicate declaration. Judgment function or expression, criteria (Spec), fact contract (Ground) |
| `0x102L` | [SPEC-DECLARE](toulmin/0x102L-spec-declare.md) | Criteria declaration. Constants and lists (Backing) |
| `0x103L` | [RULE-DECLARE](toulmin/0x103L-rule-declare.md) | Claim declaration. Places a predicate in a case as a general rule (Warrant). It can be attacked. |
| `0x104L` | [COUNTER-DECLARE](toulmin/0x104L-counter-declare.md) | Rebuttal declaration. Attacks with a conclusion of its own. The default Level is Fail |
| `0x105L` | [EXCEPT-DECLARE](toulmin/0x105L-except-declare.md) | Exception declaration. Attacks without a conclusion of its own. The default Level is Review |
| `0x106L~0x107L` | Reserved |  |
| `0x108L` | [ATTACKS](toulmin/0x108L-attacks.md) | Attack relation. The attacker's judgment gradually reduces the target's judgment. |
| `0x109L` | [SUPERSEDES](toulmin/0x109L-supersedes.md) | Supersede relation. When the attacker is Active, the target is decisively removed from the aggregate. |
| `0x10AL` | [SUPERSEDE-CHAIN](toulmin/0x10AL-supersede-chain.md) | Priority chain `A > B > C`. An abbreviation of pairwise SUPERSEDES. Layout undecided |
| `0x10BL~0x10FL` | Reserved |  |
| `0x110L` | [RUN](toulmin/0x110L-run.md) | Execution composition. When the node is Active, it runs a sub-case (DAG). |
| `0x111L` | [DO](toulmin/0x111L-do.md) | An action performed when the node is Active |
| `0x112L` | [DO-ONCE](toulmin/0x112L-do-once.md) | An action performed only once even on retry |
| `0x113L` | [UNDO](toulmin/0x113L-undo.md) | Compensating action for DO (saga). Performed in reverse order if a later step fails. |
| `0x114L` | [CHECKING](toulmin/0x114L-checking.md) | A link that only judges, with no side effects |
| `0x115L` | [ENTRY](toulmin/0x115L-entry.md) | External entry point. Runs or judges a case |
| `0x116L` | [TRIGGER](toulmin/0x116L-trigger.md) | Event or periodic entry point with no external call |
| `0x117L` | Reserved |  |
| `0x118L` | [VERDICT](toulmin/0x118L-verdict.md) | The judgment result of a node or record. Result (Pass, Review, Fail), judgment value, Activated, Excluded, Level. Layout undecided. The judgment of a whole document is Meta [VERDICT](meta/0x1E9L-verdict.md) (`0x1E9L`) |
| `0x119L` | [EVIDENCE](toulmin/0x119L-evidence.md) | Evidence for a judgment. Location, expected value, actual value (Fact). Layout undecided |
| `0x11AL~0x11BL` | Reserved |  |
| `0x11CL~0x11FL` | Reserved |  |

| TAG ID | Group |
|---|---|
| `0x100L~0x107L` | Declarations |
| `0x108L~0x10FL` | Relations |
| `0x110L~0x117L` | Execution |
| `0x118L~0x11FL` | Results (`0x11CL~0x11FL` is Reserved) |

### TOULMIN Format (`0x120L~0x134L`) {#toulmin-형식-0x120l0x134l}

The source text, divisions, and auxiliary nodes and relations of a [TOULMIN](toulmin/_index.md) document.

| Codec | Name | Description |
|---|---|---|
| `0x120L` | [SOURCE](toulmin/0x120L-source.md) | Authored source text. SPAN width and UTF8 Value |
| `0x121L` | [TEXT](toulmin/0x121L-text.md) | Name or string |
| `0x122L` | [SECTION](toulmin/0x122L-section.md) | Section start. Section code |
| `0x123L` | [CASE-BEGIN](toulmin/0x123L-case-begin.md) | Start of a case range |
| `0x124L` | [CASE-END](toulmin/0x124L-case-end.md) | End of a case range |
| `0x125L` | [PROSE](toulmin/0x125L-prose.md) | Descriptive paragraph (SPAN) |
| `0x126L` | [NAMESPACE](toulmin/0x126L-namespace.md) | NODE. `this document is` |
| `0x127L` | [FUNC](toulmin/0x127L-func.md) | NODE. Function reference |
| `0x128L` | [FIELD](toulmin/0x128L-field.md) | NODE. `is required` |
| `0x129L` | [ALIAS](toulmin/0x129L-alias.md) | NODE. `see … from` |
| `0x12AL` | [GROUP](toulmin/0x12AL-group.md) | NODE. Ordered execution group |
| `0x12BL` | [REQUIRES](toulmin/0x12BL-requires.md) | LINK. Case → field |
| `0x12CL` | [MEANS](toulmin/0x12CL-means.md) | LINK. Definition item → value or type |
| `0x12DL` | [HAS](toulmin/0x12DL-has.md) | LINK. Definition item → field |
| `0x12EL` | [RUNS](toulmin/0x12EL-runs.md) | LINK. Entry point → case, run |
| `0x12FL` | [EVALUATES](toulmin/0x12FL-evaluates.md) | LINK. Entry point → case, judge |
| `0x130L` | [TRIGGERS](toulmin/0x130L-triggers.md) | LINK. Trigger → case |
| `0x131L` | [UNTIL](toulmin/0x131L-until.md) | LINK. Trigger → case (`every … until`) |
| `0x132L` | [SAME-AS](toulmin/0x132L-same-as.md) | LINK. Node → global identifier |
| `0x133L` | [IMPORTED-FROM](toulmin/0x133L-imported-from.md) | LINK. Alias → path (TEXT) |
| `0x134L` | [LABEL](toulmin/0x134L-label.md) | LINK. Node → TEXT, name notation |

- `0x135L~0x1BCL` is Reserved.

### Edge ISSUER Format {#edge-issuer-형식}

After `0x1BDL`-`0x1BFL` ([EDGE-ISSUER-2WORD](edge/0x1BDL-edge-issuer-2word.md), [-4WORD](edge/0x1BEL-edge-issuer-4word.md), [-16WORD](edge/0x1BFL-edge-issuer-16word.md)), the Codec extended TAG holds the Issuer and a 2-WORD codec number. No Edge ISSUER format is listed at present.

## Value {#value}

`0x060L~0x09FL` — [Value](value/_index.md)

Value numbers do not denote a family. Direct codes are placed in `0x060L~0x081L` with no Reserved gaps. `0x082L~0x09CL` is Reserved, and `0x09DL~0x09FL` is VALUE-ISSUER. The family names (NUMERIC, DECIMAL, TIME, TEXT, BINARY) are topical groupings. Even-odd pairs start at an even code.

| Family | Direct codes |
|---|---|
| [NUMERIC](value/_index.md#numeric) | `0x060L~0x067L` |
| [DECIMAL](value/_index.md#decimal) | `0x068L~0x069L` |
| [TIME](value/_index.md#time) | `0x06AL~0x071L`, `0x081L` |
| [TEXT](value/_index.md#text) | `0x072L~0x07AL` |
| [BINARY](value/_index.md#binary) | `0x07BL~0x080L` |

### Direct Codes {#직접-코드}

| Codec | Name | Family | Description |
|---|---|---|---|
| `0x060L` | [BOOL](value/0x060L-bool.md) | NUMERIC | A fixed 1-WORD false or true |
| `0x061L` | [SIGNED-INTEGER](value/0x061L-signed-integer.md) | NUMERIC | Minimum-WORD two's-complement signed integer |
| `0x062L` | [UNSIGNED-INTEGER](value/0x062L-unsigned-integer.md) | NUMERIC | Minimum-WORD big-endian unsigned magnitude integer |
| `0x063L` | [BINARY-FLOAT](value/0x063L-binary-float.md) | NUMERIC | IEEE 754 binary16/32/64/128 scalar with a 1/2/4/8-WORD Payload |
| `0x064L` | [COORDINATE-EARTH](value/0x064L-coordinate-earth.md) | NUMERIC | Earth (WGS 84) latitude and longitude in binary64, uncertainty in binary32 and its unit Reference (ABSENT = unknown) |
| `0x065L` | [COORDINATE-GEO](value/0x065L-coordinate-geo.md) | NUMERIC | Celestial body Reference, latitude and longitude in binary64, uncertainty in binary32 and its unit Reference |
| `0x066L` | [QUANTITY](value/0x066L-quantity.md) | NUMERIC | Numeric Value amount (integer, BINARY-FLOAT, decimal, fraction), unit Reference, lower and upper bounds. Unit and bounds may be omitted (ABSENT `0x0000`) |
| `0x067L` | [FRACTION](value/0x067L-fraction.md) | NUMERIC | A fraction that preserves the original notation: integer or decimal numerator, unsigned integer or decimal denominator. Not reduced |
| `0x068L` | [SIGNED-DECIMAL](value/0x068L-signed-decimal.md) | DECIMAL | `C×10^E` from a signed exponent `E` and a minimum-WORD two's-complement coefficient `C` |
| `0x069L` | [UNSIGNED-DECIMAL](value/0x069L-unsigned-decimal.md) | DECIMAL | `C×10^E` from a signed exponent `E` and a minimum-WORD unsigned coefficient `C` |
| `0x06AL` | [GREGORIAN-DATE](value/0x06AL-gregorian-date.md) | TIME | Signed day count relative to proleptic Gregorian `1970-01-01` |
| `0x06BL` | [CIVIL-TIME-NANOSECONDS](value/0x06BL-civil-time-nanoseconds.md) | TIME | Unsigned nanosecond count after civil-day midnight |
| `0x06CL` | [POSIX-TIMESTAMP-SECONDS](value/0x06CL-posix-timestamp-seconds.md) | TIME | Signed second count from the Unix/POSIX epoch |
| `0x06DL` | [DURATION-SECONDS](value/0x06DL-duration-seconds.md) | TIME | Signed SI-second elapsed time with no epoch |
| `0x06EL`/`0x06FL` | [EDTF](value/0x06EL-edtf.md) | TIME | EDTF (ISO 8601-2) date string. Even and odd byte counts. A date that can be written as GREGORIAN-DATE is not written this way |
| `0x070L`/`0x071L` | [GEDCOM-DATE](value/0x070L-gedcom-date.md) | TIME | GEDCOM 7 date value string. Preserves the original notation of other calendars (Julian, etc.). Even and odd byte counts |
| `0x072L` | [UTF8-TEXT-EVEN](value/0x072L-utf8-text.md) | TEXT | A valid UTF-8 byte sequence that implies no normalization. Even byte count |
| `0x073L` | [UTF8-TEXT-ODD](value/0x072L-utf8-text.md) | TEXT | Same as above. Odd byte count |
| `0x074L` | [URI-EVEN](value/0x074L-uri.md) | TEXT | ASCII byte sequence of the RFC 3986 `URI` production. Even byte count |
| `0x075L` | [URI-ODD](value/0x074L-uri.md) | TEXT | Same as above. Odd byte count |
| `0x076L` | [LANGUAGE-BCP47-CODE-EVEN](value/0x076L-language-bcp47-code.md) | TEXT | ASCII byte sequence of a complete BCP 47 language tag in canonical casing. Even byte count |
| `0x077L` | [LANGUAGE-BCP47-CODE-ODD](value/0x076L-language-bcp47-code.md) | TEXT | Same as above. Odd byte count |
| `0x078L`/`0x079L` | [UTF8-LANGUAGE-TEXT](value/0x078L-utf8-language-text.md) | TEXT | Text with a language attached. A language Value record (LANGUAGE-SHORT-CODE or LANGUAGE-BCP47-CODE) and UTF-8 bytes. Even or odd by the text byte count |
| `0x07AL` | [LANGUAGE-SHORT-CODE](value/0x07AL-language-short-code.md) | TEXT | A BCP 47 tag written as a GEUL Language Registry number (1-WORD Payload) |
| `0x07BL` | [UUID](value/0x07BL-uuid.md) | BINARY | RFC 9562 UUID, 128 bits, fixed 8-WORD Payload |
| `0x07CL` | [SHA-256-DIGEST](value/0x07CL-sha-256-digest.md) | BINARY | SHA-256 result, fixed 16-WORD Payload |
| `0x07DL` | [SHA1-DIGEST](value/0x07DL-sha1-digest.md) | BINARY | SHA-1 result, fixed 10-WORD Payload. Only for identification purposes such as git object IDs |
| `0x07EL` | [OPAQUE-BYTES-EVEN](value/0x07EL-opaque-bytes.md) | BINARY | Byte sequence of unknown meaning or format. Even byte count |
| `0x07FL` | [OPAQUE-BYTES-ODD](value/0x07EL-opaque-bytes.md) | BINARY | Same as above. Odd byte count |
| `0x080L` | [BIT-VECTOR](value/0x080L-bit-vector.md) | BINARY | N bits stored MSB-first after a bit-count |
| `0x081L` | [DURATION-NANOSECONDS](value/0x081L-duration-nanoseconds.md) | TIME | Signed nanosecond elapsed time with no epoch |
| `0x09DL`~`0x09FL` | [VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md) |  | Formats defined by an Issuer. See Value ISSUER Format below |

### Value ISSUER Format {#value-issuer-형식}

After `0x09DL`-`0x09FL` ([VALUE-ISSUER-2WORD](value/0x09DL-value-issuer-2word.md), [-4WORD](value/0x09EL-value-issuer-4word.md), [-16WORD](value/0x09FL-value-issuer-16word.md)), the Codec extended TAG holds the Issuer and a 2-WORD codec number. The codec document is placed under that Issuer's `codecs/` by the record's codec number. Example: IETF CRC32C is at `0x00000007/codecs/0x0000C000/` ([Publication Addresses and Version List](publishing.md)).

| Issuer | Codec number | Name | Description |
|---|---|---|---|
| `0x00000002` ADHOC | `0x00000000` | BFLOAT16 | BF16 interchange bits, fixed 1-WORD Payload |
| `0x00000002` ADHOC | `0x00000500` | [DENSE-I16-VECTOR](value/adhoc.geul.org/dense-i16-vector.md) | Contiguous big-endian int16 vector |
| `0x00000002` ADHOC | `0x00000501` | [DENSE-U16-VECTOR](value/adhoc.geul.org/dense-u16-vector.md) | Contiguous big-endian uint16 vector |
| `0x00000002` ADHOC | `0x00000502` | [DENSE-I32-VECTOR](value/adhoc.geul.org/dense-i32-vector.md) | Contiguous big-endian int32 vector |
| `0x00000002` ADHOC | `0x00000503` | [DENSE-U32-VECTOR](value/adhoc.geul.org/dense-u32-vector.md) | Contiguous big-endian uint32 vector |
| `0x00000002` ADHOC | `0x00000504` | [DENSE-I64-VECTOR](value/adhoc.geul.org/dense-i64-vector.md) | Contiguous big-endian int64 vector |
| `0x00000002` ADHOC | `0x00000505` | [DENSE-U64-VECTOR](value/adhoc.geul.org/dense-u64-vector.md) | Contiguous big-endian uint64 vector |
| `0x00000002` ADHOC | `0x00000506` | [DENSE-BINARY16-VECTOR](value/adhoc.geul.org/dense-binary16-vector.md) | Contiguous IEEE 754 binary16 vector |
| `0x00000002` ADHOC | `0x00000507` | [DENSE-BFLOAT16-VECTOR](value/adhoc.geul.org/dense-bfloat16-vector.md) | Contiguous BF16 vector |
| `0x00000002` ADHOC | `0x00000508` | [DENSE-BINARY32-VECTOR](value/adhoc.geul.org/dense-binary32-vector.md) | Contiguous IEEE 754 binary32 vector |
| `0x00000002` ADHOC | `0x00000509` | [DENSE-BINARY64-VECTOR](value/adhoc.geul.org/dense-binary64-vector.md) | Contiguous IEEE 754 binary64 vector |
| `0x00000002` ADHOC | `0x0000050A` | [POINT2-BINARY64](value/adhoc.geul.org/point2-binary64.md) | IEEE binary64 2-dimensional vector in `(x,y)` order |
| `0x00000002` ADHOC | `0x0000050B` | [POINT3-BINARY64](value/adhoc.geul.org/point3-binary64.md) | IEEE binary64 3-dimensional vector in `(x,y,z)` order |
| `0x00000002` ADHOC | `0x0000050C` | [BBOX2-BINARY64](value/adhoc.geul.org/bbox2-binary64.md) | IEEE binary64 vector in `(minX,minY,maxX,maxY)` order |
| `0x00000002` ADHOC | `0x00000600` | [DESCRIBED-DENSE-TENSOR](value/adhoc.geul.org/described-dense-tensor.md) | element-format, rank, shape, and a C-contiguous dense payload |
| `0x00000002` ADHOC | `0x00000601` | [DESCRIBED-PACKED-TENSOR](value/adhoc.geul.org/described-packed-tensor.md) | packed-format, rank, shape, and a payload packed low-bit-first within each octet |
| `0x00000002` ADHOC | `0x00000700` | [COMPLEX64](value/adhoc.geul.org/complex64.md) | Two binary32 values in `(real, imag)` order |
| `0x00000002` ADHOC | `0x00000701` | [COMPLEX128](value/adhoc.geul.org/complex128.md) | Two binary64 values in `(real, imag)` order |
| `0x00000002` ADHOC | `0x00000702` | [RATIONAL-I64](value/adhoc.geul.org/rational-i64.md) | A normalized int64 numerator and a positive int64 denominator |
| `0x00000002` ADHOC | `0x00000703` | [CLOSED-INTERVAL-BINARY64](value/adhoc.geul.org/closed-interval-binary64.md) | A binary64 closed interval with `lower ≤ upper` |
| `0x00000002` ADHOC | `0x00000704` | [QUATERNION-BINARY32](value/adhoc.geul.org/quaternion-binary32.md) | Four binary32 values in `(x,y,z,w)` order |
| `0x00000002` ADHOC | `0x0000C000` | [BLAKE3-256-DIGEST](value/adhoc.geul.org/blake3-256-digest.md) | Default BLAKE3 result, fixed 16-WORD Payload |
| `0x00000007` IETF | `0x00008000` | [URI-RELATIVE-REF-EVEN](value/ietf.geul.org/uri-relative-ref.md) | ASCII byte sequence of RFC 3986 relative-ref. Even byte count |
| `0x00000007` IETF | `0x00008001` | [URI-RELATIVE-REF-ODD](value/ietf.geul.org/uri-relative-ref.md) | Same as above. Odd byte count |
| `0x00000007` IETF | `0x0000C000` | [CRC32C](value/ietf.geul.org/crc32c.md) | Castagnoli CRC-32C result, fixed 2-WORD Payload |
| `0x00000007` IETF | `0x0000C001` | [IPV4-ADDRESS](value/ietf.geul.org/ipv4-address.md) | IPv4 address, 32 bits, fixed 2-WORD Payload |
| `0x00000007` IETF | `0x0000C002` | [IPV6-ADDRESS](value/ietf.geul.org/ipv6-address.md) | IPv6 address, 128 bits, fixed 8-WORD Payload |
| `0x0000000D` IEEE | `0x00002000` | [IEEE-DECIMAL32-DPD](value/ieee.geul.org/ieee-decimal32-dpd.md) | IEEE 754 decimal32 DPD, fixed 2-WORD Payload |
| `0x0000000D` IEEE | `0x00002001` | [IEEE-DECIMAL64-DPD](value/ieee.geul.org/ieee-decimal64-dpd.md) | IEEE 754 decimal64 DPD, fixed 4-WORD Payload |
| `0x0000000D` IEEE | `0x00002002` | [IEEE-DECIMAL128-DPD](value/ieee.geul.org/ieee-decimal128-dpd.md) | IEEE 754 decimal128 DPD, fixed 8-WORD Payload |
| `0x0000000D` IEEE | `0x00002003` | [IEEE-DECIMAL32-BID](value/ieee.geul.org/ieee-decimal32-bid.md) | IEEE 754 decimal32 BID, fixed 2-WORD Payload |
| `0x0000000D` IEEE | `0x00002004` | [IEEE-DECIMAL64-BID](value/ieee.geul.org/ieee-decimal64-bid.md) | IEEE 754 decimal64 BID, fixed 4-WORD Payload |
| `0x0000000D` IEEE | `0x00002005` | [IEEE-DECIMAL128-BID](value/ieee.geul.org/ieee-decimal128-bid.md) | IEEE 754 decimal128 BID, fixed 8-WORD Payload |
| `0x0000000D` IEEE | `0x00004000` | [POSIX-TIMESTAMP-NANOSECONDS](value/ieee.geul.org/posix-timestamp-nanoseconds.md) | Signed nanosecond count from the Unix/POSIX epoch |
| `0x0000000D` IEEE | `0x0000C000` | [MAC-48-ADDRESS](value/ieee.geul.org/mac-48-address.md) | IEEE 802 MAC address, 48 bits, fixed 3-WORD Payload |
| `0x0000000E` KHRONOS | `0x00000000` | [RGBA8-UNORM](value/khronos.geul.org/rgba8-unorm.md) | Fixed 4×UNORM8 packed vector in R, G, B, A order |
| `0x0000000E` KHRONOS | `0x00000001` | [BGRA8-UNORM](value/khronos.geul.org/bgra8-unorm.md) | Fixed 4×UNORM8 packed vector in B, G, R, A order |
| `0x00000010` ONNX | `0x00000000` | FP8-E4M3FN | ONNX E4M3FN scalar in the upper octet of the Payload |
| `0x00000010` ONNX | `0x00000001` | FP8-E4M3FNUZ | ONNX E4M3FNUZ scalar in the upper octet of the Payload |
| `0x00000010` ONNX | `0x00000002` | FP8-E5M2 | ONNX E5M2 scalar in the upper octet of the Payload |
| `0x00000010` ONNX | `0x00000003` | FP8-E5M2FNUZ | ONNX E5M2FNUZ scalar in the upper octet of the Payload |
| `0x00000011` OCP | `0x00000000` | FP8-E8M0FNU | Unsigned exponent-only E8M0FNU scalar in the upper octet of the Payload |
| `0x00000011` OCP | `0x00000001` | FP4-E2M1FN | ONNX/DLPack E2M1FN scalar in the upper nibble of the Payload |
| `0x00000013` BIPM | `0x00004000` | [TAI-TIMESTAMP-SECONDS](value/bipm.geul.org/tai-timestamp-seconds.md) | Signed SI-second count from `1970-01-01T00:00:00 TAI` |
| `0x00000013` BIPM | `0x00004001` | [TAI-TIMESTAMP-NANOSECONDS](value/bipm.geul.org/tai-timestamp-nanoseconds.md) | Signed nanosecond count from the same TAI epoch |
| `0x00000015` NIST | `0x0000C000` | [SHA-512-DIGEST](value/nist.geul.org/sha-512-digest.md) | SHA-512 result, fixed 32-WORD Payload |
| `0x00000015` NIST | `0x0000C001` | [SHA3-256-DIGEST](value/nist.geul.org/sha3-256-digest.md) | SHA3-256 result, fixed 16-WORD Payload |
| `0x00000016` GPS | `0x00004000` | [GPS-TIMESTAMP-SECONDS](value/gps.geul.org/gps-timestamp-seconds.md) | Signed second count from the GPS epoch |
| `0x00000016` GPS | `0x00004001` | [GPS-TIMESTAMP-NANOSECONDS](value/gps.geul.org/gps-timestamp-nanoseconds.md) | Signed nanosecond count from the GPS epoch |

## Meta {#meta}

`0x1C0L~0x1FFL` — [Meta](meta/_index.md)

Meta numbers do not express the class in their bits. The class is known from the range table below. The verification class is the records in section 15 with `C >= 5`, that is `w >= 0x1E50`, and is known without a codebook. Meta has no ISSUER codes.

| Class | Direct codes | What it covers |
|---|---|---|
| [Structure](meta/_index.md#구조) | `0x1C0L~0x1C4L` | Document boundaries and length |
| [Definition](meta/_index.md#정의) | `0x1C5L~0x1CAL` | Interpretation declarations |
| [Provenance](meta/_index.md#출처) | `0x1CBL~0x1D0L` | Who, when, where |
| [Lineage](meta/_index.md#계보) | `0x1D1L~0x1DDL` | What it came from and how |
| [Policy](meta/_index.md#정책) | `0x1DEL~0x1E3L` | How it is handled |
| [IMPORT](meta/_index.md#import) | `0x1E4L` | Brings in an external document by IMPORT ID (`IMPORT-DOC`) |
| [Verification](meta/_index.md#검증) | `0x1E5L~0x1E9L` | Whether it can be trusted |
| Reserved (verification only) | `0x1EAL~0x1FFL` |  |

- Numbers run continuously from `0x1C0L` with no Reserved gaps. A new Meta outside verification cannot be placed before verification. The trailing Reserved `0x1EAL~0x1FFL` is for verification only. A Meta outside verification placed here would be left out of the content hash.

### Structure (`0x1C0L~0x1C4L`) {#구조-0x1c0l0x1c4l}

| Codec | Name | Description |
|---|---|---|
| `0x1C0L` | [DOC-1WORD](meta/0x1C0L-doc-1word.md) | Document start with the total length given in a 1-WORD Payload |
| `0x1C1L` | [DOC-2WORD](meta/0x1C1L-doc-2word.md) | Document start with the total length given in a 2-WORD Payload |
| `0x1C2L` | [DOC-4WORD](meta/0x1C2L-doc-4word.md) | Document start with the total length given in a 4-WORD Payload |
| `0x1C3L` | [BODY](meta/0x1C3L-body.md) | 1 WORD. Ends the document's HEAD and starts the BODY. |
| `0x1C4L` | [END](meta/0x1C4L-end.md) | 1 WORD. Closes the document. |

### Definition (`0x1C5L~0x1CAL`) {#정의-0x1c5l0x1cal}

| Codec | Name | Description |
|---|---|---|
| `0x1C5L` | [SPEC-VERSION](meta/0x1C5L-spec-version.md) | The GEUL specification edition followed. The Payload is itself the shortest-width unsigned integer. v1 is `0x0001` (record `0x1C51 0x0001`) |
| `0x1C6L` | [PROFILE](meta/0x1C6L-profile.md) | Applied profile |
| `0x1C7L` | [DOC-ID](meta/0x1C7L-doc-id.md) | The identifier of this document. Built-in Reference `DOC-POINTER` (Issuer, document ID, version 0). For a codec document, `CODEC-POINTER` (Issuer, codec ID, version 0) |
| `0x1C8L` | [EFFECTIVE-FROM](meta/0x1C8L-effective-from.md) | The effective date of this version. A GREGORIAN-DATE or POSIX-TIMESTAMP Value. If absent, the publication time |
| `0x1C9L` | [EFFECTIVE-UNTIL](meta/0x1C9L-effective-until.md) | The end of this version's validity (a time-limited law). If absent, until the next version takes effect |
| `0x1CAL` | [DEFAULT-LANGUAGE](meta/0x1CAL-default-language.md) | Default language |

### Provenance (`0x1CBL~0x1D0L`) {#출처-0x1cbl0x1d0l}

| Codec | Name | Description |
|---|---|---|
| `0x1CBL` | [AUTHOR](meta/0x1CBL-author.md) | Author. Reference (git author) |
| `0x1CCL` | [CO-AUTHOR](meta/0x1CCL-co-author.md) | Co-author. Reference (git `Co-authored-by`) |
| `0x1CDL` | [CREATED-AT](meta/0x1CDL-created-at.md) | Creation time. TIME Value (git author date) |
| `0x1CEL` | [MODIFIED-AT](meta/0x1CEL-modified-at.md) | Modification time. TIME Value |
| `0x1CFL` | [RECORDED-BY](meta/0x1CFL-recorded-by.md) | The party that recorded it. Reference (git committer) |
| `0x1D0L` | [RECORDED-AT](meta/0x1D0L-recorded-at.md) | Recording time. TIME Value (git commit date) |

- The source material and its range, retrieval time, and hash are written not in Meta but with the HEAD evidence Edge [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (Target `0`) and its QUALIFIER.

### Lineage (`0x1D1L~0x1DDL`) {#계보-0x1d1l0x1ddl}

| Codec | Name | Description |
|---|---|---|
| `0x1D1L` | [PARENT](meta/0x1D1L-parent.md) | Content hash of the immediately preceding version (git parent). If absent, this is the first version; if several, it is a merge (git merge commit). |
| `0x1D2L` | [DERIVED-FROM](meta/0x1D2L-derived-from.md) | Derived from records or material of another lineage. To pin a specific version of external material, attach a source-text hash QUALIFIER (P4092) to the HEAD [SOURCE](edge/0x0C0L-source.md#문서-전체의-출처) (git submodule). |
| `0x1D3L` | [GENERATED-BY](meta/0x1D3L-generated-by.md) | Generating party. A person, a model, a rule engine |
| `0x1D4L` | [TRANSFORMED-BY](meta/0x1D4L-transformed-by.md) | Transformation method. Tool, rule, version |
| `0x1D5L` | [CHERRY-PICKED-FROM](meta/0x1D5L-cherry-picked-from.md) | Content hash of the original version from which a change of another lineage was taken (git cherry-pick `-x`) |
| `0x1D6L` | [REVERTS](meta/0x1D6L-reverts.md) | Content hash of the version whose change is undone (git revert) |
| `0x1D7L` | [REPLACES](meta/0x1D7L-replaces.md) | Content hash of the version that was rewritten (git amend, rebase). The original version is not erased. |
| `0x1D8L` | [SQUASHED-FROM](meta/0x1D8L-squashed-from.md) | Content hashes of the original versions combined into one (git squash) |
| `0x1D9L` | [MESSAGE](meta/0x1D9L-message.md) | Reason for the change. A UTF8-LANGUAGE-TEXT Value, one per language (git commit message) |
| `0x1DAL` | [TAG](meta/0x1DAL-tag.md) | An immutable name attached to a version. TEXT Value and content hash (git annotated tag) |
| `0x1DBL` | [DELTA-BASE](meta/0x1DBL-delta-base.md) | This version file is a diff against a base version (2-WORD version ID) of the same document (git packfile delta) |
| `0x1DCL` | [DELTA-REMOVE](meta/0x1DCL-delta-remove.md) | In a diff, the list of LOCAL IDs (Edge Ids) to remove from the base BODY |
| `0x1DDL` | [NEXT-LOCAL-ID](meta/0x1DDL-next-local-id.md) | The next LOCAL ID to assign (auto increment). Placed in the HEAD of the version list `versions.geul` |

### Policy (`0x1DEL~0x1E3L`) {#정책-0x1del0x1e3l}

| Codec | Name | Description |
|---|---|---|
| `0x1DEL` | [LICENSE](meta/0x1DEL-license.md) | License. Reference |
| `0x1DFL` | [ACCESS](meta/0x1DFL-access.md) | Disclosure scope |
| `0x1E0L` | [PRIVACY](meta/0x1E0L-privacy.md) | Privacy level |
| `0x1E1L` | [RETENTION](meta/0x1E1L-retention.md) | Retention period |
| `0x1E2L` | [CONSENT](meta/0x1E2L-consent.md) | Scope and basis of consent |
| `0x1E3L` | [USAGE](meta/0x1E3L-usage.md) | Usage restrictions |

### IMPORT (`0x1E4L`) {#import-0x1e4l}

| Codec | Name | Description |
|---|---|---|
| `0x1E4L` | [IMPORT-DOC](meta/0x1E4L-import-doc.md) | Brings in an external document by IMPORT ID. Built-in Reference `DOC-POINTER` (`CODEC-POINTER` for a codec document) + IMPORT ID |

### Verification (`0x1E5L~0x1E9L`) {#검증-0x1e5l0x1e9l}

| Codec | Name | Description |
|---|---|---|
| `0x1E5L` | [ISSUER-KEY](meta/0x1E5L-issuer-key.md) | Declares the signature algorithm ID and public key of a self-issued Issuer |
| `0x1E6L` | [SIGNATURE](meta/0x1E6L-signature.md) | A signature over a target. A signature over a document signs the content hash (git signed commit, tag) |
| `0x1E7L` | [SIGNED-OFF](meta/0x1E7L-signed-off.md) | Confirmation of the right to contribute. Reference (git `Signed-off-by`, DCO) |
| `0x1E8L` | [CONFIDENCE](meta/0x1E8L-confidence.md) | Confidence |
| `0x1E9L` | [VERDICT](meta/0x1E9L-verdict.md) | Judgment result of the whole document. Pass, Review, Fail. At node or record level it is [TOULMIN](toulmin/_index.md) `VERDICT` (Edge `0x118L`) |

## Full Assignment Table {#전체-배정표}

227 assigned slots, 176 md files. The 5Q scheme and even-odd pairs have one row per member, and the md is the md of the head of the group.

| TAG ID | Codec ID | Name | Kind | Section | md | Group |
|---|---|---|---|---|---|---|
| `0x000L` | `0x00000000` | ABSENT | Reference | 0 | [0x000L-absent.md](reference/0x000L-absent.md) |  |
| `0x001L` | `0x00000010` | UNKNOWN-VALUE | Reference | 0 | [0x001L-unknown-value.md](reference/0x001L-unknown-value.md) |  |
| `0x002L` | `0x00000020` | NO-VALUE | Reference | 0 | [0x002L-no-value.md](reference/0x002L-no-value.md) |  |
| `0x005L` | `0x00000050` | LOCAL-IDENTIFIED | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x006L` | `0x00000060` | LOCAL-GENERIC | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x007L` | `0x00000070` | LOCAL-FREE-CHOICE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x008L` | `0x00000080` | LOCAL-UNIVERSAL | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x009L` | `0x00000090` | LOCAL-VARIABLE | Reference | 0 | [0x005L-local.md](reference/0x005L-local.md) | 5Q `LOCAL` |
| `0x00AL` | `0x000000A0` | GEUL-IDENTIFIED | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00BL` | `0x000000B0` | GEUL-GENERIC | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00CL` | `0x000000C0` | GEUL-FREE-CHOICE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00DL` | `0x000000D0` | GEUL-UNIVERSAL | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00EL` | `0x000000E0` | GEUL-VARIABLE | Reference | 0 | [0x00AL-geul.md](reference/0x00AL-geul.md) | 5Q `GEUL` |
| `0x00FL` | `0x000000F0` | GEUL-SIDX-IDENTIFIED | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x010L` | `0x00000100` | GEUL-SIDX-GENERIC | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x011L` | `0x00000110` | GEUL-SIDX-FREE-CHOICE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x012L` | `0x00000120` | GEUL-SIDX-UNIVERSAL | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x013L` | `0x00000130` | GEUL-SIDX-VARIABLE | Reference | 0 | [0x00FL-geul-sidx.md](reference/0x00FL-geul-sidx.md) | 5Q `GEUL-SIDX` |
| `0x014L` | `0x00000140` | WIKIDATA-QID-IDENTIFIED | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x015L` | `0x00000150` | WIKIDATA-QID-GENERIC | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x016L` | `0x00000160` | WIKIDATA-QID-FREE-CHOICE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x017L` | `0x00000170` | WIKIDATA-QID-UNIVERSAL | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x018L` | `0x00000180` | WIKIDATA-QID-VARIABLE | Reference | 0 | [0x014L-wikidata-qid.md](reference/0x014L-wikidata-qid.md) | 5Q `WIKIDATA-QID` |
| `0x019L` | `0x00000190` | WIKIDATA-PID-IDENTIFIED | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01AL` | `0x000001A0` | WIKIDATA-PID-GENERIC | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01BL` | `0x000001B0` | WIKIDATA-PID-FREE-CHOICE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01CL` | `0x000001C0` | WIKIDATA-PID-UNIVERSAL | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x01DL` | `0x000001D0` | WIKIDATA-PID-VARIABLE | Reference | 0 | [0x019L-wikidata-pid.md](reference/0x019L-wikidata-pid.md) | 5Q `WIKIDATA-PID` |
| `0x020L` | `0x00000200` | EXTERNAL-POINTER-1WORD-IDENTIFIED | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x021L` | `0x00000210` | EXTERNAL-POINTER-1WORD-GENERIC | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x022L` | `0x00000220` | EXTERNAL-POINTER-1WORD-FREE-CHOICE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x023L` | `0x00000230` | EXTERNAL-POINTER-1WORD-UNIVERSAL | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x024L` | `0x00000240` | EXTERNAL-POINTER-1WORD-VARIABLE | Reference | 1 | [0x020L-external-pointer-1word.md](reference/0x020L-external-pointer-1word.md) | 5Q `EXTERNAL-POINTER-1WORD` |
| `0x025L` | `0x00000250` | EXTERNAL-POINTER-2WORD-IDENTIFIED | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x026L` | `0x00000260` | EXTERNAL-POINTER-2WORD-GENERIC | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x027L` | `0x00000270` | EXTERNAL-POINTER-2WORD-FREE-CHOICE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x028L` | `0x00000280` | EXTERNAL-POINTER-2WORD-UNIVERSAL | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x029L` | `0x00000290` | EXTERNAL-POINTER-2WORD-VARIABLE | Reference | 1 | [0x025L-external-pointer-2word.md](reference/0x025L-external-pointer-2word.md) | 5Q `EXTERNAL-POINTER-2WORD` |
| `0x02AL` | `0x000002A0` | EXTERNAL-POINTER-4WORD-IDENTIFIED | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02BL` | `0x000002B0` | EXTERNAL-POINTER-4WORD-GENERIC | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02CL` | `0x000002C0` | EXTERNAL-POINTER-4WORD-FREE-CHOICE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02DL` | `0x000002D0` | EXTERNAL-POINTER-4WORD-UNIVERSAL | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02EL` | `0x000002E0` | EXTERNAL-POINTER-4WORD-VARIABLE | Reference | 1 | [0x02AL-external-pointer-4word.md](reference/0x02AL-external-pointer-4word.md) | 5Q `EXTERNAL-POINTER-4WORD` |
| `0x02FL` | `0x000002F0` | EXTERNAL-ISSUER-2WORD-IDENTIFIED | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x030L` | `0x00000300` | EXTERNAL-ISSUER-2WORD-GENERIC | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x031L` | `0x00000310` | EXTERNAL-ISSUER-2WORD-FREE-CHOICE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x032L` | `0x00000320` | EXTERNAL-ISSUER-2WORD-UNIVERSAL | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x033L` | `0x00000330` | EXTERNAL-ISSUER-2WORD-VARIABLE | Reference | 1 | [0x02FL-external-issuer-2word.md](reference/0x02FL-external-issuer-2word.md) | 5Q `EXTERNAL-ISSUER-2WORD` |
| `0x034L` | `0x00000340` | EXTERNAL-ISSUER-4WORD-IDENTIFIED | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x035L` | `0x00000350` | EXTERNAL-ISSUER-4WORD-GENERIC | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x036L` | `0x00000360` | EXTERNAL-ISSUER-4WORD-FREE-CHOICE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x037L` | `0x00000370` | EXTERNAL-ISSUER-4WORD-UNIVERSAL | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x038L` | `0x00000380` | EXTERNAL-ISSUER-4WORD-VARIABLE | Reference | 1 | [0x034L-external-issuer-4word.md](reference/0x034L-external-issuer-4word.md) | 5Q `EXTERNAL-ISSUER-4WORD` |
| `0x039L` | `0x00000390` | EXTERNAL-ISSUER-16WORD-IDENTIFIED | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03AL` | `0x000003A0` | EXTERNAL-ISSUER-16WORD-GENERIC | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03BL` | `0x000003B0` | EXTERNAL-ISSUER-16WORD-FREE-CHOICE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03CL` | `0x000003C0` | EXTERNAL-ISSUER-16WORD-UNIVERSAL | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x03DL` | `0x000003D0` | EXTERNAL-ISSUER-16WORD-VARIABLE | Reference | 1 | [0x039L-external-issuer-16word.md](reference/0x039L-external-issuer-16word.md) | 5Q `EXTERNAL-ISSUER-16WORD` |
| `0x040L` | `0x00000400` | ISSUER-POINTER | Reference | 2 | [0x040L-issuer-pointer.md](reference/0x040L-issuer-pointer.md) |  |
| `0x041L` | `0x00000410` | DOC-POINTER | Reference | 2 | [0x041L-doc-pointer.md](reference/0x041L-doc-pointer.md) |  |
| `0x042L` | `0x00000420` | CODEC-POINTER | Reference | 2 | [0x042L-codec-pointer.md](reference/0x042L-codec-pointer.md) |  |
| `0x05DL` | `0x000005D0` | REFERENCE-ISSUER-2WORD | Reference | 2 | [0x05DL-reference-issuer-2word.md](reference/0x05DL-reference-issuer-2word.md) |  |
| `0x05EL` | `0x000005E0` | REFERENCE-ISSUER-4WORD | Reference | 2 | [0x05EL-reference-issuer-4word.md](reference/0x05EL-reference-issuer-4word.md) |  |
| `0x05FL` | `0x000005F0` | REFERENCE-ISSUER-16WORD | Reference | 2 | [0x05FL-reference-issuer-16word.md](reference/0x05FL-reference-issuer-16word.md) |  |
| `0x060L` | `0x00000600` | BOOL | Value | 3 | [0x060L-bool.md](value/0x060L-bool.md) |  |
| `0x061L` | `0x00000610` | SIGNED-INTEGER | Value | 3 | [0x061L-signed-integer.md](value/0x061L-signed-integer.md) |  |
| `0x062L` | `0x00000620` | UNSIGNED-INTEGER | Value | 3 | [0x062L-unsigned-integer.md](value/0x062L-unsigned-integer.md) |  |
| `0x063L` | `0x00000630` | BINARY-FLOAT | Value | 3 | [0x063L-binary-float.md](value/0x063L-binary-float.md) |  |
| `0x064L` | `0x00000640` | COORDINATE-EARTH | Value | 3 | [0x064L-coordinate-earth.md](value/0x064L-coordinate-earth.md) |  |
| `0x065L` | `0x00000650` | COORDINATE-GEO | Value | 3 | [0x065L-coordinate-geo.md](value/0x065L-coordinate-geo.md) |  |
| `0x066L` | `0x00000660` | QUANTITY | Value | 3 | [0x066L-quantity.md](value/0x066L-quantity.md) |  |
| `0x067L` | `0x00000670` | FRACTION | Value | 3 | [0x067L-fraction.md](value/0x067L-fraction.md) |  |
| `0x068L` | `0x00000680` | SIGNED-DECIMAL | Value | 3 | [0x068L-signed-decimal.md](value/0x068L-signed-decimal.md) |  |
| `0x069L` | `0x00000690` | UNSIGNED-DECIMAL | Value | 3 | [0x069L-unsigned-decimal.md](value/0x069L-unsigned-decimal.md) |  |
| `0x06AL` | `0x000006A0` | GREGORIAN-DATE | Value | 3 | [0x06AL-gregorian-date.md](value/0x06AL-gregorian-date.md) |  |
| `0x06BL` | `0x000006B0` | CIVIL-TIME-NANOSECONDS | Value | 3 | [0x06BL-civil-time-nanoseconds.md](value/0x06BL-civil-time-nanoseconds.md) |  |
| `0x06CL` | `0x000006C0` | POSIX-TIMESTAMP-SECONDS | Value | 3 | [0x06CL-posix-timestamp-seconds.md](value/0x06CL-posix-timestamp-seconds.md) |  |
| `0x06DL` | `0x000006D0` | DURATION-SECONDS | Value | 3 | [0x06DL-duration-seconds.md](value/0x06DL-duration-seconds.md) |  |
| `0x06EL` | `0x000006E0` | EDTF-EVEN | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | Even-odd `EDTF` |
| `0x06FL` | `0x000006F0` | EDTF-ODD | Value | 3 | [0x06EL-edtf.md](value/0x06EL-edtf.md) | Even-odd `EDTF` |
| `0x070L` | `0x00000700` | GEDCOM-DATE-EVEN | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | Even-odd `GEDCOM-DATE` |
| `0x071L` | `0x00000710` | GEDCOM-DATE-ODD | Value | 3 | [0x070L-gedcom-date.md](value/0x070L-gedcom-date.md) | Even-odd `GEDCOM-DATE` |
| `0x072L` | `0x00000720` | UTF8-TEXT-EVEN | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | Even-odd `UTF8-TEXT` |
| `0x073L` | `0x00000730` | UTF8-TEXT-ODD | Value | 3 | [0x072L-utf8-text.md](value/0x072L-utf8-text.md) | Even-odd `UTF8-TEXT` |
| `0x074L` | `0x00000740` | URI-EVEN | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | Even-odd `URI` |
| `0x075L` | `0x00000750` | URI-ODD | Value | 3 | [0x074L-uri.md](value/0x074L-uri.md) | Even-odd `URI` |
| `0x076L` | `0x00000760` | LANGUAGE-BCP47-CODE-EVEN | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | Even-odd `LANGUAGE-BCP47-CODE` |
| `0x077L` | `0x00000770` | LANGUAGE-BCP47-CODE-ODD | Value | 3 | [0x076L-language-bcp47-code.md](value/0x076L-language-bcp47-code.md) | Even-odd `LANGUAGE-BCP47-CODE` |
| `0x078L` | `0x00000780` | UTF8-LANGUAGE-TEXT-EVEN | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | Even-odd `UTF8-LANGUAGE-TEXT` |
| `0x079L` | `0x00000790` | UTF8-LANGUAGE-TEXT-ODD | Value | 3 | [0x078L-utf8-language-text.md](value/0x078L-utf8-language-text.md) | Even-odd `UTF8-LANGUAGE-TEXT` |
| `0x07AL` | `0x000007A0` | LANGUAGE-SHORT-CODE | Value | 3 | [0x07AL-language-short-code.md](value/0x07AL-language-short-code.md) |  |
| `0x07BL` | `0x000007B0` | UUID | Value | 3 | [0x07BL-uuid.md](value/0x07BL-uuid.md) |  |
| `0x07CL` | `0x000007C0` | SHA-256-DIGEST | Value | 3 | [0x07CL-sha-256-digest.md](value/0x07CL-sha-256-digest.md) |  |
| `0x07DL` | `0x000007D0` | SHA1-DIGEST | Value | 3 | [0x07DL-sha1-digest.md](value/0x07DL-sha1-digest.md) |  |
| `0x07EL` | `0x000007E0` | OPAQUE-BYTES-EVEN | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | Even-odd `OPAQUE-BYTES` |
| `0x07FL` | `0x000007F0` | OPAQUE-BYTES-ODD | Value | 3 | [0x07EL-opaque-bytes.md](value/0x07EL-opaque-bytes.md) | Even-odd `OPAQUE-BYTES` |
| `0x080L` | `0x00000800` | BIT-VECTOR | Value | 4 | [0x080L-bit-vector.md](value/0x080L-bit-vector.md) |  |
| `0x081L` | `0x00000810` | DURATION-NANOSECONDS | Value | 4 | [0x081L-duration-nanoseconds.md](value/0x081L-duration-nanoseconds.md) |  |
| `0x09DL` | `0x000009D0` | VALUE-ISSUER-2WORD | Value | 4 | [0x09DL-value-issuer-2word.md](value/0x09DL-value-issuer-2word.md) |  |
| `0x09EL` | `0x000009E0` | VALUE-ISSUER-4WORD | Value | 4 | [0x09EL-value-issuer-4word.md](value/0x09EL-value-issuer-4word.md) |  |
| `0x09FL` | `0x000009F0` | VALUE-ISSUER-16WORD | Value | 4 | [0x09FL-value-issuer-16word.md](value/0x09FL-value-issuer-16word.md) |  |
| `0x0A0L` | `0x00000A00` | REFERENCE-NODE | Edge | 5 | [0x0A0L-reference-node.md](edge/0x0A0L-reference-node.md) |  |
| `0x0A1L` | `0x00000A10` | SAME-NODE | Edge | 5 | [0x0A1L-same-node.md](edge/0x0A1L-same-node.md) |  |
| `0x0A2L` | `0x00000A20` | DIFFERENT-NODE | Edge | 5 | [0x0A2L-different-node.md](edge/0x0A2L-different-node.md) |  |
| `0x0A3L` | `0x00000A30` | BIND | Edge | 5 | [0x0A3L-bind.md](edge/0x0A3L-bind.md) |  |
| `0x0A4L` | `0x00000A40` | LABEL | Edge | 5 | [0x0A4L-label.md](edge/0x0A4L-label.md) |  |
| `0x0A5L` | `0x00000A50` | ALIAS | Edge | 5 | [0x0A5L-alias.md](edge/0x0A5L-alias.md) |  |
| `0x0A6L` | `0x00000A60` | DESCRIPTION | Edge | 5 | [0x0A6L-description.md](edge/0x0A6L-description.md) |  |
| `0x0A8L` | `0x00000A80` | VERB-SHORT | Edge | 5 | [0x0A8L-verb-short.md](edge/0x0A8L-verb-short.md) |  |
| `0x0A9L` | `0x00000A90` | VERB | Edge | 5 | [0x0A9L-verb.md](edge/0x0A9L-verb.md) |  |
| `0x0AAL` | `0x00000AA0` | TRIPLE | Edge | 5 | [0x0AAL-triple.md](edge/0x0AAL-triple.md) |  |
| `0x0ABL` | `0x00000AB0` | QUALIFIER | Edge | 5 | [0x0ABL-qualifier.md](edge/0x0ABL-qualifier.md) |  |
| `0x0B0L` | `0x00000B00` | WORLD | Edge | 5 | [0x0B0L-world.md](edge/0x0B0L-world.md) |  |
| `0x0B1L` | `0x00000B10` | TIMELINE | Edge | 5 | [0x0B1L-timeline.md](edge/0x0B1L-timeline.md) |  |
| `0x0B2L` | `0x00000B20` | SCENE | Edge | 5 | [0x0B2L-scene.md](edge/0x0B2L-scene.md) |  |
| `0x0B8L` | `0x00000B80` | PUBLICATION | Edge | 5 | [0x0B8L-publication.md](edge/0x0B8L-publication.md) |  |
| `0x0B9L` | `0x00000B90` | DEPRECATION | Edge | 5 | [0x0B9L-deprecation.md](edge/0x0B9L-deprecation.md) |  |
| `0x0BAL` | `0x00000BA0` | TOMBSTONE | Edge | 5 | [0x0BAL-tombstone.md](edge/0x0BAL-tombstone.md) |  |
| `0x0BBL` | `0x00000BB0` | DECLARE | Edge | 5 | [0x0BBL-declare.md](edge/0x0BBL-declare.md) |  |
| `0x0BCL` | `0x00000BC0` | FIELD | Edge | 5 | [0x0BCL-field.md](edge/0x0BCL-field.md) |  |
| `0x0BDL` | `0x00000BD0` | ENUM | Edge | 5 | [0x0BDL-enum.md](edge/0x0BDL-enum.md) |  |
| `0x0BEL` | `0x00000BE0` | CODEC | Edge | 5 | [0x0BEL-codec.md](edge/0x0BEL-codec.md) |  |
| `0x0C0L` | `0x00000C00` | SOURCE | Edge | 6 | [0x0C0L-source.md](edge/0x0C0L-source.md) |  |
| `0x0E1L` | `0x00000E10` | FUNCTION-DECLARE | Edge | 7 | [0x0E1L-function-declare.md](edge/0x0E1L-function-declare.md) |  |
| `0x0E2L` | `0x00000E20` | TYPE-DECLARE | Edge | 7 | [0x0E2L-type-declare.md](edge/0x0E2L-type-declare.md) |  |
| `0x0E8L` | `0x00000E80` | CONST | Edge | 7 | [0x0E8L-const.md](edge/0x0E8L-const.md) |  |
| `0x0E9L` | `0x00000E90` | UNARY | Edge | 7 | [0x0E9L-unary.md](edge/0x0E9L-unary.md) |  |
| `0x0EAL` | `0x00000EA0` | BINARY | Edge | 7 | [0x0EAL-binary.md](edge/0x0EAL-binary.md) |  |
| `0x0EBL` | `0x00000EB0` | CALL | Edge | 7 | [0x0EBL-call.md](edge/0x0EBL-call.md) |  |
| `0x0ECL` | `0x00000EC0` | MEMBER | Edge | 7 | [0x0ECL-member.md](edge/0x0ECL-member.md) |  |
| `0x0EDL` | `0x00000ED0` | INDEX | Edge | 7 | [0x0EDL-index.md](edge/0x0EDL-index.md) |  |
| `0x0EEL` | `0x00000EE0` | CONSTRUCT | Edge | 7 | [0x0EEL-construct.md](edge/0x0EEL-construct.md) |  |
| `0x0EFL` | `0x00000EF0` | CONDITIONAL | Edge | 7 | [0x0EFL-conditional.md](edge/0x0EFL-conditional.md) |  |
| `0x0F0L` | `0x00000F00` | BLOCK | Edge | 7 | [0x0F0L-block.md](edge/0x0F0L-block.md) |  |
| `0x0F1L` | `0x00000F10` | ASSIGN | Edge | 7 | [0x0F1L-assign.md](edge/0x0F1L-assign.md) |  |
| `0x0F2L` | `0x00000F20` | IF | Edge | 7 | [0x0F2L-if.md](edge/0x0F2L-if.md) |  |
| `0x0F3L` | `0x00000F30` | SWITCH | Edge | 7 | [0x0F3L-switch.md](edge/0x0F3L-switch.md) |  |
| `0x0F4L` | `0x00000F40` | WHILE | Edge | 7 | [0x0F4L-while.md](edge/0x0F4L-while.md) |  |
| `0x0F5L` | `0x00000F50` | FOREACH | Edge | 7 | [0x0F5L-foreach.md](edge/0x0F5L-foreach.md) |  |
| `0x0F6L` | `0x00000F60` | JUMP | Edge | 7 | [0x0F6L-jump.md](edge/0x0F6L-jump.md) |  |
| `0x0F7L` | `0x00000F70` | RETURN | Edge | 7 | [0x0F7L-return.md](edge/0x0F7L-return.md) |  |
| `0x0F8L` | `0x00000F80` | RAISE | Edge | 7 | [0x0F8L-raise.md](edge/0x0F8L-raise.md) |  |
| `0x0F9L` | `0x00000F90` | TRY | Edge | 7 | [0x0F9L-try.md](edge/0x0F9L-try.md) |  |
| `0x100L` | `0x00001000` | CASE-DECLARE | Edge | 8 | [0x100L-case-declare.md](toulmin/0x100L-case-declare.md) |  |
| `0x101L` | `0x00001010` | PREDICATE-DECLARE | Edge | 8 | [0x101L-predicate-declare.md](toulmin/0x101L-predicate-declare.md) |  |
| `0x102L` | `0x00001020` | SPEC-DECLARE | Edge | 8 | [0x102L-spec-declare.md](toulmin/0x102L-spec-declare.md) |  |
| `0x103L` | `0x00001030` | RULE-DECLARE | Edge | 8 | [0x103L-rule-declare.md](toulmin/0x103L-rule-declare.md) |  |
| `0x104L` | `0x00001040` | COUNTER-DECLARE | Edge | 8 | [0x104L-counter-declare.md](toulmin/0x104L-counter-declare.md) |  |
| `0x105L` | `0x00001050` | EXCEPT-DECLARE | Edge | 8 | [0x105L-except-declare.md](toulmin/0x105L-except-declare.md) |  |
| `0x108L` | `0x00001080` | ATTACKS | Edge | 8 | [0x108L-attacks.md](toulmin/0x108L-attacks.md) |  |
| `0x109L` | `0x00001090` | SUPERSEDES | Edge | 8 | [0x109L-supersedes.md](toulmin/0x109L-supersedes.md) |  |
| `0x10AL` | `0x000010A0` | SUPERSEDE-CHAIN | Edge | 8 | [0x10AL-supersede-chain.md](toulmin/0x10AL-supersede-chain.md) |  |
| `0x110L` | `0x00001100` | RUN | Edge | 8 | [0x110L-run.md](toulmin/0x110L-run.md) |  |
| `0x111L` | `0x00001110` | DO | Edge | 8 | [0x111L-do.md](toulmin/0x111L-do.md) |  |
| `0x112L` | `0x00001120` | DO-ONCE | Edge | 8 | [0x112L-do-once.md](toulmin/0x112L-do-once.md) |  |
| `0x113L` | `0x00001130` | UNDO | Edge | 8 | [0x113L-undo.md](toulmin/0x113L-undo.md) |  |
| `0x114L` | `0x00001140` | CHECKING | Edge | 8 | [0x114L-checking.md](toulmin/0x114L-checking.md) |  |
| `0x115L` | `0x00001150` | ENTRY | Edge | 8 | [0x115L-entry.md](toulmin/0x115L-entry.md) |  |
| `0x116L` | `0x00001160` | TRIGGER | Edge | 8 | [0x116L-trigger.md](toulmin/0x116L-trigger.md) |  |
| `0x118L` | `0x00001180` | VERDICT | Edge | 8 | [0x118L-verdict.md](toulmin/0x118L-verdict.md) |  |
| `0x119L` | `0x00001190` | EVIDENCE | Edge | 8 | [0x119L-evidence.md](toulmin/0x119L-evidence.md) |  |
| `0x120L` | `0x00001200` | SOURCE | Edge | 9 | [0x120L-source.md](toulmin/0x120L-source.md) |  |
| `0x121L` | `0x00001210` | TEXT | Edge | 9 | [0x121L-text.md](toulmin/0x121L-text.md) |  |
| `0x122L` | `0x00001220` | SECTION | Edge | 9 | [0x122L-section.md](toulmin/0x122L-section.md) |  |
| `0x123L` | `0x00001230` | CASE-BEGIN | Edge | 9 | [0x123L-case-begin.md](toulmin/0x123L-case-begin.md) |  |
| `0x124L` | `0x00001240` | CASE-END | Edge | 9 | [0x124L-case-end.md](toulmin/0x124L-case-end.md) |  |
| `0x125L` | `0x00001250` | PROSE | Edge | 9 | [0x125L-prose.md](toulmin/0x125L-prose.md) |  |
| `0x126L` | `0x00001260` | NAMESPACE | Edge | 9 | [0x126L-namespace.md](toulmin/0x126L-namespace.md) |  |
| `0x127L` | `0x00001270` | FUNC | Edge | 9 | [0x127L-func.md](toulmin/0x127L-func.md) |  |
| `0x128L` | `0x00001280` | FIELD | Edge | 9 | [0x128L-field.md](toulmin/0x128L-field.md) |  |
| `0x129L` | `0x00001290` | ALIAS | Edge | 9 | [0x129L-alias.md](toulmin/0x129L-alias.md) |  |
| `0x12AL` | `0x000012A0` | GROUP | Edge | 9 | [0x12AL-group.md](toulmin/0x12AL-group.md) |  |
| `0x12BL` | `0x000012B0` | REQUIRES | Edge | 9 | [0x12BL-requires.md](toulmin/0x12BL-requires.md) |  |
| `0x12CL` | `0x000012C0` | MEANS | Edge | 9 | [0x12CL-means.md](toulmin/0x12CL-means.md) |  |
| `0x12DL` | `0x000012D0` | HAS | Edge | 9 | [0x12DL-has.md](toulmin/0x12DL-has.md) |  |
| `0x12EL` | `0x000012E0` | RUNS | Edge | 9 | [0x12EL-runs.md](toulmin/0x12EL-runs.md) |  |
| `0x12FL` | `0x000012F0` | EVALUATES | Edge | 9 | [0x12FL-evaluates.md](toulmin/0x12FL-evaluates.md) |  |
| `0x130L` | `0x00001300` | TRIGGERS | Edge | 9 | [0x130L-triggers.md](toulmin/0x130L-triggers.md) |  |
| `0x131L` | `0x00001310` | UNTIL | Edge | 9 | [0x131L-until.md](toulmin/0x131L-until.md) |  |
| `0x132L` | `0x00001320` | SAME-AS | Edge | 9 | [0x132L-same-as.md](toulmin/0x132L-same-as.md) |  |
| `0x133L` | `0x00001330` | IMPORTED-FROM | Edge | 9 | [0x133L-imported-from.md](toulmin/0x133L-imported-from.md) |  |
| `0x134L` | `0x00001340` | LABEL | Edge | 9 | [0x134L-label.md](toulmin/0x134L-label.md) |  |
| `0x1BDL` | `0x00001BD0` | EDGE-ISSUER-2WORD | Edge | 13 | [0x1BDL-edge-issuer-2word.md](edge/0x1BDL-edge-issuer-2word.md) |  |
| `0x1BEL` | `0x00001BE0` | EDGE-ISSUER-4WORD | Edge | 13 | [0x1BEL-edge-issuer-4word.md](edge/0x1BEL-edge-issuer-4word.md) |  |
| `0x1BFL` | `0x00001BF0` | EDGE-ISSUER-16WORD | Edge | 13 | [0x1BFL-edge-issuer-16word.md](edge/0x1BFL-edge-issuer-16word.md) |  |
| `0x1C0L` | `0x00001C00` | DOC-1WORD | Meta | 14 | [0x1C0L-doc-1word.md](meta/0x1C0L-doc-1word.md) |  |
| `0x1C1L` | `0x00001C10` | DOC-2WORD | Meta | 14 | [0x1C1L-doc-2word.md](meta/0x1C1L-doc-2word.md) |  |
| `0x1C2L` | `0x00001C20` | DOC-4WORD | Meta | 14 | [0x1C2L-doc-4word.md](meta/0x1C2L-doc-4word.md) |  |
| `0x1C3L` | `0x00001C30` | BODY | Meta | 14 | [0x1C3L-body.md](meta/0x1C3L-body.md) |  |
| `0x1C4L` | `0x00001C40` | END | Meta | 14 | [0x1C4L-end.md](meta/0x1C4L-end.md) |  |
| `0x1C5L` | `0x00001C50` | SPEC-VERSION | Meta | 14 | [0x1C5L-spec-version.md](meta/0x1C5L-spec-version.md) |  |
| `0x1C6L` | `0x00001C60` | PROFILE | Meta | 14 | [0x1C6L-profile.md](meta/0x1C6L-profile.md) |  |
| `0x1C7L` | `0x00001C70` | DOC-ID | Meta | 14 | [0x1C7L-doc-id.md](meta/0x1C7L-doc-id.md) |  |
| `0x1C8L` | `0x00001C80` | EFFECTIVE-FROM | Meta | 14 | [0x1C8L-effective-from.md](meta/0x1C8L-effective-from.md) |  |
| `0x1C9L` | `0x00001C90` | EFFECTIVE-UNTIL | Meta | 14 | [0x1C9L-effective-until.md](meta/0x1C9L-effective-until.md) |  |
| `0x1CAL` | `0x00001CA0` | DEFAULT-LANGUAGE | Meta | 14 | [0x1CAL-default-language.md](meta/0x1CAL-default-language.md) |  |
| `0x1CBL` | `0x00001CB0` | AUTHOR | Meta | 14 | [0x1CBL-author.md](meta/0x1CBL-author.md) |  |
| `0x1CCL` | `0x00001CC0` | CO-AUTHOR | Meta | 14 | [0x1CCL-co-author.md](meta/0x1CCL-co-author.md) |  |
| `0x1CDL` | `0x00001CD0` | CREATED-AT | Meta | 14 | [0x1CDL-created-at.md](meta/0x1CDL-created-at.md) |  |
| `0x1CEL` | `0x00001CE0` | MODIFIED-AT | Meta | 14 | [0x1CEL-modified-at.md](meta/0x1CEL-modified-at.md) |  |
| `0x1CFL` | `0x00001CF0` | RECORDED-BY | Meta | 14 | [0x1CFL-recorded-by.md](meta/0x1CFL-recorded-by.md) |  |
| `0x1D0L` | `0x00001D00` | RECORDED-AT | Meta | 14 | [0x1D0L-recorded-at.md](meta/0x1D0L-recorded-at.md) |  |
| `0x1D1L` | `0x00001D10` | PARENT | Meta | 14 | [0x1D1L-parent.md](meta/0x1D1L-parent.md) |  |
| `0x1D2L` | `0x00001D20` | DERIVED-FROM | Meta | 14 | [0x1D2L-derived-from.md](meta/0x1D2L-derived-from.md) |  |
| `0x1D3L` | `0x00001D30` | GENERATED-BY | Meta | 14 | [0x1D3L-generated-by.md](meta/0x1D3L-generated-by.md) |  |
| `0x1D4L` | `0x00001D40` | TRANSFORMED-BY | Meta | 14 | [0x1D4L-transformed-by.md](meta/0x1D4L-transformed-by.md) |  |
| `0x1D5L` | `0x00001D50` | CHERRY-PICKED-FROM | Meta | 14 | [0x1D5L-cherry-picked-from.md](meta/0x1D5L-cherry-picked-from.md) |  |
| `0x1D6L` | `0x00001D60` | REVERTS | Meta | 14 | [0x1D6L-reverts.md](meta/0x1D6L-reverts.md) |  |
| `0x1D7L` | `0x00001D70` | REPLACES | Meta | 14 | [0x1D7L-replaces.md](meta/0x1D7L-replaces.md) |  |
| `0x1D8L` | `0x00001D80` | SQUASHED-FROM | Meta | 14 | [0x1D8L-squashed-from.md](meta/0x1D8L-squashed-from.md) |  |
| `0x1D9L` | `0x00001D90` | MESSAGE | Meta | 14 | [0x1D9L-message.md](meta/0x1D9L-message.md) |  |
| `0x1DAL` | `0x00001DA0` | TAG | Meta | 14 | [0x1DAL-tag.md](meta/0x1DAL-tag.md) |  |
| `0x1DBL` | `0x00001DB0` | DELTA-BASE | Meta | 14 | [0x1DBL-delta-base.md](meta/0x1DBL-delta-base.md) |  |
| `0x1DCL` | `0x00001DC0` | DELTA-REMOVE | Meta | 14 | [0x1DCL-delta-remove.md](meta/0x1DCL-delta-remove.md) |  |
| `0x1DDL` | `0x00001DD0` | NEXT-LOCAL-ID | Meta | 14 | [0x1DDL-next-local-id.md](meta/0x1DDL-next-local-id.md) |  |
| `0x1DEL` | `0x00001DE0` | LICENSE | Meta | 14 | [0x1DEL-license.md](meta/0x1DEL-license.md) |  |
| `0x1DFL` | `0x00001DF0` | ACCESS | Meta | 14 | [0x1DFL-access.md](meta/0x1DFL-access.md) |  |
| `0x1E0L` | `0x00001E00` | PRIVACY | Meta | 15 | [0x1E0L-privacy.md](meta/0x1E0L-privacy.md) |  |
| `0x1E1L` | `0x00001E10` | RETENTION | Meta | 15 | [0x1E1L-retention.md](meta/0x1E1L-retention.md) |  |
| `0x1E2L` | `0x00001E20` | CONSENT | Meta | 15 | [0x1E2L-consent.md](meta/0x1E2L-consent.md) |  |
| `0x1E3L` | `0x00001E30` | USAGE | Meta | 15 | [0x1E3L-usage.md](meta/0x1E3L-usage.md) |  |
| `0x1E4L` | `0x00001E40` | IMPORT-DOC | Meta | 15 | [0x1E4L-import-doc.md](meta/0x1E4L-import-doc.md) |  |
| `0x1E5L` | `0x00001E50` | ISSUER-KEY | Meta | 15 | [0x1E5L-issuer-key.md](meta/0x1E5L-issuer-key.md) |  |
| `0x1E6L` | `0x00001E60` | SIGNATURE | Meta | 15 | [0x1E6L-signature.md](meta/0x1E6L-signature.md) |  |
| `0x1E7L` | `0x00001E70` | SIGNED-OFF | Meta | 15 | [0x1E7L-signed-off.md](meta/0x1E7L-signed-off.md) |  |
| `0x1E8L` | `0x00001E80` | CONFIDENCE | Meta | 15 | [0x1E8L-confidence.md](meta/0x1E8L-confidence.md) |  |
| `0x1E9L` | `0x00001E90` | VERDICT | Meta | 15 | [0x1E9L-verdict.md](meta/0x1E9L-verdict.md) |  |
