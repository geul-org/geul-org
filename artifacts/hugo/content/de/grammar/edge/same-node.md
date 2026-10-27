---
title: "SAME-NODE"
weight: 2
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "SAME-NODE ist ein ungerichtetes Identitäts-Edge (Codec 0x01), das erklärt, dass zwei Reference auf dasselbe Objekt verweisen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SAME-NODE ist ein ungerichtetes Identitäts-Edge, das erklärt, dass zwei Reference auf denselben Referenten verweisen. Codec `0x01`.

Es bedeutet nicht, dass Byte-Kodierung, Codec und ID zweier Reference-Records gleich sind. Anders als [REFERENCE-NODE](/de/grammar/edge/reference-node/), eine gerichtete Bindung `Reference → Record`, drückt SAME-NODE die Identität (referential identity) zwischen zwei Reference aus.

## Layout

```
TAG WORD          0001 0LLL L000 0001
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Subject           1 Reference-Record
Object            1 Reference-Record
```

## Interpretation und Gültigkeit

- Subject und Object werden in dieser Reihenfolge serialisiert und müssen jeweils genau ein vollständiger [Reference](/de/grammar/reference/)-Record sein. Die Grenze findet man über die Length jedes Records.
- Ist das Subject oder Object ein Value, ein Edge oder ein unvollständiger Record, ist es invalid.
- Die SAME-NODE-Beziehung ist reflexiv, symmetrisch und transitiv. Die Reihenfolge von Subject/Object im wire dient dem Framing und erzeugt keine Bedeutungsrichtung. Implementierungen müssen diese Beziehung in beide Richtungen durchsuchen können.
- Verschiedene [LOCAL](/de/grammar/reference/local/) IDs sind nur verschiedene Reference und kein Beleg dafür, dass der Referent gleich oder verschieden ist. Dass zwei Reference auf denselben Referenten verweisen, stellt man mit SAME-NODE fest.
- Interpretation und Schlussfolgerung müssen Quelle, Zeitpunkt, world und policy scope des Dokuments, das dieses Edge enthält, und des Urteilsgraphen bewahren. SAME-NODE wird nicht als Grundlage für eine kontextunabhängige globale Zusammenführung verwendet.
- Auch bei vorhandenem SAME-NODE werden die ursprünglichen Reference-Records oder die Abstammung weder gelöscht noch überschrieben.
- Stehen für dasselbe Paar SAME-NODE und [DIFFERENT-NODE](/de/grammar/edge/different-node/) zusammen, ist das wire dadurch nicht invalid. Der Kontext jeder Behauptung bleibt erhalten, und sie wird als Konflikt bewertet.
- Man verbindet ein Variable Reference mit einem Identified Reference per SAME-NODE, um die Variable aufzulösen ([Reference](/de/grammar/reference/), Variable).

## Länge

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

## Beispiel (nicht normativ)

Edge Id `0009`, Subject ist LOCAL 1, Object ist LOCAL 2.

- Das Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. Das TAG ist `0001 0 0110 0000001` = `1301`.

```
1301 0088 0009 0088 0001 0088 0002
```

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [REFERENCE-NODE](/de/grammar/edge/reference-node/), [DIFFERENT-NODE](/de/grammar/edge/different-node/)
- [Reference](/de/grammar/reference/), [LOCAL](/de/grammar/reference/local/)
