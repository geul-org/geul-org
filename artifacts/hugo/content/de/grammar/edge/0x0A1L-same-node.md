---
title: "SAME-NODE (0x0A1L)"
weight: 161
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE ist ein ungerichteter Identitäts-Aussage-Edge, der erklärt, dass zwei Reference auf denselben Referenten verweisen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Eintrag | Wert |
|---|---|
| Name | `SAME-NODE` (BIND des Spezifikationsdokuments `SAME-NODE`) |
| TAG ID | `0x0A1L` |
| Codec ID | `0x00000A10` |
| Spezifikationsdokument | `0x00000000/codecs/0x00000A10/` (DECLARE-Ziel `0A10`) |
| Abschnitt | 5 `0101` (Edge-Aussage), Offset im Abschnitt C = 1 |
| Kind | Edge · Familie: Aussage, Gruppe: Verweis und Name |
| TAG WORD | `0000 1010 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Indexbeschreibung | Identität: Zwei Reference verweisen auf dasselbe Ziel |
| Hugo-Seite | `edge/same-node.md` |

## Felder (Spezifikationsdokument) {#필드-규격-문서}

Die Reihenfolge der FIELD im Dokument ist die Reihenfolge der Payload-Felder ([Codec-Spezifikationsdokument](../codec-spec.md)). Die Edge Id eines Edge wird nicht als FIELD deklariert.

| Reihenfolge | Feld (BIND) | FIELD | Breite | Akzeptiertes Format (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | Record | Beliebiger Record (außer Slot-Marker) |  |
| 2 | `object` | #3 | Record | Beliebiger Record (außer Slot-Marker) |  |

SAME-NODE ist ein ungerichteter Identitäts-Aussage-Edge, der erklärt, dass zwei Reference auf denselben Referenten verweisen. Codec `0x0A1L`.

Das bedeutet nicht, dass die Byte-Kodierung, der Codec oder die ID der beiden Reference-Records gleich sind. Während [REFERENCE-NODE](0x0A0L-reference-node.md) eine gerichtete Bindung `Reference → Record` ist, drückt SAME-NODE die Identität (referential identity) zwischen zwei Reference aus.

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0001 LLLL
[Length-Erweiterungs-TAG]
Edge Id           LOCAL Reference-Record
Subject           1 Reference-Record
Object            1 Reference-Record
```

## Interpretation und Gültigkeit {#해석과-유효성}

- Subject und Object werden in dieser Reihenfolge serialisiert und müssen jeweils genau ein vollständiger [Reference](../reference/_index.md)-Record sein. Die Grenze findet man über die Length des jeweiligen Records.
- Ist Subject oder Object ein Value, ein Edge oder ein unvollständiger Record, ist es invalid.
- Die SAME-NODE-Beziehung ist reflexiv, symmetrisch und transitiv. Die Reihenfolge Subject/Object im Wire dient dem Framing und erzeugt keine semantische Richtung. Implementierungen müssen diese Beziehung in beide Richtungen durchsuchen können.
- Verschiedene [LOCAL](../reference/0x005L-local.md) ID sind lediglich verschiedene Reference und kein Beleg dafür, dass der Referent gleich oder verschieden ist. Dass zwei Reference auf denselben Referenten verweisen, wird mit SAME-NODE erklärt.
- Interpretation und Inferenz müssen Herkunft, Zeitpunkt, World und Policy-Scope des Dokuments, das den Edge enthält, sowie des Beurteilungsgraphen bewahren. SAME-NODE wird nicht als Grundlage für eine kontextunabhängige globale Zusammenführung verwendet.
- Auch bei vorhandenem SAME-NODE werden die ursprünglichen Reference-Records oder die Abstammung weder gelöscht noch überschrieben.
- Stehen für dasselbe Paar SAME-NODE und [DIFFERENT-NODE](0x0A2L-different-node.md) gemeinsam, ist der Wire dennoch nicht invalid. Der Kontext jeder Behauptung wird bewahrt und als Konflikt bewertet.
- Ein Variable Reference wird mit einem Identified Reference per SAME-NODE verbunden, um die Variable aufzulösen ([Reference](../reference/_index.md) Variable).

## Länge {#길이}

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

## Beispiel (nicht normativ) {#예시-비규범}

Edge Id `0009`, das Subject ist LOCAL 1, das Object ist LOCAL 2.

- Der Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. Der TAG ist `0000 1010 0001 0110` = `0A16`.

```
0A16 0051 0009 0051 0001 0051 0002
```

## Verwandte Seiten {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [DIFFERENT-NODE](0x0A2L-different-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Originaltext des Spezifikationsdokuments {#규격-문서-원문}

So sieht das Spezifikationsdokument `0x00000000/codecs/0x00000A10/latest.geul` aus, gelesen mit `geul show` (Hexadezimalwerte in Großbuchstaben).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A1000000000
BODY
#1 DECLARE 0x0A10
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "SAME-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
