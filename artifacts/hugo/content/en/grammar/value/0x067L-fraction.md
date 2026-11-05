---
title: "FRACTION (0x067L)"
weight: 103
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION is a Value that represents a fraction exactly as it is written in the source."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Item | Value |
|---|---|
| Name | `FRACTION` (spec document BIND `FRACTION`) |
| TAG ID | `0x067L` |
| Codec ID | `0x00000670` |
| Spec document | `0x00000000/codecs/0x00000670/` (DECLARE target `0670`) |
| Section | 3 `0011` (Value), offset C within the section = 7 |
| Kind | Value · family: NUMERIC |
| TAG WORD | `0000 0110 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | A fraction that preserves the original notation: integer or decimal numerator, unsigned integer or decimal denominator. Not reduced |
| Hugo side | `value/numeric/fraction.md` |

## Fields (spec document) {#필드-규격-문서}

The order of FIELDs in the document is the order of the Payload fields ([Codec spec document](../codec-spec.md)).

| Order | Field (BIND) | FIELD | Width | Receiving format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `numerator` | #2 | record | `0610` SIGNED-INTEGER, `0680` SIGNED-DECIMAL |  |
| 2 | `denominator` | #3 | record | `0620` UNSIGNED-INTEGER, `0690` UNSIGNED-DECIMAL |  |

FRACTION is a Value that represents a fraction exactly as it is written in the source. Its direct Value code is `0x067L`, family NUMERIC. The numerator and denominator are each a complete Value record. It is not reduced. It holds fractions where the record is the fraction exactly as written, such as "two thirds" or "5 per 100" in a statute, and the fractional share `23.45/1256.1` in a property registry.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0111 LLLL      Codec 0x067L
[Length extension TAG] when the total is 15 WORD or more
numerator         one Value record: SIGNED-INTEGER or SIGNED-DECIMAL
denominator       one Value record: UNSIGNED-INTEGER or UNSIGNED-DECIMAL
```

## Interpretation and validity {#해석과-유효성}

- numerator is exactly one [SIGNED-INTEGER](0x061L-signed-integer.md) (`0x061L`) or [SIGNED-DECIMAL](0x068L-signed-decimal.md) (`0x068L`) record.
- denominator is exactly one [UNSIGNED-INTEGER](0x062L-unsigned-integer.md) (`0x062L`) or [UNSIGNED-DECIMAL](0x069L-unsigned-decimal.md) (`0x069L`) record.
- It is a closed list. Other Values, FRACTION itself (no nesting), and slot markers (`0x0000`, etc.) are not accepted.
- The two records each carry their own length, so the boundary is not written separately. The cursor that has read the two records must match the end of the Payload exactly.
- The inner records also follow the canonical form of each Codec (integers and coefficients use the minimum WORD). If any inner record is non-canonical, the whole FRACTION is invalid.
- The value is `numerator / denominator`.

### Notation preservation {#표기-보존}

- **Integer and decimal**: if a component of the source is an integer (no decimal point), an INTEGER record is used; if it has a decimal point, a DECIMAL record is used. Writing a component as a DECIMAL with exponent `E = 0` is invalid. So the same notation has a single byte sequence.
- C and E of a DECIMAL component are the digits of the source as is. `23.450` is `23450×10^-3` and a different Value from `23.45`.
- **It is not reduced.** `2/4` and "5 per 100" (`5/100`) are written as they are. If the bytes are the same, the source notation is the same.
- A fraction whose denominator is 1 (`3/1`) is also written as is if the source wrote it that way. If the source is an integer, an integer Codec is used instead of FRACTION. If the source is a decimal (`0.5`, `5%`), DECIMAL is used.
- The sign is placed only on the numerator. The denominator is an unsigned Codec.
- If the value of the denominator is 0, it is invalid (both `0` and `0.0`).

### Comparison {#비교}

- The comparison layer computes FRACTION as the exact rational number `(C1 × 10^E1) / (C2 × 10^E2)` (an INTEGER component has `E = 0`). It does not approximate with floating point.
- Comparison, sorting, and duplicate detection use this value, while storage, signing, and content hashing use the notation (bytes). `2/4`, `1/2`, and `0.5` have the same value and different bytes.
- A quorum check ("at least two thirds of the voting rights of the shareholders present") compares with this exact value.

## Length {#길이}

- The total is TAG 1 WORD + (Length extension TAG) + two records. An integer record is TAG 1 + Payload 1 WORD or more, and a decimal record is TAG 1 + exponent 2 + coefficient 1 WORD or more.
- A small integer fraction is 5 WORD, and a small decimal fraction is 9 WORD. At 15 WORD or more, the extended length is used ([Record and TAG WORD](../record.md)).

| Source | Components | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Examples {#예시}

`2/3`:

```
0674 0611 0002 0621 0003
```

- TAG `0674` (Codec `0x067L`, 5 WORD), numerator `0611 0002` (SIGNED-INTEGER 2), denominator `0621 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0678 0683 FFFF FFFE 0929 0693 FFFF FFFF 3111
```

- TAG `0678` (9 WORD), numerator `0683 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0693 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Relation to other formats {#다른-형식과의-관계}

- amount, lower, and upper of [QUANTITY](0x066L-quantity.md) accept FRACTION. "Two thirds of the voting rights present" can be written as a unitless QUANTITY with amount `2/3`.
- The geul.org spec document `0x00000000/codecs/0x00000670` describes two record fields: numerator (`0610`, `0680`) and denominator (`0620`, `0690`) ([Codec spec document](../codec-spec.md)).
- If a fixed int64 fraction that enforces reduction is needed, use the Issuer format [RATIONAL-I64](adhoc.geul.org/rational-i64.md).

## Open problems {#열린-문제}

1. Notation preservation of mixed numbers (`1 and 2/3`).
2. A format that holds a fraction whose components have units (area/area) as two QUANTITYs. FRACTION does not hold units.
3. The notation criterion for whether to place percent and per mille (`5%`, `5‰`) as DECIMAL with a unit, or as FRACTION (`5/100`).
4. Complex fractions (FRACTION in the numerator or denominator). Forbidden for now.

## Related pages {#관련-페이지}

- [Value](_index.md), [QUANTITY](0x066L-quantity.md), [SIGNED-INTEGER](0x061L-signed-integer.md), [SIGNED-DECIMAL](0x068L-signed-decimal.md), [RATIONAL-I64](adhoc.geul.org/rational-i64.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00000670/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000067000000000
BODY
#1 DECLARE 0x0670
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "FRACTION"
#5 BIND #2 "numerator"
#6 BIND #3 "denominator"
#7 CODEC #2 0x0610
#8 CODEC #2 0x0680
#9 CODEC #3 0x0620
#10 CODEC #3 0x0690
```
