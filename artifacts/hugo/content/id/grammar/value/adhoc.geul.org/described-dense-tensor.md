---
title: "DESCRIBED-DENSE-TENSOR"
weight: 1015
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "tensor"]
summary: "DESCRIBED-DENSE-TENSOR adalah Value tensor yang mencatat shape dan element format pada descriptor Payload, lalu menyimpan payload C-contiguous row-major."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIBED-DENSE-TENSOR adalah Value tensor yang mencatat shape dan element format pada descriptor Payload, lalu menyimpan payload C-contiguous row-major. Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000600`, keluarga NUMERIC.

## Layout {#레이아웃}

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG ekstensi Length] jika total 15 WORD atau lebih
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000600
Payload WORD 1st  [version: 4bit][element-format: 8bit][rank: 4bit]
Payload next      [dimension 1: uint32, 2 WORD] ... [dimension rank: uint32, 2 WORD]
Sisa Payload      [dense payload]
```

## Interpretasi {#해석}

- Rank adalah nilai 4bit pada descriptor, sehingga secara struktural hanya `0..15` yang dapat dinyatakan. Setiap dimension adalah uint32 big-endian yang tidak negatif.
- Seperti aturan tensor logis ONNX, shape `[]` dengan rank 0 adalah scalar dengan 1 elemen, dan jika salah satu dimension bernilai 0, jumlah elemennya 0. Selain itu, jumlah elemen adalah hasil kali semua dimension.
- Payload dibaca dengan element format pada descriptor dan berurutan C-contiguous row-major. Jumlah elemen logis hasil perhitungan harus sama dengan jumlah elemen payload setelah descriptor.

## Validitas {#유효성}

- Setelah version dan element format yang didukung ditetapkan, batas payload dipulihkan dengan lebar elemennya, lalu dicocokkan dengan hasil kali shape yang dihitung tanpa overflow.
- Descriptor, seluruh dimension, dan payload harus sepenuhnya berada di dalam Length record, dan tidak ada ABI padding sembarang.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Aturan bahwa shape adalah daftar dimension tidak negatif dan jumlah nilai sama dengan hasil kali dimension, serta makna scalar rank 0 dan zero dimension, mengikuti [ONNX IR Tensor Definition](https://onnx.ai/onnx/repo-docs/IR.html). Urutan logis C-contiguous row-major disesuaikan dengan urutan pada [Apache Arrow canonical fixed-shape tensor extension](https://arrow.apache.org/docs/format/CanonicalExtensions.html).
- Rank 4bit, dimension uint32, field version/element-format, TAG/Length GEUL, dan payload WORD big-endian merupakan descriptor khas GEUL. Ini bukan serialization wire atau memori dari [Arrow tensor IPC format](https://arrow.apache.org/docs/format/Other.html), ONNX TensorProto, maupun [DLPack C API](https://dmlc.github.io/dlpack/latest/c_api.html).

## Panjang {#길이}

- Totalnya adalah jumlah WORD dari TAG 1 WORD, TAG ekstensi Length (jika ada), Issuer 2 WORD, nomor Codec 2 WORD, dan Payload. Panjang 14 WORD atau kurang memakai panjang langsung, sedangkan 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan TAG ekstensi masuk dalam total ([Record dan TAG WORD](../../record.md)).
- Descriptor adalah 1 WORD, shape adalah `2 × rank` WORD, dan sisanya adalah payload.

## Contoh {#예시}

- Pada profil dengan rank 2, 4 WORD setelah descriptor adalah dua dimension uint32, dan seluruh bagian sesudahnya adalah payload row-major. Untuk memastikan apakah diizinkan dan memverifikasi jumlah elemen, diperlukan profil version dan format yang telah ditetapkan.

## Masalah terbuka {#열린-문제}

- Nilai registry version dan element-format, serta cakupan profil yang akan didukung dari rank `0..15` yang dapat dinyatakan, belum ditetapkan.
