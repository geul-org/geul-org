---
title: "OPAQUE-BYTES (0x07EL·0x07FL)"
weight: 126
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "binary"]
summary: "OPAQUE-BYTES ist eine beliebige Bytefolge, deren Bedeutung und Format von diesem Format selbst nicht festgelegt werden."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

OPAQUE-BYTES ist eine beliebige Bytefolge, deren Bedeutung und Format von diesem Format selbst nicht festgelegt werden. Die direkten Value-Codes sind `0x07EL` (gerade Bytes) und `0x07FL` (ungerade Bytes), die Familie BINARY. Die Byteanzahl ergibt sich aus dem niedrigstwertigen Bit des Codecs und der Anzahl der Payload-WORDs. Sie ist `2 × Anzahl der Payload-WORDs − niedrigstwertiges Bit`; einen Byte Count gibt es nicht ([Value](_index.md)).

| Eintrag | Wert |
|---|---|
| Name | `OPAQUE-BYTES` (gerade/ungerade Paarung. Die Namen je Code stehen in der Mitgliedertabelle unten) |
| TAG ID | `0x07EL`·`0x07FL` |
| Abschnitt | 3 `0011` (Value), Offset im Abschnitt C = 30~31 |
| Kind | Value · Familie: BINARY |
| Indexbeschreibung | Bytefolge mit unbekannter Bedeutung und unbekanntem Format. Gerade/ungerade Bytes |
| Hugo-Pfad | `value/binary/opaque-bytes.md` |

## Mitglieder {#구성원}

Diese Seite behandelt die zwei Codes einer gerade/ungerade-Paarung gemeinsam. Der gerade Code gilt für Werte mit gerader Byteanzahl, der ungerade Code für Werte mit ungerader Byteanzahl ([Record und TAG WORD](../record.md#가변-길이-바이트열)). Es gibt ein Codec-Dokument je Code. Die Felder beider Codec-Dokumente sind gleich; nur das DECLARE-Ziel und der Name (BIND) unterscheiden sich.

| TAG ID | Name | Byteanzahl | Codec ID | Spezifikationsdokument | TAG WORD |
|---|---|---|---|---|---|
| `0x07EL` | `OPAQUE-BYTES-EVEN` | gerade | `0x000007E0` | `0x00000000/codecs/0x000007E0/` | `0000 0111 1110 LLLL` |
| `0x07FL` | `OPAQUE-BYTES-ODD` | ungerade | `0x000007F0` | `0x00000000/codecs/0x000007F0/` | `0000 0111 1111 LLLL` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `bytes` | #2 | restliche Rohwert-Bytes (`0xFFFF`) |  |  |

## Layout {#레이아웃}

```
TAG WORD          0000 0111 111P LLLL      Codec 0x07EL/0x07FL
[Length-Erweiterungs-TAG] bei insgesamt 15 WORDs oder mehr
Payload WORD 1st ... Nth   Bytes / am Ende Zero Padding
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Aus der Payload werden der Reihe nach so viele Bytes gelesen, wie die Byteanzahl angibt. Innerhalb eines WORDs steht das obere Byte zuerst.
- Die Anzahl der Payload-WORDs ist `ceil(Byteanzahl/2)`. Ist der Code ungerade und das untere Byte des letzten WORDs nicht `00`, wird der Wert abgelehnt.
- Passen gerader/ungerader Code, Anzahl der Payload-WORDs und Zero Padding nicht zusammen, wird der Wert abgelehnt.

## Formatstatus {#형식-지위}

- Das gerade/ungerade Codepaar (`0x07EL` gerade, `0x07FL` ungerade), die Anordnung der Payload und das Zero Padding des letzten WORDs sind nicht aus einem externen Industriestandard übernommen, sondern ein GEUL-eigenes Framing.

## Länge {#길이}

- Die Gesamtlänge ist die Summe der WORDs aus TAG (1 WORD), Length-Erweiterungs-TAG (falls vorhanden) und Payload. Bis 14 WORDs wird die direkte Länge verwendet, ab 15 WORDs die erweiterte Länge `1110`·`1111`; auch der Erweiterungs-TAG zählt zur Gesamtanzahl ([Record und TAG WORD](../record.md)).
- 0 Bytes werden als Record des geraden Codes (`0x07EL`) mit 1 WORD (nur das TAG WORD) geschrieben ([Value](_index.md)).

## Beispiel {#예시}

Die Bytes `AB CD EF` sind 3 Bytes (ungerade) und damit `OPAQUE-BYTES-ODD` (`0x07FL`), Payload `ABCD EF00`. Insgesamt sind es 3 WORDs, also `LLLL=0010`.

```
07F2 ABCD EF00
```

Die leere Bytefolge ist `07E0` (`OPAQUE-BYTES-EVEN`, nur das TAG WORD) mit 1 WORD.

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000007E0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000007E000000000
BODY
#1 DECLARE 0x07E0
#2 FIELD #1 rest
#3 BIND #1 "OPAQUE-BYTES-EVEN"
#4 BIND #2 "bytes"
```

Oben steht das Codec-Dokument von `OPAQUE-BYTES-EVEN` (`0x07EL`). Das Codec-Dokument des anderen Mitglieds (`OPAQUE-BYTES-ODD`) unterscheidet sich nur in der Codec ID der DOC-ID, im DECLARE-Ziel und im unter `#1` gebundenen Namen (BIND).
