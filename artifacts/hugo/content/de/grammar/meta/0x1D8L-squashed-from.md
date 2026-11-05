---
title: "SQUASHED-FROM (0x1D8L)"
weight: 472
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält die Inhaltshashes der zu einer Version zusammengeführten Ursprungsversionen fest (git squash)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SQUASHED-FROM` (Spezifikationsdokument BIND `SQUASHED-FROM`) |
| TAG ID | `0x1D8L` |
| Codec ID | `0x00001D80` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D80/` (DECLARE-Ziel `1D80`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 24 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Inhaltshashes der zu einer Version zusammengeführten Ursprungsversionen (git squash) |
| Hugo-Seite | `meta/lineage/squashed-from.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | Record | `07C0` SHA-256-DIGEST |  |

Hält die Inhaltshashes der zu einer Version zusammengeführten Ursprungsversionen fest (git squash).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 1000 LLLL      Codec 0x1D8L
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x1D8L`, Abstammungsklasse
- Payload: eingebetteter Value ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Anzahl: mehrere möglich (eines pro Ursprungsversion)

## Interpretation und Gültigkeit {#해석과-유효성}

- Das Digest-Format wird als Value eingebettet, um Spielraum für einen Wechsel des Hash-Algorithmus zu lassen. Derzeit gibt es als Inhaltshash nur SHA-256.

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D80/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D8000000000
BODY
#1 DECLARE 0x1D80
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "SQUASHED-FROM"
#4 BIND #2 "digest"
```
