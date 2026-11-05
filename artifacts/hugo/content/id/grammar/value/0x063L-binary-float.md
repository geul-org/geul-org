---
title: "BINARY-FLOAT (0x063L)"
weight: 99
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "BINARY-FLOAT adalah Value yang menyatakan scalar binary interchange IEEE 754."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `BINARY-FLOAT` (dokumen spesifikasi BIND `BINARY-FLOAT`) |
| TAG ID | `0x063L` |
| Codec ID | `0x00000630` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000630/` (sasaran DECLARE `0630`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 3 |
| Kind | Value · keluarga: NUMERIC |
| TAG WORD | `0000 0110 0011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | scalar IEEE 754 binary16/32/64/128 dengan Payload 1/2/4/8 WORD |
| Sisi Hugo | `value/numeric/binary-float.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `ieee-binary` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

BINARY-FLOAT adalah Value yang menyatakan scalar binary interchange IEEE 754. Kode langsung Value `0x063L`, keluarga NUMERIC. Jika Payload 1/2/4/8 WORD, masing-masing adalah binary16/32/64/128. Deret bit interchange dipertahankan apa adanya, dan ukuran Payload lain tidak diizinkan.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0011 LLLL      Codec 0x063L
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st  (WORD atas)   IEEE Binary Interchange 1st
...
Payload WORD Nth  (WORD bawah)  IEEE Binary Interchange Nth
```

## Interpretasi {#해석}

- WORD Payload disambung dengan urutan big-endian dan dibaca sebagai deret bit binary interchange IEEE 754 dengan lebar yang bersangkutan.
- Pola bit interchange dipertahankan, termasuk payload NaN dan signed zero.
- Decoder tidak boleh mengganti NaN dengan satu NaN kanonik sembarang atau menghapus tanda signed zero.
- Mode pembulatan dan perilaku aritmetika tidak ditentukan oleh format serialisasi ini.

## Panjang {#길이}

Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload ([Record dan TAG WORD](../record.md)).

| Format | Payload | Kode Length | Length extension TAG | Length total |
|---|---:|---|---|---:|
| binary16 | 1 WORD | `0001` | tidak ada | 2 WORD |
| binary32 | 2 WORD | `0010` | tidak ada | 3 WORD |
| binary64 | 4 WORD | `0100` | tidak ada | 5 WORD |
| binary128 | 8 WORD | `1000` | tidak ada | 9 WORD |

binary128 juga berada dalam rentang langsung 1~14 WORD, sehingga tidak memakai Length extension TAG.

## Validitas {#유효성}

- Payload tepat salah satu dari 1, 2, 4, 8 WORD.
- Setiap ukuran Payload harus tepat sesuai dengan representasi Length pada tabel di atas.
- Pengodean ulang yang mengubah lebar atau WORD padding di depan/belakang Payload tidak diizinkan.

## Contoh {#예시}

| Format | TAG | Length extension TAG | Contoh Payload | Penilaian |
|---|---|---|---|---|
| binary16 | `0631` | tidak ada | `0000` | kanonik |
| binary32 | `0632` | tidak ada | `0000 0000` | kanonik |
| binary64 | `0634` | tidak ada | `0000 0000 0000 0000` | kanonik |
| binary128 | `0638` | tidak ada | deret bit 8 WORD | kanonik |
| sembarang | tidak cocok dengan ukuran yang ditunjukkan Length | sembarang | sembarang | invalid |

## Dasar standar {#표준-근거}

- [IEEE 754-2019 — IEEE Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/): menerapkan encoding interchange binary16, binary32, binary64, binary128. GEUL hanya menambahkan TAG dan framing big-endian WORD 16 bit pada deret bit tersebut.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000630/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000063000000000
BODY
#1 DECLARE 0x0630
#2 FIELD #1 rest
#3 BIND #1 "BINARY-FLOAT"
#4 BIND #2 "ieee-binary"
```
