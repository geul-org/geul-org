---
title: "LABEL"
weight: 5
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "LABEL adalah Edge pernyataan yang menghubungkan satu nama per bahasa target Subject dengan Object UTF8-LANGUAGE-TEXT (Codec 0x04)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

LABEL adalah Edge pernyataan yang menghubungkan satu nama (label) bahasa tertentu untuk target Subject sebagai Object. Codec `0x04`. Ini bukan Edge yang menyatakan lemma dalam leksikologi umum.

Nama dan bahasanya dimuat dalam satu Object, [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/). Tidak ada field nilai mentah.

## Layout

```
TAG WORD          0001 0LLL L000 0100
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference
Object            Value UTF8-LANGUAGE-TEXT atau 1 record LOCAL Reference
```

## Interpretasi dan validitas

- Subject adalah tepat satu record Reference yang lengkap. Batasnya ditemukan dengan Length Subject itu sendiri, dan jika bukan Reference atau tidak lengkap, invalid.
- Object adalah tepat satu record [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/) (`0x4A`·`0x4B`) yang lengkap. Aturan bahasa dan teks (kedua format bahasa diizinkan, perbandingan bahasa yang sama) mengikuti format itu.
- Object juga dapat berupa LOCAL Reference. Dalam hal itu ia harus menjadi UTF8-LANGUAGE-TEXT melalui pengikatan [REFERENCE-NODE](/id/grammar/edge/reference-node/) dalam dokumen yang sama. Jika tidak terselesaikan atau terselesaikan ke target jenis lain, invalid.
- Dokumen spesifikasi geul.org menulis batasan ini dengan [CODEC](/id/grammar/edge/codec/) (Object = `084A`·`084B`·`0008`). Target penyelesaian LOCAL tidak dinyatakan dengan CODEC.
- Jika Object bukan salah satu dari dua format di atas atau recordnya tidak lengkap, invalid. Teks tanpa bahasa (UTF8-TEXT) tidak dapat menjadi LABEL. Nama untuk mesin tanpa bahasa ditulis dengan [BIND](/id/grammar/edge/bind/). Nama yang sama untuk beberapa bahasa ditulis dengan bahasa `mul`.
- LABEL dengan Subject dan bahasa yang sama paling banyak satu. Nama lain ditulis dengan [ALIAS](/id/grammar/edge/alias/).

## Panjang

```
Total = 1 + N_len + N_id + N_subject + N_object WORD
```

- Record bahasa dan jumlah byte teks pada Object ditangani record Object, bukan Edge. Kursor setelah membaca semua record terakhir harus tepat sama dengan akhir Edge.

## Contoh (non-normatif)

Kode bahasa `0784` untuk `en` adalah nomor dari draf GEUL Language Registry (draft-0). Registri belum disegel sehingga ini adalah nilai non-normatif, bukan kode final.

### LANGUAGE-SHORT-CODE

Edge Id `0007`, Subject Q22686 (`00A0 589e`), Object `Donald Trump` (en).

- Object adalah record bahasa `08C8 0784` (SHORT-CODE 2 WORD) + teks 12 byte (genap, 6 WORD) sehingga `UTF8-LANGUAGE-TEXT-EVEN` (`0x4A`), total 9 WORD `0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70`.
- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 9 = 14 WORD, `LLLL=1101`. TAG adalah `1684`.

```
1684 0088 0007 00A0 589e 0C4A 08C8 0784 446f 6e61 6c64 2054 7275 6d70
```

### LANGUAGE-BCP47-CODE

Edge Id `0008`, Subject Q155 (`00A0 009b`), Object `Brasil` (pt-BR).

- Object adalah record bahasa `09C7 7074 2d42 5200` (BCP47 `pt-BR`, 4 WORD) + teks 6 byte (genap, 3 WORD) sehingga total 8 WORD `0BCA 09C7 7074 2d42 5200 4272 6173 696c`.
- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + Object 8 = 13 WORD, `LLLL=1100`. TAG adalah `1604`.

```
1604 0088 0008 00A0 009b 0BCA 09C7 7074 2d42 5200 4272 6173 696c
```

## Halaman terkait

- [Edge](/id/grammar/edge/), [ALIAS](/id/grammar/edge/alias/), [DESCRIPTION](/id/grammar/edge/description/), [BIND](/id/grammar/edge/bind/)
- [UTF8-LANGUAGE-TEXT](/id/grammar/value/text/utf8-language-text/), [LANGUAGE-SHORT-CODE](/id/grammar/value/text/language-short-code/), [LANGUAGE-BCP47-CODE](/id/grammar/value/text/language-bcp47-code/)
- [LOCAL](/id/grammar/reference/local/), [REFERENCE-NODE](/id/grammar/edge/reference-node/)
