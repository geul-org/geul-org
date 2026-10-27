---
title: "BBOX2-BINARY64"
weight: 1013
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 adalah Value bounding box 2 dimensi dengan empat komponen IEEE 754 binary64 dalam urutan (minX, minY, maxX, maxY) (format Issuer ADHOC 0x050C)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 adalah bounding box 2 dimensi dengan empat komponen IEEE 754 binary64 dalam urutan `(minX, minY, maxX, maxY)`.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x050C`. Keluarga NUMERIC.

```
TAG WORD          0x0F7C (0000 1111 0111 1100)  LLLL=1110
Length extension TAG   1 WORD  0x0014 (total 20 WORD)
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Aturan interpretasi

- Setiap komponen adalah binary64 dan dibaca mulai dari WORD atas. Pola bit signed zero dipertahankan.
- CRS, makna·urutan sumbu, dan satuan adalah konteks eksternal. Tidak ada padding ABI.

## Validitas

- Payload harus tepat 16 WORD dan harus `minX ≤ maxX`, `minY ≤ maxY`.
- NaN tidak dapat dibandingkan sehingga jika ada pada komponen mana pun, ditolak.

## Dasar standar dan status format

- Makna koordinat minimum·maksimum merujuk pada bounding envelope [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html) OGC, dan setiap komponen mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Urutan array 2D envelope GeoPackage adalah `[minx, maxx, miny, maxy]`. Urutan `(minX, minY, maxX, maxY)` format ini bukan wire order tersebut melainkan tuple ringkas yang ditetapkan GEUL, dan tidak memuat header WKB/GeoPackage. CRS, makna sumbu, dan satuan adalah konteks eksternal.

## Panjang

- Total tepat 20 WORD, yaitu jumlah TAG 1 WORD, Length extension TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 16 WORD, dengan `LLLL=1110`. Tidak ada descriptor dan padding.
- Jika Payload bukan tepat 16 WORD, ditolak.

## Contoh

- Jika komponen `(0.0, 1.0, 2.0, 3.0)`, valid, dan jika `(2.0, 1.0, 0.0, 3.0)`, invalid.
