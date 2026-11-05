---
title: "SUPERSEDES (0x109L)"
weight: 265
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDES adalah Codec LINK yang menulis relasi graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDES adalah Codec LINK yang menulis relasi graf TOULMIN. Arti: relasi penyisihan. Jika penyerang Active, sasaran dikeluarkan dari agregasi secara deterministik. Rantai (`A > B > C`) ditulis satu per pasangan.

| Butir | Nilai |
|---|---|
| Nama | `SUPERSEDES` (BIND dokumen spesifikasi `SUPERSEDES`) |
| TAG ID | `0x109L` |
| Codec ID | `0x00001090` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001090/` (target DECLARE `1090`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 9 |
| Kind | Edge · keluarga: TOULMIN, kelompok: relasi, layout: LINK |
| TAG WORD | `0001 0000 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Relasi penyisihan. Jika penyerang Active, sasaran dikeluarkan dari agregasi secara deterministik. Rantai (`A > B > C`) ditulis satu per pasangan |
| Sisi Hugo | `edge/toulmin/link.md` |

## Layout {#레이아웃}

Layout-nya adalah [LINK](_index.md#link) (ID, src, dst, flags, field bersyarat, SPAN).

| Butir | Nilai |
|---|---|
| TANGEUL | `X supersedes Y` |
| src → dst | aturan → aturan. Jika Active, sasaran dikeluarkan dari agregasi |

- Rantai SUPERSEDES `A > B > C` ditulis dengan satu SUPERSEDES per pasangan. Singkatan [SUPERSEDE-CHAIN](0x10AL-supersede-chain.md) belum memiliki layout.
- F_FORCE tidak dipakai (ditolak jika aktif).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1090`). Layout LINK: field bersyarat dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [LINK](_index.md#link), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001090/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000109000000000
BODY
#1 DECLARE 0x1090
#2 BIND #1 "SUPERSEDES"
```
