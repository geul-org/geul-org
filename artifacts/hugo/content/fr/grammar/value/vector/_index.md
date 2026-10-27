---
title: "Value — Vecteurs"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "Vecteurs en formats d'Issuer de la famille NUMERIC (ADHOC `0x05xx`, KHRONOS) : vecteurs denses d'entiers et de réels, points 2D et 3D, boîtes englobantes, pixels RGBA8 et BGRA8."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Les formats de vecteurs sont des formats d'Issuer de la famille NUMERIC. Les vecteurs denses d'entiers et de réels, les points et les boîtes englobantes sont des numéros de format ADHOC (`0x0001`) `0x0500`~`0x050C`, les formats de pixels se placent sous KHRONOS (`0x0041`).

- Les éléments d'un vecteur dense sont stockés en continu en big-endian.
- Comme ce sont des formats d'Issuer, le TAG d'extension de Codec ajoute 2 WORD d'Issuer et de numéro de format.
