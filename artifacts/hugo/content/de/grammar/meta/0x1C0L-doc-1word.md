---
title: "DOC-1WORD (0x1C0L)"
weight: 448
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "structure"]
summary: "DOC-1WORD, DOC-2WORD und DOC-4WORD sind Struktur-Meta, die ein Dokument unter Angabe der Gesamtzahl seiner WORDs öffnen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-1WORD, DOC-2WORD und DOC-4WORD sind Struktur-Meta, die ein Dokument unter Angabe der Gesamtzahl seiner WORDs öffnen.

| Eintrag | Wert |
|---|---|
| Name | `DOC-1WORD` (Spezifikationsdokument BIND `DOC-1WORD`) |
| TAG ID | `0x1C0L` |
| Codec ID | `0x00001C00` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001C00/` (DECLARE-Ziel `1C00`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 0 |
| Kind | Meta · Klasse: Struktur |
| TAG WORD | `0001 1100 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Dokumentbeginn mit der Gesamtlänge in 1 WORD Payload |
| Hugo-Seite | `meta/structure/doc.md` (diese Seite behandelt auch [DOC-2WORD](0x1C1L-doc-2word.md) und [DOC-4WORD](0x1C2L-doc-4word.md)) |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `count` | #2 | Rohwert 1 WORD |  |  |

Dies ist der Record, der ein Dokument öffnet. Er gibt im Payload die Gesamtzahl der WORDs des Dokuments an. `DOC-1WORD` (`0x1C0L`), `DOC-2WORD` (`0x1C1L`) und `DOC-4WORD` (`0x1C2L`) werden auf dieser Seite gemeinsam behandelt.

## Layout {#레이아웃}

```
TAG WORD          0001 1100 0000 LLLL      Codec 0x1C0L
[Length-Erweiterungs-TAG]
Payload           Gesamtzahl der WORDs. Der Codec bestimmt die Breite: DOC-1WORD 1, DOC-2WORD 2, DOC-4WORD 4
```

- Codec: Meta `0x1C0L~0x1C2L`, Strukturklasse
- Payload: Rohwert (Gesamtzahl der WORDs des Dokuments, unsigned)
- Anzahl: eines pro Dokument, ganz am Anfang

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Länge reicht vom Beginn des öffnenden Records bis zum Ende von [END](0x1C4L-end.md).
- Verwendet wird die schmalste Breite, in die der Wert passt. Eine Kodierung in größerer Breite wird als nicht kanonische Kodierung abgelehnt.
- Die Länge muss der gesamten Eingabe entsprechen. Ein Dokument ist eine Eingabe.
- Mit dieser Länge kann der Decoder das gesamte Dokument überspringen. Einen Codec, der ohne Kenntnis der Länge öffnet, gibt es nicht.
- Bei der Berechnung des Inhaltshashs wird mit der Länge ohne die Meta der Verifikationsklasse und der dazu passenden Breite neu geschrieben ([Inhaltshash](../document.md#내용-해시)).

## Beispiel {#예시}

- `0x1C01 0x0017`: DOC-1WORD, insgesamt 23 WORD

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001C00/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001C0000000000
BODY
#1 DECLARE 0x1C00
#2 FIELD #1 0x0001
#3 BIND #1 "DOC-1WORD"
#4 BIND #2 "count"
```
