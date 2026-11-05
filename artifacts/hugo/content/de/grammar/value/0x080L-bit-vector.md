---
title: "BIT-VECTOR (0x080L)"
weight: 128
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "BIT-VECTOR ist eine rohe Bitfolge mit angegebener Länge."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIT-VECTOR ist eine rohe Bitfolge mit angegebener Länge. Der direkte Value-Code ist `0x080L`, die Familie BINARY. Die ersten 2 Payload-WORDs sind der vorzeichenlose 32-Bit-Bit-Count `N`, danach folgen `ceil(N/16)` WORDs.

| Eintrag | Wert |
|---|---|
| Name | `BIT-VECTOR` (BIND im Spezifikationsdokument `BIT-VECTOR`) |
| TAG ID | `0x080L` |
| Codec ID | `0x00000800` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000800/` (DECLARE-Ziel `0800`) |
| Abschnitt | 4 `0100` (Value), Offset im Abschnitt C = 0 |
| Kind | Value · Familie: BINARY |
| TAG WORD | `0000 1000 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Nach dem Bit-Count N Bits, MSB-first gespeichert |
| Hugo-Pfad | `value/binary/bit-vector.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bit-count` | #2 | Rohwert 2 WORDs |  |  |
| 2 | `bits` | #3 | restliche Rohwert-Bytes (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 1000 0000 LLLL      Codec 0x080L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORDs oder mehr
Payload WORD 1st–2nd       Bit Count N (obere 16 Bit │ untere 16 Bit)
Payload WORD 3rd ... Nth   Payload bits, MSB-first
```

## Interpretation und Gültigkeit {#해석과-유효성}

- `N` ist der Wert, der entsteht, wenn die ersten 2 Payload-WORDs als Big-Endian-Ganzzahl ohne Vorzeichen mit 32 Bit gelesen werden.
- Die Payload-Bits werden vom höchstwertigen Bit jedes WORDs an der Reihe nach gefüllt.
- Die Anzahl der Payload-WORDs ist genau `ceil(N/16)`, und die ungenutzten unteren Bits des letzten WORDs müssen alle 0 sein.
- Bei `N=0` gibt es keine Payload-WORDs. Da die zwei Count-WORDs bereits die Payload bilden, steht das nicht im Widerspruch zur Regel, dass die Payload mindestens 1 WORD hat.

## Formatstatus {#형식-지위}

- Der vorzeichenlose 32-Bit-Bit-Count, die MSB-first-Anordnung und das Zero Padding des letzten WORDs sind nicht aus einem externen Industriestandard übernommen, sondern ein GEUL-eigenes Framing.
- Diese Seite definiert die Darstellung einschließlich der Regeln zu GEUL TAG, Length und 16-Bit-WORD.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORDs aus TAG (1 WORD), Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORDs wird die direkte Länge verwendet, ab 15 WORDs die erweiterte Länge `1110`·`1111`; auch der Erweiterungs-TAG zählt zur Gesamtanzahl ([Record und TAG WORD](../record.md)).

## Beispiel {#예시}

- Ein leerer Bitvektor hat den Count `0000 0000`, keine Payload, insgesamt 3 WORDs, `LLLL=0010`. Das Ganze ist `0802 0000 0000`.
- Die Bitfolge `101` hat den Count `0000 0003`, Payload `A000`, insgesamt 4 WORDs, `LLLL=0011`. Das Ganze ist `0803 0000 0003 A000`.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000800/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000080000000000
BODY
#1 DECLARE 0x0800
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "BIT-VECTOR"
#5 BIND #2 "bit-count"
#6 BIND #3 "bits"
```
