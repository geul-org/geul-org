---
title: "CIVIL-TIME-NANOSECONDS (0x06BL)"
weight: 107
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "CIVIL-TIME-NANOSECONDS menyatakan waktu sipil tanpa tanggal sebagai jumlah nanosecond setelah tengah malam."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `CIVIL-TIME-NANOSECONDS` (dokumen spesifikasi BIND `CIVIL-TIME-NANOSECONDS`) |
| TAG ID | `0x06BL` |
| Codec ID | `0x000006B0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000006B0/` (sasaran DECLARE `06B0`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 11 |
| Kind | Value · keluarga: TIME |
| TAG WORD | `0000 0110 1011 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | hitungan nanosecond unsigned setelah tengah malam hari sipil |
| Sisi Hugo | `value/time/civil-time-nanoseconds.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | nilai mentah 4 WORD |  |  |

CIVIL-TIME-NANOSECONDS menyatakan waktu sipil tanpa tanggal sebagai jumlah nanosecond setelah tengah malam.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x06BL`. Keluarga TIME.
- Memakai tipe fisik int64 bertanda berlebar tetap yang sama dengan Parquet `TIME(isAdjustedToUTC=false, unit=NANOS)`.

```
TAG WORD          0x06B4 (0000 0110 1011 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Seluruh Payload 4 WORD dibaca sebagai count bertanda komplemen dua 64 bit dengan urutan WORD big-endian.
- Tipe fisiknya int64 bertanda, tetapi rentang yang valid adalah `0 <= value < 86,400×10^9` ns. Nilai negatif dan nilai di atas atau sama dengan batas atas ditolak.
- `24:00` dan label detik kabisat tidak diizinkan. Tanggal, zona waktu, dan offset UTC juga tidak dimuat.
- Nilai kecil pun selalu memakai 4 WORD.

## Panjang {#길이}

- Total adalah jumlah TAG 1 WORD dan Payload 4 WORD, yaitu tepat 5 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, maupun padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh {#예시}

- Tengah malam adalah Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 ns setelah tengah malam adalah Payload `0000 0000 0000 0001`.
- `86,400×10^9` ns sama dengan batas atas sehingga tidak valid.
- `FFFF FFFF FFFF FFFF` adalah -1 sebagai int64 bertanda sehingga tidak valid.

## Dasar standar {#표준-근거}

- `TIME(isAdjustedToUTC=false, unit=NANOS)` pada [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) menyimpan nanosecond setelah tengah malam pada waktu lokal dalam `int64` dan memakai urutan bertanda.
- Schema.fbs yang otoritatif pada [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html), yaitu [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs), mendefinisikan Time NANOSECOND sebagai bilangan bulat bertanda 64 bit, membatasi rentang yang valid hingga kurang dari 86.400 detik termasuk tengah malam, dan tidak mengizinkan detik kabisat. GEUL hanya menambahkan TAG dan framing WORD 16 bit big-endian.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000006B0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006B000000000
BODY
#1 DECLARE 0x06B0
#2 FIELD #1 0x0004
#3 BIND #1 "CIVIL-TIME-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
