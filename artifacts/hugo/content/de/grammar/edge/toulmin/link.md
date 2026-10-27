---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK ist das Layout, mit dem Beziehungen zwischen TOULMIN-Knoten (Angriff, Verdrängung, Ausführung, Urteilsverbindung, Definition, Name) geschrieben werden. Es besteht aus src- und dst-REF, einem flag-WORD, einem optionalen Konfidenz-Gate und einem SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK ist das Layout, mit dem Beziehungen zwischen Knoten im TOULMIN-Graphen geschrieben werden. Die Art der Beziehung legt der Codec (oder die GEUL-ISSUER-Formatnummer) fest.

## Codec

| Codec | Name | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | Regel → Regel. Mindert das Urteil schrittweise |
| `0x69` | SUPERSEDES | `X supersedes Y` | Regel → Regel. Ist sie Active, nimmt sie das Ziel aus der Aggregation |
| `0x70` | RUN | `run c when n` | Regel → Fall |
| `0x71` | DO | `do fn when n` | Regel → FuncRef |
| `0x72` | DO-ONCE | `do fn once when n` | Regel → FuncRef |
| `0x73` | UNDO | `undo fn when n` | Regel → FuncRef |
| `0x74` | CHECKING | `checking c` | Regel → Fall. Urteil ohne Nebenwirkung |
| ISSUER `0x0000`/`0xC020` | REQUIRES | `f is required` | Fall → Feld |
| ISSUER `0x0000`/`0xC021` | MEANS | Definitions `means` | Definitionseintrag → Wert/Typ |
| ISSUER `0x0000`/`0xC022` | HAS | Definitions `has` | Definitionseintrag → Feld |
| ISSUER `0x0000`/`0xC023` | RUNS | Einstiegspunkt `run c` | Einstiegspunkt → Fall (Ausführung) |
| ISSUER `0x0000`/`0xC024` | EVALUATES | Einstiegspunkt `check c` | Einstiegspunkt → Fall (Beurteilung) |
| ISSUER `0x0000`/`0xC025` | TRIGGERS | Trigger `run c` | Trigger → Fall |
| ISSUER `0x0000`/`0xC026` | UNTIL | `every … until c` | Trigger → Fall |
| ISSUER `0x0000`/`0xC027` | SAME-AS | | Knoten → globale Kennung |
| ISSUER `0x0000`/`0xC028` | IMPORTED-FROM | `see a from path` | Alias → Pfad (TEXT) |
| ISSUER `0x0000`/`0xC029` | LABEL | Name in Backticks | Knoten → TEXT. Namensangabe |

## Layout

```
ID               LOCAL-Reference-Record (Edge Id)
src              REF
dst              REF. Bei DO, DO-ONCE, UNDO ein FuncRef
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED
[F_GATE]         Operator 1 WORD (obere 2 Bit) + UNSIGNED-DECIMAL-Value (Prozent)
SPAN             vom SOURCE festgelegte Breite × 2
```

| flag | Bedeutung |
|---|---|
| b0 F_ONCE | Wird nur einmal ausgeführt (das `once` von UNDO) |
| b1 F_GATE | Ein Feld für das Konfidenz-Gate ist vorhanden |
| b2 F_STRIKE | Eine durchgestrichene Beziehung |
| b3 F_ORDERED | Gehört zu einer geordneten Liste `1.` |

| Gate-Operator | Bedeutung |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

## Interpretation und Gültigkeit

- REF ist die Edge Id eines Records dieses Dokuments ([TOULMIN](/de/grammar/edge/toulmin/#gemeinsame-felder), gemeinsame Felder).
- Die Form von dst legt der Codec fest. Bei DO, DO-ONCE und UNDO ist es ein FuncRef (REF (ALIAS, 0 wenn keiner) + VerbCode 1 WORD, [NODE](/de/grammar/edge/toulmin/node/#felder)), bei LABEL und IMPORTED-FROM der REF eines TEXT-Records, sonst der REF eines Knotens.
- `do … once` stellt der Codec DO-ONCE dar. In den flags von DO-ONCE wird F_ONCE nicht verwendet (ist es eingeschaltet, wird abgelehnt). Das `once` von UNDO schreibt man mit F_ONCE.
- Der Gate-Operator sind die oberen 2 Bit des Operator-WORD, die übrigen 14 Bit sind 0. Das Prozent ist ein UNSIGNED-DECIMAL-Value mit `E=0` und liegt zwischen 0 und 100.
- Die Bits b4~b15 der flags sind reserviert und müssen 0 sein. Andernfalls wird abgelehnt.
- Eine Kette `A > B > C` von SUPERSEDES schreibt man mit je einem SUPERSEDES pro Paar.

## Verwandte Seiten

- [TOULMIN](/de/grammar/edge/toulmin/), [NODE](/de/grammar/edge/toulmin/node/), [SOURCE und Gliederung](/de/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/de/grammar/value/decimal/unsigned-decimal/)
