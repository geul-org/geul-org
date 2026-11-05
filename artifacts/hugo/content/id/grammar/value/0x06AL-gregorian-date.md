---
title: "GREGORIAN-DATE (0x06AL)"
weight: 106
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "GREGORIAN-DATE adalah jumlah hari bertanda dengan 1970-01-01 proleptic Gregorian sebagai day 0."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `GREGORIAN-DATE` (dokumen spesifikasi BIND `GREGORIAN-DATE`) |
| TAG ID | `0x06AL` |
| Codec ID | `0x000006A0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000006A0/` (sasaran DECLARE `06A0`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 10 |
| Kind | Value · keluarga: TIME |
| TAG WORD | `0000 0110 1010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | jumlah hari bertanda berdasarkan proleptic Gregorian `1970-01-01` |
| Sisi Hugo | `value/time/gregorian-date.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `days` | #2 | nilai mentah 2 WORD |  |  |

GREGORIAN-DATE adalah jumlah hari bertanda dengan proleptic Gregorian `1970-01-01` sebagai day 0. Zona waktu dan waktu dalam hari tidak dimuat.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x06AL`. Keluarga TIME.
- Memakai tipe fisik int32 bertanda berlebar tetap yang sama dengan Arrow Date32 dan Parquet `DATE`.

```
TAG WORD          0x06A2 (0000 0110 1010 0010)  total 3 WORD
Payload WORD 1st (bits 31..16)     Signed Day Count high 16bit
Payload WORD 2nd (bits 15..0)      Signed Day Count low 16bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Seluruh Payload 2 WORD dibaca sebagai day count bertanda komplemen dua 32 bit dengan urutan WORD big-endian.
- Rentang yang valid adalah `-2^31` sampai `2^31-1` hari. Nilai negatif adalah tanggal sebelum epoch.
- Saat menghitung balik day count menjadi tahun, bulan, dan tanggal, dipakai kalender proleptic Gregorian tanpa peralihan kalender historis.
- Nilai kecil pun selalu memakai 2 WORD.

## Panjang {#길이}

- Total adalah jumlah TAG 1 WORD dan Payload 2 WORD, yaitu tepat 3 WORD, dengan panjang langsung `LLLL=0010`. Tidak ada Length extension TAG, descriptor, maupun padding.
- Jika Payload bukan tepat 2 WORD, ditolak.

## Contoh {#예시}

| Tanggal | Payload | Length total |
|---|---|---:|
| `1970-01-01` | `0000 0000` | 3 WORD (`LLLL=0010`) |
| `1970-01-02` | `0000 0001` | 3 WORD (`LLLL=0010`) |
| `1969-12-31` | `FFFF FFFF` | 3 WORD (`LLLL=0010`) |

## Hubungan dengan EDTF {#edtf와의-관계}

- Presisi yang lebih kasar daripada hari, ketidakpastian atau perkiraan, dan interval ditulis dengan [EDTF](0x06EL-edtf.md). Tanggal yang dapat ditulis secara tepat dengan GREGORIAN-DATE tidak ditulis dengan EDTF (bentuk kanonik EDTF).

## Dasar standar {#표준-근거}

- `DATE` pada [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) adalah `int32` yang menyimpan jumlah hari sejak 1970-01-01, epoch Unix, dan memakai urutan bertanda.
- Date32 pada [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) dan [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) yang otoritatif menyimpan jumlah hari sejak epoch Unix sebagai bilangan bulat bertanda 32 bit.
- Penghitungan balik proleptic Gregorian adalah profil kalender GEUL yang diadopsi format ini. Makna day count int32 Arrow/Parquet dibiarkan apa adanya, dan hanya ditambahkan TAG dan framing WORD 16 bit big-endian.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000006A0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006A000000000
BODY
#1 DECLARE 0x06A0
#2 FIELD #1 0x0002
#3 BIND #1 "GREGORIAN-DATE"
#4 BIND #2 "days"
```
