---
title: "BLOCK (0x0F0L)"
weight: 240
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "BLOCK adalah Codec kelompok statement Edge eksekusi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BLOCK adalah Codec kelompok statement Edge eksekusi. Arti: kumpulan statement berurutan.

| Butir | Nilai |
|---|---|
| Nama | `BLOCK` (dokumen spesifikasi BIND `BLOCK`) |
| TAG ID | `0x0F0L` |
| Codec ID | `0x00000F00` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000F00/` (target DECLARE `0F00`) |
| Bagian | 7 `0111` (Edge eksekusi), offset dalam bagian C = 16 |
| Kind | Edge · keluarga: eksekusi, kelompok: statement |
| TAG WORD | `0000 1111 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Kumpulan statement berurutan. Jumlah statement, statement × jumlah statement |
| Sisi Hugo | `edge/_index.md` |

## Komponen {#구성요소}

Jumlah statement, statement × jumlah statement.

- Komponen ditunjuk dengan LOCAL ID (REF) dokumen ini. REF `0` berarti tidak ada. Pada posisi ekspresi ditaruh Edge ekspresi atau simbol ([Edge](_index.md#실행-edge)).
- Kode operator, representasi tipe, dan layout Payload belum ditetapkan ([Edge](_index.md#실행-edge), masalah terbuka).

## Dokumen codec {#코덱-문서}

Layout belum ditetapkan. Dokumen codec hanya berisi DECLARE (target `0F00`). FIELD ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [Edge — Edge eksekusi](_index.md#실행-edge), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000F00/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F0000000000
BODY
#1 DECLARE 0x0F00
#2 BIND #1 "BLOCK"
```
