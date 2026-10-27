---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS ist ein Value mit einer vorzeichenbehafteten int64-Sekundenzahl seit der Unix-Epoche (Codec 0x22)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS ist eine vorzeichenbehaftete Sekundenzahl seit der Unix-Epoche `1970-01-01T00:00:00Z`. Wie bei den seconds-since-the-Epoch von POSIX gilt jeder Tag als genau 86.400 Sekunden, und Schaltsekunden werden nicht mitgezählt.

## Layout

- Code: direkter Value-Code `0x22`. Familie TIME.
- Für den Austausch industrieller Daten wird derselbe physische Typ fester Breite, vorzeichenbehaftetes int64, verwendet wie bei Arrow `timestamp[s]`.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  insgesamt 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretation und Gültigkeit

- Der gesamte Payload von 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63`~`2^63-1` Sekunden. Negative Werte sind Zeitpunkte (instants) vor der Epoche.
- Auch kleine Werte verwenden stets 4 WORD. Sie dürfen nicht auf die Ganzzahldarstellung mit minimaler WORD-Zahl verkürzt werden.
- Zeitzone, ursprünglicher UTC-Offset, Schaltsekunden-Label und Schaltsekundentabelle werden nicht aufgenommen.

## Länge

- Insgesamt sind es genau 5 WORD aus 1 WORD TAG und 4 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel

- Die Epoche ist der Payload `0000 0000 0000 0000`, insgesamt 5 WORD, `LLLL=0100`.
- 1 Sekunde nach der Epoche ist der Payload `0000 0000 0000 0001`.
- 1 Sekunde vor der Epoche ist der Payload `ffff ffff ffff ffff`.

## Normgrundlage

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) definiert nur die Member `time_t tv_sec` und `long tv_nsec`, aber kein Wire-Format, das die kumulierten Sekunden als vorzeichenbehaftetes int64 serialisiert. Breite und Darstellung von `time_t` richten sich nach der Implementierungsumgebung und sind nicht dasselbe wie die GEUL-Payload-Darstellung.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) definiert die Kalenderentsprechung der Sekunden seit der Epoche und die Regel von 86.400 Sekunden je Tag.
- Das [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) und die maßgebliche [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) definieren den Zeitstempel als 64-Bit-Integer mit Vorzeichen seit einer festen Epoche und unterstützen die Einheit SECOND sowie die Nichtzählung von Schaltsekunden. GEUL fügt diesem physischen Typ nur den TAG und das Big-Endian-16-Bit-WORD-Framing hinzu.
