---
title: "LANGUAGE-BCP47-CODE (0x076L·0x077L)"
weight: 118
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text"]
summary: "LANGUAGE-BCP47-CODE ist ein Value, der ein vollständiges BCP-47-Language-Tag als ASCII-Bytefolge enthält."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LANGUAGE-BCP47-CODE ist ein Value, der ein vollständiges BCP-47-Language-Tag als ASCII-Bytefolge enthält. Er verwendet das Codepaar 0x076L/0x077L für gerade und ungerade Bytes.

| Eintrag | Wert |
|---|---|
| Name | `LANGUAGE-BCP47-CODE` (gerade/ungerade Paarung. Die Namen je Code stehen in der Mitgliedertabelle unten) |
| TAG ID | `0x076L`·`0x077L` |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 22~23 |
| Kind | Value · Familie: TEXT |
| Indexbeschreibung | ASCII-Bytefolge eines vollständigen BCP-47-Language-Tags in kanonischer Groß-/Kleinschreibung. Gerade/ungerade Bytes |
| Hugo-Pfad | `value/text/language-bcp47-code.md` |

## Mitglieder {#구성원}

Diese Seite behandelt die zwei Codes einer gerade/ungerade-Paarung gemeinsam. Der gerade Code gilt für Werte mit gerader Byteanzahl, der ungerade Code für Werte mit ungerader Byteanzahl ([Record und TAG WORD](../record.md#가변-길이-바이트열)). Es gibt ein Codec-Dokument je Code. Die Felder beider Codec-Dokumente sind gleich; nur das DECLARE-Ziel und der Name (BIND) unterscheiden sich.

| TAG ID | Name | Byteanzahl | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x076L` | `LANGUAGE-BCP47-CODE-EVEN` | gerade | `0x00000760` | `0x00000000/codecs/0x00000760/` | `0000 0111 0110 LLLL` |
| `0x077L` | `LANGUAGE-BCP47-CODE-ODD` | ungerade | `0x00000770` | `0x00000000/codecs/0x00000770/` | `0000 0111 0111 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restliche Rohwert-Bytes (`0xFFFF`) |  |  |

LANGUAGE-BCP47-CODE ist ein Value, der ein vollständiges BCP-47-Language-Tag enthält. Er wird verwendet, wenn eine Sprache bis hin zu script, region und variant genau angegeben werden soll.

## Layout {#레이아웃}

- Code: direkter Value-Code `0x076L` (gerade Bytes) und `0x077L` (ungerade Bytes). Familie TEXT.
- Die Byteanzahl ergibt sich aus dem niedrigstwertigen Bit des Codecs und der Anzahl der Payload-WORDs. Sie ist `2 × Anzahl der Payload-WORDs − niedrigstwertiges Bit`; einen Byte Count gibt es nicht ([Value](_index.md)).
- Die Payload ist kein UTF-8-Text, sondern die ASCII-Bytefolge des BCP-47-Tags.

```
TAG WORD          0000 0111 011P LLLL      Codec 0x076L/0x077L
[Length-Erweiterungs-TAG] bei insgesamt 15 WORDs oder mehr
Payload WORD 1st ... Nth          BCP 47 tag bytes / final zero padding
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Bytefolge muss ein wohlgeformtes BCP-47-Language-Tag nach RFC 5646 sein. Eine leere Zeichenkette ist nicht erlaubt.
- Die Payload verwendet nur ASCII-Buchstaben, Ziffern und das Hyphen-Minus `-`. Das Trennzeichen ist zwingend ASCII `-`; `_`, Leerzeichen und Nicht-ASCII-Zeichen sind nicht erlaubt.
- Der Vergleich von BCP-47-Tags unterscheidet nicht zwischen Groß- und Kleinschreibung. Das kanonische Profil von GEUL verwendet als Trennzeichen durchgehend `-` und serialisiert die Subtags language, extlang, variant, extension und private-use in Kleinbuchstaben, script in Titlecase und region in Großbuchstaben.
- Wohlgeformtheit allein genügt nicht. Die Gültigkeit von registered Subtags und Grandfathered Tags wird anhand eines bestimmten Snapshots der IANA Language Subtag Registry beurteilt; das Datum dieses Snapshots oder die Version des Registrys ist mitzubewahren.
- Private-use-Tags und private-use-Subtags sind erlaubt, wenn sie nach der Grammatik von RFC 5646 wohlgeformt sind. Ihre Bedeutung hängt jedoch von der Vereinbarung der Beteiligten ab und wird nicht von der IANA Registry definiert, sodass sie keine allgemeine Interoperabilität garantieren.
- Hat ein deprecated Subtag oder Grandfathered Tag im selben Snapshot einen Preferred-Value, verwendet die kanonische GEUL-Form diesen Ersatzwert in kanonischer Groß-/Kleinschreibung. Ein Tag in der deprecated Schreibweise kann als Eingabe interpretiert werden, ist aber keine kanonische Speicherform.
- Da BCP 47 ein ASCII-Profil ist, gilt die Anforderung einer Unicode-Normalisierung wie UTF-8 NFC nicht.
- Innerhalb eines WORDs steht das obere Byte zuerst. Bei ungerader Byteanzahl (ungerader Code) muss das ungenutzte untere Byte des letzten WORDs `00` sein.
- Die Anzahl der Payload-WORDs ist `ceil(Byteanzahl/2)`. Ist der Code ungerade und das untere Byte des letzten WORDs nicht `00`, wird der Wert abgelehnt.

## Normative Grundlage {#표준-근거}

- Die Grammatik von Language-Tags, die Interpretation ohne Unterscheidung von Groß- und Kleinschreibung sowie die Konzepte deprecated/Preferred-Value folgen [RFC 5646, Tags for Identifying Languages](https://www.rfc-editor.org/rfc/rfc5646).
- Die Registry, anhand derer die Gültigkeit eines Tags beurteilt wird, ist die [IANA Language Subtag Registry](https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry).
- Das gerade/ungerade Codepaar, das Zero Padding, die Speicherrichtlinie für die kanonische Groß-/Kleinschreibung und die Length-Berechnung sind Framing-Regeln von GEUL.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORDs aus TAG (1 WORD), Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORDs wird die direkte Länge verwendet, ab 15 WORDs die erweiterte Länge `1110`·`1111`; auch der Erweiterungs-TAG zählt zur Gesamtanzahl ([Length](../record.md)).

## Beziehung zu LANGUAGE-SHORT-CODE {#language-short-code와의-관계}

- Ein Tag, das im GEUL Language Registry eine Nummer hat, kann als [LANGUAGE-SHORT-CODE](0x07AL-language-short-code.md) mit 1 WORD geschrieben werden.
- Ein Tag ohne Nummer im Registry (einschließlich Tags mit extension oder private-use) wird als LANGUAGE-BCP47-CODE geschrieben. Auch wenn der Originaltext des vollständigen Tags bewahrt werden muss, wird LANGUAGE-BCP47-CODE verwendet.
- Der SHORT-CODE `n` und der LANGUAGE-BCP47-CODE des Tags, das das Registry an `n` bindet (ohne Beachtung der Groß-/Kleinschreibung), bezeichnen dieselbe Sprache.

## Beispiel {#예시}

- `ko-KR` hat 5 ASCII-Bytes (ungerade) und ist daher `LANGUAGE-BCP47-CODE-ODD` (`0x077L`); die Payload ist `6B6F 2D4B 5200`.
- TAG (1 WORD) und Payload (3 WORDs) ergeben insgesamt 4 WORDs, `LLLL=0011`. Das Ganze ist `0773 6B6F 2D4B 5200`.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000760/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000076000000000
BODY
#1 DECLARE 0x0760
#2 FIELD #1 rest
#3 BIND #1 "LANGUAGE-BCP47-CODE-EVEN"
#4 BIND #2 "bytes"
```

Oben steht das Codec-Dokument von `LANGUAGE-BCP47-CODE-EVEN` (`0x076L`). Das Codec-Dokument des anderen Mitglieds (`LANGUAGE-BCP47-CODE-ODD`) unterscheidet sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im unter `#1` gebundenen Namen (BIND).
