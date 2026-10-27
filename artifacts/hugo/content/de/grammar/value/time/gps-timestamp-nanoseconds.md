---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS ist ein Value mit einer vorzeichenbehafteten Nanosekundenzahl seit der GPS-Epoche 1980-01-06T00:00:00 GPS (GPS-Issuer-Format 0x4001)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS ist eine vorzeichenbehaftete Nanosekundenzahl seit der GPS-Epoche `1980-01-06T00:00:00 GPS`. Sie wird weder durch die GPS-Wochennummer geteilt noch auf die Week-Rollover-Breite des Broadcast-Feldes gekürzt.

Diese Darstellung als kumulierter Count ist kein Broadcast-Wire-Format von IS-GPS-200, sondern ein GEUL-eigenes Profil, das die GPS-Zeitskala auf ein vorzeichenbehaftetes int64 fester Breite abbildet.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0063` GPS, Formatnummer `0x4001`. Familie TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  insgesamt 7 WORD
Issuer            1 WORD  0x0063 (GPS)
Formatnummer      1 WORD  0x4001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation und Gültigkeit

- Der gesamte Payload von 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63`~`2^63-1` ns. Negative Werte sind GPS-Zeit-instants vor der GPS-Epoche.
- Der Count ist ein von der Epoche aus fortlaufender Wert. Eine Kürzung oder ein Rollover des Broadcast-Wochennummernfeldes wird nicht angewandt.
- Auch kleine Werte verwenden stets 4 WORD. Parameter für die UTC-Umrechnung werden nicht aufgenommen.

## Länge

- Insgesamt sind es genau 7 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 4 WORD Payload, mit der direkten Länge `LLLL=0110`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel

- Die GPS-Epoche ist der Payload `0000 0000 0000 0000`, insgesamt 7 WORD, `LLLL=0110`.
- 1 ns nach der Epoche ist der Payload `0000 0000 0000 0001`.
- 1 ns vor der Epoche ist der Payload `ffff ffff ffff ffff`.

## Normgrundlage und Formatstatus

- Die [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) ist die offizielle Bezugsstelle der GPS-Schnittstellenspezifikationen.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) legt fest, dass die GPS-Zeit eine kontinuierliche Zeitskala ist und Woche 0 am 1980-01-06 um Mitternacht beginnt, und definiert die GPS-Wochennummer sowie die Broadcast-Felder time-of-week/Z-count.
- IS-GPS-200 definiert keine Wire-Darstellung als kumuliertes vorzeichenbehaftetes int64 in Nanosekunden seit der Epoche. Der kontinuierliche Count in der Einheit Nanosekunde ohne Rollover, das vorzeichenbehaftete int64 und die Big-Endian-WORD-Anordnung von GEUL sind eine GEUL-eigene Abbildung.
