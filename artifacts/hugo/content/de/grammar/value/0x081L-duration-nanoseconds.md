---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS ist eine vorzeichenbehaftete Zeitspanne in Nanosekunden ohne Epoche."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS ist eine vorzeichenbehaftete Zeitspanne in Nanosekunden ohne Epoche. Sie ist weder ein Instant noch eine Kalenderspanne in Monaten oder Jahren.

| Eintrag | Wert |
|---|---|
| Name | `DURATION-NANOSECONDS` (BIND im Spezifikationsdokument `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000810/` (DECLARE-Ziel `0810`) |
| Abschnitt | 4 `0100` (Value), Offset im Abschnitt C = 1 |
| Kind | Value · Familie: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Vorzeichenbehaftete Zeitspanne in Nanosekunden ohne Epoche |
| Hugo-Pfad | `value/time/duration-nanoseconds.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | Rohwert 4 WORDs |  |  |

## Layout {#레이아웃}

- Code: direkter Value-Code `0x081L`. Familie TIME.
- Verwendet wird derselbe physische Typ fester Breite wie bei Arrow `Duration(NANOSECOND)`, ein signed int64.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  insgesamt 5 WORDs
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Alle 4 Payload-WORDs werden als 64-Bit-Zweierkomplement-Zähler mit Vorzeichen in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63`~`2^63-1` ns. Das Vorzeichen ist die Richtung der Zeitspanne und verweist nicht auf einen Instant einer bestimmten Epoche.
- Auch kleine Werte verwenden stets 4 WORDs.

## Länge {#길이}

- Die Gesamtlänge ist die Summe aus TAG (1 WORD) und Payload (4 WORDs), also genau 5 WORDs, mit direkter Länge `LLLL=0100`. Length-Erweiterungs-TAG, descriptor und padding gibt es nicht.
- Ist die Payload nicht genau 4 WORDs, wird der Wert abgelehnt.

## Beispiel {#예시}

- 0 ns ist die Payload `0000 0000 0000 0000`, insgesamt 5 WORDs, `LLLL=0100`. Das Ganze ist `0814 0000 0000 0000 0000`.
- 1 ns ist die Payload `0000 0000 0000 0001`.
- -1 ns ist die Payload `FFFF FFFF FFFF FFFF`.

## Normative Grundlage {#표준-근거}

- Das [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) bestimmt `Schema.fbs` zur maßgeblichen Quelle der Standard-Datentypen von Arrow.
- Im maßgeblichen [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) von Arrow ist `Duration` eine kalenderunabhängige absolute Zeitspanne, die die Einheit NANOSECOND unterstützt und stets als 8-Byte-Ganzzahl mit Vorzeichen dargestellt wird. GEUL fügt dem nur TAG und das Big-Endian-16-Bit-WORD-Framing hinzu.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000810/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
