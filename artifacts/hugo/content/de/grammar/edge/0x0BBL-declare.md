---
title: "DECLARE (0x0BBL)"
weight: 187
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE ist ein Aussage-Edge, der den Payload-Aufbau eines Codec deklariert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DECLARE` (BIND des Spezifikationsdokuments `DECLARE`) |
| TAG ID | `0x0BBL` |
| Codec ID | `0x00000BB0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000BB0/` (DECLARE-Ziel `0BB0`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 27 |
| Kind | Edge · Familie: Aussage, Gruppe: Sonstiges |
| TAG WORD | `0000 1011 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Deklaration des Payload-Aufbaus eines Codec. Ziel-Kind und -Codec |
| Hugo-Seite | `edge/declare.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `target` | #2 | Rohwert 1 WORD |  |  |
| 2 | `issuer` | #3 | Restlicher Rohwert (`0xFFFF`) |  |  |

DECLARE ist ein Aussage-Edge, der den Payload-Aufbau eines Codec deklariert. Codec `0x0BBL`.

Zusammen mit [FIELD](0x0BCL-field.md) (`0x0BCL`), [ENUM](0x0BDL-enum.md) (`0x0BDL`) und [CODEC](0x0BEL-codec.md) (`0x0BEL`) ist er das Vokabular zum Schreiben von Codec-Spezifikationen ([Codec-Spezifikationsdokument](../codec-spec.md)). Das Layout der vier Edges ist im Decoder eingebaut. Die mit diesem Vokabular geschriebenen Codec-Spezifikationsdokumente sind gewöhnliche Dokumente. Mit einer Spezifikation werden Verifikation, Zerlegung und Anzeige (Viewer) gemeinsam erledigt. Der Viewer enthält keinen Code je Codec, sondern zeichnet nach der Spezifikation.

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1011 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Ziel              1 WORD. Vom TAG WORD des deklarierten Codec wird nur die Codec-Position (Abschnitt und C) verwendet (LLLL = 0)
[Issuer·Codec-Nr.] Bei der Deklaration eines Issuer-Codec. Issuer und Codec-Nummer in 2 WORD. Dasselbe Layout wie der Codec-Erweiterungs-TAG, für alle drei Kind gleich
                  Das Spezifikationsdokument des ISSUER-Codes selbst (GEUL Issuer) hat nur das Ziel
```

- Eine Feldliste steht nicht im DECLARE. Jedes [FIELD](0x0BCL-field.md) verweist auf sein DECLARE, und die Reihenfolge dieser FIELD im Dokument ist die Reihenfolge der Payload-Felder.

## Interpretationsregeln {#해석-규칙}

Dies sind die Regeln zum Lesen und Notieren von Records anhand einer Codec-Spezifikation.

- Ein Rohwert-Feld wird mit der vom FIELD deklarierten festen WORD-Zahl gelesen. Ein Feld darf ein restlicher Rohwert sein (Breite `0xFFFF`); es wird so viel gelesen, wie von den übrigen WORD nach Abzug der Breiten der nachfolgenden festen Felder bleibt. Nach dem Rest-Feld stehen nur Rohwerte fester Breite.
- Ein Record-Feld beginnt mit einem TAG WORD und wird mit der Length dieses TAG gelesen.
- Ein Rohwert-Feld ist eine Big-Endian-Ganzzahl ohne Vorzeichen aus n WORD. Die Notation ist `0x` + Breite×4 Hex-Stellen; gibt es ein ENUM mit demselben Wert, wird dessen BIND-Name mit notiert.
- Die Bedeutung eines Record-Feldes legt die Codec-Spezifikation dieses Records fest. Werte, die eine Interpretation brauchen, wie Vorzeichen, Dezimalstellen oder Datum, stehen nicht als Rohwert, sondern als Value-Record.

Weitere Grenzregeln gibt es nicht. Ein Codec, bei dem es mehr als einen variablen Rohwert gibt, nach einem variablen Rohwert ein Record oder variables Feld folgt oder die Breite eines Rohwerts vom Wert eines anderen Feldes oder vom Dokumentzustand abhängt, kann mit diesem Vokabular nicht deklariert werden. Ein solches Layout lässt nur einen variablen Teil übrig, indem es ihn in einen Record kapselt (z. B. ist der Unterzeichner von SIGNATURE ein Reference-Record).

## Gültigkeit {#유효성}

