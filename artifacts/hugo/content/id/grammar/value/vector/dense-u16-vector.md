---
title: "DENSE-U16-VECTOR"
weight: 1002
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-U16-VECTOR adalah Value vektor 1 dimensi yang memuat elemen uint16 big-endian secara berurutan tanpa descriptor (format Issuer ADHOC 0x0501)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-U16-VECTOR adalah Value 1 dimensi homogen yang menyimpan elemen uint16 big-endian secara berurutan tanpa descriptor.

## Layout

- Kode: Value `ISSUER-1WORD` (`0x7C`), Issuer `0x0001` ADHOC, nomor format `0x0501`. Keluarga NUMERIC.

```
TAG WORD          0000 1LLL LCCC CCCC      Codec 0x7C
[Length extension TAG] jika total 15 WORD atau lebih
Issuer            1 WORD  0x0001 (ADHOC)
Nomor format      1 WORD  0x0501
Payload: [uint16 1st: 1 WORD] ... [uint16 Nth: 1 WORD]
```

## Aturan interpretasi

- Setiap WORD dibaca sebagai bilangan bulat unsigned 16 bit yang independen. Jumlah elemen adalah jumlah WORD Payload.
- Tidak ada padding ABI di antara dan di akhir elemen.

## Validitas

- Payload harus 1 WORD atau lebih. Format tanpa descriptor ini tidak mengizinkan vektor kosong.
- Ukuran Payload harus kelipatan bilangan bulat dari lebar elemen 1 WORD.

## Dasar standar dan status format

- Signedness dan lebar 16 bit dtype bilangan bulat unsigned disesuaikan dengan dtype industri pada [ONNX IR dari tensor element type](https://onnx.ai/onnx/repo-docs/IR.html) dan [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Deretan 1 dimensi tanpa descriptor, serta TAG/Length GEUL dan penataan WORD big-endian adalah format khas GEUL. DLPack mengasumsikan dtype native-endian sehingga Payload ini bukan serialisasi wire DLPack atau ONNX.

## Panjang

- Total adalah jumlah WORD TAG 1 WORD, Length extension TAG (jika ada), Issuer 1 WORD, nomor format 1 WORD, dan Payload. 14 WORD atau kurang memakai panjang langsung, dan 15 WORD atau lebih memakai panjang extension `1110`·`1111` dengan extension TAG juga termasuk dalam jumlah total ([Length](/id/grammar/record/)).

## Contoh

- Payload `0000 ffff` adalah elemen `[0, 65535]`, record total 5 WORD dengan panjang langsung `LLLL=0100`.
