---
title: "RECORDED-AT"
weight: 38
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "RECORDED-AT adalah Meta asal-usul yang mencatat waktu perekaman sebagai dokumen dalam Value TIME (git commit date)."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat waktu perekaman sebagai dokumen (git commit date).

## Layout

```
TAG WORD          0001 1LLL L010 0101      Codec 0x25
[Length extension TAG]
Payload           satu Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, dll.)
```

- Codec: Meta `0x25`, kelas asal-usul (`010`)
- Payload: Value tersemat (keluarga TIME: [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/id/grammar/value/time/posix-timestamp-seconds/), dll.)
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Formatnya dipilih dari Value keluarga TIME. Jika diperlukan presisi, pakai format nanodetik yang didefinisikan Issuer (misalnya [POSIX-TIMESTAMP-NANOSECONDS](/id/grammar/value/time/posix-timestamp-nanoseconds/)).
- Dokumen daftar versi ([PUBLICATION](/id/grammar/edge/publication/)) memakai nilai ini sebagai waktu publikasi, deprecate, dan penghapusan.

## Masalah terbuka

- Meta asal-usul masuk ke hash isi. Apakah diizinkan bahwa isi yang sama yang direkam pada waktu berbeda menghasilkan hash berbeda.
