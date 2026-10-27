---
title: "MODIFIED-AT"
weight: 36
date: 2026-10-27T12:00:00+09:00
lastmod: 2026-10-27T12:00:00+09:00
tags: ["grammar", "meta", "provenance"]
summary: "MODIFIED-AT adalah Meta asal-usul yang mencatat waktu modifikasi dokumen sebagai Value TIME."
author: "Junwoo Park"
authorLink: "https://parkjunwoo.com/about"
image: "/images/og-default.webp"
---

Mencatat waktu dokumen dimodifikasi.

## Layout

```
TAG WORD          0001 1LLL L010 0011      Codec 0x23
[Length extension TAG]
Payload           satu Value TIME (GREGORIAN-DATE, POSIX-TIMESTAMP-SECONDS, dll.)
```

- Codec: Meta `0x23`, kelas asal-usul (`010`)
- Payload: Value tersemat (keluarga TIME: [GREGORIAN-DATE](/id/grammar/value/time/gregorian-date/), [POSIX-TIMESTAMP-SECONDS](/id/grammar/value/time/posix-timestamp-seconds/), dll.)
- Jumlah: paling banyak satu

## Interpretasi dan validitas

- Formatnya dipilih dari Value keluarga TIME. Jika diperlukan presisi, pakai format nanodetik yang didefinisikan Issuer (misalnya [POSIX-TIMESTAMP-NANOSECONDS](/id/grammar/value/time/posix-timestamp-nanoseconds/)).
