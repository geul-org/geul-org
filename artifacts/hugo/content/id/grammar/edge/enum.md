---
title: "ENUM"
weight: 30
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "ENUM adalah Edge pernyataan yang memberi makna pada satu nilai kode field nilai mentah (Codec 0x1D). Nama diikat dengan BIND."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ENUM adalah Edge pernyataan yang memberi makna pada satu nilai kode field nilai mentah. Codec `0x1D`.

Bersama [FIELD](/id/grammar/edge/field/), ia adalah kosakata untuk menulis spesifikasi Codec. Layoutnya ditanamkan di decoder ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)).

## Layout

```
TAG WORD          0001 0LLL L001 1101
[Length extension TAG]
Edge Id           record LOCAL Reference
Field             record LOCAL Reference yang menunjuk Edge FIELD
Nilai kode        nilai mentah. Jumlah WORD sama dengan lebar FIELD itu
```

## Interpretasi dan validitas

- Field harus berupa FIELD nilai mentah (lebar `n ≥ 1`). ENUM tidak ditempelkan pada field record. Makna record dinyatakan oleh Codec record itu.
- Nilai kode tepat selebar FIELD itu. Batasnya diperiksa dengan Length record ENUM.
- Nilai kode yang sama tidak dideklarasikan dua kali pada satu field.
- Nama nilai kode diikat pada Edge Id ENUM dengan [BIND](/id/grammar/edge/bind/). Semua UTF8-TEXT yang ditempelkan pada DECLARE·FIELD·ENUM·CODEC memakai BIND, dan tidak ditempelkan dengan Edge lain seperti LABEL.
- Nilai kode yang tidak dideklarasikan bukan kesalahan. Viewer menampilkan nilai mentah apa adanya. Apakah nilai yang diizinkan ditutup adalah urusan spesifikasi Codec, dan kosakata saat ini tidak memiliki penanda penutup.

## Panjang

```
Total = 1 + N_len + N_id + N_field + n WORD
```

## Contoh (non-normatif)

Mendeklarasikan kode `0x0001` pada field kategori alasan (FIELD #4, nilai mentah 1 WORD) dokumen spesifikasi TOMBSTONE. Edge Id 10. Nama diikat terpisah dengan BIND. Tabel kode kategori alasan belum ditetapkan sehingga nilai kode ini hanya contoh.

- TAG 1 + Edge Id 2 + field 2 + nilai kode 1 = 6 WORD, `LLLL = 0101`.

```
129D 0088 000A 0088 0004 0001
```

Dokumen spesifikasi TRIPLE menaruh tiga ENUM (`0`·`1`·`2`) pada field Rank (FIELD #5) dan mengikatnya dengan BIND masing-masing sebagai `normal`·`preferred`·`deprecated` ([TRIPLE](/id/grammar/edge/triple/)).

## Halaman terkait

- [DECLARE](/id/grammar/edge/declare/), [FIELD](/id/grammar/edge/field/), [CODEC](/id/grammar/edge/codec/), [BIND](/id/grammar/edge/bind/)
- [Dokumen spesifikasi Codec](/id/grammar/codec-spec/)
