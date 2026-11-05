---
title: "POINT2-BINARY64"
weight: 1017
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "POINT2-BINARY64 adalah titik dua dimensi yang terdiri atas dua komponen IEEE 754 binary64 dengan urutan (x, y)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

POINT2-BINARY64 adalah titik dua dimensi yang terdiri atas dua komponen IEEE 754 binary64 dengan urutan `(x, y)`.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x0000050A`. Keluarga NUMERIC.

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x0000050A
Payload: [x binary64: 4 WORD][y binary64: 4 WORD]
```

## Aturan interpretasi {#해석-규칙}

- Setiap komponen dibaca mulai dari WORD teratas, dan pola bit payload NaN serta signed zero dipertahankan.
- CRS, makna dan urutan sumbu, serta satuan merupakan konteks eksternal. Tidak ada ABI padding.

## Validitas {#유효성}

- Payload tepat 8 WORD, dan setiap rentang 4 WORD adalah interchange bits binary64.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Urutan koordinat `x, y` pada titik merujuk pada axis order Point/WKB dalam OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), dan setiap komponen mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Payload ini adalah profil ringkas GEUL yang tidak memuat header type/byte-order WKB maupun header GeoPackage, dan bukan wire format OGC WKB. CRS, makna sumbu, dan satuan merupakan konteks eksternal.

## Panjang {#길이}

- Totalnya tepat 13 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1100`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 8 WORD, nilai ditolak.

## Contoh {#예시}

- Payload `3FF0 0000 0000 0000 4000 0000 0000 0000` adalah `(1.0, 2.0)`.
