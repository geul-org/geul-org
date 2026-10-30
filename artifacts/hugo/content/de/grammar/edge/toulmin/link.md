---
title: "LINK"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-31T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LINK ist das Layout, mit dem Beziehungen zwischen TOULMIN-Knoten (Angriff, Verdrängung, Ausführung, Urteilsverbindung, Definition, Name) geschrieben werden. Es besteht aus src- und dst-REF, einem flag-WORD, einem optionalen Konfidenz-Gate, einer optionalen Angriffskraft und einem SPAN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LINK ist das Layout, mit dem Beziehungen zwischen Knoten im TOULMIN-Graphen geschrieben werden. Die Art der Beziehung legt der Codec (oder die GEUL-ISSUER-Formatnummer) fest.

## Codec

| Codec | Name | TANGEUL | src → dst |
|---|---|---|---|
| `0x68` | ATTACKS | `don't X when Y` | Regel → Regel. Mindert das Urteil schrittweise nach der Angriffskraft |
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
flags 1 WORD     b0 F_ONCE, b1 F_GATE, b2 F_STRIKE, b3 F_ORDERED, b4 F_FORCE
[F_GATE]         Operator 1 WORD (obere 2 Bit) + UNSIGNED-DECIMAL-Value (Prozent)
[F_FORCE]        SIGNED-DECIMAL Value. Angriffskraft (0~1). Nur ATTACKS
SPAN             vom SOURCE festgelegte Breite × 2
```

| flag | Bedeutung |
|---|---|
| b0 F_ONCE | Wird nur einmal ausgeführt (das `once` von UNDO) |
| b1 F_GATE | Ein Feld für das Konfidenz-Gate ist vorhanden |
| b2 F_STRIKE | Eine durchgestrichene Beziehung |
| b3 F_ORDERED | Gehört zu einer geordneten Liste `1.` |
| b4 F_FORCE | Ein Angriffskraft-Feld ist vorhanden. Nur ATTACKS |

| Gate-Operator | Bedeutung |
|---|---|
| 0 | at least |
| 1 | above |
| 2 | less than |
| 3 | at most |

- Bedingte Felder stehen in Flag-Reihenfolge (F_GATE, F_FORCE). Ein Feld, dessen Flag aus ist, belegt keinen Platz.

## Angriffskraft

Die Angriffskraft (Force) gibt an, wie kräftig eine ATTACKS-Kante ihr Ziel angreift. Ihr Bereich ist 0~1; ohne F_FORCE ist sie 1.

- Im Urteil wird der Beitrag `(v+1)/2` des Urteilswerts v des Angreifers mit der Kraft F multipliziert. Ein Widerlegungsangriff (COUNTER) geht als Nennerterm `F·(v+1)/2` ein, ein Ausnahmeangriff (EXCEPT) in das Gate `Π(1 − F·(v+1)/2)`. Bei F = 0 wirkt der Angriff nicht auf das Urteil.
- Der Wert folgt den numerischen Regeln von [TOULMIN](/de/grammar/edge/toulmin/#numerische-werte). Der Encoder entfernt Nullen am Ende des Koeffizienten (0.5 ist `C=5, E=−1`, 1.0 ist `C=1, E=0`). Der Decoder nimmt bis zu 4 Nachkommastellen an.
- Eine Oberfläche ohne Kraftangabe (`don't X when Y`, koreanisch `` `Y` 면 `X` 는 무효다``) schaltet F_FORCE aus.
- Eine Oberfläche mit Kraftangabe (koreanisch `` `Y` 면 `X` 를 0.5의 세기로 공격한다``) schaltet F_FORCE ein und trägt den Wert. Auch wenn 1 geschrieben wird, wie in `1.0의 세기로`, wird F_FORCE eingeschaltet und trägt 1. So kehrt die Quelloberfläche unverändert zurück.
- Die Angriffskraft ist eine andere Achse als die Stärke eines Knotens (Strict, Defeasible, Defeater). Die Stärke gehört zum Knoten, die Angriffskraft zur ATTACKS-Kante.

### Beispiel

`` `Y` 면 `X` 를 0.5의 세기로 공격한다``. Edge Id 5, Angreifer Y ist Edge Id 3, Ziel X ist Edge Id 2, SPAN-Breite 1 WORD.

```
16E8                  TAG WORD: Edge, insgesamt 14 WORD, Codec 0x68 (ATTACKS)
0088 0005             ID      LOCAL 5
0088 0003             src     LOCAL 3 (Y, Angreifer)
0088 0002             dst     LOCAL 2 (X, Ziel)
0010                  flags   F_FORCE
0990 FFFF FFFF 0005   F_FORCE SIGNED-DECIMAL, E=−1, C=5 (0.5)
0040 001A             SPAN    Startbyte 0x40, Byteanzahl 0x1A
```

Dieselbe Kante ohne Kraftangabe hat flags `0000` und kein F_FORCE-Feld. Ihr TAG WORD ist `14E8` (insgesamt 10 WORD).

## Interpretation und Gültigkeit

- REF ist die Edge Id eines Records dieses Dokuments ([TOULMIN](/de/grammar/edge/toulmin/#gemeinsame-felder), gemeinsame Felder).
- Die Form von dst legt der Codec fest. Bei DO, DO-ONCE und UNDO ist es ein FuncRef (REF (ALIAS, 0 wenn keiner) + VerbCode 1 WORD, [NODE](/de/grammar/edge/toulmin/node/#felder)), bei LABEL und IMPORTED-FROM der REF eines TEXT-Records, sonst der REF eines Knotens.
- `do … once` stellt der Codec DO-ONCE dar. In den flags von DO-ONCE wird F_ONCE nicht verwendet (ist es eingeschaltet, wird abgelehnt). Das `once` von UNDO schreibt man mit F_ONCE.
- Der Gate-Operator sind die oberen 2 Bit des Operator-WORD, die übrigen 14 Bit sind 0. Das Prozent ist ein UNSIGNED-DECIMAL-Value mit `E=0` und liegt zwischen 0 und 100.
- Die Bits b5~b15 der flags sind reserviert und müssen 0 sein. Andernfalls wird abgelehnt.
- F_FORCE wird nur bei ATTACKS verwendet. Ist es in einem anderen Codec (SUPERSEDES, Ausführungs- und Urteilsverbindungen, Beziehungen im ISSUER-Format) gesetzt, wird abgelehnt.
- Ist die Angriffskraft kein SIGNED-DECIMAL-Value, liegt sie außerhalb von 0~1 oder lässt sie sich nicht exakt mit 4 Nachkommastellen schreiben, wird abgelehnt.
- Eine Kette `A > B > C` von SUPERSEDES schreibt man mit je einem SUPERSEDES pro Paar.

## Verwandte Seiten

- [TOULMIN](/de/grammar/edge/toulmin/), [NODE](/de/grammar/edge/toulmin/node/), [SOURCE und Gliederung](/de/grammar/edge/toulmin/source/)
- [UNSIGNED-DECIMAL](/de/grammar/value/decimal/unsigned-decimal/), [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/)
