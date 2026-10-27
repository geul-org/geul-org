---
title: "EXPR"
weight: 98
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXPR is the condition-expression layout used by PREDICATE-DECLARE (Codec 0x61). It holds a condition-expression tree as expression records laid out in pre-order, with its own label table."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXPR is the layout that writes the condition expressions of TANGEUL Rules. It is used by Codec `0x61` PREDICATE-DECLARE (predicate declaration). It holds the condition-expression tree laid out in pre-order, and strings inside the expression are pointed to through a label table inside the record. So it is self-contained without TEXT records.

## Layout

```
ID                     LOCAL Reference record (Edge Id)
node count 1 WORD      total number of expression records
label count 1 WORD
labels × label count   UTF8-TEXT Value records
expression records × node count    in pre-order
```

- A label is a string such as a field name, a string value, a path step, or a function name. An empty string is also a label. An expression record points to a label with an index (1 WORD) numbered from 0.
- Expression records place the children after the parent in order (pre-order). The child count of each record and this order fix the tree uniquely.

## Expression Records

An expression record starts with a 1 WORD header.

```
header 1 WORD    kind low 2 bits (b15–14) | kind high 1 bit (b13) | child count 13 bits (b12–0)
```

Kind = `(b13 << 2) | b15–14`.

| Kind | Name | Child count | After the header |
|---|---|---|---|
| 0 | COMPARE | 0 | comparison operator 1 WORD, field label 1 WORD, value slot |
| 1 | LOGIC | n | logic operator 1 WORD |
| 2 | NOT | 1 | none |
| 3 | EITHER | n | none |
| 4 | EXISTS | 1 | quantifier operator 1 WORD, target operand, binding name label 1 WORD |
| 5 | CALL | 0 | alias label 1 WORD, function name label 1 WORD |
| 6 | COMPARE-X | 0 | comparison operator 1 WORD, field label 1 WORD, left marker 1 WORD [+ operand], value slot |
| 7 | Reserved | | |

- Child records follow after the fields that come after the header. The child of EXISTS is one condition.
- COMPARE is a comparison `<field> <operator> <value>` with no operand on either side. If there is an operand on either side, COMPARE-X is used.
- If the left marker of COMPARE-X is `1`, an operand follows; if `0`, none. If there is a left operand, the field label is an empty string.
- CALL is a host function call in the predicate position. For a function of this document, the alias label is an empty string.

### Value Slot

```
value kind 1 WORD    0 number, 1 string, 2 operand
value                0: UNSIGNED-INTEGER Value record
                     1: label 1 WORD
                     2: operand (only in COMPARE-X)
```

- If the value string is exactly the canonical decimal notation of a non-negative integer, it is written as an UNSIGNED-INTEGER Value. Any other value is written as a label. So the value string is restored exactly.

### Operands

```
operand kind 1 WORD    0 path, 1 criterion reference, 2 function call
path, criterion ref    step count 1 WORD + label 1 WORD × step count
function call          alias label 1 WORD + function name label 1 WORD
```

- A path is a path into the input data, and a criterion reference is a path into the criterion (SPEC) injected with `with`.

### Operator Codes

| Code | Comparison operator |
|---|---|
| `0x0301` | is empty |
| `0x0302` | is not empty |
| `0x0303` | equals |
| `0x0304` | is in |
| `0x0305` | is greater than |
| `0x0306` | is less than |
| `0x0307` | is at most |
| `0x0308` | is at least |

| Code | Logic operator |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| Code | Quantifier operator |
|---|---|
| `0x0321` | any |

### Evaluation over Unknown Input

When the input is a slot marker, comparison operators are evaluated in 3 values (true, false, undetermined U). For NO-VALUE, `is empty` is true and other comparisons are false. For UNKNOWN-VALUE, `is not empty` is true and `equals`, `is in`, and size comparisons are U. For ABSENT and no statement, every operator is U. Logic operators follow Kleene strong 3-valued logic, and if a predicate is U, the node's judgment is Review. This evaluation is the fixed core ([TOULMIN](/grammar/edge/toulmin/#judging-over-unknown)).

## Interpretation and Validity

- The node count must equal the number of expanded expression records. The position after reading the last expression record must match the end of the record exactly.
- A label index greater than or equal to the label count is rejected.
- The child count of NOT and EXISTS must be 1.
- An unknown kind (7), or an unknown value kind or operand kind, is rejected.
- The child count is 13 bits (up to 8191).

## Related Pages

- [TOULMIN](/grammar/edge/toulmin/), [NODE](/grammar/edge/toulmin/node/)
- [UTF8-TEXT](/grammar/value/text/utf8-text/), [UNSIGNED-INTEGER](/grammar/value/numeric/unsigned-integer/)
