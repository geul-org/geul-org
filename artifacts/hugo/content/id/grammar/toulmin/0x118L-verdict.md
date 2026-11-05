---
title: "VERDICT (0x118L)"
weight: 280
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "VERDICT adalah Codec Edge TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERDICT adalah Codec Edge TOULMIN. Arti: hasil penilaian node dan record. Hasil (Pass, Review, Fail), nilai penilaian, Activated, Excluded, Level.

| Butir | Nilai |
|---|---|
| Nama | `VERDICT` (BIND dokumen spesifikasi `VERDICT`) |
| TAG ID | `0x118L` |
| Codec ID | `0x00001180` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001180/` (target DECLARE `1180`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 24 |
| Kind | Edge · keluarga: TOULMIN, kelompok: hasil |
| TAG WORD | `0001 0001 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Hasil penilaian node dan record. Hasil (Pass, Review, Fail), nilai penilaian, Activated, Excluded, Level. Layout belum ditetapkan |
| Sisi Hugo | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Hanya kode yang dialokasikan, dan layout belum ada ([TOULMIN](_index.md#열린-문제)).

- Penilaian seluruh dokumen ditangani oleh Meta [VERDICT](../meta/0x1E9L-verdict.md) (`0x1E9L`). Keduanya adalah Codec terpisah dengan Kind yang berbeda.
- Hasil penilaian ditempatkan di dokumen yang berbeda dari sasaran penilaian ([TOULMIN](_index.md#판정-결과)).

## Dokumen Codec {#코덱-문서}

Layout belum ditetapkan. Dokumen Codec hanya memuat DECLARE (target `1180`). FIELD akan ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001180/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000118000000000
BODY
#1 DECLARE 0x1180
#2 BIND #1 "VERDICT"
```
