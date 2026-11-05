---
title: "SECTION (0x122L)"
weight: 290
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "SECTION adalah record teks sumber dan pembagian dokumen TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

SECTION adalah record teks sumber dan pembagian dokumen TOULMIN. Arti: awal bagian.

| Butir | Nilai |
|---|---|
| Nama | `SECTION` (BIND dokumen spesifikasi `SECTION`) |
| TAG ID | `0x122L` |
| Codec ID | `0x00001220` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001220/` (target DECLARE `1220`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 2 |
| Kind | Edge · keluarga: format TOULMIN, layout: ID, kode bagian 1 WORD |
| TAG WORD | `0001 0010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Awal bagian |
| Sisi Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Awal sebuah bagian. Kode bagian adalah 1 WORD.

```
ID
kode bagian      1 WORD
```

| Kode | Bagian | TANGEUL |
|---|---|---|
| 1 | Subject | `this document is x` |
| 2 | See | `see a from path` |
| 3 | Definitions | `means`, `has` |
| 4 | Rules | aturan ekspresi kondisi |
| 5 | Cases | `in case of x` |
| 6 | Provides | `provides x` |
| 7 | Internal | `on`, `every` |

- `0` tidak dipakai. Bagian dideklarasikan dalam urutan kode ini.
- Judul bagian adalah [PROSE](0x125L-prose.md) tepat setelah SECTION.

- ID adalah Edge Id, dan REF adalah Edge Id record dokumen ini (field umum [TOULMIN](_index.md#공통-필드)). Payload mengikuti TAG tanpa kolom Issuer dan nomor Codec.

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1220`). Deklarasi field ditetapkan bersama dokumen spesifikasi Codec TOULMIN ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [SOURCE dan pembagian](_index.md#source와-구획), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001220/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000122000000000
BODY
#1 DECLARE 0x1220
#2 BIND #1 "SECTION"
```
