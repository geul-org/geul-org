---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS ist ein Value mit einer vorzeichenbehafteten int64-Nanosekundenzahl seit der Unix-Epoche (IEEE-Issuer-Format 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS ist eine vorzeichenbehaftete Nanosekundenzahl seit der Unix-Epoche `1970-01-01T00:00:00Z`. Wie bei den seconds-since-the-Epoch von POSIX gilt jeder Tag als genau 86.400 Sekunden, und Schaltsekunden werden nicht mitgezählt.

## Layout

- Code: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, Formatnummer `0x4000`. Familie TIME.
- Für den Austausch industrieller Daten wird derselbe physische Typ fester Breite, vorzeichenbehaftetes int64, verwendet wie bei Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  insgesamt 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
Formatnummer      1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation und Gültigkeit

- Der gesamte Payload von 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63`~`2^63-1` ns, und der instant-Bereich ist `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z`.
- Auch kleine Werte verwenden stets 4 WORD. Sie dürfen nicht auf die Ganzzahldarstellung mit minimaler WORD-Zahl verkürzt werden.
- Zeitzone, ursprünglicher UTC-Offset, Schaltsekunden-Label und Schaltsekundentabelle werden nicht aufgenommen.

## Länge

- Insgesamt sind es genau 7 WORD aus 1 WORD TAG, 1 WORD Issuer, 1 WORD Formatnummer und 4 WORD Payload, mit der direkten Länge `LLLL=0110`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel

- Die Epoche ist der Payload `0000 0000 0000 0000`, insgesamt 7 WORD, `LLLL=0110`.
- 1 ns nach der Epoche ist der Payload `0000 0000 0000 0001`.
- 1 ns vor der Epoche ist der Payload `ffff ffff ffff ffff`.

## Normgrundlage

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) definiert die Member `time_t tv_sec` und `long tv_nsec` sowie `0 <= tv_nsec < 10^9`. Breite und Darstellung von `time_t` richten sich nach der Implementierungsumgebung, und ein Wire-Format als kumuliertes vorzeichenbehaftetes int64 in Nanosekunden aus beiden Membern wird nicht definiert.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) rechnet einen Tag als genau 86.400 Sekunden.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` von [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) speichert die Nanosekunden seit der Unix-Epoche in einem einzigen `int64`. GEUL fügt diesem physischen Typ nur den TAG und das Big-Endian-16-Bit-WORD-Framing hinzu.
