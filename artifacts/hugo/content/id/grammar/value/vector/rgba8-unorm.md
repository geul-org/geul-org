---
title: "RGBA8-UNORM"
weight: 1014
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "RGBA8-UNORM adalah Value piksel yang memuat empat komponen UNORM8 dalam urutan R, G, B, A pada Payload 2 WORD (format Issuer KHRONOS 0x0000)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

RGBA8-UNORM adalah Value yang menyimpan empat komponen UNORM8 R, G, B, A secara packed dalam Payload 2 WORD tetap.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0041` KHRONOS, nomor format `0x0000`. Keluarga NUMERIC.

```
TAG WORD          0x0A7C (0000 1010 0111 1100)  total 5 WORD
Issuer            1 WORD  0x0041 (KHRONOS)
Nomor format      1 WORD  0x0000
Payload WORD 1st: [R: 8 bit atas][G: 8 bit bawah]
Payload WORD 2nd: [B: 8 bit atas][A: 8 bit bawah]
```

## Aturan interpretasi

- Urutan byte serialisasi adalah `R, G, B, A`, dan nilai setiap byte komponen `b` adalah `b / 255`.
- Ini berpadanan dengan urutan komponen byte 0~3 dan pemetaan numerik UNORM `VK_FORMAT_R8G8B8A8_UNORM` pada Vulkan.
- Karena bukan format `_SRGB`, ruang warna sRGB atau transfer function lain tidak tersirat. Alpha juga nilai numerik UNORM, tetapi apakah straight/premultiplied dan makna compositing adalah konteks eksternal. Tidak ada padding ABI.

## Validitas

- Semua pola 8 bit valid. Payload harus tepat 2 WORD.

## Dasar standar dan status format

- Urutan memori komponen dan makna UNORM disesuaikan dengan `VK_FORMAT_R8G8B8A8_UNORM` pada [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) dan [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) Khronos.
- Framing TAG/Length GEUL dan dua WORD big-endian 16 bit adalah aturan khas GEUL, dan tidak mendefinisikan serialisasi image Vulkan itu sendiri.

## Panjang

- Total tepat 5 WORD, yaitu jumlah TAG 1 WORD, Issuer 1 WORD, nomor format 1 WORD, dan Payload 2 WORD, dengan panjang langsung `LLLL=0100`. Tidak ada Length extension TAG, descriptor, dan padding.
- Jika Payload bukan tepat 2 WORD, ditolak.

## Contoh

- Payload `ff00 0080` adalah byte `R=ff, G=00, B=00, A=80`.
