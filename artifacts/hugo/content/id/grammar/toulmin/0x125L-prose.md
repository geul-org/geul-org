---
title: "PROSE (0x125L)"
weight: 293
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "PROSE adalah record teks sumber dan pembagian dokumen TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

PROSE adalah record teks sumber dan pembagian dokumen TOULMIN. Arti: paragraf uraian.

| Butir | Nilai |
|---|---|
| Nama | `PROSE` (BIND dokumen spesifikasi `PROSE`) |
| TAG ID | `0x125L` |
| Codec ID | `0x00001250` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001250/` (target DECLARE `1250`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 5 |
| Kind | Edge · keluarga: format TOULMIN, layout: ID, SPAN |
| TAG WORD | `0001 0010 0101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Paragraf uraian |
| Sisi Hugo | `edge/toulmin/source.md` |

## Layout {#레이아웃}

Paragraf uraian yang bukan aturan. Hanya menunjuk rentang (SPAN) pada teks asli.

```
ID
SPAN             lebar yang ditentukan SOURCE × 2 (byte awal, jumlah byte)
```

- ID adalah Edge Id, dan REF adalah Edge Id record dokumen ini (field umum [TOULMIN](_index.md#공통-필드)). Payload mengikuti TAG tanpa kolom Issuer dan nomor Codec.

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1250`). Lebar SPAN ditentukan oleh SOURCE sehingga tidak dapat dideklarasikan dengan FIELD, dan deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [SOURCE dan pembagian](_index.md#source와-구획), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001250/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000125000000000
BODY
#1 DECLARE 0x1250
#2 BIND #1 "PROSE"
```
