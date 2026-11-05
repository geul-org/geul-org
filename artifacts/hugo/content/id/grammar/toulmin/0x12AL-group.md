---
title: "GROUP (0x12AL)"
weight: 298
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "GROUP adalah Codec NODE yang menulis node graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GROUP adalah Codec NODE yang menulis node graf TOULMIN. Arti: kelompok eksekusi berurutan.

| Butir | Nilai |
|---|---|
| Nama | `GROUP` (BIND dokumen spesifikasi `GROUP`) |
| TAG ID | `0x12AL` |
| Codec ID | `0x000012A0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000012A0/` (target DECLARE `12A0`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 10 |
| Kind | Edge · keluarga: format TOULMIN, layout: NODE |
| TAG WORD | `0001 0010 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Kelompok eksekusi berurutan |
| Sisi Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

Layout-nya adalah [NODE](_index.md#node). Header 1 WORD menentukan role, level, bentuk Claim, dan field bersyarat.

| Butir | Nilai |
|---|---|
| TANGEUL | `1.` daftar berurutan |
| Node | kelompok eksekusi berurutan |

- role harus 0.
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `12A0`). Field bersyarat layout NODE dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000012A0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000012A000000000
BODY
#1 DECLARE 0x12A0
#2 BIND #1 "GROUP"
```
