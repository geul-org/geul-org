---
title: "DELTA-REMOVE"
weight: 60
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "lineage"]
summary: "DELTA-REMOVE adalah Meta silsilah yang mencatat daftar LOCAL ID (Edge Id) yang harus dikeluarkan dari BODY snapshot dasar pada sebuah diff."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Pada diff ([DELTA-BASE](/id/grammar/meta/lineage/delta-base/)), mencatat LOCAL ID (Edge Id) dari record yang harus dikeluarkan dari BODY snapshot dasar (seperti "Pasal X dihapus").

## Layout

```
TAG WORD          0001 1LLL L011 1011      Codec 0x3B
[Length extension TAG]
LOCAL ID yang dihapus    record LOCAL Reference × 1 atau lebih
```

- Codec: Meta `0x3B`, kelas silsilah (`011`)
- Payload: satu atau lebih record [LOCAL](/id/grammar/reference/local/) Reference
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Hanya ditaruh pada dokumen yang memiliki `DELTA-BASE`.
- Setiap LOCAL ID harus berupa Edge Id yang ada di BODY snapshot dasar. Jika tidak ada, invalid. Menaruh ID yang sama dua kali juga invalid.
- Menaruh kembali Edge Id yang sama di BODY diff yang sama adalah invalid (penghapusan dan revisi tidak dapat dilakukan bersamaan).
- LOCAL ID yang sudah dihapus tidak dialokasikan ulang ke objek lain pada versi berikutnya ([revisi](/id/grammar/document/#revisi)).
- Tidak adanya record di BODY diff berarti "tidak berubah". Karena itu penghapusan hanya dinyatakan dengan Meta ini.
- Edge HEAD ([SOURCE](/id/grammar/edge/source/#sumber-seluruh-dokumen) untuk seluruh dokumen beserta QUALIFIER-nya) tidak ditulis. HEAD diganti seluruhnya oleh HEAD diff ([penyimpanan diff](/id/grammar/document/#penyimpanan-diff)).

## Contoh

Menghapus LOCAL `#7` dan `#12`:

```
1A3B 0088 0007 0088 000C
```

- TAG `1A3B` (Meta `0x3B`, `LLLL=0100`, 5 WORD), LOCAL Reference `0088 0007`, `0088 000C`.
