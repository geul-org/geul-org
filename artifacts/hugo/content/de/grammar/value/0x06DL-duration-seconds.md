---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS ist eine vorzeichenbehaftete verstrichene Zeit in Sekunden ohne Epoche."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DURATION-SECONDS` (Spezifikationsdokument BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000006D0/` (DECLARE-Ziel `06D0`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 13 |
| Kind | Value · Familie: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | vorzeichenbehaftete verstrichene Zeit in SI-Sekunden ohne Epoche |
| Hugo-Seite | `value/time/duration-seconds.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | Rohwert 4 WORD |  |  |

DURATION-SECONDS ist eine vorzeichenbehaftete verstrichene Zeit in Sekunden ohne Epoche. Es ist weder ein Instant noch eine kalendarische Monats- oder Jahresspanne.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x06DL`. Familie TIME.
- Es wird derselbe physische Typ fester Breite wie bei Arrow `Duration(SECOND)` verwendet, ein vorzeichenbehafteter int64.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  insgesamt 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Der gesamte Payload mit 4 WORD wird als vorzeichenbehafteter 64-Bit-Zweierkomplement-Count in big-endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^63` bis `2^63-1` Sekunden. Das Vorzeichen ist die Richtung des Verstreichens und zeigt nicht auf einen Instant einer bestimmten Epoche.
- Auch kleine Werte verwenden immer 4 WORD.

## Länge {#길이}

- Die Gesamtzahl ist genau 5 WORD aus 1 WORD TAG und 4 WORD Payload, mit der direkten Länge `LLLL=0100`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 4 WORD, wird abgelehnt.

## Beispiel {#예시}

- 0 Sekunden ist der Payload `0000 0000 0000 0000`, insgesamt 5 WORD, `LLLL=0100`.
- 1 Sekunde ist der Payload `0000 0000 0000 0001`.
- -1 Sekunde ist der Payload `FFFF FFFF FFFF FFFF`.

## Normative Grundlage {#표준-근거}

- Das [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) bestimmt `Schema.fbs` als maßgebliche Quelle der Arrow-Standarddatentypen.
- In der maßgeblichen [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) von Arrow ist `Duration` eine kalenderunabhängige absolute verstrichene Zeit, unterstützt die Einheit SECOND und wird immer als 8-Byte-Ganzzahl mit Vorzeichen dargestellt. GEUL fügt dem nur den TAG und das big-endian-16-Bit-WORD-Framing hinzu.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x000006D0/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
