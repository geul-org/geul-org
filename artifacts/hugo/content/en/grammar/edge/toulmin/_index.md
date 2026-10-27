---
title: "TOULMIN"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "TOULMIN Edges (Codec 0x60-0x7B) write judgment and execution graphs with the Toulmin model of argument. This page sets the TOULMIN document rules, common fields, code table, numeric rules, and the fixed core of self-revision."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The TOULMIN family of Edges (upper 2 bits of the Codec `11`, direct codes `0x60`-`0x7B`) writes judgment and execution graphs with the Toulmin model of argument. Declarations of claims, rebuttals, and exceptions, attack and override relations, execution links, and judgment results are all Edges. One TANGEUL document (the rule language of the toulmin engine) becomes one GEUL document. The file extension is `.geul`, the same as other documents.

What this page does not set follows the common rules of [Edge](/grammar/edge/) and [Records and the TAG WORD](/grammar/record/).

## Metacognition and Self-Revision

TOULMIN is a GEUL Codec so that GEUL can be metacognitive about itself. Only if the judgment and execution rules are also described in GEUL can TOULMIN take those rules as its object and correct them itself. So TOULMIN is not an application profile but the core of GEUL operation, and it is placed in the Edge direct-code space (`0x60`-`0x7B`).

- Self-description makes self-improvement possible but risks a circular error. If a rule judges its own revision, a revision that loosens the judgment criteria can also pass (the pass rate rises while the real accuracy falls).
- The circularity is accepted as a risk but cut by structure.
  - **Fixed core**: the meaning of judgment (Pass, Review, Fail; attack, override, priority; the 3-valued evaluation and U → Review in [Judging over Unknown](#judging-over-unknown) below) is fixed in this specification. It cannot be changed by a TOULMIN document. It is in the same place as the rules built into the decoder (Layer 0 in [Publication Addresses and Version Lists](/grammar/publishing/#layers)).
  - **Edition separation**: the revision of rule document v(n) is judged by the v(n−1) rules and an external check. A rule does not judge itself. The judgment result is placed in a document different from the target (so the target's content hash does not change).
  - **Immutable history**: revisions accumulate as new versions (`PARENT`, content hash, signature). Old versions remain, so a circular error can be found afterward and reverted. The safety net for self-revision is GEUL's edition model ([Document](/grammar/document/#revisions)).
  - **External criterion**: a set of test cases that the revision path cannot touch is kept separately. The adoption of a revision is confirmed by the result on this set.
- Falsification test: plant one rule that is deliberately wrong. If the system corrects it and the external criterion score rises, self-improvement is working. If only the pass rate rises and the external criterion score falls, it is a circular error.

## Codes

A TOULMIN record uses one of three layouts. The layout is set by the Codec (or format number).

| Layout | Use | Page |
|---|---|---|
| NODE | Graph nodes such as cases, rules, definitions, entry points | [NODE](/grammar/edge/toulmin/node/) |
| LINK | Relations between nodes (attack, override, execution, definition) | [LINK](/grammar/edge/toulmin/link/) |
| EXPR | Condition expressions (predicates) | [EXPR](/grammar/edge/toulmin/expr/) |

The source text and section records (SOURCE, TEXT, SECTION, CASE-BEGIN and CASE-END, PROSE) are set by [SOURCE and Sections](/grammar/edge/toulmin/source/).

### Direct Codes

| Codec | Name | Layout | TANGEUL | Meaning |
|---|---|---|---|---|
| `0x60` | [CASE-DECLARE](/grammar/edge/toulmin/node/) | NODE | `in case of` | Case declaration. A judgment graph holding nodes and relations |
| `0x61` | [PREDICATE-DECLARE](/grammar/edge/toulmin/expr/) | EXPR | condition expressions in Rules | Predicate declaration. A judgment expression |
| `0x62` | [SPEC-DECLARE](/grammar/edge/toulmin/node/) | NODE | Definitions item | Criterion declaration (Backing). The role bits are the kind of definition |
| `0x63` | [RULE-DECLARE](/grammar/edge/toulmin/node/) | NODE | general rule, rule name in Rules | Claim declaration (Warrant). It can be attacked |
| `0x64` | [COUNTER-DECLARE](/grammar/edge/toulmin/node/) | NODE | counter rule | Rebuttal declaration. Attacks with its own conclusion. The default Level is Fail |
| `0x65` | [EXCEPT-DECLARE](/grammar/edge/toulmin/node/) | NODE | except rule | Exception declaration. Attacks without its own conclusion. The default Level is Review |
| `0x68` | [ATTACKS](/grammar/edge/toulmin/link/) | LINK | `don't X when Y` | Attack relation. The attacker's judgment gradually reduces the target's judgment |
| `0x69` | [SUPERSEDES](/grammar/edge/toulmin/link/) | LINK | `X supersedes Y` | Override relation. If the attacker is Active, it removes the target from aggregation decisively. A chain (`A > B > C`) is written one pair at a time |
| `0x6A` | SUPERSEDE-CHAIN | — | | Priority chain `A > B > C`. An abbreviation of pairwise SUPERSEDES. Only the code is assigned; there is no layout yet |
| `0x70` | [RUN](/grammar/edge/toulmin/link/) | LINK | `run c when n` | Execution composition. If the node is Active, it runs a lower case (DAG) |
| `0x71` | [DO](/grammar/edge/toulmin/link/) | LINK | `do fn when n` | An action performed when the node is Active |
| `0x72` | [DO-ONCE](/grammar/edge/toulmin/link/) | LINK | `do fn once when n` | An action performed only once even on retry |
| `0x73` | [UNDO](/grammar/edge/toulmin/link/) | LINK | `undo fn when n` | The compensating action of a DO (saga). Performed in reverse order if a later step fails |
| `0x74` | [CHECKING](/grammar/edge/toulmin/link/) | LINK | `checking c` | A link that only judges, with no side effects |
| `0x75` | [ENTRY](/grammar/edge/toulmin/node/) | NODE | `provides x` | An external entry point. Runs or judges a case |
| `0x76` | [TRIGGER](/grammar/edge/toulmin/node/) | NODE | `on`, `every`, `until` | An event or periodic entry point with no external call |
| `0x78` | VERDICT | — | | The judgment result of a node or record. Result (Pass, Review, Fail), judgment value, Activated, Excluded, Level. Only the code is assigned; there is no layout yet |
| `0x79` | EVIDENCE | — | | Evidence of a judgment. Position, expected value, actual value (Fact). Only the code is assigned; there is no layout yet |
| `0x7C`-`0x7F` | ISSUER-* | | | Formats defined by an Issuer. See ISSUER Formats below |

- Direct codes not in the table (`0x66` and `0x67`, `0x6B`-`0x6F`, `0x77`, `0x7A` and `0x7B`) are reserved.
- The upper 2 bits of the lower 5 bits of the Codec are the group: `00` declaration, `01` relation, `10` execution, `11` result (`0x7C`-`0x7F` are ISSUER).
- The judgment of the whole document is handled by the Meta [VERDICT](/grammar/meta/verification/verdict/) (`0x44`), and the judgment of a node or record by the TOULMIN `VERDICT` (Edge `0x78`). They are separate Codecs of different Kinds.

### ISSUER Formats

TOULMIN records that do not fit in the direct codes are placed under `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` (GEUL), with a format number. The format numbers are in the TOULMIN family (`0xC000`-`0xFFFF`, upper 2 bits `11`).

```
TAG WORD          0001 0LLL L111 1100      Edge, Codec 0x7C
[Length extension TAG]
Issuer            0x0000
Format number     0xC000-0xC029
Edge Id           LOCAL Reference record
Components        layout set by the format
```

| Format number | Name | Layout | Meaning |
|---|---|---|---|
| `0xC000` | [SOURCE](/grammar/edge/toulmin/source/) | ID, SPAN width WORD, UTF8 Value | Authored source text |
| `0xC001` | [TEXT](/grammar/edge/toulmin/source/) | ID, UTF8 Value | A name or string |
| `0xC002` | [SECTION](/grammar/edge/toulmin/source/) | ID, section code 1 WORD | Start of a section |
| `0xC003` | [CASE-BEGIN](/grammar/edge/toulmin/source/) | ID, REF (case) | Start of a case range |
| `0xC004` | [CASE-END](/grammar/edge/toulmin/source/) | ID, REF (case) | End of a case range |
| `0xC005` | [PROSE](/grammar/edge/toulmin/source/) | ID, SPAN | A prose paragraph |
| `0xC010` | [NAMESPACE](/grammar/edge/toulmin/node/) | NODE | `this document is` |
| `0xC011` | [FUNC](/grammar/edge/toulmin/node/) | NODE | Function reference |
| `0xC012` | [FIELD](/grammar/edge/toulmin/node/) | NODE | `is required` |
| `0xC013` | [ALIAS](/grammar/edge/toulmin/node/) | NODE | `see … from` |
| `0xC014` | [GROUP](/grammar/edge/toulmin/node/) | NODE | An ordered execution group |
| `0xC020` | [REQUIRES](/grammar/edge/toulmin/link/) | LINK | case → field |
| `0xC021` | [MEANS](/grammar/edge/toulmin/link/) | LINK | definition item → value or type |
| `0xC022` | [HAS](/grammar/edge/toulmin/link/) | LINK | definition item → field |
| `0xC023` | [RUNS](/grammar/edge/toulmin/link/) | LINK | entry point → case, run |
| `0xC024` | [EVALUATES](/grammar/edge/toulmin/link/) | LINK | entry point → case, judge |
| `0xC025` | [TRIGGERS](/grammar/edge/toulmin/link/) | LINK | trigger → case |
| `0xC026` | [UNTIL](/grammar/edge/toulmin/link/) | LINK | trigger → case (`every … until`) |
| `0xC027` | [SAME-AS](/grammar/edge/toulmin/link/) | LINK | node → global identifier |
| `0xC028` | [IMPORTED-FROM](/grammar/edge/toulmin/link/) | LINK | alias → path (TEXT) |
| `0xC029` | [LABEL](/grammar/edge/toulmin/link/) | LINK | node → TEXT, a name notation |

- The format number space is separate for each Kind. The Value GEUL format `0xC000` (OPAQUE-BYTES-EVEN) and the Edge `0xC000` (SOURCE) are different formats.
- Format numbers are only added. An assigned number is not reused for another format.

## Document

One `.geul` file is one DOC. No other bytes are placed outside the DOC.

```
DOC-1WORD/2WORD/4WORD     total length
  SPEC-VERSION            0x0001 (v1, an integer with no embedded Value)
  PROFILE                 UTF8 Value "tangeul-<major>.<minor>". Currently "tangeul-1.0"
  [DEFAULT-LANGUAGE]      LANGUAGE-BCP47-CODE Value. The locale it was written in ("en", "ko")
BODY
  SOURCE                  authored source text. The first record of the BODY
  statement records …    in document declaration order
END
```

- HEAD: [SPEC-VERSION](/grammar/meta/declaration/spec-version/), [PROFILE](/grammar/meta/declaration/profile/), and an optional [DEFAULT-LANGUAGE](/grammar/meta/declaration/default-language/).
- A decoder rejects the document if SPEC-VERSION differs or the major of PROFILE differs. It reads the document even if the minor differs.
- The first record of the BODY is SOURCE. Every SPAN is a range within this source text.
- The order of statement records is the same as the document declaration order. The execution order (`do` and `run` firing, `undo` compensation in reverse order) relies on this order. In a TOULMIN document the order of Edges carries meaning (an exception to the order rule in [Edge](/grammar/edge/)).
- Every record of the BODY is an Edge. No independent Value records are placed. Values are embedded in the Edge Payload.
- The identity of a case and importing use the Meta [DOC-ID](/grammar/meta/declaration/doc-id/) and [IMPORT-DOC](/grammar/meta/import/import-doc/) (TANGEUL's Subject and See).

## Common Fields

| Field | Width | Description |
|---|---|---|
| ID | LOCAL Reference record | The Edge Id of the record. The first element of every record's Payload |
| REF | LOCAL Reference record | An Edge Id that points to another record of this document. `0` means none |
| SPAN | width set by SOURCE × 2 | A range within the authored source text. Start byte, byte count |

- ID and REF are embedded [LOCAL](/grammar/reference/local/) Reference records (`0000 0LLL L000 1000` + an ID in the shortest width). The width is set by that record's Length and is not declared per document.
- REF `0` (LOCAL `0`) means "none". This is a Codec rule that uses LOCAL `0` as none ([LOCAL](/grammar/reference/local/)).
- Edge Ids are assigned from 1 and are not duplicated within a document. `0` is "none" for REF, so it is not used as an Edge Id.
- Nodes are forward-referenced by other records, so they receive numbers first, in document declaration order. Other records (SOURCE, TEXT, LINK, FUNC, section records) are assigned by the encoder from the number after the nodes.
- A decoder only checks that an Edge Id is not 0 and has no duplicates. The assignment order is not used for interpretation.
- Nodes and relations are pointed to by Edge Id.
- An embedded Value is a Value record as it is, including the TAG WORD. Its length is set by that TAG.

## Numbers

- Judgment values (−1 to 1) and Qualifiers (0 to 1) are [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/) Values. No separate fixed-point format is placed.
- The encoder strips trailing zeros from the coefficient. 0.8 is `C=8, E=−1`. A decoder accepts up to 4 decimal places.
- A confidence gate (for example, `at least 75%`) is written with a 1 WORD comparison operator and a percent [UNSIGNED-DECIMAL](/grammar/value/decimal/unsigned-decimal/) Value (`E=0`) ([LINK](/grammar/edge/toulmin/link/) F_GATE).

## Axes of Node Declarations

- A node declaration (RULE-, COUNTER-, EXCEPT-DECLARE) has a role (claim, rebuttal, exception), a Qualifier (0 to 1), and a Level (Unset, Fail, Review). The role is held by the Codec and the role of the NODE header, the Qualifier by F_QUAL, and the Level by the level of the header ([NODE](/grammar/edge/toulmin/node/)).
- Strength (Strict, Defeasible, Defeater) is an axis separate from role. Where strength goes is not yet decided.

## Judging over Unknown

When a judgment graph takes GEUL facts as input, the three notions of a [slot marker](/grammar/reference/slot-marker/) (not written, unknown, none) are evaluated differently. The evaluation of the [EXPR](/grammar/edge/toulmin/expr/) comparison operators is as follows.

| Input | `is empty` | `is not empty` | `equals` / `is in` / size comparison |
|---|---|---|---|
| a value v | false | true | evaluated with v |
| NO-VALUE (none) | **true** | false | false |
| UNKNOWN-VALUE (unknown) | false | **true** | **undetermined (U)** |
| ABSENT (not written) / no statement | U (open world) | U | U |

- The logic is Kleene strong 3-valued. `NOT U = U`, `false AND U = false`, `true OR U = true`. The U of the remaining combinations is U.
- `EXISTS any` is true if any one element is true. If there is no true and there is a U, it is U; if all are false, it is false.
- **If a predicate is U, the judgment of that node is Review, not Pass or Fail.** If it is unknown, hand it to a person (or the next stage).
- To read ABSENT as empty rather than U, the input side must **declare** a closed world (injected as a criterion SPEC, for example "the input of this case is complete"). Without the declaration it is U.
- This table and the U → Review correspondence are the meaning of judgment, so they are the **fixed core**. They cannot be changed by a TOULMIN document.
- Example: the rule "count only borders that are still valid" (`P582 is empty`) excludes it when P582 = UNKNOWN-VALUE because it is false, includes it when P582 = NO-VALUE because it is true, and sends it to Review when there is no P582 because it is U.

## Judgment Results

- Judgment results (`VERDICT`, `EVIDENCE`) are placed in a document different from the target of judgment. The result document imports the target document with [IMPORT-DOC](/grammar/meta/import/import-doc/) and points to it with [EXTERNAL-POINTER-*](/grammar/reference/external-pointer/). So judging does not change the content hash of the target document.
- The judgment of the whole document is the Meta `VERDICT`; the judgment of a node or record is the TOULMIN `VERDICT`.
- Rules that choose the applicable edition of a revision (transitional provisions, the choice between the law at the time of the act and a newer law) and interpretive rulings and precedents are also written as judgment rules ([Document](/grammar/document/#revisions)).

## Open Questions

- The layouts of SUPERSEDE-CHAIN (`0x6A`), VERDICT (`0x78`), and EVIDENCE (`0x79`). Whether the current way of writing SUPERSEDES pair by pair is enough for chains.
- Where node strength (Strict, Defeasible, Defeater) goes.
- Within EXPR, the node count and label count, and the label index is 1 WORD while the child count is 13 bits. The upper bounds are fixed.
- The PROVENANCE (rule source, premises) layout.
- Whether to place backtick names as the statement [LABEL](/grammar/edge/label/) and [BIND](/grammar/edge/bind/) instead of TEXT + LABEL (`0xC029`).
- The table of code values for the predicate and mode of a Claim and the VerbCode of a FuncRef.
- Whether the closed-world declaration (reading ABSENT as empty) is made per criterion (SPEC) or per case.
- The [Codec specification document](/grammar/codec-spec/) for TOULMIN Codecs. The conditional fields of NODE and LINK and the SPAN width set by SOURCE are layouts that cannot be declared with FIELD.

## Related Pages

- [NODE](/grammar/edge/toulmin/node/), [LINK](/grammar/edge/toulmin/link/), [EXPR](/grammar/edge/toulmin/expr/), [SOURCE and Sections](/grammar/edge/toulmin/source/)
- [Edge](/grammar/edge/), [Document](/grammar/document/), [PROFILE](/grammar/meta/declaration/profile/)
