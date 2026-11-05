---
title: "GENERATED-BY (0x1D3L)"
weight: 467
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält fest, wer das Dokument erzeugt hat."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `GENERATED-BY` (Spezifikationsdokument BIND `GENERATED-BY`) |
| TAG ID | `0x1D3L` |
| Codec ID | `0x00001D30` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D30/` (DECLARE-Ziel `1D30`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 19 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Erzeugendes Subjekt. Mensch, Modell, Regel-Engine |
| Hugo-Seite | `meta/lineage/generated-by.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `agent` | #2 | Record | beliebiger Record (außer Slot-Marker) |  |
| 2 | `version` | #5 | Record | `0720` UTF8-TEXT-EVEN, `0730` UTF8-TEXT-ODD, `0000` ABSENT (optionales Feld) |  |

Hält fest, wer das Dokument erzeugt hat. Mensch, Modell und Regel-Engine kommen alle in Frage.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0011 LLLL      Codec 0x1D3L
[Length-Erweiterungs-TAG]
Erzeuger          Reference (Mensch, Modell, Regel-Engine)
Version           UTF8-TEXT-Value oder Auslassungsmarker 0x0000 (optionales Feld)
```

- Codec: Meta `0x1D3L`, Abstammungsklasse
- Payload: eingebettete Reference + Versionstext (optional)
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit {#해석과-유효성}

- Bei einem Modell wird zusätzlich die Modellversion angegeben.
- Ist die Version unbekannt oder wird keine angegeben, lässt man die Stelle aus und verwendet ABSENT (`0x0000`) ([CODEC](../edge/0x0BEL-codec.md) optionales Feld). Die Spezifikation `0x1D30` von geul.org besteht aus zwei Record-Feldern: agent (ohne CODEC) und version (`0720`·`0730`·`0000`).
- Für die Quellversion (Commit) eines Programms ist das Format von [TRANSFORMED-BY](0x1D4L-transformed-by.md) (Digest, Pflicht) genauer. Die Version von GENERATED-BY hält als Text fest, was keine Commit-ID ist, etwa Modellname und -version.
- In auf geul.org veröffentlichten Dokumenten gibt es keine Reference, die auf natürliche Personen verweist ([Issuer und Veröffentlichung](../issuer.md#geulorg-공표)). Sie verweist auf Organisationen und Issuer. Als Ausnahme ist es erlaubt, mit [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) auf natürliche Personen zu verweisen.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D30/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D3000000000
BODY
#1 DECLARE 0x1D30
#2 FIELD #1 record
#3 BIND #1 "GENERATED-BY"
#4 BIND #2 "agent"
#5 FIELD #1 record
#6 BIND #5 "version"
#7 CODEC #5 0x0720
#8 CODEC #5 0x0730
#9 CODEC #5 0x0000
```
