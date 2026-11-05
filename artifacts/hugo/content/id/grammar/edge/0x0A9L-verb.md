---
title: "VERB (0x0A9L)"
weight: 169
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "VERB adalah Edge pernyataan verba."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

VERB adalah Edge pernyataan verba. Bentuk singkatnya adalah [VERB-SHORT](0x0A8L-verb-short.md) (`0x0A8L`) ([Edge](_index.md#서술-edge)).

| Butir | Nilai |
|---|---|
| Nama | `VERB` (BIND dokumen spesifikasi `VERB`) |
| TAG ID | `0x0A9L` |
| Codec ID | `0x00000A90` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A90/` (target DECLARE `0A90`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 9 |
| Kind | Edge · keluarga: pernyataan, kelompok: proposisi |
| TAG WORD | `0000 1010 1001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Pernyataan verba |
| Sisi Hugo | `edge/_index.md` |

## Layout {#레이아웃}

Layout belum ditentukan. Mengikuti layout umum Edge (TAG, [Length extension TAG], Edge Id, komponen) ([Edge](_index.md#레이아웃)).

## Dokumen codec {#코덱-문서}

Layout belum ditentukan. Dokumen codec hanya memuat DECLARE (target `0A90`). FIELD ditambahkan setelah layout ditentukan.

## Halaman terkait {#관련-페이지}

- [VERB-SHORT](0x0A8L-verb-short.md), [Edge](_index.md), [TRIPLE](0x0AAL-triple.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A90/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A9000000000
BODY
#1 DECLARE 0x0A90
#2 BIND #1 "VERB"
```
