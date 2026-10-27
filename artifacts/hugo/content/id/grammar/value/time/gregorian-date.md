---
title: "GREGORIAN-DATE"
weight: 33
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE adalah Value jumlah hari signed int32 dengan proleptic Gregorian 1970-01-01 sebagai day 0 (Codec 0x20)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

GREGORIAN-DATE adalah jumlah hari bertanda dengan proleptic Gregorian `1970-01-01` sebagai day 0. Zona waktu dan waktu dalam sehari tidak dimuat.

## Layout

- Kode: kode langsung Value `0x20`. Keluarga TIME.
- Memakai tipe fisik signed int32 berlebar tetap yang sama dengan Arrow Date32 dan Parquet `DATE`.

```
TAG WORD          0x0920 (0000 1001 0010 0000)  total 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretasi dan validitas

- Seluruh 2 WORD Payload dibaca sebagai day count bertanda komplemen 2 32 bit dalam urutan WORD big-endian.
- Rentang yang valid adalah `-2^31`~`2^31-1` hari. Negatif adalah tanggal sebelum epoch.
- Saat menghitung balik day count menjadi tahun·bulan·hari, dipakai kalender proleptic Gregorian tanpa peralihan kalender historis.
- Nilai kecil pun selalu memakai 2 WORD.

## Panjang

- Total tepat 3 WORD, yaitu jumlah TAG 1 WORD dan Payload 2 WORD, dengan panjang langsung `LLLL=0010`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 2 WORD, ditolak.

## Contoh

| Tanggal | Payload | Length total |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `ffff ffff` | 3 WORD (`LLLL=0010`) |

## Hubungan dengan EDTF

- Presisi yang lebih kasar dari hari, tidak pasti·perkiraan, dan interval ditulis dengan [EDTF](/id/grammar/value/time/edtf/). Tanggal yang dapat ditulis tepat dengan GREGORIAN-DATE tidak ditulis dengan EDTF (bentuk kanonik EDTF).

## Dasar standar

- `DATE` pada [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) adalah `int32` yang menyimpan jumlah hari sejak epoch Unix 1970-01-01 dan memakai urutan bertanda.
- Date32 pada [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) dan [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) otoritatif menyimpan jumlah hari sejak epoch Unix sebagai bilangan bulat bertanda 32 bit.
- Perhitungan balik proleptic Gregorian adalah profil kalender GEUL yang diadopsi format ini. Makna day-count int32 Arrow/Parquet dibiarkan apa adanya dan hanya framing TAG dan WORD 16 bit big-endian yang ditambahkan.
