---
title: "Value — Bilangan"
weight: 10
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "Format bilangan dasar keluarga NUMERIC (Codec `0x00`~`0x0F`): BOOL, bilangan bulat, floating-point IEEE 754, koordinat Bumi·benda langit, QUANTITY dengan satuan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Format bilangan dasar keluarga NUMERIC. Ditaruh pada kode langsung `0x00`~`0x0F` (3 bit atas Codec `000`) dan nomor format Issuer `0x0000`~`0x1FFF`.

- Ada BOOL, bilangan bulat bertanda·tanpa tanda, floating-point biner IEEE 754, koordinat Bumi (WGS 84)·benda langit, serta QUANTITY yang menggabungkan kuantitas·satuan·batas.
- Bilangan bulat ditulis dengan WORD minimum tempat nilainya muat.
- Format Issuer scalar kecil (BFLOAT16, FP8, FP4) hanya nomor formatnya yang dialokasikan dan belum ada spesifikasi rinci (masalah terbuka [Value](/id/grammar/value/#masalah-terbuka)).
- Vektor, tensor, bilangan kompleks, pecahan, dan interval juga keluarga NUMERIC, tetapi karena format Issuer maka ditaruh pada kelompok [vector](/id/grammar/value/vector/), [tensor](/id/grammar/value/tensor/), dan [etc](/id/grammar/value/etc/).
