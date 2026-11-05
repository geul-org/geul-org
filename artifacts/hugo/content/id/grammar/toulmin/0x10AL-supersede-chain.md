---
title: "SUPERSEDE-CHAIN (0x10AL)"
weight: 266
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SUPERSEDE-CHAIN adalah Codec Edge TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SUPERSEDE-CHAIN adalah Codec Edge TOULMIN. Arti: rantai prioritas `A > B > C`. Singkatan dari SUPERSEDES berpasangan.

| Butir | Nilai |
|---|---|
| Nama | `SUPERSEDE-CHAIN` (BIND dokumen spesifikasi `SUPERSEDE-CHAIN`) |
| TAG ID | `0x10AL` |
| Codec ID | `0x000010A0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000010A0/` (target DECLARE `10A0`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 10 |
| Kind | Edge · keluarga: TOULMIN, kelompok: relasi |
| TAG WORD | `0001 0000 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Rantai prioritas `A > B > C`. Singkatan dari SUPERSEDES berpasangan. Layout belum ditetapkan |
| Sisi Hugo | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Hanya kode yang dialokasikan, dan layout belum ada ([TOULMIN](_index.md#열린-문제)).

- Untuk saat ini [SUPERSEDES](0x109L-supersedes.md) ditulis satu per pasangan. Apakah itu cukup untuk rantai adalah masalah terbuka.

## Dokumen Codec {#코덱-문서}

Layout belum ditetapkan. Dokumen Codec hanya memuat DECLARE (target `10A0`). FIELD akan ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000010A0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000010A000000000
BODY
#1 DECLARE 0x10A0
#2 BIND #1 "SUPERSEDE-CHAIN"
```
