---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1004
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 ist ein ADHOC-Issuer-Format mit festen 11 WORD, das ein endliches, nicht leeres abgeschlossenes Intervall aus binary64-Unter- und -Obergrenze enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 ist ein Value, der ein abgeschlossenes Intervall aus zwei IEEE-754-binary64-Endpunkten in der Reihenfolge `(lower, upper)` darstellt. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, Formatnummer `0x0703`, Familie NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  insgesamt 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Formatnummer      1 WORD  0x0703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretation und Gültigkeit

- Die beiden Endpunkte sind binary64 in Big-Endian-WORD-Reihenfolge und schließen beide Enden ein.
- Das Bitmuster von signed zero gültiger Endpunkte bleibt unverändert erhalten. Es gibt kein ABI-Padding.
- Der Payload ist genau 8 WORD, und es muss `lower ≤ upper` gelten.
- NaN ist nicht vergleichbar und wird daher abgelehnt. Auch ein Endpunkt Unendlich wird abgelehnt, da das Intervall unbeschränkt wäre.
- Leere, unbeschränkte und offene Intervalle sowie NaI lassen sich mit diesem Format nicht darstellen und werden abgelehnt.

## Normgrundlage und Formatstatus

- Das Zahlenformat der Endpunkte folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/), und für die Bedeutung des abgeschlossenen Endpunktpaars werden das Intervallmodell von [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) und des simplified flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734) herangezogen.
- Dieses Format ist ein einfaches GEUL-Profil, das nur endliche, nicht leere abgeschlossene Intervalle zulässt. decorations, NaI, leere/unbeschränkte Intervalle und das vollständige Operations- und Interchange-Modell von IEEE 1788/1788.1 werden weder implementiert noch unverändert serialisiert.

## Länge

- Insgesamt sind es genau 11 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 8 WORD Payload, mit der direkten Länge `LLLL=1010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 8 WORD, wird abgelehnt.

## Beispiel

- Die Endpunkte `(1.0, 2.0)` ergeben `[1.0, 2.0]` und sind gültig. `(2.0, 1.0)` und `(NaN, 1.0)` sind invalid.
