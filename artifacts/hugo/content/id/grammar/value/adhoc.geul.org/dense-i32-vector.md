---
title: "DENSE-I32-VECTOR"
weight: 1010
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "value", "vector"]
summary: "DENSE-I32-VECTOR adalah Value 1 dimensi homogen yang menyimpan elemen int32 big-endian secara berurutan tanpa descriptor."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DENSE-I32-VECTOR adalah Value 1 dimensi homogen yang menyimpan elemen int32 big-endian secara berurutan tanpa descriptor.

## Layout {#레이아웃}

- Kode: Value `VALUE-ISSUER-2WORD`(`0x09DL`), Issuer `0x00000002` ADHOC, nomor Codec `0x00000502`. Keluarga NUMERIC.

```
TAG WORD          0000 1001 1101 LLLL      Codec 0x09DL
[TAG ekstensi Length] jika total 15 WORD atau lebih
Issuer            2 WORD  0x00000002 (ADHOC)
Nomor Codec       2 WORD  0x00000502
Payload: [int32 1st: 2 WORD] ... [int32 Nth: 2 WORD]
```

## Aturan interpretasi {#해석-규칙}

- 2 WORD berurutan digabung mulai dari WORD teratas dan dibaca sebagai bilangan bulat 32 bit komplemen dua.
- Jumlah elemen adalah 1/2 jumlah WORD Payload, dan tidak ada ABI padding.

## Validitas {#유효성}

- Payload harus 2 WORD atau lebih dan kelipatan bulat dari 2 WORD. Format ini tidak memiliki descriptor sehingga tidak mengizinkan vector kosong.

## Dasar standar dan status format {#표준-근거와-형식-지위}

- Signedness dtype signed integer dan lebar 32 bit disesuaikan dengan [tensor element type pada ONNX IR](https://onnx.ai/onnx/repo-docs/IR.html) serta dtype industri [DLPack `DLDataType`](https://dmlc.github.io/dlpack/latest/c_api.html).
- Interpretasi komplemen dua, deret 1 dimensi tanpa descriptor, serta penempatan TAG/Length GEUL dan WORD big-endian merupakan format khas GEUL. DLPack mengasumsikan dtype native-endian, sehingga Payload ini bukan wire serialization DLPack maupun ONNX.

## Panjang {#길이}

- Totalnya adalah jumlah WORD dari TAG 1 WORD, TAG ekstensi Length (jika ada), Issuer 2 WORD, nomor Codec 2 WORD, dan Payload. Panjang 14 WORD atau kurang memakai panjang langsung, sedangkan 15 WORD atau lebih memakai panjang ekstensi `1110`·`1111`, dan TAG ekstensi juga dihitung dalam total ([Length](../../record.md)).

## Contoh {#예시}

- Payload `FFFF FFFF 0000 0002` adalah elemen `[-1, 2]`, dan merupakan record 9 WORD secara keseluruhan.
