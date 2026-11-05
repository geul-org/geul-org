---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS stellt eine bürgerliche Uhrzeit ohne Datum als Anzahl der Nanosekunden nach Mitternacht dar."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `CIVIL-TIME-NANOSECONDS` (Spezifikationsdokument BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000006B0/` (DECLARE-Ziel `06B0`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 11 |
| Kind | Value · Familie: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | Unsigned-Nanosekunden-Zählung nach Mitternacht des bürgerlichen Tages |
| Hugo-Seite | `value/time/civil-time-nanoseconds.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | Rohwert 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS stellt eine bürgerliche Uhrzeit ohne Datum als Anzahl der Nanosekunden nach Mitternacht dar.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x06BL`. Familie TIME.
- Es wird derselbe physische Typ fester Breite wie bei Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)` verwendet, ein vorzeichenbehafteter int64.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  insgesamt 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Der gesamte Payload mit 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in big-endian-WORD-Reihenfolge gelesen.
- Der physische Typ ist ein vorzeichenbehafteter int64, aber der gültige Bereich ist `0 <= value < 86,400×10^9` ns. Negative Werte und Werte ab der Obergrenze werden abgelehnt.
- `24:00` und Schaltsekunden-Label sind nicht zulässig. Auch Datum, Zeitzone und UTC-Offset werden nicht aufgenommen.
- Auch kleine Werte verwenden immer 4 WORD.

## Länge {#길이}

- Die Gesamtzahl ist genau 5 WORD aus 1 WORD TAG und 4 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel {#예시}

- Mitternacht ist der Payload `0000 0000 0000 0000`, insgesamt 5 WORD, `LLLL=0100`.
- 1 ns nach Mitternacht ist der Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns entspricht der Obergrenze und ist daher ungültig.
- `FFFF FFFF FFFF FFFF` ist als vorzeichenbehafteter int64 gleich -1 und daher ungültig.

## Normative Grundlage {#표준-근거}

- `TIME(isAdjustedToUTC=false, unit=NANOS)` in den [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) speichert die Nanosekunden nach Mitternacht der Ortszeit in einem `int64` und verwendet die Vorzeichenordnung.
- Das [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) definiert in der maßgeblichen [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) NANOSECOND Time als 64-Bit-Ganzzahl mit Vorzeichen, beschränkt den gültigen Bereich auf weniger als 86.400 Sekunden einschließlich Mitternacht und lässt keine Schaltsekunden zu. GEUL fügt nur den TAG und das big-endian-16-Bit-WORD-Framing hinzu.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x000006B0/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
