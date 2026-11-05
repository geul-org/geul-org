---
title: "EVIDENCE (0x119L)"
weight: 281
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "EVIDENCE adalah Codec Edge TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EVIDENCE adalah Codec Edge TOULMIN. Arti: bukti penilaian. Lokasi, nilai yang diharapkan, nilai sebenarnya (Fact).

| Butir | Nilai |
|---|---|
| Nama | `EVIDENCE` (BIND dokumen spesifikasi `EVIDENCE`) |
| TAG ID | `0x119L` |
| Codec ID | `0x00001190` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001190/` (target DECLARE `1190`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 25 |
| Kind | Edge · keluarga: TOULMIN, kelompok: hasil |
| TAG WORD | `0001 0001 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Bukti penilaian. Lokasi, nilai yang diharapkan, nilai sebenarnya (Fact). Layout belum ditetapkan |
| Sisi Hugo | `edge/toulmin/_index.md` |

## Layout {#레이아웃}

Hanya kode yang dialokasikan, dan layout belum ada ([TOULMIN](_index.md#열린-문제)).

- Hasil penilaian ditempatkan di dokumen yang berbeda dari sasaran penilaian ([TOULMIN](_index.md#판정-결과)).

## Dokumen Codec {#코덱-문서}

Layout belum ditetapkan. Dokumen Codec hanya memuat DECLARE (target `1190`). FIELD akan ditambahkan setelah layout ditetapkan.

## Halaman terkait {#관련-페이지}

- [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001190/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000119000000000
BODY
#1 DECLARE 0x1190
#2 BIND #1 "EVIDENCE"
```
