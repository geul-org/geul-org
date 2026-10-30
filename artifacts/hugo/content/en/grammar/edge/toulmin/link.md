---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK is the layout that writes relations between TOULMIN nodes (attack, override, execution, judgment link, definition, name). It consists of src and dst REFs, a flag WORD, an optional confidence gate, an optional attack force, and a SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK is the layout that writes relations between nodes in a TOULMIN graph. The kind of relation is set by the Codec (or the GEUL ISSUER format number).

## Codec

| Codec | Name | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | rule → rule. Gradually reduces the judgment by the attack force |
| `0x69` | SUPERSEDES | `X supersedes Y` | rule → rule. If Active, removes the target from aggregation |
| `0x70` | RUN | `run c when n` | rule → case |
| `0x71` | DO | `do fn when n` | rule → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | rule → FuncRef |
| `0x73` | UNDO | `undo fn when n` | rule → FuncRef |
| `0x74` | CHECKING | `checking c` | rule → case. A judgment with no side effects |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | case → field |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | definition item → value or type |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | definition item → field |
| ISSUER `0x0000`/`0xC023` | RUNS | entry point `run c` | entry point → case (run) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | entry point `check c` | entry point → case (judge) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | trigger `run c` | trigger → case |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | trigger → case |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | node → global identifier |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | alias → path (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | backtick name | node → TEXT. A name notation |

## Layout

```
ID               LOCAL Reference record (Edge Id)
src              REF
dst              REF. For DO, DO-ONCE, UNDO, a FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         operator 1 WORD (upper 2 bits) + UNSIGNED-DECIMAL Value (percent)
[F_FORCE]        SIGNED-DECIMAL Value. Attack force (0 to 1). ATTACKS only
SPAN             width set by SOURCE × 2
```

| flag | Meaning |
|---|---|
| b0 F_ONCE | Perform only once (the `once` of UNDO) |
| b1 F_GATE | A confidence gate field is present |
| b2 F_STRIKE | A relation struck out with strikethrough |
| b3 F_ORDERED | Belongs to a `1.` ordered list |
| b4 F_FORCE | An attack force field is present. ATTACKS only |

| Gate operator | Meaning |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Conditional fields are placed in flag order (F_GATE, F_FORCE). A field whose flag is off takes no space.

## Attack Force

The attack force (Force) says how strongly one ATTACKS edge attacks its target. Its range is 0 to 1, and it is 1 when F_FORCE is absent.

- In judgment, the contribution `(v+1)/2` of the attacker's judgment value v is multiplied by the force F. A rebuttal (COUNTER) attack enters the denominator term as `F·(v+1)/2`, and an exception (EXCEPT) attack enters the gate `Π(1 − F·(v+1)/2)`. With F = 0 the attack has no effect on the judgment.
- The value follows the [TOULMIN](/grammar/edge/toulmin/#numbers) numeric rules. The encoder removes trailing zeros of the coefficient (0.5 is `C=5, E=−1`, 1.0 is `C=1, E=0`). The decoder accepts up to 4 decimal places.
- A surface that writes no force (`don't X when Y`, Korean `` `Y` 면 `X` 는 무효다``) turns F_FORCE off.
- A surface that writes a force (Korean `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) turns F_FORCE on and carries the value. Even when 1 is written, as in `1.0의 세기로`, F_FORCE is on and carries 1. So the source surface comes back as written.
- The attack force is a different axis from the strength of a node (Strict, Defeasible, Defeater). Strength belongs to a node; the attack force belongs to an ATTACKS edge.

### Example

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, attacker Y is Edge Id 3, target X is Edge Id 2, SPAN width 1 WORD.

```
16E8                  TAG WORD: Edge, 14 WORD total, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, attacker)
0088 0002             dst     LOCAL 2 (X, target)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    start byte 0x40, byte count 0x1A
```

The same edge without a force has flags `0000` and no F_FORCE field. Its TAG WORD is `14E8` (10 WORD total).

## Interpretation and Validity

- REF is the Edge Id of a record of this document (the common fields of [TOULMIN](/grammar/edge/toulmin/#common-fields)).
- The form of dst is set by the Codec. DO, DO-ONCE, and UNDO use a FuncRef (REF(ALIAS, 0 if none) + VerbCode 1 WORD, [NODE](/grammar/edge/toulmin/node/#fields)); LABEL and IMPORTED-FROM use the REF of a TEXT record; the rest use the REF of a node.
- `do … once` is expressed by the DO-ONCE Codec. F_ONCE is not used in the flags of DO-ONCE (if it is on, reject). The `once` of UNDO is written with F_ONCE.
- The gate operator is the upper 2 bits of the operator WORD, and the remaining 14 bits are 0. The percent is an UNSIGNED-DECIMAL Value with `E=0`, from 0 to 100.
- Bits b5-b15 of flags are reserved and must be 0. Otherwise reject.
- F_FORCE is used only on ATTACKS. If it is on in any other Codec (SUPERSEDES, execution and judgment links, ISSUER-format relations), reject.
- If the attack force is not a SIGNED-DECIMAL Value, lies outside 0 to 1, or cannot be written exactly with 4 decimal places, reject.
- A SUPERSEDES chain `A > B > C` is written with one SUPERSEDES per pair.

## Related Pages

- [TOULMIN](/grammar/edge/toulmin/), [NODE](/grammar/edge/toulmin/node/), [SOURCE and Sections](/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/grammar/value/decimal/signed-decimal/)
