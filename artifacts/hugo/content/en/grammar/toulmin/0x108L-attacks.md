---
title: "ATTACKS (0x108L)"
weight: 264
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "ATTACKS is the LINK Codec that writes a relation of a TOULMIN graph."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ATTACKS is the LINK Codec that writes a relation of a TOULMIN graph. Meaning: attack relation. The attacker's verdict gradually reduces the target's verdict by the attack strength (0 to 1, default 1).

| Item | Value |
|---|---|
| Name | `ATTACKS` (spec document BIND `ATTACKS`) |
| TAG ID | `0x108L` |
| Codec ID | `0x00001080` |
| Spec document | `0x00000000/codecs/0x00001080/` (DECLARE target `1080`) |
| Section | 8 `1000` (Edge TOULMIN), offset within section C = 8 |
| Kind | Edge · family: TOULMIN, group: relation, layout: LINK |
| TAG WORD | `0001 0000 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Index description | Attack relation. The attacker's verdict gradually reduces the target's verdict by the attack strength (0 to 1, default 1) |
| Hugo page | `edge/toulmin/link.md` |

## Layout {#레이아웃}

The layout is [LINK](_index.md#link) (ID, src, dst, flags, conditional fields, SPAN).

| Item | Value |
|---|---|
| TANGEUL | `don't X when Y` |
| src → dst | rule → rule. Gradually reduces the verdict by the attack strength |

- dst is the REF of a node.
- Only this Codec uses F_FORCE (attack strength). See [Attack strength](#공격-세기) below.
- The common fields (ID, REF, SPAN) and the numeric rules follow [TOULMIN](_index.md#공통-필드).

## Attack strength {#공격-세기}

Attack strength (Force) says how strongly a single ATTACKS edge attacks its target. The range is 0 to 1, and it is 1 if F_FORCE is absent.

- In the verdict, the contribution `(v+1)/2` of the attacker's verdict value v is multiplied by the strength F. A rebuttal (COUNTER) attack enters as the denominator term `F·(v+1)/2`, and an exception (EXCEPT) attack enters as the gate `Π(1 − F·(v+1)/2)`. If F is 0, the attack has no effect on the verdict.
- The value follows the numeric rules of [TOULMIN](_index.md#수치). The encoder strips trailing zeros of the coefficient (0.5 is `C=5, E=−1`, 1.0 is `C=1, E=0`). The decoder accepts up to 4 decimal places.
- A surface form that does not state a strength (`don't X when Y`, ``if `Y`, `X` is void``) turns F_FORCE off.
- A surface form that states a strength (``if `Y`, attack `X` with strength 0.5``) turns F_FORCE on and holds the value. Even if 1 is written, as in `with strength 1.0`, F_FORCE is turned on and holds 1. So the original surface form is restored.
- Attack strength is a different axis from node strength (Strict, Defeasible, Defeater). Node strength attaches to the node; attack strength attaches to the ATTACKS edge.

### Attack strength example {#공격-세기-예시}

``if `Y`, attack `X` with strength 0.5``. Edge Id 5, attacker Y is Edge Id 3, target X is Edge Id 2, SPAN width 1 WORD.

```
108D                  TAG WORD: Edge, Codec 0x108L (ATTACKS), 14 WORD in total
0051 0005             ID      LOCAL 5
0051 0003             src     LOCAL 3 (Y, attacker)
0051 0002             dst     LOCAL 2 (X, target)
0010                  flags   F_FORCE
0683 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    start byte 0x40, byte count 0x1A
```

The same edge without a stated strength has flags `0000` and no F_FORCE field. Its TAG WORD is `1089` (10 WORD in total).

## Codec document {#코덱-문서}

The Codec document holds a DECLARE (target `1080`). The conditional fields of the LINK layout and the SPAN width set by SOURCE cannot be declared with FIELD, so the field declaration is an open problem ([TOULMIN](_index.md#열린-문제)).

## Related pages {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Spec document source {#규격-문서-원문}

This is the spec document `0x00000000/codecs/0x00001080/latest.geul` as read with `geul show` (hexadecimal in uppercase).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000108000000000
BODY
#1 DECLARE 0x1080
#2 BIND #1 "ATTACKS"
```
