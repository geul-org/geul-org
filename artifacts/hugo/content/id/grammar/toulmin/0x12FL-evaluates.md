---
title: "EVALUATES (0x12FL)"
weight: 303
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVALUATES adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVALUATES adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: titik masuk → kasus, penilaian.

| Butir | Nilai |
|---|---|
| Nama | `EVALUATES` (BIND dokumen spesifikasi `EVALUATES`) |
| TAG ID | `0x12FL` |
| Codec ID | `0x000012F0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000012F0/` (target DECLARE `12F0`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 15 |
| Kind | Edge · keluarga: format TOULMIN, layout: LINK |
| TAG WORD | `0001 0010 1111 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Titik masuk → kasus, penilaian |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | titik masuk `check c` |
| src → dst | titik masuk → kasus (penilaian) |

- dst adalah REF sebuah node.
- F_FORCE tidak dipakai (ditolak jika aktif).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `12F0`). Field bersyarat layout LINK dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000012F0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012F000000000
BODY
#1 DECLARE 0x12F0
#2 BIND #1 "EVALUATES"
```
