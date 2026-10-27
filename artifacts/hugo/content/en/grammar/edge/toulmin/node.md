---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE is the layout that writes the nodes of a TOULMIN graph (case, rule, definition, entry point, trigger, function, field, alias, group). The flags of a 1 WORD header set the conditional fields that follow."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE is the layout that writes the nodes of a TOULMIN judgment and execution graph. The node kind is set by the Codec (or the GEUL ISSUER format number), and a 1 WORD header sets the role, Level, Claim form, and conditional fields.

## Codec

| Codec | Name | TANGEUL | Node |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | case |
| `0x62` | SPEC-DECLARE | Definitions item (`means`, `has`) | criterion (Backing). The role is the kind of definition |
| `0x63` | RULE-DECLARE | general rule | claim (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | rebuttal (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | exception (Defeater) |
| `0x75` | ENTRY | `provides x` | external entry point |
| `0x76` | TRIGGER | `on`, `every`, `until` | event or periodic entry point |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | document namespace |
| ISSUER `0x0000`/`0xC011` | FUNC | function reference | outside function (for example, `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | required field |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | alias of an imported package |
| ISSUER `0x0000`/`0xC014` | GROUP | `1.` ordered list | ordered execution group |

After `ISSUER-1WORD` (`0x7C`), the Codec extension TAG of an ISSUER format holds the Issuer `0x0000` and the format number ([TOULMIN](/grammar/edge/toulmin/)).

## Layout

```
ID               LOCAL Reference record (Edge Id)
header 1 WORD    role 2b | reserved 2b | F_GROUNDS 1b | level 2b | object kind 2b | flags 7b
[F_FUNC]         FuncRef: REF(ALIAS, 0 if none) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL Value. Qualifier
[F_CHECK]        REF(case)
[F_CLAIM]        Claim: REF(subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL Value. Initial judgment value
[F_WITH]         count (UNSIGNED-INTEGER Value) + REF(TEXT) × count
[F_GROUNDS]      count (UNSIGNED-INTEGER Value) + REF(TEXT) × count
SPAN             width set by SOURCE × 2 (start byte, byte count)
```

### Header WORD

| Bits | Field | Value |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | reserved | 0 |
| 11 | F_GROUNDS | A grounds list is present |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 reserved) |
| 8–7 | object kind | The form of the Claim object. 0 REF, 1 UNSIGNED-INTEGER Value, 2 SPAN |
| 6–0 | flags | table below |

| Bit | flag | Meaning |
|---|---|---|
| b0 | F_FUNC | A FuncRef field is present |
| b1 | F_QUAL | A Qualifier field is present |
| b2 | F_CHECK | A `checking` target case field is present |
| b3 | F_CLAIM | A Claim field is present |
| b4 | F_VERDICT | An initial judgment value field is present |
| b5 | F_STRIKE | A declaration struck out with strikethrough. There are no fields |
| b6 | F_WITH | A criteria list field is present |

- Conditional fields are placed in flag order (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). A field whose flag is off takes no position.
- If a flag is on but the field is missing, reject. The position after reading the fields in order must match the end of the record exactly after the SPAN.

## Fields

| Field | Description |
|---|---|
| FuncRef | The function position. REF is the ALIAS record that imported that function, and `0` for a function of this document. VerbCode is a 1 WORD code and is not yet assigned (`0x0000` allowed). The original notation of the function is written separately with TEXT + [LABEL](/grammar/edge/toulmin/link/) |
| Qualifier | The node's confidence (0 to 1) |
| case | F_CHECK: the case this node only judges (`checking c`) |
| Claim | The proposition the node holds. subject REF, predicate 1 WORD, object, mode 1 WORD. The form of the object is set by the object kind in the header |
| judgment value | The initial judgment value (−1 to 1) |
| F_WITH | The criteria at declaration time (`기준으로 하는`, "based on"). A list of TEXT record REFs |
| F_GROUNDS | Names of outside facts interpreted at evaluation time (`근거로 하는`, "grounded on"). A list of TEXT record REFs |
| SPAN | The range of the source text this declaration came from |

- The notation of the judgment value and Qualifier follows the [numeric rules](/grammar/edge/toulmin/#numbers) of TOULMIN.
- The count of a list is an embedded [UNSIGNED-INTEGER](/grammar/value/numeric/unsigned-integer/) Value record.
- The basic form of a descriptive Claim has subject and predicate `0` and object as a SPAN (object kind 2). It is fixed to the original notation.

## Interpretation and Validity

- For RULE-, COUNTER-, and EXCEPT-DECLARE, the role must equal the Codec (0 general, 1 counter, 2 except). For SPEC-DECLARE, it is the kind of definition. For other Codecs, it is 0.
- If level is 0 (Unset), the engine default is used: Fail for COUNTER-DECLARE, Review for EXCEPT-DECLARE.
- The host function rule of TANGEUL `tangl:규칙` ("rule") (`쓰는 규칙이다`, "is a rule that uses") is written as a RULE-DECLARE NODE outside a case. The function is F_FUNC, the criteria are F_WITH, and the grounds are F_GROUNDS. Only a condition-expression rule has a [PREDICATE-DECLARE](/grammar/edge/toulmin/expr/) in front.
- Reserved bits (13–12) must be 0. If a reserved bit is on, or the role does not match the Codec, reject.

## Related Pages

- [TOULMIN](/grammar/edge/toulmin/), [LINK](/grammar/edge/toulmin/link/), [EXPR](/grammar/edge/toulmin/expr/), [SOURCE and Sections](/grammar/edge/toulmin/source/)
- [LOCAL](/grammar/reference/local/), [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/)
