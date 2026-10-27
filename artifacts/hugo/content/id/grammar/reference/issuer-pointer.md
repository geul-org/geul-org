---
title: "ISSUER-POINTER"
weight: 7
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "ISSUER-POINTER adalah Reference penunjuk-deklarasi yang menunjuk Issuer itu sendiri. Payload-nya hanya satu Issuer."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

ISSUER-POINTER adalah Reference penunjuk-deklarasi yang menunjuk Issuer itu sendiri. Ia menjadi target `BIND` nama Issuer, `LABEL`, dan Edge putusan.

## Layout

```
TAG WORD          0000 0LLL L011 0QQQ      CCCC = 0110
[Length extension TAG]
Issuer            1/2/4/16 WORD
```

- Lebar Issuer adalah seluruh Payload. Codec tidak membagi lebar. Jika lebarnya bukan 1, 2, 4, atau 16 WORD, atau nilai Issuer muat pada lebar yang lebih sempit, record invalid (bentuk kanonik Issuer).
- Jika Issuer 16 WORD, totalnya 17 WORD sehingga 1 WORD Length extension ditambahkan.
- Quantifier hanya `000` (Identified). Nilai lain invalid.
- Nilai Issuer mengikuti alokasi pada [Issuer](/id/grammar/issuer/).
- Pemakaian: Subject BIND pada indeks nama Issuer `issuers.geul` ([alamat publikasi dan daftar versi](/id/grammar/publishing/#nama-issuer)), LABEL nama tampilan Issuer, putusan tentang Issuer, penanda tangan, dan posisi lain yang targetnya Issuer itu sendiri.
- Format untuk menunjuk Issuer itu sendiri hanya ISSUER-POINTER. Menunjuk Issuer dengan `EXTERNAL-ISSUER-*` memakai ID dokumen `0` dan ID target `0` adalah invalid.

## Contoh

| Issuer | WORD sequence |
|---|---|
| GEUL `0x0000` | `00B0 0000` |
| IEEE `0x0040` | `00B0 0040` |

## Halaman terkait

- [Reference](/id/grammar/reference/), [DOC-POINTER](/id/grammar/reference/doc-pointer/), [EXTERNAL-ISSUER](/id/grammar/reference/external-issuer/), [Issuer dan publikasi](/id/grammar/issuer/)
