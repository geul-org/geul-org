---
title: "RECORDED-BY (0x1CFL)"
weight: 463
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Hält fest, wer das Dokument aufgezeichnet hat (git committer)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `RECORDED-BY` (Spezifikationsdokument BIND `RECORDED-BY`) |
| TAG ID | `0x1CFL` |
| Codec ID | `0x00001CF0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001CF0/` (DECLARE-Ziel `1CF0`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 15 |
| Kind | Meta · Klasse: Herkunft |
| TAG WORD | `0001 1100 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Aufzeichnendes Subjekt. Reference (git committer) |
| Hugo-Seite | `meta/provenance/recorded-by.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `actor` | #2 | Record | beliebiger Record (außer Slot-Marker) |  |

Hält fest, wer das Dokument aufgezeichnet hat (git committer).

## Layout {#레이아웃}

```
TAG WORD          0001 1100 1111 LLLL      Codec 0x1CFL
[Length-Erweiterungs-TAG]
Payload           ein Reference-Record (EXTERNAL-ISSUER-*, GEUL, WIKIDATA-QID, LOCAL usw.)
```

- Codec: Meta `0x1CFL`, Herkunftsklasse
- Payload: eingebettete Reference
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Die Reference ist nicht auf bestimmte Codecs beschränkt. Mensch, Organisation, Modell und Regel-Engine kommen alle in Frage ([EXTERNAL-ISSUER](../reference/0x02FL-external-issuer-2word.md), [GEUL](../reference/0x00AL-geul.md), [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md), [LOCAL](../reference/0x005L-local.md) usw.).
- In auf geul.org veröffentlichten Dokumenten gibt es keine Reference, die auf natürliche Personen verweist ([Issuer und Veröffentlichung](../issuer.md#geulorg-공표)). Sie verweist auf Organisationen und Issuer. Als Ausnahme ist es erlaubt, mit [WIKIDATA-QID](../reference/0x014L-wikidata-qid.md) auf natürliche Personen zu verweisen.
- Ist es ein LOCAL, wird das Objekt im BODY beschrieben.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001CF0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001CF000000000
BODY
#1 DECLARE 0x1CF0
#2 FIELD #1 record
#3 BIND #1 "RECORDED-BY"
#4 BIND #2 "actor"
```
