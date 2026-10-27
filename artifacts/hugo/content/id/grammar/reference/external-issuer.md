---
title: "EXTERNAL-ISSUER"
weight: 13
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "reference"]
summary: "EXTERNAL-ISSUER adalah Reference penunjuk-deklarasi yang mengutip LOCAL ID dalam dokumen terbitan Issuer dengan satu record, tanpa IMPORT."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

EXTERNAL-ISSUER adalah Reference penunjuk-deklarasi yang mengutip LOCAL ID dalam dokumen terbitan Issuer tanpa IMPORT. Maknanya lengkap dalam satu record dan mengikuti versi terbaru.

## Layout

```
TAG WORD          0000 0LLL L11W WQQQ      CCCC = 11WW
[Length extension TAG]
Issuer            lebar yang ditetapkan WW (00=1, 01=2, 10=4, 11=16 WORD)
ID dokumen        4 WORD
ID target         seluruh sisanya. LOCAL ID dokumen itu, lebar terpendek
```

| CCCC | Nama | Lebar Issuer |
|---|---|---|
| `1100` | EXTERNAL-ISSUER-1WORD | 1 WORD (dialokasikan geul.org) |
| `1101` | EXTERNAL-ISSUER-2WORD | 2 WORD (didaftarkan di geul.org, bukti domain) |
| `1110` | EXTERNAL-ISSUER-4WORD | 4 WORD (didaftarkan di geul.org, tanpa bukti) |
| `1111` | EXTERNAL-ISSUER-16WORD | 16 WORD (dihitung dari kunci publik) |

- Issuer ID adalah nilai bilangan bulat. Jika nilainya sama, Issuer-nya sama. Issuer ditulis dengan lebar terpendek tempat nilainya muat, dan Codec dipilih sesuai lebar itu (2 WORD hanya jika nilai melebihi `0xFFFF`, 4 WORD hanya jika `2^32` atau lebih, 16 WORD hanya jika `2^64` atau lebih). Penulisan dengan lebar lebih lebar adalah invalid ([Issuer](/id/grammar/issuer/)).
- Pendaftaran dan pengelolaan Issuer ditangani geul.org.
- Versi tidak ditulis dan mengikuti versi terbaru. Untuk mengunci versi, pakai [IMPORT-DOC](/id/grammar/meta/import/import-doc/) dan [EXTERNAL-POINTER](/id/grammar/reference/external-pointer/).
- Lokasinya dicari dengan aturan alamat publikasi ([alamat publikasi dan daftar versi](/id/grammar/publishing/)).
- Jika LOCAL ID dokumen itu sama, targetnya sama, baik dipakai sebagai LOCAL di dalam dokumen itu, sebagai EXTERNAL-ISSUER di dokumen lain, maupun sebagai EXTERNAL-POINTER setelah IMPORT.
- Hanya menunjuk LOCAL dokumen. Dokumen itu sendiri ditunjuk dengan [DOC-POINTER](/id/grammar/reference/doc-pointer/), dan Issuer itu sendiri dengan [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/). Karena itu ID target bukan `0`. ID dokumen `0` adalah dokumen indeks definisi istilah Issuer.

## Validitas

- Jika lebar Issuer tidak sesuai dengan Codec, atau nilainya muat pada lebar yang lebih sempit, record invalid.
- Jika ID target `0`, record invalid. ID target `0` (dokumen itu sendiri) ditangani DOC-POINTER.
- WORD `0x0000` di depan ID target dilarang.

## Contoh

| Target | WORD sequence |
|---|---|
| Issuer `0x0001`, dokumen `0x…0002`, LOCAL 7 | `0360 0001 0000 0000 0000 0002 0007` |
| Issuer `0x00012345`, dokumen `0x…0002`, LOCAL 7 | `03E8 0001 2345 0000 0000 0000 0002 0007` |

## Halaman terkait

- [Reference](/id/grammar/reference/), [DOC-POINTER](/id/grammar/reference/doc-pointer/), [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/), [EXTERNAL-POINTER](/id/grammar/reference/external-pointer/)
- [Issuer dan publikasi](/id/grammar/issuer/)
