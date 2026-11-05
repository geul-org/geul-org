---
title: "BBOX2-BINARY64"
weight: 1000
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BBOX2-BINARY64 adalah kotak pembatas dua dimensi yang terdiri atas empat komponen IEEE 754 binary64 dengan urutan (minX, minY, maxX, maxY)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BBOX2-BINARY64 adalah kotak pembatas dua dimensi yang terdiri atas empat komponen IEEE 754 binary64 dengan urutan `(minX, minY, maxX, maxY)`.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x0000050C`. Keluarga NUMERIC.

```
TAG WORD          0x09DE (0000 1001 1101 1110)  LLLL=1110
TAG ekstensi Length   1 WORD  0x0016 (total 22 WORD)
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x0000050C
Payload: [minX: 4 WORD][minY: 4 WORD][maxX: 4 WORD][maxY: 4 WORD]
```

## Aturan interpretasi {#해석-규칙}

- Setiap komponen berupa binary64 dan dibaca mulai dari WORD teratas. Pola bit signed zero dipertahankan.
- CRS, makna dan urutan sumbu, serta satuan merupakan konteks eksternal. Tidak ada ABI padding.

## Validitas {#유효성}

- Payload harus tepat 16 WORD, dan harus berlaku `minX ≤ maxX` serta `minY ≤ maxY`.
- NaN tidak dapat dibandingkan, sehingga nilai yang memuat NaN pada komponen mana pun ditolak.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Makna koordinat minimum dan maksimum merujuk pada bounding envelope dalam OGC [GeoPackage Encoding Standard](https://docs.ogc.org/is/12-128r19/12-128r19.html), dan setiap komponen mengikuti [IEEE 754 binary64](https://standards.ieee.org/ieee/754/6210/).
- Urutan larik 2D pada envelope GeoPackage adalah `[minx, maxx, miny, maxy]`. Urutan `(minX, minY, maxX, maxY)` pada format ini bukan wire order tersebut, melainkan tuple ringkas yang ditetapkan GEUL, dan header WKB/GeoPackage juga tidak dimuat. CRS, makna sumbu, dan satuan merupakan konteks eksternal.

## Panjang {#길이}

- Totalnya tepat 22 WORD, yaitu jumlah TAG 1 WORD, TAG ekstensi Length 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 16 WORD, dengan `LLLL=1110`. Tidak ada descriptor maupun padding.
- Jika Payload tidak tepat 16 WORD, nilai ditolak.

## Contoh {#예시}

- Jika komponennya `(0.0, 1.0, 2.0, 3.0)`, nilai itu valid, dan jika `(2.0, 1.0, 0.0, 3.0)`, nilai itu tidak valid.
