---
title: "REPLACES (0x1D7L)"
weight: 471
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält den Inhaltshash der neu geschriebenen Zielversion fest (git amend·rebase)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `REPLACES` (Spezifikationsdokument BIND `REPLACES`) |
| TAG ID | `0x1D7L` |
| Codec ID | `0x00001D70` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D70/` (DECLARE-Ziel `1D70`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 23 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 0111 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Inhaltshash der neu geschriebenen Zielversion (git amend·rebase). Die ursprüngliche Version wird nicht gelöscht. |
| Hugo-Seite | `meta/lineage/replaces.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | Record | `07C0` SHA-256-DIGEST |  |

Hält den Inhaltshash der neu geschriebenen Zielversion fest (git amend·rebase).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0111 LLLL      Codec 0x1D7L
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x1D7L`, Abstammungsklasse
- Payload: eingebetteter Value ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit {#해석과-유효성}

- Die ursprüngliche Version wird nicht gelöscht (Bewahrung des früheren Rechts).
- Das Digest-Format wird als Value eingebettet, um Spielraum für einen Wechsel des Hash-Algorithmus zu lassen. Derzeit gibt es als Inhaltshash nur SHA-256.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D70/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D7000000000
BODY
#1 DECLARE 0x1D70
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "REPLACES"
#4 BIND #2 "digest"
```
