---
title: "DIFFERENT-NODE (0x0A2L)"
weight: 162
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-11-05T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DIFFERENT-NODE adalah Edge pernyataan non-identitas yang menyatakan bahwa dua Reference menunjuk referent yang berbeda."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

| Butir | Nilai |
|---|---|
| Nama | `DIFFERENT-NODE` (BIND dokumen spesifikasi `DIFFERENT-NODE`) |
| TAG ID | `0x0A2L` |
| Codec ID | `0x00000A20` |
| Dokumen spesifikasi | `0x00000000/codecs/0x00000A20/` (target DECLARE `0A20`) |
| Bagian | 5 `0101` (Edge pernyataan), offset dalam bagian C = 2 |
| Kind | Edge · keluarga: pernyataan, kelompok: penunjukan dan nama |
| TAG WORD | `0000 1010 0010 LLLL` (`000K KKKC CCCC LLLL`) |
| Deskripsi indeks | Non-identitas: dua Reference menunjuk objek yang berbeda |
| Sisi Hugo | `edge/different-node.md` |

## Bidang (dokumen spesifikasi) {#필드-규격-문서}

Urutan FIELD dalam dokumen adalah urutan bidang Payload ([dokumen spesifikasi Codec](../codec-spec.md)). Edge Id milik Edge tidak dideklarasikan sebagai FIELD.

| Urutan | Bidang (BIND) | FIELD | Lebar | Bentuk yang diterima (CODEC) | ENUM |
|---|---|---|---|---|---|
| 1 | `subject` | #2 | record | record apa saja (kecuali penanda slot) |  |
| 2 | `object` | #3 | record | record apa saja (kecuali penanda slot) |  |

DIFFERENT-NODE adalah Edge pernyataan non-identitas yang menyatakan bahwa dua Reference menunjuk referent yang berbeda. Codec `0x0A2L`.

Ini tidak berarti encoding byte, Codec, atau ID kedua record Reference berbeda. Bedakan dari binding berarah [REFERENCE-NODE](0x0A0L-reference-node.md) dan identitas [SAME-NODE](0x0A1L-same-node.md).

## Layout {#레이아웃}

```
TAG WORD          0000 1010 0010 LLLL
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            1 record Reference
```

## Interpretasi dan validitas {#해석과-유효성}

- Subject dan Object masing-masing harus tepat satu record [Reference](../reference/_index.md) yang lengkap. Batasnya ditemukan dengan Length tiap record; jika berupa Value atau Edge, atau tidak lengkap, maka invalid.
- Subject dan Object menunjuk referent yang berbeda. Perbedaan deret byte, Codec, atau ID record Reference saja tidak dipakai untuk menyimpulkan bahwa referent-nya berbeda.
- Khususnya, [LOCAL](../reference/0x005L-local.md) ID yang berbeda hanyalah Reference yang berbeda, bukan berarti referent di dunia nyata juga berbeda. DIFFERENT tidak diturunkan hanya dari perbedaan LOCAL ID.
- Non-identitas bersifat simetris, irefleksif, dan tidak transitif. `DIFFERENT(A, B)` adalah relasi yang sama dengan `DIFFERENT(B, A)`. Namun `DIFFERENT(A, C)` tidak disimpulkan dari `DIFFERENT(A, B)` dan `DIFFERENT(B, C)`.
- Urutan Subject/Object pada wire hanyalah urutan serialisasi untuk framing dan tidak menciptakan arah makna. Implementasi harus dapat menelusuri ke kedua arah.
- Kursor setelah membaca kedua komponen harus tepat sama dengan akhir Edge.

Relasinya sendiri irefleksif, tetapi klaim `DIFFERENT(A, A)` yang valid secara struktur atau klaim yang membuat SAME dan DIFFERENT bertabrakan tidak boleh dihapus sebagai kesalahan tata bahasa wire. Klaim semacam ini mempertahankan konteks dan silsilahnya, dan ditangani sebagai kontradiksi di lapisan penilaian. Saat menafsirkan atau menurunkan DIFFERENT, asal-usul, waktu, world, dan policy scope dokumen yang memuat Edge itu dipertahankan, dan kesimpulan tidak diperluas menjadi kesimpulan global yang mengabaikannya.

## Panjang {#길이}

```
total = 1 + N_len + N_id + N_subject + N_object WORD
```

## Contoh (non-normatif) {#예시-비규범}

Edge Id `000A`, Subject adalah LOCAL 1, Object adalah LOCAL 2.

- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 2 = 7 WORD, `LLLL=0110`. TAG-nya `0000 1010 0010 0110` = `0A26`.

```
0A26 0051 000A 0051 0001 0051 0002
```

Perbedaan LOCAL ID pada contoh ini hanya untuk memperlihatkan encoding. Sequence ini dijadikan DIFFERENT-NODE hanya jika ada klaim tersendiri bahwa ID 1 dan ID 2 menunjuk referent yang berbeda.

## Halaman terkait {#관련-페이지}

- [Edge](_index.md), [REFERENCE-NODE](0x0A0L-reference-node.md), [SAME-NODE](0x0A1L-same-node.md)
- [Reference](../reference/_index.md), [LOCAL](../reference/0x005L-local.md)

## Teks asli dokumen spesifikasi {#규격-문서-원문}

Tampilan dokumen spesifikasi `0x00000000/codecs/0x00000A20/latest.geul` yang dibaca dengan `geul show` (heksadesimal huruf besar).

```
SPEC-VERSION 0x0001
DOC-ID 0x04260000000000000A2000000000
BODY
#1 DECLARE 0x0A20
#2 FIELD #1 record
#3 FIELD #1 record
#4 BIND #1 "DIFFERENT-NODE"
#5 BIND #2 "subject"
#6 BIND #3 "object"
```
