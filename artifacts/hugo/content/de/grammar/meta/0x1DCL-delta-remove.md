---
title: "DELTA-REMOVE (0x1DCL)"
weight: 476
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält im Diff (DELTA-BASE) die LOCAL IDs (Edge Id) der Records fest, die aus dem BODY des Basis-Snapshots zu entfernen sind („Artikel X gelöscht“)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DELTA-REMOVE` (Spezifikationsdokument BIND `DELTA-REMOVE`) |
| TAG ID | `0x1DCL` |
| Codec ID | `0x00001DC0` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001DC0/` (DECLARE-Ziel `1DC0`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 28 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Liste der LOCAL IDs (Edge Id), die im Diff aus dem Basis-BODY zu entfernen sind |
| Hugo-Seite | `meta/lineage/delta-remove.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ids` | #2 | Rest-Rohwert (`0xFFFF`) |  |  |

Hält im Diff ([DELTA-BASE](0x1DBL-delta-base.md)) die LOCAL IDs (Edge Id) der Records fest, die aus dem BODY des Basis-Snapshots zu entfernen sind („Artikel X gelöscht“).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1100 LLLL      Codec 0x1DCL
[Length-Erweiterungs-TAG]
Lösch-ID          LOCAL-Reference-Record × 1 oder mehr
```

- Codec: Meta `0x1DCL`, Abstammungsklasse
- Payload: ein oder mehrere [LOCAL](../reference/0x005L-local.md)-Reference-Records
- Anzahl: höchstens eines

## Interpretation und Gültigkeit {#해석과-유효성}

- Steht nur in Dokumenten mit `DELTA-BASE`.
- Jede LOCAL ID muss eine Edge Id sein, die im BODY des Basis-Snapshots vorhanden ist. Andernfalls ist es invalid. Dieselbe ID zweimal zu setzen ist invalid.
- Steht dieselbe Edge Id erneut im BODY desselben Diffs, ist es invalid (Löschen und Revision zugleich sind nicht möglich).
- Eine gelöschte LOCAL ID wird in späteren Versionen keinem anderen Objekt erneut zugewiesen ([Revision](../document.md#개정)).
- Ein Record, der im Diff-BODY fehlt, bedeutet „unverändert“. Deshalb wird das Löschen allein durch dieses Meta ausgedrückt.
- HEAD-Edges (das [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) für das gesamte Dokument und sein QUALIFIER) werden nicht vermerkt. Der HEAD wird als Ganzes durch den HEAD des Diffs ersetzt ([Diff-Speicherung](../document.md#diff-저장)).

## Beispiel {#예시}

LOCAL `#7` und `#12` löschen:

```
1DC4 0051 0007 0051 000C
```

- TAG `1DC4`(Meta `0x1DCL`, `LLLL=0100`, 5 WORD), LOCAL Reference `0051 0007`, `0051 000C`.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001DC0/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001DC000000000
BODY
#1 DECLARE 0x1DC0
#2 FIELD #1 rest
#3 BIND #1 "DELTA-REMOVE"
#4 BIND #2 "ids"
```
