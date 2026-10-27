---
title: "QUATERNION-BINARY32"
weight: 1005
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "etc"]
summary: "QUATERNION-BINARY32 adalah format Issuer ADHOC 11 WORD tetap yang memuat kuaternion dengan empat komponen binary32 dalam urutan (x, y, z, w)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

QUATERNION-BINARY32 adalah Value yang menyatakan kuaternion dengan empat komponen IEEE 754 binary32 dalam urutan `(x, y, z, w)`. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0704`, keluarga NUMERIC.

## Layout

```
TAG WORD          0x0D7C (0000 1101 0111 1100)  total 11 WORD
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0704
Payload           [x: 2 WORD][y: 2 WORD][z: 2 WORD][w: 2 WORD]
```

## Interpretasi dan validitas

- Setiap komponen adalah interchange bits binary32 dalam urutan WORD big-endian.
- Frame, handedness, unit norm, dan kesetaraan `q/-q` adalah konteks eksternal dan tidak termasuk dalam makna format ini.
- Pola bit payload NaN dan signed zero dipertahankan, dan tidak ada padding ABI.
- Payload tepat 8 WORD. Format ini tidak memaksakan unit norm atau normalisasi `q/-q`.

## Dasar standar dan status format

- Urutan `x, y, z, w` sama dengan urutan komponen kuaternion pada [spesifikasi/registri glTF 2.0](https://registry.khronos.org/glTF/) Khronos, dan setiap komponen adalah [IEEE 754 binary32](https://standards.ieee.org/ieee/754/6210/).
- Rotasi node glTF menuntut unit quaternion dengan W sebagai scalar. Format ini adalah kuaternion umum yang tidak memaksakan unit norm atau makna rotasi, sehingga tidak dapat dianggap sama dengan rotasi glTF kecuali profil eksternal menambahkan syarat itu.

## Panjang

- Total tepat 11 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 8 WORD, dengan panjang langsung `LLLL=1010`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 8 WORD, ditolak.

## Contoh

- Komponen `(0.0, 0.0, 0.0, 1.0)` adalah nilai valid yang menyimpan empat pola bit secara berurutan.
