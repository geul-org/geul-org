---
title: "UTF8-TEXT (0x072L·0x073L)"
weight: 114
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-TEXT ist ein Value, der eine UTF-8-Zeichenkette ohne Sprache enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-TEXT ist ein Value, der eine UTF-8-Zeichenkette ohne Sprache enthält. Er verwendet das Codepaar 0x072L/0x073L für gerade und ungerade Bytes.

| Eintrag | Wert |
|---|---|
| Name | `UTF8-TEXT` (gerade/ungerade Paarung. Die Namen je Code stehen in der Mitgliedertabelle unten) |
| TAG ID | `0x072L`·`0x073L` |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 18~19 |
| Kind | Value · Familie: TEXT |
| Indexbeschreibung | Gültige UTF-8-Bytefolge, die keine Normalisierung impliziert. Gerade/ungerade Bytes |
| Hugo-Pfad | `value/text/utf8-text.md` |

## Mitglieder {#구성원}

Diese Seite behandelt die zwei Codes einer gerade/ungerade-Paarung gemeinsam. Der gerade Code gilt für Werte mit gerader Byteanzahl, der ungerade Code für Werte mit ungerader Byteanzahl ([Record und TAG WORD](../record.md#가변-길이-바이트열)). Es gibt ein Codec-Dokument je Code. Die Felder beider Codec-Dokumente sind gleich; nur das DECLARE-Ziel und der Name (BIND) unterscheiden sich.

| TAG ID | Name | Byteanzahl | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x072L` | `UTF8-TEXT-EVEN` | gerade | `0x00000720` | `0x00000000/codecs/0x00000720/` | `0000 0111 0010 LLLL` |
| `0x073L` | `UTF8-TEXT-ODD` | ungerade | `0x00000730` | `0x00000000/codecs/0x00000730/` | `0000 0111 0011 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restliche Rohwert-Bytes (`0xFFFF`) |  |  |

UTF8-TEXT ist ein Value, der eine gültige UTF-8-Bytefolge nach RFC 3629 enthält. Er wird für Zeichenketten ohne Sprache verwendet, etwa Bezeichner, Codes und Dateinamen.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x072L` (gerade Bytes) und `0x073L` (ungerade Bytes). Familie TEXT.
- Die Byteanzahl ergibt sich aus dem niedrigstwertigen Bit des Codecs und der Anzahl der Payload-WORDs. Sie ist `2 × Anzahl der Payload-WORDs − niedrigstwertiges Bit`; einen Byte Count gibt es nicht ([Value](_index.md)).

```
TAG WORD          0000 0111 001P LLLL      Codec 0x072L/0x073L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORDs oder mehr
Payload WORD 1st ... Nth          UTF-8 bytes / final zero padding
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Bytefolge muss wohlgeformtes UTF-8 in kürzester Form nach der Grammatik von RFC 3629 sein. Das Dekodierergebnis enthält nur Unicode Scalar Values im Bereich `U+0000..U+10FFFF` und keine Surrogate im Bereich `U+D800..U+DFFF`.
- Ein U+FEFF am Anfang der Payload (UTF-8-Bytefolge `EF BB BF`) gilt als dasselbe Zeichen wie U+FEFF an anderer Stelle und ist erlaubt. Die in RFC 3629 beschriebene Behandlung eines führenden U+FEFF als Signatur (BOM) findet nicht statt. Es wird weder entfernt noch als Signatur gedeutet, sondern unverändert bewahrt.
- Eine Unicode-Normalisierung wird nicht erzwungen. Die dekodierte Original-Scalar-Sequenz bleibt unverändert erhalten.
- Die gültige UTF-8-Bytefolge wird ohne Umwandlung in die Payload gelegt. Innerhalb eines WORDs steht das obere Byte zuerst. Bei ungerader Byteanzahl (ungerader Code) muss das ungenutzte untere Byte des letzten WORDs `00` sein.
- Die Anzahl der Payload-WORDs ist `ceil(Byteanzahl/2)`. Ist der Code ungerade und das untere Byte des letzten WORDs nicht `00`, wird der Wert abgelehnt.

## Normative Grundlage {#표준-근거}

- Der Scalar-Bereich von UTF-8 und wohlgeformte Bytefolgen folgen [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Das gerade/ungerade Codepaar, das Zero Padding sowie TAG/Length von GEUL und die Anordnung in 16-Bit-WORDs sind die kanonischen Framing-Regeln dieses Formats.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORDs aus TAG (1 WORD), Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORDs wird die direkte Länge verwendet, ab 15 WORDs die erweiterte Länge `1110`·`1111`; auch der Erweiterungs-TAG zählt zur Gesamtanzahl ([Length](../record.md)).
- Eine Zeichenkette mit 0 Bytes wird als Record des geraden Codes mit 1 WORD (nur das TAG WORD) geschrieben ([Value](_index.md)).

## Beispiel {#예시}

- `A` (`41`) hat 1 Byte (ungerade) und damit `UTF8-TEXT-ODD` (`0x073L`), Payload `4100`, insgesamt 2 WORDs, `LLLL=0001`. Das Ganze ist `0731 4100`.
- Die leere Zeichenkette ist `0720` (`UTF8-TEXT-EVEN`, nur das TAG WORD) mit 1 WORD.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000720/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000072000000000
BODY
#1 DECLARE 0x0720
#2 FIELD #1 rest
#3 BIND #1 "UTF8-TEXT-EVEN"
#4 BIND #2 "bytes"
```

Oben steht das Codec-Dokument von `UTF8-TEXT-EVEN` (`0x072L`). Das Codec-Dokument des anderen Mitglieds (`UTF8-TEXT-ODD`) unterscheidet sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im unter `#1` gebundenen Namen (BIND).
