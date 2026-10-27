---
title: "DENSE-BINARY64-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY64-VECTOR adalah Value vektor 1 dimensi yang memuat elemen binary64 secara berurutan tanpa descriptor (format Issuer ADHOC 0x0509)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY64-VECTOR menyimpan pola bit interchange IEEE 754 binary64 secara berurutan tanpa descriptor.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0509`. Keluarga NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0509
Payload: [binary64 bits 1st: 4 WORD] ... [binary64 bits Nth: 4 WORD]
```

## Aturan interpretasi

- 4 WORD berurutan adalah satu elemen dan dibaca mulai dari WORD atas. Pola bit termasuk payload NaN dan signed zero dipertahankan apa adanya.
- Jumlah elemen adalah 1/4 jumlah WORD Payload dan tidak ada padding ABI.

## Validitas

- Payload harus 4 WORD atau lebih dan kelipatan bilangan bulat 4 WORD. Format tanpa descriptor ini tidak mengizinkan vektor kosong.

## Dasar standar dan status format

- Interchange format elemen binary64 mengikuti [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Deretan 1 dimensi tanpa descriptor, serta TAG/Length GEUL dan penataan WORD big-endian 16 bit adalah format khas GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) mengasumsikan native-endian sehingga Payload ini bukan serialisasi wire DLPack, Arrow, atau ONNX.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga termasuk dalam jumlah total ([Length](/id/grammar/record/)).

## Contoh

- Payload `3ff0 0000 0000 0000` adalah binary64 `[1.0]`, dan record total 7 WORD.
