---
title: "DENSE-BFLOAT16-VECTOR"
weight: 1008
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-BFLOAT16-VECTOR adalah Value vektor 1 dimensi yang memuat elemen BF16 secara berurutan tanpa descriptor (format Issuer ADHOC 0x0507)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-BFLOAT16-VECTOR menyimpan pola bit elemen bfloat16 16 bit secara berurutan tanpa descriptor. Ini format yang berbeda dari binary16.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0507`. Keluarga NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0507
Payload: [BF16 bits 1st: 1 WORD] ... [BF16 bits Nth: 1 WORD]
```

## Aturan interpretasi

- Jumlah elemen adalah jumlah WORD Payload. Pola bit termasuk payload NaN dan signed zero dipertahankan apa adanya.
- Tidak ada padding ABI di antara dan di akhir elemen.

## Validitas

- Payload harus 1 WORD atau lebih. Format tanpa descriptor ini tidak mengizinkan vektor kosong.
- Ukuran Payload harus kelipatan bilangan bulat dari lebar elemen 1 WORD.

## Dasar standar dan status format

- Dtype 16 bit tersendiri bernama bfloat16 dan pembedaannya dari binary16 disesuaikan dengan [ONNX IR dari tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) serta [DLPack `kDLBfloat`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Deretan bit-pattern 1 dimensi tanpa descriptor, serta TAG/Length GEUL dan penataan WORD big-endian 16 bit adalah format khas GEUL. DLPack mengasumsikan native-endian sehingga Payload ini bukan serialisasi wire DLPack, Arrow, atau ONNX.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga termasuk dalam jumlah total ([Length](/id/grammar/record/)).

## Contoh

- Payload `3f80 8000` adalah BF16 `1.0` dan `-0`, dan record total 5 WORD.
