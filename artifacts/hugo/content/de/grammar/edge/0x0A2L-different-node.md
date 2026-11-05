---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE ist ein Nichtidentitäts-Aussage-Edge, der besagt, dass zwei Reference auf verschiedene Referenten verweisen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `DIFFERENT-NODE` (BIND des Spezifikationsdokuments `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A20/` (DECLARE-Ziel `0A20`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 2 |
| Kind | Edge · Familie: Aussage, Gruppe: Verweis und Name |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Nichtidentität: Zwei Reference verweisen auf verschiedene Ziele |
| Hugo-Seite | `edge/different-node.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | Record | Beliebiger Record (außer Slot-Marker) |  |
| 2 | `object` | #3 | Record | Beliebiger Record (außer Slot-Marker) |  |

DIFFERENT-NODE ist ein Nichtidentitäts-Aussage-Edge, der besagt, dass zwei Reference auf verschiedene Referenten verweisen. Codec `0x0A2L`.

Das bedeutet nicht, dass sich die Byte-Kodierung, der Codec oder die ID der beiden Reference-Records unterscheiden. Es ist abzugrenzen von der gerichteten Bindung von [REFERENCE-NODE](0x0A0L-reference-node.md) und der Identität von [SAME-NODE](0x0A1L-same-node.md).

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Subject           1 Reference-Record
Object            1 Reference-Record
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Subject und Object müssen jeweils genau ein vollständiger [Reference](../reference/_index.md)-Record sein. Die Grenze findet man über die Length des jeweiligen Records; ist es ein Value oder ein Edge oder unvollständig, ist es invalid.
- Subject und Object verweisen auf verschiedene Referenten. Allein aus Unterschieden in Bytefolge, Codec oder ID der Reference-Records wird nicht geschlossen, dass die Referenten verschieden sind.
- Insbesondere sind verschiedene [LOCAL](../reference/0x005L-local.md) ID lediglich verschiedene Reference und bedeuten nicht, dass auch die Referenten in der Wirklichkeit verschieden sind. Aus einem Unterschied der LOCAL ID allein wird kein DIFFERENT abgeleitet.
- Nichtidentität ist symmetrisch, irreflexiv und nicht transitiv. `DIFFERENT(A, B)` ist dieselbe Beziehung wie `DIFFERENT(B, A)`. Aus `DIFFERENT(A, B)` und `DIFFERENT(B, C)` wird jedoch nicht `DIFFERENT(A, C)` gefolgert.
- Die Reihenfolge Subject/Object im Wire ist nur eine Serialisierungsreihenfolge für das Framing und erzeugt keine semantische Richtung. Implementierungen müssen in beide Richtungen suchen können.
- Der Cursor nach dem Lesen beider Komponenten muss genau mit dem Ende des Edge übereinstimmen.

Auch wenn die Beziehung selbst irreflexiv ist, dürfen eine strukturell gültige Behauptung `DIFFERENT(A, A)` oder Behauptungen, in denen SAME und DIFFERENT aufeinanderprallen, nicht als Grammatikfehler im Wire gelöscht werden. Solche Behauptungen bewahren Kontext und Abstammung und werden in der Beurteilungsschicht als Widerspruch behandelt. Beim Interpretieren oder Ableiten von DIFFERENT werden Herkunft, Zeitpunkt, World und Policy-Scope des Dokuments, das den Edge enthält, bewahrt und nicht zu einer globalen Schlussfolgerung ausgeweitet, die sie ignoriert.

## Länge {#길이}

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

## Beispiel (nicht normativ) {#예시-비규범}

Edge Id `000A`, das Subject ist LOCAL 1, das Object ist LOCAL 2.

- Der Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. Der TAG ist `0000 1010 0010 0110` = `0A26`.

```
0A26 0051 000A 0051 0001 0051 0002
```

Der Unterschied der LOCAL ID in diesem Beispiel dient nur dazu, die Kodierung zu zeigen. Diese Sequenz wird nur dann zu einem DIFFERENT-NODE, wenn es eine eigene Behauptung gibt, dass ID 1 und ID 2 auf verschiedene Referenten verweisen.

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A20/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
