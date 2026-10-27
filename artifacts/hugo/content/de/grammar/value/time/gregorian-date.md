---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE ist ein Value mit einer vorzeichenbehafteten int32-Tageszahl, bei der das proleptische gregorianische 1970-01-01 der Tag 0 ist (Codec 0x20)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE ist eine vorzeichenbehaftete Tageszahl, bei der das proleptische gregorianische `1970-01-01` der Tag 0 ist. Zeitzone und Tageszeit werden nicht aufgenommen.

## Layout

- Code: direkter Value-Code `0x20`. Familie TIME.
- Es wird derselbe physische Typ fester Breite, vorzeichenbehaftetes int32, verwendet wie bei Arrow Date32 und Parquet `DATE`.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  insgesamt 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretation und Gültigkeit

- Der gesamte Payload von 2 WORD wird als vorzeichenbehafteter 32-Bit-Zweierkomplement-Day-Count in Big-Endian-WORD-Reihenfolge gelesen.
- Der gültige Bereich ist `-2^31`~`2^31-1` Tage. Negative Werte sind Daten vor der Epoche.
- Bei der Rückrechnung des Day-Count in Jahr, Monat und Tag wird der proleptische gregorianische Kalender ohne historische Kalenderumstellung verwendet.
- Auch kleine Werte verwenden stets 2 WORD.

## Länge

- Insgesamt sind es genau 3 WORD aus 1 WORD TAG und 2 WORD Payload, mit der direkten Länge `LLLL=0010`. Es gibt keinen Length-Erweiterungs-TAG, Descriptor oder Padding.
- Ist der Payload nicht genau 2 WORD, wird abgelehnt.

## Beispiel

| Datum | Payload | Gesamte Length |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## Verhältnis zu EDTF

- Gröbere Genauigkeit als der Tag, Unsicherheit/Ungefähres und Intervalle schreibt man mit [EDTF](/de/grammar/value/time/edtf/). Ein Datum, das sich genau als GREGORIAN-DATE schreiben lässt, wird nicht als EDTF geschrieben (kanonische Form von EDTF).

## Normgrundlage

- `DATE` von [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) ist ein `int32`, das die Zahl der Tage seit der Unix-Epoche 1970-01-01 speichert, und verwendet die Vorzeichenreihenfolge.
- Date32 des [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) und der maßgeblichen [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) speichert die Zahl der Tage seit der Unix-Epoche als 32-Bit-Integer mit Vorzeichen.
- Die proleptische gregorianische Rückrechnung ist das von diesem Format übernommene GEUL-Kalenderprofil. Die int32-Day-Count-Bedeutung von Arrow/Parquet bleibt unverändert, und nur der TAG und das Big-Endian-16-Bit-WORD-Framing werden hinzugefügt.
