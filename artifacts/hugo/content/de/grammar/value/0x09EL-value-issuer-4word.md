---
title: "VALUE-ISSUER-4WORD (0x09EL)"
weight: 158
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "text", "decimal", "time"]
summary: "VALUE-ISSUER-4WORD ist ein vom Issuer definiertes Value-Format."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VALUE-ISSUER-4WORD ist ein vom Issuer definiertes Value-Format. Es ist eines der letzten drei Felder des Value-Bereichs, und die Issuer-Breite beträgt 4 WORDs. Das ISSUER-Layout ist bei allen drei Kinds gleich ([Record und TAG WORD](../record.md#issuer-형식-레코드)).

| Eintrag | Wert |
|---|---|
| Name | `VALUE-ISSUER-4WORD` (BIND im Spezifikationsdokument `VALUE-ISSUER-4WORD`) |
| TAG ID | `0x09EL` |
| Codec ID | `0x000009E0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000009E0/` (DECLARE-Ziel `09E0`) |
| Abschnitt | 4 `0100` (Value), Offset im Abschnitt C = 30 |
| Kind | Value · Klassifikation: Issuer-Format |
| TAG WORD | `0000 1001 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Issuer (4 WORDs) und Codec-Nummer (2 WORDs). Das Format bestimmt das Codec-Dokument des Issuers |
| Hugo-Pfad | `value/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1110 LLLL      Codec 0x09EL
[Length-Erweiterungs-TAG]
Issuer            4 WORDs
Codec-Nummer      2 WORDs. Vom Issuer definiert
Payload           Bestimmt das vom Issuer veröffentlichte Codec-Dokument
```

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELDs im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Rohwert 4 WORDs |  |  |
| 2 | `codec` | #3 | Rohwert 2 WORDs |  |  |
| 3 | `payload` | #4 | restliche Rohwert-Bytes (`0xFFFF`) |  |  |

Den Aufbau von `payload` bestimmt das Codec-Dokument des jeweiligen Issuers.

## Interpretation und Gültigkeit {#해석과-유효성}

- GEUL kennt über Length nur die Grenze der Payload. Ein Decoder, der das Format nicht kennt, kennt Kind, Length, Issuer und Codec-Nummer und überspringt den Rest mithilfe von Length.
- Die Interpretation der Payload bestimmt das Codec-Dokument des Issuers. Die derzeit aufgenommenen Value-Issuer-Formate stehen im [Codec-Index](../codec-index.md#value-issuer-형식).
- Der Issuer wird in der kürzesten Breite geschrieben, in die der Wert passt ([Issuer und Veröffentlichung](../issuer.md#issuer-등급)). Sind die oberen 2 WORDs des Issuer-Werts 0, ist er invalid. Dieser Wert wird mit dem 2-WORD-Code ([VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md)) geschrieben.
- Die Codec-Nummer hat 2 WORDs. Der Issuer vergibt sie unabhängig vom Kind innerhalb seines eigenen `codecs/` überschneidungsfrei. Reichen die Nummern nicht aus, wird ein weiterer Issuer beantragt.
- Das Codec-Dokument liegt unter `<Issuer>/codecs/<Codec-Nummer>/` des jeweiligen Issuers ([Veröffentlichungsadresse und Versionsliste](../publishing.md#id-표기)).
- Die Lizenz eines Issuer-Formats bestimmt der jeweilige Issuer ([Issuer und Veröffentlichung](../issuer.md#라이선스)).

## Verwandte Seiten {#관련-페이지}

- [Value — Issuer-Format](_index.md#issuer-형식), [VALUE-ISSUER-2WORD](0x09DL-value-issuer-2word.md), [VALUE-ISSUER-16WORD](0x09FL-value-issuer-16word.md)
- [Record und TAG WORD](../record.md#issuer-형식-레코드), [Issuer und Veröffentlichung](../issuer.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000009E0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000009E000000000
BODY
#1 DECLARE 0x09E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "VALUE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
