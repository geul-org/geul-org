---
title: "VERB-SHORT (0x0A8L)"
weight: 168
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB-SHORT adalah bentuk singkat dari Edge pernyataan verba VERB."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB-SHORT adalah bentuk singkat dari Edge pernyataan verba [VERB](0x0A9L-verb.md). `-SHORT` dan bentuk biasa dipasangkan sebagai genap·ganjil ([Edge](_index.md#서술-edge)).

| Butir | Nilai |
|---|---|
| Nama | `VERB-SHORT` (BIND dokumen spesifikasi `VERB-SHORT`) |
| TAG ID | `0x0A8L` |
| Codec ID | `0x00000A80` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A80/` (target DECLARE `0A80`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 8 |
| Kind | Edge · keluarga: pernyataan, kelompok: proposisi |
| TAG WORD | `0000 1010 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Bentuk singkat pernyataan verba |
| Sisi Hugo | `edge/_index.md` |

## Layout {#레이아웃}

Layout belum ditentukan. Mengikuti layout umum Edge (TAG, [Length extension TAG], Edge Id, komponen) ([Edge](_index.md#레이아웃)).

## Dokumen codec {#코덱-문서}

Layout belum ditentukan. Dokumen codec hanya memuat DECLARE (target `0A80`). FIELD ditambahkan setelah layout ditentukan.

## Halaman terkait {#관련-페이지}

- [VERB](0x0A9L-verb.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A80/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A8000000000
BODY
#1 DECLARE 0x0A80
#2 BIND #1 "VERB-SHORT"
```
