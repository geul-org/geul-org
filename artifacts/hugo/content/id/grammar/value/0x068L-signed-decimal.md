---
title: "SIGNED-DECIMAL (0x068L)"
weight: 104
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "decimal"]
summary: "SIGNED-DECIMAL adalah Value bilangan desimal eksak (exact decimal) dengan coefficient bertanda."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `SIGNED-DECIMAL` (dokumen spesifikasi BIND `SIGNED-DECIMAL`) |
| TAG ID | `0x068L` |
| Codec ID | `0x00000680` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000680/` (sasaran DECLARE `0680`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 8 |
| Kind | Value · keluarga: DECIMAL |
| TAG WORD | `0000 0110 1000 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | `C×10^E` dari signed exponent `E` dan coefficient `C` komplemen dua dengan WORD minimum |
| Sisi Hugo | `value/decimal/signed-decimal.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `exponent` | #2 | nilai mentah 2 WORD |  |  |
| 2 | `coefficient` | #3 | sisa nilai mentah (`0xFFFF`) |  |  |

SIGNED-DECIMAL adalah Value bilangan desimal eksak (exact decimal) dengan coefficient bertanda. Kode langsung Value `0x068L`, keluarga DECIMAL. 2 WORD pertama Payload adalah exponent desimal signed 32bit `E`, sisanya adalah coefficient `C` komplemen dua dengan WORD minimum, dan nilainya `C×10^E`.

## Layout {#레이아웃}

```
TAG WORD          0000 0110 1000 LLLL      Codec 0x068L
[Length extension TAG] jika total 15 WORD atau lebih
Payload WORD 1st–2nd (32 bit)       Signed Base-10 Exponent E
Payload WORD 3rd–Nth (1 WORD atau lebih)  Signed Two's-complement Coefficient C
```

## Interpretasi {#해석}

- `E` adalah bilangan bulat komplemen dua big-endian signed 32bit yang dicatat dari WORD atas.
- `C` adalah bilangan bulat komplemen dua berpresisi sembarang dari seluruh WORD sisa yang disambung mulai dari WORD atas.
- `C` mengikuti aturan WORD minimum yang sama dengan [SIGNED-INTEGER](0x061L-signed-integer.md). WORD `0000` atau `FFFF` di depan yang dapat dihapus dilarang.

## Panjang dan validitas {#길이와-유효성}

- Total adalah jumlah WORD dari TAG 1 WORD, Length extension TAG (jika ada), dan Payload. 14 WORD atau kurang memakai panjang langsung, 15 WORD atau lebih memakai panjang perluasan `1110`·`1111`, dan extension TAG juga dihitung dalam total ([Record dan TAG WORD](../record.md)).
- Payload terdiri dari exponent 2 WORD dan coefficient 1 WORD atau lebih, sehingga minimal 3 WORD.
- Kekanonikan representasi byte hanya memeriksa representasi WORD minimum dari coefficient.

## Contoh {#예시}

| Representasi nilai | Payload (`E` + `C`) | Penilaian |
|---|---|---|
| `1×10^0` | `0000 0000 0001` | representasi byte kanonik |
| `10×10^-1` | `FFFF FFFF 000A` | representasi byte kanonik, hubungan kanonik dengan representasi di atas adalah masalah terbuka |
| `1×10^0` | `0000 0000 0000 0001` | tidak kanonik: `0000` di depan coefficient tidak perlu |
| Payload 7 WORD | panjang langsung `LLLL=0111`, total 8 WORD | struktur panjang kanonik |

## Status format {#형식-지위}

- Tata letak ini, yang menggabungkan exponent `E` signed 32 bit dengan coefficient `C` WORD minimum, adalah format khas GEUL, bukan decimal interchange IEEE 754 maupun `DECIMAL` Apache Parquet.
- `DECIMAL` Parquet memakai `unscaledValue × 10^(-scale)` dan metadata precision/scale yang wajib, menyimpan unscaled value pada tipe fisik byte-array sebagai komplemen dua big-endian, dan scale-nya 0 atau lebih. Format ini memasukkan `E` bertanda ke dalam badan dan tidak punya metadata precision, sehingga bukan format yang sama.
- Untuk bertukar dengan decimal IEEE 754 atau `DECIMAL` Parquet, diperlukan konversi eksplisit yang menetapkan kebijakan rentang, precision/scale, quantum, dan nilai khusus.
- Dasar perbandingan: [IEEE 754-2019](https://standards.ieee.org/ieee/754/6210/), [Apache Parquet Logical Types — DECIMAL](https://parquet.apache.org/docs/file-format/types/logicaltypes/)

## Masalah terbuka {#열린-문제}

- Ada banyak pasangan exponent/coefficient yang menyatakan bilangan yang sama, seperti `10×10^-1` dan `1×10^0`.
- Belum ditetapkan apakah format ini mempertahankan quantum, bagaimana kesetaraan nilai ditentukan, dan bagaimana canonical exponent dinormalkan.
- Karena itu implementasi tidak boleh memaksakan secara sepihak normalisasi exponent/coefficient di luar aturan WORD minimum coefficient.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000680/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000068000000000
BODY
#1 DECLARE 0x0680
#2 FIELD #1 0x0002
#3 FIELD #1 rest
#4 BIND #1 "SIGNED-DECIMAL"
#5 BIND #2 "exponent"
#6 BIND #3 "coefficient"
```
