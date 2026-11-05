---
title: "NAMESPACE (0x126L)"
weight: 294
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge", "toulmin"]
summary: "NAMESPACE adalah Codec NODE yang menulis node graf TOULMIN."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

NAMESPACE adalah Codec NODE yang menulis node graf TOULMIN. Arti: `this document is`. Namespace dokumen.

| Butir | Nilai |
|---|---|
| Nama | `NAMESPACE` (BIND dokumen spesifikasi `NAMESPACE`) |
| TAG ID | `0x126L` |
| Codec ID | `0x00001260` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00001260/` (target DECLARE `1260`) |
| Bagian | 9 `1001` (Edge format TOULMIN), offset dalam bagian C = 6 |
| Kind | Edge · keluarga: format TOULMIN, layout: NODE |
| TAG WORD | `0001 0010 0110 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | `this document is`. Namespace dokumen |
| Sisi Hugo | `edge/toulmin/node.md` |

## Layout {#레이아웃}

Layout-nya adalah [NODE](_index.md#node). Header 1 WORD menentukan role, level, bentuk Claim, dan field bersyarat.

| Butir | Nilai |
|---|---|
| TANGEUL | this document is |
| Node | namespace dokumen |

- role harus 0.
- Field umum (ID, REF, SPAN) dan aturan numerik mengikuti [TOULMIN](_index.md#공통-필드).

## Dokumen Codec {#코덱-문서}

Dokumen Codec memuat DECLARE (target `1260`). Field bersyarat layout NODE dan lebar SPAN yang ditentukan SOURCE tidak dapat dideklarasikan dengan FIELD, sehingga deklarasi field menjadi masalah terbuka ([TOULMIN](_index.md#열린-문제)).

## Halaman terkait {#관련-페이지}

- [NODE](_index.md#node), [TOULMIN](_index.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00001260/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf kapital).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000126000000000
BODY
#1 DECLARE 0x1260
#2 BIND #1 "NAMESPACE"
```
