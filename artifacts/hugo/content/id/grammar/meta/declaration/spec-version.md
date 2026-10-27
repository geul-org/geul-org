---
title: "SPEC-VERSION"
weight: 17
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "SPEC-VERSION adalah Meta definisi yang menyatakan edisi spesifikasi GEUL yang diikuti dokumen dengan satu bilangan bulat. GEUL v1 adalah 0x0001."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Menyatakan edisi spesifikasi GEUL yang diikuti dokumen. Nilai ini menentukan cara membaca record lainnya.

## Layout

```
TAG WORD          0001 1LLL L001 0000      Codec 0x10
[Length extension TAG]
Payload           edisi spesifikasi. v1 = 0x0001
```

- Codec: Meta `0x10`, kelas definisi (`001`)
- Payload: nilai mentah (bilangan unsigned dengan lebar terpendek)
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Tidak bergantung pada kode Value. Hanya bilangan bulat tanpa Value tersemat, agar dapat dibaca decoder edisi mana pun.
- Jika edisinya tidak dikenal, decoder menolak atau memberi peringatan.
- Jika tidak ada, dibaca dengan edisi yang dikenal decoder. Dokumen terbitan menulisnya.

## Contoh

- `0x1890 0x0001`: GEUL v1

## Masalah terbuka

- Korespondensi dengan versi dokumen codebook ([dokumen spesifikasi](/id/grammar/codec-spec/)).
