---
title: "DURATION-SECONDS"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "time"]
summary: "DURATION-SECONDS adalah Value yang memuat waktu berlalu satuan detik signed int64 tanpa epoch (Codec 0x23)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DURATION-SECONDS adalah waktu berlalu bertanda dalam satuan detik tanpa epoch. Ini bukan instant atau periode bulan·tahun kalender.

## Layout

- Kode: kode langsung Value `0x23`. Keluarga TIME.
- Memakai tipe fisik signed int64 berlebar tetap yang sama dengan Arrow `Duration(SECOND)`.

```
TAG WORD          0x0A23 (0000 1010 0010 0011)  total 5 WORD
Payload WORD 1st (bits 63..48)     Signed Seconds high 16bit
Payload WORD 2nd (bits 47..32)     Signed Seconds
Payload WORD 3rd (bits 31..16)     Signed Seconds
Payload WORD 4th (bits 15..0)      Signed Seconds low 16bit
```

## Interpretasi dan validitas

- Seluruh 4 WORD Payload dibaca sebagai count bertanda komplemen 2 64 bit dalam urutan WORD big-endian.
- Rentang yang valid adalah `-2^63`~`2^63-1` detik. Tanda adalah arah berlalunya waktu dan tidak menunjuk instant pada epoch tertentu.
- Nilai kecil pun selalu memakai 4 WORD.

## Panjang

- Total tepat 5 WORD, yaitu jumlah TAG 1 WORD dan Payload 4 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 4 WORD, ditolak.

## Contoh

- 0 detik adalah Payload `0000 0000 0000 0000`, total 5 WORD, `LLLL=0100`.
- 1 detik adalah Payload `0000 0000 0000 0001`.
- -1 detik adalah Payload `ffff ffff ffff ffff`.

## Dasar standar

- [Apache Arrow Columnar Format](https://arrow.apache.org/docs/format/Columnar.html) menetapkan `Schema.fbs` sebagai sumber otoritatif tipe data standar Arrow.
- Pada [Schema.fbs](https://github.com/apache/arrow/blob/main/format/Schema.fbs) otoritatif Arrow, `Duration` adalah waktu berlalu absolut yang tidak bergantung kalender, mendukung satuan SECOND, dan selalu dinyatakan sebagai bilangan bulat bertanda 8 byte. GEUL hanya menambahkan framing TAG dan WORD 16 bit big-endian.
