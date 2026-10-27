---
title: "Meta — Abstammung"
weight: 40
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "Die Meta-Abstammungsklasse (obere 3 Bit `011`, `0x30`~`0x3F`) hält im git-Commit-Modell fest, woraus und wie ein Dokument entstanden ist."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Meta-Abstammungsklasse (obere 3 Bit `011`, Codec `0x30`~`0x3F`) hält fest, woraus und wie ein Dokument entstanden ist. Die Abstammung folgt dem Commit-Modell von git, die Einheit, die einem Commit entspricht, ist das Dokument.

- Der **Inhaltshash** bezeichnet den Inhalt eines Dokuments als Ganzes (git commit id). Es ist das SHA-256 vom öffnenden Record (`DOC-*`) bis unmittelbar vor `END`; Records der Verifikationsklasse (`100`) werden aus der Berechnung ausgenommen.
- Die **Versions-ID** ist eine 2-WORD-Ganzzahl, die innerhalb eines benannten Dokuments in Veröffentlichungsreihenfolge ab 1 vergeben wird. `0` bedeutet, dass keine Version angegeben ist.
- Abstammungs-Meta verweisen per Inhaltshash auf Versionen. Auch das `PARENT` im Dokument geht in den Hash ein, sodass der Inhaltshash eine Hashkette über die gesamte Historie bildet.
- Die Historie wird nicht gelöscht. Korrekturen erscheinen als neue Version. Veränderliche Zeiger wie Branches stehen nicht im Dokument.
- `DELTA-BASE` und `DELTA-REMOVE` sind ein Format, das eine Version als Diff gegen eine Basisversion speichert. Eine Version ist immer als Snapshot definiert.

Die Revisionsregeln stehen unter [Dokument](/de/grammar/document/).
