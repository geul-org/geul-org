---
title: "BOOL (0x060L)"
weight: 96
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BOOL adalah Value yang menyatakan nilai logika false dan true."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `BOOL` (dokumen spesifikasi BIND `BOOL`) |
| TAG ID | `0x060L` |
| Codec ID | `0x00000600` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000600/` (sasaran DECLARE `0600`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 0 |
| Kind | Value · keluarga: NUMERIC |
| TAG WORD | `0000 0110 0000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | false atau true dalam 1 WORD tetap |
| Sisi Hugo | `value/numeric/bool.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `code` | #2 | nilai mentah 1 WORD |  | `0x0000` false, `0x0001` true |

BOOL adalah Value yang menyatakan nilai logika false dan true. Kode langsung Value `0x060L`, keluarga NUMERIC. Ini tipe yang berbeda dari SIGNED-INTEGER dan UNSIGNED-INTEGER yang memuat angka 0 dan 1.

## Layout {#레이아웃}

```
TAG WORD          0x0601 (0000 0110 0000 0001)  total 2 WORD
Payload           1 WORD  Boolean Code
```

## Interpretasi dan validitas {#해석과-유효성}

- Payload `0000` adalah false, dan `0001` adalah true.
- Tidak ada padding atau descriptor.
- Payload tepat `0000` atau `0001`. Nilai 16 bit lain ditolak sebagai invalid.
- Semua representasi Length lain ditolak sebagai invalid.

## Panjang {#길이}

- Total adalah jumlah TAG 1 WORD dan Payload 1 WORD, yaitu tepat 2 WORD, dengan panjang langsung `LLLL=0001`. Tidak ada Length extension TAG, descriptor, maupun padding.
- Jika Payload bukan tepat 1 WORD, ditolak.

## Contoh {#예시}

| Record lengkap (TAG + Payload) | Payload | Penilaian |
|---|---|---|
| `0601 0000` | `0000` | false, kanonik |
| `0601 0001` | `0001` | true, kanonik |
| `0601 0002` | `0002` | invalid |
| `0601 FFFF` | `FFFF` | invalid |
| TAG dengan Length bukan `0001` + `0000` atau `0001` | `0000` atau `0001` | invalid |

## Status format {#형식-지위}

- Representasi yang menggabungkan code word 16 bit `0000`/`0001` dengan TAG GEUL ini adalah profil scalar khas GEUL.
- Nilai logika itu sendiri bersifat universal, tetapi tidak diklaim ada satu standar industri tunggal yang berpadanan dengan representasi 1 WORD ini.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000600/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000060000000000
BODY
#1 DECLARE 0x0600
#2 FIELD #1 0x0001
#3 ENUM #2 0x0000
#4 ENUM #2 0x0001
#5 BIND #1 "BOOL"
#6 BIND #2 "code"
#7 BIND #3 "false"
#8 BIND #4 "true"
```
