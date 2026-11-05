---
title: "PARENT (0x1D1L)"
weight: 465
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält den Inhaltshash der unmittelbar vorangehenden Version fest (git parent)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `PARENT` (Spezifikationsdokument BIND `PARENT`) |
| TAG ID | `0x1D1L` |
| Codec ID | `0x00001D10` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D10/` (DECLARE-Ziel `1D10`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 17 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Inhaltshash der unmittelbar vorangehenden Version (git parent). Fehlt er, ist es die erste Version; sind es mehrere, ist es ein Merge (git merge commit). |
| Hugo-Seite | `meta/lineage/parent.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `digest` | #2 | Record | `07C0` SHA-256-DIGEST |  |

Hält den Inhaltshash der unmittelbar vorangehenden Version fest (git parent).

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0001 LLLL      Codec 0x1D1L
[Length-Erweiterungs-TAG]
Payload           ein SHA-256-DIGEST-Value (16 WORD)
```

- Codec: Meta `0x1D1L`, Abstammungsklasse
- Payload: eingebetteter Value ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md))
- Anzahl: mehrere möglich (Merge)

## Interpretation und Gültigkeit {#해석과-유효성}

- Fehlt er, ist es die erste Version; sind es mehrere, ist es ein Merge (git merge commit).
- Er geht in den [Inhaltshash](../document.md#내용-해시) ein, sodass die gesamte Historie zu einer Hashkette wird.
- Ein Versionslisten-Dokument verweist auf das unmittelbar vorangehende Listendokument ([PUBLICATION](../edge/0x0B8L-publication.md)).
- Das Digest-Format wird als Value eingebettet, um Spielraum für einen Wechsel des Hash-Algorithmus zu lassen. Derzeit gibt es als Inhaltshash nur SHA-256.

## Beispiel {#예시}

- `0x1D1E 0x0014 0x07CE 0x0012 <16 WORD>` (Meta 20 WORD = TAG + Length-Erweiterung + eingebetteter Value 18 WORD)

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D10/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D1000000000
BODY
#1 DECLARE 0x1D10
#2 FIELD #1 record
#5 CODEC #2 0x07C0
#3 BIND #1 "PARENT"
#4 BIND #2 "digest"
```
