---
title: "SPEC-DECLARE (0x102L)"
weight: 258
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SPEC-DECLARE adalah Codec NODE yang menulis node graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SPEC-DECLARE adalah Codec NODE yang menulis node graf TOULMIN. Arti: deklarasi kriteria penilaian (Backing). Bit role adalah jenis definisi.

| Butir | Nilai |
|---|---|
| Nama | `SPEC-DECLARE` (BIND dokumen spesifikasi `SPEC-DECLARE`) |
| TAG ID | `0x102L` |
| Codec ID | `0x00001020` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001020/` (target DECLARE `1020`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 2 |
| Kind | Edge · keluarga: TOULMIN, kelompok: deklarasi, layout: NODE |
| TAG WORD | `0001 0000 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deklarasi kriteria penilaian (Backing). Bit role adalah jenis definisi |
| Sisi Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

Layout-nya adalah [NODE](_index.md#node). Header 1 WORD menentukan role, level, bentuk Claim, dan field bersyarat.

| Butir | Nilai |
|---|---|
| TANGEUL | butir Definitions (`means`, `has`) |
| Node | kriteria penilaian (Backing). role adalah jenis definisi |

- role adalah jenis definisi.
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1020`). Field bersyarat layout NODE dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001020/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000102000000000
BODY
#1 DECLARE 0x1020
#2 BIND #1 "SPEC-DECLARE"
```
