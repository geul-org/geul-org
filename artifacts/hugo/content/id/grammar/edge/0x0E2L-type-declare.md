---
title: "TYPE-DECLARE (0x0E2L)"
weight: 226
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "TYPE-DECLARE adalah Codec kelompok deklarasi Edge eksekusi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

TYPE-DECLARE adalah Codec kelompok deklarasi Edge eksekusi. Arti: deklarasi tipe.

| Butir | Nilai |
|---|---|
| Nama | `TYPE-DECLARE` (dokumen spesifikasi BIND `TYPE-DECLARE`) |
| TAG ID | `0x0E2L` |
| Codec ID | `0x00000E20` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000E20/` (target DECLARE `0E20`) |
| Bagian | 7 `0111` (Edge eksekusi), offset dalam bagian C = 2 |
| Kind | Edge · keluarga: eksekusi, kelompok: deklarasi |
| TAG WORD | `0000 1110 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deklarasi tipe. Simbol dan komposisi (daftar simbol field, nilai enumerasi, target alias) |
| Sisi Hugo | `edge/_index.md` |

## Komponen {#구성요소}

Simbol dan komposisi (daftar simbol field, nilai enumerasi, target alias).

- Komponen ditunjuk dengan LOCAL ID (REF) dokumen ini. REF `0` berarti tidak ada. Pada posisi ekspresi ditaruh Edge ekspresi atau simbol ([Edge](_index.md#실행-edge)).
- Kode operator, representasi tipe, dan layout Payload belum ditetapkan ([Edge](_index.md#실행-edge), masalah terbuka).

## Dokumen codec {#코덱-문서}

Layout belum ditetapkan. Dokumen codec hanya berisi DECLARE (target `0E20`). FIELD ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [Edge — Edge eksekusi](_index.md#실행-edge), [FUNCTION-DECLARE](0x0E1L-function-declare.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000E20/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E2000000000
BODY
#1 DECLARE 0x0E20
#2 BIND #1 "TYPE-DECLARE"
```
