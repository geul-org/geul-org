---
title: "TAI-TIMESTAMP-SECONDS"
weight: 1003
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "TAI-TIMESTAMP-SECONDS ist ein Value mit einer vorzeichenbehafteten Zahl von SI-Sekunden seit 1970-01-01T00:00:00 TAI (BIPM-Issuer-Format 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TAI-TIMESTAMP-SECONDS ist eine vorzeichenbehaftete Zahl von SI-Sekunden seit `1970-01-01T00:00:00 TAI`. Diese Darstellung als kumulierter Count ist kein Standard-Wire-Format des BIPM, sondern ein GEUL-eigenes Profil, das die Zeitskala TAI auf ein vorzeichenbehaftetes int64 fester Breite abbildet.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0060` BIPM, Formatnummer `0x4000`. Familie TIME.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  insgesamt 7 WORD
Issuer            1 WORD  0x0060 (BIPM)
Formatnummer      1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed SI Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed SI Seconds
Payload WORD 3rd (bits 31..16)     Signed SI Seconds
Payload WORD 4th (bits 15..0)      Signed SI Seconds low 16bit
```

## Interpretation und Gültigkeit

- Der gesamte Payload von 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63`~`2^63-1` Sekunden. Negative Werte sind TAI-instants vor der von GEUL festgelegten Epoche.
- Auch kleine Werte verwenden stets 4 WORD. UTC-Offset und Schaltsekundentabelle werden nicht gespeichert.

## Länge

- Insgesamt sind es genau 7 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 4 WORD Payload, mit der direkten Länge `LLLL=0110`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel

- Die GEUL-TAI-Epoche ist der Payload `0000 0000 0000 0000`, insgesamt 7 WORD, `LLLL=0110`.
- 1 Sekunde nach der Epoche ist der Payload `0000 0000 0000 0001`.
- 1 Sekunde vor der Epoche ist der Payload `ffff ffff ffff ffff`.

## Normgrundlage und Formatstatus

- Die [BIPM SI Brochure, 9th edition](https://www.bipm.org/documents/20126/41483022/SI-Brochure-9-EN.pdf/2d2b50bf-f2b4-9661-f402-5f9d66e4b507?version=1.10) legt die SI-Sekunde und die Zeitskala International Atomic Time (TAI) fest.
- Das BIPM definiert keinen kumulierten vorzeichenbehafteten int64-Count seit der Epoche `1970-01-01 TAI` und kein Wire-Encoding dafür. Epoche, vorzeichenbehaftetes int64 und die Big-Endian-WORD-Anordnung von GEUL sind eine GEUL-eigene Abbildung.
- Das int64 fester Breite wurde im Hinblick auf Austauschkonsistenz mit anderen TIME-Count-Profilen gewählt und bedeutet nicht, dass ein BIPM-Format unverändert nachgebildet wurde.
