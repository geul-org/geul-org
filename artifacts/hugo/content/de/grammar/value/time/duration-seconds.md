---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS ist ein Value, der eine verstrichene Zeit in Sekunden als vorzeichenbehaftetes int64 ohne Epoche enthält (Codec 0x23)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS ist eine verstrichene Zeit in vorzeichenbehafteten Sekunden ohne Epoche. Sie ist weder ein instant noch eine Kalenderdauer in Monaten oder Jahren.

## Layout

- Code: direkter Value-Code `0x23`. Familie TIME.
- Es wird derselbe physische Typ fester Breite, vorzeichenbehaftetes int64, verwendet wie bei Arrow `Duration(SECOND)`.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  insgesamt 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretation und Gültigkeit

- Der gesamte Payload von 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63`~`2^63-1` Sekunden. Das Vorzeichen ist die Richtung des Verstreichens und verweist nicht auf einen instant einer bestimmten Epoche.
- Auch kleine Werte verwenden stets 4 WORD.

## Länge

- Insgesamt sind es genau 5 WORD aus 1 WORD TAG und 4 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel

- 0 Sekunden sind der Payload `0000 0000 0000 0000`, insgesamt 5 WORD, `LLLL=0100`.
- 1 Sekunde ist der Payload `0000 0000 0000 0001`.
- -1 Sekunde ist der Payload `ffff ffff ffff ffff`.

## Normgrundlage

- Das [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) bestimmt `Schema.fbs` als maßgebliche Quelle der Standarddatentypen von Arrow.
- In der maßgeblichen [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) von Arrow ist `Duration` eine kalenderunabhängige absolute verstrichene Zeit, unterstützt die Einheit SECOND und wird stets als 8-Byte-Integer mit Vorzeichen dargestellt. GEUL fügt dem nur den TAG und das Big-Endian-16-Bit-WORD-Framing hinzu.
