---
title: "NEXT-LOCAL-ID"
weight: 61
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "NEXT-LOCAL-ID ist ein Abstammungs-Meta, das in der Versionsliste die LOCAL ID festhält, die die nächste Version des Dokuments einer neuen Aussage zuweist (Auto-Increment)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Hält die LOCAL ID fest, die die nächste Version des Dokuments einer neuen Aussage zuweist (Auto-Increment im DBMS, MySQL `AUTO_INCREMENT`). Alle in irgendeiner Version des Dokuments vergebenen LOCAL IDs sind kleiner als dieser Wert.

## Layout

```
TAG WORD          0001 1LLL L011 1100      Codec 0x3C
Payload           nächste zu vergebende LOCAL ID, unsigned Ganzzahl in der kürzesten Breite
```

- Codec: Meta `0x3C`, Abstammungsklasse (`011`)
- Payload: Rohwert (unsigned Ganzzahl in der kürzesten Breite)
- Anzahl: höchstens eins
- Ablageort: HEAD des Versionslisten-Dokuments `versions.geul` ([PUBLICATION](/de/grammar/edge/publication/))

## Interpretation und Gültigkeit

- Die LOCAL ID (einschließlich Edge Id) ist eine versionsübergreifende Identität ([Revision](/de/grammar/document/#revision)). Eine neue Aussage erhält diesen Wert, und der Wert wächst um 1. Gelöschte LOCAL IDs werden nicht wiederverwendet. Deshalb sinkt der Wert nicht, auch wenn die Aussage mit dem Höchstwert gelöscht wird.
- Die LOCAL ID `0` wird nicht vergeben, daher ist der Anfangswert `1`. Gibt es noch keine Version, steht dieses Meta nicht, und die nächste Nummer ist `1`.
- Die veröffentlichende Stelle trägt ihn beim Veröffentlichen einer Version aktualisiert in das neue Listendokument ein. Er muss größer sein als jede LOCAL ID, die in veröffentlichten Versionen verwendet wurde. Kleiner oder gleich ist invalid.
- Der Wert wächst nur. Ist er kleiner als der Wert im vorherigen Listendokument ([PARENT](/de/grammar/meta/lineage/parent/)), ist er invalid.
- Bei Dokumenten ohne Versionsverwaltung (Dokumente ohne `versions.geul`, namenlose Dokumente) gibt es ihn nicht. Solche Dokumente haben auch keinen Diff ([DELTA-BASE](/de/grammar/meta/lineage/delta-base/)).
- Im Dokumenttext (Versionsdokument) steht er nicht. Das Merken der Nummer ist kein Dokumentinhalt, sondern Zustand der veröffentlichenden Stelle, die das Dokument fortschreibt (nicht Commit, sondern refs in git).

## Beispiel

Nächste Vergabenummer 524:

```
18BC 020C
```

- TAG `18BC` (Meta `0x3C`, `LLLL=0001`, 2 WORD), Payload `020C`.
