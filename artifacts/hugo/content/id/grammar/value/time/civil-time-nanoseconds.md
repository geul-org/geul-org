---
title: "CIVIL-TIME-NANOSECONDS"
weight: 34
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS adalah Value yang memuat waktu sipil tanpa tanggal sebagai jumlah nanosecond setelah tengah malam (Codec 0x21)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

CIVIL-TIME-NANOSECONDS menyatakan waktu sipil tanpa tanggal sebagai jumlah nanosecond setelah tengah malam.

## Layout

- Kode: kode langsung Value `0x21`. Keluarga TIME.
- Memakai tipe fisik signed int64 berlebar tetap yang sama dengan Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x0A21 (0000 1010 0010 0001)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretasi dan validitas

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen 2 64 bit dalam urutan WORD big-endian.
- Tipe fisiknya signed int64, tetapi rentang yang valid adalah `0 <= value < 86,400×10^9` ns. Negatif dan nilai di atas batas atas ditolak.
- `24:00` dan label detik kabisat tidak diizinkan. Tanggal, zona waktu, dan offset UTC juga tidak dimuat.
- Nilai kecil pun selalu memakai 4 WORD.

## Panjang

- Total tepat 5 WORD, yaitu jumlah TAG 1 WORD dan Payload 4 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh

- Tengah malam adalah Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 ns setelah tengah malam adalah Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns sama dengan batas atas sehingga tidak valid.
- `ffff ffff ffff ffff` adalah -1 sebagai signed int64 sehingga tidak valid.

## Dasar standar

- `TIME(isAdjustedToUTC=false, unit=NANOS)` pada [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) menyimpan nanosecond setelah tengah malam waktu lokal pada `int64` dan memakai urutan bertanda.
- [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) otoritatif dari [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) mendefinisikan Time NANOSECOND sebagai bilangan bulat bertanda 64 bit, membatasi rentang valid kurang dari 86,400 detik termasuk tengah malam, dan tidak mengizinkan detik kabisat. GEUL hanya menambahkan framing TAG dan WORD 16 bit big-endian.
