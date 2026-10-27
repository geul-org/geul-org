---
title: "Value — Vektor"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "Vektor format Issuer keluarga NUMERIC (ADHOC `0x05xx`, KHRONOS): vektor padat bilangan bulat·riil, titik 2·3 dimensi, bounding box, piksel RGBA8·BGRA8."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Format vektor adalah format Issuer keluarga NUMERIC. Vektor padat bilangan bulat·riil serta titik·bounding box ditaruh pada nomor format `0x0500`~`0x050C` ADHOC (`0x0001`), dan format piksel di bawah KHRONOS (`0x0041`).

- Elemen vektor padat disimpan berurutan secara big-endian.
- Karena format Issuer, Codec extension TAG disertai Issuer dan nomor format 2 WORD.
