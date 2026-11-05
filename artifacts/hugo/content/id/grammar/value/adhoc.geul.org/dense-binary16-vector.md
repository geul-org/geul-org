---
title: "DENSE-BINARY16-VECTOR"
weight: 1006
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR menyimpan pola bit interchange IEEE 754 binary16 secara berurutan tanpa descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR menyimpan pola bit interchange IEEE 754 binary16 secara berurutan tanpa descriptor.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000506`. Keluarga NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG ekstensi Length] jika total 15 WORD atau lebih
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Aturan interpretasi {#해석-규칙}

- Jumlah elemen adalah jumlah WORD Payload. Pola bit, termasuk payload NaN dan signed zero, dipertahankan apa adanya.
- Tidak ada ABI padding di antara elemen maupun di akhir.

## Validitas {#유효성}

- Payload harus 1 WORD atau lebih. Format ini tidak memiliki descriptor sehingga tidak mengizinkan vector kosong.
- Ukuran Payload harus kelipatan bulat dari lebar elemen, yaitu 1 WORD.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Format interchange elemen binary16 mengikuti [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Deret 1 dimensi tanpa descriptor, serta penempatan TAG/Length GEUL dan WORD big-endian 16 bit, merupakan format khas GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) mengasumsikan native-endian, sehingga Payload ini bukan wire serialization DLPack, Arrow, maupun ONNX.

## Panjang {#길이}

- Totalnya adalah jumlah WORD dari TAG 1 WORD, TAG ekstensi Length (jika ada), Issuer 2 WORD, nomor Codec 2 WORD, dan Payload. Panjang 14 WORD atau kurang memakai panjang langsung, sedangkan 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan TAG ekstensi juga dihitung dalam total ([Length](../../record.md)).

## Contoh {#예시}

- Payload `3C00 8000` adalah binary16 `1.0` dan `-0`, dan merupakan record 7 WORD secara keseluruhan.
