---
title: "BGRA8-UNORM"
weight: 1037
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "BGRA8-UNORM adalah Value yang menyimpan empat komponen UNORM8 B, G, R, A secara packed dalam Payload tetap 2 WORD."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BGRA8-UNORM adalah Value yang menyimpan empat komponen UNORM8 B, G, R, A secara packed dalam Payload tetap 2 WORD.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x0000000E` KHRONOS, nomor Codec `0x00000001`. Keluarga NUMERIC.

```
TAG WORD          0x09D6 (0000 1001 1101 0110)  total 7 WORD
Issuer            2 WORD  0x0000000E (KHRONOS)
Nomor Codec       2 WORD  0x00000001
Payload WORD 1st: [B: 8bit atas][G: 8bit bawah]
Payload WORD 2nd: [R: 8bit atas][A: 8bit bawah]
```

## Aturan interpretasi {#해석-규칙}

- Urutan byte serialisasi adalah `B, G, R, A`, dan nilai setiap byte komponen `b` adalah `b / 255`.
- Ini sesuai dengan urutan komponen byte 0~3 dan pemetaan numerik UNORM pada Vulkan `VK_FORMAT_B8G8R8A8_UNORM`.
- Format ini bukan `_SRGB` sehingga tidak mengisyaratkan sRGB maupun ruang warna atau transfer function lain. Alpha juga merupakan nilai UNORM, tetapi apakah straight atau premultiplied serta makna compositing-nya merupakan konteks eksternal. Tidak ada ABI padding.

## Validitas {#유효성}

- Semua pola 8 bit valid. Payload harus tepat 2 WORD.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Urutan memori komponen dan makna UNORM disesuaikan dengan `VK_FORMAT_B8G8R8A8_UNORM` pada [Vulkan Formats specification](https://docs.vulkan.org/spec/latest/chapters/formats.html) dan [Vulkan registry](https://registry.khronos.org/vulkan/specs/latest/registry.html) milik Khronos.
- TAG/Length GEUL dan framing dua WORD big-endian 16 bit merupakan aturan khas GEUL, dan tidak mendefinisikan serialization image Vulkan itu sendiri.

## Panjang {#길이}

- Totalnya tepat 7 WORD, yaitu jumlah TAG 1 WORD, Issuer 2 WORD, nomor Codec 2 WORD, dan Payload 2 WORD, dengan panjang langsung `LLLL=0110`. Tidak ada TAG ekstensi Length, descriptor, maupun padding.
- Jika Payload tidak tepat 2 WORD, nilai ditolak.

## Contoh {#예시}

- Payload `0000 FF80` adalah bytes `B=00, G=00, R=FF, A=80`.
