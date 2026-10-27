---
title: "BINARY-FLOAT"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT adalah Value yang memuat apa adanya deretan bit interchange IEEE 754 binary16/32/64/128."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BINARY-FLOAT adalah Value yang menyatakan scalar interchange biner IEEE 754. Kode langsung Value `0x03`, keluarga NUMERIC. Jika Payload 1/2/4/8 WORD, masing-masing adalah binary16/32/64/128. Deretan bit interchange dipertahankan apa adanya dan ukuran Payload lain tidak diizinkan.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x03
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st  (WORD atas)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD bawah)  IEEE Binary Interchange Nth
```

## Interpretasi

- WORD Payload disambung dalam urutan big-endian dan dibaca sebagai deretan bit interchange biner IEEE 754 dengan lebar tersebut.
- Pola bit interchange termasuk payload NaN dan signed zero dipertahankan.
- Decoder tidak boleh mengganti NaN dengan satu NaN kanonik sembarang atau menghapus tanda signed zero.
- Cara pembulatan dan perilaku aritmetika tidak ditetapkan oleh format serialisasi ini.

## Panjang

Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), dan Payload ([Record dan TAG WORD](/id/grammar/record/)).

| Format | Payload | Kode Length | Length extension TAG | Length total |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | Tidak ada | 2 WORD |
| binary32 | 2 WORD | `0010` | Tidak ada | 3 WORD |
| binary64 | 4 WORD | `0100` | Tidak ada | 5 WORD |
| binary128 | 8 WORD | `1000` | Tidak ada | 9 WORD |

binary128 juga berada pada rentang langsung 1~14 WORD sehingga Length extension TAG tidak dipakai.

## Validitas

- Payload tepat salah satu dari 1, 2, 4, 8 WORD.
- Setiap ukuran Payload harus tepat sesuai dengan penyajian Length pada tabel di atas.
- Pengodean ulang yang mengubah lebar dan WORD padding di depan·belakang Payload tidak diizinkan.

## Contoh

| Format | TAG | Length extension TAG | Contoh Payload | Penilaian |
|---|---|---|---|---|
| binary16 | `0883` | Tidak ada | `0000` | Kanonik |
| binary32 | `0903` | Tidak ada | `0000 0000` | Kanonik |
| binary64 | `0A03` | Tidak ada | `0000 0000 0000 0000` | Kanonik |
| binary128 | `0C03` | Tidak ada | Deretan bit 8 WORD | Kanonik |
| Sembarang | Tidak sesuai dengan ukuran yang dinyatakan Length | Sembarang | Sembarang | invalid |

## Dasar standar

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): menerapkan encoding interchange binary16, binary32, binary64, dan binary128. GEUL hanya menambahkan TAG dan framing big-endian WORD 16 bit pada deretan bit itu.
