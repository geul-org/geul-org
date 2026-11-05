---
title: "TRY (0x0F9L)"
weight: 249
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TRY adalah Codec kelompok galat Edge eksekusi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TRY adalah Codec kelompok galat Edge eksekusi. Arti: penanganan galat.

| Butir | Nilai |
|---|---|
| Nama | `TRY` (dokumen spesifikasi BIND `TRY`) |
| TAG ID | `0x0F9L` |
| Codec ID | `0x00000F90` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000F90/` (target DECLARE `0F90`) |
| Bagian | 7 `0111` (Edge eksekusi), offset dalam bagian C = 25 |
| Kind | Edge · keluarga: eksekusi, kelompok: galat |
| TAG WORD | `0000 1111 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Penanganan galat. BLOCK badan, simbol galat, BLOCK penanganan, BLOCK penutup (0 jika tidak ada) |
| Sisi Hugo | `edge/_index.md` |

## Komponen {#구성요소}

BLOCK badan, simbol galat, BLOCK penanganan, BLOCK penutup (0 jika tidak ada).

- Komponen ditunjuk dengan LOCAL ID (REF) dokumen ini. REF `0` berarti tidak ada. Pada posisi ekspresi ditaruh Edge ekspresi atau simbol ([Edge](_index.md#실행-edge)).
- Kode operator, representasi tipe, dan layout Payload belum ditetapkan ([Edge](_index.md#실행-edge), masalah terbuka).

## Dokumen codec {#코덱-문서}

Layout belum ditetapkan. Dokumen codec hanya berisi DECLARE (target `0F90`). FIELD ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [Edge — Edge eksekusi](_index.md#실행-edge), [RAISE](0x0F8L-raise.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000F90/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F9000000000
BODY
#1 DECLARE 0x0F90
#2 BIND #1 "TRY"
```
