---
title: "CALL (0x0EBL)"
weight: 235
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "CALL adalah Codec kelompok ekspresi Edge eksekusi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CALL adalah Codec kelompok ekspresi Edge eksekusi. Arti: pemanggilan.

| Butir | Nilai |
|---|---|
| Nama | `CALL` (dokumen spesifikasi BIND `CALL`) |
| TAG ID | `0x0EBL` |
| Codec ID | `0x00000EB0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000EB0/` (target DECLARE `0EB0`) |
| Bagian | 7 `0111` (Edge eksekusi), offset dalam bagian C = 11 |
| Kind | Edge · keluarga: eksekusi, kelompok: ekspresi |
| TAG WORD | `0000 1110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Pemanggilan. Fungsi target, jumlah argumen, argumen × jumlah argumen |
| Sisi Hugo | `edge/_index.md` |

## Komponen {#구성요소}

Fungsi target, jumlah argumen, argumen × jumlah argumen.

- Komponen ditunjuk dengan LOCAL ID (REF) dokumen ini. REF `0` berarti tidak ada. Pada posisi ekspresi ditaruh Edge ekspresi atau simbol ([Edge](_index.md#실행-edge)).
- Kode operator, representasi tipe, dan layout Payload belum ditetapkan ([Edge](_index.md#실행-edge), masalah terbuka).

## Dokumen codec {#코덱-문서}

Layout belum ditetapkan. Dokumen codec hanya berisi DECLARE (target `0EB0`). FIELD ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [Edge — Edge eksekusi](_index.md#실행-edge), [CONST](0x0E8L-const.md), [UNARY](0x0E9L-unary.md), [BINARY](0x0EAL-binary.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000EB0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000EB000000000
BODY
#1 DECLARE 0x0EB0
#2 BIND #1 "CALL"
```
