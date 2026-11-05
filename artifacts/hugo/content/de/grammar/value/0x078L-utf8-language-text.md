---
title: "UTF8-LANGUAGE-TEXT (0x078L·0x079L)"
weight: 120
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "UTF8-LANGUAGE-TEXT ist ein Text mit Sprachangabe, der einen Sprach-Value-Record und UTF-8-Text in einem Value enthält (Codec 0x078L/0x079L)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UTF8-LANGUAGE-TEXT ist ein Text mit Sprachangabe, der einen Sprach-Value-Record und UTF-8-Text in einem Value enthält (Codec 0x078L/0x079L).

| Eintrag | Wert |
|---|---|
| Name | `UTF8-LANGUAGE-TEXT` (gerade/ungerade Paarung. Die Namen je Code stehen in der Mitgliedertabelle unten) |
| TAG ID | `0x078L`·`0x079L` |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 24~25 |
| Kind | Value · Familie: TEXT |
| Indexbeschreibung | Text mit Sprachangabe. Ein Sprach-Value-Record (LANGUAGE-SHORT-CODE oder LANGUAGE-BCP47-CODE) und UTF-8-Bytes. Gerade/ungerade bezieht sich auf die Textbytes |
| Hugo-Pfad | `value/text/utf8-language-text.md` |

## Mitglieder {#구성원}

