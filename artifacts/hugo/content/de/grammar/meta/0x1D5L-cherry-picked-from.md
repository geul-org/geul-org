---
title: "CHERRY-PICKED-FROM (0x1D5L)"
weight: 469
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält den Inhaltshash der Ursprungsversion fest, aus der eine Änderung einer anderen Abstammung übernommen wurde (git cherry-pick -x)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `CHERRY-PICKED-FROM` (Spezifikationsdokument BIND `CHERRY-PICKED-FROM`) |
| TAG ID | `0x1D5L` |
| Codec ID | `0x00001D50` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D50/` (DECLARE-Ziel `1D50`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 21 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Inhaltshash der Ursprungsversion, aus der eine Änderung einer anderen Abstammung übernommen wurde (git cherry-pick `-x`) |
| Hugo-Seite | `meta/lineage/cherry-picked-from.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | Record | `07C0` SHA-256-DIGEST |  |

Hält den Inhaltshash der Ursprungsversion fest, aus der eine Änderung einer anderen Abstammung übernommen wurde (git cherry-pick `-x`).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0101 LLLL      Codec 0x1D5L
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x1D5L`, Abstammungsklasse
- Payload: eingebetteter Value ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Digest-Format wird als Value eingebettet, um Spielraum für einen Wechsel des Hash-Algorithmus zu lassen. Derzeit gibt es als Inhaltshash nur SHA-256.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D50/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D5000000000
BODY
#1 DECLARE 0x1D50
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "CHERRY-PICKED-FROM"
#4 BIND #2 "digest"
```
