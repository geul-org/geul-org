---
title: "GEUL-SIDX"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL-SIDX ist ein Deklarations-Reference, das mit einem GEUL SIDX (Semantic-aligned Index), dessen Bits selbst Bedeutung tragen, auf ein Objekt verweist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL-SIDX ist ein Deklarations-Reference, das mit einem GEUL SIDX (Semantic-aligned Index) auf ein Objekt verweist. SIDX ist eine Kennung, deren Bits selbst Bedeutung (Art, Eigenschaften) tragen.

## Layout

```
TAG WORD          0000 0LLL L001 1QQQ      CCCC = 0011
[Length-Erweiterungs-TAG]
SIDX              der gesamte Rest
```

- Der Quantifier ist derselbe wie bei anderen Deklarations-Codecs. Bei Variable ist es eine anonyme Variable dieser Art ([Reference](/de/grammar/reference/), Variable). Quantifiziert wird nur über `QQQ`. In den SIDX-Wert wird keine Quantifizierung eingebracht.
- Das Spezifikationsdokument deklariert SIDX als ein Rohwert-Feld mit Restbreite. Sobald die Breitenregel feststeht, wird es geändert.

## Beispiel

| SIDX | WORD-Folge |
|---|---|
| (nicht normativ) 64 Bit `0x1234 5678 9abc def0`, Identified | `0218 1234 5678 9abc def0` |

## Vergabegrundsatz

- Die Rolle unterscheidet sich von [GEUL](/de/grammar/reference/geul/). GEUL ist eine Identitäts-ID, die im Allgemeinen der Reihe nach vergeben wird (auto increment), GEUL-SIDX eine semantische Adresse, die bedeutungsnahen Objekten nahe Werte gibt.
- Wie nah, wird anhand gesammelter Nutzungsdaten statistisch festgelegt. Bevor sich Statistiken ansammeln, verwendet man die GEUL ID, und nach der Vergabe eines SIDX verbindet man GEUL und GEUL-SIDX desselben Objekts per [SAME-NODE](/de/grammar/edge/same-node/).

## Offene Fragen

- **Breite.** Sie wird nach den Statistiken festgelegt. Geprüft werden unter anderem 4 WORD (64 Bit) und 16 WORD. Bei SIDX tragen die oberen Bits Bedeutung, daher lässt sich die Regel der „kürzesten Breite“ anderer Deklarations-Codecs (kein führendes `0x0000`) nicht unverändert übernehmen. Es wird deshalb eine feste Breite (oder je Unterformat eine feste Breite). Bis dahin deklariert das Spezifikationsdokument SIDX als Rohwert mit Restbreite.
- **Stabilität der Vergabe.** Ein Reference verweist bei gleichem ganzzahligem Wert auf dasselbe Objekt, und vergebene IDs werden nicht wiederverwendet. Damit sich bereits vergebene SIDX auch bei geänderten Statistiken nicht verschieben, braucht man eine Append-only-Vergabe (dünn besetzte Vergabe, die Plätze für bedeutungsnahe Werte freihält). Wären Verschiebungen häufig, ist zu klären, ob SIDX nicht als dauerhafte Kennung, sondern als an eine Registerfassung gebundener Index definiert wird.
- **Eindeutigkeit.** Könnten SIDX durch die Erzeugung aus Bitbedeutungen kollidieren, passte das nicht zur Prämisse „gleicher ganzzahliger Wert, gleiches Objekt“. Bei der Vergabe werden Kollisionen aufgelöst, um die Eindeutigkeit zu sichern.
- Codebook und Veröffentlichungsformat des Registers.

## Verwandte Seiten

- [Reference](/de/grammar/reference/), [GEUL](/de/grammar/reference/geul/)
