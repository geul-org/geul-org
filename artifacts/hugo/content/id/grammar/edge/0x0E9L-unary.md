---
title: "UNARY (0x0E9L)"
weight: 233
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "UNARY adalah Codec kelompok ekspresi Edge eksekusi."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNARY adalah Codec kelompok ekspresi Edge eksekusi. Arti: ekspresi unari.

| Butir | Nilai |
|---|---|
| Nama | `UNARY` (dokumen spesifikasi BIND `UNARY`) |
| TAG ID | `0x0E9L` |
| Codec ID | `0x00000E90` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000E90/` (target DECLARE `0E90`) |
| Bagian | 7 `0111` (Edge eksekusi), offset dalam bagian C = 9 |
| Kind | Edge · keluarga: eksekusi, kelompok: ekspresi |
| TAG WORD | `0000 1110 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Ekspresi unari. Operator 1 WORD, operan |
| Sisi Hugo | `edge/_index.md` |

## Komponen {#구성요소}

Operator 1 WORD, operan.

- Komponen ditunjuk dengan LOCAL ID (REF) dokumen ini. REF `0` berarti tidak ada. Pada posisi ekspresi ditaruh Edge ekspresi atau simbol ([Edge](_index.md#실행-edge)).
- Kode operator, representasi tipe, dan layout Payload belum ditetapkan ([Edge](_index.md#실행-edge), masalah terbuka).

## Dokumen codec {#코덱-문서}

Layout belum ditetapkan. Dokumen codec hanya berisi DECLARE (target `0E90`). FIELD ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [Edge — Edge eksekusi](_index.md#실행-edge), [CONST](0x0E8L-const.md), [BINARY](0x0EAL-binary.md), [CALL](0x0EBL-call.md), [MEMBER](0x0ECL-member.md), [INDEX](0x0EDL-index.md), [CONSTRUCT](0x0EEL-construct.md), [CONDITIONAL](0x0EFL-conditional.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000E90/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000E9000000000
BODY
#1 DECLARE 0x0E90
#2 BIND #1 "UNARY"
```
