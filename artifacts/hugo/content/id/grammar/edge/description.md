---
title: "DESCRIPTION"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-29T23:00:00+09:00
tags: ["grammar", "edge"]
summary: "DESCRIPTION adalah Edge pernyataan yang menghubungkan satu deskripsi singkat per bahasa untuk target Subject (Codec 0x06). Layout sama dengan LABEL."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DESCRIPTION adalah Edge pernyataan yang menghubungkan satu deskripsi bahasa tertentu untuk target Subject sebagai Object. Codec `0x06`.

Deskripsi adalah frasa singkat yang membedakan target (description Wikidata, contoh: "ibu kota dan kota terbesar Jerman"). Ini bukan definisi atau klaim tentang target. Proposisi tentang target ditulis dengan [TRIPLE](/id/grammar/edge/triple/). Layoutnya sama dengan [LABEL](/id/grammar/edge/label/). Deskripsi dan bahasanya dimuat dalam satu Object, [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/). Tidak ada field nilai mentah.

## Layout

```
TAG WORD          0001 0LLL L000 0110
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            Value UTF8-LANGUAGE-TEXT atau 1 record LOCAL Reference
```

## Interpretasi dan validitas

- Aturan Subject dan Object sama dengan [LABEL](/id/grammar/edge/label/). Subject adalah tepat satu record Reference yang lengkap. Object adalah tepat satu record UTF8-LANGUAGE-TEXT (`0x4A`·`0x4B`) yang lengkap, atau LOCAL Reference yang menjadi UTF8-LANGUAGE-TEXT melalui pengikatan [REFERENCE-NODE](/id/grammar/edge/reference-node/) dalam dokumen yang sama.
- Teks tanpa bahasa (UTF8-TEXT) tidak dapat menjadi DESCRIPTION. Deskripsi satu per bahasa sehingga aturannya hanya berdiri jika ada bahasa. Deskripsi yang sama untuk beberapa bahasa ditulis dengan bahasa `mul`.
- DESCRIPTION dengan Subject dan bahasa yang sama paling banyak satu.
- Deskripsi dipakai untuk membedakan dari target lain yang bernama sama. Sebaiknya pasangan LABEL dan DESCRIPTION pada bahasa yang sama tidak tumpang tindih pada dua target, tetapi spesifikasi tidak memeriksanya (Wikidata pun hanya menganjurkan dan tidak memaksa).
- Dokumen spesifikasi geul.org membatasi Object dengan [CODEC](/id/grammar/edge/codec/) (`084A`·`084B`·`0008`, sama dengan LABEL).

## Panjang

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

- Record bahasa dan jumlah byte teks pada Object ditangani record Object. Kursor setelah membaca record terakhir harus tepat sama dengan akhir Edge.
- Deskripsi lebih panjang dari label sehingga Object dan Edge mudah melebihi 15 WORD. Dalam hal itu pakai Length extension ([Record](/id/grammar/record/)).

## Contoh (non-normatif)

Edge Id `0009`, Subject Q64 (`00A0 0040`), Object `capital and largest city of Germany` (en). Bahasa ini contoh format LANGUAGE-BCP47-CODE (`en` punya nomor registri `0x0784` sehingga dapat juga ditulis sebagai SHORT-CODE).

- Object adalah record bahasa `08C6 656E` (BCP47 `en`, 2 WORD) + teks 35 byte (ganjil, 18 WORD) sehingga `0x4B`, TAG 1 + extension TAG 1 + 20 = 22 WORD, `0F4B 0016 …`.
- Edge adalah TAG 1 + extension TAG 1 + Edge Id 2 + Subject 2 + Object 22 = 28 WORD sehingga `LLLL=1110`, TAG `1706`, extension TAG `001C`.

```
1706 001C 0088 0009 00A0 0040
0F4B 0016 08C6 656E 6361 7069 7461 6C20 616E 6420 6C61 7267 6573 7420 6369 7479 206F 6620 4765 726D 616E 7900
```

## Padanan Wikidata

- `descriptions` item (satu per bahasa) → satu DESCRIPTION per bahasa. Kode bahasa dipindahkan dengan tabel padanan kode bahasa yang sama seperti LABEL.

## Masalah terbuka

- Apakah ada kasus yang mengizinkan deskripsi UTF8-TEXT tanpa bahasa (saat ini tidak diizinkan).

## Halaman terkait

- [Edge](/id/grammar/edge/), [LABEL](/id/grammar/edge/label/), [ALIAS](/id/grammar/edge/alias/), [CODEC](/id/grammar/edge/codec/)
- [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/), [LOCAL](/id/grammar/reference/local/), [REFERENCE-NODE](/id/grammar/edge/reference-node/)
