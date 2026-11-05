---
title: "ASSIGN (0x0F1L)"
weight: 241
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "ASSIGN adalah Codec kelompok statement Edge eksekusi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ASSIGN adalah Codec kelompok statement Edge eksekusi. Arti: penugasan.

| Butir | Nilai |
|---|---|
| Nama | `ASSIGN` (dokumen spesifikasi BIND `ASSIGN`) |
| TAG ID | `0x0F1L` |
| Codec ID | `0x00000F10` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000F10/` (target DECLARE `0F10`) |
| Bagian | 7 `0111` (Edge eksekusi), offset dalam bagian C = 17 |
| Kind | Edge · keluarga: eksekusi, kelompok: statement |
| TAG WORD | `0000 1111 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Penugasan. Target (simbol, MEMBER, INDEX), nilai |
| Sisi Hugo | `edge/_index.md` |

## Komponen {#구성요소}

Target (simbol, MEMBER, INDEX), nilai.

- Komponen ditunjuk dengan LOCAL ID (REF) dokumen ini. REF `0` berarti tidak ada. Pada posisi ekspresi ditaruh Edge ekspresi atau simbol ([Edge](_index.md#실행-edge)).
- Kode operator, representasi tipe, dan layout Payload belum ditetapkan ([Edge](_index.md#실행-edge), masalah terbuka).

## Dokumen codec {#코덱-문서}

Layout belum ditetapkan. Dokumen codec hanya berisi DECLARE (target `0F10`). FIELD ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [Edge — Edge eksekusi](_index.md#실행-edge), [BLOCK](0x0F0L-block.md), [IF](0x0F2L-if.md), [SWITCH](0x0F3L-switch.md), [WHILE](0x0F4L-while.md), [FOREACH](0x0F5L-foreach.md), [JUMP](0x0F6L-jump.md), [RETURN](0x0F7L-return.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000F10/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000F1000000000
BODY
#1 DECLARE 0x0F10
#2 BIND #1 "ASSIGN"
```
