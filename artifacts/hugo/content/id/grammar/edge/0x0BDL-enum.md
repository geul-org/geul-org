---
title: "ENUM (0x0BDL)"
weight: 189
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM adalah Edge pernyataan yang memberi makna pada satu nilai kode bidang nilai mentah."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `ENUM` (BIND dokumen spesifikasi `ENUM`) |
| TAG ID | `0x0BDL` |
| Codec ID | `0x00000BD0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000BD0/` (target DECLARE `0BD0`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 29 |
| Kind | Edge · keluarga: pernyataan, kelompok: lainnya |
| TAG WORD | `0000 1011 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Satu nilai kode bidang nilai mentah. Bidang, nilai kode |
| Sisi Hugo | `edge/enum.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `field` | #2 | record | `0050` LOCAL |  |
| 2 | `code` | #3 | sisa nilai mentah (`0xFFFF`) |  |  |

ENUM adalah Edge pernyataan yang memberi makna pada satu nilai kode bidang nilai mentah. Codec `0x0BDL`.

Bersama [FIELD](0x0BCL-field.md), ini adalah kosakata untuk menulis spesifikasi Codec. Layout tertanam di decoder ([dokumen spesifikasi Codec](../codec-spec.md)).

## Layout {#레이아웃}

```
TAG WORD          0000 1011 1101 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Bidang            record LOCAL Reference yang menunjuk Edge FIELD
Nilai kode        nilai mentah. Jumlah WORD sama dengan lebar FIELD itu
```

## Interpretasi dan validitas {#해석과-유효성}

- Bidang harus FIELD nilai mentah (lebar `n ≥ 1`). ENUM tidak ditempelkan pada bidang record. Makna record dinyatakan oleh Codec record itu.
- Nilai kode tepat sebesar lebar FIELD itu. Batasnya dipastikan dengan Length record ENUM.
- Nilai kode yang sama tidak dideklarasikan dua kali pada satu bidang.
- Nama nilai kode diikat pada Edge Id ENUM dengan [BIND](0x0A3L-bind.md). UTF8-TEXT yang ditempelkan pada DECLARE·FIELD·ENUM·CODEC semuanya dengan BIND, tidak ditempelkan dengan Edge lain seperti LABEL.
- Nilai kode yang tidak dideklarasikan bukan galat. Viewer menampilkannya sebagai nilai mentah apa adanya. Apakah nilai yang diizinkan ditutup adalah urusan spesifikasi Codec, dan kosakata saat ini tidak punya penanda penutup.

## Panjang {#길이}

```
total = 1 + N_len + N_id + N_field + n WORD
```

## Contoh (non-normatif) {#예시-비규범}

Mendeklarasikan kode `0x0001` pada bidang kategori alasan (FIELD #4, nilai mentah 1 WORD) dokumen spesifikasi TOMBSTONE. Edge Id 10. Namanya diikat terpisah dengan BIND. Tabel kode kategori alasan belum ditentukan, sehingga nilai kode ini hanya contoh.

- TAG 1 + Edge Id 2 + bidang 2 + nilai kode 1 = 6 WORD, `LLLL = 0101`.

```
0BD5 0051 000A 0051 0004 0001
```

Dokumen spesifikasi TRIPLE menaruh tiga ENUM (`0`·`1`·`2`) pada bidang Rank (FIELD #5) dan mengikatnya dengan BIND masing-masing sebagai `normal`·`preferred`·`deprecated` ([TRIPLE](0x0AAL-triple.md)).

## Halaman terkait {#관련-페이지}

- [DECLARE](0x0BBL-declare.md), [FIELD](0x0BCL-field.md), [CODEC](0x0BEL-codec.md), [BIND](0x0A3L-bind.md)
- [dokumen spesifikasi Codec](../codec-spec.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000BD0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000BD000000000
BODY
#1 DECLARE 0x0BD0
#2 FIELD #1 record
#3 FIELD #1 rest
#4 BIND #1 "ENUM"
#5 BIND #2 "field"
#6 BIND #3 "code"
#7 CODEC #2 0x0050
```
