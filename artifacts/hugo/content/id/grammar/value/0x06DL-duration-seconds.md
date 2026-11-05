---
title: "DURATION-SECONDS (0x06DL)"
weight: 109
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS adalah waktu yang berlalu dalam satuan detik bertanda tanpa epoch."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DURATION-SECONDS` (dokumen spesifikasi BIND `DURATION-SECONDS`) |
| TAG ID | `0x06DL` |
| Codec ID | `0x000006D0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000006D0/` (sasaran DECLARE `06D0`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 13 |
| Kind | Value · keluarga: TIME |
| TAG WORD | `0000 0110 1101 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | waktu yang berlalu dalam SI-second bertanda tanpa epoch |
| Sisi Hugo | `value/time/duration-seconds.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | nilai mentah 4 WORD |  |  |

DURATION-SECONDS adalah waktu yang berlalu dalam satuan detik bertanda tanpa epoch. Ini bukan instant maupun rentang bulan dan tahun menurut kalender.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x06DL`. Keluarga TIME.
- Memakai tipe fisik int64 bertanda berlebar tetap yang sama dengan Arrow `Duration(SECOND)`.

```
TAG WORD          0x06D4 (0000 0110 1101 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Seluruh Payload 4 WORD dibaca sebagai count bertanda komplemen dua 64 bit dengan urutan WORD big-endian.
- Rentang yang valid adalah `-2^63` sampai `2^63-1` detik. Tanda adalah arah waktu yang berlalu dan tidak menunjuk instant pada epoch tertentu.
- Nilai kecil pun selalu memakai 4 WORD.

## Panjang {#길이}

- Total adalah jumlah TAG 1 WORD dan Payload 4 WORD, yaitu tepat 5 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, maupun padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh {#예시}

- 0 detik adalah Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 detik adalah Payload `0000 0000 0000 0001`.
- -1 detik adalah Payload `FFFF FFFF FFFF FFFF`.

## Dasar standar {#표준-근거}

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) menetapkan `Schema.fbs` sebagai sumber otoritatif tipe data standar Arrow.
- Pada [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) Arrow yang otoritatif, `Duration` adalah waktu berlalu absolut yang tidak bergantung pada kalender, mendukung satuan SECOND, dan selalu direpresentasikan sebagai bilangan bulat bertanda 8 byte. GEUL hanya menambahkan TAG dan framing WORD 16 bit big-endian padanya.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000006D0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006D000000000
BODY
#1 DECLARE 0x06D0
#2 FIELD #1 0x0004
#3 BIND #1 "DURATION-SECONDS"
#4 BIND #2 "seconds"
```
