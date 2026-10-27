---
title: "NODE"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NODE ist das Layout, mit dem Knoten des TOULMIN-Graphen (Fall, Regel, Definition, Einstiegspunkt, Trigger, Funktion, Feld, Alias, Gruppe) geschrieben werden. Die Flags des 1-WORD-Headers legen die nachfolgenden bedingten Felder fest."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NODE ist das Layout, mit dem Knoten des TOULMIN-Urteils- und Ausführungsgraphen geschrieben werden. Die Knotenart legt der Codec (oder die GEUL-ISSUER-Formatnummer) fest, und der 1-WORD-Header legt Rolle, Level, Claim-Form und die bedingten Felder fest.

## Codec

| Codec | Name | TANGEUL | Knoten |
|---|---|---|---|
| `0x60` | CASE-DECLARE | `in case of` | Fall |
| `0x62` | SPEC-DECLARE | Eintrag der Definitions (`means`, `has`) | Beurteilungskriterium (Backing). role ist die Art der Definition |
| `0x63` | RULE-DECLARE | general rule | Behauptung (Warrant) |
| `0x64` | COUNTER-DECLARE | counter rule | Gegenbehauptung (Rebuttal) |
| `0x65` | EXCEPT-DECLARE | except rule | Ausnahme (Defeater) |
| `0x75` | ENTRY | `provides x` | Externer Einstiegspunkt |
| `0x76` | TRIGGER | `on`, `every`, `until` | Ereignis- oder periodischer Einstiegspunkt |
| ISSUER `0x0000`/`0xC010` | NAMESPACE | `this document is` | Namensraum des Dokuments |
| ISSUER `0x0000`/`0xC011` | FUNC | Funktionsreferenz | Externe Funktion (z. B. `bank.withdraw`) |
| ISSUER `0x0000`/`0xC012` | FIELD | `x is required [as Type]` | Pflichtfeld |
| ISSUER `0x0000`/`0xC013` | ALIAS | `see a from path` | Alias eines importierten Pakets |
| ISSUER `0x0000`/`0xC014` | GROUP | `1.` geordnete Liste | Geordnete Ausführungsgruppe |

ISSUER-Formate haben nach `ISSUER-1WORD` (`0x7C`) im Codec-Erweiterungs-TAG den Issuer `0x0000` und die Formatnummer ([TOULMIN](/de/grammar/edge/toulmin/)).

## Layout

```
ID               LOCAL-Reference-Record (Edge Id)
Header 1 WORD    role 2b | reserviert 2b | F_GROUNDS 1b | level 2b | object-Art 2b | flags 7b
[F_FUNC]         FuncRef: REF (ALIAS, 0 wenn keiner) + VerbCode 1 WORD
[F_QUAL]         SIGNED-DECIMAL-Value. Qualifier
[F_CHECK]        REF (Fall)
[F_CLAIM]        Claim: REF (subject) + predicate 1 WORD + object + mode 1 WORD
[F_VERDICT]      SIGNED-DECIMAL-Value. Anfangswert des Urteilswerts
[F_WITH]         Anzahl (UNSIGNED-INTEGER-Value) + REF (TEXT) × Anzahl
[F_GROUNDS]      Anzahl (UNSIGNED-INTEGER-Value) + REF (TEXT) × Anzahl
SPAN             vom SOURCE festgelegte Breite × 2 (Startbyte, Bytezahl)
```

### Header-WORD

| Bit | Feld | Wert |
|---|---|---|
| 15–14 | role | 0 general, 1 counter, 2 except |
| 13–12 | reserviert | 0 |
| 11 | F_GROUNDS | Eine Liste von Belegen ist vorhanden |
| 10–9 | level | 0 Unset, 1 Fail, 2 Review (3 reserviert) |
| 8–7 | object-Art | Form des Claim-object. 0 REF, 1 UNSIGNED-INTEGER-Value, 2 SPAN |
| 6–0 | flags | Tabelle unten |

| Bit | flag | Bedeutung |
|---|---|---|
| b0 | F_FUNC | Ein FuncRef-Feld ist vorhanden |
| b1 | F_QUAL | Ein Qualifier-Feld ist vorhanden |
| b2 | F_CHECK | Ein Feld für den Fall, der nur mit `checking` beurteilt wird, ist vorhanden |
| b3 | F_CLAIM | Ein Claim-Feld ist vorhanden |
| b4 | F_VERDICT | Ein Feld für den Anfangswert des Urteilswerts ist vorhanden |
| b5 | F_STRIKE | Eine durchgestrichene Deklaration. Kein Feld |
| b6 | F_WITH | Ein Feld für die Kriterienliste ist vorhanden |

