---
title: "DELTA-BASE"
weight: 59
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-BASE adalah Meta silsilah yang menandai bahwa file versi ini adalah diff terhadap versi dasar dari dokumen yang sama."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Penanda bahwa file versi ini bukan snapshot, melainkan **diff** terhadap versi dasar dari dokumen yang sama (delta pada git packfile). Versi itu sendiri tetap didefinisikan sebagai snapshot. Hash isi, daftar versi, dan tanda tangan semuanya mengacu pada snapshot yang dipulihkan dengan menerapkan diff ([penyimpanan diff](/id/grammar/document/#penyimpanan-diff)).

## Layout

```
TAG WORD          0001 1LLL L011 1010      Codec 0x3A
ID versi          2 WORD unsigned (versi dasar dari dokumen yang sama)
```

- Codec: Meta `0x3A`, kelas silsilah (`011`)
- Payload: ID versi 2 WORD (nilai mentah)
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Hanya dipakai pada dokumen yang memiliki [DOC-ID](/id/grammar/meta/declaration/doc-id/) (dokumen yang mengelola versi dengan daftar versi). `versions.geul`, `documents.geul`, `issuers.geul` yang tidak mengelola versi, serta dokumen tanpa nama, tidak memakai diff.
- Versi dasar adalah versi terbit dari `DOC-ID` yang sama dan lebih awal daripada versi ini. `0` (tanpa versi) invalid.
- Hash isi snapshot hasil pemulihan harus sama dengan hash versi ini pada daftar versi ([PUBLICATION](/id/grammar/edge/publication/)). Jika berbeda, diff ini invalid. Karena itu hash hasil tidak ditulis terpisah di dalam diff.
- Hanya dokumen yang semua record BODY-nya adalah Edge (record yang memiliki Edge Id) yang boleh disimpan sebagai diff, karena satuan diff adalah LOCAL ID (Edge Id).
- Aturan pemulihan snapshot mengikuti [penyimpanan diff](/id/grammar/document/#penyimpanan-diff). Penghapusan ditangani [DELTA-REMOVE](/id/grammar/meta/lineage/delta-remove/).
- Tidak ada penanda terpisah untuk penambahan atau revisi. Jika Edge Id pada BODY diff sudah ada di versi dasar, itu revisi; jika belum ada, itu penambahan. Penambahan menerima nomor mulai dari [NEXT-LOCAL-ID](/id/grammar/meta/lineage/next-local-id/) pada daftar versi. Memakai ulang LOCAL ID yang sudah dihapus adalah invalid ([revisi](/id/grammar/document/#revisi)).

## Contoh

Diff terhadap versi dasar 3:

```
193A 0000 0003
```

- TAG `193A` (Meta `0x3A`, `LLLL=0010`, 3 WORD), ID versi `0000 0003`.

## Masalah terbuka

1. Interval snapshot: setiap berapa versi snapshot penuh ditaruh (panjang rantai diff dan biaya pemulihan).
2. Apakah versi dasar dibatasi hanya versi tepat sebelumnya.
3. Lokasi penyimpanan file diff: apakah di tempat file versi (`<ID versi>.geul`), dan hubungannya dengan penyimpanan beralamat isi `h/` (`h/` dicari dengan hash isi snapshot).
