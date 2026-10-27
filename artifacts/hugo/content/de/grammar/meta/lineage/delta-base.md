---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE ist ein Abstammungs-Meta, das markiert, dass diese Versionsdatei ein Diff gegen eine Basisversion desselben Dokuments ist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Markiert, dass diese Versionsdatei kein Snapshot, sondern ein **Diff** gegen eine Basisversion desselben Dokuments ist (Delta im git packfile). Die Version selbst ist weiterhin als Snapshot definiert. Inhaltshash, Versionsliste und Signaturen beziehen sich alle auf den Snapshot, der durch Anwenden des Diffs wiederhergestellt wird ([Diff-Speicherung](/de/grammar/document/#diff-speicherung)).

## Layout

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
Versions-ID       2 WORD unsigned (Basisversion desselben Dokuments)
```

- Codec: Meta `0x3A`, Abstammungsklasse (`011`)
- Payload: 2-WORD-Versions-ID (Rohwert)
- Anzahl: höchstens eins

## Interpretation und Gültigkeit

- Wird nur in Dokumenten mit [DOC-ID](/de/grammar/meta/declaration/doc-id/) verwendet (Dokumente, deren Versionen über eine Versionsliste verwaltet werden). Bei `versions.geul`, `documents.geul` und `issuers.geul`, die keine Versionsverwaltung haben, sowie bei namenlosen Dokumenten gibt es keine Diffs.
- Die Basisversion ist eine veröffentlichte Version derselben `DOC-ID` und liegt vor dieser Version. `0` (keine Version) ist invalid.
- Der Inhaltshash des wiederhergestellten Snapshots muss mit dem Hash dieser Version in der Versionsliste ([PUBLICATION](/de/grammar/edge/publication/)) übereinstimmen. Andernfalls ist dieser Diff invalid. Deshalb wird der Ergebnis-Hash nicht noch einmal im Diff angegeben.
- Nur Dokumente, deren BODY-Records alle Edges sind (Records mit Edge Id), können als Diff abgelegt werden, weil die Diff-Einheit die LOCAL ID (Edge Id) ist.
- Die Regeln zur Snapshot-Wiederherstellung folgen [Diff-Speicherung](/de/grammar/document/#diff-speicherung). Löschungen übernimmt [DELTA-REMOVE](/de/grammar/meta/lineage/delta-remove/).
- Marker für Hinzufügen oder Revision gibt es nicht. Ist die Edge Id im BODY des Diffs in der Basis vorhanden, ist es eine Revision, sonst ein Hinzufügen. Hinzugefügte Edges erhalten Nummern ab [NEXT-LOCAL-ID](/de/grammar/meta/lineage/next-local-id/) der Versionsliste. Die Wiederverwendung einer gelöschten LOCAL ID ist invalid ([Revision](/de/grammar/document/#revision)).

## Beispiel

Diff gegen Basisversion 3:

```
193A 0000 0003
```

- TAG `193A` (Meta `0x3A`, `LLLL=0010`, 3 WORD), Versions-ID `0000 0003`.

## Offene Fragen

1. Snapshot-Abstand: nach wie vielen Versionen ein vollständiger Snapshot abgelegt wird (Länge der Diff-Kette gegen Wiederherstellungskosten).
2. Ob die Basisversion auf die unmittelbar vorherige Version beschränkt werden soll.
3. Speicherort der Diff-Datei: ob am Platz der Versionsdatei (`<Versions-ID>.geul`) und in welchem Verhältnis zum inhaltsadressierten Speicher `h/` (`h/` wird über den Inhaltshash des Snapshots gefunden).
