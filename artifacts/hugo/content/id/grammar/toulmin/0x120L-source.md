---
title: "SOURCE (0x120L)"
weight: 288
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SOURCE adalah record teks sumber dan pembagian dokumen TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SOURCE adalah record teks sumber dan pembagian dokumen TOULMIN. Arti: teks asli penulisan.

| Butir | Nilai |
|---|---|
| Nama | `SOURCE` (BIND dokumen spesifikasi `SOURCE`) |
| TAG ID | `0x120L` |
| Codec ID | `0x00001200` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001200/` (target DECLARE `1200`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 0 |
| Kind | Edge · keluarga: format TOULMIN, layout: ID, lebar SPAN WORD, UTF8 Value |
| TAG WORD | `0001 0010 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Teks asli penulisan |
| Sisi Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Seluruh teks asli penulisan. Semua SPAN adalah rentang byte di dalam teks asli ini.

```
ID
lebar SPAN WORD     2 bit atas = lebar (00=1, 01=2, 10=4, 11=8 WORD), 14 bit sisanya = 0
teks asli           record UTF8-TEXT Value
```

- SOURCE adalah record pertama BODY. Satu per dokumen.
- SPAN terdiri dari dua field: byte awal dan jumlah byte. Setiap field adalah bilangan bulat unsigned dengan lebar (1/2/4/8 WORD) yang ditentukan WORD lebar SPAN.
- Ini Codec yang berbeda dari Edge dasar [SOURCE](../edge/0x0C0L-source.md) (`0x0C0L`).

- ID adalah Edge Id, dan REF adalah Edge Id record dokumen ini (field umum [TOULMIN](_index.md#공통-필드)). Payload mengikuti TAG tanpa kolom Issuer dan nomor Codec.

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1200`). Deklarasi field ditetapkan bersama dokumen spesifikasi Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [SOURCE dan pembagian](_index.md#source와-구획), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001200/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000120000000000
BODY
#1 DECLARE 0x1200
#2 BIND #1 "SOURCE"
```
