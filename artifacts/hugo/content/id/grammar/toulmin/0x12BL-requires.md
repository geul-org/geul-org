---
title: "REQUIRES (0x12BL)"
weight: 299
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "REQUIRES adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

REQUIRES adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: kasus → field.

| Butir | Nilai |
|---|---|
| Nama | `REQUIRES` (BIND dokumen spesifikasi `REQUIRES`) |
| TAG ID | `0x12BL` |
| Codec ID | `0x000012B0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000012B0/` (target DECLARE `12B0`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 11 |
| Kind | Edge · keluarga: format TOULMIN, layout: LINK |
| TAG WORD | `0001 0010 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Kasus → field |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | `f is required` |
| src → dst | kasus → field |

- dst adalah REF sebuah node.
- F_FORCE tidak dipakai (ditolak jika aktif).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `12B0`). Field bersyarat layout LINK dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000012B0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012B000000000
BODY
#1 DECLARE 0x12B0
#2 BIND #1 "REQUIRES"
```
