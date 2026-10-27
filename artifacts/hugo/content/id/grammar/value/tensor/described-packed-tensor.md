---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR adalah format Issuer ADHOC yang mengisi elemen sub-WORD secara low-bit-first setelah descriptor packed format·rank·shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR adalah Value tensor yang menulis shape dan packed format pada descriptor Payload lalu menyimpan elemen yang lebih kecil dari WORD secara packed. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0601`, keluarga NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload sisanya   [packed payload octet stream, low-bit-first]
```

## Interpretasi

- rank adalah nilai 4 bit pada descriptor sehingga secara struktural hanya dapat menyatakan `0..15`. Setiap dimension adalah uint32 big-endian non-negatif. Urutan logis adalah C-contiguous row-major.
- Seperti aturan tensor logis ONNX, shape `[]` pada rank 0 adalah scalar dengan 1 elemen, dan jika salah satu dimension 0 maka jumlah elemen 0. Selain itu jumlah elemen adalah hasil kali semua dimension.
- packed-format mengunci encoding elemen dan lebar bit seperti int2/int4, FP4/FP6, dan varian FP8 tertentu.
- Jika urutan octet payload dinyatakan `p[0], p[1], ...` dan dilihat sebagai bilangan bulat little-bit-endian `P = Σ(p[j] << (8j))`, elemen logis `i` berlebar `w` adalah `(P >> (i × w)) & ((1 << w) - 1)`. Yaitu elemen pertama dimasukkan ke bit paling rendah.
- Pada WORD, `p[0]` dimuat sebagai octet atas WORD pertama dan `p[1]` sebagai octet bawah, dan seterusnya. Bit ekor atas yang tidak dipakai pada octet terakhir yang dipakai harus 0, dan jika jumlah octet payload ganjil, seluruh octet bawah yang tidak dipakai pada WORD terakhir harus `00`.

## Validitas

- Saat lebar bit format yang didukung diterapkan, hasil kali dimension shape yang dihitung tanpa overflow harus sama dengan jumlah elemen payload.
- Jika bit ekor atas setelah bit payload yang diperlukan atau padding octet ada yang 1, ditolak. Descriptor, shape, dan payload harus masuk seluruhnya dalam Length record.

## Dasar standar dan status format

- Makna logis shape, scalar rank 0, dan zero dimension mengikuti [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Aturan menaruh elemen sub-byte mulai dari bit rendah mengikuti packing int2/int4 pada [skema ONNX TensorProto](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) resmi dan packing little bit-endian pada [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- rank 4 bit, dimension uint32, field version/packed-format, cara mengelompokkan octet menjadi WORD big-endian, serta TAG/Length GEUL adalah descriptor khas GEUL. Bukan serialisasi wire·memori ONNX, [tensor Apache Arrow](https://arrow.apache.org/docs/format/Other.html), maupun DLPack itu sendiri.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga masuk ke jumlah total ([Record dan TAG WORD](/id/grammar/record/)).
- descriptor adalah 1 WORD, shape adalah `2 × rank` WORD, dan sisanya adalah payload packed.
- Jika jumlah elemen logis `N` dan lebar elemen `w`, jumlah octet payload adalah `ceil(N × w / 8)`, dan jumlah WORD payload adalah `ceil(jumlah octet payload / 2)`.

## Contoh

- Pada profil dengan rank 2, 4 WORD setelah descriptor adalah shape, dan setelahnya adalah urutan octet payload low-bit-first. Lebar elemen dan apakah benar diizinkan dinilai dengan profil format yang sudah ditetapkan.
- Urutan octet payload elemen 4 bit `[1, 2, 3]` adalah `21 03` dan WORD payload-nya `2103`. Elemen pertama berada pada nibble rendah octet pertama, dan nibble atas yang tidak dipakai pada octet terakhir adalah 0.

## Masalah terbuka

- Nilai registri version dan packed-format, serta rentang profil yang didukung dari rank `0..15` yang dapat dinyatakan, belum ditetapkan.
