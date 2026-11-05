---
title: "RUNS (0x12EL)"
weight: 302
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RUNS adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RUNS adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: titik masuk → kasus, eksekusi.

| Butir | Nilai |
|---|---|
| Nama | `RUNS` (BIND dokumen spesifikasi `RUNS`) |
| TAG ID | `0x12EL` |
| Codec ID | `0x000012E0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000012E0/` (target DECLARE `12E0`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 14 |
| Kind | Edge · keluarga: format TOULMIN, layout: LINK |
| TAG WORD | `0001 0010 1110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Titik masuk → kasus, eksekusi |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | titik masuk `run c` |
| src → dst | titik masuk → kasus (eksekusi) |

- dst adalah REF sebuah node.
- F_FORCE tidak dipakai (ditolak jika aktif).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `12E0`). Field bersyarat layout LINK dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000012E0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012E000000000
BODY
#1 DECLARE 0x12E0
#2 BIND #1 "RUNS"
```
