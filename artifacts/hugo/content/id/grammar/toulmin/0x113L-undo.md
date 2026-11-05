---
title: "UNDO (0x113L)"
weight: 275
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "UNDO adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

UNDO adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: aksi kompensasi (saga) untuk DO. Jika langkah berikutnya gagal, dilakukan dalam urutan terbalik.

| Butir | Nilai |
|---|---|
| Nama | `UNDO` (BIND dokumen spesifikasi `UNDO`) |
| TAG ID | `0x113L` |
| Codec ID | `0x00001130` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001130/` (target DECLARE `1130`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 19 |
| Kind | Edge · keluarga: TOULMIN, kelompok: eksekusi, layout: LINK |
| TAG WORD | `0001 0001 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Aksi kompensasi (saga) untuk DO. Jika langkah berikutnya gagal, dilakukan dalam urutan terbalik |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | `undo fn when n` |
| src → dst | aturan → FuncRef |

- dst adalah FuncRef. `once` pada UNDO ditulis sebagai F_ONCE pada flags.
- F_FORCE tidak dipakai (ditolak jika aktif).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1130`). Field bersyarat layout LINK dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001130/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000113000000000
BODY
#1 DECLARE 0x1130
#2 BIND #1 "UNDO"
```
