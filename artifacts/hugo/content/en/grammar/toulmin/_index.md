---
title: "TOULMIN"
weight: 130
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "Writes judgment and execution graphs with the Toulmin argument model."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Writes judgment and execution graphs with the Toulmin argument model. It is the core family through which GEUL describes its own rules in GEUL and revises itself.

| Group | Codec |
|---|---|
| Declaration | [CASE-DECLARE](0x100L-case-declare.md) (case), [PREDICATE-DECLARE](0x101L-predicate-declare.md) (predicate), [SPEC-DECLARE](0x102L-spec-declare.md) (criterion), [RULE-DECLARE](0x103L-rule-declare.md) (claim), [COUNTER-DECLARE](0x104L-counter-declare.md) (rebuttal), [EXCEPT-DECLARE](0x105L-except-declare.md) (exception) — [NODE](#node) |
| Relation | [ATTACKS](0x108L-attacks.md) (attack), [SUPERSEDES](0x109L-supersedes.md) (exclusion) — [LINK](#link), [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) (priority chain, layout undecided) |
| Execution | [RUN](0x110L-run.md), [DO](0x111L-do.md), [DO-ONCE](0x112L-do-once.md), [UNDO](0x113L-undo.md), [CHECKING](0x114L-checking.md) — [LINK](#link), [ENTRY](0x115L-entry.md), [TRIGGER](0x116L-trigger.md) — [NODE](#node) |
| Result | [VERDICT](0x118L-verdict.md) (judgment result: Pass, Review, Fail), [EVIDENCE](0x119L-evidence.md) (evidence of a judgment) — layout undecided |

- The source, section, and auxiliary nodes and relations are the direct codes `0x120L~0x134L` of the TOULMIN format family ([Source and sections](#source와-구획), [TOULMIN format](#toulmin-형식)).
- A judgment result is kept in a document different from the one being judged. The result document imports and points to the target document. So judging does not change the content hash of the target document.

TOULMIN family Edges (direct codes `0x100L~0x11BL`; auxiliary records are in the TOULMIN format family `0x120L~0x134L`) write judgment and execution graphs with the Toulmin argument model. Declarations of claims, rebuttals, and exceptions, attack and exclusion relations, execution links, and judgment results are all Edges. One TANGEUL document (the rule language of the toulmin engine) becomes one GEUL document. The file extension is `.geul`, the same as other documents.

What this document does not fix follows the common rules of [Edge](../edge/_index.md) and [Records and TAG WORD](../record.md).

## Metacognition and self-revision {#메타-인지와-자기-개정}

TOULMIN is a GEUL Codec so that GEUL can be metacognitive about itself. Only if the judgment and execution rules are also described in GEUL can TOULMIN take those rules as its object and revise them itself. So TOULMIN is not an application profile but the core of GEUL operation, and it sits in the Edge direct code space (`0x100L~0x11BL`).

- Self-description makes self-improvement possible but bears the risk of circular error. If a rule judges its own revision, a revision that loosens the judgment criteria can also pass (the pass rate rises while the real accuracy falls).
- The circularity is accepted as a risk but cut by structure.
  - **Fixed core**: the meaning of judgment (Pass, Review, Fail; attack, exclusion, priority; the three-valued evaluation and U → Review in [Judging on the unknown](#미상-위에서-판정하기) below) is fixed in this specification. It cannot be changed by a TOULMIN document. This is the same place as the rules built into the decoder (layer 0 of [Publication addresses and version lists](../publishing.md#층)).
  - **Version separation**: the revision of rule document v(n) is judged by the rules of v(n−1) and by external checks. A rule does not judge itself. A judgment result is kept in a document different from its target (the content hash of the target does not change).
  - **Immutable history**: revisions accumulate as new versions (`PARENT`, content hash, signature). Because old versions remain, a circular error can be found afterwards and rolled back. The safety net of self-revision is the GEUL version model ([Document](../document.md#개정)).
  - **Outside criterion**: a set of test cases that the revision path cannot touch is kept separately. The adoption of a revision is confirmed by the result on this set.
- Falsification test: deliberately plant one wrong rule. If the system fixes it and the outside-criterion score rises, self-improvement works. If only the pass rate rises and the outside-criterion score falls, it is a circular error.

## Codes {#코드}

A TOULMIN record uses one of three layouts. The Codec sets the layout.

| Layout | Use | Page |
|---|---|---|
| NODE | graph nodes such as case, rule, definition, entry point | [NODE](#node) |
| LINK | relations between nodes (attack, exclusion, execution, definition) | [LINK](#link) |
| EXPR | condition expression (predicate) | [EXPR](0x101L-predicate-declare.md) |

The source and section records (SOURCE, TEXT, SECTION, CASE-BEGIN and CASE-END, PROSE) are set by [Source and sections](#source와-구획).

### Direct codes {#직접-코드}

| Codec | Name | Layout | TANGEUL | Meaning |
|---|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | NODE | `in case of` | Case declaration. A judgment graph that holds nodes and relations |
| `0x101L` | [PREDICATE-DECLARE](0x101L-predicate-declare.md) | EXPR | condition expression of Rules | Predicate declaration. A judgment expression |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | NODE | Definitions item | Criterion declaration (Backing). The role bits give the kind of definition |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | NODE | general rule, rule name in Rules | Claim declaration (Warrant). It can be attacked |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | NODE | counter rule | Rebuttal declaration. It attacks with a conclusion of its own. The default Level is Fail |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | NODE | except rule | Exception declaration. It attacks without a conclusion of its own. The default Level is Review |
| `0x108L` | [ATTACKS](0x108L-attacks.md) | LINK | `don't X when Y` | Attack relation. The attacker's verdict gradually reduces the target's verdict by the attack strength (0 to 1, default 1) |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | LINK | `X supersedes Y` | Exclusion relation. If the attacker is Active, it deterministically removes the target from the aggregation. A chain (`A > B > C`) is written one pair at a time |
| `0x10AL` | [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) | — | | Priority chain `A > B > C`. An abbreviation of pairwise SUPERSEDES. Only the code is assigned; there is no layout yet |
| `0x110L` | [RUN](0x110L-run.md) | LINK | `run c when n` | Execution composition. If the node is Active, it runs a sub-case (DAG) |
| `0x111L` | [DO](0x111L-do.md) | LINK | `do fn when n` | An action performed if the node is Active |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | LINK | `do fn once when n` | An action performed only once even on retry |
| `0x113L` | [UNDO](0x113L-undo.md) | LINK | `undo fn when n` | The compensating action of DO (saga). If a later step fails, it is performed in reverse order |
| `0x114L` | [CHECKING](0x114L-checking.md) | LINK | `checking c` | A link that only judges, without side effects |
| `0x115L` | [ENTRY](0x115L-entry.md) | NODE | `provides x` | External entry point. It runs or judges a case |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | NODE | `on`, `every`, `until` | An event or periodic entry point with no external call |
| `0x118L` | [VERDICT](0x118L-verdict.md) | — | | The judgment result of a node or record. Result (Pass, Review, Fail), verdict value, Activated, Excluded, Level. Only the code is assigned; there is no layout yet |
| `0x119L` | [EVIDENCE](0x119L-evidence.md) | — | | The evidence of a judgment. Location, expected value, actual value (Fact). Only the code is assigned; there is no layout yet |
| `0x11CL~0x11FL` | Reserved | | | |

- Direct codes not in the table (`0x106L`, `0x107L`, `0x10BL`~`0x10FL`, `0x117L`, `0x11AL`, `0x11BL`) are Reserved.
- The groups are `0x100L~0x107L` declaration, `0x108L~0x10FL` relation, `0x110L~0x117L` execution, and `0x118L~0x11FL` result (`0x11CL~0x11FL` are Reserved).
- The verdict of a whole document belongs to Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`), and the verdict of a node or record belongs to TOULMIN `VERDICT` (Edge `0x118L`). The two are separate Codecs with different Kinds.

### TOULMIN format {#toulmin-형식}

The source, section, and auxiliary nodes and relations are placed in the direct codes `0x120L~0x134L` of the Edge TOULMIN format family. There is no Issuer or Codec number slot, and the Payload follows the TAG directly.

```
TAG WORD          0001 0010 0000 LLLL      Edge, Codec 0x120L (SOURCE). Other codes use the same slot
[Length extension TAG]
Edge Id           LOCAL Reference record
components        layout set by the format
```

| Codec | Name | Layout | Meaning |
|---|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN width WORD, UTF8 Value | Authoring source text |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value | Name or string |
| `0x122L` | [SECTION](0x122L-section.md) | ID, section code 1 WORD | Section start |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (case) | Start of a case scope |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (case) | End of a case scope |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN | Descriptive paragraph |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | NODE | `this document is` |
| `0x127L` | [FUNC](0x127L-func.md) | NODE | Function reference |
| `0x128L` | [FIELD](0x128L-field.md) | NODE | `is required` |
| `0x129L` | [ALIAS](0x129L-alias.md) | NODE | `see … from` |
| `0x12AL` | [GROUP](0x12AL-group.md) | NODE | Ordered execution group |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | LINK | Case → field |
| `0x12CL` | [MEANS](0x12CL-means.md) | LINK | Definition item → value or type |
| `0x12DL` | [HAS](0x12DL-has.md) | LINK | Definition item → field |
| `0x12EL` | [RUNS](0x12EL-runs.md) | LINK | Entry point → case, run |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | LINK | Entry point → case, judge |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | LINK | Trigger → case |
| `0x131L` | [UNTIL](0x131L-until.md) | LINK | Trigger → case (`every … until`) |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | LINK | Node → global identifier |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | LINK | Alias → path (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | LINK | Node → TEXT, name notation |

## Document {#문서}

One `.geul` file is one DOC. No other bytes are placed outside the DOC.

```
DOC-1WORD/2WORD/4WORD     total length
  SPEC-VERSION            0x0001 (v1, integer with no embedded Value)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>". Currently "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value. Authoring locale ("en", "ko")
BODY
  SOURCE                  authoring source text. First record of the BODY
  statement records …     in document declaration order
END
```

- HEAD: [SPEC-VERSION](../meta/0x1C5L-spec-version.md), [PROFILE](../meta/0x1C6L-profile.md), optional [DEFAULT-LANGUAGE](../meta/0x1CAL-default-language.md).
- The decoder rejects a different SPEC-VERSION or a different PROFILE major. A different minor is still read.
- The first record of the BODY is SOURCE. Every SPAN is a range within this source text.
- The order of statement records is the same as the document declaration order. Execution order (`do` and `run` firing, `undo` reverse compensation) relies on this order. In a TOULMIN document, Edge order is meaningful (an exception to the order rule of the [Edge layout](../edge/_index.md#레이아웃)).
- Every record in the BODY is an Edge. No standalone Value records are placed. Values are embedded in the Edge Payload.
- The identity of a case and imports use Meta [DOC-ID](../meta/0x1C7L-doc-id.md) and [IMPORT-DOC](../meta/0x1E4L-import-doc.md) (Subject and See of TANGEUL).

## Common fields {#공통-필드}

| Field | Width | Description |
|---|---|---|
| ID | LOCAL Reference record | The Edge Id of the record. The first element of the Payload of every record |
| REF | LOCAL Reference record | An Edge Id pointing to another record of this document. `0` means none |
| SPAN | width set by SOURCE × 2 | A range within the authoring source text. Start byte, byte count |

- ID and REF are embedded [LOCAL](../reference/0x005L-local.md) Reference records (`0000 0000 0101 LLLL` + an ID of the shortest width). The width is set by the Length of that record and is not declared per document.
- REF `0` (LOCAL `0`) means "none". This is a Codec rule that uses LOCAL `0` as none ([LOCAL](../reference/0x005L-local.md)).
- Edge Ids are assigned from 1 and are not duplicated within a document. `0` is not used as an Edge Id because it means "none" in REF.
- Nodes are forward-referenced by other records, so they receive numbers first, in document declaration order. The encoder assigns the other records (SOURCE, TEXT, LINK, FUNC, section records) numbers after the nodes.
- The decoder only checks that an Edge Id is not 0 and has no duplicate. The assignment order is not used in interpretation.
- Nodes and relations are pointed to by Edge Id.
- An embedded Value is the Value record as is, including its TAG WORD. Its length is set by that TAG.

## Numbers {#수치}

- The verdict value (−1 to 1), Qualifier (0 to 1), and attack strength (0 to 1) are [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md) Values. No separate fixed-point format is provided.
- The encoder strips trailing zeros of the coefficient. 0.8 is `C=8, E=−1`. The decoder accepts up to 4 decimal places.
- A confidence gate (for example, `at least 75%`) is written as a comparison operator 1 WORD and a percent [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md) Value (`E=0`) ([LINK](#link) F_GATE).
- Attack strength is the F_FORCE field of ATTACKS ([LINK](#공격-세기)). A value out of range is rejected.

## Axes of node declaration {#노드-선언의-축}

- A node declaration (RULE-, COUNTER-, EXCEPT-DECLARE) has a role (claim, rebuttal, exception), a Qualifier (0 to 1), and a Level (Unset, Fail, Review). The role is held by the Codec and the role of the NODE header, the Qualifier by F_QUAL, and the Level by the level of the header ([NODE](#node)).
- Strength (Strict, Defeasible, Defeater) is a separate axis from the role. The placement of strength is not decided yet.
- Attack strength (Force) is a value of the ATTACKS edge, not of a node ([LINK](#공격-세기) F_FORCE). It is a different axis from strength.

## Judging on the unknown {#미상-위에서-판정하기}

When a judgment graph takes GEUL facts as input, the three concepts of the [slot marker](../slot-marker.md) (not written, unknown, none) are evaluated differently. The evaluation of the comparison operators of [EXPR](0x101L-predicate-declare.md) is as follows.

| Input | `is empty` | `is not empty` | `equals` / `is in` / magnitude comparison |
|---|---|---|---|
| value v | false | true | evaluated with v |
| NO-VALUE (none) | **true** | false | false |
| UNKNOWN-VALUE (unknown) | false | **true** | **undetermined (U)** |
| ABSENT (not written) / no description | U (open world) | U | U |

- Logic uses Kleene strong three-valued logic. `NOT U = U`, `false AND U = false`, `true OR U = true`. Any other combination with U is U.
- `EXISTS any` is true if any element is true. If there is no true and there is a U, it is U; if all are false, it is false.
- **If a predicate is U, the verdict of that node is not Pass or Fail but Review.** What is not known is handed to a person (or the next stage).
- To read ABSENT as empty rather than U, the input side must **declare** a closed world (injected as the criterion SPEC, for example "the input of this case is complete"). Without the declaration, it is U.
- This table and the U → Review mapping are the meaning of judgment, so they are a **fixed core**. They cannot be changed by a TOULMIN document.
- Example: a rule that "counts only borders still valid today" (`P582 is empty`) excludes it as false if P582 = UNKNOWN-VALUE, includes it as true if P582 = NO-VALUE, and sends it to Review as U if P582 is absent.

## Judgment results {#판정-결과}

- A judgment result (`VERDICT`, `EVIDENCE`) is kept in a document different from the one being judged. The result document imports the target document with [IMPORT-DOC](../meta/0x1E4L-import-doc.md) and points to it with [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md). So judging does not change the content hash of the target document.
- The verdict of a whole document is Meta `VERDICT`; the verdict of a node or record is TOULMIN `VERDICT`.
- Rules that choose the version of a revision to apply (transitional provisions, choosing between the law at the time of the act and the new law), as well as interpretive precedents and case law, are also used as judgment rules ([Document](../document.md#개정)).

## Open problems {#열린-문제}

- The layouts of SUPERSEDE-CHAIN (`0x10AL`), VERDICT (`0x118L`), and EVIDENCE (`0x119L`). Whether the current way of writing SUPERSEDES one pair at a time is enough for a chain.
- The placement of node strength (Strict, Defeasible, Defeater).
- An ATTACKS that states attack strength 1 and an ATTACKS that does not have the same verdict but different bytes. Whether the verdicts are the same must be compared by interpreted value, not by bytes.
- The node count, label count, and label index in EXPR are 1 WORD, and the child count is 13 bits. The upper limits are fixed.
- The PROVENANCE (rule source and premise) layout.
- Whether to place a backtick name as a statement [LABEL](../edge/0x0A4L-label.md) or [BIND](../edge/0x0A3L-bind.md) instead of TEXT + LABEL (`0x134L`).
- The code value tables for the predicate and mode of Claim and for the VerbCode of FuncRef.
- Whether a closed-world declaration (reading ABSENT as empty) is made per criterion (SPEC) or per case.
- The [Codec spec document](../codec-spec.md) of the TOULMIN Codecs. The conditional fields of NODE and LINK and the SPAN width set by SOURCE make layouts that cannot be declared with FIELD.

## Related pages {#관련-페이지}

- [NODE](#node), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [Source and sections](#source와-구획)
- [Document](../document.md), [PROFILE](../meta/0x1C6L-profile.md)

## NODE {#node}

NODE is the layout that writes the nodes of a TOULMIN judgment and execution graph. The node kind is set by the Codec, and a 1 WORD header sets the role, Level, Claim form, and conditional fields.

### Codec {#codec}

| Codec | Name | TANGEUL | Node |
|---|---|---|---|
| `0x100L` | [CASE-DECLARE](0x100L-case-declare.md) | `in case of` | case |
| `0x102L` | [SPEC-DECLARE](0x102L-spec-declare.md) | Definitions item (`means`, `has`) | criterion (Backing). The role is the kind of definition |
| `0x103L` | [RULE-DECLARE](0x103L-rule-declare.md) | general rule | claim (Warrant) |
| `0x104L` | [COUNTER-DECLARE](0x104L-counter-declare.md) | counter rule | rebuttal (Rebuttal) |
| `0x105L` | [EXCEPT-DECLARE](0x105L-except-declare.md) | except rule | exception (Defeater) |
| `0x115L` | [ENTRY](0x115L-entry.md) | `provides x` | external entry point |
| `0x116L` | [TRIGGER](0x116L-trigger.md) | `on`, `every`, `until` | event or periodic entry point |
| `0x126L` | [NAMESPACE](0x126L-namespace.md) | `this document is` | document namespace |
| `0x127L` | [FUNC](0x127L-func.md) | function reference | outside function (for example, `bank.withdraw`) |
| `0x128L` | [FIELD](0x128L-field.md) | `x is required [as Type]` | required field |
| `0x129L` | [ALIAS](0x129L-alias.md) | `see a from path` | alias of an imported package |
| `0x12AL` | [GROUP](0x12AL-group.md) | `1.` ordered list | ordered execution group |

`0x126L~0x12AL` are direct codes of the Edge TOULMIN format family ([TOULMIN format](#toulmin-형식)).

### Layout {#레이아웃}

```
ID               LOCAL Reference record (Edge Id)
header 1 WORD    role 2b | Reserved 2b | F_GROUNDS 1b | level 2b | object kind 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 0 if none) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF(case)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value. Initial verdict value
[F_WITH]         count (UNSIGNED-INTEGER Value) + REF(TEXT) × count
[F_GROUNDS]      count (UNSIGNED-INTEGER Value) + REF(TEXT) × count
SPAN             width set by SOURCE × 2 (start byte, byte count)
```

#### Header WORD {#헤더-word}

| Bits | Field | Value |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | Reserved | 0 |
| 11 | F_GROUNDS | a grounds list is present |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 Reserved) |
| 8–7 | object kind | The form of the Claim object. 0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | table below |

| Bit | flag | Meaning |
|---|---|---|
| b0 | F_FUNC | a FuncRef field is present |
| b1 | F_QUAL | a Qualifier field is present |
| b2 | F_CHECK | a field for the case that `checking` targets is present |
| b3 | F_CLAIM | a Claim field is present |
| b4 | F_VERDICT | an initial verdict value field is present |
| b5 | F_STRIKE | a declaration crossed out with strikethrough. It has no fields |
| b6 | F_WITH | a criteria list field is present |

- Conditional fields are placed in flag order (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). A field whose flag is off takes no space.
- If a flag is on but the field is missing, the record is rejected. The position after reading the fields in order must match the end of the record exactly after the SPAN.

### Fields {#필드}

| Field | Description |
|---|---|
| FuncRef | The function slot. REF is the ALIAS record from which the function was imported, and is `0` for a function of this document. VerbCode is a 1 WORD code and is not assigned yet (`0x0000` is allowed). The source notation of the function is written separately as TEXT + [LABEL](#link) |
| Qualifier | The confidence of the node (0 to 1) |
| case | F_CHECK: the case that this node only judges (`checking c`) |
| Claim | The proposition the node holds. Subject REF, predicate 1 WORD, object, mode 1 WORD. The form of the object is set by the object kind of the header |
| verdict value | The initial verdict value (−1 to 1) |
| F_WITH | The criteria at declaration time (`with`). A list of TEXT record REFs |
| F_GROUNDS | Names of external facts resolved at evaluation time (`grounds`). A list of TEXT record REFs |
| SPAN | The range of the source text where this declaration appears |

- The notation of verdict values and Qualifier follows the numeric rules of [TOULMIN](#수치).
- The count of a list is an embedded [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md) Value record.
- The default form of a descriptive Claim has subject and predicate `0` and the object as a SPAN (object kind 2). It is fixed to the source notation.

### Interpretation and validity {#해석과-유효성}

- For RULE-, COUNTER-, and EXCEPT-DECLARE, the role must equal the Codec (0 general, 1 counter, 2 except). For SPEC-DECLARE it is the kind of definition. For any other Codec it is 0.
- If level is 0 (Unset), the engine default is used: Fail for COUNTER-DECLARE, Review for EXCEPT-DECLARE.
- A host-function rule of TANGEUL `tangl:rule` (`is a rule that uses`) is written as a RULE-DECLARE NODE outside a case. The function is F_FUNC, the criterion is F_WITH, and the grounds are F_GROUNDS. Only a condition expression rule has a [PREDICATE-DECLARE](0x101L-predicate-declare.md) before it.
- Reserved bits (13–12) must be 0. If a Reserved bit is on, or the role does not match the Codec, the record is rejected.

### Related pages {#관련-페이지-1}

- [TOULMIN](_index.md), [LINK](#link), [EXPR](0x101L-predicate-declare.md), [Source and sections](#source와-구획)
- [LOCAL](../reference/0x005L-local.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## LINK {#link}

LINK is the layout that writes the relations between nodes in a TOULMIN graph. The Codec sets the kind of relation.

### Codec {#codec-1}

| Codec | Name | TANGEUL | src → dst |
|---|---|---|---|
| `0x108L` | [ATTACKS](0x108L-attacks.md) | `don't X when Y` | rule → rule. Gradually reduces the verdict by the attack strength |
| `0x109L` | [SUPERSEDES](0x109L-supersedes.md) | `X supersedes Y` | rule → rule. If Active, removes the target from the aggregation |
| `0x110L` | [RUN](0x110L-run.md) | `run c when n` | rule → case |
| `0x111L` | [DO](0x111L-do.md) | `do fn when n` | rule → FuncRef |
| `0x112L` | [DO-ONCE](0x112L-do-once.md) | `do fn once when n` | rule → FuncRef |
| `0x113L` | [UNDO](0x113L-undo.md) | `undo fn when n` | rule → FuncRef |
| `0x114L` | [CHECKING](0x114L-checking.md) | `checking c` | rule → case. A judgment without side effects |
| `0x12BL` | [REQUIRES](0x12BL-requires.md) | `f is required` | case → field |
| `0x12CL` | [MEANS](0x12CL-means.md) | Definitions `means` | definition item → value or type |
| `0x12DL` | [HAS](0x12DL-has.md) | Definitions `has` | definition item → field |
| `0x12EL` | [RUNS](0x12EL-runs.md) | entry point `run c` | entry point → case (run) |
| `0x12FL` | [EVALUATES](0x12FL-evaluates.md) | entry point `check c` | entry point → case (judge) |
| `0x130L` | [TRIGGERS](0x130L-triggers.md) | trigger `run c` | trigger → case |
| `0x131L` | [UNTIL](0x131L-until.md) | `every … until c` | trigger → case |
| `0x132L` | [SAME-AS](0x132L-same-as.md) | | node → global identifier |
| `0x133L` | [IMPORTED-FROM](0x133L-imported-from.md) | `see a from path` | alias → path (TEXT) |
| `0x134L` | [LABEL](0x134L-label.md) | backtick name | node → TEXT. Name notation |

### Layout {#레이아웃-1}

```
ID               LOCAL Reference record (Edge Id)
src              REF
dst              REF. FuncRef for DO, DO-ONCE, and UNDO
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         operator 1 WORD (top 2 bits) + UNSIGNED-DECIMAL Value (percent)
[F_FORCE]        SIGNED-DECIMAL Value. Attack strength (0 to 1). ATTACKS only
SPAN             width set by SOURCE × 2
```

| flag | Meaning |
|---|---|
| b0 F_ONCE | performed only once (the `once` of UNDO) |
| b1 F_GATE | a confidence gate field is present |
| b2 F_STRIKE | a relation crossed out with strikethrough |
| b3 F_ORDERED | belongs to a `1.` ordered list |
| b4 F_FORCE | an attack strength field is present. ATTACKS only |

| Gate operator | Meaning |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Conditional fields are placed in flag order (F_GATE, F_FORCE). A field whose flag is off takes no space.

### Attack strength {#공격-세기}

Attack strength (F_FORCE) is used only by [ATTACKS](0x108L-attacks.md#공격-세기). The verdict formula, notation, and example are on that page.

### Interpretation and validity {#해석과-유효성-1}

- REF is the Edge Id of a record in this document (common fields of [TOULMIN](#공통-필드)).
- The form of dst is set by the Codec. DO, DO-ONCE, and UNDO use a FuncRef (REF(ALIAS, 0 if none) + VerbCode 1 WORD, [NODE](#필드)); LABEL and IMPORTED-FROM use the REF of a TEXT record; the rest use the REF of a node.
- `do … once` is represented by the DO-ONCE Codec. F_ONCE is not used in the flags of DO-ONCE (it is rejected if turned on). The `once` of UNDO is written as F_ONCE.
- The gate operator is the top 2 bits of the operator WORD, and the remaining 14 bits are 0. The percent is an UNSIGNED-DECIMAL Value with `E=0`, from 0 to 100.
- Bits b5 to b15 of flags are Reserved and must be 0. Otherwise the record is rejected.
- F_FORCE is used only by ATTACKS. If it is on in any other Codec (SUPERSEDES, execution and judgment links, TOULMIN format relations), the record is rejected.
- If the attack strength is not a SIGNED-DECIMAL Value, is outside 0 to 1, or cannot be represented exactly in 4 decimal places, the record is rejected.
- A SUPERSEDES chain `A > B > C` writes one SUPERSEDES per pair.

### Related pages {#관련-페이지-2}

- [TOULMIN](_index.md), [NODE](#node), [Source and sections](#source와-구획)
- [UNSIGNED-DECIMAL](../value/0x069L-unsigned-decimal.md), [SIGNED-DECIMAL](../value/0x068L-signed-decimal.md)

## Source and sections {#source와-구획}

Records that write the source text and the sections of a TOULMIN document. All are direct codes `0x120L~0x125L` of the Edge TOULMIN format family ([TOULMIN format](#toulmin-형식)). There is no Issuer or Codec number slot, and the Payload follows the TAG.

### Formats {#형식}

| Codec | Name | Layout |
|---|---|---|
| `0x120L` | [SOURCE](0x120L-source.md) | ID, SPAN width WORD, UTF8 Value |
| `0x121L` | [TEXT](0x121L-text.md) | ID, UTF8 Value |
| `0x122L` | [SECTION](0x122L-section.md) | ID, section code 1 WORD |
| `0x123L` | [CASE-BEGIN](0x123L-case-begin.md) | ID, REF (case) |
| `0x124L` | [CASE-END](0x124L-case-end.md) | ID, REF (case) |
| `0x125L` | [PROSE](0x125L-prose.md) | ID, SPAN |

- ID is the Edge Id, and REF is the Edge Id of a record in this document (common fields of [TOULMIN](#공통-필드)).
- A UTF8 Value is a [UTF8-TEXT](../value/0x072L-utf8-text.md) Value record. It holds the bytes as is.

### Pages by format {#형식별-쪽}

Each format has its own page for the layout, the section code table, and the interpretation.

- [SOURCE](0x120L-source.md): authoring source text. The first record of the BODY, and it sets the SPAN width
- [TEXT](0x121L-text.md): name or string
- [SECTION](0x122L-section.md): section start and section code
- [CASE-BEGIN](0x123L-case-begin.md), [CASE-END](0x124L-case-end.md): case scope
- [PROSE](0x125L-prose.md): descriptive paragraph

### Related pages {#관련-페이지-3}

- [TOULMIN](_index.md), [NODE](#node), [LINK](#link)
