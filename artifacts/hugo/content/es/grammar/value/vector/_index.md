---
title: "Value — vector"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "Vectores como formatos de Issuer de la familia NUMERIC (ADHOC `0x05xx`, KHRONOS): vectores densos de enteros y reales, puntos 2D y 3D, cuadro delimitador y píxeles RGBA8 y BGRA8."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Los formatos de vector son formatos de Issuer de la familia NUMERIC. Los vectores densos de enteros y reales, los puntos y el cuadro delimitador se ubican en ADHOC (`0x0001`), con números de formato `0x0500` a `0x050C`; los formatos de píxel, bajo KHRONOS (`0x0041`).

- Los elementos de un vector denso se almacenan de forma contigua en big-endian.
- Al ser formatos de Issuer, el TAG de extensión de Codec lleva añadidos 2 WORD: el Issuer y el número de formato.
