---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1022
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS ist die Anzahl der signed SI-Sekunden seit 1970-01-01T00:00:00 TAI."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS ist die Anzahl der signed SI-Sekunden seit `1970-01-01T00:00:00 TAI`. Diese Darstellung als akkumulierter Count ist kein BIPM-Standard-Wire-Format, sondern ein GEUL-eigenes Profil, das die Zeitskala TAI auf ein signed int64 fester Breite abbildet.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x00000013` BIPM, Codec-Nummer `0x00004000`. Familie TIME.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  insgesamt 9 WORD
Issuer            2 WORD  0x00000013 (BIPM)
Codec-Nummer      2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Alle 4 WORD des Payloads werden als signed Count im 64-Bit-Zweierkomplement in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63` bis `2^63-1` Sekunden. Negative Werte sind TAI-Instants vor der von GEUL festgelegten Epoche.
- Auch kleine Werte belegen stets 4 WORD. UTC-Offset und Leap-Second-Tabelle werden nicht gespeichert.

## Länge {#길이}

- Die Gesamtlänge ist genau 9 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 4 WORD Payload; verwendet wird die direkte Länge `LLLL=1000`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 4 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Die GEUL-TAI-Epoche ist der Payload `0000 0000 0000 0000`, insgesamt 9 WORD, `LLLL=1000`.
- 1 Sekunde nach der Epoche ist der Payload `0000 0000 0000 0001`.
- 1 Sekunde vor der Epoche ist der Payload `FFFF FFFF FFFF FFFF`.

## Normgrundlage und Formatstatus {#표준-근거와-형식-지위}

- Die [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) legt die SI-Sekunde und die Zeitskala International Atomic Time (TAI) fest.
- Das BIPM definiert weder ein signed int64 als akkumulierten Count seit der Epoche `1970-01-01 TAI` noch dessen Wire Encoding. Epoche, signed int64 und die Big-Endian-WORD-Anordnung von GEUL sind eine GEUL-eigene Abbildung.
- Das int64 fester Breite wurde im Hinblick auf die Austauschkonsistenz mit anderen TIME-Count-Profilen gewählt und bedeutet nicht, dass ein BIPM-Format unverändert nachgebildet wird.
