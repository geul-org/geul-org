---
title: "Meta — Richtlinie"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "policy"]
summary: "Die Meta-Richtlinienklasse (obere 3 Bit `101`, `0x50`~`0x5F`) legt fest, wie mit einem Dokument umzugehen ist (Lizenz, Zugriffsbereich, Datenschutz, Aufbewahrung, Einwilligung, Nutzungsbeschränkung)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Die Meta-Richtlinienklasse (obere 3 Bit `101`, Codec `0x50`~`0x5F`) legt fest, wie mit einem Dokument umzugehen ist: Lizenz, Zugriffsbereich, Datenschutzstufe, Aufbewahrungsfrist, Einwilligung und Nutzungsbeschränkung.

- Eine Richtlinie ändert nicht die Interpretation, sondern legt den Umgang fest.
- Die ursprüngliche Lizenz eines in der Bytefolge enthaltenen Werkes wird mit `LICENSE` festgehalten.