- Das Kind des Ziels ist eines von Reference, Value, Edge, Meta. Das Spezifikationsdokument eines direkten GEUL-Codes gibt es je Code eines. Auch das 5Q-System von Reference wird je Quantifizierungscode einzeln deklariert (LOCAL Identified `0050`, Generic `0060`, …). Auch Zeiger (`0x040L`, `0x041L`, `0x042L`), Slot-Marker und der ISSUER-Code sind jeweils dieser Code selbst. Der Issuer-Codec, der durch Issuer und Codec-Nummer nach dem ISSUER-Code bestimmt wird, wird vom Dokument dieses Issuer definiert.
- Auch [Slot-Marker](../slot-marker.md) (Reference `0x000L~0x002L`) sind Ziel eines DECLARE. Da sie keinen Payload haben, steht nur das DECLARE ohne FIELD. Bedeutung und Akzeptanzregeln der Marker sind im Decoder eingebaut (Schicht 0). Auch Codecs, deren Layout noch nicht festgelegt ist (SUPERSEDE-CHAIN, VERDICT, EVIDENCE usw.), haben nur das DECLARE.
- Die Edge Id eines Edge wird nicht als FIELD deklariert. Da sie bei allen Edges das erste Element ist, ist sie implizit ([Edge](_index.md)). Bei EDGE-ISSUER ist sie das erste Element nach Issuer und Codec-Nummer ([EDGE-ISSUER-2WORD](0x1BDL-edge-issuer-2word.md)).
- Die Felder eines DECLARE sind die FIELD, die auf es verweisen, und es können 0 sein. Ein FIELD gehört zu genau einem DECLARE. Auch Felder gleicher Gestalt erhalten je DECLARE ein eigenes FIELD.
- Im DECLARE steht außer dem Ziel (und bei Zielen im Issuer-Format Issuer und Codec-Nummer) nichts.
- Der Cursor nach dem Lesen der Felder der Reihe nach muss genau mit dem Ende des Records übereinstimmen. Bleibt etwas übrig oder fehlt etwas, verstößt der Record gegen die Spezifikation.
- In einem Dokument wird dasselbe Ziel nicht zweimal deklariert.
- Varianten mit unterschiedlichen Endfeldern werden nicht als Verzweigung verwendet. Für jeden Codec gibt es ein eigenes DECLARE.

## Spezifikationsdokument {#규격-문서}

- Das Spezifikationsdokument eines direkten Codes ist ein Codec-Dokument des GEUL Issuer `0x00000000`. Die Codec ID ist der als 32 Bit geschriebene Ziel-TAG-WORD (L=0) (`0x0B80` → `0x00000B80`) und wird unter `<Issuer>/codecs/<Codec ID>/` mit Versions-ID und `versions.geul` veröffentlicht ([Codec-Spezifikationsdokument](../codec-spec.md)).
- Das Codec-Dokument eines Issuer-Codec liegt unter `<Issuer>/codecs/<Codec-Nummer>/` dieses Issuer. Die Codec-Nummer überschneidet sich innerhalb dieses Issuer unabhängig vom Kind nicht. Der Interpreter betrachtet es als Fehler, wenn das Kind des Records und das Kind des DECLARE-Ziels verschieden sind ([Veröffentlichungsadresse und Versionsliste](../publishing.md#id-표기)).
- In einem Spezifikationsdokument gibt es genau ein DECLARE, und sein Ziel muss dem TAG WORD der Codec ID entsprechen. Das `DOC-ID` ist [CODEC-POINTER](../reference/0x042L-codec-pointer.md) (`0x00000000`, diese Codec ID, `0`).

## Name {#이름}

- Der Codec-Name wird mit [BIND](0x0A3L-bind.md) an die DECLARE-Edge-Id gebunden (z. B. `PUBLICATION`). Alle UTF8-TEXT, die an DECLARE, FIELD, ENUM und CODEC angefügt werden, erfolgen per BIND und nicht durch andere Edges wie LABEL.
- Feldnamen und Enum-Namen werden auf dieselbe Weise an FIELD und ENUM gebunden.

## Beispiel {#예시}

Das Spezifikationsdokument `0x00000000/codecs/0x00000B80/` von PUBLICATION (Edge `0x0B8L`): Nach der Edge Id ein DOC-POINTER-Record und ein Inhaltshash von 16 WORD.

```
0BB3 0051 0001 0B80                 DECLARE #1  Edge 0x0B8L               (BIND "PUBLICATION")
0BC5 0051 0002 0051 0001 0000       FIELD #2    DECLARE #1, Record         (BIND "doc")
0BE5 0051 0009 0051 0002 0410       CODEC #9    FIELD #2, DOC-POINTER
0BE5 0051 000A 0051 0002 0420       CODEC #10   FIELD #2, CODEC-POINTER (Codec-Versionsliste)
0BC5 0051 0004 0051 0001 0010       FIELD #4    DECLARE #1, Rohwert 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + Ziel 1 = 4 WORD, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + Breite 1 = 6 WORD (`LLLL = 0101`). Das akzeptierte Kind und der Codec stehen gesondert in [CODEC](0x0BEL-codec.md) (`0410` = DOC-POINTER, `0420` = CODEC-POINTER).
- Ein optionales Feld wird mit dem CODEC-Ziel `0000` deklariert. An der ausgelassenen Stelle steht ABSENT (`0x0000`) ([CODEC](0x0BEL-codec.md) optionales Feld).
- Die Feldreihenfolge ist die Reihenfolge, in der FIELD #2 und #4 im Dokument stehen. Die Edge Id muss nicht fortlaufend sein (LOCAL AUTO INCREMENT ist eine Empfehlung).

## Offene Probleme {#열린-문제}

- Wiederholung. Aufbau, bei dem ein vorangehender Rohwert die Anzahl bestimmt, wie bei „Argument × Anzahl der Argumente“ in `CALL`. Derzeit nicht deklarierbar.
- Deklaration von Codecs mit Unterformaten (Codec-spezifischer TAG) (WORLD usw.).
- Welches Versionsbündel der Spezifikationsdokumente der direkten Codes `SPEC-VERSION` bedeutet.

## Verwandte Seiten {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [Edge](_index.md), [Codec-Spezifikationsdokument](../codec-spec.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000BB0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BB000000000
BODY
#1 DECLARE 0x0BB0
#2 FIELD #1 0x0001
#3 FIELD #1 rest
#4 BIND #1 "DECLARE"
#5 BIND #2 "target"
#6 BIND #3 "issuer"
```
