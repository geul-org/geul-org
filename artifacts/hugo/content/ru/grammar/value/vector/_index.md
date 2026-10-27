---
title: "Value — векторы"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "Векторы как форматы Issuer семейства NUMERIC (ADHOC `0x05xx`, KHRONOS): плотные целочисленные и вещественные векторы, 2D- и 3D-точки, ограничивающий прямоугольник, пиксели RGBA8 и BGRA8."
author: "Джунву Пак"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Векторные форматы — это форматы Issuer семейства NUMERIC. Плотные целочисленные и вещественные векторы, точки и ограничивающий прямоугольник занимают номера форматов `0x0500`–`0x050C` под ADHOC (`0x0001`); пиксельные форматы находятся под KHRONOS (`0x0041`).

- Элементы плотного вектора хранятся подряд в порядке big-endian.
- Это форматы Issuer, поэтому к Codec extension TAG добавляются 2 WORD: Issuer и номер формата.
