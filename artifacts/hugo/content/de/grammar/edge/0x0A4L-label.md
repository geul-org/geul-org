---
title: "LABEL (0x0A4L)"
weight: 164
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL ist ein Aussage-Edge, der einen Namen (Label) des Subject-Ziels in einer bestimmten Sprache mit dem Object verbindet."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `LABEL` (BIND des Spezifikationsdokuments `LABEL`) |
| TAG ID | `0x0A4L` |
| Codec ID | `0x00000A40` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A40/` (DECLARE-Ziel `0A40`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 4 |
| Kind | Edge · Familie: Aussage, Gruppe: Verweis und Name |
| TAG WORD | `0000 1010 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Verbindet den Sprachnamen (Label) des Subject. Das Object ist UTF8-LANGUAGE-TEXT |
| Hugo-Seite | `edge/label.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | Record | Beliebiger Record (außer Slot-Marker) |  |
| 2 | `object` | #3 | Record | `0780` UTF8-LANGUAGE-TEXT, `0790` UTF8-LANGUAGE-TEXT, `0050` LOCAL |  |

LABEL ist ein Aussage-Edge, der einen Namen (Label) des Subject-Ziels in einer bestimmten Sprache mit dem Object verbindet. Codec `0x0A4L`. Er ist kein Edge, der das Lemma der allgemeinen Lexikologie darstellt.

Name und Sprache stehen in einem einzigen Object, [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md). Ein Rohwert-Feld gibt es nicht.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0100 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Subject           1 Reference-Record
Object            1 UTF8-LANGUAGE-TEXT-Value oder LOCAL Reference-Record
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Subject ist genau ein vollständiger Reference-Record. Seine Grenze findet man über die eigene Length des Subject; ist es kein Reference oder unvollständig, ist es invalid.
- Das Object ist genau ein vollständiger [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md)-Record (`0x078L`·`0x079L`). Die Regeln für Sprache und Text (beide Sprachformate zulässig, Vergleich gleicher Sprachen) richten sich nach diesem Format.
- Im Object kann auch ein LOCAL Reference stehen. Dann muss er über eine [REFERENCE-NODE](0x0A0L-reference-node.md)-Bindung im selben Dokument zu UTF8-LANGUAGE-TEXT aufgelöst werden. Wird er nicht aufgelöst oder zu einem Ziel anderer Art aufgelöst, ist es invalid.
- Die Spezifikationsdokumente von geul.org schreiben diese Einschränkung als [CODEC](0x0BEL-codec.md) (Object = `0780`·`0790`·`0050`). Das Auflösungsziel von LOCAL wird nicht durch CODEC ausgedrückt.
- Ist das Object keines der beiden obigen Formate oder der Record unvollständig, ist es invalid. Ein Text ohne Sprache (UTF8-TEXT) kann kein LABEL sein. Ein maschinenlesbarer Name ohne Sprache wird als [BIND](0x0A3L-bind.md) geschrieben. Ein Name, der für mehrere Sprachen gemeinsam gilt, wird mit der Sprache `mul` geschrieben.
- Zu demselben Subject und derselben Sprache gibt es höchstens ein LABEL. Weitere Namen werden als [ALIAS](0x0A5L-alias.md) geschrieben.

## Länge {#길이}

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

- Sprach-Record und Textbytes des Object gehören nicht zum Edge, sondern zum Object-Record. Der Cursor nach dem Lesen des letzten Records muss genau mit dem Ende des Edge übereinstimmen.

## Beispiel (nicht normativ) {#예시-비규범}

Der Sprachcode `0784` für `en` ist die Nummer im GEUL Language Registry v2 (Spezifikationsdokument `0x00000000/codecs/0x000007A0`, Version 2).

### LANGUAGE-SHORT-CODE {#language-short-code}

Edge Id `0007`, Subject Q22686 (`0141 589E`), Object `Donald Trump` (en).

- Das Object ist Sprache `07A1 0784` (SHORT-CODE, 2 WORD) + Text mit 12 Byte (gerade, 6 WORD), also `UTF8-LANGUAGE-TEXT-EVEN` (`0x078L`), insgesamt 9 WORD `0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70`.
- Der Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. Der TAG ist `0A4D`.

```
0A4D 0051 0007 0141 589E 0788 07A1 0784 446F 6E61 6C64 2054 7275 6D70
```

### LANGUAGE-BCP47-CODE {#language-bcp47-code}

Edge Id `0008`, Subject Q155 (`0141 009B`), Object `Brasil` (pt-BR).

- Das Object ist Sprache `0773 7074 2D42 5200` (BCP47 `pt-BR`, 4 WORD) + Text mit 6 Byte (gerade, 3 WORD), insgesamt 8 WORD `0787 0773 7074 2D42 5200 4272 6173 696C`.
- Der Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. Der TAG ist `0A4C`.

```
0A4C 0051 0008 0141 009B 0787 0773 7074 2D42 5200 4272 6173 696C
```

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [ALIAS](0x0A5L-alias.md), [DESCRIPTION](0x0A6L-description.md), [BIND](0x0A3L-bind.md)
- [UTF8-LANGUAGE-TEXT](../value/0x078L-utf8-language-text.md), [LANGUAGE-SHORT-CODE](../value/0x07AL-language-short-code.md), [LANGUAGE-BCP47-CODE](../value/0x076L-language-bcp47-code.md)
- [LOCAL](../reference/0x005L-local.md), [REFERENCE-NODE](0x0A0L-reference-node.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A40/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A4000000000
BODY
#1 DECLARE 0x0A40
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "LABEL"
#5 BIND #2 "subject"
#6 BIND #3 "object"
#7 CODEC #3 0x0780
#8 CODEC #3 0x0790
#9 CODEC #3 0x0050
```
