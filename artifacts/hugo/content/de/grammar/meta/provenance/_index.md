---
title: "Meta — Herkunft"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "Die Meta-Herkunftsklasse (obere 3 Bit `010`, `0x20`~`0x2F`) hält fest, wer das Dokument wann erstellt und aufgezeichnet hat. Quellmaterial schreibt man mit dem Beleg-Edge SOURCE."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Meta-Herkunftsklasse (obere 3 Bit `010`, Codec `0x20`~`0x2F`) hält fest, wer das Dokument wann erstellt und aufgezeichnet hat.

- Autor und Aufzeichnende sowie deren Zeitpunkte folgen dem author-/committer-Modell von git (`AUTHOR`/`CREATED-AT`, `RECORDED-BY`/`RECORDED-AT`).
- Die Herkunft kann man löschen, ohne dass sich der Inhalt der Aussagen ändert. Es fehlt nur das Material für Vertrauensurteile.
- Quellmaterial gehört nicht zu dieser Klasse. Die Quelle des gesamten Dokuments steht im HEAD, die Quelle einzelner Records im BODY, jeweils als Beleg-Edge [SOURCE](/de/grammar/edge/source/). Entsprechender Bereich im Originaltext, Beschaffungszeitpunkt und Hash des Originals sind QUALIFIER, die an dieses SOURCE angehängt werden (Seite P304, Abschnitt P958, Abrufdatum P813, Prüfsumme P4092).
- Würde man Eigenschaften der Quelle (Bereich im Originaltext, Beschaffungszeitpunkt) als Meta ablegen, ließe sich bei mehreren Quellen nicht bestimmen, zu welcher Quelle sie gehören. Deshalb schreibt man sie als QUALIFIER, der das SOURCE als Target hat. Die Codecs `0x26`~`0x2F` sind reserviert.
