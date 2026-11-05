---
title: "DESCRIBED-PACKED-TENSOR"
weight: 1016
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-PACKED-TENSOR adalah Value tensor yang mencatat shape dan packed format pada descriptor Payload, lalu menyimpan elemen yang lebih kecil dari WORD secara packed."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-PACKED-TENSOR adalah Value tensor yang mencatat shape dan packed format pada descriptor Payload, lalu menyimpan elemen yang lebih kecil dari WORD secara packed. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000601`, keluarga NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG ekstensi Length] jika total 15 WORD atau lebih
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000601
Payload WORD 1st  [version: 4bit][packed-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Sisa Payload      [packed payload octet stream, low-bit-first]
```

## Interpretasi {#해석}

- Rank adalah nilai 4bit pada descriptor, sehingga secara struktural hanya `0..15` yang dapat dinyatakan. Setiap dimension adalah uint32 big-endian yang tidak negatif. Urutan logisnya adalah C-contiguous row-major.
- Seperti aturan tensor logis ONNX, shape `[]` dengan rank 0 adalah scalar dengan 1 elemen, dan jika salah satu dimension bernilai 0, jumlah elemennya 0. Selain itu, jumlah elemen adalah hasil kali semua dimension.
- Packed-format menetapkan encoding elemen dan lebar bit, seperti int2/int4, FP4/FP6, dan varian FP8 tertentu.
- Jika sequence octet payload dinyatakan sebagai `p[0], p[1], ...` dan dipandang sebagai bilangan bulat little-bit-endian `P = Σ(p[j] << (8j))`, maka elemen logis `i` dengan lebar `w` adalah `(P >> (i × w)) & ((1 << w) - 1)`. Artinya, elemen pertama ditempatkan mulai dari bit terendah.
- Pada WORD, `p[0]` dimuat sebagai octet atas WORD pertama dan `p[1]` sebagai octet bawahnya, dan seterusnya. Tail bit atas yang tidak terpakai pada octet terakhir yang dipakai harus 0, dan jika jumlah octet payload ganjil, seluruh octet bawah yang tidak terpakai pada WORD terakhir harus `00`.

## Validitas {#유효성}

- Hasil kali dimension shape yang dihitung tanpa overflow dengan menerapkan lebar bit format yang didukung harus sama dengan jumlah elemen payload.
- Jika tail bit atas atau padding octet setelah bit payload yang diperlukan ada yang bernilai 1, nilai ditolak. Descriptor, shape, dan payload harus sepenuhnya berada di dalam Length record.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Makna logis shape, scalar rank 0, dan zero dimension mengikuti [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Aturan menempatkan elemen sub-byte mulai dari bit terendah mengikuti packing int2/int4 pada [ONNX TensorProto schema](https://github.com/onnx/onnx/blob/main/onnx/onnx.proto3) resmi dan packing little bit-endian pada [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Rank 4bit, dimension uint32, field version/packed-format, cara mengelompokkan octet menjadi WORD big-endian, dan TAG/Length GEUL merupakan descriptor khas GEUL. Ini bukan serialization wire atau memori dari ONNX, [Apache Arrow tensor](https://arrow.apache.org/docs/format/Other.html), maupun DLPack itu sendiri.

## Panjang {#길이}

- Totalnya adalah jumlah WORD dari TAG 1 WORD, TAG ekstensi Length (jika ada), Issuer 2 WORD, nomor Codec 2 WORD, dan Payload. Panjang 14 WORD atau kurang memakai panjang langsung, sedangkan 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan TAG ekstensi masuk dalam total ([Record dan TAG WORD](../../record.md)).
- Descriptor adalah 1 WORD, shape adalah `2 × rank` WORD, dan sisanya adalah packed payload.
- Jika jumlah elemen logis adalah `N` dan lebar elemen `w`, jumlah octet payload adalah `ceil(N × w / 8)`, dan jumlah WORD payload adalah `ceil(jumlah octet payload / 2)`.

## Contoh {#예시}

- Pada profil dengan rank 2, 4 WORD setelah descriptor adalah shape, dan bagian sesudahnya adalah sequence octet payload low-bit-first. Lebar elemen dan apakah diizinkan ditentukan oleh profil format yang telah ditetapkan.
- Sequence octet payload untuk elemen 4bit `[1, 2, 3]` adalah `21 03`, dan WORD payload-nya `2103`. Elemen pertama berada di nibble rendah octet pertama, dan nibble tinggi yang tidak terpakai pada octet terakhir adalah 0.

## Masalah terbuka {#열린-문제}

- Nilai registry version dan packed-format, serta cakupan profil yang akan didukung dari rank `0..15` yang dapat dinyatakan, belum ditetapkan.
