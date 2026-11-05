---
title: "EXCEPT-DECLARE (0x105L)"
weight: 261
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EXCEPT-DECLARE adalah Codec NODE yang menulis node graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXCEPT-DECLARE adalah Codec NODE yang menulis node graf TOULMIN. Arti: deklarasi pengecualian. Menyerang tanpa kesimpulan sendiri. Level bawaan adalah Review.

| Butir | Nilai |
|---|---|
| Nama | `EXCEPT-DECLARE` (BIND dokumen spesifikasi `EXCEPT-DECLARE`) |
| TAG ID | `0x105L` |
| Codec ID | `0x00001050` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001050/` (target DECLARE `1050`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 5 |
| Kind | Edge · keluarga: TOULMIN, kelompok: deklarasi, layout: NODE |
| TAG WORD | `0001 0000 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deklarasi pengecualian. Menyerang tanpa kesimpulan sendiri. Level bawaan adalah Review |
| Sisi Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

Layout-nya adalah [NODE](_index.md#node). Header 1 WORD menentukan role, level, bentuk Claim, dan field bersyarat.

| Butir | Nilai |
|---|---|
| TANGEUL | except rule |
| Node | pengecualian (Defeater) |

- role harus 2 (except). Jika level 0 (Unset), dipakai nilai bawaan mesin, Review.
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1050`). Field bersyarat layout NODE dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001050/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000105000000000
BODY
#1 DECLARE 0x1050
#2 BIND #1 "EXCEPT-DECLARE"
```
