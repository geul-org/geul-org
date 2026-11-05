---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE ist eine vorzeichenbehaftete Tageszahl, bei der 1970-01-01 im proleptischen gregorianischen Kalender der Tag 0 ist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `GREGORIAN-DATE` (Spezifikationsdokument BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000006A0/` (DECLARE-Ziel `06A0`) |
| Abschnitt | 3 `0011` (Value), Offset C im Abschnitt = 10 |
| Kind | Value · Familie: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Index-Beschreibung | vorzeichenbehaftete Tageszahl bezogen auf `1970-01-01` im proleptischen gregorianischen Kalender |
| Hugo-Seite | `value/time/gregorian-date.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Nr. | Feld (BIND) | FIELD | Breite | Zielformat (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | Rohwert 2 WORD |  |  |

GREGORIAN-DATE ist eine vorzeichenbehaftete Tageszahl, bei der `1970-01-01` im proleptischen gregorianischen Kalender der Tag 0 ist. Zeitzone und Tageszeit werden nicht aufgenommen.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x06AL`. Familie TIME.
- Es wird derselbe physische Typ fester Breite wie bei Arrow Date32 und Parquet `DATE` verwendet, ein vorzeichenbehafteter int32.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  insgesamt 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Der gesamte Payload mit 2 WORD wird als vorzeichenbehafteter 32-Bit-Zweierkomplement-Day-Count in big-endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^31` bis `2^31-1` Tage. Negative Werte sind Daten vor der Epoche.
- Bei der Rückrechnung des Day Count in Jahr, Monat und Tag wird ohne historische Kalenderumstellungen der proleptische gregorianische Kalender verwendet.
- Auch kleine Werte verwenden immer 2 WORD.

## Länge {#길이}

- Die Gesamtzahl ist genau 3 WORD aus 1 WORD TAG und 2 WORD Payload, mit der direkten Länge `LLLL=0010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 2 WORD, wird abgelehnt.

## Beispiel {#예시}

| Datum | Payload | Gesamtlänge |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## Beziehung zu EDTF {#edtf와의-관계}

- Gröbere Genauigkeit als Tage, Unsicherheit und Näherung sowie Intervalle werden mit [EDTF](0x06EL-edtf.md) geschrieben. Ein Datum, das sich exakt mit GREGORIAN-DATE schreiben lässt, wird nicht mit EDTF geschrieben (EDTF-Normalform).

## Normative Grundlage {#표준-근거}

- `DATE` in den [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) ist ein `int32`, das die Tage seit der Unix-Epoche 1970-01-01 speichert, und verwendet die Vorzeichenordnung.
- Date32 im [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) und in der maßgeblichen [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) speichert die Tage seit der Unix-Epoche als 32-Bit-Ganzzahl mit Vorzeichen.
- Die proleptische gregorianische Rückrechnung ist das von diesem Format übernommene GEUL-Kalenderprofil. Die int32-Day-Count-Bedeutung von Arrow/Parquet bleibt unverändert, und nur der TAG und das big-endian-16-Bit-WORD-Framing werden hinzugefügt.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

Das Spezifikationsdokument `0x00000000/codecs/0x000006A0/latest.geul`, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
