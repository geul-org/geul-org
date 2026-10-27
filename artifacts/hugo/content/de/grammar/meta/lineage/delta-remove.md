---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE ist ein Abstammungs-Meta, das in einem Diff die LOCAL IDs (Edge Ids) auflistet, die aus dem BODY des Basis-Snapshots zu entfernen sind."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Listet im Diff ([DELTA-BASE](/de/grammar/meta/lineage/delta-base/)) die LOCAL IDs (Edge Ids) der Records auf, die aus dem BODY des Basis-Snapshots zu entfernen sind ("Artikel X gestrichen").

## Layout

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length-Erweiterungs-TAG]
Zu löschende LOCAL IDs    LOCAL-Reference-Record × mindestens 1
```

- Codec: Meta `0x3B`, Abstammungsklasse (`011`)
- Payload: mindestens ein [LOCAL](/de/grammar/reference/local/)-Reference-Record
- Anzahl: höchstens eins

## Interpretation und Gültigkeit

- Steht nur in Dokumenten mit `DELTA-BASE`.
- Jede LOCAL ID muss eine Edge Id sein, die im BODY des Basis-Snapshots vorkommt. Andernfalls ist sie invalid. Dieselbe ID zweimal anzugeben ist invalid.
- Dieselbe Edge Id erneut im BODY desselben Diffs anzugeben ist invalid (Löschen und Revidieren zugleich ist nicht möglich).
- Eine gelöschte LOCAL ID wird in späteren Versionen keinem anderen Ziel neu zugewiesen ([Revision](/de/grammar/document/#revision)).
- Fehlt ein Record im BODY des Diffs, bedeutet das "unverändert". Deshalb wird Löschen nur über dieses Meta ausgedrückt.
- HEAD-Edges (das [SOURCE](/de/grammar/edge/source/#quelle-des-gesamten-dokuments) für das gesamte Dokument und dessen QUALIFIER) werden nicht aufgeführt. Der HEAD wird als HEAD des Diffs als Ganzes ersetzt ([Diff-Speicherung](/de/grammar/document/#diff-speicherung)).

## Beispiel

LOCAL `#7` und `#12` löschen:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`, `LLLL=0100`, 5 WORD), LOCAL-Reference `0088 0007`, `0088 000C`.
