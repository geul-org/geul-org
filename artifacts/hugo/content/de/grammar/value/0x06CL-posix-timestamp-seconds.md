---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS ist die vorzeichenbehaftete Sekundenzahl seit der Unix-Epoche 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `POSIX-TIMESTAMP-SECONDS` (Spezifikationsdokument BIND `POSIX-TIMESTAMP-SECONDS`) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000006C0/` (DECLARE-Ziel `06C0`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 12 |
| Kind | Value · Familie: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | vorzeichenbehaftete Sekundenzählung seit der Unix/POSIX-Epoche |
| Hugo-Seite | `value/time/posix-timestamp-seconds.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | Rohwert 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS ist die vorzeichenbehaftete Sekundenzahl seit der Unix-Epoche `1970-01-01T00:00:00Z`. Wie bei den Seconds Since the Epoch von POSIX hat jeder Tag genau 86.400 Sekunden, und Schaltsekunden werden nicht gezählt.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x06CL`. Familie TIME.
- Für den Austausch industrieller Daten wird derselbe physische Typ fester Breite wie bei Arrow `timestamp[s]` verwendet, ein vorzeichenbehafteter int64.

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  insgesamt 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Der gesamte Payload mit 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in big-endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63` bis `2^63-1` Sekunden. Negative Werte sind Instants vor der Epoche.
- Auch kleine Werte verwenden immer 4 WORD. Sie dürfen nicht auf die Ganzzahldarstellung mit minimaler WORD-Anzahl verkürzt werden.
- Zeitzone, ursprünglicher UTC-Offset, Schaltsekunden-Label und Schaltsekundentabelle werden nicht aufgenommen.

## Länge {#길이}

- Die Gesamtzahl ist genau 5 WORD aus 1 WORD TAG und 4 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel {#예시}

- Die Epoche ist der Payload `0000 0000 0000 0000`, insgesamt 5 WORD, `LLLL=0100`.
- 1 Sekunde nach der Epoche ist der Payload `0000 0000 0000 0001`.
- 1 Sekunde vor der Epoche ist der Payload `FFFF FFFF FFFF FFFF`.

## Normative Grundlage {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) definiert nur die Member `time_t tv_sec` und `long tv_nsec`, nicht aber ein Wire-Format, das die kumulierten Sekunden als vorzeichenbehafteten int64 serialisiert. Breite und Darstellung von `time_t` hängen von der Implementierungsumgebung ab und sind nicht mit der GEUL-Payload-Darstellung identisch.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) definiert die Kalenderentsprechung der Sekunden seit der Epoche und die Regel von 86.400 Sekunden pro Tag.
- Das [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) und die maßgebliche [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) definieren timestamp als 64-Bit-Ganzzahl mit Vorzeichen ab einer festen Epoche und unterstützen die Einheit SECOND sowie die Nichtzählung von Schaltsekunden. GEUL fügt diesem physischen Typ nur den TAG und das big-endian-16-Bit-WORD-Framing hinzu.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x000006C0/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
