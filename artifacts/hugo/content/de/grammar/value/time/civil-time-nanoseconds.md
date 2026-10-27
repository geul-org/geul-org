---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS ist ein Value, der eine bürgerliche Uhrzeit ohne Datum als Nanosekundenzahl seit Mitternacht enthält (Codec 0x21)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS stellt eine bürgerliche Uhrzeit ohne Datum als Nanosekundenzahl seit Mitternacht dar.

## Layout

- Code: direkter Value-Code `0x21`. Familie TIME.
- Es wird derselbe physische Typ fester Breite, vorzeichenbehaftetes int64, verwendet wie bei Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  insgesamt 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation und Gültigkeit

- Der gesamte Payload von 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in Big-Endian-WORD-Reihenfolge gelesen.
- Der physische Typ ist vorzeichenbehaftetes int64, aber der gültige Bereich ist `0 <= value < 86,400×10^9` ns. Negative Werte und Werte ab der Obergrenze werden abgelehnt.
- `24:00` und Schaltsekunden-Labels sind nicht zulässig. Auch Datum, Zeitzone und UTC-Offset werden nicht aufgenommen.
- Auch kleine Werte verwenden stets 4 WORD.

## Länge

- Insgesamt sind es genau 5 WORD aus 1 WORD TAG und 4 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel

- Mitternacht ist der Payload `0000 0000 0000 0000`, insgesamt 5 WORD, `LLLL=0100`.
- 1 ns nach Mitternacht ist der Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns entspricht der Obergrenze und ist daher nicht gültig.
- `ffff ffff ffff ffff` ist als vorzeichenbehaftetes int64 -1 und daher nicht gültig.

## Normgrundlage

- `TIME(isAdjustedToUTC=false, unit=NANOS)` von [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) speichert die Nanosekunden seit Mitternacht der Ortszeit in einem `int64` und verwendet die Vorzeichenreihenfolge.
- Die maßgebliche [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) des [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) definiert NANOSECOND Time als 64-Bit-Integer mit Vorzeichen, beschränkt den gültigen Bereich auf weniger als 86.400 Sekunden einschließlich Mitternacht und lässt keine Schaltsekunden zu. GEUL fügt nur den TAG und das Big-Endian-16-Bit-WORD-Framing hinzu.
