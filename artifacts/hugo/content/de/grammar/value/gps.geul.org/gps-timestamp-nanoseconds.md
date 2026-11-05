---
title: "GPS-TIMESTAMP-NANOSECONDS"
weight: 1023
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GPS-TIMESTAMP-NANOSECONDS ist die Anzahl der signed Nanosekunden seit der GPS-Epoche 1980-01-06T00:00:00 GPS."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GPS-TIMESTAMP-NANOSECONDS ist die Anzahl der signed Nanosekunden seit der GPS-Epoche `1980-01-06T00:00:00 GPS`. Der Wert wird weder durch die GPS-Wochennummer geteilt noch auf die Week-Rollover-Breite des Broadcast-Felds gekürzt.

Diese Darstellung als akkumulierter Count ist kein IS-GPS-200-Broadcast-Wire-Format, sondern ein GEUL-eigenes Profil, das die GPS-Zeitskala auf ein signed int64 fester Breite abbildet.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000016` GPS, Codec-Nummer `0x00004001`. Familie TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  insgesamt 9 WORD
Issuer            2 WORD  0x00000016 (GPS)
Codec-Nummer      2 WORD  0x00004001
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Alle 4 WORD des Payloads werden als signed Count im 64-Bit-Zweierkomplement in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63` bis `2^63-1` ns. Negative Werte sind GPS-Time-Instants vor der GPS-Epoche.
- Der Count ist ein ab der Epoche fortlaufender Wert. Truncation oder Rollover des Broadcast-Wochennummernfelds werden nicht angewandt.
- Auch kleine Werte belegen stets 4 WORD. UTC-Umrechnungsparameter werden nicht aufgenommen.

## Länge {#길이}

- Die Gesamtlänge ist genau 9 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 4 WORD Payload; verwendet wird die direkte Länge `LLLL=1000`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 4 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Die GPS-Epoche ist der Payload `0000 0000 0000 0000`, insgesamt 9 WORD, `LLLL=1000`.
- 1 ns nach der Epoche ist der Payload `0000 0000 0000 0001`.
- 1 ns vor der Epoche ist der Payload `FFFF FFFF FFFF FFFF`.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Die [GPS.gov Technical Documentation](https://www.gps.gov/technical-documentation) ist die offizielle Bezugsquelle der GPS-Schnittstellenspezifikationen.
- [IS-GPS-200N](https://archive.gps.gov/technical/icwg/IS-GPS-200N.pdf) legt fest, dass die GPS-Zeit eine kontinuierliche Zeitskala ist und Woche 0 um Mitternacht des 1980-01-06 beginnt, und definiert die GPS-Wochennummer sowie die Broadcast-Felder Time of Week/Z-Count.
- IS-GPS-200 definiert keine Wire-Darstellung als akkumuliertes Nanosekunden-signed-int64 seit der Epoche. Der Rollover-freie fortlaufende Count in Nanosekunden, signed int64 und die Big-Endian-WORD-Anordnung von GEUL sind eine GEUL-eigene Abbildung.
