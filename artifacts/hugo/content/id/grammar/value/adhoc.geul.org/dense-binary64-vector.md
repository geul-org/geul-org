---
title: "DENSE-BINARY64-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR menyimpan pola bit interchange IEEE 754 binary64 secara berurutan tanpa descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR menyimpan pola bit interchange IEEE 754 binary64 secara berurutan tanpa descriptor.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000509`. Keluarga NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG ekstensi Length] jika total 15 WORD atau lebih
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## Aturan interpretasi {#해석-규칙}

- 4 WORD berurutan membentuk satu elemen dan dibaca mulai dari WORD teratas. Pola bit, termasuk payload NaN dan signed zero, dipertahankan apa adanya.
- Jumlah elemen adalah 1/4 jumlah WORD Payload, dan tidak ada ABI padding.

## Validitas {#유효성}

- Payload harus 4 WORD atau lebih dan kelipatan bulat dari 4 WORD. Format ini tidak memiliki descriptor sehingga tidak mengizinkan vector kosong.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Format interchange elemen binary64 mengikuti [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Deret 1 dimensi tanpa descriptor, serta penempatan TAG/Length GEUL dan WORD big-endian 16 bit, merupakan format khas GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) mengasumsikan native-endian, sehingga Payload ini bukan wire serialization DLPack, Arrow, maupun ONNX.

## Panjang {#길이}

- Totalnya adalah jumlah WORD dari TAG 1 WORD, TAG ekstensi Length (jika ada), Issuer 2 WORD, nomor Codec 2 WORD, dan Payload. Panjang 14 WORD atau kurang memakai panjang langsung, sedangkan 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan TAG ekstensi juga dihitung dalam total ([Length](../../record.md)).

## Contoh {#예시}

- Payload `3FF0 0000 0000 0000` adalah binary64 `[1.0]`, dan merupakan record 9 WORD secara keseluruhan.
