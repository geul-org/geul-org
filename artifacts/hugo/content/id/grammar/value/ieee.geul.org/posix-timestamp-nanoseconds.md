---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1032
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS adalah jumlah nanosecond bertanda sejak Unix epoch 1970-01-01T00:00:00Z."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS adalah jumlah nanosecond bertanda sejak Unix epoch `1970-01-01T00:00:00Z`. Seperti seconds-since-the-Epoch pada POSIX, setiap hari dianggap tepat 86.400 detik dan leap second tidak dihitung.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x0000000D` IEEE, nomor Codec `0x00004000`. Keluarga TIME.
- Untuk pertukaran data industri, format ini memakai tipe fisik signed int64 berlebar tetap yang sama dengan Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x09D8 (0000 1001 1101 1000)  total 9 WORD
Issuer            2 WORD  0x0000000D (IEEE)
Nomor Codec       2 WORD  0x00004000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretasi dan validitas {#해석과-유효성}

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen dua 64 bit dengan urutan WORD big-endian.
- Rentang yang valid adalah `-2^63` hingga `2^63-1` ns, dan rentang instant-nya adalah `1677-09-21 00:12:43.145224192Z` hingga `2262-04-11 23:47:16.854775807Z`.
- Nilai kecil pun selalu memakai 4 WORD. Tidak boleh dipersingkat menjadi representasi bilangan bulat WORD minimum.
- Timezone, offset UTC asli, label leap second, dan tabel leap-second tidak dimuat.

## Panjang {#길이}

- Totalnya tepat 9 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=1000`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 4 WORD, nilai ditolak.

## Contoh {#예시}

- Epoch adalah Payload `0000 0000 0000 0000`, total 9 WORD, `LLLL=1000`.
- 1 ns setelah epoch adalah Payload `0000 0000 0000 0001`.
- 1 ns sebelum epoch adalah Payload `FFFF FFFF FFFF FFFF`.

## Dasar standar {#표준-근거}

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) mendefinisikan anggota `time_t tv_sec` dan `long tv_nsec` serta `0 <= tv_nsec < 10^9`. Lebar dan representasi konkret `time_t` bergantung pada lingkungan implementasi, dan POSIX tidak mendefinisikan wire format signed int64 nanosecond kumulatif yang menggabungkan kedua anggota tersebut.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) menganggap satu hari tepat 86.400 detik.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` pada [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) menyimpan nanosecond sejak Unix epoch sebagai satu `int64`. GEUL hanya menambahkan TAG dan framing WORD 16bit big-endian pada tipe fisik ini.
