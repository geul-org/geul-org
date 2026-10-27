---
title: "DECLARE"
weight: 28
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "DECLARE adalah Edge pernyataan yang mendeklarasikan susunan Payload satu Codec (Codec 0x1B). Bersama FIELD·ENUM·CODEC, ia adalah kosakata untuk menulis dokumen spesifikasi Codec."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DECLARE adalah Edge pernyataan yang mendeklarasikan susunan Payload satu Codec. Codec `0x1B`.

Bersama [FIELD](/id/grammar/edge/field/) (`0x1C`), [ENUM](/id/grammar/edge/enum/) (`0x1D`), dan [CODEC](/id/grammar/edge/codec/) (`0x1E`), ia adalah kosakata untuk menulis spesifikasi Codec ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)). Layout keempat Edge ini ditanamkan di decoder. Setiap dokumen spesifikasi Codec yang ditulis dengan kosakata ini adalah dokumen biasa. Satu spesifikasi sekaligus melakukan validasi, penguraian, dan tampilan (viewer). Viewer tidak memiliki kode per Codec dan menggambar sesuai spesifikasi.

## Layout

```
TAG WORD          0001 0LLL L001 1011
[Length extension TAG]
Edge Id           record LOCAL Reference
Target            1 WORD. Dari TAG WORD Codec yang dideklarasikan, hanya posisi Kind·Codec yang dipakai (LLLL = 0)
[Issuer·nomor format]  jika target adalah format Issuer. Layout sama dengan Codec extension TAG
```

- Daftar field tidak ditaruh pada DECLARE. Setiap [FIELD](/id/grammar/edge/field/) menunjuk DECLARE-nya, dan urutan FIELD itu dalam dokumen adalah urutan field Payload.

## Aturan interpretasi

Aturan untuk membaca dan menotasikan record dengan spesifikasi Codec.

- Field nilai mentah dibaca sebanyak jumlah WORD tetap yang dideklarasikan FIELD. Satu field boleh berupa nilai mentah sisa (lebar `0xFFFF`), yang dibaca sebanyak WORD tersisa dikurangi lebar field tetap setelahnya. Setelah field sisa hanya ditaruh nilai mentah berlebar tetap.
- Field record dimulai dengan TAG WORD dan dibaca sebanyak Length TAG itu.
- Field nilai mentah adalah bilangan bulat tanpa tanda big-endian n WORD. Notasinya `0x` + hex sebanyak lebar×4 digit, dan jika ada ENUM dengan nilai yang sama, nama BIND-nya ditulis bersama.
- Arti field record ditetapkan oleh spesifikasi Codec record itu. Nilai yang memerlukan interpretasi seperti tanda·desimal·tanggal ditaruh sebagai record Value, bukan nilai mentah.

Tidak ada aturan batas lain. Codec dengan dua nilai mentah variabel atau lebih, dengan record atau field variabel setelah nilai mentah variabel, atau dengan lebar nilai mentah yang berubah menurut nilai field lain atau keadaan dokumen tidak dapat dideklarasikan dengan kosakata ini. Layout seperti itu dibungkus bagian variabelnya dalam record sehingga tersisa satu (contoh: penanda tangan SIGNATURE adalah record Reference).

## Validitas

- Kind target adalah salah satu dari Reference, Value, Edge, Meta. Codec Reference berada di posisi `CCCC` dan Quantifier dibiarkan 0.
- [Penanda slot](/id/grammar/reference/slot-marker/) (Codec Reference `0000`) tidak dapat menjadi target DECLARE. Ia ditanamkan di decoder (lapisan 0).
- Edge Id Edge tidak dideklarasikan dengan FIELD. Ia implisit karena elemen pertama setiap Edge ([Edge](/id/grammar/edge/)).
- Field DECLARE adalah FIELD yang menunjuknya, dan boleh 0. Satu FIELD hanya milik satu DECLARE. Field yang berbentuk sama pun diberi FIELD terpisah per DECLARE.
- DECLARE tidak berisi apa pun selain target (dan Issuer·nomor format untuk target format Issuer).
- Kursor setelah membaca field secara berurutan harus tepat sama dengan akhir record. Jika tersisa atau kurang, record itu melanggar spesifikasi.
- Target yang sama tidak dideklarasikan dua kali dalam satu dokumen.
- Varian yang field ekornya berbeda tidak dipakai sebagai cabang. Setiap Codec diberi DECLARE terpisah.

