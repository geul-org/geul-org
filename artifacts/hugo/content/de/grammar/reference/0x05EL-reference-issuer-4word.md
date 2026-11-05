---
title: "REFERENCE-ISSUER-4WORD (0x05EL)"
weight: 94
date: 2026-11-03T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "reference", "issuer"]
summary: "REFERENCE-ISSUER-4WORD ist ein vom Issuer definiertes Reference-Format."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REFERENCE-ISSUER-4WORD ist ein vom Issuer definiertes Reference-Format. Es ist einer der letzten drei Plätze des Reference-Bereichs, und die Breite des Issuer beträgt 4 WORD. Das ISSUER-Layout ist bei allen drei Kind gleich ([Record und TAG WORD](../record.md#issuer-형식-레코드)).

| Eintrag | Wert |
|---|---|
| Name | `REFERENCE-ISSUER-4WORD` (Spezifikationsdokument BIND `REFERENCE-ISSUER-4WORD`) |
| TAG ID | `0x05EL` |
| Codec ID | `0x000005E0` |
| Spezifikationsdokument | `0x00000000/codecs/0x000005E0/` (DECLARE-Ziel `05E0`) |
| Abschnitt | 2 `0010` (Reference Sonstige), Offset im Abschnitt C = 30 |
| Kind | Reference · Klasse: Issuer-Format |
| TAG WORD | `0000 0101 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Issuer 4 WORD und Codec-Nummer 2 WORD. Das Format bestimmt das Codec-Dokument des Issuer |
| Hugo-Seite | `reference/reference-issuer.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 0101 1110 LLLL      Codec 0x05EL
[Length-Erweiterungs-TAG]
Issuer            4 WORD
Codec-Nummer      2 WORD. Wird vom Issuer definiert
Payload           Bestimmt das vom Issuer herausgegebene Codec-Dokument
```

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Rohwert 4 WORD |  |  |
| 2 | `codec` | #3 | Rohwert 2 WORD |  |  |
| 3 | `payload` | #4 | restlicher Rohwert (`0xFFFF`) |  |  |

Den Aufbau von `payload` bestimmt das Codec-Dokument dieses Issuer.

## Interpretation und Gültigkeit {#해석과-유효성}

- GEUL kennt über Length nur die Grenze des Payloads. Ein Decoder, der das Format nicht kennt, kennt Kind, Length, Issuer und Codec-Nummer und überspringt den Rest mittels Length.
- Bedeutung der Codec-Nummer, Quantifizierung und was bezeichnet wird, bestimmt das vom Issuer herausgegebene Codec-Dokument. Die gemeinsamen Reference-Regeln wie die kürzeste Breite der Ziel-ID und das Lesen der Quantifizierung gelten nicht ([REFERENCE-ISSUER](_index.md#해석과-유효성)).
- Der Issuer wird in der kürzesten Breite geschrieben, in die der Wert passt ([Issuer und Veröffentlichung](../issuer.md#issuer-등급)). Sind die oberen 2 WORD des Issuer-Werts 0, ist es invalid. Dieser Wert wird mit dem 2-WORD-Code ([REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md)) geschrieben.
- Die Codec-Nummer hat 2 WORD. Der Issuer vergibt sie unabhängig vom Kind so in seinem `codecs/`, dass sie sich nicht überschneidet. Reichen die Nummern nicht aus, lässt man sich einen weiteren Issuer ausstellen.
- Das Codec-Dokument liegt unter `<Issuer>/codecs/<Codec-Nummer>/` dieses Issuer ([Veröffentlichungsadresse und Versionsliste](../publishing.md#id-표기)).
- Die Lizenz eines Issuer-Formats bestimmt dieser Issuer ([Issuer und Veröffentlichung](../issuer.md#라이선스)).

## Verwandte Seiten {#관련-페이지}

- [REFERENCE-ISSUER](_index.md#reference-issuer), [REFERENCE-ISSUER-2WORD](0x05DL-reference-issuer-2word.md), [REFERENCE-ISSUER-16WORD](0x05FL-reference-issuer-16word.md)
- [Record und TAG WORD](../record.md#issuer-형식-레코드), [Issuer und Veröffentlichung](../issuer.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x000005E0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000005E000000000
BODY
#1 DECLARE 0x05E0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "REFERENCE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
