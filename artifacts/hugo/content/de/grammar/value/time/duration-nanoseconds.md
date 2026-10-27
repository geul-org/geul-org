---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS ist ein Value, der eine verstrichene Zeit in Nanosekunden als vorzeichenbehaftetes int64 ohne Epoche enthält (GEUL-Issuer-Format 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS ist eine verstrichene Zeit in vorzeichenbehafteten Nanosekunden ohne Epoche. Sie ist weder ein instant noch eine Kalenderdauer in Monaten oder Jahren.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, Formatnummer `0x4000`. Familie TIME.
- Es wird derselbe physische Typ fester Breite, vorzeichenbehaftetes int64, verwendet wie bei Arrow `Duration(NANOSECOND)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  insgesamt 7 WORD
Issuer            1 WORD  0x0000 (GEUL)
Formatnummer      1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation und Gültigkeit

- Der gesamte Payload von 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63`~`2^63-1` ns. Das Vorzeichen ist die Richtung des Verstreichens und verweist nicht auf einen instant einer bestimmten Epoche.
- Auch kleine Werte verwenden stets 4 WORD.

## Länge

- Insgesamt sind es genau 7 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 4 WORD Payload, mit der direkten Länge `LLLL=0110`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel

- 0 ns sind der Payload `0000 0000 0000 0000`, insgesamt 7 WORD, `LLLL=0110`.
- 1 ns ist der Payload `0000 0000 0000 0001`.
- -1 ns ist der Payload `ffff ffff ffff ffff`.

## Normgrundlage

- Das [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) bestimmt `Schema.fbs` als maßgebliche Quelle der Standarddatentypen von Arrow.
- In der maßgeblichen [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) von Arrow ist `Duration` eine kalenderunabhängige absolute verstrichene Zeit, unterstützt die Einheit NANOSECOND und wird stets als 8-Byte-Integer mit Vorzeichen dargestellt. GEUL fügt dem nur den TAG und das Big-Endian-16-Bit-WORD-Framing hinzu.
