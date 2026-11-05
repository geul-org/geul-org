---
title: "DURATION-NANOSECONDS (0x081L)"
weight: 129
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS adalah waktu berlalu signed dalam nanodetik tanpa epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS adalah waktu berlalu signed dalam nanodetik tanpa epoch. Bukan instant dan bukan periode bulan·tahun kalender.

| Butir | Nilai |
|---|---|
| Nama | `DURATION-NANOSECONDS` (dokumen spesifikasi BIND `DURATION-NANOSECONDS`) |
| TAG ID | `0x081L` |
| Codec ID | `0x00000810` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000810/` (sasaran DECLARE `0810`) |
| Bagian | 4 `0100` (Value), offset dalam bagian C = 1 |
| Kind | Value · keluarga: TIME |
| TAG WORD | `0000 1000 0001 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Waktu berlalu signed dalam nanodetik tanpa epoch |
| Sisi Hugo | `value/time/duration-nanoseconds.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `nanoseconds` | #2 | nilai mentah 4 WORD |  |  |

## Layout {#레이아웃}

- Kode: kode langsung Value `0x081L`. Keluarga TIME.
- Memakai tipe fisik signed int64 berlebar tetap yang sama dengan `Duration(NANOSECOND)` Arrow.

```
TAG WORD          0x0814 (0000 1000 0001 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Seluruh 4 Payload WORD dibaca sebagai count signed komplemen dua 64 bit dengan urutan WORD big-endian.
- Rentang valid adalah `-2^63`~`2^63-1` ns. Tanda menyatakan arah waktu berlalu dan tidak menunjuk instant pada epoch tertentu.
- Nilai kecil pun selalu memakai 4 WORD.

## Panjang {#길이}

- Total adalah tepat 5 WORD, yaitu TAG 1 WORD ditambah Payload 4 WORD, dan memakai panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, maupun padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh {#예시}

- 0 ns: Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`. Totalnya `0814 0000 0000 0000 0000`.
- 1 ns: Payload `0000 0000 0000 0001`.
- -1 ns: Payload `FFFF FFFF FFFF FFFF`.

## Dasar standar {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) menetapkan `Schema.fbs` sebagai sumber otoritatif tipe data standar Arrow.
- Pada [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) otoritatif Arrow, `Duration` adalah waktu berlalu absolut yang tidak terkait kalender, mendukung satuan NANOSECOND, dan selalu direpresentasikan sebagai bilangan bulat signed 8 byte. GEUL hanya menambahkan TAG dan framing WORD 16 bit big-endian.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000810/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x0426000000000000081000000000
BODY
#1 DECLARE 0x0810
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-NANOSECONDS"
#4 BIND #2 "nanoseconds"
```
