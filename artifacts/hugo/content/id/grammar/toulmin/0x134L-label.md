---
title: "LABEL (0x134L)"
weight: 308
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "LABEL adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: node → TEXT, penulisan nama.

| Butir | Nilai |
|---|---|
| Nama | `LABEL` (BIND dokumen spesifikasi `LABEL`) |
| TAG ID | `0x134L` |
| Codec ID | `0x00001340` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001340/` (target DECLARE `1340`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 20 |
| Kind | Edge · keluarga: format TOULMIN, layout: LINK |
| TAG WORD | `0001 0011 0100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Node → TEXT, penulisan nama |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | nama dalam backtick |
| src → dst | node → TEXT. Penulisan nama |

- dst adalah REF record TEXT. Apakah nama dalam backtick ditempatkan sebagai pernyataan [LABEL](../edge/0x0A4L-label.md) atau [BIND](../edge/0x0A3L-bind.md) adalah masalah terbuka ([TOULMIN](_index.md#열린-문제)).
- F_FORCE tidak dipakai (ditolak jika aktif).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1340`). Layout LINK: field bersyarat dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001340/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000134000000000
BODY
#1 DECLARE 0x1340
#2 BIND #1 "LABEL"
```
