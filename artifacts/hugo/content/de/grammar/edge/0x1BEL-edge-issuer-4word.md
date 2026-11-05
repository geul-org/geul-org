---
title: "EDGE-ISSUER-4WORD (0x1BEL)"
weight: 446
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "EDGE-ISSUER-4WORD ist ein vom Issuer definiertes Edge-Format."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EDGE-ISSUER-4WORD ist ein vom Issuer definiertes Edge-Format. Es ist eines der letzten drei Plätze des Edge-Bereichs, und die Issuer-Breite beträgt 4 WORD. Das ISSUER-Layout ist bei allen drei Kind gleich ([Record und TAG WORD](../record.md#issuer-형식-레코드)).

| Eintrag | Wert |
|---|---|
| Name | `EDGE-ISSUER-4WORD` (Spezifikationsdokument BIND `EDGE-ISSUER-4WORD`) |
| TAG ID | `0x1BEL` |
| Codec ID | `0x00001BE0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001BE0/` (DECLARE-Ziel `1BE0`) |
| Abschnitt | 13 `1101` (Edge (letzte 3 Plätze ISSUER)), Offset im Abschnitt C = 30 |
| Kind | Edge · Klassifikation: Issuer-Format |
| TAG WORD | `0001 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Issuer 4 WORD und Codec-Nummer 2 WORD. Das Format legt das Codec-Dokument des Issuer fest |
| Hugo-Seite | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0001 1011 1110 LLLL      Codec 0x1BEL
[Length-Erweiterungs-TAG]
Issuer            4 WORD
Codec-Nummer      2 WORD. Wird vom Issuer definiert
Edge Id           LOCAL-Reference-Record. Erstes Element nach Issuer und Codec-Nummer
Restliche Payload Legt das vom Issuer veröffentlichte Codec-Dokument fest
```

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert. Die Edge Id von EDGE-ISSUER steht nach der Codec-Nummer und vor dem Feld `payload` ([Layout](#레이아웃)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `issuer` | #2 | Rohwert 4 WORD |  |  |
| 2 | `codec` | #3 | Rohwert 2 WORD |  |  |
| 3 | `payload` | #4 | restlicher Rohwert (`0xFFFF`) |  |  |

Den Aufbau von `payload` legt das Codec-Dokument des jeweiligen Issuer fest.

## Interpretation und Gültigkeit {#해석과-유효성}

- GEUL kennt über Length nur die Payload-Grenze. Ein Decoder, der das Format nicht kennt, kennt Kind, Length, Issuer und Codec-Nummer und überspringt den Rest anhand von Length.
- Die Payload beginnt mit der Edge Id (LOCAL Reference) ([Edge](_index.md#레이아웃)). Die Komponenten nach der Edge Id legt das Codec-Dokument des Issuer fest.
- Der Issuer wird in der kürzesten Breite geschrieben, in die der Wert passt ([Issuer und Veröffentlichung](../issuer.md#issuer-등급)). Sind die oberen 2 WORD des Issuer-Werts 0, ist er invalid. Dieser Wert wird mit dem 2-WORD-Code ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)) geschrieben.
- Die Codec-Nummer umfasst 2 WORD. Der Issuer vergibt sie unabhängig vom Kind überschneidungsfrei innerhalb seines eigenen `codecs/`. Reichen die Nummern nicht aus, wird ein weiterer Issuer beantragt.
- Das Codec-Dokument liegt unter `<Issuer>/codecs/<Codec-Nummer>/` dieses Issuer ([Veröffentlichungsadresse und Versionsliste](../publishing.md#id-표기)).
- Die Lizenz eines Issuer-Formats legt der jeweilige Issuer fest ([Issuer und Veröffentlichung](../issuer.md#라이선스)).

## Verwandte Seiten {#관련-페이지}

- [Edge — Issuer-Format-Edge](_index.md#issuer-형식-edge), [EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md), [EDGE-ISSUER-16WORD](0x1BFL-edge-issuer-16word.md)
- [Record und TAG WORD](../record.md#issuer-형식-레코드), [Issuer und Veröffentlichung](../issuer.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001BE0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001BE000000000
BODY
#1 DECLARE 0x1BE0
#2 FIELD #1 0x0004
#3 FIELD #1 0x0002
#4 FIELD #1 rest
#5 BIND #1 "EDGE-ISSUER-4WORD"
#6 BIND #2 "issuer"
#7 BIND #3 "codec"
#8 BIND #4 "payload"
```
