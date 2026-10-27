---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE ist ein Nicht-Identitäts-Edge (Codec 0x02), das erklärt, dass zwei Reference auf verschiedene Objekte verweisen."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE ist ein Nicht-Identitäts-Edge, das erklärt, dass zwei Reference auf verschiedene Referenten verweisen. Codec `0x02`.

Es bedeutet nicht, dass Byte-Kodierung, Codec und ID zweier Reference-Records verschieden sind. Es ist abzugrenzen von der gerichteten Bindung von [REFERENCE-NODE](/de/grammar/edge/reference-node/) und der Identität von [SAME-NODE](/de/grammar/edge/same-node/).

## Layout

```
TAG WORD          0001 0LLL L000 0010
[Length-Erweiterungs-TAG]
Edge Id           LOCAL-Reference-Record
Subject           1 Reference-Record
Object            1 Reference-Record
```

## Interpretation und Gültigkeit

- Subject und Object müssen jeweils genau ein vollständiger [Reference](/de/grammar/reference/)-Record sein. Die Grenze findet man über die Length jedes Records; ist es ein Value oder ein Edge oder unvollständig, ist es invalid.
- Subject und Object verweisen auf verschiedene Referenten. Allein aus Unterschieden in Bytefolge, Codec oder ID der Reference-Records schließt man nicht, dass die Referenten verschieden sind.
- Insbesondere sind verschiedene [LOCAL](/de/grammar/reference/local/) IDs nur verschiedene Reference und bedeuten nicht, dass auch die Referenten in der Wirklichkeit verschieden sind. Allein aus einem Unterschied der LOCAL IDs leitet man kein DIFFERENT ab.
- Nicht-Identität ist symmetrisch, irreflexiv und nicht transitiv. `DIFFERENT(A, B)` ist dieselbe Beziehung wie `DIFFERENT(B, A)`. Aus `DIFFERENT(A, B)` und `DIFFERENT(B, C)` schließt man jedoch nicht auf `DIFFERENT(A, C)`.
- Die Reihenfolge von Subject/Object im wire ist nur die Serialisierungsreihenfolge für das Framing und erzeugt keine Bedeutungsrichtung. Implementierungen müssen in beide Richtungen durchsuchen können.
- Der Cursor nach dem Lesen beider Komponenten muss genau mit dem Ende des Edge übereinstimmen.

Die Beziehung selbst ist irreflexiv, aber eine strukturell valide Behauptung `DIFFERENT(A, A)` oder eine Behauptung, in der SAME und DIFFERENT aufeinanderprallen, darf nicht als wire-Grammatikfehler gelöscht werden. Solche Behauptungen bewahren Kontext und Abstammung und werden in der Urteilsebene als Widerspruch behandelt. Wenn man DIFFERENT interpretiert oder ableitet, bewahrt man Quelle, Zeitpunkt, world und policy scope des Dokuments, das dieses Edge enthält, und weitet es nicht zu einer globalen Schlussfolgerung aus, die diese ignoriert.

## Länge

```
Gesamt = 1 + N_len + N_id + N_subject + N_object WORD
```

## Beispiel (nicht normativ)

Edge Id `000a`, Subject ist LOCAL 1, Object ist LOCAL 2.

- Das Edge hat TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. Das TAG ist `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

Der Unterschied der LOCAL IDs in diesem Beispiel soll nur die Kodierung zeigen. Diese Sequenz wird nur dann zu einem DIFFERENT-NODE, wenn es eine eigene Behauptung gibt, dass ID 1 und ID 2 auf verschiedene Referenten verweisen.

## Verwandte Seiten

- [Edge](/de/grammar/edge/), [REFERENCE-NODE](/de/grammar/edge/reference-node/), [SAME-NODE](/de/grammar/edge/same-node/)
- [Reference](/de/grammar/reference/), [LOCAL](/de/grammar/reference/local/)
