---
title: "BIND"
weight: 4
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "edge"]
summary: "BIND adalah Edge pernyataan yang mengikat nama yang dicocokkan mesin (UTF8-TEXT tanpa bahasa) pada Subject (Codec 0x03)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

BIND adalah Edge pernyataan yang mengikat nama yang dicocokkan mesin pada Subject. Codec `0x03`.

Ini adalah penamaan. Nama yang dibaca manusia (judul per bahasa) ditangani [LABEL](/id/grammar/edge/label/). Nama simbol program dan nama untuk alamat dokumen ditulis dengan record yang sama.

## Layout

```
TAG WORD          0001 0LLL L000 0011
[Length extension TAG]
Edge Id           record LOCAL Reference
Subject           1 record Reference, atau 1 WORD TAG WORD codec
Nama              1 Value UTF8-TEXT-*
```

## Interpretasi dan validitas

- Subject adalah tepat satu record [Reference](/id/grammar/reference/) yang lengkap. Jika LOCAL, itu target dokumen ini (simbol, dan lain-lain); jika Reference penunjuk, itu target dokumen lain. Dokumen itu sendiri adalah [DOC-POINTER](/id/grammar/reference/doc-pointer/), dan Issuer itu sendiri adalah [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/).
- Atau Subject adalah satu TAG WORD codec (hanya Kind·Codec, `LLLL = 0`, tanpa Payload). Ini bukan record dengan Payload kosong, melainkan menunjuk kode langsung itu sendiri, yaitu dokumen spesifikasinya (dokumen Issuer GEUL `0x000000000000<TAG>`) ([dokumen spesifikasi Codec](/id/grammar/codec-spec/), [DECLARE](/id/grammar/edge/declare/)). Contoh: `1018` adalah PUBLICATION. Pada indeks nama dipakai Subject DOC-POINTER. Codec format Issuer tidak dipakai.
- Record lain (Value, dan lain-lain) tidak dapat menjadi Subject. FIELD pada dokumen spesifikasi BIND mendeklarasikan Subject hanya dengan lebar `0` (record), sehingga batasan ini adalah aturan isi BIND.
- Nama adalah tepat satu Value [UTF8-TEXT](/id/grammar/value/text/utf8-text/). Tanpa bahasa dan tidak dinormalisasi. Nama dianggap sama hanya jika byte-nya sama.
- Cakupan nama adalah dokumen yang memuat BIND. Dalam satu dokumen, nama yang sama tidak diikat pada Subject yang berbeda.
- Beberapa nama dapat diikat pada satu Subject (alias, nama lama). Jika dokumen tidak menetapkan lain, BIND terakhir adalah nama utama.
- Record lain menunjuk target dengan LOCAL ID, bukan nama. Nama dipakai untuk mencocokkan dengan pihak luar (fungsi host, input alamat, manusia).
- Karakter yang boleh dipakai pada nama ditentukan oleh penggunaannya. Nama untuk alamat dokumen mengikuti aturan nama dokumen (slug ASCII huruf kecil) ([alamat publikasi dan daftar versi](/id/grammar/publishing/#nama-dokumen)).

## Panjang

```
Total = 1 + N_len + N_id + N_subject + N_name WORD
```

## Contoh (non-normatif)

Simbol program: Edge Id `0003`, Subject LOCAL 7, nama `main`.

- Nama `main` adalah 4 byte (genap) sehingga `0940 6d61 696e` 3 WORD.
- Edge adalah TAG 1 + Edge Id 2 + Subject 2 + nama 3 = 8 WORD, TAG `1383`.

```
1383 0088 0003 0088 0007 0940 6d61 696e
```

Nama dokumen (di dalam dokumen daftar versi dokumen itu `0x0000/0xffff000000000002/versions.geul`): Edge Id `0005`, Subject `DOC-POINTER` (Issuer `0x0000`, dokumen `0xffff000000000002`, versi `0` = dokumen itu sendiri), nama `this-is-sample-doc`.

- Subject adalah TAG `03B8` + Issuer 1 + ID dokumen 4 + ID versi 2 = 8 WORD.
- Nama adalah 18 byte (genap) sehingga TAG `0CC0` + 9 WORD = 10 WORD.
- Edge adalah TAG 1 + Length extension 1 + Edge Id 2 + Subject 8 + nama 10 = 22 WORD sehingga `LLLL=1110`, TAG `1703`, extension `0016`.

```
1703 0016 0088 0005 03B8 0000 ffff 0000 0000 0002 0000 0000 0CC0 7468 6973 2d69 732d 7361 6d70 6c65 2d64 6f63
```

## Halaman terkait

- [Edge](/id/grammar/edge/), [LABEL](/id/grammar/edge/label/), [PUBLICATION](/id/grammar/edge/publication/) (nama dokumen pada dokumen daftar versi)
- [LOCAL](/id/grammar/reference/local/), [DOC-POINTER](/id/grammar/reference/doc-pointer/), [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/)
