---
title: "SIGNED-INTEGER (0x061L)"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "numeric"]
summary: "SIGNED-INTEGER adalah Value yang menyatakan bilangan bulat bertanda."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SIGNED-INTEGER` (dokumen spesifikasi BIND `SIGNED-INTEGER`) |
| TAG ID | `0x061L` |
| Codec ID | `0x00000610` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000610/` (sasaran DECLARE `0610`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 1 |
| Kind | Value · keluarga: NUMERIC |
| TAG WORD | `0000 0110 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | bilangan bulat bertanda komplemen dua dengan WORD minimum |
| Sisi Hugo | `value/numeric/signed-integer.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `integer` | #2 | sisa nilai mentah (`0xFFFF`) |  |  |

SIGNED-INTEGER adalah Value yang menyatakan bilangan bulat bertanda. Kode langsung Value `0x061L`, keluarga NUMERIC. Seluruh Payload dibaca sebagai bilangan bulat komplemen dua berpresisi sembarang dengan urutan WORD big-endian. Payload minimal 1 WORD dan hanya representasi kanonik dengan WORD minimum yang diizinkan.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 0001 LLLL      Codec 0x061L
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st  (WORD atas)   Integer 1st
...
Payload WORD Nth  (WORD bawah)  Integer Nth
```

## Interpretasi {#해석}

- Bit paling signifikan dari WORD Payload pertama adalah bit tanda untuk seluruh bilangan bulat.
- Semua WORD Payload dibaca sebagai satu deret bit komplemen dua yang berkesinambungan. WORD pertama adalah posisi tertinggi, WORD terakhir posisi terendah.
- Jika Payload N WORD, lebar interpretasi adalah `16N` bit. Lebar ini bukan lebar penyimpanan yang dideklarasikan, melainkan lebar representasi nilai yang ditentukan oleh representasi kanonik.
- Tidak ada Byte Count atau bit width descriptor.

## Representasi kanonik {#정규-표현}

- 0 adalah Payload 1 WORD `0000`.
- WORD perluasan tanda di depan yang tidak mengubah nilai dilarang.
- Jika Payload 2 WORD atau lebih, yang berikut ini tidak kanonik.
  - WORD pertama `0000` dan bit paling signifikan WORD berikutnya 0
  - WORD pertama `FFFF` dan bit paling signifikan WORD berikutnya 1
- `0000` di depan yang menjaga tanda bilangan positif diizinkan jika bit paling signifikan WORD berikutnya 1.
- `FFFF` di depan yang menjaga tanda bilangan negatif diizinkan jika bit paling signifikan WORD berikutnya 0.
- Decoder harus menolak representasi tidak kanonik.

## Panjang {#길이}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, 15 WORD atau lebih memakai panjang perluasan `1110`·`1111`, dan extension TAG juga dihitung dalam total ([Record dan TAG WORD](../record.md)).
- Lebar yang dideklarasikan seperti INT8·INT16·INT32 tidak dipertahankan; hanya nilai angkanya yang dipertahankan. `-32768` sampai `32767` adalah 1 WORD, dan di luar rentang itu ditambahkan WORD sebanyak yang diperlukan. Tidak ada format SIGNED-INT8 tersendiri.

## Contoh {#예시}

| Nilai | WORD Payload | Penilaian |
|---:|---|---|
| 0 | `0000` | kanonik |
| 1 | `0001` | kanonik |
| 32767 | `7FFF` | kanonik |
| 32768 | `0000 8000` | kanonik: `0000` diperlukan untuk menjaga tanda positif |
| -1 | `FFFF` | kanonik |
| -32768 | `8000` | kanonik |
| -32769 | `FFFF 7FFF` | kanonik: `FFFF` diperlukan untuk menjaga tanda negatif |
| 1 | `0000 0001` | tidak kanonik: `0000` di depan tidak perlu |
| -1 | `FFFF FFFF` | tidak kanonik: `FFFF` di depan tidak perlu |

## Status format {#형식-지위}

- Komplemen dua adalah konvensi yang umum dipakai, tetapi representasi ini, yang menormalkan nilai berpresisi sembarang menjadi deret WORD minimal 16 bit dan menggabungkannya dengan TAG GEUL, adalah profil scalar khas GEUL.
- Saat bertukar dengan tipe eksternal berlebar tetap seperti INT8/16/32/64, diperlukan pemeriksaan rentang dan konversi lebar yang eksplisit.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000610/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000061000000000
BODY
#1 DECLARE 0x0610
#2 FIELD #1 rest
#3 BIND #1 "SIGNED-INTEGER"
#4 BIND #2 "integer"
```
