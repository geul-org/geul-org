---
title: "POINT3-BINARY64"
weight: 1018
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT3-BINARY64 adalah titik tiga dimensi yang terdiri atas tiga komponen IEEE 754 binary64 dengan urutan (x, y, z)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT3-BINARY64 adalah titik tiga dimensi yang terdiri atas tiga komponen IEEE 754 binary64 dengan urutan `(x, y, z)`.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x0000050B`. Keluarga NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG ekstensi Length   1 WORD  0x0012 (total 18 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x0000050B
Payload: [x binary64: 4 WORD][y binary64: 4 WORD][z binary64: 4 WORD]
```

## Aturan interpretasi {#해석-규칙}

- Setiap komponen dibaca mulai dari WORD teratas, dan pola bit payload NaN serta signed zero dipertahankan.
- CRS, makna dan urutan sumbu, serta satuan merupakan konteks eksternal. Tidak ada ABI padding.

## Validitas {#유효성}

- Payload tepat 12 WORD, dan setiap rentang 4 WORD adalah interchange bits binary64.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Urutan koordinat `x, y, z` pada titik merujuk pada axis order Point/WKB dalam OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), dan setiap komponen mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Payload ini adalah profil ringkas GEUL yang tidak memuat header type/byte-order WKB maupun header GeoPackage, dan bukan wire format OGC WKB. CRS, makna sumbu, dan satuan merupakan konteks eksternal.

## Panjang {#길이}

- Totalnya tepat 18 WORD, yaitu jumlah TAG 1 WORD, TAG ekstensi Length 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 12 WORD, dengan `LLLL=1110`. Tidak ada descriptor maupun padding.
- Jika Payload tidak tepat 12 WORD, nilai ditolak.

## Contoh {#예시}

- Jika tiga binary64 pada Payload adalah `1.0, 2.0, 3.0`, nilainya adalah titik `(1.0, 2.0, 3.0)`.
