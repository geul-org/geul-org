---
title: "CLOSED-INTERVAL-BINARY64"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "CLOSED-INTERVAL-BINARY64 ist ein Value, der ein abgeschlossenes Intervall aus zwei IEEE-754-binary64-Endpunkten in der Reihenfolge (lower, upper) darstellt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CLOSED-INTERVAL-BINARY64 ist ein Value, der ein abgeschlossenes Intervall aus zwei IEEE-754-binary64-Endpunkten in der Reihenfolge `(lower, upper)` darstellt. Es ist ein Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000002` ADHOC, Codec-Nummer `0x00000703`, Familie NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  insgesamt 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Codec-Nummer      2 WORD  0x00000703
Payload           [lower binary64: 4 WORD][upper binary64: 4 WORD]
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die beiden Endpunkte sind binary64 in Big-Endian-WORD-Reihenfolge und gehören zum Intervall.
- Das Bitmuster von signed zero gültiger Endpunkte bleibt erhalten. Es gibt kein ABI-Padding.
- Der Payload umfasst genau 8 WORD, und es muss `lower ≤ upper` gelten.
- NaN ist nicht vergleichbar und wird abgelehnt. Auch ein infinity-Endpunkt ergibt ein unbeschränktes Intervall und wird abgelehnt.
- Empty, unbounded und open interval sowie NaI sind in diesem Format nicht darstellbar und werden abgelehnt.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Das Zahlenformat der Endpunkte folgt [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/); die Bedeutung als abgeschlossenes Endpunktpaar orientiert sich am Intervallmodell von [IEEE 1788, Standard for Interval Arithmetic](https://standards.ieee.org/ieee/1788/4431/) und dem Simplified Flavor [IEEE 1788.1-2017](https://ieeexplore.ieee.org/document/8241734).
- Dieses Format ist ein einfaches GEUL-Profil, das nur endliche, nichtleere abgeschlossene Intervalle zulässt. Decorations, NaI, empty/unbounded interval sowie das vollständige Operations- und Interchange-Modell von IEEE 1788/1788.1 werden weder implementiert noch unverändert serialisiert.

## Länge {#길이}

- Die Gesamtlänge ist genau 13 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 8 WORD Payload; verwendet wird die direkte Länge `LLLL=1100`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 8 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Die Endpunkte `(1.0, 2.0)` ergeben `[1.0, 2.0]` und sind gültig. `(2.0, 1.0)` und `(NaN, 1.0)` sind invalid.
