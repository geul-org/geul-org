---
title: "POINT3-BINARY64"
weight: 1012
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 adalah Value titik 3 dimensi dengan tiga komponen IEEE 754 binary64 dalam urutan (x, y, z) (format Issuer ADHOC 0x050B)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 adalah titik 3 dimensi dengan tiga komponen IEEE 754 binary64 dalam urutan `(x, y, z)`.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x050B`. Keluarga NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0010 (total 16 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Aturan interpretasi

- Setiap komponen dibaca mulai dari WORD atas, dan pola bit payload NaN dan signed zero dipertahankan.
- CRS, makna·urutan sumbu, dan satuan adalah konteks eksternal. Tidak ada padding ABI.

## Validitas

- Payload tepat 12 WORD, dan setiap bagian 4 WORD adalah interchange bits binary64.

## Dasar standar dan status format

- Urutan koordinat `x, y, z` titik merujuk pada axis order Point/WKB [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) OGC, dan setiap komponen mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Payload ini adalah profil ringkas GEUL yang tidak memuat header type/byte-order WKB atau header GeoPackage, dan bukan wire format WKB OGC. CRS, makna sumbu, dan satuan adalah konteks eksternal.

## Panjang

- Total tepat 16 WORD, yaitu jumlah TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 12 WORD, dengan `LLLL=1110`. Tidak ada descriptor dan padding.
- Jika Payload bukan tepat 12 WORD, ditolak.

## Contoh

- Jika tiga binary64 Payload adalah `1.0, 2.0, 3.0`, itu adalah titik `(1.0, 2.0, 3.0)`.
