---
title: "EFFECTIVE-FROM"
weight: 20
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-FROM adalah Meta definisi yang menyatakan tanggal berlaku versi ini sebagai Value tanggal atau timestamp."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Menyatakan tanggal berlaku versi ini. Tanggal berlaku berbeda dari waktu publikasi ([revisi](/id/grammar/document/#revisi)).

## Layout

```
TAG WORD          0001 1LLL L001 0011      Codec 0x13
[Length extension TAG]
Payload           satu Value TIME
```

- Codec: Meta `0x13`, kelas definisi (`001`)
- Payload: Value tersemat ([GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/) atau [POSIX-TIMESTAMP-SECONDS](/id/grammar/value/time/posix-timestamp-seconds/))
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Jika tidak ada, berlaku sejak waktu publikasi.
- Jika ada [EFFECTIVE-UNTIL](/id/grammar/meta/declaration/effective-until/), nilai ini harus lebih awal darinya.
- Jika tanggal berlaku berbeda untuk tiap pasal, tulis terpisah pada Edge pasal itu dengan QUALIFIER P580 (mulai) dan P582 (akhir) ([SOURCE](/id/grammar/edge/source/#ungkapan-dasar-lain)).
- Nilai ini dibaca saat dokumen diinterpretasikan pada titik waktu tertentu.

## Contoh

- Berlaku 1970-01-02: `0x1993 0x0920 0x0000 0x0001`
