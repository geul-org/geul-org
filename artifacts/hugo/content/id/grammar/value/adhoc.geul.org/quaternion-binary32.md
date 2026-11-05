---
title: "QUATERNION-BINARY32"
weight: 1019
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 adalah Value yang menyatakan quaternion dengan empat komponen IEEE 754 binary32 berurutan (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 adalah Value yang menyatakan quaternion dengan empat komponen IEEE 754 binary32 berurutan `(x, y, z, w)`. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000704`, keluarga NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0x09DC (0000 1001 1101 1100)  total 13 WORD
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretasi dan validitas {#해석과-유효성}

- Setiap komponen adalah interchange bits binary32 dengan urutan WORD big-endian.
- Frame, handedness, unit norm, dan kesetaraan `q/-q` merupakan konteks eksternal dan tidak termasuk dalam makna format ini.
- Pola bit payload NaN dan signed zero dipertahankan, dan tidak ada ABI padding.
- Payload tepat 8 WORD. Format ini tidak memaksakan unit norm maupun normalisasi `q/-q`.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Urutan `x, y, z, w` sama dengan urutan komponen quaternion pada Khronos [glTF 2.0 specification/registry](https://registry.khronos.org/glTF/), dan setiap komponen adalah [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Rotasi node glTF mensyaratkan unit quaternion dengan W sebagai scalar. Format ini adalah quaternion umum yang tidak memaksakan unit norm maupun makna rotasi, sehingga tidak dapat dianggap sama dengan rotasi glTF kecuali profil eksternal menambahkan syarat tersebut.

## Panjang {#길이}

- Totalnya tepat 13 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1100`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 8 WORD, nilai ditolak.

## Contoh {#예시}

- Komponen `(0.0, 0.0, 0.0, 1.0)` adalah nilai valid yang menyimpan keempat pola bit secara berurutan.
