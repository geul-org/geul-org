---
title: "REFERENCE-NODE"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "REFERENCE-NODE ist ein gerichtetes Beschreibungs-Edge (Codec 0x00), das ein Reference an einen Object-Record bindet und damit definiert, was dieses Reference ist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-NODE ist ein gerichtetes Beschreibungs-Edge, das ein Reference mit einem Object-Record verbindet und damit definiert oder bindet, was dieses Reference ist. Codec `0x00`.

Das Subject verweist auf das Object. Diese Bindung ist kein [SAME-NODE](/de/grammar/edge/same-node/), das semantische Identität behauptet, und bedeutet auch nicht, dass die Bytes beider Records gleich sind.

## Layout

```
TAG WORD          0001 0LLL L000 0000
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Subject           1 Reference-Record
Object            1 Reference- oder Value-Record
```

## Interpretation und Gültigkeit

- Das Subject muss genau ein vollständiger [Reference](/de/grammar/reference/)-Record sein. Seine Grenze findet man über seine eigene Length; ist es kein Reference oder unvollständig, ist es invalid.
- Das Object muss genau ein vollständiger Reference- oder Value-Record sein. Seine Grenze findet man über seine eigene Length; ist es ein Edge oder Meta oder unvollständig, ist es invalid.
- Ist das Object ein Reference, darf die Reference-Kette, der man über REFERENCE-NODE-Bindungen folgt, nicht zyklisch sein, und LOCAL muss letztlich aufgelöst werden. Auflösungszyklen und dangling LOCAL sind invalid.
- Wird in einem Dokument eine LOCAL ID an widersprüchliche Objects gebunden, ist es invalid. Geltungsbereich, ID, minimale Breite und Zusammenführungsregeln von LOCAL richten sich nach [LOCAL](/de/grammar/reference/local/).
- Nicht jedes Reference muss über REFERENCE-NODE gebunden werden.
- Der typische Anwendungsfall ist `LOCAL → UTF8-LANGUAGE-TEXT`. Steht im Object eines [LABEL](/de/grammar/edge/label/) ein LOCAL, wird der Text über diese Bindung im selben Dokument aufgelöst.

Die Richtung, in der das Subject auf das Object verweist, darf nicht umgekehrt interpretiert werden. Bedeutung und Einzelheiten von SAME und DIFFERENT legt jedes Format eigens fest.

## Länge

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

`N_len` ist die Zahl der WORD des Length-Erweiterungs-TAG, `N_id` die WORD-Zahl des Edge-Id-LOCAL-Records, `N_subject` und `N_object` die Gesamtzahl der WORD der jeweiligen Records. Der Cursor nach dem Lesen von Subject und Object muss genau mit dem Ende des Edge übereinstimmen.

## Beispiel (nicht normativ)

Edge Id `0008`, Subject ist LOCAL 1, Object ist der [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/) von `Donald Trump` (en).

- Die Edge Id ist `0088 0008`, also 2 WORD.
- Das Subject ist `0088 0001`, also 2 WORD.
- Das Object besteht aus der Sprache `08C6 656e` (BCP47 `en`) + Text 12 Byte (gerade), also `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), insgesamt 9 WORD. Das TAG ist `0C4A`.
- Das Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. Das TAG ist `1680`.

```
1680 0088 0008 0088 0001 0C4A 08C6 656e 446f 6e61 6c64 2054 7275 6d70
```

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [SAME-NODE](/de/grammar/edge/same-node/), [DIFFERENT-NODE](/de/grammar/edge/different-node/), [LABEL](/de/grammar/edge/label/)
- [Reference](/de/grammar/reference/), [LOCAL](/de/grammar/reference/local/), [UTF8-LANGUAGE-TEXT](/de/grammar/value/text/utf8-language-text/)
