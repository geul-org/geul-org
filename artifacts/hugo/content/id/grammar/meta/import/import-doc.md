---
title: "IMPORT-DOC"
weight: 97
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "import"]
summary: "IMPORT-DOC adalah Meta IMPORT yang menunjuk dokumen eksternal dengan DOC-POINTER dan mengalokasikan IMPORT ID."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mengimpor dokumen eksternal dengan IMPORT ID. Dokumen yang diimpor ditunjuk oleh [DOC-POINTER](/id/grammar/reference/doc-pointer/), dan lebar Issuer juga dimuat oleh DOC-POINTER.

## Layout

```
TAG WORD          0001 1LLL L110 0000      Codec 0x60
[Length extension TAG]
Dokumen           record Reference DOC-POINTER (Issuer, ID dokumen, ID versi. Versi 0 berarti terbaru)
IMPORT ID         seluruh sisanya. Unsigned dengan lebar terpendek
```

- Codec: Meta `0x60`, kelas IMPORT (`110`)
- Payload: Reference tersemat `DOC-POINTER` (Issuer, ID dokumen, ID versi) + nilai mentah IMPORT ID
- Jumlah: boleh lebih dari satu (satu untuk setiap IMPORT ID)

## Interpretasi dan validitas

- Dokumen adalah tepat satu record DOC-POINTER. Record itu berakhir dengan Length-nya sendiri, dan sisanya adalah IMPORT ID.
- IMPORT ID berukuran minimal 1 WORD dengan lebar terpendek. Lebar IMPORT ID di sini ditentukan oleh panjang record, dan pada [EXTERNAL-POINTER-*](/id/grammar/reference/external-pointer/) ditentukan oleh Codec. IMPORT ID hanya berlaku di dalam dokumen itu.
- IMPORT ID yang sama tidak dialokasikan dua kali dalam satu dokumen.
- Jika ID versi ditulis, terikat pada edisi itu; jika `0`, terikat pada edisi terbaru (atau edisi yang berlaku pada titik waktu yang ditentukan) pada saat interpretasi ([revisi](/id/grammar/document/#revisi)).
- [EXTERNAL-POINTER-*](/id/grammar/reference/external-pointer/) di BODY menunjuk LOCAL dari dokumen yang diimpor dengan IMPORT ID. Dokumen yang diimpor sendiri ditunjuk dengan DOC-POINTER.
- HEAD dokumen yang diimpor tidak ikut diimpor. Target dokumen itu diinterpretasikan menurut deklarasi dokumen itu.
- Dengan IMPORT ID, pencarian lintas dokumen tidak dapat dilakukan. Repositori yang memuat banyak dokumen menyimpan IMPORT ID dengan menguraikannya menjadi jalur lengkap (Issuer, ID dokumen, ID versi, LOCAL ID).

## Contoh

- IMPORT ID 1, Issuer `0x0001`, dokumen `0x…0002`, terbaru: `1CE0 03B8 0001 0000 0000 0000 0002 0000 0000 0001` (TAG Meta 1 + DOC-POINTER 8 + IMPORT ID 1 = 10 WORD)
