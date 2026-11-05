---
title: "RULE-DECLARE (0x103L)"
weight: 259
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "RULE-DECLARE adalah Codec NODE yang menulis node graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RULE-DECLARE adalah Codec NODE yang menulis node graf TOULMIN. Arti: deklarasi klaim (Warrant). Dapat diserang.

| Butir | Nilai |
|---|---|
| Nama | `RULE-DECLARE` (BIND dokumen spesifikasi `RULE-DECLARE`) |
| TAG ID | `0x103L` |
| Codec ID | `0x00001030` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001030/` (target DECLARE `1030`) |
| Bagian | 8 `1000` (Edge TOULMIN), offset dalam bagian C = 3 |
| Kind | Edge · keluarga: TOULMIN, kelompok: deklarasi, layout: NODE |
| TAG WORD | `0001 0000 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Deklarasi klaim (Warrant). Dapat diserang |
| Sisi Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

Layout-nya adalah [NODE](_index.md#node). Header 1 WORD menentukan role, level, bentuk Claim, dan field bersyarat.

| Butir | Nilai |
|---|---|
| TANGEUL | general rule, nama aturan pada Rules |
| Node | klaim (Warrant) |

- role harus 0 (general).
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1030`). Field bersyarat layout NODE dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001030/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000103000000000
BODY
#1 DECLARE 0x1030
#2 BIND #1 "RULE-DECLARE"
```
