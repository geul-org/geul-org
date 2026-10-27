---
title: "DENSE-BINARY16-VECTOR"
weight: 1007
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BINARY16-VECTOR adalah Value vektor 1 dimensi yang memuat elemen binary16 secara berurutan tanpa descriptor (format Issuer ADHOC 0x0506)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BINARY16-VECTOR menyimpan pola bit interchange IEEE 754 binary16 secara berurutan tanpa descriptor.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0506`. Keluarga NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0506
Payload: [binary16 bits 1st: 1 WORD] ... [binary16 bits Nth: 1 WORD]
```

## Aturan interpretasi

- Jumlah elemen adalah jumlah WORD Payload. Pola bit termasuk payload NaN dan signed zero dipertahankan apa adanya.
- Tidak ada padding ABI di antara dan di akhir elemen.

## Validitas

- Payload harus 1 WORD atau lebih. Format tanpa descriptor ini tidak mengizinkan vektor kosong.
- Ukuran Payload harus kelipatan bilangan bulat dari lebar elemen 1 WORD.

## Dasar standar dan status format

- Interchange format elemen binary16 mengikuti [IEEE 754, Standard for Floating-Point Arithmetic](https://standards.ieee.org/ieee/754/6210/).
- Deretan 1 dimensi tanpa descriptor, serta TAG/Length GEUL dan penataan WORD big-endian 16 bit adalah format khas GEUL. [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html) mengasumsikan native-endian sehingga Payload ini bukan serialisasi wire DLPack, Arrow, atau ONNX.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga termasuk dalam jumlah total ([Length](/id/grammar/record/)).

## Contoh

- Payload `3c00 8000` adalah binary16 `1.0` dan `-0`, dan record total 5 WORD.
