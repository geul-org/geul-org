---
title: "GEUL"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "GEUL adalah Reference deklarasi yang menunjuk target dengan ID entitas yang diterbitkan geul.org sebagai CC0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GEUL adalah Reference deklarasi yang menunjuk entitas yang diterbitkan geul.org sebagai CC0. Ia adalah ID berurutan yang nomornya tidak memuat makna. Pengenal yang bitnya memuat makna ditangani Codec tersendiri, [GEUL-SIDX](/id/grammar/reference/geul-sidx/) (`0011`).

## Layout

```
TAG WORD          0000 0LLL L001 0QQQ      CCCC = 0010
[Length extension TAG]
GEUL ID           unsigned big-endian dengan lebar terpendek
```

- Nomor kecil dialokasikan untuk entitas berfrekuensi tinggi. ID yang muat dalam 1 WORD berukuran total 2 WORD.
- Alokasi ID dan registri dikelola geul.org. Registri hanya diisi yang berasal dari sumber CC0.
- Jika Variable, itu adalah variabel anonim dari jenis tersebut ([Reference](/id/grammar/reference/) Variable).

## Contoh

| GEUL ID | WORD sequence |
|---|---|
| 1, Identified | `0090 0001` |
| 1, Variable | `0094 0001` |
| 70000, Generic | `0111 0001 1170` |

## Masalah terbuka

- Aturan alokasi GEUL ID dan format publik registri.

## Halaman terkait

- [Reference](/id/grammar/reference/), [GEUL-SIDX](/id/grammar/reference/geul-sidx/)
