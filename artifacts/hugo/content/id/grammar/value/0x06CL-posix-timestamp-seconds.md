---
title: "POSIX-TIMESTAMP-SECONDS (0x06CL)"
weight: 108
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS adalah jumlah detik bertanda sejak epoch Unix 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `POSIX-TIMESTAMP-SECONDS` (dokumen spesifikasi BIND `POSIX-TIMESTAMP-SECONDS`) |
| TAG ID | `0x06CL` |
| Codec ID | `0x000006C0` |
| Dokumen spesifikasi | `0x00000000/codecs/0x000006C0/` (sasaran DECLARE `06C0`) |
| Bagian | 3 `0011` (Value), offset dalam bagian C = 12 |
| Kind | Value · keluarga: TIME |
| TAG WORD | `0000 0110 1100 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | hitungan detik bertanda sejak epoch Unix/POSIX |
| Sisi Hugo | `value/time/posix-timestamp-seconds.md` |

## Field (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan field Payload ([dokumen spesifikasi Codec](../codec-spec.md)).

| Urutan | Field (BIND) | FIELD | Lebar | Format penerima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `seconds` | #2 | nilai mentah 4 WORD |  |  |

POSIX-TIMESTAMP-SECONDS adalah jumlah detik bertanda sejak epoch Unix `1970-01-01T00:00:00Z`. Seperti seconds-since-the-Epoch pada POSIX, setiap hari dianggap tepat 86.400 detik dan detik kabisat tidak dihitung.

## Layout {#레이아웃}

- Kode: kode langsung Value `0x06CL`. Keluarga TIME.
- Untuk pertukaran data industri, dipakai tipe fisik int64 bertanda berlebar tetap yang sama dengan Arrow `timestamp[s]`.

```
TAG WORD          0x06C4 (0000 0110 1100 0100)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Seluruh Payload 4 WORD dibaca sebagai count bertanda komplemen dua 64 bit dengan urutan WORD big-endian.
- Rentang yang valid adalah `-2^63` sampai `2^63-1` detik. Nilai negatif adalah instant sebelum epoch.
- Nilai kecil pun selalu memakai 4 WORD. Tidak boleh dipersingkat menjadi representasi bilangan bulat dengan WORD minimum.
- Zona waktu, offset UTC asli, label detik kabisat, dan tabel detik kabisat tidak dimuat.

## Panjang {#길이}

- Total adalah jumlah TAG 1 WORD dan Payload 4 WORD, yaitu tepat 5 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, maupun padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh {#예시}

- Epoch adalah Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 detik setelah epoch adalah Payload `0000 0000 0000 0001`.
- 1 detik sebelum epoch adalah Payload `FFFF FFFF FFFF FFFF`.

## Dasar standar {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) hanya mendefinisikan anggota `time_t tv_sec` dan `long tv_nsec`, dan tidak mendefinisikan wire format yang menyerialisasi detik kumulatif sebagai int64 bertanda. Lebar dan representasi konkret `time_t` bergantung pada lingkungan implementasi dan tidak sama dengan representasi Payload GEUL.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) mendefinisikan padanan kalender untuk detik setelah epoch dan aturan 86.400 detik per hari.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) dan [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) yang otoritatif mendefinisikan timestamp sebagai bilangan bulat bertanda 64 bit sejak epoch tetap, mendukung satuan SECOND, dan tidak menghitung detik kabisat. GEUL hanya menambahkan TAG dan framing WORD 16 bit big-endian pada tipe fisik ini.

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x000006C0/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x042600000000000006C000000000
BODY
#1 DECLARE 0x06C0
#2 FIELD #1 0x0004
#3 BIND #1 "POSIX-TIMESTAMP-SECONDS"
#4 BIND #2 "seconds"
```