## Dokumen spesifikasi

- Dokumen spesifikasi kode langsung adalah dokumen biasa Issuer GEUL `0x0000`. ID dokumennya adalah TAG WORD target yang diperlebar ke 4 WORD (`0x1018` → `0x0000000000001018`), dan diterbitkan dengan cara yang sama seperti dokumen Issuer lain (ID versi, `versions.geul`) ([dokumen spesifikasi Codec](/id/grammar/codec-spec/)).
- Satu dokumen spesifikasi memiliki satu DECLARE, dan targetnya harus sama dengan TAG WORD pada ID dokumen. `DOC-ID` adalah DOC-POINTER (`0x0000`, ID dokumen itu, `0`).

## Nama

- Nama Codec diikat pada Edge Id DECLARE dengan [BIND](/id/grammar/edge/bind/) (contoh: `PUBLICATION`). Semua UTF8-TEXT yang ditempelkan pada DECLARE·FIELD·ENUM·CODEC memakai BIND, dan tidak ditempelkan dengan Edge lain seperti LABEL.
- Nama field dan nama enum juga diikat pada FIELD·ENUM dengan cara yang sama.

## Contoh

Dokumen spesifikasi PUBLICATION (Edge `0x18`) `geul.org/publication`: setelah Edge Id ada record DOC-POINTER, lalu hash isi 16 WORD.

```
119B 0088 0001 1018                 DECLARE #1  Edge 0x18                 (BIND "PUBLICATION")
129C 0088 0002 0088 0001 0000       FIELD #2    DECLARE #1, record         (BIND "doc")
129E 0088 0009 0088 0002 0038       CODEC #9    FIELD #2, DOC-POINTER
129C 0088 0004 0088 0001 0010       FIELD #4    DECLARE #1, nilai mentah 16 WORD   (BIND "hash")
```

- DECLARE: TAG 1 + Edge Id 2 + target 1 = 4 WORD, `LLLL = 0011`.
- FIELD: TAG 1 + Edge Id 2 + DECLARE 2 + lebar 1 = 6 WORD (`LLLL = 0101`). Kind·Codec yang diterima ditaruh terpisah dengan [CODEC](/id/grammar/edge/codec/) (`0038` = DOC-POINTER).
- Field opsional dideklarasikan dengan target CODEC `0000`. Pada posisi yang dihilangkan ditulis ABSENT (`0x0000`) ([CODEC](/id/grammar/edge/codec/) field opsional).
- Urutan field adalah urutan FIELD #2, #4 ditaruh di dokumen. Edge Id tidak harus berurutan (LOCAL AUTO INCREMENT adalah anjuran).

## Masalah terbuka

- Pengulangan. Susunan yang jumlahnya ditentukan nilai mentah di depannya, seperti "argumen × jumlah argumen" pada `CALL`. Saat ini tidak dapat dideklarasikan.
- Cara mendeklarasikan Codec yang memiliki sub-format (TAG per Codec) seperti WORLD.
- Cara menemukan dokumen spesifikasi format Issuer (Issuer·nomor format → alamat dokumen spesifikasi).
- Himpunan versi dokumen spesifikasi kode langsung mana yang dimaksud `SPEC-VERSION`.

## Halaman terkait

- [FIELD](/id/grammar/edge/field/), [ENUM](/id/grammar/edge/enum/), [CODEC](/id/grammar/edge/codec/), [BIND](/id/grammar/edge/bind/)
- [Edge](/id/grammar/edge/), [Dokumen spesifikasi Codec](/id/grammar/codec-spec/)
