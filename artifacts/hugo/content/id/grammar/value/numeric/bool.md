---
title: "BOOL"
weight: 1
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL adalah Value 2 WORD tetap yang memuat nilai logika false dan true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BOOL adalah Value yang menyatakan nilai logika false dan true. Kode langsung Value `0x00`, keluarga NUMERIC. Ini tipe yang berbeda dari SIGNED-INTEGER·UNSIGNED-INTEGER yang memuat angka 0 dan 1.

## Layout

```
TAG WORD          0x0880 (0000 1000 1000 0000)  total 2 WORD
Payload           1 WORD  Boolean Code
```

## Interpretasi dan validitas

- Payload `0000` adalah false, dan `0001` adalah true.
- Tidak ada padding atau descriptor.
- Payload tepat `0000` atau `0001`. Nilai 16 bit lain ditolak sebagai invalid.
- Semua penyajian Length lain ditolak sebagai invalid.

## Panjang

- Total tepat 2 WORD, yaitu jumlah TAG 1 WORD dan Payload 1 WORD, dengan panjang langsung `LLLL=0001`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 1 WORD, ditolak.

## Contoh

| Record lengkap (TAG + Payload) | Payload | Penilaian |
|---|---|---|
| `0880 0000` | `0000` | false, kanonik |
| `0880 0001` | `0001` | true, kanonik |
| `0880 0002` | `0002` | invalid |
| `0880 ffff` | `ffff` | invalid |
| TAG yang Length-nya bukan `0001` + `0000` atau `0001` | `0000` atau `0001` | invalid |

## Status format

- Representasi yang menggabungkan code word 16 bit `0000`/`0001` dan TAG GEUL ini adalah profil scalar khas GEUL.
- Nilai logika itu sendiri bersifat universal, tetapi tidak diklaim ada satu standar industri tunggal yang berpadanan dengan representasi 1 WORD ini.
