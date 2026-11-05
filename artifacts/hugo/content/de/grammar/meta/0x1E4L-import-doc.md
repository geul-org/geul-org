---
title: "IMPORT-DOC (0x1E4L)"
weight: 484
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "Holt ein externes Dokument über eine IMPORT ID herein."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `IMPORT-DOC` (Spezifikationsdokument BIND `IMPORT-DOC`) |
| TAG ID | `0x1E4L` |
| Codec ID | `0x00001E40` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001E40/` (DECLARE-Ziel `1E40`) |
| Abschnitt | 15 `1111` (Meta), Offset im Abschnitt C = 4 |
| Kind | Meta · Klasse: IMPORT |
| TAG WORD | `0001 1110 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Holt ein externes Dokument über eine IMPORT ID herein. Eingebettete Reference `DOC-POINTER` (bei einem Codec-Dokument `CODEC-POINTER`) + IMPORT ID |
| Hugo-Seite | `meta/import/import-doc.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `doc` | #4 | Record | `0410` DOC-POINTER, `0420` CODEC-POINTER |  |
| 2 | `import-id` | #2 | Rest-Rohwert (`0xFFFF`) |  |  |

Holt ein externes Dokument über eine IMPORT ID herein. Das hereinzuholende Dokument wird von [DOC-POINTER](../reference/0x041L-doc-pointer.md) bezeichnet, und auch die Issuer-Breite steckt im DOC-POINTER.

## Layout {#레이아웃}

```
TAG WORD          0001 1110 0100 LLLL      Codec 0x1E4L
[Length-Erweiterungs-TAG]
Dokument          DOC-POINTER-Reference-Record (Issuer, Dokument-ID, Versions-ID. Bei Version 0 die neueste). Bei einem Codec-Dokument CODEC-POINTER
IMPORT ID         der gesamte Rest. unsigned in der schmalsten Breite
```

- Codec: Meta `0x1E4L`, IMPORT-Klasse
- Payload: eingebettete Reference `DOC-POINTER` (Issuer, Dokument-ID, Versions-ID) + Rohwert der IMPORT ID
- Anzahl: mehrere möglich (eines pro IMPORT ID)

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Dokument ist genau ein DOC-POINTER-Record. Beim Hereinholen eines Codec-Dokuments ist es ein [CODEC-POINTER](../reference/0x042L-codec-pointer.md)(Issuer, Codec-ID, Versions-ID)-Record. Er endet mit seiner eigenen Length, und der Rest ist die IMPORT ID.
- Die IMPORT ID umfasst mindestens 1 WORD, in der schmalsten Breite. Die Breite der IMPORT ID wird hier durch die Record-Länge bestimmt, bei [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) durch den Codec.
- Dieselbe IMPORT ID wird in einem Dokument nicht zweimal vergeben.
- Wird eine Versions-ID angegeben, ist es an diese Fassung gebunden, bei `0` an die zum Zeitpunkt der Interpretation neueste (oder zu einem festgelegten Zeitpunkt in Kraft befindliche) Fassung ([Revision](../document.md#개정)).
- Die [EXTERNAL-POINTER-*](../reference/0x020L-external-pointer-1word.md) im BODY verweist auf ein LOCAL des über die IMPORT ID hereingeholten Dokuments. Das hereingeholte Dokument selbst wird mit DOC-POINTER referenziert.
- Der HEAD des hereingeholten Dokuments wird nicht hereingeholt. Dessen Objekte werden gemäß den eigenen Deklarationen jenes Dokuments interpretiert.
- Mit der IMPORT ID kann man nicht dokumentübergreifend suchen. Ein Repository, das mehrere Dokumente lädt, löst die IMPORT ID in den vollständigen Pfad (Issuer, Dokument-ID, Versions-ID, LOCAL ID) auf und speichert diesen.

## Beispiel {#예시}

- IMPORT ID 1, Issuer `0x00000002`, Dokument `0x…0002`, neueste Version: `1E4A 0418 0000 0002 0000 0000 0000 0002 0000 0000 0001` (Meta TAG 1 + DOC-POINTER 9 + IMPORT ID 1 = 11 WORD)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001E40/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001E4000000000
BODY
#1 DECLARE 0x1E40
#4 FIELD #1 record
#10 CODEC #4 0x0410
#2 FIELD #1 rest
#6 BIND #1 "IMPORT-DOC"
#7 BIND #2 "import-id"
#9 BIND #4 "doc"
#11 CODEC #4 0x0420
```
