---
title: "Meta — Verifikation"
weight: 50
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "Die Meta-Verifikationsklasse (obere 3 Bit `100`, `0x40`~`0x4F`) hält Material zur Beurteilung fest, ob man einem Dokument vertrauen kann (öffentlicher Schlüssel, Signatur, Konfidenz, Urteil)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Meta-Verifikationsklasse (obere 3 Bit `100`, Codec `0x40`~`0x4F`) hält Material zur Beurteilung fest, ob man einem Dokument vertrauen kann: den öffentlichen Schlüssel eines selbst ausgestellten Issuers, Signatur, Bestätigung des Beitragsrechts, Konfidenz und das Urteilsergebnis über das gesamte Dokument.

- Die Verifikationsklasse bleibt bei der Berechnung des Inhaltshashs außen vor. Deshalb ändert sich der Inhaltshash weder, wenn man die Signatur ins Dokument legt, noch, wenn man weitere Signaturen hinzufügt (wie bei git `gpgsig`).
- Die Klasse erkennt man an den oberen 3 Bit des Codec, sodass man den Hash ohne Codebook berechnen kann.
- Urteile auf Ebene von Knoten und Records übernimmt das [TOULMIN](/de/grammar/edge/toulmin/)-Edge `VERDICT` (`0x78`).
