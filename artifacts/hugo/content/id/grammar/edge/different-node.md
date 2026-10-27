---
title: "DIFFERENT-NODE"
weight: 3
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE adalah Edge pernyataan non-identitas bahwa dua Reference menunjuk target yang saling berbeda (Codec 0x02)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DIFFERENT-NODE adalah Edge pernyataan non-identitas bahwa dua Reference menunjuk referent yang saling berbeda. Codec `0x02`.

Ini tidak berarti encoding byte, Codec, atau ID kedua record Reference berbeda. Bedakan dari pengikatan berarah [REFERENCE-NODE](/id/grammar/edge/reference-node/) dan identitas [SAME-NODE](/id/grammar/edge/same-node/).

## Layout

```
TAG WORD          0001 0LLL L000 0010
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 record Reference
```

## Interpretasi dan validitas

- Subject dan Object masing-masing harus tepat satu record [Reference](/id/grammar/reference/) yang lengkap. Batasnya ditemukan dengan Length setiap record, dan jika berupa Value atau Edge, atau tidak lengkap, invalid.
- Subject dan Object menunjuk referent yang berbeda. Perbedaan referent tidak disimpulkan hanya dari perbedaan deretan byte, Codec, atau ID record Reference.
- Khususnya, [LOCAL](/id/grammar/reference/local/) ID yang berbeda hanyalah Reference yang berbeda, bukan berarti referent di dunia nyata juga berbeda. DIFFERENT tidak diturunkan hanya dari perbedaan LOCAL ID.
- Non-identitas bersifat simetris, irefleksif, dan tidak transitif. `DIFFERENT(A, B)` adalah relasi yang sama dengan `DIFFERENT(B, A)`. Tetapi `DIFFERENT(A, C)` tidak disimpulkan dari `DIFFERENT(A, B)` dan `DIFFERENT(B, C)`.
- Urutan Subject/Object pada wire hanyalah urutan serialisasi untuk framing dan tidak membuat arah makna. Implementasi harus dapat menelusuri dua arah.
- Kursor setelah membaca kedua komponen harus tepat sama dengan akhir Edge.

Walaupun relasinya sendiri irefleksif, klaim `DIFFERENT(A, A)` yang valid secara struktural atau klaim yang bertabrakan antara SAME dan DIFFERENT tidak boleh dihapus sebagai kesalahan tata bahasa wire. Klaim seperti itu mempertahankan konteks dan silsilahnya, dan ditangani sebagai kontradiksi pada lapisan putusan. Saat menginterpretasikan atau menurunkan DIFFERENT, pertahankan sumber, waktu, world, dan policy scope dokumen yang memuat Edge itu, dan jangan memperluasnya menjadi kesimpulan global yang mengabaikannya.

## Panjang

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Contoh (non-normatif)

Edge Id `000a`, Subject adalah LOCAL 1, Object adalah LOCAL 2.

- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. TAG adalah `0001 0 0110 0000010` = `1302`.

```
1302 0088 000a 0088 0001 0088 0002
```

Perbedaan LOCAL ID pada contoh ini hanya untuk memperlihatkan encoding. Sequence ini dijadikan DIFFERENT-NODE hanya jika ada klaim tersendiri bahwa ID 1 dan ID 2 menunjuk referent yang berbeda.

## Halaman terkait

- [Edge](/id/grammar/edge/), [REFERENCE-NODE](/id/grammar/edge/reference-node/), [SAME-NODE](/id/grammar/edge/same-node/)
- [Reference](/id/grammar/reference/), [LOCAL](/id/grammar/reference/local/)
