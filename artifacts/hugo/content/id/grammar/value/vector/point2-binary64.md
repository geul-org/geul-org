---
title: "POINT2-BINARY64"
weight: 1011
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 adalah Value titik 2 dimensi dengan dua komponen IEEE 754 binary64 dalam urutan (x, y) (format Issuer ADHOC 0x050A)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 adalah titik 2 dimensi dengan dua komponen IEEE 754 binary64 dalam urutan `(x, y)`.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x050A`. Keluarga NUMERIC.

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Aturan interpretasi

- Setiap komponen dibaca mulai dari WORD atas, dan pola bit payload NaN dan signed zero dipertahankan.
- CRS, makna·urutan sumbu, dan satuan adalah konteks eksternal. Tidak ada padding ABI.

## Validitas

- Payload tepat 8 WORD, dan setiap bagian 4 WORD adalah interchange bits binary64.

## Dasar standar dan status format

- Urutan koordinat `x, y` titik merujuk pada axis order Point/WKB [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) OGC, dan setiap komponen mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Payload ini adalah profil ringkas GEUL yang tidak memuat header type/byte-order WKB atau header GeoPackage, dan bukan wire format WKB OGC. CRS, makna sumbu, dan satuan adalah konteks eksternal.

## Panjang

- Total tepat 11 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1010`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Contoh

- Payload `3ff0 0000 0000 0000 4000 0000 0000 0000` adalah `(1.0, 2.0)`.
