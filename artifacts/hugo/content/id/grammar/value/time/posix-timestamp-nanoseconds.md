---
title: "POSIX-TIMESTAMP-NANOSECONDS"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-NANOSECONDS adalah Value yang memuat jumlah nanosecond signed int64 sejak epoch Unix (format Issuer IEEE 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-NANOSECONDS adalah jumlah nanosecond bertanda sejak epoch Unix `1970-01-01T00:00:00Z`. Seperti seconds-since-the-Epoch POSIX, setiap hari dianggap tepat 86,400 detik dan detik kabisat tidak dihitung.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0040` IEEE, nomor format `0x4000`. Keluarga TIME.
- Untuk pertukaran data industri, memakai tipe fisik signed int64 berlebar tetap yang sama dengan Parquet `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total 7 WORD
Issuer            1 WORD  0x0040 (IEEE)
Nomor format      1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretasi dan validitas

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen 2 64 bit dalam urutan WORD big-endian.
- Rentang yang valid adalah `-2^63`~`2^63-1` ns, dan rentang instant-nya adalah `1677-09-21 00:12:43.145224192Z`~`2262-04-11 23:47:16.854775807Z`.
- Nilai kecil pun selalu memakai 4 WORD. Tidak boleh dipersingkat menjadi representasi bilangan bulat WORD minimum.
- Timezone, offset UTC asli, label detik kabisat, dan tabel detik kabisat tidak dimuat.

## Panjang

- Total tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh

- Epoch adalah Payload `0000 0000 0000 0000`, total 7 WORD, `LLLL=0110`.
- 1 ns setelah epoch adalah Payload `0000 0000 0000 0001`.
- 1 ns sebelum epoch adalah Payload `ffff ffff ffff ffff`.

## Dasar standar

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) mendefinisikan anggota `time_t tv_sec` dan `long tv_nsec` serta `0 <= tv_nsec < 10^9`. Lebar dan representasi konkret `time_t` mengikuti lingkungan implementasi, dan wire format signed int64 nanosecond akumulatif yang menggabungkan kedua anggota tidak didefinisikan.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) menganggap sehari tepat 86,400 detik.
- `TIMESTAMP(isAdjustedToUTC=true, unit=NANOS)` pada [Apache Parquet Logical Types](https://parquet.apache.org/docs/file-format/types/logicaltypes/) menyimpan nanosecond sejak epoch Unix dalam satu `int64`. GEUL hanya menambahkan framing TAG dan WORD 16 bit big-endian pada tipe fisik ini.
