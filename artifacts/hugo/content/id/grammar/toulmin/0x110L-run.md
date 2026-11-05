---
title: "RUN (0x110L)"
weight: 272
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RUN adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RUN adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: komposisi eksekusi. Jika node Active, kasus bawahan dieksekusi (DAG).

| Butir | Nilai |
|---|---|
| Nama | `RUN` (BIND dokumen spesifikasi `RUN`) |
| TAG ID | `0x110L` |
| Codec ID | `0x00001100` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001100/` (target DECLARE `1100`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 16 |
| Kind | Edge · keluarga: TOULMIN, kelompok: eksekusi, layout: LINK |
| TAG WORD | `0001 0001 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Komposisi eksekusi. Jika node Active, kasus bawahan dieksekusi (DAG) |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | `run c when n` |
| src → dst | aturan → kasus |

- dst adalah REF sebuah node.
- F_FORCE tidak dipakai (ditolak jika aktif).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1100`). Field bersyarat layout LINK dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001100/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000110000000000
BODY
#1 DECLARE 0x1100
#2 BIND #1 "RUN"
```
