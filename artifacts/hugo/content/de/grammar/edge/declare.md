---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE ist ein Beschreibungs-Edge (Codec 0x1B), das den Payload-Aufbau eines Codecs deklariert. Zusammen mit FIELD, ENUM und CODEC ist es das Vokabular zum Schreiben von Codec-Spezifikationsdokumenten."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE ist ein Beschreibungs-Edge, das den Payload-Aufbau eines Codecs deklariert. Codec `0x1B`.

Zusammen mit [FIELD](/de/grammar/edge/field/) (`0x1C`), [ENUM](/de/grammar/edge/enum/) (`0x1D`) und [CODEC](/de/grammar/edge/codec/) (`0x1E`) ist es das Vokabular zum Schreiben von Codec-Spezifikationen ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)). Die Layouts der vier Edges sind im Decoder eingebaut. Die mit diesem Vokabular geschriebenen Codec-Spezifikationsdokumente sind gewöhnliche Dokumente. Eine einzige Spezifikation dient zugleich der Prüfung, Zerlegung und Anzeige (Viewer). Der Viewer enthält keinen Code je Codec, sondern zeichnet nach der Spezifikation.

## Layout

```
TAG WORD          0001 0LLL L001 1011
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Ziel              1 WORD. Vom TAG WORD des deklarierten Codecs nur die Stellen für Kind und Codec (LLLL = 0)
[Issuer, Formatnummer] wenn das Ziel ein Issuer-Format ist. Layout wie beim Codec-Erweiterungs-TAG
```

- Die Feldliste steht nicht im DECLARE. Jedes [FIELD](/de/grammar/edge/field/) verweist auf sein DECLARE, und die Reihenfolge dieser FIELDs im Dokument ist die Reihenfolge der Payload-Felder.

## Interpretationsregeln

Regeln, mit denen ein Record anhand der Codec-Spezifikation gelesen und dargestellt wird.

- Ein Rohwert-Feld wird in der von FIELD deklarierten festen WORD-Zahl gelesen. Ein Feld kann der restliche Rohwert sein (Breite `0xFFFF`); er wird mit den verbleibenden WORD abzüglich der Breiten der nachfolgenden festen Felder gelesen. Nach dem restlichen Feld stehen nur Rohwerte fester Breite.
- Ein Record-Feld beginnt mit einem TAG WORD und wird in der Length dieses TAG gelesen.
- Ein Rohwert-Feld ist eine vorzeichenlose Big-Endian-Ganzzahl von n WORD. Die Notation ist `0x` + Breite×4 Hex-Stellen, und gibt es ein ENUM für denselben Wert, wird zusätzlich dessen BIND-Name angegeben.
- Die Bedeutung eines Record-Feldes legt die Codec-Spezifikation dieses Records fest. Werte, die eine Interpretation brauchen, wie Vorzeichen, Dezimalstellen oder Datum, sind keine Rohwerte, sondern Value-Records.

Andere Grenzregeln gibt es nicht. Codecs mit mehr als einem variablen Rohwert, mit einem Record oder variablen Feld hinter einem variablen Rohwert oder mit einer Rohwertbreite, die vom Wert eines anderen Feldes oder vom Dokumentzustand abhängt, lassen sich mit diesem Vokabular nicht deklarieren. Bei solchen Layouts kapselt man den variablen Teil in einen Record, sodass nur einer übrig bleibt (z. B. der Signierende von SIGNATURE ist ein Reference-Record).

## Gültigkeit

