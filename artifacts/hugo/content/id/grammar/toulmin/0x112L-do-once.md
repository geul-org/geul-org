---
title: "DO-ONCE (0x112L)"
weight: 274
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "DO-ONCE adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DO-ONCE adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: aksi yang dilakukan hanya sekali meskipun dicoba ulang.

| Butir | Nilai |
|---|---|
| Nama | `DO-ONCE` (BIND dokumen spesifikasi `DO-ONCE`) |
| TAG ID | `0x112L` |
| Codec ID | `0x00001120` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001120/` (target DECLARE `1120`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 18 |
| Kind | Edge · keluarga: TOULMIN, kelompok: eksekusi, layout: LINK |
| TAG WORD | `0001 0001 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Aksi yang dilakukan hanya sekali meskipun dicoba ulang |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | `do fn once when n` |
| src → dst | aturan → FuncRef |

- dst adalah FuncRef. `do … once` dinyatakan oleh Codec ini. F_ONCE tidak dipakai pada flags (ditolak jika aktif).
- F_FORCE tidak dipakai (ditolak jika aktif).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1120`). Field bersyarat layout LINK dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001120/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000112000000000
BODY
#1 DECLARE 0x1120
#2 BIND #1 "DO-ONCE"
```
