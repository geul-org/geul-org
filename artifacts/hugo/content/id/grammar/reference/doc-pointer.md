---
title: "DOC-POINTER"
weight: 8
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "DOC-POINTER adalah Reference penunjuk-deklarasi yang menunjuk satu versi dokumen yang diterbitkan Issuer. ID versi 0 adalah versi terbaru."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

DOC-POINTER adalah Reference penunjuk-deklarasi yang menunjuk satu versi dokumen yang diterbitkan Issuer. Ia menjadi target publikasi·deprecate·penghapusan dokumen, edisi kutipan, dan pernyataan tentang dokumen.

## Layout

```
TAG WORD          0000 0LLL L011 1QQQ      CCCC = 0111
[Length extension TAG]
Issuer            1/2/4/16 WORD
ID dokumen        4 WORD
ID versi          2 WORD
```

## Interpretasi dan validitas

- Lebar Issuer adalah sisa Payload setelah dikurangi ID dokumen dan ID versi (6 WORD). Codec tidak membagi lebar. Jika lebarnya bukan 1, 2, 4, atau 16 WORD, atau nilai Issuer muat pada lebar yang lebih sempit, record invalid (bentuk kanonik Issuer).
- ID versi tidak dihilangkan. Jika penghilangan diizinkan, lebar Issuer tidak dapat ditentukan hanya dari panjang Payload (Issuer 4 WORD tanpa versi dan Issuer 2 WORD dengan versi sama-sama 8 WORD).
- ID versi `0` adalah versi terbaru. Ia terikat pada versi yang berlaku saat interpretasi. Nilai lain terkunci pada versi itu ([PUBLICATION](/id/grammar/edge/publication/)).
- ID dokumen `0` adalah dokumen indeks definisi istilah Issuer. Issuer itu sendiri ditunjuk dengan [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/).
- Quantifier hanya `000` (Identified). Nilai lain invalid.
- Format untuk menunjuk dokumen Issuer hanya DOC-POINTER. Menunjuk dokumen dengan `EXTERNAL-ISSUER-*` (Issuer, ID dokumen, ID target `0`) atau `EXTERNAL-POINTER-*` (IMPORT ID, ID target `0`) adalah invalid.
- Tempat pemakaian: Meta [DOC-ID](/id/grammar/meta/declaration/doc-id/) dan [IMPORT-DOC](/id/grammar/meta/import/import-doc/), PUBLICATION·DEPRECATION·TOMBSTONE dan Subject BIND pada daftar versi, serta Subject BIND pada indeks nama `documents.geul`.

## Contoh

Dokumen `0xffff000000000001` milik Issuer GEUL `0x0000`.

| Versi | WORD sequence |
|---|---|
| 1 | `03B8 0000 ffff 0000 0000 0001 0000 0001` |
| Terbaru (`0`) | `03B8 0000 ffff 0000 0000 0001 0000 0000` |

- TAG 1 + Issuer 1 + ID dokumen 4 + ID versi 2 = 8 WORD, `LLLL=0111`. TAG adalah `0000 0 0111 0111 000` = `03B8`.

## Halaman terkait

- [Reference](/id/grammar/reference/), [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/), [EXTERNAL-ISSUER](/id/grammar/reference/external-issuer/), [PUBLICATION](/id/grammar/edge/publication/)
- [Issuer dan publikasi](/id/grammar/issuer/)
