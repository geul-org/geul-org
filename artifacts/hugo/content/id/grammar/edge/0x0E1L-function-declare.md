---
title: "FUNCTION-DECLARE (0x0E1L)"
weight: 225
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "FUNCTION-DECLARE adalah Codec kelompok deklarasi Edge eksekusi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

FUNCTION-DECLARE adalah Codec kelompok deklarasi Edge eksekusi. Arti: deklarasi fungsi.

| Butir | Nilai |
|---|---|
| Nama | `FUNCTION-DECLARE` (dokumen spesifikasi BIND `FUNCTION-DECLARE`) |
| TAG ID | `0x0E1L` |
| Codec ID | `0x00000E10` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000E10/` (target DECLARE `0E10`) |
| Bagian | 7 `0111` (Edge eksekusi), offset dalam bagian C = 1 |
| Kind | Edge · keluarga: eksekusi, kelompok: deklarasi |
| TAG WORD | `0000 1110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deklarasi fungsi. Simbol, daftar simbol parameter, tipe kembalian, badan (BLOCK) |
| Sisi Hugo | `edge/_index.md` |

## Komponen {#구성요소}

Simbol, daftar simbol parameter, tipe kembalian, badan (BLOCK).

- Komponen ditunjuk dengan LOCAL ID (REF) dokumen ini. REF `0` berarti tidak ada. Pada posisi ekspresi ditaruh Edge ekspresi atau simbol ([Edge](_index.md#실행-edge)).
- Kode operator, representasi tipe, dan layout Payload belum ditetapkan ([Edge](_index.md#실행-edge), masalah terbuka).

## Dokumen codec {#코덱-문서}

Layout belum ditetapkan. Dokumen codec hanya berisi DECLARE (target `0E10`). FIELD ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [Edge — Edge eksekusi](_index.md#실행-edge), [TYPE-DECLARE](0x0E2L-type-declare.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000E10/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E1000000000
BODY
#1 DECLARE 0x0E10
#2 BIND #1 "FUNCTION-DECLARE"
```
