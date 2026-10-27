---
title: "CONFIDENCE"
weight: 68
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "CONFIDENCE adalah Meta verifikasi yang mencatat tingkat kepercayaan seluruh dokumen sebagai Value desimal antara 0 dan 1."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat tingkat kepercayaan seluruh dokumen. Kepercayaan pada tingkat record ditulis dengan QUALIFIER yang melekat pada Edge target (propertinya belum ditentukan, [SOURCE](/id/grammar/edge/source/#ungkapan-dasar-lain)).

## Layout

```
TAG WORD          0001 1LLL L100 0011      Codec 0x43
[Length extension TAG]
Payload           Value UNSIGNED-DECIMAL, antara 0 dan 1 (inklusif)
```

- Codec: Meta `0x43`, kelas verifikasi (`100`)
- Payload: Value tersemat ([UNSIGNED-DECIMAL](/id/grammar/value/decimal/unsigned-decimal/))
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Siapa yang memberi nilai dicatat bersamanya dengan [GENERATED-BY](/id/grammar/meta/lineage/generated-by/), dll.

## Masalah terbuka

- Skala (0~1) dan hubungannya dengan putusan TOULMIN.