Diese Seite behandelt die zwei Codes einer gerade/ungerade-Paarung gemeinsam. Der gerade Code gilt für Werte mit gerader Byteanzahl, der ungerade Code für Werte mit ungerader Byteanzahl ([Record und TAG WORD](../record.md#가변-길이-바이트열)). Es gibt ein Codec-Dokument je Code. Die Felder beider Codec-Dokumente sind gleich; nur das DECLARE-Ziel und der Name (BIND) unterscheiden sich.

| TAG ID | Name | Byteanzahl | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x078L` | `UTF8-LANGUAGE-TEXT-EVEN` | gerade | `0x00000780` | `0x00000000/codecs/0x00000780/` | `0000 0111 1000 LLLL` |
| `0x079L` | `UTF8-LANGUAGE-TEXT-ODD` | ungerade | `0x00000790` | `0x00000000/codecs/0x00000790/` | `0000 0111 1001 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `language` | #2 | Record | `07A0` LANGUAGE-SHORT-CODE, `0760` LANGUAGE-BCP47-CODE-EVEN, `0770` LANGUAGE-BCP47-CODE-ODD |  |
| 2 | `bytes` | #3 | restliche Rohwert-Bytes (`0xFFFF`) |  |  |

UTF8-LANGUAGE-TEXT ist ein Text mit Sprachangabe. Er enthält einen Sprach-Value-Record und eine UTF-8-Bytefolge in einem Value.

[UTF8-TEXT](0x072L-utf8-text.md) ist eine Zeichenkette ohne Sprache (Bezeichner, Code, Dateiname, Original-Bytes); dieses Format dagegen ist ein Text mit Sprache (Name, Titel, Motto, Satz). Beide sind verschiedene Werte, auch wenn die Bytes gleich sind. „Paris“ (Zeichenkette) und „Paris“ (Französisch) sind nicht dasselbe. Das entspricht der Trennung von `xsd:string` und `rdf:langString` in RDF.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x078L` (Text mit geraden Bytes) und `0x079L` (Text mit ungeraden Bytes). Familie TEXT.

```
TAG WORD          0000 0111 100P LLLL      Codec 0x078L/0x079L (P = Text hat ungerade Bytes)
[Length-Erweiterungs-TAG] bei insgesamt 15 WORDs oder mehr
Language          1 Value-Record LANGUAGE-SHORT-CODE oder LANGUAGE-BCP47-CODE (einschließlich TAG)
Text WORD 1st ... Nth             UTF-8 bytes / bei ungerader Anzahl letztes 0x00
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Payload beginnt mit einem Sprach-Record. Das erste WORD der Payload wird als TAG gelesen; der Bereich seiner Length ist der Sprach-Record, der Rest sind die Textbytes. Der Sprach-Record ist Pflicht. Gibt es keine Sprache, wird nicht dieses Format, sondern UTF8-TEXT verwendet.
- Der Sprach-Record ist genau ein vollständiger Record [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) (`0x07AL`) oder [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md) (`0x076L`·`0x077L`). Ein anderer Codec oder ein unvollständiger Record ist invalid. Die Gültigkeit des Sprach-Records richtet sich nach den Regeln seines Formats.
- Beide Sprachformate sind zulässig. Die Regel zum Vergleich, ob es dieselbe Sprache ist, entspricht der von [LABEL](../edge/0x0A4L-label.md). Ein SHORT-CODE und das BCP-47-Tag, das das Registry an diese Nummer bindet, bezeichnen dieselbe Sprache.
- `zxx` (kein sprachlicher Inhalt) wird nicht verwendet. Eine solche Zeichenkette ist UTF8-TEXT. `und` (Sprache unbestimmt) und `mul` (mehrere Sprachen) sind Texte mit Sprache und dürfen daher verwendet werden.
- Die Textbytes folgen denselben Regeln wie UTF8-TEXT. Sie müssen wohlgeformtes UTF-8 sein, ein führendes U+FEFF wird als Zeichen akzeptiert, eine Normalisierung wird nicht erzwungen, und der Originaltext bleibt unverändert erhalten. Wer vergleicht oder indiziert, gleicht auf NFC ab.
- Die Anzahl der Textbytes ist `2 × (Anzahl der Payload-WORDs − Anzahl der WORDs des Sprach-Records) − P`. P (niedrigstwertiges Bit des Codecs) gibt nur die Parität der Textbytes an. Bei ungerader Anzahl muss das untere Byte des letzten WORDs `00` sein.
- Ein leerer Text (0 Bytes) besteht beim geraden Code nur aus dem Sprach-Record.

## Verwendung {#쓰는-곳}

- Monolingualtext-Werte aus Wikidata: `{"text":"Bundesrepublik Deutschland","language":"de"}` wird zu genau einem Wert dieses Formats. Er geht unverändert in das Object eines [TRIPLE](../edge/0x0AAL-triple.md) und in den Value eines [QUALIFIER](../edge/0x0ABL-qualifier.md). Property, rank und qualifier übernimmt das TRIPLE.
- Object von [LABEL](../edge/0x0A4L-label.md) und [ALIAS](../edge/0x0A5L-alias.md). Dieser eine Wert enthält Name und Sprache.
- Texte mit festgelegter Sprache, etwa Titel von Gesetzen und Aufsätzen.

## Zuordnung von Sprachcodes (Wikidata) {#언어-코드-대응-위키데이터}

- Nicht alle Sprachcodes von Wikidata und Wikimedia sind BCP 47 (z. B. `simple`, `map-bms`). Sie werden über eine Zuordnungstabelle in BCP-47-Tags überführt. Codes, die sich nicht überführen lassen, werden je nach Verwendung unterschiedlich behandelt.
  - Werte (Monolingualtext): Der Originaltext des datavalue bleibt als UTF8-TEXT erhalten. Der Wert ist Teil der Aussage, und sein Verwerfen würde die Aussage ändern.
  - Labels, Beschreibungen, Aliasse: Sie werden übersprungen und im Bericht vermerkt. Diese Edges bestehen nur mit Sprache (Text ohne Sprache ist invalid), und der Originaltext bleibt in den Quelldaten.
- Hat das überführte Tag im GEUL Language Registry eine Nummer, wird LANGUAGE-SHORT-CODE verwendet, sonst LANGUAGE-BCP47-CODE.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORDs aus TAG (1 WORD), Length-Erweiterungs-TAG (falls vorhanden), Sprach-Record und Text-WORDs. Bis 14 WORDs wird die direkte Länge verwendet, ab 15 WORDs die erweiterte Länge ([Length](../record.md)).
- Der Sprach-Record hat bei SHORT-CODE 2 WORDs, bei BCP 47 `ceil(Tag-Bytes/2) + 1` WORDs (`de` 2 WORDs, `zh-Hant` 5 WORDs).

## Beispiel {#예시}

Alle Sprachen sind Beispiele im Format LANGUAGE-BCP47-CODE. `fr`, `ko` und `de` haben Registry-Nummern und können auch als SHORT-CODE (2 WORDs) geschrieben werden.

| Wert | Textbytes | Gesamt-WORDs |
|---|---|---|
| "Paris" (fr) | 5 (ungerade) | `0795 0761 6672 5061 7269 7300` |
| "" (ko) | 0 | `0782 0761 6B6F` |
| "Bundesrepublik Deutschland" (de) | 26 (gerade) | `078E 0011 0761 6465 4275 6E64 6573 7265 7075 626C 696B 2044 6575 7473 6368 6C61 6E64` |

- „Paris“: TAG `0795` (Codec `0x079L`, `LLLL=0101`, insgesamt 6 WORDs), Sprache `0761 6672` (BCP 47 `fr`), Text `5061 7269 7300` (5 Bytes, letztes `00`).
- Das dritte Beispiel hat insgesamt 17 WORDs und verwendet daher die Length-Erweiterung (`LLLL=1110` in `078E`, Erweiterungs-TAG `0011`).

## Normative Grundlage {#표준-근거}

- Sprach-Tag: [RFC 5646 (BCP 47)](https://www.rfc-editor.org/rfc/rfc5646). `zxx`, `und` und `mul` sind Sonderkodes der IANA Language Subtag Registry.
- Text: [RFC 3629](https://www.rfc-editor.org/rfc/rfc3629).
- Unterscheidung zwischen Zeichenkette und Text mit Sprache: [RDF 1.1 Concepts — language-tagged string](https://www.w3.org/TR/rdf11-concepts/#dfn-language-tagged-string).

## Offene Probleme {#열린-문제}

- Die Prüfung der BCP-47-Tag-Grammatik im Schema. Derzeit wird nur geprüft, dass es ASCII und nicht leer ist.

## Verwandte Seiten {#관련-페이지}

- [Value](_index.md), [UTF8-TEXT](0x072L-utf8-text.md), [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](0x076L-language-bcp47-code.md), [LABEL](../edge/0x0A4L-label.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000780/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000078000000000
BODY
#1 DECLARE 0x0780
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "UTF8-LANGUAGE-TEXT-EVEN"
#5 BIND #2 "language"
#6 BIND #3 "bytes"
#7 CODEC #2 0x07A0
#8 CODEC #2 0x0760
#9 CODEC #2 0x0770
```

Oben steht das Codec-Dokument von `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`). Das Codec-Dokument des anderen Mitglieds (`UTF8-LANGUAGE-TEXT-ODD`) unterscheidet sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im unter `#1` gebundenen Namen (BIND).
