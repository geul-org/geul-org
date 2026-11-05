---
title: "FIELD (0x0BCL)"
weight: 188
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "FIELD ist ein Aussage-Edge, der ein Feld des Codec-Payload deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `FIELD` (BIND des Spezifikationsdokuments `FIELD`) |
| TAG ID | `0x0BCL` |
| Codec ID | `0x00000BC0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000BC0/` (DECLARE-Ziel `0BC0`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 28 |
| Kind | Edge · Familie: Aussage, Gruppe: Sonstiges |
| TAG WORD | `0000 1011 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Ein Payload-Feld. Zugehöriges DECLARE, Breite: Record (Length des TAG) oder Rohwert n WORD |
| Hugo-Seite | `edge/field.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `declare` | #2 | Record | `0050` LOCAL |  |
| 2 | `width` | #3 | Rohwert 1 WORD |  | `0x0000` record, `0xFFFF` rest |

FIELD ist ein Aussage-Edge, der ein Feld des Codec-Payload deklariert. Codec `0x0BCL`.

Ein FIELD verweist auf sein [DECLARE](0x0BBL-declare.md). Die FIELD, die auf ein DECLARE verweisen, bilden in der Reihenfolge im Dokument den Payload. Das Layout ist im Decoder eingebaut ([Codec-Spezifikationsdokument](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1100 LLLL
Edge Id           LOCAL Reference-Record
DECLARE           LOCAL Reference-Record. Das DECLARE-Edge, zu dem dieses Feld gehört
Breite            1 WORD. 0 = Record, n (1~65534) = Rohwert n WORD, 0xFFFF = restlicher Rohwert
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Das DECLARE verweist auf ein DECLARE-Edge desselben Dokuments. Ein FIELD gehört zu genau einem DECLARE. Die Reihenfolge wird nicht gesondert angegeben, sondern ist die Reihenfolge, in der die FIELD-Records im Dokument stehen.
- Das FIELD-Spezifikationsdokument deklariert das DECLARE als Feld mit Breite `0` (Record) und CODEC `0050` (LOCAL). Deshalb wird im Viewer-Graphen die Verbindung FIELD → DECLARE gezeichnet.
- Die Breite `0` ist ein Record-Feld. Es beginnt mit einem TAG WORD und wird mit der Length dieses TAG gelesen ([DECLARE](0x0BBL-declare.md) Interpretationsregeln).
- Die Breite `n` (1~65534) ist ein Rohwert-Feld. Es sind immer genau n WORD.
- Die Breite `0xFFFF` ist ein restlicher Rohwert. Er steht nur einmal in einem DECLARE und darf vorn, in der Mitte oder am Ende stehen. Die Breite ist der Wert, der von den übrigen WORD, die die Length des TAG des äußeren Records festlegt, nach Abzug der Breiten der nachfolgenden Felder bleibt. Deshalb müssen alle Felder nach dem Rest-Feld Rohwerte fester Breite sein (ein Record muss von vorn gelesen werden, damit man sein Ende kennt). Er kann 0 WORD haben. Ein ENUM wird nicht angefügt.
- Das vom Feld akzeptierte Kind und der Codec werden mit [CODEC](0x0BEL-codec.md) angegeben. Ein Record-Feld akzeptiert ohne CODEC beliebige Records, mit CODEC muss es einer davon sein. Setzt man bei einem Rohwert-Feld einen CODEC, wird dieser Rohwert als dieser Value ohne TAG interpretiert.
- Der Feldname wird mit [BIND](0x0A3L-bind.md) an die FIELD-Edge-Id gebunden (z. B. `doc`, `hash`). Alle UTF8-TEXT, die an DECLARE, FIELD, ENUM und CODEC angefügt werden, erfolgen per BIND und nicht durch andere Edges wie LABEL.
- Die Bedeutung der Codewerte eines Rohwert-Feldes wird per [ENUM](0x0BDL-enum.md) angefügt.
- Felder, die im Graphen auf andere Knoten verweisen, werden nicht gesondert gekennzeichnet. Ist ein Record-Feld ein Reference, ist das die Verbindung.

## Länge {#길이}

```
Gesamt = 1 + 2 + 2 + 1 WORD   (wenn Edge Id und DECLARE LOCAL-IDs mit 1 WORD sind)
```

## Beispiel (nicht normativ) {#예시-비규범}

- Record-Feld: Edge Id 7, DECLARE #1, Breite `0`. TAG 1 + Edge Id 2 + DECLARE 2 + Breite 1 = 6 WORD. Soll nur LOCAL akzeptiert werden, siehe das Beispiel bei [CODEC](0x0BEL-codec.md).

```
0BC5 0051 0007 0051 0001 0000
```

- Für Rohwert-Felder wie einen Inhaltshash siehe das Beispiel bei [DECLARE](0x0BBL-declare.md).

## Verwandte Seiten {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Codec-Spezifikationsdokument](../codec-spec.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000BC0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BC000000000
BODY
#1 DECLARE 0x0BC0
#2 FIELD #1 record
#13 CODEC #2 0x0050
#3 FIELD #1 0x0001
#5 ENUM #3 0x0000
#6 ENUM #3 0xFFFF
#7 BIND #1 "FIELD"
#8 BIND #2 "declare"
#9 BIND #3 "width"
#11 BIND #5 "record"
#12 BIND #6 "rest"
```
