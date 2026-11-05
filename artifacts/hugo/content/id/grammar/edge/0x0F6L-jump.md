---
title: "JUMP (0x0F6L)"
weight: 246
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "JUMP adalah Codec kelompok statement Edge eksekusi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

JUMP adalah Codec kelompok statement Edge eksekusi. Arti: kontrol perulangan.

| Butir | Nilai |
|---|---|
| Nama | `JUMP` (dokumen spesifikasi BIND `JUMP`) |
| TAG ID | `0x0F6L` |
| Codec ID | `0x00000F60` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000F60/` (target DECLARE `0F60`) |
| Bagian | 7 `0111` (Edge eksekusi), offset dalam bagian C = 22 |
| Kind | Edge · keluarga: eksekusi, kelompok: statement |
| TAG WORD | `0000 1111 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Kontrol perulangan. Jenis 1 WORD (break, continue), perulangan target |
| Sisi Hugo | `edge/_index.md` |

## Komponen {#구성요소}

Jenis 1 WORD (break, continue), perulangan target.

- Komponen ditunjuk dengan LOCAL ID (REF) dokumen ini. REF `0` berarti tidak ada. Pada posisi ekspresi ditaruh Edge ekspresi atau simbol ([Edge](_index.md#실행-edge)).
- Kode operator, representasi tipe, dan layout Payload belum ditetapkan ([Edge](_index.md#실행-edge), masalah terbuka).

## Dokumen codec {#코덱-문서}

Layout belum ditetapkan. Dokumen codec hanya berisi DECLARE (target `0F60`). FIELD ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [Edge — Edge eksekusi](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [ASSIGN](0x0F1L-assign.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [RETURN](0x0F7L-return.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000F60/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F6000000000
BODY
#1 DECLARE 0x0F60
#2 BIND #1 "JUMP"
```
