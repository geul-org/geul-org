---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS ist die Anzahl der signed Nanosekunden seit der Unix-Epoche 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS ist die Anzahl der signed Nanosekunden seit der Unix-Epoche `1970-01-01T00:00:00Z`. Wie bei den Seconds since the Epoch von POSIX gilt jeder Tag als genau 86.400 Sekunden, und Schaltsekunden werden nicht gezählt.

## Layout {#레이아웃}

- Code: Value `VALUE-ISSUER-2WORD` (`0x09DL`), Issuer `0x0000000D` IEEE, Codec-Nummer `0x00004000`. Familie TIME.
- Für den Austausch von Industriedaten wird derselbe physische signed-int64-Typ fester Breite wie bei Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` verwendet.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  insgesamt 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Codec-Nummer      2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Alle 4 WORD des Payloads werden als signed Count im 64-Bit-Zweierkomplement in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63` bis `2^63-1` ns, und der Instant-Bereich ist `1677-09-21 00:12:43.145224192Z` bis `2262-04-11 23:47:16.854775807Z`.
- Auch kleine Werte belegen stets 4 WORD. Sie dürfen nicht auf eine minimale WORD-Ganzzahldarstellung verkürzt werden.
- Zeitzone, ursprünglicher UTC-Offset, Schaltsekunden-Label und Leap-Second-Tabelle werden nicht aufgenommen.

## Länge {#길이}

- Die Gesamtlänge ist genau 9 WORD: 1 WORD TAG, 2 WORD Issuer, 2 WORD Codec-Nummer und 4 WORD Payload; verwendet wird die direkte Länge `LLLL=1000`. Length-Erweiterungs-TAG, Descriptor und Padding gibt es nicht.
- Hat der Payload nicht genau 4 WORD, wird er abgelehnt.

## Beispiel {#예시}

- Die Epoche ist der Payload `0000 0000 0000 0000`, insgesamt 9 WORD, `LLLL=1000`.
- 1 ns nach der Epoche ist der Payload `0000 0000 0000 0001`.
- 1 ns vor der Epoche ist der Payload `FFFF FFFF FFFF FFFF`.

## Normgrundlage {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) definiert die Member `time_t tv_sec` und `long tv_nsec` sowie `0 <= tv_nsec < 10^9`. Konkrete Breite und Darstellung von `time_t` hängen von der Implementierungsumgebung ab, und ein Wire Format als akkumuliertes Nanosekunden-signed-int64 aus beiden Membern wird nicht definiert.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) rechnet jeden Tag mit genau 86.400 Sekunden.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` der [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) speichert die Nanosekunden seit der Unix-Epoche als einzelnes `int64`. GEUL fügt diesem physischen Typ nur den TAG und das Big-Endian-16-Bit-WORD-Framing hinzu.
