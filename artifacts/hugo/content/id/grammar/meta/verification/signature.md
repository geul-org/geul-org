---
title: "SIGNATURE"
weight: 66
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "verification"]
summary: "SIGNATURE adalah Meta verifikasi yang mencatat tanda tangan atas hash isi dokumen sebagai ID algoritma, penanda tangan, dan tanda tangan."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Tanda tangan atas hash isi dokumen (commit dan tag bertanda tangan pada git).

## Layout

```
TAG WORD          0001 1LLL L100 0001      Codec 0x41
[Length extension TAG]
ID algoritma      1 WORD (0x0001 = Ed25519)
Penanda tangan    record Reference ISSUER-POINTER (Issuer)
Tanda tangan      seluruh sisanya. Lebarnya ditentukan algoritma (Ed25519 32 WORD)
```

- Codec: Meta `0x41`, kelas verifikasi (`100`)
- Payload: ID algoritma (nilai mentah 1 WORD) + penanda tangan (Reference tersemat) + tanda tangan (nilai mentah, sisanya)
- Jumlah: boleh lebih dari satu

## Interpretasi dan validitas

- Yang ditandatangani adalah hash isi. BODY saja tidak ditandatangani ([tanda tangan](/id/grammar/issuer/#tanda-tangan)).
- Karena kelas verifikasi, dikeluarkan dari hash isi. Hash tetap sama walaupun tanda tangan ditambah.
- Verifikasi tidak berbunyi "jika ada tanda tangan, periksa", melainkan "harus ada tanda tangan dari kunci yang ditentukan".
- Dokumen daftar versi ditandatangani oleh pihak penerbit.
- Penanda tangan adalah [ISSUER-POINTER](/id/grammar/reference/issuer-pointer/) (Issuer) yang menunjuk Issuer itu sendiri. Karena itu record Reference berakhir dengan Length-nya sendiri, layout tetap satu walaupun lebar tanda tangan berbeda tiap algoritma ([DECLARE](/id/grammar/edge/declare/) field sisa).
- Jika jumlah WORD tanda tangan berbeda dari lebar yang ditentukan algoritma, invalid.

## Masalah terbuka

- Apakah waktu tanda tangan ikut ditandatangani.
