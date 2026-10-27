---
title: "Value — Vector"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "Vectors among the NUMERIC-family Issuer formats (ADHOC `0x05xx`, KHRONOS): dense integer and real vectors, 2- and 3-dimensional points, bounding boxes, and RGBA8 and BGRA8 pixels."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

The vector formats are NUMERIC-family Issuer formats. Dense integer and real vectors, points, and bounding boxes are placed in ADHOC (`0x0001`) format numbers `0x0500`-`0x050C`, and pixel formats under KHRONOS (`0x0041`).

- The elements of a dense vector are stored contiguously in big-endian.
- Since they are Issuer formats, a Codec extension TAG carries the Issuer and format number, 2 WORDs.
