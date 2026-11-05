---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM ist ein Aussage-Edge, der einem Codewert eines Rohwert-Feldes eine Bedeutung gibt."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `ENUM` (BIND des Spezifikationsdokuments `ENUM`) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000BD0/` (DECLARE-Ziel `0BD0`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 29 |
| Kind | Edge · Familie: Aussage, Gruppe: Sonstiges |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Ein Codewert eines Rohwert-Feldes. Feld, Codewert |
| Hugo-Seite | `edge/enum.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | Record | `0050` LOCAL |  |
| 2 | `code` | #3 | Restlicher Rohwert (`0xFFFF`) |  |  |

ENUM ist ein Aussage-Edge, der einem Codewert eines Rohwert-Feldes eine Bedeutung gibt. Codec `0x0BDL`.

Zusammen mit [FIELD](0x0BCL-field.md) ist er das Vokabular zum Schreiben von Codec-Spezifikationen. Das Layout ist im Decoder eingebaut ([Codec-Spezifikationsdokument](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Feld              LOCAL Reference-Record, der auf ein FIELD-Edge verweist
Codewert          Rohwert. Dieselbe WORD-Zahl wie die Breite dieses FIELD
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Feld muss ein Rohwert-FIELD sein (Breite `n ≥ 1`). An Record-Felder wird kein ENUM angefügt. Die Bedeutung eines Records nennt der Codec dieses Records.
- Der Codewert hat genau die Breite dieses FIELD. Die Grenze wird über die Length des ENUM-Records geprüft.
- In einem Feld wird derselbe Codewert nicht zweimal deklariert.
- Der Name eines Codewerts wird mit [BIND](0x0A3L-bind.md) an die ENUM-Edge-Id gebunden. Alle UTF8-TEXT, die an DECLARE, FIELD, ENUM und CODEC angefügt werden, erfolgen per BIND und nicht durch andere Edges wie LABEL.
- Ein nicht deklarierter Codewert ist kein Fehler. Der Viewer zeigt den Rohwert unverändert an. Ob die zulässigen Werte geschlossen werden, ist Sache der Codec-Spezifikation; im jetzigen Vokabular gibt es dafür keine Kennzeichnung.

## Länge {#길이}

```
Gesamt = 1 + N_len + N_id + N_field + n WORD
```

## Beispiel (nicht normativ) {#예시-비규범}

Im Feld der Begründungskategorie (FIELD #4, Rohwert 1 WORD) des TOMBSTONE-Spezifikationsdokuments wird der Code `0x0001` deklariert. Edge Id 10. Der Name wird gesondert per BIND gebunden. Da die Codetabelle der Begründungskategorie noch nicht festgelegt ist, ist der Codewert ein Beispiel.

- TAG 1 + Edge Id 2 + Feld 2 + Codewert 1 = 6 WORD, `LLLL = 0101`.

```
0BD5 0051 000A 0051 0004 0001
```

Das TRIPLE-Spezifikationsdokument setzt beim Rank-Feld (FIELD #5) drei ENUM (`0`·`1`·`2`) und bindet sie per BIND jeweils an `normal`·`preferred`·`deprecated` ([TRIPLE](0x0AAL-triple.md)).

## Verwandte Seiten {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [FIELD](0x0BCL-field.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Codec-Spezifikationsdokument](../codec-spec.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000BD0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
