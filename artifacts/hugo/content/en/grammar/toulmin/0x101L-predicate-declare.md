---
title: "PREDICATE-DECLARE (0x101L)"
weight: 257
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PREDICATE-DECLARE is the TOULMIN Codec that declares a predicate (a judgment expression)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PREDICATE-DECLARE is the TOULMIN Codec that declares a predicate (a judgment expression). Its layout is EXPR. EXPR is the layout that writes the condition expressions of TANGEUL Rules. It lays out the condition expression tree in preorder, and strings inside an expression are referenced through a label table in the record. So it is self-contained, with no TEXT record.

| Item | Value |
|---|---|
| Name | `PREDICATE-DECLARE` (spec document BIND `PREDICATE-DECLARE`) |
| TAG ID | `0x101L` |
| Codec ID | `0x00001010` |
| Spec document | `0x00000000/codecs/0x00001010/` (DECLARE target `1010`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 1 |
| Kind | Edge · family: TOULMIN, group: declaration, layout: EXPR |
| TAG WORD | `0001 0000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Predicate declaration. Judgment function and expression, criterion (Spec), fact contract (Ground) |
| Hugo page | `edge/toulmin/expr.md` |

## Layout {#레이아웃}

```
ID                     LOCAL Reference record (Edge Id)
node count 1 WORD      total number of expression records
label count 1 WORD
label × label count    UTF8-TEXT Value record
expression record × node count      preorder
```

- A label is a string such as a field name, a string value, a path step, or a function name. An empty string is also a label. An expression record refers to a label by an index (1 WORD) numbered from 0.
- An expression record places its children in order after its parent (preorder). The child count of each record and this order fix the tree uniquely.

## Expression record {#식-레코드}

An expression record starts with a 1 WORD header.

```
header 1 WORD      kind low 2 bits (b15–14) | kind high 1 bit (b13) | child count 13 bits (b12–0)
```

Kind = `(b13 << 2) | b15–14`.

| Kind | Name | Child count | After the header |
|---|---|---|---|
| 0 | COMPARE | 0 | comparison operator 1 WORD, field label 1 WORD, value slot |
| 1 | LOGIC | n | logical operator 1 WORD |
| 2 | NOT | 1 | none |
| 3 | EITHER | n | none |
| 4 | EXISTS | 1 | quantifier operator 1 WORD, target operand, binding name label 1 WORD |
| 5 | CALL | 0 | alias label 1 WORD, function name label 1 WORD |
| 6 | COMPARE-X | 0 | comparison operator 1 WORD, field label 1 WORD, left marker 1 WORD [+ operand], value slot |
| 7 | Reserved | | |

- Child records follow the fields after the header. The child of EXISTS is one condition.
- COMPARE is a comparison `<field> <operator> <value>` with no operand on either side. If either side has an operand, use COMPARE-X.
- If the left marker of COMPARE-X is `1`, an operand follows; if `0`, none. If a left operand is present, the field label is an empty string.
- CALL is a host function call in predicate position. If the function belongs to this document, the alias label is an empty string.

### Value slot {#값-자리}

```
value kind 1 WORD    0 number, 1 string, 2 operand
value                0: UNSIGNED-INTEGER Value record
                     1: label 1 WORD
                     2: operand (COMPARE-X only)
```

- If the value string is exactly the canonical decimal notation of a non-negative integer, it is written as an UNSIGNED-INTEGER Value. Any other value is written as a label. So the value string is restored exactly.

### Operand {#피연산자}

```
operand kind 1 WORD    0 path, 1 criterion reference, 2 function call
path, criterion reference    step count 1 WORD + label 1 WORD × step count
function call          alias label 1 WORD + function name label 1 WORD
```

- A path is a path into the input data; a criterion reference is a path into the criterion (SPEC) injected with `with`.

### Operator codes {#연산자-코드}

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

| Code | Logical operator |
|---|---|
| `0x0311` | and |
| `0x0312` | or |

| Code | Quantifier operator |
|---|---|
| `0x0321` | any |

### Evaluation of unknown input {#미상-입력의-평가}

Comparison operators evaluate to three values (true, false, undetermined U) when the input is a slot marker. For NO-VALUE, `is empty` is true and the other comparisons are false. For UNKNOWN-VALUE, `is not empty` is true, and `equals`, `is in`, and magnitude comparisons are U. For ABSENT and no description, every operator is U. Logical operators follow Kleene strong three-valued logic, and when a predicate is U, the node verdict is Review. This evaluation is a fixed core ([TOULMIN](_index.md#미상-위에서-판정하기)).

## Interpretation and validity {#해석과-유효성}

- The node count must equal the number of expanded expression records. The position after reading the last expression record must match the end of the record exactly.
- A label index greater than or equal to the label count is rejected.
- The child count of NOT and EXISTS must be 1.
- An unknown kind (7), or an unknown value kind or operand kind, is rejected.
- The child count is 13 bits (at most 8191).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1010`). In the EXPR layout, the preceding raw values (node count, label count) set the repetition counts and cannot be declared with FIELD, so the field declaration is an open problem (same as the repetition in [DECLARE](../edge/0x0BBL-declare.md#열린-문제)).

## Related pages {#관련-페이지}

- [TOULMIN](_index.md), [NODE](_index.md#node)
- [UTF8-TEXT](../value/0x072L-utf8-text.md), [UNSIGNED-INTEGER](../value/0x062L-unsigned-integer.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001010/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000101000000000
BODY
#1 DECLARE 0x1010
#2 BIND #1 "PREDICATE-DECLARE"
```