- Bedingte Felder stehen in der Reihenfolge der flags (F_FUNC, F_QUAL, F_CHECK, F_CLAIM, F_VERDICT, F_WITH, F_GROUNDS). Ein Feld, dessen flag ausgeschaltet ist, belegt keine Stelle.
- Ist ein flag eingeschaltet und das Feld fehlt, wird abgelehnt. Die Position nach dem Lesen der Felder muss hinter dem SPAN genau mit dem Ende des Records übereinstimmen.

## Felder

| Feld | Beschreibung |
|---|---|
| FuncRef | Stelle der Funktion. REF ist der ALIAS-Record, der diese Funktion importiert hat, und `0`, wenn es eine Funktion dieses Dokuments ist. Der VerbCode ist ein 1-WORD-Code und noch nicht vergeben (`0x0000` zulässig). Die Originalschreibweise der Funktion wird gesondert als TEXT + [LABEL](/de/grammar/edge/toulmin/link/) geschrieben |
| Qualifier | Konfidenz des Knotens (0~1) |
| Fall | F_CHECK: Fall, den dieser Knoten nur beurteilt (`checking c`) |
| Claim | Die vom Knoten enthaltene Proposition. subject REF, predicate 1 WORD, object, mode 1 WORD. Die Form des object legt die object-Art im Header fest |
| Urteilswert | Anfangswert des Urteilswerts (−1~1) |
| F_WITH | Beurteilungskriterien zum Zeitpunkt der Deklaration (`기준으로 하는`, „zugrunde gelegtes Kriterium“). Liste von REF auf TEXT-Records |
| F_GROUNDS | Namen externer Tatsachen, die zum Zeitpunkt der Auswertung aufgelöst werden (`근거로 하는`, „gestützt auf“). Liste von REF auf TEXT-Records |
| SPAN | Bereich im Originaltext, aus dem diese Deklaration stammt |

- Die Notation von Urteilswert und Qualifier folgt den Regeln unter [Numerische Werte](/de/grammar/edge/toulmin/#numerische-werte) in TOULMIN.
- Die Anzahl der Listen ist ein eingebetteter [UNSIGNED-INTEGER](/de/grammar/value/numeric/unsigned-integer/)-Value-Record.
- Die Grundform eines beschreibenden Claim hat subject und predicate `0` und als object einen SPAN (object-Art 2). Sie ist an die Schreibweise im Originaltext gebunden.

## Interpretation und Gültigkeit

- role muss bei RULE-, COUNTER- und EXCEPT-DECLARE dem Codec entsprechen (0 general, 1 counter, 2 except). Bei SPEC-DECLARE ist es die Art der Definition. Bei anderen Codecs ist es 0.
- Ist level 0 (Unset), gilt der Standardwert der Engine: COUNTER-DECLARE ist Fail, EXCEPT-DECLARE Review.
- Die Host-Funktionsregel von TANGEUL `tangl:규칙` („Regel“) (`쓰는 규칙이다`, „ist eine Regel, die … verwendet“) wird als RULE-DECLARE-NODE außerhalb eines Falls geschrieben. Die Funktion ist F_FUNC, das Kriterium F_WITH, der Beleg F_GROUNDS. Nur Bedingungsausdruck-Regeln haben davor ein [PREDICATE-DECLARE](/de/grammar/edge/toulmin/expr/).
- Die reservierten Bits (13–12) müssen 0 sein. Ist ein reserviertes Bit eingeschaltet oder passt role nicht zum Codec, wird abgelehnt.

## Verwandte Seiten

- [TOULMIN](/de/grammar/edge/toulmin/), [LINK](/de/grammar/edge/toulmin/link/), [EXPR](/de/grammar/edge/toulmin/expr/), [SOURCE und Gliederung](/de/grammar/edge/toulmin/source/)
- [LOCAL](/de/grammar/reference/local/), [SIGNED-DECIMAL](/de/grammar/value/decimal/signed-decimal/)
