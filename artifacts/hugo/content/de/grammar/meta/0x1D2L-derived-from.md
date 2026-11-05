---
title: "DERIVED-FROM (0x1D2L)"
weight: 466
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Hält fest, dass dieses Dokument aus Dokumenten oder Material einer anderen Abstammung abgeleitet ist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DERIVED-FROM` (Spezifikationsdokument BIND `DERIVED-FROM`) |
| TAG ID | `0x1D2L` |
| Codec ID | `0x00001D20` |
| Spezifikationsdokument | `0x00000000/codecs/0x00001D20/` (DECLARE-Ziel `1D20`) |
| Abschnitt | 14 `1110` (Meta), Offset im Abschnitt C = 18 |
| Kind | Meta · Klasse: Abstammung |
| TAG WORD | `0001 1101 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Beschreibung im Index | Abgeleitet von Records oder Material einer anderen Abstammung. Soll eine bestimmte Version externen Materials festgelegt werden, hängt man an das [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) im HEAD einen QUALIFIER (P4092) mit dem Hash des Originaltexts (git submodule). |
| Hugo-Seite | `meta/lineage/derived-from.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)).

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `source` | #2 | Record | `000F` ganzer Abschnitt 0 (Wildcard, Reference), `020F` ganzer Abschnitt 1 (Wildcard, Reference), `040F` ganzer Abschnitt 2 (Wildcard, Reference), `07C0` SHA-256-DIGEST, `0740` URI-EVEN, `0750` URI-ODD |  |

Hält fest, dass dieses Dokument aus Dokumenten oder Material einer anderen Abstammung abgeleitet ist.

## Layout {#레이아웃}

```
TAG WORD          0001 1101 0010 LLLL      Codec 0x1D2L
[Length-Erweiterungs-TAG]
Payload           Reference, oder SHA-256-DIGEST (Inhaltshash), oder URI-Value
```

- Codec: Meta `0x1D2L`, Abstammungsklasse
- Payload: eingebettete Reference oder Value
- Anzahl: mehrere möglich

## Interpretation und Gültigkeit {#해석과-유효성}

- Ist es aus einem GEUL-Dokument abgeleitet, steht dessen Inhaltshash ([SHA-256-DIGEST](../value/0x07CL-sha-256-digest.md)), bei externem Material eine [URI](../value/0x074L-uri.md). Um die Fassung externen Materials per Hash festzulegen, hängt man an das [SOURCE](../edge/0x0C0L-source.md#문서-전체의-출처) im HEAD einen QUALIFIER (P4092) mit dem Hash des Originaltexts.
- Die Quelle auf Record-Ebene übernimmt der Beleg-Edge [SOURCE](../edge/0x0C0L-source.md); den früheren Record vor Verschiebung, Teilung oder Zusammenführung übernimmt der QUALIFIER P1365 des Ziel-Edge (der Wert ist die alte Edge Id).

## Wortlaut des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00001D20/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000001D2000000000
BODY
#1 DECLARE 0x1D20
#2 FIELD #1 record
#3 BIND #1 "DERIVED-FROM"
#4 BIND #2 "source"
#5 CODEC #2 0x000F
#9 CODEC #2 0x020F
#10 CODEC #2 0x040F
#6 CODEC #2 0x07C0
#7 CODEC #2 0x0740
#8 CODEC #2 0x0750
```
