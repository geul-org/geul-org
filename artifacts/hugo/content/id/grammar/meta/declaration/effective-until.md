---
title: "EFFECTIVE-UNTIL"
weight: 21
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "declaration"]
summary: "EFFECTIVE-UNTIL adalah Meta definisi yang menyatakan akhir masa berlaku versi ini (berlaku terbatas) sebagai Value tanggal atau timestamp."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Menyatakan akhir masa berlaku versi ini (berlaku terbatas). Sejak waktu itu versi ini tidak lagi berlaku.

## Layout

```
TAG WORD          0001 1LLL L001 0100      Codec 0x14
[Length extension TAG]
Payload           satu Value TIME
```

- Codec: Meta `0x14`, kelas definisi (`001`)
- Payload: Value tersemat ([GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/) atau [POSIX-TIMESTAMP-SECONDS](/id/grammar/value/time/posix-timestamp-seconds/))
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Jika tidak ada, tetap berlaku sampai versi berikutnya berlaku.
- Setelah masa berlaku lewat, tidak ada edisi yang berlaku. Edisi lama tidak hidup kembali.
