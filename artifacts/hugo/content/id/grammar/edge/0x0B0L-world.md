---
title: "WORLD (0x0B0L)"
weight: 176
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "triple", "qualifier", "label"]
summary: "WORLD adalah Edge pernyataan untuk menulis pandangan dunia."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

WORLD adalah Edge pernyataan untuk menulis pandangan dunia. Arti: struktur untuk mengekspresikan pandangan dunia.

| Butir | Nilai |
|---|---|
| Nama | `WORLD` (BIND dokumen spesifikasi `WORLD`) |
| TAG ID | `0x0B0L` |
| Codec ID | `0x00000B00` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000B00/` (target DECLARE `0B00`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 16 |
| Kind | Edge · keluarga: pernyataan, kelompok: struktur |
| TAG WORD | `0000 1011 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Struktur untuk mengekspresikan pandangan dunia |
| Sisi Hugo | `edge/_index.md` |

## Layout {#레이아웃}

```
TAG WORD          0000 1011 0000 LLLL      Codec 0x0B0L
[Length extension TAG]
TAG per Codec     1 WORD. Subbentuk
Edge Id           record LOCAL Reference
Komponen          ditentukan subbentuk
```

- Ini adalah Codec yang punya subbentuk. 1 WORD TAG per Codec menentukan subbentuk ([record dan TAG WORD](../record.md#레코드-레이아웃)).
- Subbentuk dan komponen belum ditentukan.

## Dokumen codec {#코덱-문서}

Layout belum ditentukan. Dokumen codec hanya memuat DECLARE (target `0B00`). FIELD ditambahkan setelah layout ditentukan.

## Halaman terkait {#관련-페이지}

- [TIMELINE](0x0B1L-timeline.md), [SCENE](0x0B2L-scene.md), [Edge](_index.md)
- [DECLARE](0x0BBL-declare.md#열린-문제) (cara mendeklarasikan Codec yang punya subbentuk)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000B00/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000B0000000000
BODY
#1 DECLARE 0x0B00
#2 BIND #1 "WORLD"
```
