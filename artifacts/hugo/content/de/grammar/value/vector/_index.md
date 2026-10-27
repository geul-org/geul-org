---
title: "Value — Vektor"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "Vektoren als Issuer-Formate der NUMERIC-Familie (ADHOC `0x05xx`, KHRONOS): dichte Vektoren aus Ganz- und Gleitkommazahlen, 2D- und 3D-Punkte, Bounding Box, RGBA8- und BGRA8-Pixel."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Vektorformate sind Issuer-Formate der NUMERIC-Familie. Dichte Vektoren aus Ganz- und Gleitkommazahlen sowie Punkte und Bounding Boxes liegen unter den ADHOC-Formatnummern (`0x0001`) `0x0500`~`0x050C`, Pixelformate unter KHRONOS (`0x0041`).

- Die Elemente dichter Vektoren werden zusammenhängend in Big-Endian abgelegt.
- Da es Issuer-Formate sind, folgen im Codec-Erweiterungs-TAG der Issuer und die Formatnummer mit 2 WORD.
