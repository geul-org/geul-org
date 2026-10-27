---
title: "DURATION-NANOSECONDS"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-NANOSECONDS adalah Value yang memuat waktu berlalu nanosecond signed int64 tanpa epoch (format Issuer GEUL 0x4000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-NANOSECONDS adalah waktu berlalu nanosecond bertanda tanpa epoch. Ini bukan instant atau periode bulan·tahun kalender.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0000` GEUL, nomor format `0x4000`. Keluarga TIME.
- Memakai tipe fisik signed int64 berlebar tetap yang sama dengan Arrow `Duration(NANOSECOND)`.

```
TAG WORD          0x0B7C (0000 1011 0111 1100)  total 7 WORD
Issuer            1 WORD  0x0000 (GEUL)
Nomor format      1 WORD  0x4000
Payload WORD 1st (bits 63..48)     Signed Nanoseconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Nanoseconds
Payload WORD 3rd (bits 31..16)     Signed Nanoseconds
Payload WORD 4th (bits 15..0)      Signed Nanoseconds low 16bit
```

## Interpretasi dan validitas

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen 2 64 bit dalam urutan WORD big-endian.
- Rentang yang valid adalah `-2^63`~`2^63-1` ns. Tanda adalah arah berlalunya waktu dan tidak menunjuk instant pada epoch tertentu.
- Nilai kecil pun selalu memakai 4 WORD.

## Panjang

- Total tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 4 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh

- 0 ns adalah Payload `0000 0000 0000 0000`, total 7 WORD, `LLLL=0110`.
- 1 ns adalah Payload `0000 0000 0000 0001`.
- -1 ns adalah Payload `ffff ffff ffff ffff`.

## Dasar standar

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) menetapkan `Schema.fbs` sebagai sumber otoritatif tipe data standar Arrow.
- Pada [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) otoritatif Arrow, `Duration` adalah waktu berlalu absolut yang tidak bergantung kalender, mendukung satuan NANOSECOND, dan selalu dinyatakan sebagai bilangan bulat bertanda 8 byte. GEUL hanya menambahkan framing TAG dan WORD 16 bit big-endian.