- Das Kind des Ziels ist Reference, Value, Edge oder Meta. Der Codec eines Reference steht an der Stelle `CCCC`, der Quantifier bleibt 0.
- [Slot-Marker](/de/grammar/reference/slot-marker/) (Reference-Codec `0000`) können nicht Ziel eines DECLARE sein. Sie sind im Decoder eingebaut (Ebene 0).
- Die Edge Id eines Edge wird nicht als FIELD deklariert. Als erste Komponente jedes Edge ist sie implizit ([Edge](/de/grammar/edge/)).
- Die Felder eines DECLARE sind die FIELDs, die darauf verweisen, und es können null sein. Ein FIELD gehört nur zu einem DECLARE. Auch Felder derselben Form erhalten für jedes DECLARE eigene FIELDs.
- Im DECLARE steht außer dem Ziel (und bei Issuer-Format-Zielen Issuer und Formatnummer) nichts.
- Der Cursor nach dem Lesen aller Felder muss genau mit dem Ende des Records übereinstimmen. Bleibt etwas übrig oder fehlt etwas, verstößt der Record gegen die Spezifikation.
- Dasselbe Ziel wird in einem Dokument nicht zweimal deklariert.
- Varianten mit anderen Endfeldern werden nicht als Verzweigung geschrieben. Jeder Codec erhält ein eigenes DECLARE.

## Spezifikationsdokument

- Das Spezifikationsdokument eines direkten Codes ist ein gewöhnliches Dokument des GEUL-Issuers `0x0000`. Die Dokument-ID ist das Ziel-TAG-WORD, auf 4 WORD erweitert (`0x1018` → `0x0000000000001018`), und es wird wie andere Issuer-Dokumente veröffentlicht (Versions-ID, `versions.geul`) ([Codec-Spezifikationsdokument](/de/grammar/codec-spec/)).
- In einem Spezifikationsdokument gibt es ein DECLARE, dessen Ziel dem TAG WORD der Dokument-ID entsprechen muss. Die `DOC-ID` ist der DOC-POINTER (`0x0000`, diese Dokument-ID, `0`).

## Namen

- Der Codec-Name wird per [BIND](/de/grammar/edge/bind/) an die Edge Id des DECLARE gebunden (z. B. `PUBLICATION`). UTF8-TEXT für DECLARE, FIELD, ENUM und CODEC wird stets per BIND angehängt, nicht über LABEL oder andere Edges.
- Feldnamen und Enum-Namen werden auf dieselbe Weise an FIELD und ENUM gebunden.

## Beispiel

Das Spezifikationsdokument `geul.org/publication` von PUBLICATION (Edge `0x18`): Nach der Edge Id folgen ein DOC-POINTER-Record und der Inhaltshash mit 16 WORD.

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, Record         (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, Rohwert 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + Ziel 1 = 4 WORD, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + Breite 1 = 6 WORD (`LLLL = 0101`). Das akzeptierte Kind/Codec legt man gesondert mit [CODEC](/de/grammar/edge/codec/) fest (`0038` = DOC-POINTER).
- Ein optionales Feld wird mit dem CODEC-Ziel `0000` deklariert. An der ausgelassenen Stelle steht ABSENT (`0x0000`) ([CODEC](/de/grammar/edge/codec/), optionale Felder).
- Die Feldreihenfolge ist die Reihenfolge, in der FIELD #2 und #4 im Dokument stehen. Die Edge Ids müssen nicht lückenlos sein (LOCAL AUTO INCREMENT ist nur eine Empfehlung).

## Offene Fragen

- Wiederholung. Aufbauten wie „Argument × Argumentanzahl“ bei `CALL`, bei denen ein vorangehender Rohwert die Anzahl festlegt. Derzeit nicht deklarierbar.
- Wie man Codecs mit Unterformaten (Codec-spezifischer TAG) (WORLD usw.) deklariert.
- Wie man das Spezifikationsdokument eines Issuer-Formats findet (Issuer, Formatnummer → Adresse des Spezifikationsdokuments).
- Welches Bündel von Versionen der Spezifikationsdokumente direkter Codes `SPEC-VERSION` meint.

## Verwandte Seiten

- [FIELD](/de/grammar/edge/field/), [ENUM](/de/grammar/edge/enum/), [CODEC](/de/grammar/edge/codec/), [BIND](/de/grammar/edge/bind/)
- [Edge](/de/grammar/edge/), [Codec-Spezifikationsdokument](/de/grammar/codec-spec/)
