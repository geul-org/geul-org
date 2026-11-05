---
title: "UNSIGNED-DECIMAL (0x069L)"
weight: 105
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "UNSIGNED-DECIMAL ist ein Value für eine exakte Dezimalzahl (exact decimal) mit vorzeichenlosem coefficient."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `UNSIGNED-DECIMAL` (Spezifikationsdokument BIND `UNSIGNED-DECIMAL`) |
| TAG ID | `0x069L` |
| Codec ID | `0x00000690` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000690/` (DECLARE-Ziel `0690`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 9 |
| Kind | Value · Familie: DECIMAL |
| TAG WORD | `0000 0110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | `C×10^E` aus vorzeichenbehaftetem Exponenten `E` und Unsigned-coefficient `C` mit minimaler WORD-Anzahl |
| Hugo-Seite | `value/decimal/unsigned-decimal.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | Rohwert 2 WORD |  |  |
| 2 | `coefficient` | #3 | restlicher Rohwert (`0xFFFF`) |  |  |

UNSIGNED-DECIMAL ist ein Value für eine exakte Dezimalzahl (exact decimal) mit vorzeichenlosem coefficient. Direkter Value-Code `0x069L`, Familie DECIMAL. Die ersten 2 WORD des Payload sind der 32-Bit-Dezimalexponent `E` mit Vorzeichen, der Rest ist der Unsigned-coefficient `C` mit minimaler WORD-Anzahl, und der Wert ist `C×10^E`.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 1001 LLLL      Codec 0x069L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORD oder mehr
Payload WORD 1st–2nd (32 Bit)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (ab 1 WORD)    Unsigned Coefficient C
```

## Interpretation {#해석}

- `E` ist eine vorzeichenbehaftete 32-Bit-big-endian-Zweierkomplement-Ganzzahl, beginnend mit dem oberen WORD.
- `C` ist eine Unsigned Magnitude beliebiger Genauigkeit, die aus allen übrigen WORD, beginnend mit dem oberen WORD, gelesen wird.
- `C` folgt derselben Regel der minimalen WORD-Anzahl wie [UNSIGNED-INTEGER](0x062L-unsigned-integer.md). 0 ist `0000`, und bei 2 WORD oder mehr ist ein erstes WORD `0000` verboten.

## Länge und Gültigkeit {#길이와-유효성}

- Die Gesamtzahl ist die Summe der WORD aus 1 WORD TAG, dem Length-Erweiterungs-TAG (falls vorhanden) und dem Payload. Bis 14 WORD wird die direkte Länge verwendet, ab 15 WORD die erweiterte Länge `1110`·`1111`, und auch der Erweiterungs-TAG zählt zur Gesamtzahl ([Record und TAG WORD](../record.md)).
- Der Payload besteht aus 2 WORD Exponent und mindestens 1 WORD coefficient, hat also mindestens 3 WORD.
- Die Kanonizität der Byte-Darstellung prüft nur die Darstellung des coefficient mit minimaler WORD-Anzahl.

## Beispiel {#예시}

| Wertdarstellung | Payload (`E` + `C`) | Beurteilung |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | Byte-Darstellung kanonisch |
| `10×10^-1` | `FFFF FFFF 000A` | Byte-Darstellung kanonisch, die Canonical-Beziehung zur obigen Darstellung ist ein offenes Problem |
| `1×10^0` | `0000 0000 0000 0001` | nicht kanonisch: führendes `0000` im coefficient überflüssig |
| negativer coefficient | nicht zutreffend | invalid |

## Formatstatus {#형식-지위}

- Diese Anordnung, die einen 32-Bit-Exponenten `E` mit Vorzeichen und einen Unsigned-coefficient `C` mit minimaler WORD-Anzahl verbindet, ist ein GEUL-eigenes Format und weder IEEE-754-Decimal-Interchange noch Apache Parquet `DECIMAL`.
- Parquet `DECIMAL` verwendet einen vorzeichenbehafteten unscaled value, `unscaledValue × 10^(-scale)` und obligatorische Metadaten precision/scale; der Byte-Array-Typ ist big-endian Zweierkomplement, und scale ist mindestens 0. Dieses Format ist wegen des Unsigned `C`, des vorzeichenbehafteten `E` und des Fehlens von precision-Metadaten nicht dasselbe Format.
- Für den Austausch mit IEEE-754-Decimal oder Parquet `DECIMAL` ist eine explizite Konvertierung nötig, die Vorzeichen, Bereich, precision/scale, quantum und die Richtlinie für Sonderwerte festlegt.
- Vergleichsgrundlage: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Offene Probleme {#열린-문제}

- Es gibt mehrere Exponent/coefficient-Paare, die dieselbe Zahl darstellen, etwa `10×10^-1` und `1×10^0`.
- Ob dieses Format das quantum bewahrt, wie Wertgleichheit beurteilt wird und wie der canonical exponent normalisiert wird, ist noch nicht festgelegt.
- Daher darf eine Implementierung außerhalb der Regel der minimalen WORD-Anzahl des coefficient keine Normalisierung von Exponent und coefficient willkürlich erzwingen.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x00000690/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000069000000000
BODY
#1 DECLARE 0x0690
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "UNSIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
