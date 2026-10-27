---
title: "POSIX-TIMESTAMP-SECONDS"
weight: 35
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "POSIX-TIMESTAMP-SECONDS adalah Value yang memuat jumlah detik signed int64 sejak epoch Unix (Codec 0x22)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POSIX-TIMESTAMP-SECONDS adalah jumlah detik bertanda sejak epoch Unix `1970-01-01T00:00:00Z`. Seperti seconds-since-the-Epoch POSIX, setiap hari dianggap tepat 86,400 detik dan detik kabisat tidak dihitung.

## Layout

- Kode: kode langsung Value `0x22`. Keluarga TIME.
- Untuk pertukaran data industri, memakai tipe fisik signed int64 berlebar tetap yang sama dengan Arrow `timestamp[s]`.

```
TAG WORD          0x0A22 (0000 1010 0010 0010)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretasi dan validitas

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen 2 64 bit dalam urutan WORD big-endian.
- Rentang yang valid adalah `-2^63`~`2^63-1` detik. Negatif adalah instant sebelum epoch.
- Nilai kecil pun selalu memakai 4 WORD. Tidak boleh dipersingkat menjadi representasi bilangan bulat WORD minimum.
- Timezone, offset UTC asli, label detik kabisat, dan tabel detik kabisat tidak dimuat.

## Panjang

- Total tepat 5 WORD, yaitu jumlah TAG 1 WORD dan Payload 4 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh

- Epoch adalah Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 detik setelah epoch adalah Payload `0000 0000 0000 0001`.
- 1 detik sebelum epoch adalah Payload `ffff ffff ffff ffff`.

## Dasar standar

- [POSIX.1-2024 `timespec`](https://pubs.opengroup.org/onlinepubs/9799919799/functions/V2_chap02.html) hanya mendefinisikan anggota `time_t tv_sec` dan `long tv_nsec`, dan tidak mendefinisikan wire format yang menserialisasi detik akumulatif sebagai signed int64. Lebar dan representasi konkret `time_t` mengikuti lingkungan implementasi dan tidak sama dengan representasi Payload GEUL.
- [POSIX.1-2024 Seconds Since the Epoch](https://pubs.opengroup.org/onlinepubs/9799919799/basedefs/V1_chap04.html) mendefinisikan padanan kalender detik setelah epoch dan aturan 86,400 detik per hari.
- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) dan [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) otoritatif mendefinisikan timestamp sebagai bilangan bulat bertanda 64 bit sejak epoch tetap, serta mendukung satuan SECOND dan tidak menghitung detik kabisat. GEUL hanya menambahkan framing TAG dan WORD 16 bit big-endian pada tipe fisik ini.
