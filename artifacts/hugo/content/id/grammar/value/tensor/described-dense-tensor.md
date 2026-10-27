---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1001
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR adalah format Issuer ADHOC yang memuat elemen C-contiguous row-major setelah descriptor element format·rank·shape."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR adalah Value tensor yang menulis shape dan element format pada descriptor Payload lalu menyimpan payload C-contiguous row-major. Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0600`, keluarga NUMERIC.

## Layout

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Payload sisanya   [dense payload]
```

## Interpretasi

- rank adalah nilai 4 bit pada descriptor sehingga secara struktural hanya dapat menyatakan `0..15`. Setiap dimension adalah uint32 big-endian non-negatif.
- Seperti aturan tensor logis ONNX, shape `[]` pada rank 0 adalah scalar dengan 1 elemen, dan jika salah satu dimension 0 maka jumlah elemen 0. Selain itu jumlah elemen adalah hasil kali semua dimension.
- payload dibaca dengan element format descriptor dan berurutan C-contiguous row-major. Jumlah elemen logis yang dihitung harus sama dengan jumlah elemen payload setelah descriptor.

## Validitas

- Setelah version dan element format yang didukung ditetapkan, batas payload dipulihkan dengan lebar elemen itu, dan diverifikasi kesesuaiannya dengan hasil kali shape yang dihitung tanpa overflow.
- Descriptor, semua dimension, dan payload harus masuk seluruhnya dalam Length record, dan tidak ada padding ABI sembarang.

## Dasar standar dan status format

- Aturan bahwa shape adalah daftar dimension non-negatif dan jumlah nilai sama dengan hasil kali dimension, serta makna rank 0 scalar dan zero dimension, mengikuti [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Urutan logis C-contiguous row-major disesuaikan dengan urutan [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- rank 4 bit, dimension uint32, field version/element-format, TAG/Length GEUL, dan payload WORD big-endian adalah descriptor khas GEUL. Bukan serialisasi wire·memori [format IPC tensor Arrow](https://arrow.apache.org/docs/format/Other.html), ONNX TensorProto, atau [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga masuk ke jumlah total ([Record dan TAG WORD](/id/grammar/record/)).
- descriptor adalah 1 WORD, shape adalah `2 × rank` WORD, dan sisanya adalah payload.

## Contoh

- Pada profil dengan rank 2, 4 WORD setelah descriptor adalah dua dimension uint32, dan seluruh sisanya adalah payload row-major. Untuk menentukan apakah benar diizinkan dan memverifikasi jumlah elemen diperlukan profil version·format yang sudah ditetapkan.

## Masalah terbuka

- Nilai registri version dan element-format, serta rentang profil yang didukung dari rank `0..15` yang dapat dinyatakan, belum ditetapkan.
