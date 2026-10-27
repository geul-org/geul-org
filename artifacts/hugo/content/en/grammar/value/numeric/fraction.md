---
title: "FRACTION"
weight: 8
date: 2026-10-28T12:00:00+09:00
lastmod: 2026-10-28T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "FRACTION is a fraction Value that holds a numerator (integer or decimal) and a denominator (unsigned integer or decimal) exactly as written in the original, without reducing."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FRACTION is a Value that represents a fraction written in an original text, keeping its notation. It is Value direct code `0x07`, family NUMERIC. The numerator and the denominator are each a complete Value record. It is not reduced. It holds fractions whose written form is itself the record, such as "two-thirds" and "5 per 100" in statutes and the decimal share `23.45/1256.1` in a land register.

## Layout

```
TAG WORD          0000 1LLL L000 0111      Codec 0x07
[Length extension TAG] when the total is 15 WORD or more
numerator         one Value record: SIGNED-INTEGER or SIGNED-DECIMAL
denominator       one Value record: UNSIGNED-INTEGER or UNSIGNED-DECIMAL
```

## Interpretation and Validity

- numerator is exactly one [SIGNED-INTEGER](/grammar/value/numeric/signed-integer/) (`0x01`) or [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/) (`0x10`) record.
- denominator is exactly one [UNSIGNED-INTEGER](/grammar/value/numeric/unsigned-integer/) (`0x02`) or [UNSIGNED-DECIMAL](/grammar/value/decimal/unsigned-decimal/) (`0x11`) record.
- The list is closed. Other Values, FRACTION itself (no nesting), and slot markers (`0x0000` and the like) are not accepted.
- Each of the two records carries its own length, so no boundary is written separately. The cursor after reading the two records must match the end of the Payload exactly.
- The inner records also follow the canonical form of each Codec (minimal WORDs for integers and coefficients). If an inner record is non-canonical, the whole FRACTION is invalid.
- The value is `numerator / denominator`.

### Notation Preservation

- **Integer and decimal**: if a component of the original is an integer (no decimal point), an INTEGER record is used; if it has a decimal point, a DECIMAL record is used. Writing a component as a DECIMAL with exponent `E = 0` is invalid. So one notation has exactly one byte sequence.
- The C and E of a DECIMAL component keep the digits of the original as they are. `23.450` is `23450×10^-3`, a different Value from `23.45`.
- **No reduction.** `2/4` and "5 per 100" (`5/100`) are written as they are. If the bytes are the same, the original notation is the same.
- A fraction with denominator 1 (`3/1`) is also written as it is if the original wrote it so. If the original is an integer, an integer Codec is used instead of FRACTION. If the original is a decimal (`0.5`, `5%`), DECIMAL is used.
- The sign is placed only on the numerator. The denominator uses an unsigned Codec.
- A denominator whose value is 0 is invalid (both `0` and `0.0`).

### Comparison

- The comparison layer computes a FRACTION as the exact rational number `(C1 × 10^E1) / (C2 × 10^E2)` (`E = 0` for an INTEGER component). It does not approximate with floating point.
- Comparison, sorting, and duplicate detection use this value; storage, signatures, and content hashes use the notation (bytes). `2/4`, `1/2`, and `0.5` have the same value and different bytes.
- A quorum test ("at least two-thirds of the voting rights of the shareholders present") is compared with this exact value.

## Length

- The total is TAG 1 WORD + (Length extension TAG) + the two records. An integer record is TAG 1 + Payload of at least 1 WORD, and a decimal record is TAG 1 + exponent 2 + coefficient of at least 1 WORD.
- A small integer fraction is 5 WORD, and a small decimal fraction is 9 WORD. At 15 WORD or more, the extended length is used ([Records and the TAG WORD](/grammar/record/)).

| Original | Components | Total |
|---|---|---|
| `2/3` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `5/100` | INTEGER 2 WORD + INTEGER 2 WORD | 5 WORD |
| `23.45/1256.1` | DECIMAL 4 WORD + DECIMAL 4 WORD | 9 WORD |

## Examples

`2/3`:

```
0A07 0881 0002 0882 0003
```

- TAG `0A07` (Codec `0x07`, 5 WORD), numerator `0881 0002` (SIGNED-INTEGER 2), denominator `0882 0003` (UNSIGNED-INTEGER 3).

`23.45/1256.1`:

```
0C07 0990 FFFF FFFE 0929 0991 FFFF FFFF 3111
```

- TAG `0C07` (9 WORD), numerator `0990 FFFF FFFE 0929` (SIGNED-DECIMAL E = -2, C = 2345), denominator `0991 FFFF FFFF 3111` (UNSIGNED-DECIMAL E = -1, C = 12561).

## Relation to Other Formats

- The amount, lower, and upper of [QUANTITY](/grammar/value/numeric/quantity/) accept FRACTION. "Two-thirds of the voting rights present" can be written as a unitless QUANTITY with amount `2/3`.
- The geul.org specification document `0x0000/0x0000000000000807` writes it with two record fields: numerator (`0801`, `0810`) and denominator (`0802`, `0811`) ([Codec specification document](/grammar/codec-spec/)).
- When a fixed int64 fraction with enforced reduction is needed, use the Issuer format [RATIONAL-I64](/grammar/value/etc/rational-i64/).

## Open Questions

1. Notation preservation for mixed numbers (`1 and 2/3`).
2. A format that holds a fraction whose components have units (area/area) as two QUANTITYs. FRACTION does not hold a unit.
3. The notation rule for percent and per mille (`5%`, `5‰`): DECIMAL with a unit, or FRACTION (`5/100`).
4. Complex fractions (FRACTION in the numerator or denominator). They are forbidden for now.

## Related Pages

- [Value](/grammar/value/), [QUANTITY](/grammar/value/numeric/quantity/), [SIGNED-INTEGER](/grammar/value/numeric/signed-integer/), [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/), [RATIONAL-I64](/grammar/value/etc/rational-i64/)
