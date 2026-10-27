---
title: "BIT-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR ist ein GEUL-Issuer-Format, das nach einer 32-Bit-Bitzahl N genau N Bit in MSB-first-Reihenfolge enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR ist eine rohe Bitfolge (raw bit sequence) mit angegebener Länge. Es ist ein Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, Formatnummer `0xC002`, Familie BINARY. Die ersten 2 Payload-WORD sind der vorzeichenlose 32-Bit-bit count `N`, danach folgen `ceil(N/16)` WORD.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length-Erweiterungs-TAG] ab insgesamt 15 WORD
Issuer            1 WORD  0x0000 (GEUL)
Formatnummer      1 WORD  0xC002
Payload WORD 1st–2nd       Bit Count N (obere 16 Bit │ untere 16 Bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretation und Gültigkeit

- `N` ist der Wert, der entsteht, wenn man die ersten 2 Payload-WORD als vorzeichenlose 32-Bit-Big-Endian-Ganzzahl liest.
- Die Payload-Bits werden in jedem WORD ab dem höchstwertigen Bit der Reihe nach gefüllt.
- Die Zahl der Payload-WORD ist genau `ceil(N/16)`, und die nicht verwendeten unteren Bits des letzten WORD müssen alle 0 sein.
- Bei `N=0` gibt es kein Payload-WORD. Da die beiden count-WORD bereits den Payload bilden, steht das nicht im Widerspruch zur Regel „mindestens 1 WORD Payload“.

## Formatstatus

- Der vorzeichenlose 32-Bit-bit count, die MSB-first-Anordnung und das Zero-Padding im letzten WORD sind kein Zitat eines externen Industriestandards, sondern GEUL-eigenes Framing.
- Diese Seite definiert die Darstellung einschließlich der Regeln für GEUL-TAG, Length und 16-Bit-WORD.

## Länge

- Insgesamt ist es die Summe der WORD aus 1 WORD TAG, Length-Erweiterungs-TAG (falls vorhanden), 1 WORD Issuer, 1 WORD Formatnummer und Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`/`1111`, und der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](/de/grammar/record/)).

## Beispiel

- Ein leerer Bitvektor hat den count `0000 0000`, keinen Payload, insgesamt 5 WORD, `LLLL=0100`.
- Die Bitfolge `101` hat den count `0000 0003`, Payload `a000`, insgesamt 6 WORD, `LLLL=0101`.
