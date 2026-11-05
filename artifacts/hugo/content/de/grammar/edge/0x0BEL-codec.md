---
title: "CODEC (0x0BEL)"
weight: 190
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "CODEC ist ein Aussage-Edge, der ein Kind und einen Codec festlegt, die ein FIELD akzeptiert."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `CODEC` (BIND des Spezifikationsdokuments `CODEC`) |
| TAG ID | `0x0BEL` |
| Codec ID | `0x00000BE0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000BE0/` (DECLARE-Ziel `0BE0`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 30 |
| Kind | Edge · Familie: Aussage, Gruppe: Sonstiges |
| TAG WORD | `0000 1011 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Ein vom Feld akzeptiertes Kind und ein Codec. Feld, Ziel-WORD (`000K KKKC CCCC LLLL`, LLLL 0000 exakt·1111 Wildcard (alle 32 Plätze dieses Abschnitts), Slot-Marker nur als exaktes Ziel `0000`·`0010`·`0020`). Record-Felder mehrere (geschlossene Liste), Rohwert-Felder eines (dieser Value ohne TAG) |
| Hugo-Seite | `edge/codec.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | Record | `0050` LOCAL |  |
| 2 | `target` | #4 | Rohwert 1 WORD |  |  |

CODEC ist ein Aussage-Edge, der ein Kind und einen Codec festlegt, die ein [FIELD](0x0BCL-field.md) akzeptiert. Codec `0x0BEL`.

So wie [ENUM](0x0BDL-enum.md) einem Codewert eines Rohwert-Feldes eine Bedeutung gibt, fügt CODEC dem Feld ein Format hinzu. Da es pro Edge eines ist, können mehrere festgelegt werden. Das Layout ist im Decoder eingebaut ([Codec-Spezifikationsdokument](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1110 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Feld              LOCAL Reference-Record, der auf ein FIELD-Edge verweist
Ziel              1 WORD. 000K KKKC CCCC LLLL (LLLL = 0000 exakt, 1111 Wildcard)
```

## Ziel-WORD {#대상-word}

- Die Codec-Position des TAG WORD (Abschnitt `KKKK` und `CCCCC`) bleibt unverändert. Die oberen 3 Bit sind 0. `LLLL` ist `0000` (exakt) oder `1111` (Wildcard); andere Werte sind invalid.
- Der als 32 Bit geschriebene Wert des exakten Ziels (`LLLL = 0000`) ist die Codec ID dieses Codec (z. B. LOCAL `0x0050` → `0x00000050`, COORDINATE-EARTH `0x0640`, UTF8-LANGUAGE-TEXT `0x0780`). Daher verweist das Ziel unmittelbar auf das Spezifikationsdokument dieses Codec ([Codec-Spezifikationsdokument](../codec-spec.md)).
- Auch gerade/ungerade Codepaare (Text, Bytefolge) werden mit exakten Codes festgelegt. Sollen gerade und ungerade akzeptiert werden, stehen beide. Eine Regel, Paare zusammengefasst zu interpretieren, gibt es nicht (es gibt benachbarte Codes, die kein Paar sind, wie NUMERIC `0x064L`/`0x065L`).

### Wildcard (`LLLL = 1111`) {#와일드카드-llll--1111}

- Bei `LLLL = 1111` wird unabhängig vom Wert `C` der gesamte Abschnitt `KKKK` (32 Plätze) des Ziel-WORD akzeptiert. Innerhalb desselben Abschnitts hat jeder Wert von `C` dieselbe Bedeutung. Es wird nur geprüft, ob der Abschnitt des Ziels und der Abschnitt des Records gleich sind. Über Abschnitte hinaus wird nicht akzeptiert.
- Bei `LLLL = 1111` wird der erste Platz des Abschnitts (`C = 0`) empfohlen. Es ist eine Empfehlung und kein Zwang. Auch ein anderes `C` desselben Abschnitts ist gültig.
- Erstreckt sich ein Kind über mehrere Abschnitte, werden die CODEC je Abschnitt aufgezählt.

| Ziel | Bedeutung |
|---|---|
| `000F`·`020F`·`040F` | Beliebiges Reference (Abschnitte 0~2, einschließlich REFERENCE-ISSUER) |
| `060F`·`080F` | Beliebiger Value (Abschnitte 3·4, einschließlich VALUE-ISSUER) |
| `0A0F`·`0C0F`·`0E0F`·`100F`·`120F`·`140F`·`160F`·`180F`·`1A0F` | Beliebiger Edge (Abschnitte 5~13, einschließlich EDGE-ISSUER) |
| `1C0F`·`1E0F` | Beliebiges Meta (Abschnitte 14·15) |

- Die Slot-Marker des Reference (`0x000L~0x002L`) passen nicht zu `LLLL = 1111` (`000F` akzeptiert weder ABSENT noch UNKNOWN-VALUE noch NO-VALUE). Andererseits schließt `LLLL = 1111` auch Abschnitte ein, deren erster Platz belegt ist, wie Value `0x060L` (BOOL) und Edge `0x0A0L` (REFERENCE-NODE) (soll nur BOOL akzeptiert werden, dann `0600` mit `LLLL = 0000`).
- Ein Ziel mit `LLLL = 1111` verweist nicht auf ein Spezifikationsdokument.
- Quantifizierungsunabhängigkeit oder Gruppen werden nur durch eine CODEC-Aufzählung (`LLLL = 0000`) geschrieben. Beispiel: Quantifizierungsunabhängig bei WIKIDATA-QID sind fünf Einträge: `0140`, `0150`, `0160`, `0170`, `0180`.
- Die Codes des Reference-5Q-Systems enthalten die Quantifizierung. Das Ziel gibt die Quantifizierung exakt an. Sollen mehrere Quantifier akzeptiert werden, stehen mehrere CODEC. Die Quantifizierung von REFERENCE-ISSUER legt das Issuer-Dokument fest.

### Slot-Marker (Ziel `0000`, `0010`, `0020`) {#자리-표지-대상-0000-0010-0020}

[Slot-Marker](../slot-marker.md) sind ein Bündel von 1-WORD-Records, das den ersten drei Plätzen `0x000L~0x002L` des Reference-Abschnitts 0 zugewiesen ist. Sie haben keine Quantifizierung.

| Ziel | Marker | Bedeutung |
|---|---|---|
| `0000` | ABSENT | Nicht angegeben. Dieses Feld ist ein optionales Feld |
| `0010` | UNKNOWN-VALUE | Unbekannt. Akzeptiert die Behauptung, dass es einen Wert gibt |
| `0020` | NO-VALUE | Nicht vorhanden. Akzeptiert die Behauptung, dass es keinen Wert gibt |

- **Akzeptanzregel:** Ein Marker ist nur gültig, wenn dasselbe WORD als exaktes Ziel in der CODEC-Liste des Feldes steht. Wildcards und Record-Felder ohne CODEC („beliebiger Record“) akzeptieren keine Marker. Ein Marker an der Position eines HEAD-/BODY-Records oder der Edge Id ist invalid.
- Eine Liste mit nur Marker-Zielen (immer Marker) ist invalid (Verallgemeinerung der Regel für eine Liste mit nur `0000`). Marker-Ziele werden zusammen mit einem Ziel mit `LLLL = 1111` oder einem exakten Ziel verwendet (`000F`·`020F`·`040F` + `0000` = beliebiges Reference oder Auslassung).
- Bei Rohwert-Feldern können keine Marker-Ziele stehen. Ein Rohwert hat keinen TAG und eine feste Breite, sodass kein Platz für einen 1-WORD-Marker bleibt.
- Die Bedeutung eines Markers legt die Codec-Spezifikation fest, die ihn akzeptiert.

### Optionales Feld (Ziel `0000`) {#선택-필드-대상-0000}

- Steht in der CODEC-Liste eines Record-Feldes das Ziel `0000`, ist dieses Feld ein **optionales Feld**. Bei Auslassung wird an dieser Stelle das 1 WORD `0x0000` geschrieben. Dieser 1-WORD-Record ist der Slot-Marker ABSENT (nicht angegeben).
- `0x0000` ist Reference, Codec `0x000L` (Reserved), `LLLL = 0000` (insgesamt 1 WORD). Er überschneidet sich nicht mit anderen Records, und auch ein Decoder, der die Spezifikation nicht kennt, überspringt ihn als 1-WORD-Record.
- Auch ein optionales Feld belegt immer seine Stelle. Bei Auslassung wird unbedingt `0x0000` geschrieben, und die Stelle bleibt nicht leer (auch bei hinteren Feldern gleich). So gibt es für einen Record nur eine Notation, und die Zerlegung wird allein durch die Position bestimmt. Für Position und Anzahl optionaler Felder sowie dafür, ob sich Listen mit anderen Feldern überschneiden, gibt es keine Einschränkung.
- ABSENT ist nur an der Stelle eines optionalen Feldes gültig. `0x0000` an der Position eines HEAD-/BODY-Records, eines Pflichtfeldes oder der Edge Id ist invalid.
- Eine Auslassung bedeutet nicht „kein Wert“, sondern „nicht angegeben“. Über die Welt wird nichts behauptet. „Kein Wert“ wird mit NO-VALUE (`0020`) geschrieben. Was eine Auslassung bedeutet (z. B. dass ohne Ziel des TAG diese Version gemeint ist), legt die Spezifikation des jeweiligen Formats fest.

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Feld ist ein FIELD-Edge desselben Dokuments. Dasselbe Ziel wird in einem Feld nicht zweimal angegeben.
- **Record-Feld (Breite 0)**: Ohne CODEC wird jeder Record außer Slot-Markern akzeptiert. Gibt es mindestens einen, ist es eine geschlossene Liste. Der Record dieses Feldes muss mit Kind und Codec (bei Reference einschließlich Quantifier) einer in der Liste sein, andernfalls entspricht der Record nicht der Spezifikation. Anders als ENUM ist es keine offene Liste.
- **Rohwert-Feld (Breite n ≥ 1 oder Rest `0xFFFF`)**: Bei CODEC steht nur ein exaktes Ziel (keine Wildcard). Dieser Rohwert ist der Payload dieses Value ohne TAG. Kind und Codec liefert der CODEC, die Length die FIELD-Breite. Bei geraden/ungeraden Codes bestimmt der angegebene Code, ob die Byteanzahl gerade oder ungerade ist. Folgt der Rohwert nicht den Regeln dieses Value (einschließlich Länge), entspricht der Record nicht der Spezifikation.
- Slot-Marker werden nur mit den exakten Zielen der Liste abgeglichen. Steht an der Stelle eines optionalen Feldes (Ziel `0000`) `0x0000`, ist es eine Auslassung. Alle anderen Records werden mit der Liste ohne Marker-Ziele abgeglichen.
- Bei einem Rohwert-Feld können CODEC und ENUM zusammen stehen. CODEC ist das Format, ENUM der Name des Codewerts (z. B. rank als UNSIGNED-INTEGER und 0·1·2 als ENUM).
- Der Edge Id eines CODEC kann per BIND ein Name gegeben werden, das ist aber nicht erforderlich.
- Ein Feld „Reference oder Value“ wird mit 5 CODEC (`000F`, `020F`, `040F`, `060F`, `080F`) geschrieben.

## Länge {#길이}

```
Gesamt = 1 + N_len + N_id + N_field + 1 WORD   (6 WORD, wenn Edge Id und Feld LOCAL-IDs mit 1 WORD sind)
```

## Beispiel {#예시}

Im LABEL-Spezifikationsdokument `0x00000000/codecs/0x00000A40/` akzeptiert das Object-Feld (FIELD #3) UTF8-LANGUAGE-TEXT (gerade/ungerade) und LOCAL. Edge Id 7~9.

```
0BE5 0051 0007 0051 0003 0780
0BE5 0051 0008 0051 0003 0790
0BE5 0051 0009 0051 0003 0050
```

- TAG `0BE5` (Edge, Codec `0x0BEL`, `LLLL = 0101`, 6 WORD), Edge Id `0051 0007`, Feld `0051 0003`, Ziel `0780`.

## Verwandte Seiten {#관련-페이지}

- [FIELD](0x0BCL-field.md), [ENUM](0x0BDL-enum.md), [DECLARE](0x0BBL-declare.md), [BIND](0x0A3L-bind.md)
- [Codec-Spezifikationsdokument](../codec-spec.md), [LABEL](0x0A4L-label.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000BE0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BE000000000
BODY
#1 DECLARE 0x0BE0
#2 FIELD #1 record
#3 CODEC #2 0x0050
#4 FIELD #1 0x0001
#5 BIND #1 "CODEC"
#6 BIND #2 "field"
#7 BIND #4 "target"
```
